use crate::{
    eth::backend::db::{
        Db, MaybeHashDatabase, SerializableAccountRecord, SerializableState, StateDb,
    },
    revm::AccountInfo,
    Address, U256,
};
use ethers::prelude::H256;
use forge::{
    revm::{Bytecode, Database, KECCAK_EMPTY}, executor::DatabaseRef,
};
pub use foundry_evm::executor::fork::database::ForkedDatabase;
use foundry_evm::executor::{
    backend::{snapshot::StateSnapshot, DatabaseResult},
    fork::database::ForkDbSnapshot,
};
use tracing::trace;

/// Implement the helper for the fork database
impl Db for ForkedDatabase {
    fn insert_account(&mut self, address: Address, account: AccountInfo) {
        self.database_mut().insert_account(address, account)
    }

    fn set_storage_at(&mut self, address: Address, slot: U256, val: U256) -> DatabaseResult<()> {
        // this ensures the account is loaded first
        let _ = Database::basic(self, address)?;
        self.database_mut().set_storage_at(address, slot, val)
    }

    fn insert_block_hash(&mut self, number: U256, hash: H256) {
        self.inner().block_hashes().write().insert(number, hash);
    }

    fn dump_state(&self) -> DatabaseResult<Option<SerializableState>> {
        // TODO: Maybe we want to dump the remote state also; just in case; would be for perf; in case the caching strategy fails
        // Use CachedDb because is contains *OUR* changes *NOT* related to the remote and they are the ones we care about the most
        let accounts  = self
            .database()
            .accounts
            .clone()
            .into_iter()
            .map(|(k, v)| -> DatabaseResult<_> {
                let code = v
                    .info
                    .code
                    .unwrap_or_else(|| {
                        self.database().db.code_by_hash(v.info.code_hash).unwrap_or_default()
                    })
                    .to_checked();

                Ok((
                    k,
                    SerializableAccountRecord {
                        nonce: v.info.nonce,
                        balance: v.info.balance,
                        code: code.bytes()[..code.len()].to_vec().into(),
                        storage: v.storage.into_iter().collect(),
                    },
                ))
            })
            .collect::<Result<_, _>>()?;


        Ok(Some(SerializableState { accounts }))
    }

    fn load_state(&mut self, state: SerializableState) -> DatabaseResult<bool> {
        for (address, account) in state.accounts.into_iter() {
            let old_account_nonce =
                self.inner().accounts().read().get(&address).map(|a| a.nonce).unwrap_or_default();
            // use max nonce in case account is imported multiple times with difference
            // nonces to prevent collisions
            let nonce = std::cmp::max(old_account_nonce, account.nonce);
            trace!(target: "fork_db", "Inserting account: {:?}\n Data: {:#?}", address, account);
            self.insert_account(
                address,
                AccountInfo {
                    balance: account.balance,
                    code_hash: KECCAK_EMPTY,
                    nonce,
                    code: if account.code.0.is_empty() {
                        None
                    } else {
                        Some(Bytecode::new_raw(account.code.0).to_checked())
                    },
                },
            );

            for (slot, val) in account.storage {
                self.set_storage_at(address, slot, val)?;
            }
        }
        Ok(true)
    }

    fn snapshot(&mut self) -> U256 {
        self.insert_snapshot()
    }

    fn revert(&mut self, id: U256) -> bool {
        self.revert_snapshot(id)
    }

    fn current_state(&self) -> StateDb {
        StateDb::new(self.create_snapshot())
    }
}

impl MaybeHashDatabase for ForkedDatabase {
    fn clear_into_snapshot(&mut self) -> StateSnapshot {
        let db = self.inner().db();
        let accounts = std::mem::take(&mut *db.accounts.write());
        let storage = std::mem::take(&mut *db.storage.write());
        let block_hashes = std::mem::take(&mut *db.block_hashes.write());
        StateSnapshot { accounts, storage, block_hashes }
    }

    fn clear(&mut self) {
        self.flush_cache();
        self.clear_into_snapshot();
    }

    fn init_from_snapshot(&mut self, snapshot: StateSnapshot) {
        let db = self.inner().db();
        let StateSnapshot { accounts, storage, block_hashes } = snapshot;
        *db.accounts.write() = accounts;
        *db.storage.write() = storage;
        *db.block_hashes.write() = block_hashes;
    }
}
impl MaybeHashDatabase for ForkDbSnapshot {
    fn clear_into_snapshot(&mut self) -> StateSnapshot {
        std::mem::take(&mut self.snapshot)
    }

    fn clear(&mut self) {
        std::mem::take(&mut self.snapshot);
        self.local.clear()
    }

    fn init_from_snapshot(&mut self, snapshot: StateSnapshot) {
        self.snapshot = snapshot;
    }
}

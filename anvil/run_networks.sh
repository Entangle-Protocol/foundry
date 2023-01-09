
# optimism
anvil  --host "${OUTGOING_IP}" --port '8591' --accounts 3 --balance 1000000000 --block-time 10 --mnemonic "${MNEMONIC}" --fork-url 'https://op.getblock.io/d025d1f8-a350-4197-88ff-6432e52fc034/mainnet/' --gas-price 100000

# bsc
anvil  --host "${OUTGOING_IP}" --port '8592' --accounts 3 --balance 1000000000 --block-time 10 --mnemonic "${MNEMONIC}" --fork-url 'https://bsc.getblock.io/094313a6-cbce-4df0-a835-2326697662cf/mainnet/' --gas-price 100000

# avalanche
anvil  --host "${OUTGOING_IP}" --port '8593' --accounts 3 --balance 1000000000 --block-time 10 --mnemonic "${MNEMONIC}" --fork-url 'https://avax.getblock.io/mainnet/126012a1-9cf6-4c9c-8007-650d8e25d5c5/ext/bc/C/rpc' --gas-price 100000

# arbitrum
anvil  --host "${OUTGOING_IP}" --port '8594' --accounts 3 --balance 1000000000 --block-time 10 --mnemonic "${MNEMONIC}" --fork-url 'https://arb.getblock.io/e7f30447-6684-4d07-87e0-ee392fee862c/mainnet/' --gas-price 100000

# fantom
anvil  --host "${OUTGOING_IP}" --port '8595' --accounts 3 --balance 1000000000 --block-time 10 --mnemonic "${MNEMONIC}" --fork-url 'https://ftm.getblock.io/086f3fe0-6268-4d76-8521-ea289cc09fd5/mainnet/' --gas-price 100000

# polygon
anvil  --host "${OUTGOING_IP}" --port '8596' --accounts 3 --balance 1000000000 --block-time 10 --mnemonic "${MNEMONIC}" --fork-url 'https://matic.getblock.io/01bf3536-694c-4c7c-945c-9c6e7e47abf2/mainnet/' --gas-price 100000

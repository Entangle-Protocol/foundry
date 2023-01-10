#!/usr/bin/env bash

MNEMONIC=$(cat .secret)

# should be host external address
IP_ADDRESS='127.0.0.1'

case $1 in
    "teth")
        # ethereum
        anvil  --host "${IP_ADDRESS}" --port '8590' --accounts 3 --balance 1000000000000 --block-time 10 --mnemonic "${MNEMONIC}" --fork-url 'https://tame-solemn-surf.quiknode.pro/54c2bb653513d229c7bcdc195f3db78f2e3beae8/' --gas-price 100000 > ./eth_log.log &
        ;;
    "tbsc")
        # bsc
        anvil  --host "${IP_ADDRESS}" --port '8591' --accounts 3 --balance 1000000000000 --block-time 10 --mnemonic "${MNEMONIC}" --fork-url 'https://holy-powerful-model.bsc.discover.quiknode.pro/13afa7fc2c4c3b92c1d6857617ab288a1ee4d821/' --gas-price 100000 > ./bsc_log.log &
        ;;
    "topt")
        # optimism
        anvil  --host "${IP_ADDRESS}" --port '8592' --accounts 3 --balance 1000000000000 --block-time 10 --mnemonic "${MNEMONIC}" --fork-url 'https://holy-fabled-meme.optimism.quiknode.pro/9c28139d84f33e248177c64a8cb20d27121d91d6/' --gas-price 100000 > ./opt_log.log &
        ;;
    "tavax")
        # avalanche
        anvil  --host "${IP_ADDRESS}" --port '8593' --accounts 3 --balance 1000000000000 --block-time 10 --mnemonic "${MNEMONIC}" --fork-url 'https://tiniest-purple-liquid.avalanche-mainnet.quiknode.pro/5e352b72065b22ca04b9d1b5d8f739546110a77a/ext/bc/C/rpc' --gas-price 100000 > ./avax_log.log &
        ;;
    "tarb")
        # arbitrum
        anvil  --host "${IP_ADDRESS}" --port '8594' --accounts 3 --balance 1000000000000 --block-time 10 --mnemonic "${MNEMONIC}" --fork-url 'https://lingering-practical-theorem.arbitrum-mainnet.quiknode.pro/b45639b0be2a7a149c4ef67053d51e60db6cf4bc/' --gas-price 100000 > ./arb_log.log &
        ;;
    "tftm")
        # fantom
        anvil  --host "${IP_ADDRESS}" --port '8595' --accounts 3 --balance 1000000000000 --block-time 10 --mnemonic "${MNEMONIC}" --fork-url 'https://boldest-neat-model.fantom.quiknode.pro/46694b4ef14795ac05e7c983478d427e35b49fc2/' --gas-price 100000 > ./ftm_log.log &
        ;;
    "tmat")
        # polygon
        anvil  --host "${IP_ADDRESS}" --port '8596' --accounts 3 --balance 1000000000000 --block-time 10 --mnemonic "${MNEMONIC}" --fork-url 'https://powerful-summer-sanctuary.matic.quiknode.pro/2a89d5b192315c49cdbbd6ed4f48c55dc317acfb/' --gas-price 100000 > ./mat_log.log &
        ;;
esac
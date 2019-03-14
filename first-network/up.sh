#!/bin/bash

# #Generate certificates
# cryptogen generate --config=crypto-config.yaml

# export FABRIC_CFG_PATH=$PWD

# #Create Channel Artifacts
# #Genesis Block
# configtxgen -profile TwoOrgsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block

# #Channel.tx
# export CHANNEL_NAME=mychannel && configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME

# #Org1AnchorPeer.tx
# export CHANNEL_NAME=mychannel && configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/org1MSPanchors.tx -asOrg org1MSP -channelID $CHANNEL_NAME

# #Org2AnchorPeer.tx
# export CHANNEL_NAME=mychannel && configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/org2MSPanchors.tx -asOrg org2MSP -channelID $CHANNEL_NAME

#Network Up
docker-compose -f ./docker-compose-cli.yaml up

# docker exec -it cli bash



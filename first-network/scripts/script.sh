#!/bin/bash

#Create and join channel
export CHANNEL_NAME=mychannel

# the channel.tx file is mounted in the channel-artifacts directory within your CLI container
# as a result, we pass the full path for the file
# we also pass the path for the orderer ca-cert in order to verify the TLS handshake
# be sure to export or replace the $CHANNEL_NAME variable appropriately
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.com/users/Admin@org1.com/msp
export CORE_PEER_ADDRESS=peer0.org1.com:7051
export CORE_PEER_LOCALMSPID="org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.com/peers/peer0.org1.com/tls/ca.crt

peer channel create -o orderer0.orderer.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/orderer.com/orderers/orderer0.orderer.com/msp/tlscacerts/tlsca.orderer.com-cert.pem

#Join peer to channel for peer0 org1 #############################################
# ################################################################################
peer channel join -b mychannel.block
#Install chaincode
peer chaincode install -l node -n my_chaincode -v 1.0 -p /opt/gopath/src/github.com/chaincode/fabcar/javascript

#Update channel for Anchor peer
peer channel update -o orderer0.orderer.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/org1MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/orderer.com/orderers/orderer0.orderer.com/msp/tlscacerts/tlsca.orderer.com-cert.pem

#Set Environment Variables for peer1 org1 ##########################################
# ################################################################################
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.com/users/Admin@org1.com/msp 
export CORE_PEER_ADDRESS=peer1.org1.com:7051 
export CORE_PEER_LOCALMSPID="org1MSP" 
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.com/peers/peer1.org1.com/tls/ca.crt 

peer channel join -b mychannel.block
#Install chaincode
peer chaincode install -l node -n my_chaincode -v 1.0 -p /opt/gopath/src/github.com/chaincode/fabcar/javascript


#Set Environment Variables for peer0 org2 ########################################
# ################################################################################
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.com/users/Admin@org2.com/msp 
export CORE_PEER_ADDRESS=peer0.org2.com:7051 
export CORE_PEER_LOCALMSPID="org2MSP" 
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.com/peers/peer0.org2.com/tls/ca.crt 

peer channel join -b mychannel.block
#Install chaincode
peer chaincode install -l node -n my_chaincode -v 1.0 -p /opt/gopath/src/github.com/chaincode/fabcar/javascript


#Update channel for Anchor peer
peer channel update -o orderer0.orderer.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/org2MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/orderer.com/orderers/orderer0.orderer.com/msp/tlscacerts/tlsca.orderer.com-cert.pem


#Set Environment Variables for peer1 org2 ########################################
# ################################################################################
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.com/users/Admin@org2.com/msp 
CORE_PEER_ADDRESS=peer1.org2.com:7051 
CORE_PEER_LOCALMSPID="org2MSP" 
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.com/peers/peer1.org2.com/tls/ca.crt 

peer channel join -b mychannel.block

#Install chaincode
peer chaincode install -l node -n my_chaincode -v 1.0 -p /opt/gopath/src/github.com/chaincode/fabcar/javascript

# peer chaincode instantiate -o orderer0.orderer.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/orderer.com/orderers/orderer0.orderer.com/msp/tlscacerts/tlsca.orderer.com-cert.pem -l node -C mychannel -n my_chaincode -v 1.0 -c '{"Args":[]}' -P "AND ('org1MSP.peer','org2MSP.peer')"

# peer chaincode invoke -o orderer0.orderer.com:7050 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/orderer.com/orderers/orderer0.orderer.com/msp/tlscacerts/tlsca.orderer.com-cert.pem -C mychannel -n my_chaincode --peerAddresses peer0.org1.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.com/peers/peer0.org1.com/tls/ca.crt --peerAddresses peer0.org2.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.com/peers/peer0.org2.com/tls/ca.crt -c '{"function":"initLedger","Args":[]}'
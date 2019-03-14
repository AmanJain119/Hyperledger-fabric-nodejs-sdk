## Hyperledger Fabric Client SDK for Node.js with Hyperledger Fabric Sample v1.4

The Hyperledger Fabric SDK for Node.js provides a powerful API to interact with a Hyperledger Fabric blockchain. The SDK is designed to be used in the Node.js JavaScript runtime.

### About netwok we have used

In our sample network there are three organizations and their namespace.

(Organization) Orderer, orderer.com
Organization 1 (Org1), org1.com
Organization 2 (Org2), org2.com

At the node level, there is one node in Orderer. In Org1 and Org2, there are two peers in each organization. there is one node for CA in Org1. The two peers are labeled as peer0 and peer1. Therefore in the First Network there are totally six nodes.

orderer0.orderer.com
ca.org1.com
peer0.org1.com
peer1.org1.com
peer0.org2.com
peer1.org2.com

Peer0 in Org1 and Org2 are designated as the Anchor Peer.

Note: We have Enabled TLS to secure network

### Prerequisites

Refer following link to install prerequisites:- [https://hyperledger-fabric.readthedocs.io/en/release-1.4/prereqs.html](https://hyperledger-fabric.readthedocs.io/en/release-1.4/prereqs.html)


### Setup Network

Clone the repo

The first thing we need to do is clone the repo on your local computer.

```
$ git clone https://github.com/AmanJain119/Hyperledger-fabric-nodejs-sdk.git
```

Then, go ahead and go into the directory:

```
$ cd first-network
```

```
$ sh up.sh
```

Now, go to cli container to setup channel and chaincode:

```
$ docker exec -it cli bash
```

```
$ sh scripts/script.sh
```

Above commands setup network and installed fabcar nodejs chaincode on all running peer in network.

### Setup Node.js SDK

To setup Node.js sdk we have created `connection.json` config file in `first-network` directory like below:-

```
{
    "name": "Network",
    "version": "1.0.0",
    "client": {
        "organization": "org1",
        "credentialStore": {
            "path": "./wallet",
            "cryptoStore": {
              "path": "./wallet"
            }
          }
    },
    ...
    ...
```

Now, go into the directory `fabcar-sdk/javascript` from root of this repo:

```
$ cd fabcar-sdk/javascript
```

```
$ npm install
```

```
$ node enrollAdmin.js
```

```
$ node registerUser.js
```

```
$ node index.js
```

Now Network and Node.js sdk setup is completed.

You can import the fabcar.postman_collection.json in root directory of repo into your postman to test API's.
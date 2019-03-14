/*
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const { FileSystemWallet, Gateway } = require('fabric-network');
const fs = require('fs');
const path = require('path');
const ccpPath = path.resolve(__dirname, '..', '..', 'first-network', 'connection.json');
const ccpJSON = fs.readFileSync(ccpPath, 'utf8');
const ccp = JSON.parse(ccpJSON);
const config = require('./config');
const restify = require('restify');
const restifyPlugins = require('restify-plugins');

/**
 * Initialize Server
 */
const server = restify.createServer({
    name: config.name,
    version: config.version,
});

/**
 * Middleware
 */
server.use(restifyPlugins.jsonBodyParser({ mapParams: true }));
server.use(restifyPlugins.acceptParser(server.acceptable));
server.use(restifyPlugins.queryParser({ mapParams: true }));
server.use(restifyPlugins.fullResponse());


/**
 * Routes
 */
server.get('/car/:id', handleGetCar);
server.get('/car', handleGetAllCar);

server.post({ path: '/car' }, function (req, res, next) {
    console.log(req.body);
    
    handleCreateCar(req.body.id, req.body.make, req.body.model, req.body.colour, req.body.owner).then((result) => {
        console.log('Issue program complete.');
        res.contentType = 'json';
        let proResult =
        {
           "message":"Car added successfully"
        }
        return res.send(proResult);
    }).catch((e) => {

        console.log('Issue program exception.');
        console.log(e);
        console.log(e.stack);
        process.exit(-1);
        return res.send('error handleRegisterCar');
    });

});

/**
 * Processing Functions
 */

//getCar -----------------
function handleGetCar(req, res, next) {
    var Id = req.query.Id;
    if (typeof Id == 'undefined') {
        Id = req.params.id
    }

    // console.log('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!REquest id =' + req.params.id);
    handleGetTheCar(Id).then((result) => {
        let theResult = JSON.parse(result);
        console.log('Issue program complete.' + result);
        res.contentType = 'json';
        let proResult =
        {
            "exists": !(result == null),
            "data": theResult
        }
        return res.send(proResult);
    }).catch((e) => {

        console.log('Issue program exception.');
        console.log(e);
        console.log(e.stack);
        process.exit(-1);
    });

}

async function handleGetTheCar(Id) {
    try {

        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = new FileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

        // Check to see if we've already enrolled the user.
        const userExists = await wallet.exists('user1');
        if (!userExists) {
            console.log('An identity for the user "user1" does not exist in the wallet');
            console.log('Run the registerUser.js application before retrying');
            return;
        }

        // Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'user1', discovery: { enabled: false } });

        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('mychannel');

        // Get the contract from the network.
        const contract = network.getContract('my_chaincode');

        // Evaluate the specified transaction.
        // queryCar transaction - requires 1 argument, ex: ('queryCar', 'CAR4')
        // queryAllCars transaction - requires no arguments, ex: ('queryAllCars')
        const result = await contract.evaluateTransaction('queryCar', Id);
        console.log(`Transaction has been evaluated, result is: ${result.toString()}`);
        let prossedRes = result.toString();
        let theResult = JSON.parse (prossedRes);
        return theResult;

    } catch (error) {
        console.error(`Failed to evaluate transaction: ${error}`);
        return null;
        //process.exit(1);
    }
}

async function handleGetAllCar(req, res, next) {
    try {

        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = new FileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

        // Check to see if we've already enrolled the user.
        const userExists = await wallet.exists('user1');
        if (!userExists) {
            console.log('An identity for the user "user1" does not exist in the wallet');
            console.log('Run the registerUser.js application before retrying');
            return;
        }

        // Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'user1', discovery: { enabled: false } });

        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('mychannel');

        // Get the contract from the network.
        const contract = network.getContract('my_chaincode');

        // Evaluate the specified transaction.
        // queryCar transaction - requires 1 argument, ex: ('queryCar', 'CAR4')
        // queryAllCars transaction - requires no arguments, ex: ('queryAllCars')
        const result = await contract.evaluateTransaction('queryAllCars');
        console.log(`Transaction has been evaluated, result is: ${result.toString()}`);
        let prossedRes = result.toString();
        let theResult = JSON.parse (prossedRes);

        console.log('Issue program complete.' + result);
        res.contentType = 'json';
        let proResult =
        {
            "exists": !(result == null),
            "data": theResult
        }
        return res.send(proResult);
    } catch (error) {
        console.error(`Failed to evaluate transaction: ${error}`);
        return null;
        //process.exit(1);
    }
}

//-------------registerCar
async function handleCreateCar(id, make, model, colour, owner) {
    try {

        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = new FileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

        // Check to see if we've already enrolled the user.
        const userExists = await wallet.exists('user1');
        if (!userExists) {
            console.log('An identity for the user "user1" does not exist in the wallet');
            console.log('Run the registerUser.js application before retrying');
            return;
        }

        // Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'user1', discovery: { enabled: false } });

        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('mychannel');

        // Get the contract from the network.
        const contract = network.getContract('my_chaincode');

        // Submit the specified transaction.

        //ctx, carNum,$class, carId, carType, value, metadata
        const result = await contract.submitTransaction('createCar', id, make, model, colour, owner);
        console.log('Transaction has been submitted');

        // Disconnect from the gateway.
        await gateway.disconnect();

        return;
    } catch (error) {
        console.error(`Failed to submit transaction: ${error}`);

        process.exit(1);
    }
}

server.listen(config.port, () => { 
    console.log("Server is running on "+ config.port)
});


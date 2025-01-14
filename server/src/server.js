const WebSocket = require('ws');
const DatabaseHelper = require('./connect_db');
const format = require('pg-format');

class WSServer {
    constructor(port) {
        this.db = new DatabaseHelper();
        this.socket = new WebSocket.Server({ 
            host : '0.0.0.0',
            port: port,
            // verifyClient: (info, done) => {
            //     console.log('verifyClient');
            //     done(true);
            // }
        }); 

        this.socket.on('connection', (ws) => {
            console.log('Connection established');

            ws.on('message', async (message) => {
                console.log(`Received message => ${message}`);

                try {
                    const request = JSON.parse(message);

                    if (request.type === 'GET') {
                        const query = format('SELECT * FROM wine');
                        const result = await this.db.getData(
                            query,
                        );
                        // console.log('Data fetched');
                        // console.log(result);
                        ws.send(JSON.stringify({
                            message: 'Data fetched',
                            data: result['rows']
                        }));
                    } else if (request.type === 'POST') {
                        console.log('Requested data');
                        console.log(request.data);
                        // const query = format ('INSERT INTO wine (nameOfProducer, type, yearOfProduction, region, listOfIngredients, calories, photoURL) VALUES (%L, %L, %L, %L, %L, %L, %L) RETURNING id', request.data.nameOfProducer, request.data.type, request.data.yearOfProduction, request.data.region, request.data.listOfIngredients, request.data.calories, request.data.photoURL);
                        // const result = await this.db.postData(query);

                        const query = format ('INSERT INTO wine (nameOfProducer, type, yearOfProduction, region, listOfIngredients, calories, photoURL) VALUES (%L, %L, %L, %L, %L, %L, %L)', request.data.nameOfProducer, request.data.type, request.data.yearOfProduction, request.data.region, request.data.listOfIngredients, request.data.calories, request.data.photoURL);
                        const result = await this.db.postData(
                            query,
                            [request.data.nameOfProducer, request.data.type, request.data.yearOfProduction, request.data.region, request.data.listOfIngredients, request.data.calories, request.data.photoURL]
                        );

                        if (result.rowCount === 0) {
                            console.log('Data not inserted');
                        }

                        const query2 = format('SELECT * FROM wine WHERE nameOfProducer = %L AND type = %L AND yearOfProduction = %L AND region = %L AND listOfIngredients = %L AND calories = %L AND photoURL = %L LIMIT 1', request.data.nameOfProducer, request.data.type, request.data.yearOfProduction, request.data.region, request.data.listOfIngredients, request.data.calories, request.data.photoURL);
                        const result2 = await this.db.getData(
                            query2,
                            [request.data.nameOfProducer, request.data.type, request.data.yearOfProduction, request.data.region, request.data.listOfIngredients, request.data.calories, request.data.photoURL]
                        );

                        console.log('Find the new ID');
                        console.log(result2['rows'][0]['id']);
                        const newID = result2['rows'][0]['id'];

                        ws.send(JSON.stringify({
                                message: 'Data inserted',
                                data: { id: newID } 
                        }));
                    } else if (request.type === 'PUT') {
                        console.log(request.data);
                        const query = format('UPDATE wine SET nameOfProducer = %L, type = %L, yearOfProduction = %L, region = %L, listOfIngredients = %L, calories = %L, photoURL = %L WHERE id = %L', request.data.nameOfProducer, request.data.type, request.data.yearOfProduction, request.data.region, request.data.listOfIngredients, request.data.calories, request.data.photoURL, request.data.id);
                        const result = await this.db.putData(
                            query,
                            [request.data.nameOfProducer, request.data.type, request.data.yearOfProduction, request.data.region, request.data.listOfIngredients, request.data.calories, request.data.photoURL, request.data.id]
                        );
                        var ifExecuted;
                        if (result.rowCount === 0) {
                            ifExecuted = false;
                            console.log('Data not updated');
                        } else {
                            ifExecuted = true;
                        }
                        ws.send(JSON.stringify({
                            message: 'Data updated',
                            data: ifExecuted
                        }));
                    } else if (request.type === 'DELETE') {
                        const query = format('DELETE FROM wine WHERE id = %L', request.data.id);
                        console.log('Requested data');
                        console.log(request);
                        console.log(request.data);
                        console.log(request.data.id);
                        const result = await this.db.deleteData(
                            query,
                            [request.data.id]
                        );
                        var ifExecuted;

                        if (result.rowCount === 0) {
                            ifExecuted = false;
                            console.log('Data not deleted');
                        } else {
                            ifExecuted = true;
                        }
                        ws.send(JSON.stringify({
                            message: 'Data deleted',
                            data: ifExecuted
                        }));
                    } else if (request.type === 'GET_ONE') {
                        const result = await this.db.getOne(
                            'SELECT * FROM wine WHERE id = $1',
                            [request.data.id]
                        );
                        ws.send(JSON.stringify(result));
                    } else {
                        ws.send('Invalid request');
                        console.log('Invalid request');
                    }
                } catch (error) {
                    ws.send('Error processing request');
                    console.error('Error processing request', error.stack);
                }
            });
        });
    }
};

module.exports = WSServer;

// wss.on('open', () => {
//     console.log('WebSocket Server is open');

//     wss.send('Connectedto the WebSocket Server');

//     wss.on('message', async (message) => {
//         console.log(`Received message => ${message}`);

//         try {
//             const request = JSON.parse(message);

//             if (request.type === 'get') {
//                 const result = await 
//         }
//     });
// })
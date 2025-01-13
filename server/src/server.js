const WebSocket = require('ws');
const DatabaseHelper = require('./connect_db');
const format = require('pg-format');

class WSServer {
    constructor(port) {
        this.db = new DatabaseHelper();
        this.socket = new WebSocket.Server({ 
            port: port,
            verifyClient: (info, done) => {
                console.log('verifyClient');
                done(true);
            }
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
                        ws.send(JSON.stringify({
                            message: 'Data fetched',
                            data: result.rows
                        }));
                    } else if (request.type === 'POST') {
                        console.log(request.data);
                        const query = format ('INSERT INTO wine (nameOfProducer, type, yearOfProduction, region, listOfIngredients, calories, photoURL) VALUES (%L, %L, %L, %L, %L, %L, %L)', request.data.nameOfProducer, request.data.type, request.data.yearOfProduction, request.data.region, request.data.listOfIngredients, request.data.calories, request.data.photoURL);
                        await this.db.postData(
                            query,
                            [request.data.nameOfProducer, request.data.type, request.data.yearOfProduction, request.data.region, request.data.listOfIngredients, request.data.calories, request.data.photoURL]
                        );
                        ws.send(JSON.stringify({
                                message: 'Data inserted',
                                data: { id: result.rows[0].id }
                        }));
                    } else if (request.type === 'PUT') {
                        console.log(request.data);
                        const query = format('UPDATE wine SET nameOfProducer = %L, type = %L, yearOfProduction = %L, region = %L, listOfIngredients = %L, calories = %L, photoURL = %L WHERE id = %L', request.data.nameOfProducer, request.data.type, request.data.yearOfProduction, request.data.region, request.data.listOfIngredients, request.data.calories, request.data.photoURL, request.data.id);
                        await this.db.putData(
                            query,
                            [request.data.nameOfProducer, request.data.type, request.data.yearOfProduction, request.data.region, request.data.listOfIngredients, request.data.calories, request.data.photoURL, request.data.id]
                        );
                        ws.send(JSON.stringify({
                            message: 'Data updated',
                            data: request.data
                        }));
                    } else if (request.type === 'DELETE') {
                        const query = format('DELETE FROM wine WHERE id = %L', request.data.id);
                        await this.db.deleteData(
                            query,
                            [request.data.id]
                        );
                        ws.send(JSON.stringify({
                            message: 'Data deleted',
                            data: request.data
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
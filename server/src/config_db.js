const dotenv = require('dotenv');
dotenv.config();

const postgres = require('pg');

const config = {
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT,
};

const pool = new postgres.Pool(config);

module.exports = pool;
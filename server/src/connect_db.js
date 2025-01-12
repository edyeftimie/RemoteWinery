const pool = require('./config_db');

class DatabaseHelper {
    constructor() {
        this.pool = pool;
    }

    async getData(query) {
        const client = await this.pool.connect();
        try {
            const result = await client.query(query);
            return result.rows;
        } catch (error) {
            console.error('Error executing query', error.stack);
            throw error;
        } finally {
            client.release();
        }
    }

    async postData(query) {
        const client = await this.pool.connect();
        try {
            await client.query(query);
        } catch (error) {
            console.error('Error executing query', error.stack);
            throw error;
        } finally {
            client.release();
        }
    }

    async putData(query) {
        const client = await this.pool.connect();
        try {
            await client.query(query);
        } catch (error) {
            console.error('Error executing query', error.stack);
            throw error;
        } finally {
            client.release();
        }
    }

    async deleteData(query) {
        const client = await this.pool.connect();
        try {
            await client.query(query);
        } catch (error) {
            console.error('Error executing query', error.stack);
            throw error;
        } finally {
            client.release();
        }
    }

    async getOne(query) {
        const client = await this.pool.connect();
        try {
            const result = await client.query(query);
            return result.rows[0];
        } catch (error) {
            console.error('Error executing query', error.stack);
            throw error;
        } finally {
            client.release();
        }
    }
}

pool.connect((err, client, release) => {
    if (err) {
        return console.error('Error acquiring client', err.stack);
    }
    client.query('SELECT NOW()', (err, result) => {
        release();
        if (err) {
        return console.error('Error executing query', err.stack);
        }
        console.log(result.rows);
    });
});

module.exports = DatabaseHelper;
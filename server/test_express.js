const express = require('express');

const app = express();

app.get('/', (req, res) => {
    res.send('Hello you!');
    }
);

app.listen(3000, () => {
    console.log('Listening on http://localhost:3000');
    }
);
// run with `node server/test_express.js`
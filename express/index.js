import express from 'express';

const app = express();

app.use('/', express.static('public'));

app.get('/', (req, res) => {
  res.end('hi!');
});

console.log('starting server...');

app.listen(4321, () => {
  console.log('started server');
});


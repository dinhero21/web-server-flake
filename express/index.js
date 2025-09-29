import express from 'express';
import { createProxyMiddleware } from 'http-proxy-middleware';

const IS_PRODUCTION = process.env.NODE_ENV === 'production';

const app = express();

// #region api must come first to take precedence

app.get('/api', (req, res) => {
  res.json('now with express');
});

// #endregion

// #region fallback to astro

const astroMiddleware = IS_PRODUCTION
  ? express.static('public')
  : createProxyMiddleware({
    target: 'http://localhost:4321/',
  });

app.use('/', astroMiddleware);

// #endregion

console.log('starting server...');

const PORT = 5432;

app.listen(PORT, () => {
  console.log(`listening on http://localhost:${PORT}/`);
});


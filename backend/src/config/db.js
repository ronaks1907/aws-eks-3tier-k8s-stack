const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
  user: process.env.PGUSER,
  host: process.env.PGHOST,
  database: process.env.PGDATABASE,
  password: process.env.PGPASSWORD,
  port: process.env.PGPORT,
  ssl: {
    rejectUnauthorized: false,
  }
});

pool.connect()
  .then(client => {
    console.log('✅ Connected to PostgreSQL database successfully.');
    client.release();
  })
  .catch(err => {
    console.error('❌ Failed to connect to PostgreSQL database:', err.stack);
  });

module.exports = pool;

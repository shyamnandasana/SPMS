const { Client } = require('pg');
require('dotenv').config();

const client = new Client({
  connectionString: process.env.DATABASE_URL,
});

async function listTables() {
  try {
    await client.connect();
    console.log('Connected!');
    const res = await client.query(`
      SELECT table_name 
      FROM information_schema.tables 
      WHERE table_schema = 'public'
    `);
    console.log('Tables:', res.rows.map(r => r.table_name));
    
    for (const row of res.rows) {
      const countRes = await client.query(`SELECT COUNT(*) FROM "public"."${row.table_name}"`);
      console.log(`Table ${row.table_name} count: ${countRes.rows[0].count}`);
    }
    
    await client.end();
  } catch (err) {
    console.error('Error:', err);
  }
}

listTables();

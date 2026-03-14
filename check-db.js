const { PrismaClient } = require('@prisma/client');
const { Pool } = require('pg');
const { PrismaPg } = require('@prisma/adapter-pg');
require('dotenv').config();

const connectionString = process.env.DATABASE_URL;
const pool = new Pool({ connectionString });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

async function main() {
  try {
    const userCount = await prisma.user.count();
    console.log(`Connection successful! User count: ${userCount}`);
    
    const users = await prisma.user.findMany({ take: 5 });
    console.log('Sample users:', JSON.stringify(users, null, 2));

    const tables = ['User', 'Project', 'StudentProfile', 'FacultyProfile'];
    for (const table of tables) {
      const count = await prisma[table.charAt(0).toLowerCase() + table.slice(1)].count();
      console.log(`${table} count: ${count}`);
    }
  } catch (error) {
    console.error('Error connecting to database:', error);
  } finally {
    await prisma.$disconnect();
  }
}

main();

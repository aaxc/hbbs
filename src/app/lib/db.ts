import mariadb from "mariadb";

declare global {
  // eslint-disable-next-line no-var
  var dbPool: mariadb.Pool | undefined;
}

const pool =
  globalThis.dbPool ??
  mariadb.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    connectionLimit: 3,
    idleTimeout: 30,
  });

// In development, preserve the pool across HMR reloads so we don't
// create a new pool (and leak connections/event-listeners) on every edit.
if (process.env.NODE_ENV !== "production") {
  globalThis.dbPool = pool;
}

// Register the shutdown handler exactly once on the real process object.
// Using `process.once` instead of `process.on` guarantees a single listener
// even if this module were somehow evaluated more than once.
process.once("SIGINT", async () => {
  await pool.end();
  process.exit(0);
});

export default pool;


const sqlite3 = require("sqlite3").verbose();

const db = new sqlite3.Database("./shieldher.db", (err) => {
    if (err) {
        console.error(err.message);
    } else {
        console.log("Connected to SQLite Database");
    }
});

db.serialize(() => {
    db.run(`
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        )
    `);
});

module.exports = db;
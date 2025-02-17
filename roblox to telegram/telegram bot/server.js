const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const path = require('path');

const app = express();
const port = 1337;
const codeRegex = /^\d{4}-[А-ЯЁ]{4}$/;

app.use(express.json());

const dbPath = path.resolve(__dirname, 'libs', 'verification.db');
const db = new sqlite3.Database(dbPath, (err) => {
    if (err) {
        console.error('error opening database:', err.message);
        process.exit(1);
    } else {
        console.log('connected to SQLite database');
        db.run("PRAGMA journal_mode = WAL;", (err) => {
            if (err) {
                console.error('error setting WAL mode:', err.message);
            } else {
                console.log('WAL mode enabled');
            }
        });
    }
});

db.serialize(() => {
    db.run(`CREATE TABLE IF NOT EXISTS codes (
        accesscode TEXT PRIMARY KEY,
        robloxuserid INTEGER NOT NULL,
        timestamp INTEGER NOT NULL
    )`);

    db.run(`CREATE TABLE IF NOT EXISTS successful_verifications (
        robloxuserid INTEGER PRIMARY KEY,
        telegramid INTEGER NOT NULL
    )`);
});

function runWithRetry(stmt, params, retries = 5, delay = 100) {
    return new Promise((resolve, reject) => {
        function attempt(remaining) {
            stmt.run(params, function(err) {
                if (err) {
                    if (err.code === 'SQLITE_BUSY' && remaining > 0) {
                        setTimeout(() => attempt(remaining - 1), delay);
                    } else {
                        reject(err);
                    }
                } else {
                    resolve(this);
                }
            });
        }
        attempt(retries);
    });
}

app.post('/validate', (req, res) => {
    const { robloxuserid, accesscode, timestamp } = req.body;

    if (!robloxuserid || !accesscode || !timestamp) {
        return res.status(400).json({ error: 'missing parameters' });
    }

    if (!codeRegex.test(accesscode)) {
        return res.status(400).json({ error: 'invalid access code format' });
    }

    const stmt = db.prepare(`INSERT INTO codes (accesscode, robloxuserid, timestamp) VALUES (?, ?, ?)`);
    stmt.run(accesscode, robloxuserid, timestamp, function(err) {
        if (err) {
            console.error('error inserting code:', err.message);
            return res.status(500).json({ error: 'Internal server error' });
        }
        console.log(`code stored: ${accesscode} for user ${robloxuserid}`);
        res.json({ success: true });
    });
    stmt.finalize();
});

app.get('/validate', (req, res) => {
    const { accesscode } = req.query;

    if (!accesscode) {
        return res.status(403).json({ error: 'missing accesscode parameter' });
    }

    const stmt = db.prepare(`SELECT robloxuserid FROM codes WHERE accesscode = ?`);
    stmt.get(accesscode, (err, row) => {
        if (err) {
            console.error('error querying code:', err.message);
            return res.status(500).json({ error: 'internal server error' });
        }

        if (row) {
            res.json({ valid: true, robloxuserid: row.robloxuserid });
        } else {
            res.json({ valid: false });
        }
    });
    stmt.finalize();
});

app.delete('/validate', (req, res) => {
    const { accesscode } = req.query;

    if (!accesscode) {
        return res.status(403).json({ error: 'missing accesscode parameter' });
    }

    const stmt = db.prepare(`DELETE FROM codes WHERE accesscode = ?`);
    stmt.run(accesscode, function(err) {
        if (err) {
            console.error('error deleting code:', err.message);
            return res.status(500).json({ error: 'internal server error' });
        }

        if (this.changes > 0) {
            console.log(`code deleted: ${accesscode}`);
            res.json({ success: true });
        } else {
            res.json({ success: false, message: 'code not found' });
        }
    });
    stmt.finalize();
});

app.post('/successfulverifications', async (req, res) => {
    const { robloxuserid, telegramid } = req.body;

    if (!robloxuserid || !telegramid) {
        return res.status(400).json({ error: 'missing parameters' });
    }

    const stmt = db.prepare(`INSERT INTO successful_verifications (robloxuserid, telegramid) VALUES (?, ?)
                             ON CONFLICT(robloxuserid) DO UPDATE SET telegramid=excluded.telegramid`);

    try {
        await runWithRetry(stmt, [robloxuserid, telegramid]);
        console.log(`verification stored: RobloxUserID ${robloxuserid} with telegram ID ${telegramid}`);
        res.json({ success: true });
    } catch (err) {
        console.error('error inserting successful verification:', err.message);
        res.status(500).json({ error: 'internal server error' });
    } finally {
        stmt.finalize();
    }
});

app.get('/successfulverifications', (req, res) => {
    const { robloxuserid } = req.query;

    if (!robloxuserid) {
        return res.status(400).json({ error: 'missing robloxuserid parameter' });
    }

    const stmt = db.prepare(`SELECT telegramid FROM successful_verifications WHERE robloxuserid = ?`);
    stmt.get(robloxuserid, (err, row) => {
        if (err) {
            console.error('error querying successful verifications:', err.message);
            return res.status(500).json({ error: 'Internal server error' });
        }

        if (row) {
            res.json({ exists: true, telegramid: row.telegramid });
        } else {
            res.json({ exists: false });
        }
    });
    stmt.finalize();
});


app.listen(port, () => {
    console.log(`Server running on http://127.0.0.1:${port}`);
});

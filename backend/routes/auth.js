const express = require("express");
const router = express.Router();
const db = require("../database");

router.post("/register", (req, res) => {
    const { name, email, password } = req.body;

    if (!name || !email || !password) {
        return res.status(400).json({
            success: false,
            message: "All fields are required"
        });
    }

    const query =
        "INSERT INTO users (name, email, password) VALUES (?, ?, ?)";

    db.run(query, [name, email, password], function (err) {
        if (err) {
            return res.status(400).json({
                success: false,
                message: err.message
            });
        }

        res.json({
            success: true,
            userId: this.lastID
        });
    });
});

module.exports = router;
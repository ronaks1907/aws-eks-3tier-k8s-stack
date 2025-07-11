const express = require("express");
const router = express.Router();
const pool = require("../../config/db");

const ensureUserTableExists = async () => {
  const query = `
    CREATE TABLE IF NOT EXISTS users (
      id SERIAL PRIMARY KEY,
      name VARCHAR(100),
      username VARCHAR(100),
      age INTEGER
    )
  `;
  await pool.query(query);
};

const addUser = async (req, res) => {
  const { name, username, age } = req.body;

  try {
    await ensureUserTableExists();

    const newUser = await pool.query(
      "INSERT INTO users(name, username, age) VALUES($1, $2, $3) RETURNING *",
      [name, username, age]
    );

    res.json(newUser.rows[0]);
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Server error");
  }
};

const getUser = async (req, res) => {
  try {
    await ensureUserTableExists();
    const users = await pool.query("SELECT * FROM users ORDER BY id DESC");
    res.json(users.rows);
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Server error");
  }
};

const deleteUser = async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query(
      "DELETE FROM users WHERE id = $1 RETURNING *",
      [id]
    );
    if (result.rowCount === 0) {
      return res.status(404).json({ error: "User not found" });
    }
    res.json({ message: "User deleted", user: result.rows[0] });
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Server error");
  }
};

module.exports = { addUser, getUser, deleteUser };

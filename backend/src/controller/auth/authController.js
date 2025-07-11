const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");
const pool = require("../../config/db.js");
require("dotenv").config();

const ensureAuthTableExists = async () => {
  const query = `
    CREATE TABLE IF NOT EXISTS registeredUser (
      id SERIAL PRIMARY KEY,
      name VARCHAR(255), -- Add this
      email VARCHAR(255) UNIQUE NOT NULL,
      password TEXT NOT NULL
    );
  `;
  await pool.query(query);
};

const registerUser = async (req, res) => {
  await ensureAuthTableExists();

  const { email, password, name } = req.body;
  try {
    const userExists = await pool.query(
      "SELECT * FROM registeredUser WHERE email = $1",
      [email]
    );
    if (userExists.rows.length > 0) {
      return res.status(400).json({ message: "User already exists" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const newUser = await pool.query(
      "INSERT INTO registeredUser (name, email, password) VALUES ($1, $2, $3) RETURNING id, email, name",
      [name, email, hashedPassword]
    );

    res.status(201).json({ message: "User registered", user: newUser.rows[0] });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Registration error" });
  }
};

const loginUser = async (req, res) => {
  const { email, password } = req.body;
  try {
    const userRes = await pool.query(
      "SELECT * FROM registeredUser WHERE email = $1",
      [email]
    );
    const user = userRes.rows[0];

    if (!user) return res.status(401).json({ message: "Invalid credentials" });

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch)
      return res.status(401).json({ message: "Invalid credentials" });

    const token = jwt.sign(
      { id: user.id, email: user.email },
      process.env.JWT_SECRET,
      {
        expiresIn: process.env.JWT_EXPIRY,
      }
    );

    res.json({ token });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Login error" });
  }
};

module.exports = { registerUser, loginUser };

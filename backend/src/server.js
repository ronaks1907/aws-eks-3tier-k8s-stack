const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();
const usersRouter = require('./routes/userRoutes');
const authRouter = require('./routes/authRoutes');

app.use(cors());
app.use(express.json());

// Logging middleware
app.use((req, res, next) => {
  console.log(`➡️  ${req.method} ${req.url} — ${new Date().toISOString()}`);
  next();
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ status: "OK", message: "Backend is healthy" });
});

// Default welcome route (optional)
app.get('/', (req, res) => {
  res.send('🚀 Backend is running successfully!');
});

// Routes
app.use('/users', usersRouter);
app.use('/auth', authRouter);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));

const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();
const usersRouter = require('./routes/userRoutes');
const authRouter = require('./routes/authRoutes');

app.use(cors());
app.use(express.json());

app.use('/users', usersRouter);
app.use('/auth', authRouter);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));

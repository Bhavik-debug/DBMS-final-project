const express = require('express');
const cors = require('cors');
const morgan = require('morgan');
require('dotenv').config();
const apiRoutes = require('./routes/api');

const app = express();

app.use(cors());
app.use(express.json());
app.use(morgan('dev'));

// Setup Routes
app.use('/api', apiRoutes);

// Health Check
app.get('/health', (req, res) => {
    res.json({ status: 'OK', message: 'Backend is running correctly' });
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});

const express = require('express');
const cors = require('cors');
require('dotenv').config();

const authRoutes = require('./routes/authRoutes');
const friendsRoutes = require('./routes/friendsRoutes');
const userRoutes = require('./routes/userRoutes');

const app = express();

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.json({
    message: 'EcoKids API funcionando',
  });
});

// Autenticación
app.use('/auth', authRoutes);

// Amigos
app.use('/friends', friendsRoutes);

// Usuarios
app.use('/users', userRoutes);

const PORT = process.env.PORT || 3000;

app.listen(PORT, '0.0.0.0', () => {
  console.log(
    `Servidor ejecutándose en http://localhost:${PORT}`
  );
});
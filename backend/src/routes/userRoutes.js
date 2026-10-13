const express = require('express');

const {
  searchUsers,
  getUserByUsername,
} = require('../controllers/friendsController');

const {
  getMe,
} = require('../controllers/authController');

const authMiddleware = require('../middleware/authMiddleware');

const router = express.Router();

// Todas estas rutas requieren autenticación.
router.use(authMiddleware);

// Obtener el usuario que ha iniciado sesión.
router.get('/me', getMe);

// Buscar usuarios.
router.get('/search', searchUsers);

// Buscar usuario por nombre
router.get('/username/:username', getUserByUsername);

module.exports = router;
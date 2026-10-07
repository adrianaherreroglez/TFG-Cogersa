const express = require('express');

const {
  searchUsers,
} = require('../controllers/friendsController');

const authMiddleware = require('../middleware/authMiddleware');

const router = express.Router();


// Todas las rutas necesitan autenticación
router.use(authMiddleware);


// Buscar usuarios
router.get(
  '/search',
  searchUsers
);


module.exports = router;


const express = require('express');

const {
  crearSala,
} = require('../controllers/salasController');

const authMiddleware = require('../middleware/authMiddleware');

const router = express.Router();

router.use(authMiddleware);

router.post('/', crearSala);

module.exports = router;
const express = require('express');

const {
  crearSala,
  unirseSala,
  obtenerSala,
  iniciarSala,
} = require('../controllers/salasController');

const authMiddleware = require('../middleware/authMiddleware');

const router = express.Router();

router.use(authMiddleware);

router.post('/', crearSala);
router.post('/unirse', unirseSala);
router.get('/:id', obtenerSala);
router.patch('/:id/iniciar', iniciarSala);

module.exports = router;
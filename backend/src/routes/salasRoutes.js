const express = require('express');

const {
  crearSala,
  unirseSala,
  obtenerSala,
  iniciarSala,
  guardarResultado,
  obtenerClasificacion,
  cerrarSala,
} = require('../controllers/salasController');


const authMiddleware = require('../middleware/authMiddleware');

const router = express.Router();

router.use(authMiddleware);

router.post('/', crearSala);
router.post('/unirse', unirseSala);
router.get('/:id', obtenerSala);
router.patch('/:id/iniciar', iniciarSala);

router.post('/:id/resultados', guardarResultado);
router.get('/:id/clasificacion', obtenerClasificacion);
router.patch('/:id/cerrar', cerrarSala);

module.exports = router;
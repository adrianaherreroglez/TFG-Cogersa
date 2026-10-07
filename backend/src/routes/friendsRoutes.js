const express = require('express');

const {
  getFriends,
  getReceivedRequests,
  getSentRequests,
  sendFriendRequest,
  acceptFriendRequest,
  rejectFriendRequest,
} = require('../controllers/friendsController');

const authMiddleware = require('../middleware/authMiddleware');

const router = express.Router();


// Todas las rutas de amigos
// necesitan estar autenticadas
router.use(authMiddleware);


// Obtener amigos
router.get(
  '/',
  getFriends
);


// Solicitudes recibidas
router.get(
  '/requests/received',
  getReceivedRequests
);


// Solicitudes enviadas
router.get(
  '/requests/sent',
  getSentRequests
);


// Enviar solicitud
router.post(
  '/requests',
  sendFriendRequest
);


// Aceptar solicitud
router.put(
  '/requests/:id/accept',
  acceptFriendRequest
);


// Rechazar solicitud
router.delete(
  '/requests/:id',
  rejectFriendRequest
);


module.exports = router;


const express = require('express');

const {
  getMessages,
} = require('../controllers/messagesController');

const authMiddleware = require('../middleware/authMiddleware');

const router = express.Router();

router.use(authMiddleware);

// Obtener conversación con otro usuario
router.get('/:userId', getMessages);

module.exports = router;


const express = require('express');

const {
  searchUsers,
  getUserByUsername,
} = require('../controllers/friendsController');

const {
  getMe,
  updateMe,
} = require('../controllers/authController');

const authMiddleware = require('../middleware/authMiddleware');

const router = express.Router();

router.use(authMiddleware);

router.get('/me', getMe);
router.put('/me', updateMe);

router.get('/search', searchUsers);
router.get('/username/:username', getUserByUsername);

module.exports = router;
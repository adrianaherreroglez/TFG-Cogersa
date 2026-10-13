const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const pool = require('../config/database');

const register = async (req, res) => {
  try {
    const { username, password } = req.body;

    if (!username ||  !password) {
      return res.status(400).json({
        message: 'Todos los campos son obligatorios',
      });
    }

    const existingUser = await pool.query(
      'SELECT id FROM users WHERE username = $1',
      [username]
    );

    if (existingUser.rows.length > 0) {
      return res.status(409).json({
        message: 'El usuario ya existe',
      });
    }

    const passwordHash = await bcrypt.hash(password, 12);

    const result = await pool.query(
      `INSERT INTO users (username, password_hash)
       VALUES ($1, $2)
       RETURNING id, username, created_at`,
      [username, passwordHash]
    );

    const user = result.rows[0];

    const token = jwt.sign(
      {
        id: user.id,
        username: user.username,
      },
      process.env.JWT_SECRET,
      {
        expiresIn: '7d',
      }
    );

    res.status(201).json({
      message: 'Usuario registrado correctamente',
      token,
      user,
    });

  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: 'Error interno del servidor',
    });
  }
};


const login = async (req, res) => {
  try {
    const { username, password } = req.body;

    if (!username || !password) {
      return res.status(400).json({
        message: 'Usuario y contraseña son obligatorios',
      });
    }

    const result = await pool.query(
      'SELECT * FROM users WHERE username = $1',
      [username]
    );

    if (result.rows.length === 0) {
      return res.status(401).json({
        message: 'Usuario o contraseña incorrectos',
      });
    }

    const user = result.rows[0];

    const passwordCorrect = await bcrypt.compare(
      password,
      user.password_hash
    );

    if (!passwordCorrect) {
      return res.status(401).json({
        message: 'Usuario o contraseña incorrectos',
      });
    }

    const token = jwt.sign(
      {
        id: user.id,
        username: user.username,
      },
      process.env.JWT_SECRET,
      {
        expiresIn: '7d',
      }
    );

    res.json({
      message: 'Login correcto',
      token,
      user: {
        id: user.id,
        username: user.username
      },
    });

  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: 'Error interno del servidor',
    });
  }
};


const getMe = async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT id, username, created_at
       FROM users
       WHERE id = $1`,
      [req.user.id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        message: 'Usuario no encontrado',
      });
    }

    res.json(result.rows[0]);

  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: 'Error interno del servidor',
    });
  }
};

const updateMe = async (req, res) => {
  try {
    const userId = req.user.id;
    const {
      username,
      currentPassword,
      newPassword,
      confirmPassword,
    } = req.body;

    const cambiarUsername =
      typeof username === 'string' && username.trim() !== '';

    const cambiarPassword =
      typeof newPassword === 'string' && newPassword.length > 0;

    if (!cambiarUsername && !cambiarPassword) {
      return res.status(400).json({
        message: 'No hay cambios que guardar',
      });
    }

    // Comprobar el nuevo nombre de usuario
    const nuevoUsername = cambiarUsername ? username.trim() : null;

    if (cambiarUsername) {
      if (nuevoUsername.length < 3 || nuevoUsername.length > 30) {
        return res.status(400).json({
          message: 'El usuario debe tener entre 3 y 30 caracteres',
        });
      }

      const existente = await pool.query(
        `SELECT id FROM users
         WHERE LOWER(username) = LOWER($1) AND id <> $2`,
        [nuevoUsername, userId]
      );

      if (existente.rows.length > 0) {
        return res.status(409).json({
          message: 'Ese nombre de usuario ya está ocupado',
        });
      }
    }

    let passwordHash = null;

    if (cambiarPassword) {
      if (
        typeof currentPassword !== 'string' ||
        currentPassword.length === 0
      ) {
        return res.status(400).json({
          message: 'Introduce tu contraseña actual',
        });
      }

      if (newPassword.length < 8) {
        return res.status(400).json({
          message: 'La nueva contraseña debe tener al menos 8 caracteres',
        });
      }

      if (newPassword !== confirmPassword) {
        return res.status(400).json({
          message: 'Las contraseñas nuevas no coinciden',
        });
      }

      const resultado = await pool.query(
        'SELECT password_hash FROM users WHERE id = $1',
        [userId]
      );

      if (resultado.rows.length === 0) {
        return res.status(404).json({
          message: 'Usuario no encontrado',
        });
      }

      const passwordCorrecta = await bcrypt.compare(
        currentPassword,
        resultado.rows[0].password_hash
      );

      if (!passwordCorrecta) {
        return res.status(400).json({
          message: 'La contraseña actual es incorrecta',
        });
      }

      passwordHash = await bcrypt.hash(newPassword, 12);
    }

    const result = await pool.query(
      `UPDATE users
       SET username = CASE
             WHEN $2::boolean THEN $3
             ELSE username
           END,
           password_hash = CASE
             WHEN $4::boolean THEN $5
             ELSE password_hash
           END
       WHERE id = $1
       RETURNING id, username, created_at`,
      [
        userId,
        cambiarUsername,
        nuevoUsername,
        cambiarPassword,
        passwordHash,
      ]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        message: 'Usuario no encontrado',
      });
    }

    return res.status(200).json({
      message: 'Perfil actualizado correctamente',
      user: result.rows[0],
    });
  } catch (error) {
    console.error('Error actualizando perfil:', error);

    // Protección adicional por si existe una restricción UNIQUE
    // en la base de datos y dos peticiones coinciden.
    if (error.code === '23505') {
      return res.status(409).json({
        message: 'Ese nombre de usuario ya está ocupado',
      });
    }

    return res.status(500).json({
      message: 'Error interno del servidor',
    });
  }
};


module.exports = {
  register,
  login,
  getMe,
  updateMe,
};
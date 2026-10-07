const pool = require('../config/database');


// OBTENER CONVERSACIÓN
const getMessages = async (req, res) => {
  try {
    const currentUserId = req.user.id;
    const otherUserId = Number(req.params.userId);

    if (!otherUserId) {
      return res.status(400).json({
        message: 'Usuario no válido',
      });
    }

    const result = await pool.query(
      `
      SELECT
        m.id,
        m.sender_id,
        m.receiver_id,
        m.message,
        m.created_at
      FROM messages m
      WHERE
        (
          m.sender_id = $1
          AND m.receiver_id = $2
        )
        OR
        (
          m.sender_id = $2
          AND m.receiver_id = $1
        )
      ORDER BY m.created_at ASC, m.id ASC
      `,
      [currentUserId, otherUserId]
    );

    res.json({
      messages: result.rows,
    });
  } catch (error) {
    console.error(
      'Error obteniendo mensajes:',
      error
    );

    res.status(500).json({
      message: 'Error interno del servidor',
    });
  }
};


// GUARDAR MENSAJE
const saveMessage = async ({
  senderId,
  receiverId,
  message,
}) => {
  const result = await pool.query(
    `
    INSERT INTO messages
    (
      sender_id,
      receiver_id,
      message
    )
    VALUES ($1, $2, $3)
    RETURNING
      id,
      sender_id,
      receiver_id,
      message,
      created_at
    `,
    [
      senderId,
      receiverId,
      message,
    ]
  );

  return result.rows[0];
};

module.exports = {
  getMessages,
  saveMessage,
};


const pool = require('../config/database');


// BUSCAR USUARIOS
const searchUsers = async (req, res) => {
  try {
    const currentUserId = req.user.id;
    const username = req.query.username || '';

    if (username.trim() === '') {
      return res.json({
        users: [],
      });
    }

    const result = await pool.query(
      `
      SELECT
        u.id,
        u.username
      FROM users u

      WHERE u.id <> $1

      -- No mostrar usuarios que ya son amigos
      AND NOT EXISTS (
        SELECT 1
        FROM friend_requests fr
        WHERE
          (
            (
              fr.sender_id = $1
              AND fr.receiver_id = u.id
            )
            OR
            (
              fr.sender_id = u.id
              AND fr.receiver_id = $1
            )
          )
          AND fr.status = 'accepted'
      )

      -- No mostrar solicitudes pendientes
      -- que nosotros hemos enviado
      AND NOT EXISTS (
        SELECT 1
        FROM friend_requests fr
        WHERE
          fr.sender_id = $1
          AND fr.receiver_id = u.id
          AND fr.status = 'pending'
      )

      -- Tampoco mostrar solicitudes pendientes
      -- que nos hayan enviado
      AND NOT EXISTS (
        SELECT 1
        FROM friend_requests fr
        WHERE
          fr.sender_id = u.id
          AND fr.receiver_id = $1
          AND fr.status = 'pending'
      )

      -- Buscar por nombre de usuario
      AND u.username ILIKE $2

      ORDER BY u.username

      LIMIT 20
      `,
      [
        currentUserId,
        `%${username}%`,
      ]
    );

    res.json({
      users: result.rows,
    });
  } catch (error) {
    console.error(
      'Error buscando usuarios:',
      error
    );

    res.status(500).json({
      message: 'Error interno del servidor',
    });
  }
};



// OBTENER AMIGOS
const getFriends = async (req, res) => {
  try {
    const currentUserId = req.user.id;

    const result = await pool.query(
      `
      SELECT
        u.id,
        u.username
      FROM friend_requests fr

      JOIN users u
        ON u.id = CASE
          WHEN fr.sender_id = $1
          THEN fr.receiver_id
          ELSE fr.sender_id
        END

      WHERE
        (
          fr.sender_id = $1
          OR fr.receiver_id = $1
        )

        AND fr.status = 'accepted'

      ORDER BY u.username
      `,
      [currentUserId]
    );

    res.json({
      friends: result.rows,
    });
  } catch (error) {
    console.error(
      'Error obteniendo amigos:',
      error
    );

    res.status(500).json({
      message: 'Error interno del servidor',
    });
  }
};


// SOLICITUDES RECIBIDAS
const getReceivedRequests = async (req, res) => {
  try {
    const currentUserId = req.user.id;

    const result = await pool.query(
      `
      SELECT
        u.id,
        u.username,
        fr.id AS "requestId"

      FROM friend_requests fr

      JOIN users u
        ON u.id = fr.sender_id

      WHERE
        fr.receiver_id = $1
        AND fr.status = 'pending'

      ORDER BY fr.created_at DESC
      `,
      [currentUserId]
    );

    res.json({
      requests: result.rows,
    });
  } catch (error) {
    console.error(
      'Error obteniendo solicitudes recibidas:',
      error
    );

    res.status(500).json({
      message: 'Error interno del servidor',
    });
  }
};



// SOLICITUDES ENVIADAS
const getSentRequests = async (req, res) => {
  try {
    const currentUserId = req.user.id;

    const result = await pool.query(
      `
      SELECT
        u.id,
        u.username,
        fr.id AS "requestId"

      FROM friend_requests fr

      JOIN users u
        ON u.id = fr.receiver_id

      WHERE
        fr.sender_id = $1
        AND fr.status = 'pending'

      ORDER BY fr.created_at DESC
      `,
      [currentUserId]
    );

    res.json({
      requests: result.rows,
    });
  } catch (error) {
    console.error(
      'Error obteniendo solicitudes enviadas:',
      error
    );

    res.status(500).json({
      message: 'Error interno del servidor',
    });
  }
};


// ENVIAR SOLICITUD
const sendFriendRequest = async (req, res) => {
  try {
    const senderId = req.user.id;
    const { receiverId } = req.body;

    if (!receiverId) {
      return res.status(400).json({
        message:
          'Debes indicar el usuario receptor',
      });
    }

    if (
      Number(senderId) ===
      Number(receiverId)
    ) {
      return res.status(400).json({
        message:
          'No puedes enviarte una solicitud a ti mismo',
      });
    }

    // Comprobar que el usuario existe
    const userResult = await pool.query(
      `
      SELECT id
      FROM users
      WHERE id = $1
      `,
      [receiverId]
    );

    if (userResult.rows.length === 0) {
      return res.status(404).json({
        message:
          'El usuario no existe',
      });
    }

    // Buscar relación anterior
    const existingResult = await pool.query(
      `
      SELECT *
      FROM friend_requests

      WHERE
        (
          sender_id = $1
          AND receiver_id = $2
        )
        OR
        (
          sender_id = $2
          AND receiver_id = $1
        )

      ORDER BY id DESC

      LIMIT 1
      `,
      [
        senderId,
        receiverId,
      ]
    );

    if (existingResult.rows.length > 0) {
      const existing =
        existingResult.rows[0];

      // Ya son amigos
      if (
        existing.status === 'accepted'
      ) {
        return res.status(400).json({
          message:
            'Ya sois amigos',
        });
      }

      // Ya existe una solicitud
      if (
        existing.status === 'pending'
      ) {
        return res.status(400).json({
          message:
            'Ya existe una solicitud pendiente',
        });
      }

      // Si estaba rechazada,
      // reutilizamos la solicitud
      if (
        existing.status === 'rejected'
      ) {
        const updated =
          await pool.query(
            `
            UPDATE friend_requests

            SET
              sender_id = $1,
              receiver_id = $2,
              status = 'pending',
              created_at =
                CURRENT_TIMESTAMP

            WHERE id = $3

            RETURNING id
            `,
            [
              senderId,
              receiverId,
              existing.id,
            ]
          );

        return res.status(201).json({
          message:
            'Solicitud enviada',

          requestId:
            updated.rows[0].id,
        });
      }
    }

    // Crear solicitud nueva
    const result = await pool.query(
      `
      INSERT INTO friend_requests
      (
        sender_id,
        receiver_id,
        status
      )

      VALUES
      (
        $1,
        $2,
        'pending'
      )

      RETURNING id
      `,
      [
        senderId,
        receiverId,
      ]
    );

    res.status(201).json({
      message:
        'Solicitud enviada',

      requestId:
        result.rows[0].id,
    });
  } catch (error) {
    console.error(
      'Error enviando solicitud:',
      error
    );

    res.status(500).json({
      message:
        'Error interno del servidor',
    });
  }
};



// ACEPTAR SOLICITUD
const acceptFriendRequest = async (
  req,
  res
) => {
  try {
    const currentUserId =
      req.user.id;

    const requestId =
      req.params.id;

    const result = await pool.query(
      `
      UPDATE friend_requests

      SET status = 'accepted'

      WHERE
        id = $1
        AND receiver_id = $2
        AND status = 'pending'

      RETURNING id
      `,
      [
        requestId,
        currentUserId,
      ]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        message:
          'Solicitud no encontrada',
      });
    }

    res.json({
      message:
        'Solicitud aceptada',
    });
  } catch (error) {
    console.error(
      'Error aceptando solicitud:',
      error
    );

    res.status(500).json({
      message:
        'Error interno del servidor',
    });
  }
};


// RECHAZAR SOLICITUD
const rejectFriendRequest = async (
  req,
  res
) => {
  try {
    const currentUserId =
      req.user.id;

    const requestId =
      req.params.id;

    const result = await pool.query(
      `
      UPDATE friend_requests

      SET status = 'rejected'

      WHERE
        id = $1
        AND receiver_id = $2
        AND status = 'pending'

      RETURNING id
      `,
      [
        requestId,
        currentUserId,
      ]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        message:
          'Solicitud no encontrada',
      });
    }

    res.json({
      message:
        'Solicitud rechazada',
    });
  } catch (error) {
    console.error(
      'Error rechazando solicitud:',
      error
    );

    res.status(500).json({
      message:
        'Error interno del servidor',
    });
  }
};

const getUserByUsername = async (req, res) => {
  try {
    const username = req.params.username;

    const result = await pool.query(
      `
      SELECT
        id,
        username
      FROM users
      WHERE username = $1
      `,
      [username]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        message: 'Usuario no encontrado',
      });
    }

    res.json({
      user: result.rows[0],
    });
  } catch (error) {
    console.error(
      'Error obteniendo usuario:',
      error
    );

    res.status(500).json({
      message:
        'Error interno del servidor',
    });
  }
};



// EXPORTAR
module.exports = {
  searchUsers,
  getFriends,
  getReceivedRequests,
  getSentRequests,
  sendFriendRequest,
  acceptFriendRequest,
  rejectFriendRequest,
  getUserByUsername,
};


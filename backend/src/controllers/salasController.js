const pool = require('../config/database');

const crearSala = async (req, res) => {
  const client = await pool.connect();

  try {
    const creadorId = req.user.id;
    const { codigo, juego_id, num_jugadores = 10 } = req.body;

    if (
      typeof codigo !== 'string' ||
      !/^[A-Z0-9]{6}$/.test(codigo)
    ) {
      return res.status(400).json({
        message: 'El código debe tener 6 letras mayúsculas o números',
      });
    }

    const juegoId = Number(juego_id);
    const numJugadores = Number(num_jugadores);

    if (!Number.isInteger(juegoId) || juegoId <= 0) {
      return res.status(400).json({
        message: 'El juego seleccionado no es válido',
      });
    }

    if (
      !Number.isInteger(numJugadores) ||
      numJugadores < 2 ||
      numJugadores > 100
    ) {
      return res.status(400).json({
        message: 'El número de jugadores debe estar entre 2 y 100',
      });
    }

    await client.query('BEGIN');

    const result = await client.query(
      `INSERT INTO salas (
        codigo, juego_id, creador_id, num_jugadores
      )
      VALUES ($1, $2, $3, $4)
      RETURNING id, codigo, juego_id, creador_id,
                num_jugadores, estado, created_at`,
      [codigo, juegoId, creadorId, numJugadores]
    );

    const sala = result.rows[0];

    await client.query(
      `INSERT INTO sala_miembros (sala_id, usuario_id)
       VALUES ($1, $2)`,
      [sala.id, creadorId]
    );

    await client.query('COMMIT');

    return res.status(201).json({
      message: 'Sala creada correctamente',
      sala,
    });
  } catch (error) {
    await client.query('ROLLBACK');

    if (error.code === '23505') {
      return res.status(409).json({
        message: 'El código de sala ya existe',
      });
    }

    if (error.code === '23503') {
      return res.status(400).json({
        message: 'El juego o el usuario no existe',
      });
    }

    console.error('Error creando sala:', error);

    return res.status(500).json({
      message: 'Error interno del servidor',
    });
  } finally {
    client.release();
  }
};

// Unirse a una sala utilizando su código.
const unirseSala = async (req, res) => {
  const client = await pool.connect();

  try {
    const usuarioId = req.user.id;
    const codigo = String(req.body.codigo ?? '')
      .trim()
      .toUpperCase();

    if (!/^[A-Z0-9]{6}$/.test(codigo)) {
      return res.status(400).json({
        message: 'El código debe tener 6 letras mayúsculas o números',
      });
    }

    await client.query('BEGIN');

    const resultado = await client.query(
      `SELECT *
       FROM salas
       WHERE codigo = $1
       FOR UPDATE`,
      [codigo]
    );

    if (resultado.rows.length === 0) {
      await client.query('ROLLBACK');

      return res.status(404).json({
        message: 'No existe una sala con ese código',
      });
    }

    const sala = resultado.rows[0];

    if (sala.estado !== 'esperando') {
      await client.query('ROLLBACK');

      return res.status(400).json({
        message: 'Esta sala ya ha comenzado o está cerrada',
      });
    }

    // Comprobar si el usuario ya pertenece a la sala.
    // Esto permite al anfitrión entrar con su propio código.
    const miembroExistente = await client.query(
      `SELECT id
       FROM sala_miembros
       WHERE sala_id = $1 AND usuario_id = $2`,
      [sala.id, usuarioId]
    );

    if (miembroExistente.rows.length === 0) {
      const total = await client.query(
        `SELECT COUNT(*)::int AS total
         FROM sala_miembros
         WHERE sala_id = $1`,
        [sala.id]
      );

      if (total.rows[0].total >= sala.num_jugadores) {
        await client.query('ROLLBACK');

        return res.status(400).json({
          message: 'La sala está llena',
        });
      }

      await client.query(
        `INSERT INTO sala_miembros (sala_id, usuario_id)
         VALUES ($1, $2)`,
        [sala.id, usuarioId]
      );
    }

    await client.query('COMMIT');

    return res.status(200).json({
      message: 'Te has unido a la sala',
      sala,
    });
  } catch (error) {
    await client.query('ROLLBACK');

    console.error('Error al unirse a la sala:', error);

    return res.status(500).json({
      message: 'Error interno al unirse a la sala',
    });
  } finally {
    client.release();
  }
};


// Obtener los datos de la sala y sus jugadores.
const obtenerSala = async (req, res) => {
  try {
    const usuarioId = Number(req.user.id);
    const salaId = Number(req.params.id);

    if (!Number.isInteger(salaId) || salaId <= 0) {
      return res.status(400).json({
        message: 'El ID de la sala no es válido',
      });
    }

    const resultadoSala = await pool.query(
      `SELECT s.*
       FROM salas s
       INNER JOIN sala_miembros sm
         ON sm.sala_id = s.id
       WHERE s.id = $1 AND sm.usuario_id = $2`,
      [salaId, usuarioId]
    );

    if (resultadoSala.rows.length === 0) {
      return res.status(404).json({
        message: 'La sala no existe o no perteneces a ella',
      });
    }

    const sala = resultadoSala.rows[0];

    const resultadoMiembros = await pool.query(
      `SELECT
         sm.usuario_id,
         COALESCE(
           to_jsonb(u)->>'nombre',
           to_jsonb(u)->>'username',
           to_jsonb(u)->>'name',
           'Jugador'
         ) AS nombre,
         (sm.usuario_id = s.creador_id) AS es_anfitrion
       FROM sala_miembros sm
       INNER JOIN salas s ON s.id = sm.sala_id
       INNER JOIN users u ON u.id = sm.usuario_id
       WHERE sm.sala_id = $1
       ORDER BY sm.unido_en ASC`,
      [salaId]
    );

    return res.status(200).json({
      sala,
      miembros: resultadoMiembros.rows,
      es_anfitrion: Number(sala.creador_id) === usuarioId,
    });
  } catch (error) {
    console.error('Error al obtener la sala:', error);

    return res.status(500).json({
      message: 'Error interno al obtener la sala',
    });
  }
};


// Iniciar una sala: solo puede hacerlo su creador.
const iniciarSala = async (req, res) => {
  try {
    const usuarioId = Number(req.user.id);
    const salaId = Number(req.params.id);

    if (!Number.isInteger(salaId) || salaId <= 0) {
      return res.status(400).json({
        message: 'El ID de la sala no es válido',
      });
    }

    const resultado = await pool.query(
      `UPDATE salas
       SET estado = 'jugando'
       WHERE id = $1
         AND creador_id = $2
         AND estado = 'esperando'
       RETURNING *`,
      [salaId, usuarioId]
    );

    if (resultado.rows.length === 0) {
      const existe = await pool.query(
        'SELECT id, creador_id, estado FROM salas WHERE id = $1',
        [salaId]
      );

      if (existe.rows.length === 0) {
        return res.status(404).json({
          message: 'La sala no existe',
        });
      }

      if (Number(existe.rows[0].creador_id) !== usuarioId) {
        return res.status(403).json({
          message: 'Solo el anfitrión puede iniciar la partida',
        });
      }

      return res.status(400).json({
        message: 'La sala ya ha comenzado o está cerrada',
      });
    }

    return res.status(200).json({
      message: 'Partida iniciada',
      sala: resultado.rows[0],
    });
  } catch (error) {
    console.error('Error al iniciar la sala:', error);

    return res.status(500).json({
      message: 'Error interno al iniciar la partida',
    });
  }
};


module.exports = {
  crearSala,
  unirseSala,
  obtenerSala,
  iniciarSala,
};
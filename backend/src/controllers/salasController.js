
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
      `
      INSERT INTO salas (
        codigo,
        juego_id,
        creador_id,
        num_jugadores
      )
      VALUES ($1, $2, $3, $4)
      RETURNING
        id,
        codigo,
        juego_id,
        creador_id,
        num_jugadores,
        estado,
        created_at
      `,
      [codigo, juegoId, creadorId, numJugadores]
    );

    const sala = result.rows[0];

    await client.query(
      `
      INSERT INTO sala_miembros (sala_id, usuario_id)
      VALUES ($1, $2)
      `,
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
        message: 'El código de sala ya existe. Vuelve a entrar en la página para generar otro.',
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

module.exports = {
  crearSala,
};

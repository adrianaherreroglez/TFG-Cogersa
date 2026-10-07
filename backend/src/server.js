const express = require('express');
const cors = require('cors');
const http = require('http');
const jwt = require('jsonwebtoken');
const { Server } = require('socket.io');

require('dotenv').config();

const authRoutes = require('./routes/authRoutes');
const friendsRoutes = require('./routes/friendsRoutes');
const userRoutes = require('./routes/userRoutes');
const messagesRoutes = require('./routes/messagesRoutes');

const {
  saveMessage,
} = require('./controllers/messagesController');

const app = express();

app.use(cors());
app.use(express.json());


// RUTAS
app.get('/', (req, res) => {
  res.json({
    message: 'EcoKids API funcionando',
  });
});

app.use('/auth', authRoutes);
app.use('/friends', friendsRoutes);
app.use('/users', userRoutes);
app.use('/messages', messagesRoutes);


// SERVIDOR HTTP
const server = http.createServer(app);


// SOCKET.IO
const io = new Server(server, {
  cors: {
    origin: '*',
    methods: ['GET', 'POST'],
  },
});


// AUTENTICACIÓN SOCKET
io.use((socket, next) => {
  try {
    const token = socket.handshake.auth.token;

    if (!token) {
      return next(
        new Error('No se proporcionó token')
      );
    }

    const decoded = jwt.verify(
      token,
      process.env.JWT_SECRET
    );

    socket.userId = decoded.id;

    next();
  } catch (error) {
    console.error(
      'Error autenticando socket:',
      error.message
    );

    next(
      new Error('Token inválido')
    );
  }
});


// CONEXIONES
io.on('connection', (socket) => {
  // Cada usuario entra en una sala con su propio ID.
  // Así podemos enviarle mensajes directamente.
  socket.join(`user_${socket.userId}`);

  // ENVIAR MENSAJE
  socket.on('send_message', async (data) => {
    try {
      const receiverId = Number(
        data.receiverId
      );

      const message = String(
        data.message ?? ''
      ).trim();

      if (!receiverId || !message) {
        return;
      }

      if (
        Number(socket.userId) ===
        receiverId
      ) {
        return;
      }

      // Guardar en PostgreSQL
      const savedMessage =
        await saveMessage({
          senderId: socket.userId,
          receiverId,
          message,
        });

      // Enviar al receptor
      io.to(`user_${receiverId}`).emit(
        'new_message',
        savedMessage
      );

      // Enviar también al emisor
      io.to(`user_${socket.userId}`).emit(
        'new_message',
        savedMessage
      );
    } catch (error) {
      console.error(
        'Error enviando mensaje:',
        error
      );

      socket.emit(
        'message_error',
        {
          message:
            'No se pudo enviar el mensaje',
        }
      );
    }
  });
});


// INICIAR SERVIDOR
const PORT = process.env.PORT || 3000;

server.listen(
  PORT,
  '0.0.0.0',
  () => {
    console.log(
      `Servidor ejecutándose en http://localhost:${PORT}`
    );

    console.log(
      'Socket.IO funcionando correctamente'
    );
  }
);

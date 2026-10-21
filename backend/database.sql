
-- Tabla de usuarios
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de solicitudes de amistad
CREATE TABLE friend_requests (
    id SERIAL PRIMARY KEY,
    sender_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    receiver_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT check_different_users
        CHECK (sender_id <> receiver_id),

    CONSTRAINT check_friend_request_status
        CHECK (status IN ('pending', 'accepted', 'rejected'))
);

CREATE INDEX idx_friend_requests_sender
    ON friend_requests(sender_id);

CREATE INDEX idx_friend_requests_receiver
    ON friend_requests(receiver_id);

CREATE INDEX idx_friend_requests_status
    ON friend_requests(status);

-- Tabla de mensajes
CREATE TABLE messages (
    id SERIAL PRIMARY KEY,
    sender_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    receiver_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT check_different_message_users
        CHECK (sender_id <> receiver_id)
);

CREATE INDEX idx_messages_sender_receiver
    ON messages(sender_id, receiver_id);

CREATE INDEX idx_messages_receiver_sender
    ON messages(receiver_id, sender_id);

CREATE INDEX idx_messages_created_at
    ON messages(created_at);


-- Tabla de juegos
CREATE TABLE juegos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    tipo VARCHAR(50) NOT NULL
);

-- Insertar juegos ya creados
INSERT INTO juegos (nombre, tipo)
VALUES
    ('Reciclaje', 'Drag & Drop'),
    ('Reciclaje', 'Fill in the Gaps'),
    ('Punto Limpio', 'Drag & Drop'),
    ('Punto Limpio', 'Fill in the Gaps');

-- Tablas para crear la sala y los users q se unan

CREATE TABLE salas (
    id SERIAL PRIMARY KEY,

    codigo VARCHAR(8) NOT NULL UNIQUE,

    juego_id INTEGER NOT NULL
        REFERENCES juegos(id)
        ON DELETE RESTRICT,

    creador_id INTEGER NOT NULL
        REFERENCES users(id)
        ON DELETE CASCADE,

    num_jugadores INTEGER NOT NULL DEFAULT 10
        CHECK (num_jugadores BETWEEN 2 AND 100),

    estado VARCHAR(20) NOT NULL DEFAULT 'esperando'
        CHECK (estado IN ('esperando', 'jugando', 'cerrada')),

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sala_miembros (
    id SERIAL PRIMARY KEY,

    sala_id INTEGER NOT NULL
        REFERENCES salas(id)
        ON DELETE CASCADE,

    usuario_id INTEGER NOT NULL
        REFERENCES users(id)
        ON DELETE CASCADE,

    unido_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_sala_miembro
        UNIQUE (sala_id, usuario_id)
);

CREATE INDEX idx_salas_creador
    ON salas(creador_id);

CREATE INDEX idx_salas_estado
    ON salas(estado);

CREATE INDEX idx_sala_miembros_sala
    ON sala_miembros(sala_id);

CREATE INDEX idx_sala_miembros_usuario
    ON sala_miembros(usuario_id);

CREATE TABLE resultados_partida (
    id SERIAL PRIMARY KEY,
    sala_id INTEGER NOT NULL
        REFERENCES salas(id) ON DELETE CASCADE,
    usuario_id INTEGER NOT NULL
        REFERENCES users(id) ON DELETE CASCADE,

    puntos INTEGER NOT NULL DEFAULT 0
        CHECK (puntos >= 0),
    tiempo_segundos INTEGER NOT NULL DEFAULT 0
        CHECK (tiempo_segundos >= 0),
    intentos INTEGER NOT NULL DEFAULT 0
        CHECK (intentos >= 0),

    terminado BOOLEAN NOT NULL DEFAULT FALSE,
    terminado_en TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_resultado_sala_usuario
        UNIQUE (sala_id, usuario_id)
);

CREATE INDEX IF NOT EXISTS idx_resultados_sala_puntos
    ON resultados_partida (sala_id, puntos DESC);

CREATE INDEX IF NOT EXISTS idx_resultados_sala_tiempo
    ON resultados_partida (sala_id, tiempo_segundos ASC);

-- Insertar nuevo juego de cartas
INSERT INTO juegos (nombre, tipo)
VALUES
    ('Cartas', 'Juego de Memoria');
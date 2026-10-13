BEGIN;


DROP TABLE IF EXISTS friend_requests CASCADE;
DROP TABLE IF EXISTS messages CASCADE;
DROP TABLE IF EXISTS users CASCADE;

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

COMMIT;
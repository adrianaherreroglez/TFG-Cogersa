--- Tabla que recoge información de los usuarios registrados
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--- Tabla que recoge las solicitudes de amistad
CREATE TABLE friend_requests (
    id SERIAL PRIMARY KEY,

    sender_id INTEGER NOT NULL,
    receiver_id INTEGER NOT NULL,

    status VARCHAR(20) NOT NULL DEFAULT 'pending',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_friend_request_sender
        FOREIGN KEY (sender_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_friend_request_receiver
        FOREIGN KEY (receiver_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

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

---Tabla que recoge los mensajes enviados entre amigos
CREATE TABLE messages (
    id SERIAL PRIMARY KEY,
    sender_id INTEGER NOT NULL,
    receiver_id INTEGER NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_message_sender
        FOREIGN KEY (sender_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_message_receiver
        FOREIGN KEY (receiver_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT check_different_message_users
        CHECK (sender_id <> receiver_id)
);

CREATE INDEX idx_messages_sender_receiver
ON messages(sender_id, receiver_id);

CREATE INDEX idx_messages_receiver_sender
ON messages(receiver_id, sender_id);

CREATE INDEX idx_messages_created_at
ON messages(created_at);

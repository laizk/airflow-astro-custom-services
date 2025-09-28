BEGIN;

DROP TABLE IF EXISTS item CASCADE;

CREATE TABLE IF NOT EXISTS item (
    id                  SERIAL PRIMARY KEY,
    item_name           VARCHAR(255) NOT NULL,
    manufacturer_name   VARCHAR(100) NOT NULL,
    cost                DECIMAL(10,2) NOT NULL CHECK (cost > 0),
    weight              DECIMAL(8,3) NOT NULL CHECK (weight > 0),
    category            VARCHAR(50),
    is_active           BOOLEAN DEFAULT TRUE,
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMIT;
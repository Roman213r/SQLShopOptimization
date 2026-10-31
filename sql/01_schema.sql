CREATE EXTENSION IF NOT EXISTS pg_trgm;

DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS inventory CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS warehouses CASCADE;

CREATE TABLE customers (
    id            BIGSERIAL PRIMARY KEY,
    email         TEXT        NOT NULL,
    full_name     TEXT        NOT NULL,
    city          TEXT        NOT NULL,
    registered_at TIMESTAMPTZ NOT NULL,
    is_active     BOOLEAN     NOT NULL DEFAULT TRUE
);

CREATE TABLE categories (
    id        SERIAL PRIMARY KEY,
    name      TEXT NOT NULL,
    parent_id INT  REFERENCES categories (id)
);

CREATE TABLE products (
    id          BIGSERIAL PRIMARY KEY,
    sku         TEXT           NOT NULL,
    name        TEXT           NOT NULL,
    category_id INT            NOT NULL REFERENCES categories (id),
    price       NUMERIC(10, 2) NOT NULL,
    created_at  TIMESTAMPTZ    NOT NULL
);

CREATE TABLE warehouses (
    id   SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    city TEXT NOT NULL
);

CREATE TABLE inventory (
    product_id   BIGINT NOT NULL REFERENCES products (id),
    warehouse_id INT    NOT NULL REFERENCES warehouses (id),
    quantity     INT    NOT NULL CHECK (quantity >= 0),
    updated_at   TIMESTAMPTZ NOT NULL,
    PRIMARY KEY (product_id, warehouse_id)
);

CREATE TABLE orders (
    id             BIGSERIAL PRIMARY KEY,
    customer_id    BIGINT         NOT NULL REFERENCES customers (id),
    status         TEXT           NOT NULL,
    created_at     TIMESTAMPTZ    NOT NULL,
    total_amount   NUMERIC(12, 2) NOT NULL,
    shipping_city  TEXT           NOT NULL
);

CREATE TABLE order_items (
    id         BIGSERIAL PRIMARY KEY,
    order_id   BIGINT         NOT NULL REFERENCES orders (id),
    product_id BIGINT         NOT NULL REFERENCES products (id),
    quantity   INT            NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10, 2) NOT NULL
);

CREATE TABLE payments (
    id       BIGSERIAL PRIMARY KEY,
    order_id BIGINT         NOT NULL REFERENCES orders (id),
    amount   NUMERIC(12, 2) NOT NULL,
    method   TEXT           NOT NULL,
    status   TEXT           NOT NULL,
    paid_at  TIMESTAMPTZ
);

-- =========================================================
-- TrailShop Relational Schema
-- PostgreSQL DDL — created in dependency order
-- =========================================================

-- -----------------------------------------------------
-- categories: no dependencies, created first
-- -----------------------------------------------------
CREATE TABLE categories (
    category_id     BIGSERIAL PRIMARY KEY,
    name            VARCHAR(100) NOT NULL UNIQUE,
    description     TEXT
);

-- -----------------------------------------------------
-- customers: no dependencies, created first
-- -----------------------------------------------------
CREATE TABLE customers (
    customer_id     BIGSERIAL PRIMARY KEY,
    first_name      VARCHAR(50)  NOT NULL,
    last_name       VARCHAR(50)  NOT NULL,
    email           VARCHAR(255) NOT NULL UNIQUE,
    phone           VARCHAR(20),
    address         TEXT,
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- -----------------------------------------------------
-- products: depends on categories
-- -----------------------------------------------------
CREATE TABLE products (
    product_id      BIGSERIAL PRIMARY KEY,
    category_id     BIGINT REFERENCES categories(category_id)
                        ON DELETE SET NULL
                        ON UPDATE CASCADE,
    name            VARCHAR(150)   NOT NULL,
    description     TEXT,
    sku             VARCHAR(50)    NOT NULL UNIQUE,
    price           NUMERIC(10,2)  NOT NULL CHECK (price >= 0),
    stock_quantity  INTEGER        NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    created_at      TIMESTAMPTZ    NOT NULL DEFAULT now()
);

-- -----------------------------------------------------
-- orders: depends on customers
-- -----------------------------------------------------
CREATE TABLE orders (
    order_id        BIGSERIAL PRIMARY KEY,
    customer_id     BIGINT NOT NULL REFERENCES customers(customer_id)
                        ON DELETE RESTRICT
                        ON UPDATE CASCADE,
    order_date      TIMESTAMPTZ    NOT NULL DEFAULT now(),
    status          VARCHAR(20)    NOT NULL DEFAULT 'pending'
                        CHECK (status IN ('pending', 'paid', 'shipped', 'delivered', 'cancelled')),
    total_amount    NUMERIC(10,2)  NOT NULL DEFAULT 0 CHECK (total_amount >= 0),
    shipping_address TEXT
);

-- -----------------------------------------------------
-- order_items: weak entity, depends on orders and products
-- composite primary key = its identity
-- -----------------------------------------------------
CREATE TABLE order_items (
    order_id        BIGINT NOT NULL REFERENCES orders(order_id)
                        ON DELETE CASCADE
                        ON UPDATE CASCADE,
    product_id      BIGINT NOT NULL REFERENCES products(product_id)
                        ON DELETE RESTRICT
                        ON UPDATE CASCADE,
    quantity        INTEGER        NOT NULL CHECK (quantity > 0),
    unit_price      NUMERIC(10,2)  NOT NULL CHECK (unit_price >= 0),
    PRIMARY KEY (order_id, product_id)
);
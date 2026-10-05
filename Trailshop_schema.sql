CREATE TABLE categories (
    category_id  INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name         VARCHAR(100) NOT NULL UNIQUE,
    description  TEXT
);

CREATE TABLE customers (
    customer_id       INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name        VARCHAR(100) NOT NULL,
    last_name         VARCHAR(100) NOT NULL,
    email             VARCHAR(255) NOT NULL UNIQUE,
    phone             VARCHAR(20),
    shipping_address  TEXT,                       --  drafted an optional default address
    created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE products (
    product_id      INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_id     INTEGER NOT NULL,
    name            VARCHAR(200) NOT NULL,
    description     TEXT,
    price           NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    stock_quantity  INTEGER NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    weight_kg       NUMERIC(6,2) CHECK (weight_kg > 0),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT fk_products_category
        FOREIGN KEY (category_id) REFERENCES categories (category_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE orders (
    order_id          INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id       INTEGER NOT NULL,
    order_date        TIMESTAMPTZ NOT NULL DEFAULT now(),
    status            VARCHAR(20) NOT NULL DEFAULT 'new',
    shipping_address  TEXT NOT NULL,
    CONSTRAINT ck_orders_status
        CHECK (status IN ('new', 'confirmed', 'shipped', 'delivered', 'cancelled', 'returned')),
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE order_items (
    order_id    INTEGER NOT NULL,
    product_id  INTEGER NOT NULL,
    quantity    INTEGER NOT NULL CHECK (quantity > 0),
    unit_price  NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),
    PRIMARY KEY (order_id, product_id),
    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id) REFERENCES orders (order_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id) REFERENCES products (product_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

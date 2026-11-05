CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    supplier_email VARCHAR(100),
    supplier_city VARCHAR(100)
);

CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category_id INT NOT NULL REFERENCES categories(category_id)
);

CREATE TABLE supplier_products (
    supplier_id INT REFERENCES suppliers(supplier_id),
    product_id INT REFERENCES products(product_id),
    supply_price DECIMAL(10,2) NOT NULL,
    lead_time_days INT NOT NULL,
    PRIMARY KEY (supplier_id, product_id)
);

# Week 40 — Exercises: SQL Fundamentals

> [!IMPORTANT]
> ***How to Complete These Exercises***
> Write your answers directly in the highlighted **Your Answer** / **Your SQL** fields below each task. Replace the placeholder text with your own work before submitting.

## Exercise 1: TrailShop Project Task

This week you'll build the TrailShop database from scratch and practice manipulating data.

### Task 1.1: Create the Database

1. Open your PostgreSQL terminal (psql) or pgAdmin
2. Create a new database called `trailshop`
3. Connect to it

### Task 1.2: Create All Tables

Write and execute the CREATE TABLE statements for all five TrailShop tables in the correct order:
- categories
- customers
- products
- orders
- order_items

**Requirements:**
- Use appropriate data types for each column
- Include all constraints from the theory (NOT NULL, UNIQUE, CHECK, FOREIGN KEY, DEFAULT)
- Use SERIAL for primary keys
- Ensure foreign keys reference the correct parent tables

**Verify** by running `\dt` in psql to list all tables.

> [!NOTE]
> ***Your SQL***
>
> ```sql
> 
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name        VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name  VARCHAR(100) NOT NULL,
    last_name   VARCHAR(100) NOT NULL,
    email       VARCHAR(255) NOT NULL UNIQUE,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
    product_id  SERIAL PRIMARY KEY,
    name        VARCHAR(200) NOT NULL,
    description TEXT,
    price       NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    stock       INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
    created_at  TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE product_categories (
    product_id  INTEGER NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
    category_id INTEGER NOT NULL REFERENCES categories(category_id) ON DELETE CASCADE,
    PRIMARY KEY (product_id, category_id)
);

CREATE TABLE orders (
    order_id    SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
    order_date  TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status      VARCHAR(20) NOT NULL DEFAULT 'pending'
                CHECK (status IN ('pending', 'shipped', 'delivered', 'cancelled'))
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id      INTEGER NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id    INTEGER NOT NULL REFERENCES products(product_id),
    quantity      INTEGER NOT NULL CHECK (quantity > 0),
    unit_price    NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),
    UNIQUE (order_id, product_id)
);
and then verified it using the : \dt
>
>
> ```


### Task 1.3: Insert Sample Data

Insert the following data:

**Categories** (at least 5):
- Footwear, Backpacks, Tents, Clothing, Accessories

> [!NOTE]
> ***Your SQL***
>
> ```sql
> INSERT INTO categories (name, description) VALUES
    ('Footwear',    'Hiking boots, trail runners, and socks'),
    ('Backpacks',   'Day packs and expedition packs'),
    ('Tents',       'Tents for solo and family camping'),
    ('Clothing',    'Layers and weatherproof clothing'),
    ('Accessories', 'Bottles, lights, poles, and other gear');

SELECT * FROM categories;
>
>
> ```

**Customers** (at least 5):
- Use easy to write names with realistic email addresses

> [!NOTE]
> ***Your SQL***
>
> ```sql
> INSERT INTO customers (first_name, last_name, email) VALUES
    ('Aino',   'Virtanen',  'aino.virtanen@email.com'),
    ('Mikko',  'Korhonen',  'mikko.korhonen@email.com'),
    ('Laura',  'Nieminen',  'laura.nieminen@email.com'),
    ('Jussi',  'Heikkinen', 'jussi.heikkinen@email.com'),
    ('Sofia',  'Laine',     'sofia.laine@email.com'),
    ('Olli',   'Makinen',   'olli.makinen@email.com');

SELECT * FROM customers;
>
>
> ```

**Products** (at least 10):
- At least 2 products per category
- Prices ranging from €20 to €500
- Various stock levels

> [!NOTE]
> ***Your SQL***
>
> ```sql
> INSERT INTO products (name, description, price, stock) VALUES
    ('TrailRunner Pro Shoes',  'Lightweight trail running shoes',        129.00,  25),
    ('Summit Hiking Boots',    'Waterproof leather hiking boots',        189.90,  15),
    ('Day Pack 25L',           'Comfortable pack for day hikes',          59.90,  40),
    ('Expedition Pack 65L',    'Large pack for multi-day trips',         249.00,  10),
    ('Solo Trek Tent',         'One-person three-season tent',           199.00,   8),
    ('Family Dome Tent',       'Four-person dome tent',                  489.00,   4),
    ('Merino Base Layer',      'Warm merino wool base layer',             74.50,  30),
    ('Rain Shell Jacket',      'Waterproof breathable shell',            159.00,  18),
    ('HydroFlask 1L',          'Insulated stainless steel bottle',        39.90,  60),
    ('Headlamp Beam 300',      NULL,                                      29.90,  45),
    ('Trekking Poles',         NULL,                                      49.90,   0),
    ('Merino Hiking Socks',    'Cushioned merino socks',                  21.00, 100);

SELECT * FROM products;
>
>
> ```

**Orders** (at least 5):
- Different customers, different statuses

> [!NOTE]
> ***Your SQL***
>
> ```sql
>INSERT INTO product_categories (product_id, category_id) VALUES
    (1, 1), (2, 1),          -- Footwear
    (3, 2), (4, 2),          -- Backpacks
    (5, 3), (6, 3),          -- Tents
    (7, 4), (8, 4),          -- Clothing
    (9, 5), (10, 5), (11, 5),-- Accessories
    (12, 1), (12, 4);        -- Socks: Footwear AND Clothing

SELECT * FROM product_categories;
>
>
> ```

**Order Items** (at least 10):
- Multiple items in some orders, single items in others

> [!NOTE]
> ***Your SQL***
>
> ```sql
> INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
    (1, 1,  1, 129.00),
    (1, 9,  2,  39.90),
    (2, 3,  1,  59.90),
    (2, 10, 1,  29.90),
    (2, 7,  2,  74.50),
    (3, 5,  1, 199.00),
    (3, 11, 1,  49.90),
    (4, 8,  1, 159.00),
    (5, 2,  1, 189.90),
    (5, 12, 3,  21.00),
    (6, 4,  1, 249.00),
    (6, 9,  1,  39.90);

SELECT * FROM order_items;
>
>
> ```

**Verify** each insert with `SELECT * FROM table_name;`

### Task 1.4: Practice UPDATE

Perform the following updates and verify each one:

1. Increase the price of all products in the Footwear category by 10%
2. Change customer #3's email to a new address
3. Update the status of order #2 from 'shipped' to 'delivered'
4. Set the stock of 'HydroFlask 1L' to 85
5. Add a description to any product that currently has NULL in description

> [!NOTE]
> ***Your SQL***
>
> ```sql
> -- 1. +10% for all Footwear products (join through product_categories)
UPDATE products p
SET price = ROUND(p.price * 1.10, 2)
FROM product_categories pc
JOIN categories c ON c.category_id = pc.category_id
WHERE pc.product_id = p.product_id
  AND c.name = 'Footwear';
SELECT product_id, name, price FROM products WHERE product_id IN (1, 2, 12);

-- 2. New email for customer #3
UPDATE customers SET email = 'laura.n@newmail.com' WHERE customer_id = 3;
SELECT * FROM customers WHERE customer_id = 3;

-- 3. Order #2: shipped -> delivered
UPDATE orders SET status = 'delivered' WHERE order_id = 2 AND status = 'shipped';
SELECT * FROM orders WHERE order_id = 2;

-- 4. Stock of HydroFlask 1L
UPDATE products SET stock = 85 WHERE name = 'HydroFlask 1L';
SELECT name, stock FROM products WHERE name = 'HydroFlask 1L';

-- 5. Add a description where it is NULL (product 10 here)
UPDATE products
SET description = 'Rechargeable 300-lumen headlamp'
WHERE product_id = 10 AND description IS NULL;
SELECT product_id, name, description FROM products WHERE product_id = 10;
>
>
> ```


### Task 1.5: Practice DELETE

1. Delete the most recently created order (and observe what happens to its order_items if you used CASCADE)
2. Try to delete a category that has products — what error do you get?

> [!NOTE]
> ***Your Answer***
>
> *(-- 1. Delete the most recent order
DELETE FROM orders
WHERE order_id = (SELECT MAX(order_id) FROM orders);

SELECT * FROM orders;
SELECT * FROM order_items;

-- 2. Try to delete a category that has products
DELETE FROM categories WHERE name = 'Footwear';)
*
>The order was deleted, and its order_items rows were deleted automatically too, because of ON DELETE CASCADE. The delete failed with a foreign key error.
>
>
>

3. Delete a customer who has no orders

### Task 1.6: Practice ALTER TABLE

1. Add a column `phone VARCHAR(20)` to the customers table
2. Add a column `weight_grams INTEGER` to the products table
3. Add a CHECK constraint to ensure `weight_grams > 0` (allow NULL though — not all products have weight recorded yet)
4. Rename the `stock` column in products to `quantity_in_stock`

> [!NOTE]
> ***Your SQL***
>
> ```sql
> -- 1
ALTER TABLE customers ADD COLUMN phone VARCHAR(20);

-- 2
ALTER TABLE products ADD COLUMN weight_grams INTEGER;

-- 3 (NULL is allowed: a CHECK only fails when the expression is FALSE, NULL passes)
ALTER TABLE products
    ADD CONSTRAINT chk_products_weight_positive CHECK (weight_grams > 0);

-- 4
ALTER TABLE products RENAME COLUMN stock TO quantity_in_stock;

-- IMPORTANT: rename it back, later weeks use "stock"
ALTER TABLE products RENAME COLUMN quantity_in_stock TO stock;
>
> ```


---

## Exercise 2: Theory Review Questions

Answer the following questions in your own words using the answer fields below:

1. What does SQL stand for, and why was the language designed to look like English?

> [!NOTE]
> ***Your Answer***
>
> *(SQL stands for Structured Query Language. It is used to work with databases. It was designed to look a bit like English so it would be easier for people to understand and write, even if they are not professional programmers.)*
>
>
>
>

2. Explain the difference between DDL and DML. Give two example commands for each.

> [!NOTE]
> ***Your Answer***
>
> *(DDL is used to create or change the structure of a database, such as tables and columns. Examples are CREATE TABLE and ALTER TABLE.

DML is used to work with the data inside the tables. Examples are INSERT and UPDATE.)*
>
>
>
>

3. What is the difference between DCL and TCL? When would you use each?

> [!NOTE]
> ***Your Answer***
>
> *(DCL is used to control permissions and access to the database. For example, GRANT gives someone permission and REVOKE removes it.

TCL is used to manage transactions. For example, COMMIT saves the changes and ROLLBACK cancels them. It is useful when several database changes need to work together.)*
>
>
>
>

4. Why must you create tables in a specific order? What determines that order?

> [!NOTE]
> ***Your Answer***
>
> *(Tables need to be created in the correct order because of foreign keys. A table that is being referenced must exist before another table can reference it.

So, parent tables are created first and child tables after them. For example, orders needs to be created before order_items because order_items refers to orders.)*
>
>
>
>

5. What is the difference between a column-level constraint and a table-level constraint? When *must* you use a table-level constraint?

> [!NOTE]
> ***Your Answer***
>
> *(A column-level constraint is written directly next to a column and applies to that column. For example, email VARCHAR(255) NOT NULL.

A table-level constraint is written separately and can involve one or more columns. You need a table-level constraint when the constraint involves multiple columns, such as a composite primary key like PRIMARY KEY (product_id, category_id).)*
>
>
>
>

6. Explain the difference between `DELETE FROM products;` and `TRUNCATE TABLE products;`. When would you prefer each?

> [!NOTE]
> ***Your Answer***
>
> *(DELETE FROM products; removes the rows from the table and can also be used with a WHERE condition to remove only certain rows.

TRUNCATE TABLE products; removes all rows from the table at once and cannot use WHERE. It is usually faster when you want to empty the whole table.

I would use DELETE when I only want to remove specific rows and TRUNCATE when I want to completely clear a table, for example in a test database.)*
>
>
>
>

7. What does `ON DELETE CASCADE` do on a foreign key? Give a real-world scenario where it's appropriate and one where it would be dangerous.

> [!NOTE]
> ***Your Answer***
>
> *(ON DELETE CASCADE automatically deletes related child rows when the parent row is deleted.

For example, it makes sense for order_items because if an order is deleted, its items should also be deleted.

It could be dangerous for customers and orders. If deleting a customer also deleted all their orders, important order history could be lost.)*
>
>
>
>

8. Why should you store `unit_price` in the `order_items` table instead of just looking it up from the `products` table?

> [!NOTE]
> ***Your Answer***
>
> *(Product prices can change over time. An order should keep the price that the customer actually paid.

For example, if a product was €10 when someone bought it and later becomes €15, the old order should still show €10. That is why unit_price is stored in order_items.)*
>
>
>
>

9. What is the difference between SERIAL and GENERATED ALWAYS AS IDENTITY? Which would you use in a new project and why?

> [!NOTE]
> ***Your Answer***
>
> *(SERIAL automatically creates numbers for IDs using a sequence. It is commonly used in PostgreSQL.

GENERATED ALWAYS AS IDENTITY is the newer and more standard way of automatically generating IDs. In a new project, I would use GENERATED ALWAYS AS IDENTITY because it is more modern and follows the SQL standard better.)*
>

10. Explain why `UPDATE products SET price = 9.99;` is dangerous. What steps should you take before running any UPDATE statement?

> [!NOTE]
> ***Your Answer***
>
> *(It is dangerous because there is no WHERE condition, so it would change the price of every product to €9.99.

Before running an UPDATE, I would first check the rows using a SELECT with the same WHERE condition. I would also use a transaction so I can roll back if something goes wrong, and check how many rows were changed.)*
>
>
>
>
---

## Exercise 3: SQL Writing Exercises

Write the SQL statements for each task in the **Your SQL** fields below. Verify by running them when ready.

### 3.1 CREATE TABLE

Write a CREATE TABLE statement for a `suppliers` table with the following columns:
- supplier_id (auto-incrementing primary key)
- company_name (required, max 200 characters, must be unique)
- contact_name (max 150 characters)
- email (max 255 characters, required, unique)
- phone (max 20 characters)
- country (max 100 characters, required, default 'Finland')

> [!NOTE]
> ***Your SQL***
>
> ```sql
> CREATE TABLE suppliers (
    supplier_id  SERIAL PRIMARY KEY,
    company_name VARCHAR(200) NOT NULL UNIQUE,
    contact_name VARCHAR(150),
    email        VARCHAR(255) NOT NULL UNIQUE,
    phone        VARCHAR(20),
    country      VARCHAR(100) NOT NULL DEFAULT 'Finland'
);
>
>
> ```

### 3.2 CREATE TABLE with Foreign Key

Write a CREATE TABLE statement for a `product_reviews` table:
- review_id (auto-incrementing primary key)
- product_id (required, references products)
- customer_id (required, references customers)
- rating (required integer, must be between 1 and 5 inclusive)
- review_text (optional, unlimited length)
- created_at (required, defaults to current timestamp)

> [!NOTE]
> ***Your SQL***
>
> ```sql
> CREATE TABLE product_reviews (
    review_id   SERIAL PRIMARY KEY,
    product_id  INTEGER NOT NULL REFERENCES products(product_id),
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
    rating      INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
>
> ```

### 3.3 INSERT — Single Row

Write an INSERT statement to add a new category called 'Electronics' with description 'GPS devices, solar chargers, and tech gear'.

> [!NOTE]
> ***Your SQL***
>
> ```sql
> INSERT INTO categories (name, description)
VALUES ('Electronics', 'GPS devices, solar chargers, and tech gear');
>
>
> ```

### 3.4 INSERT — Multiple Rows

Write a single INSERT statement that adds three new customers:
- Eero Lahtinen, eero.l@email.com
- Maria Salminen, maria.s@email.com
- Petri Kallio, petri.k@email.com

> [!NOTE]
> ***Your SQL***
>
> ```sql
> INSERT INTO customers (first_name, last_name, email) VALUES
    ('Eero',  'Lahtinen', 'eero.l@email.com'),
    ('Maria', 'Salminen', 'maria.s@email.com'),
    ('Petri', 'Kallio',   'petri.k@email.com');
>
>
> ```

### 3.5 INSERT with RETURNING

Write an INSERT statement that adds a new product called 'NorthStar GPS' priced at €229.99 with stock of 12 in category 'Electronics' (assume category_id = 6). Return the product_id and created_at.

> [!NOTE]
> ***Your SQL***
>
> ```sql
> WITH new_product AS (
    INSERT INTO products (name, price, stock)
    VALUES ('NorthStar GPS', 229.99, 12)
    RETURNING product_id, created_at
),
link AS (
    INSERT INTO product_categories (product_id, category_id)
    SELECT product_id, 6 FROM new_product
)
SELECT product_id, created_at FROM new_product;
>
>
> ```

### 3.6 UPDATE — Simple

Write an UPDATE statement that changes the email of the customer with customer_id = 2 to 'mikko.korhonen@newmail.com'.

> [!NOTE]
> ***Your SQL***
>
> ```sql
> UPDATE customers
SET email = 'mikko.korhonen@newmail.com'
WHERE customer_id = 2;
>
>
> ```

### 3.7 UPDATE — Expression

Write an UPDATE statement that reduces the stock of all products by 1 where the stock is currently greater than 0.

> [!NOTE]
> ***Your SQL***
>
> ```sql
> UPDATE products
SET stock = stock - 1
WHERE stock > 0;
>
>
> ```

### 3.8 UPDATE — Multiple Columns

Write an UPDATE statement that changes order #3 to status 'cancelled' and sets a (hypothetical) cancelled_at timestamp to the current time. (Assume you've already added a cancelled_at column.)

> [!NOTE]
> ***Your SQL***
>
> ```sql
> UPDATE orders
SET status = 'cancelled',
    cancelled_at = CURRENT_TIMESTAMP
WHERE order_id = 3;
>
>
> ```

### 3.9 DELETE — With Condition

Write a DELETE statement that removes all orders with status 'cancelled'.

> [!NOTE]
> ***Your SQL***
>
> ```sql
> DELETE FROM orders
WHERE status = 'cancelled';
>
>
> ```

### 3.10 ALTER TABLE

Write the ALTER TABLE statements to:
a) Add a `discount_percent NUMERIC(5,2) DEFAULT 0 CHECK (discount_percent >= 0 AND discount_percent <= 100)` column to products
b) Drop the `description` column from categories
c) Add a composite unique constraint on (customer_id, product_id) in the product_reviews table (preventing a customer from reviewing the same product twice)

> [!NOTE]
> ***Your SQL***
>
> ```sql
>-- a)
ALTER TABLE products
    ADD COLUMN discount_percent NUMERIC(5,2) DEFAULT 0
    CHECK (discount_percent >= 0 AND discount_percent <= 100);

-- b)
ALTER TABLE categories DROP COLUMN description;

-- c)
ALTER TABLE product_reviews
    ADD CONSTRAINT uq_product_reviews_customer_product UNIQUE (customer_id, product_id);
>
>
> ```

---

## Exercise 4: Error Diagnosis

Each of the following SQL statements contains one or more errors. Identify the error(s) and write the corrected version.

### 4.1

```sql
CREATE TABLE warehouses
    warehouse_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(100
);
```

> [!NOTE]
> ***Error(s) Identified***
>
> *(The opening parenthesis ( after the table name warehouses is missing.
VARCHAR(100 is missing its closing parenthesis.)*
>
>
>


> [!NOTE]
> ***Corrected SQL***
>
> ```sql
> CREATE TABLE warehouses (
    warehouse_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(100)
);
>
>
> ```


### 4.2

```sql
INSERT INTO products (name, price, stock, category_id)
VALUES ("Alpine Sleeping Bag", 89.99, 20, 2);
```

> [!NOTE]
> ***Error(s) Identified***
>
> *(String values must use single quotes. In PostgreSQL double quotes mean an identifier (a column/table name), so "Alpine Sleeping Bag" is treated as a column name and causes an error ("column does not exist").)*
>
>
>


> [!NOTE]
> ***Corrected SQL***
>
> ```sql
> INSERT INTO products (name, price, stock)
VALUES ('Alpine Sleeping Bag', 89.99, 20);
>
>
> ```


### 4.3

```sql
CREATE TABLE shipments (
    shipment_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id)
    shipped_date DATE NOT NULL,
    carrier VARCHAR(100)
);
```

> [!NOTE]
> ***Error(s) Identified***
>
> *(A comma is missing after order_id INTEGER REFERENCES orders(order_id), so the parser runs it into the next column definition.)*
>
>
>


> [!NOTE]
> ***Corrected SQL***
>
> ```sql
> CREATE TABLE shipments (
    shipment_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id),
    shipped_date DATE NOT NULL,
    carrier VARCHAR(100)
);
>
>
> ```


### 4.4

```sql
UPDATE products
SET price = price * 0.9
SET stock = stock + 10
WHERE category_id = 3;
```

> [!NOTE]
> ***Error(s) Identified***
>
> *(SET is used twice and there is no comma between the assignments. An UPDATE has a single SET clause with the assignments separated by commas.)*
>
>
>


> [!NOTE]
> ***Corrected SQL***
>
> ```sql
> UPDATE products
SET price = price * 0.9,
    stock = stock + 10
WHERE product_id = 3;
>
>
> ```


### 4.5

```sql
CREATE TABLE wishlists (
    wishlist_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
    product_id INTEGER NOT NULL REFERENCES products(product_id),
    added_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (customer_id, product_id)
);
```

> [!NOTE]
> ***Error(s) Identified***
>
> *(The table defines two primary keys: wishlist_id SERIAL PRIMARY KEY and the table-level PRIMARY KEY (customer_id, product_id). A table can have only one primary key. Since the composite key already prevents duplicates (a customer can wishlist a product only once), the surrogate wishlist_id is not needed.)*
>
>
>


> [!NOTE]
> ***Corrected SQL***
>
> ```sql
> CREATE TABLE wishlists (
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
    product_id  INTEGER NOT NULL REFERENCES products(product_id),
    added_at    TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (customer_id, product_id)
);

-- Alternative: keep wishlist_id as the PK and make the pair UNIQUE instead
-- wishlist_id SERIAL PRIMARY KEY, ..., UNIQUE (customer_id, product_id)
>
>
> ```


---

## Submission Checklist

- [ ] All 5 TrailShop tables created successfully
- [ ] Sample data inserted (at least 5 categories, 5 customers, 10 products, 5 orders, 10 order items)
- [ ] UPDATE exercises completed and verified
- [ ] DELETE exercises completed and verified
- [ ] ALTER TABLE exercises completed and verified
- [ ] Theory review questions answered
- [ ] SQL writing exercises completed
- [ ] Error diagnosis completed with corrections
- [ ] All inline answer fields completed

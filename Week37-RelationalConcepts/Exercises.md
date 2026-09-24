# Week 37 — Exercises & Project Task

> [!IMPORTANT]
> ***How to Complete These Exercises***
> Write your answers directly in the highlighted **Your Answer** / **Your SQL** fields below each task. Replace the placeholder text with your own work before submitting.

These exercises accompany the Week 37 Theory material. Complete all sections.

---

## Part 1: TrailShop Project Task

### Task 1: Identify Keys

Using the `products`, `categories`, and `customers` tables shown in Section 2 of this week's Theory material, answer:

1. What is the primary key of the `products` table? Why is it a good choice?

> [!NOTE]
> ***Your Answer***
>
> The primary key of the products table is product_id. It is a good choice because each product has a unique identifier so product ID helps uniquely identify every row. It is also stable and does not depend on information such as the product's name or price which may change over time.
>
>
>
>


2. What is the primary key of the `categories` table?

> [!NOTE]
> ***Your Answer***
>
> *(The primary keys of the categories table is category_id. It uniquely identifies each category and provides a stable identifier that can be referenced by other tables.)*
>
>
>
>


3. What is the foreign key in the `products` table? What does it reference?

> [!NOTE]
> ***Your Answer***
>
> *(The foreign key in the products table is category_id. It references cetegory(category_id). This ensures that a product can only reference A category that exists in the categories table.)*
>
>
>
>


4. Is `name` in `products` a candidate key? Under what assumption? What would make it unsuitable as a primary key?


> [!NOTE]
> ***Your Answer***
>
> *(name could be a candidate key if we assume that every product name must be unique and cannot be NULL. However, it would be unsuitable as a primary key if duplicate names are allowed or if product names can change. A primary key should be stable and reliably unique so product_id is a better choice.)*
>
>
>
>
5. Give an example of a **superkey** for the `products` table that is NOT a candidate key. Explain why it's not minimal.

> [!NOTE]
> ***Your Answer***
>
> *(An example is product_id, name. This is a superkey because product_id alone already uniquely identifies a product. However it is not a candidate key because name is unnecessary. Since product_id by itself is sufficient the combination is not minimal.)*
>
>
>
>

6. Give an example of a **composite key** using a hypothetical `order_items` table. Explain why neither column alone would be sufficient.

> [!NOTE]
> ***Your Answer***
>
> *(order_id or product_id is a suitable composite key. Neither column alone is sufficient because an order can contain multiple products, so order_id can appear in multiple rows. Likewise, the same product can appear in many different orders, so product_id can also appear in multiple rows. Together, however, order_id and product_id uniquely identify one product within one order.)*
>
>
>
>

7. Is `email` in `customers` a candidate key? What makes it different from `customer_id` as a PK choice? *(See Section 6.9 on natural vs surrogate keys.)*

> [!NOTE]
> ***Your Answer***
>
> *(email can be a candidate key if every customer has a unique non null email address. It is natural key because it comes from real world customer information. customer_id on the other hand is a surrogate key created specifically for database identification. customer_id is generally better primary key because it is stable even if a customer's email changes.)*
>
>
>
>

### Task 2: Define Business Rules

List **5 business rules** for TrailShop. For each rule, specify:
- The rule in plain English
- Which constraint type(s) would enforce it
- Which table and column the constraint applies to
- The SQL syntax for the constraint

Example:

| Business Rule | Constraint Type | Table.Column | SQL |
|---|---|---|---|
| Every product must have a price greater than zero | CHECK | products.price | `CHECK (price > 0)` |
| ... | ... | ... | ... |

Think about rules for customers, orders, and categories — not just products.

> [!NOTE]
> ***Your Answer***
>
> *Business Rule	Constraint Type	Table.Column	SQL Syntax
Every product must have a price greater than zero.	CHECK	products.price	CHECK (price > 0)
Every product must have a stock quantity of zero or greater.	CHECK	products.stock_quantity	CHECK (stock_quantity >= 0)
Every customer must have a unique email address.	UNIQUE + NOT NULL	customers.email	email VARCHAR(255) NOT NULL UNIQUE
Every order must belong to an existing customer.	FOREIGN KEY	orders.customer_id	FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
Every product must belong to an existing category.	FOREIGN KEY	products.category_id	FOREIGN KEY (category_id) REFERENCES categories(category_id)*
>
>
>
>

### Task 3: Integrity Violations

For each SQL statement below, predict whether it will **succeed** or **fail**. If it fails, explain which integrity rule or constraint is violated and what error message you'd expect. Assume the schema from Section 9.8 of the Theory material.

```sql
-- Statement A
INSERT INTO categories (category_id, category_name)
VALUES (NULL, 'Cycling');

-- Statement B
INSERT INTO products (product_id, name, price, stock_quantity, category_id)
VALUES (109, 'AeroLite Tent', 279.00, 10, 2);

-- Statement C
INSERT INTO products (product_id, name, price, stock_quantity, category_id)
VALUES (110, 'BudgetBoots', -5.00, 25, 1);

-- Statement D
INSERT INTO products (product_id, name, price, stock_quantity, category_id)
VALUES (103, 'Duplicate Shoes', 99.99, 5, 3);

-- Statement E
INSERT INTO products (product_id, name, price, stock_quantity, category_id)
VALUES (111, 'CloudWalker Sandals', 65.00, 40, 10);

-- Statement F
INSERT INTO products (product_id, name, price, stock_quantity, category_id)
VALUES (112, NULL, 89.99, 20, 1);

-- Statement G
INSERT INTO products (product_id, name, price, stock_quantity, category_id)
VALUES (113, 'LightStep Shoes', 149.00, -3, 1);

-- Statement H
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES (1001, 101, 0, 189.50);
```

> [!NOTE]
> ***Your Answer***
>
> *(A-Fail-category_id is the primary key of categories, so it cannot contain NULL-Column 'category_id' cannot be null
> B-Success
> C-Fail-The price is -5.00, which violates the CHECK constraint requiring the price to be greater than zero-CHECK constraint violated
> D-FAIL-product_id = 103 already exists in the products table-Duplicate entry '103' for key 'PRIMARY'
> E-FAIL-Foreign key category_id = 10-does not exist)*
>F-FAIL-category_id = 10 does not correspond to an existing category. This violates the FOREIGN KEY constraint on products.category_id-update row
> G-FAIL-stock_quantity = -3 violates the CHECK constraint requiring stock quantity to be zero or greater-CHECK constraint violated
> H-FAIL-The quantity is 0, which violates the CHECK constraint requiring an order-item quantity to be greater than zero-CHECK constraint violated
>
>

### Task 4: Foreign Key Actions

Consider the following scenario using the schema from Theory Section 9.8:

1. You want to delete category 2 ("Camping") from the `categories` table. Products 102 and 106 reference this category. What happens with:
   - `ON DELETE RESTRICT`?
   - `ON DELETE CASCADE`?
   - `ON DELETE SET NULL`? (Assume `category_id` in `products` allows NULL for this question)

2. Which foreign key action would you recommend for the TrailShop `products.category_id` → `categories.category_id` relationship? Justify your choice in 2–3 sentences.

> [!NOTE]
> ***Your Answer***
>
> *(I would recommend ON DELETE RESTRICT for the products.category_id → categories.category_id relationship. A category should normally not be deleted while products still depend on it, because automatically deleting products with CASCADE could cause unintended data loss. RESTRICT forces the administrator to move or delete the products explicitly before removing the category.)*
>
>
>
>




---

## Part 2: Theory Review Questions

Answer each question in 2–4 sentences unless otherwise specified. Reference the Theory material sections as needed.

### Short-Answer Questions

**Q1.** Define the following terms in your own words: relation, tuple, attribute, domain. Give one TrailShop example for each.

> [!NOTE]
> ***Your Answer***
>
> *(Relation: A table in a database. Example: the products table.
Tuple: A row in a table. Example: one row describing a specific product.
Attribute: A column in a table. Example: price in the products table.
Domain: The allowed values for an attribute. Example: price can be positive numbers.)*
>
>
>
>

*(See Sections 2 and 3 of this week's Theory material.)*

**Q2.** What makes a candidate key different from a primary key? Can a table have more than one candidate key?


> [!NOTE]
> ***Your Answer***
>
> *(A candidate key is a column or group of columns that can uniquely identify each row. The primary key is the candidate key chosen to be the main key of the table. Yes, a table can have more than one candidate key, but normally only one is selected as the primary key.)*
>
>
>
>

*(See Section 6 of this week's Theory material.)*

**Q3.** Explain entity integrity in your own words. Why can't a primary key be NULL?


> [!NOTE]
> ***Your Answer***
>
> *(Entity integrity means that every row must be uniquely identifiable. A primary key cannot be NULL because NULL does not identify a specific value, so every row must have a known and unique primary key.)*
>
>
>
>

*(See Section 8.1 of this week's Theory material.)*

**Q4.** What happens when referential integrity is violated? Give a concrete TrailShop example — show the SQL statement and the expected error.

> [!NOTE]
> ***Your Answer***
>
> *(Referential integrity prevents a foreign key from referring to a row that does not exist in the parent table.)*
>
>
>
>

*(See Section 8.2 of this week's Theory material.)*

**Q5.** Explain the difference between a surrogate key and a natural key. Give an example of each for a `books` table in a library database.

> [!NOTE]
> ***Your Answer***
>
> *(A surrogate key is an artificial ID created by the database and has no real-world meaning. For a books table, book_id could be a surrogate key.A natural key is a value that already has meaning in the real world. For example, ISBN can be a natural key for a book.)*
>
>
>
>

*(See Section 6.8–6.9 of this week's Theory material.)*

**Q6.** What is a NULL value? Why is `WHERE price = NULL` wrong? What should you write instead?


> [!NOTE]
> ***Your Answer***
>
> *(NULL means that a value is missing, unknown, or not provided. We cannot compare NULL using = because NULL is not an ordinary value.)*
>
>
>
>

*(See Section 7 of this week's Theory material.)*

**Q7.** What is a junction table? When is it needed? Give an example.

> [!NOTE]
> ***Your Answer***
>
> *(A junction table is a table used to connect two tables in a many-to-many (M:N) relationship. For TrailShop, order_items can be a junction table between orders and products. One order can contain many products, and one product can appear in many orders.)*
>
>
>
>

*(See Section 12.3 of this week's Theory material.)*

**Q8.** Describe the three types of relationships (1:1, 1:N, M:N). For each, give one TrailShop example.

> [!NOTE]
> ***Your Answer***
>
> *(1:1 (one-to-one): One row in one table is connected to one row in another table. Example: one customer has one customer profile.
1:N (one-to-many): One row can be connected to many rows. Example: one category can have many products.
M:N (many-to-many): Many rows can be connected to many rows. Example: many orders can contain many products, using order_items.)*
>
>
>
>

*(See Section 12 of this week's Theory material.)*

**Q9.** What is the difference between `ON DELETE CASCADE` and `ON DELETE RESTRICT`? When would you use each?


> [!NOTE]
> ***Your Answer***
>
> *(ON DELETE CASCADE automatically deletes related child rows when the parent row is deleted. It is useful when the child records should not exist without the parent. ON DELETE RESTRICT prevents the parent row from being deleted if child rows still reference it. It is useful when we want to protect important related data from accidental deletion.)*
>
>
>
>

*(See Section 10 of this week's Theory material.)*

**Q10.** Explain what "atomic entries" means in the context of relation properties. Give an example of a violation.

> [!NOTE]
> ***Your Answer***
>
> *(Atomic entries means that each table cell should contain one single value, not a list of values.)*
>
>
>
>

*(See Section 5.3 of this week's Theory material.)*

### True/False

For each statement, write **True** or **False** and correct any false statements.

1. A superkey is always a candidate key. FALSE
2. A primary key can consist of more than one column. TRUE
3. NULL = NULL evaluates to TRUE in SQL.FALSE
4. A foreign key must always be NOT NULL.FALSE
5. Referential integrity ensures that every FK value matches an existing PK value (or is NULL).TRUE
6. The degree of a relation is the number of rows.FALSE

### Matching Exercise

Match each term (1–12) with its definition (A–L).

| # | Term |
|---|---|
| 1 | Superkey |F
| 2 | Candidate key |G
| 3 | Composite key |B
| 4 | Foreign key |H
| 5 | Alternate key |E
| 6 | Surrogate key |D
| 7 | Natural key |J
| 8 | Orphan record |C
| 9 | Domain |A
| 10 | Junction table |K
| 11 | Cardinality |I
| 12 | COALESCE |L

| Letter | Definition |
|---|---|
| A | The set of all permitted values for an attribute |
| B | A key composed of two or more attributes |
| C | A row whose FK references a non-existent PK — forbidden by referential integrity |
| D | An artificial key with no business meaning (e.g., auto-generated ID) |
| E | A candidate key not chosen as the primary key |
| F | Any set of attributes that uniquely identifies every tuple |
| G | A minimal superkey — no attribute can be removed without losing uniqueness |
| H | A column that references the primary key of another table |
| I | The number of tuples (rows) in a relation |
| J | A key drawn from real-world data with business meaning |
| K | A table implementing a many-to-many relationship |
| L | A SQL function that returns the first non-NULL argument |


> [!NOTE]
> ***Your Answers***
>
> | # | Your Match |
> |---|---|
> | 1 |F |
> | 2 | G|
> | 3 | B|
> | 4 | H|
> | 5 | E|
> | 6 | D|
> | 7 | J|
> | 8 | C|
> | 9 | A|
> | 10 | K|
> | 11 | I|
> | 12 | L|
>

---

## Part 3: SQL Practice — Constraints in Action

These exercises test your understanding of constraints. You do NOT need to run these in PostgreSQL (but you may if you'd like to verify your answers).

### Exercise 3.1: Predict the Outcome

Given the following table definitions:

```sql
CREATE TABLE departments (
    dept_id   INTEGER      PRIMARY KEY,
    dept_name VARCHAR(50)  NOT NULL UNIQUE
);

CREATE TABLE employees (
    emp_id    INTEGER       PRIMARY KEY,
    name      VARCHAR(100)  NOT NULL,
    salary    NUMERIC(10,2) NOT NULL CHECK (salary >= 0),
    dept_id   INTEGER       NOT NULL REFERENCES departments(dept_id)
);
```


Assume these rows already exist:

```sql
INSERT INTO departments VALUES (1, 'Engineering');
INSERT INTO departments VALUES (2, 'Marketing');
INSERT INTO employees VALUES (100, 'Alice', 75000, 1);
INSERT INTO employees VALUES (101, 'Bob', 65000, 2);
```

For each statement below, predict: **SUCCESS** or **FAIL**? If fail, name the violated constraint.

```sql
-- 1
INSERT INTO employees VALUES (102, 'Carol', 70000, 1);

-- 2
INSERT INTO employees VALUES (103, 'Dan', -5000, 1);

-- 3
INSERT INTO employees VALUES (100, 'Eve', 80000, 2);

-- 4
INSERT INTO employees VALUES (104, 'Frank', 60000, 5);

-- 5
INSERT INTO departments VALUES (3, 'Engineering');

-- 6
INSERT INTO employees VALUES (105, NULL, 55000, 2);

-- 7
DELETE FROM departments WHERE dept_id = 1;

-- 8
INSERT INTO employees VALUES (106, 'Grace', 0, 2);
```
1-Outcome: SUCCESS
2.Outcome: FAIL, Constraint Violated: CHECK (salary >= 0) (Salary cannot be negative)
3.Outcome: FAIL, Constraint Violated: PRIMARY KEY on employees(emp_id) (Employee ID 100 already belongs to Alice).
4.Outcome: FAIL, Constraint Violated: FOREIGN KEY / REFERENCES departments(dept_id) (Department 5 does not exist)
5.Outcome: FAIL, Constraint Violated: UNIQUE on departments(dept_name) ('Engineering' already exists).
6.Outcome: FAIL, Constraint Violated: NOT NULL on employees(name) Name cannot be empty
7.Outcome: FAIL, Constraint Violated: FOREIGN KEY / REFERENCES (You cannot delete department 1 because Alice is still linked to it).
8.Outcome: SUCCESS
### Exercise 3.2: Write the Constraints

Given these business rules for a **bookstore database**, write the `CREATE TABLE` statements with appropriate constraints:

1. Every book has a unique ISBN (13 characters), a title (required), a price (must be positive), and a publication year.
2. Every author has an ID, a first name (required), and a last name (required).
3. A book can have multiple authors, and an author can write multiple books.
4. Every book belongs to exactly one genre. Genres have an ID and a unique name.
5. Publication year must be between 1450 and the current year.

*(Hint: you'll need at least 4 tables, including a junction table for the M:N relationship.)*

---

## Part 4: Design Exercise — Library System

A small public library needs a database. Here is a description of their requirements:

> The library has a collection of **books**. Each book has an ISBN, a title, a publication year, and belongs to one genre (Fiction, Non-Fiction, Science, History, etc.). The library may own multiple **copies** of the same book — each copy has a unique barcode sticker.
>
> The library has registered **members**. Each member has a member number, name, email, and phone. Members can **borrow** copies. Each borrowing records which member borrowed which copy, the borrow date, the due date, and the return date (NULL if not yet returned).
>
> **Rules:**
> - A member can borrow at most 5 copies at any given time.
> - The due date is always 14 days after the borrow date.
> - A copy cannot be borrowed if it's currently not returned (return_date IS NULL).

### Your Tasks

1. **Identify the tables** you would need (list them with their columns).
2. **Identify the primary key** for each table. Are they surrogate or natural keys? Justify your choices.
3. **Identify all foreign keys** and the tables they reference.
4. **Identify any candidate keys** beyond the primary key (alternate keys).
5. **List the business rules** from the description and map each to a constraint type. Which rules cannot be enforced by simple constraints?


> [!NOTE]
> ***Your Answer***
>
> *(1.genres: genre_id, genre_name

books: isbn, title, pub_year, genre_id

book_copies: barcode, isbn

members: member_id, name, email, phone

borrowings: borrowing_id, member_id, barcode, borrow_date, due_date, return_date

2.genres: genre_id — Surrogate (auto-generated number; faster than searching text names).

books: isbn — Natural (a standard 13-digit identifier that already uniquely identifies books globally).

book_copies: barcode — Natural (the physical barcode sticker uniquely identifies each physical copy).

members: member_id — Surrogate (system-assigned account number to avoid issues with matching names).

borrowings: borrowing_id — Surrogate (auto-generated ID for each borrowing transaction)

3-
4.genres: genre_name (Must be unique so duplicate genres aren't created).

members: email (Must be unique to identify distinct member accounts))*
>
>5.very book copy has a unique barcode-PRIMARY KEY-Yes
Every book belongs to one genre-NOT NULL + FOREIGN KEY-Yes
Due date is 14 days after borrow date-CHECK or DEFAULT calculation-Yes
Cannot borrow a copy if it's currently unreturned-Complex Logic-No (Needs a custom SQL trigger or application logic to check active rows)
>
>
6. **Write the CREATE TABLE statements** for at least the `books`, `copies`, and `borrowings` tables with full constraints.

---CREATE TABLE genres (
    genre_id   SERIAL PRIMARY KEY,
    genre_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE books (
    isbn         CHAR(13) PRIMARY KEY,
    title        VARCHAR(255) NOT NULL,
    pub_year     INTEGER CHECK (pub_year >= 1450 AND pub_year <= 2026),
    genre_id     INTEGER NOT NULL REFERENCES genres(genre_id)
);


CREATE TABLE copies (
    barcode      VARCHAR(50) PRIMARY KEY,
    isbn         CHAR(13) NOT NULL REFERENCES books(isbn) ON DELETE CASCADE
);


CREATE TABLE members (
    member_id    SERIAL PRIMARY KEY,
    name         VARCHAR(100) NOT NULL,
    email        VARCHAR(255) NOT NULL UNIQUE,
    phone        VARCHAR(20)
);

-- 3. Borrowings Table
CREATE TABLE borrowings (
    borrowing_id SERIAL PRIMARY KEY,
    member_id    INTEGER NOT NULL REFERENCES members(member_id),
    barcode      VARCHAR(50) NOT NULL REFERENCES copies(barcode),
    borrow_date  DATE NOT NULL DEFAULT CURRENT_DATE,
    due_date     DATE NOT NULL DEFAULT (CURRENT_DATE + INTERVAL '14 days'),
    return_date  DATE,
    
);

## Submission Checklist

- [ ] Task 1: Key identification answers (Part 1)
- [ ] Task 2: Business rules table with 5 rules (Part 1)
- [ ] Task 3: Integrity violation predictions with explanations (Part 1)
- [ ] Task 4: Foreign key action analysis (Part 1)
- [ ] Theory Review Questions answered (Part 2)
- [ ] SQL Practice — constraint predictions and bookstore CREATE TABLE (Part 3)
- [ ] Library System design exercise (Part 4)

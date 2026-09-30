# Week 39 — Logical Database Design: Exercises

> [!IMPORTANT]
> ***How to Complete These Exercises***
> Write your answers directly in the highlighted **Your Answer** / **Your SQL** fields below each task. Replace the placeholder text with your own work before submitting.

These exercises accompany the Week 39 Theory material. Refer to the theory sections indicated in brackets when you need help.

---

## Exercise 1: TrailShop Project Task — Build the Schema

**Goal:** Convert the TrailShop ER diagram (from Week 38) into a complete PostgreSQL relational schema.

### Instructions

Write `CREATE TABLE` statements for all five TrailShop tables:

1. `categories`
2. `customers`
3. `products`
4. `orders`
5. `order_items`

### Requirements

For each table, you must:

- Choose appropriate PostgreSQL data types for every column (justify at least 3 choices in writing)
- Define primary keys (surrogate or composite as appropriate)
- Define foreign keys with explicit `ON DELETE` and `ON UPDATE` actions (justify each choice)
- Add `NOT NULL`, `UNIQUE`, `CHECK`, and `DEFAULT` constraints where appropriate
- Create tables in the correct dependency order
- Follow the naming conventions from Theory Section 8

### Deliverables

1. A single `.sql` file with all five `CREATE TABLE` statements (executable in PostgreSQL)
2. A short written document (1–2 pages) containing:
   - Justification for 3 data type choices (e.g., why `NUMERIC(10,2)` for price instead of `REAL`)
   - Justification for each FK action choice (e.g., why CASCADE on `order_items.order_id`)
   - One design decision you made that wasn't specified in the requirements (e.g., whether shipping address is optional)

### Bonus Challenge

After creating the tables, insert sample data:
- At least 5 categories
- At least 8 products (across at least 3 categories)
- At least 3 customers
- At least 4 orders (across at least 2 customers)
- At least 10 order items

Verify that your constraints work by attempting at least 2 invalid inserts and showing the error messages.

> [!NOTE]
> ***Your SQL***
>
> ```sql
> -- Paste key CREATE TABLE statements or link to your .sql file contents here
>
>
> ```

> [!NOTE]
> ***Your Answer***
>
> *(Paste written justifications for data types, FK actions, and design decisions here.)*
>
>
>
>

## Exercise 2: Theory Review Questions

Answer each question in 2–4 sentences. Reference the relevant theory section.

1. List the seven phases of the database development lifecycle in order. Which phase is this week's focus? *(Section 1)*

> [!NOTE]
> ***Your Answer***
>
> *(The seven phases are: (1) requirements analysis, (2) conceptual design (ER modelling), (3) logical design, (4) physical design, (5) implementation, (6) testing and evaluation, and (7) deployment and maintenance. This week's focus is logical design, where the ER diagram is converted into a relational schema (tables, columns, keys and constraints) independent of a specific storage implementation.)*
>
>
>
>

2. Explain the transformation rule for mapping a 1:N relationship to the relational model. Why is the foreign key placed on the "many" side? *(Section 3.2)*

> [!NOTE]
> ***Your Answer***
>
> *(To map a 1:N relationship, take the primary key of the "one" side and add it as a foreign key column in the table on the "many" side. The FK goes on the "many" side because each row there relates to at most one row on the "one" side, so a single column can hold that reference. Putting it on the "one" side would require storing multiple values in one column, violating first normal form.)*
>
>
>
>

3. What is a junction table? When is it needed? Give an example not from TrailShop. *(Section 3.3)*

> [!NOTE]
> ***Your Answer***
>
> *(A junction table (also called a bridge or associative table) implements an M:N relationship by holding foreign keys to both related tables, usually as a composite primary key, plus any attributes of the relationship. It is needed because relational tables cannot directly represent M:N relationships. Example: in a university, students and courses are M:N, so an enrollments table has (student_id, course_id, enrolled_on, grade).)*
>
>
>
>

4. When mapping a 1:1 relationship, how do you decide which table gets the foreign key? *(Section 3.4)*

> [!NOTE]
> ***Your Answer***
>
> *(Place the foreign key in the table that has total (mandatory) participation or that is the dependent side, so the FK can be NOT NULL and you avoid many NULLs. Add a UNIQUE constraint on the FK to enforce the 1:1 cardinality. If both sides are mandatory and always accessed together, the two tables may be merged into one.)*
>
>
>
>

5. How does the mapping of a weak entity differ from a strong entity? What happens to the primary key? *(Section 3.5)*

> [!NOTE]
> ***Your Answer***
>
> *(A weak entity has no key of its own, so it is mapped to a table that includes the primary key of its owner (strong) entity as a foreign key. Its primary key is a composite of the owner's PK and the weak entity's partial key. The FK to the owner is typically ON DELETE CASCADE, because the weak entity cannot exist without its owner.)*
>
>
>
>

6. Why should you never use `REAL` or `DOUBLE PRECISION` for monetary values? What should you use instead? *(Section 4.1)*

> [!NOTE]
> ***Your Answer***
>
> *(REAL and DOUBLE PRECISION are approximate binary floating-point types, so many decimal values (like 0.1) cannot be stored exactly and rounding errors accumulate, for example 0.1 + 0.2 is not exactly 0.3. For money you should use NUMERIC(p,s) (or DECIMAL), which stores exact decimal values, such as NUMERIC(10,2).)*
>
>
>
>

7. What is the difference between `TIMESTAMP` and `TIMESTAMPTZ`? Which should you prefer and why? *(Section 4.3)*
> [!NOTE]
> ***Your Answer***
>
> *(TIMESTAMP (without time zone) stores a date and time exactly as given, with no zone information. TIMESTAMPTZ converts input to UTC for storage and converts to the session time zone on output, so it represents an unambiguous moment in time. You should prefer TIMESTAMPTZ for almost all event times, since it handles users in different time zones and daylight saving changes correctly.)*
>




8. Explain the difference between `CASCADE` and `RESTRICT` as foreign key delete actions. Give a scenario where each is appropriate. *(Section 6)*
> [!NOTE]
> ***Your Answer***
>
> *(CASCADE automatically deletes (or updates) the child rows when the parent row is deleted (or its key changed). RESTRICT blocks the deletion of the parent while child rows still reference it. CASCADE is appropriate for order_items when an order is deleted, because the items belong to the order. RESTRICT is appropriate for orders.customer_id, because you do not want to lose order history by deleting a customer.)*
>




9. What is an insertion anomaly? Give an example and explain how proper schema design prevents it. *(Section 7)*
> [!NOTE]
> ***Your Answer***
>
> *(An insertion anomaly occurs when you cannot add certain data without also adding unrelated data, because too much is stored in one table. For example, in a single orders table holding customer and product details, you cannot add a new product until someone orders it. Proper design (normalisation) separates entities into their own tables (products, customers, orders) linked by foreign keys, so each fact is stored once and can be inserted independently.)*
>




10. What is the difference between a surrogate key and a natural key? Give one advantage of each. *(Section 9)*
> [!NOTE]
> ***Your Answer***
>
> *(A natural key is an existing real-world attribute that identifies a row (e.g. email, ISBN, passport number), while a surrogate key is an artificial identifier generated by the database with no business meaning (e.g. an identity integer). A natural key's advantage is that it is meaningful and can enforce real-world uniqueness without an extra column. A surrogate key's advantage is that it is stable (never changes), compact, and fast for joins and foreign keys.)*
>




11. Why does PostgreSQL fold unquoted identifiers to lowercase? How does `snake_case` naming help? *(Section 8)*

> [!NOTE]
> ***Your Answer***
>
> *(PostgreSQL folds unquoted identifiers to lowercase (following the SQL standard's case-insensitivity for identifiers, with PostgreSQL choosing lowercase), so CustomerName and customername refer to the same column. If you create a name with double quotes and mixed case, you must quote it every time. Using snake_case (e.g. customer_name) avoids this problem, since it is already lowercase, stays readable, and never needs quoting.)*
>
>
>
>

12. What does `SET NULL` do as a foreign key action? When would you use it instead of `CASCADE`? *(Section 6)*
> [!NOTE]
> ***Your Answer***
>
> *(ON DELETE SET NULL sets the foreign key column of the child rows to NULL when the parent is deleted, keeping the child rows but removing the link. It requires the FK column to be nullable. Use it instead of CASCADE when the child rows have value on their own, e.g. when a department is deleted, employees should remain in the database and just become unassigned.)*
>



---

## Exercise 3: Transformation Exercise — Hotel Booking System

### Given ER Diagram

A hotel booking system has the following entities and relationships:

**Entities:**

1. **Hotel** — hotel_id (PK), name, city, star_rating, phone
2. **Room** (weak entity, owned by Hotel) — room_number (partial key), room_type, floor, price_per_night, has_balcony
3. **Guest** — guest_id (PK), first_name, last_name, email, phone, passport_number
4. **Booking** — booking_id (PK), check_in_date, check_out_date, total_amount, status
5. **Service** — service_id (PK), name, description, price (e.g., "Room Service", "Spa", "Airport Shuttle")

**Relationships:**

- Hotel (1) → Room (N): A hotel has many rooms. Each room belongs to exactly one hotel. (Identifying relationship — Room is weak.)
- Guest (1) → Booking (N): A guest can make many bookings. Each booking belongs to one guest.
- Booking (M) ↔ Room (N): A booking can include multiple rooms, and a room can appear in many bookings (over time). The junction records the specific dates.
- Booking (M) ↔ Service (N): A booking can use multiple services, and a service can be used by many bookings. The junction records the date used and quantity.

### Task

1. Write `CREATE TABLE` statements for ALL tables (including junction tables).
2. For each table:
   - Choose appropriate data types
   - Define PK, FK, NOT NULL, UNIQUE, CHECK, and DEFAULT constraints
   - Specify ON DELETE and ON UPDATE actions for all FKs
3. Create the tables in the correct dependency order.
4. Explain why Room is a weak entity and how its PK reflects this.

> [!NOTE]
> ***Your SQL***
>
> ```sql
> -- 
>
>
> ```

> [!NOTE]
> ***Your Answer***
>
> *(Room is a weak entity because it cannot be identified on its own. A room number like "101" or "204" is not unique across the system, since almost every hotel has a room 101. A room only means something in the context of the hotel that owns it. Room also depends on Hotel for its existence: if the hotel is removed, its rooms no longer make sense. The Hotel-Room relationship is therefore an identifying relationship.
> A strong entity like hotels has its own primary key (hotel_id). A weak entity has only a partial key (room_number), which is unique only within one hotel. To get a full identifier, the table combines the owner's primary key with the partial key, giving the composite primary key PRIMARY KEY (hotel_id, room_number). Here hotel_id is both part of the primary key and a foreign key to hotels, and room_number is the partial key. The foreign key uses ON DELETE CASCADE because a room cannot exist without its hotel.

The composite key also affects the tables that reference rooms. booking_rooms needs a composite foreign key (hotel_id, room_number) to identify a single room. That is why it stores both columns.)*
>
>
>
>

---

## Exercise 4: Data Type Selection

> [!NOTE]
> ***Your Answers***
> Fill in the **Your Data Type** and **Justification** columns in the table below.
>

For each column described below, choose the best PostgreSQL data type and write a brief justification (1–2 sentences). Do NOT just pick `VARCHAR` or `TEXT` for everything — think carefully about validation, storage, and query needs.

| # | Column Description | Your Data Type | Justification |
|---|---|---|---|
| 1 | Employee salary (exact, up to €999,999.99) |NUMERIC(8,2) |Money must be exact; 8 digits total with 2 decimals covers up to 999,999.99. Floating-point types would introduce rounding errors. |
| 2 | Number of items in stock (never negative, max ~50,000) |INTEGER with CHECK (stock >= 0) | A whole number that fits easily in INTEGER (SMALLINT max is 32,767, too small). The CHECK enforces "never negative".|
| 3 | Whether a user's email is verified |BOOLEAN |A true/false flag; it is the most compact and clear type, usually with DEFAULT false. |
| 4 | Customer's date of birth |DATE | Only the calendar date is needed, not the time. DATE supports date arithmetic (e.g. calculating age).|
| 5 | Product description (variable length, could be several paragraphs) | TEXT| 	Unbounded variable-length text.|
| 6 | Country code (always exactly 2 letters, like "FI", "US") |CHAR(2) |Fixed length of exactly 2 characters |
| 7 | IP address of a login attempt |INET | 	Native network address type that validates IPv4/IPv6 format and supports network operators and subnet queries.|
| 8 | Order total (exact, up to €9,999,999.99) |NUMERIC(9,2) | Exact decimal for money; 9 digits with 2 decimals covers up to 9,999,999.99.|
| 9 | GPS latitude of a store location | NUMERIC(9,6)| |
| 10 | A unique identifier for API tokens that must be globally unique across distributed systems | |UUID |128-bit identifier designed to be globally unique without central coordination; stored compactly (16 bytes) and generated with gen_random_uuid()
| 11 | Duration of a video in seconds (always a whole number) | INTEGER|Whole-number seconds fit comfortably (max about 2.1 billion seconds = 68 years). Could add CHECK (duration_seconds >= 0). |
| 12 | Timestamp of when a record was last modified (users in multiple time zones) | | |
| 13 | A Finnish phone number like "+358 40 123 4567" |VARCHAR(20) | Phone numbers are identifiers, not numbers to calculate with. |
| 14 | A percentage discount (0.00% to 100.00%) |NUMERIC(5,2) with CHECK (discount BETWEEN 0 AND 100) | 5 digits with 2 decimals covers 0.00 to 100.00 exactly; the CHECK restricts the range.|
| 15 | A product's color options (e.g., a product comes in "red", "blue", "green") |Separate product_colors table (or TEXT[] array / ENUM for a simple case) |A product can have several colors, so storing them in one column would violate first normal form. |

---

## Exercise 5: Constraint Design

For each business rule below, write the appropriate PostgreSQL constraint. Provide the constraint as it would appear inside a `CREATE TABLE` statement or as an `ALTER TABLE` statement.

### Part A: Single-Column Constraints

1. "A product's weight must be greater than zero (if provided)."

2. "Every customer must have an email address."

3. "Product names must be unique."

4. "An employee's hire date defaults to today if not specified."

5. "Order status can only be one of: 'new', 'confirmed', 'shipped', 'delivered', 'returned'."

> [!NOTE]
> ***Your SQL***
>
> ```sql
> -- Write constraints 1–5 here
> -- 1. 
weight_kg NUMERIC(6,2) CHECK (weight_kg > 0)
-- or as ALTER TABLE:
ALTER TABLE products ADD CONSTRAINT ck_products_weight CHECK (weight_kg > 0);

-- 2.
email VARCHAR(255) NOT NULL
-- or:
ALTER TABLE customers ALTER COLUMN email SET NOT NULL;

-- 3. 
name VARCHAR(200) UNIQUE
-- or:
ALTER TABLE products ADD CONSTRAINT uq_products_name UNIQUE (name);

-- 4. 
hire_date DATE NOT NULL DEFAULT CURRENT_DATE
-- or:
ALTER TABLE employees ALTER COLUMN hire_date SET DEFAULT CURRENT_DATE;

-- 5. 
status VARCHAR(20) NOT NULL
    CHECK (status IN ('new', 'confirmed', 'shipped', 'delivered', 'returned'))
>
>
> ```

### Part B: Multi-Column Constraints

6. "A flight's arrival time must be after its departure time."

7. "In the `enrollments` table, the combination of `student_id` and `course_id` must be unique (a student can only enroll in a course once)."

8. "A discount percentage must be between 0 and 100, inclusive."

> [!NOTE]
> ***Your SQL***
>
> ```sql
> -- Write constraints 6–8 here
> -- 6. 
CONSTRAINT ck_flights_times CHECK (arrival_time > departure_time)
-- or:
ALTER TABLE flights ADD CONSTRAINT ck_flights_times
    CHECK (arrival_time > departure_time);

-- 7.
CONSTRAINT uq_enrollments_student_course UNIQUE (student_id, course_id)
-- (or make it the composite primary key: PRIMARY KEY (student_id, course_id))
-- or:
ALTER TABLE enrollments ADD CONSTRAINT uq_enrollments_student_course
    UNIQUE (student_id, course_id);

-- 8. 
discount_percent NUMERIC(5,2) CHECK (discount_percent BETWEEN 0 AND 100)
>
>
> ```

### Part C: Foreign Key Constraints with Actions

9. "When a department is deleted, all employees in that department should have their `department_id` set to NULL (they become unassigned)."

10. "When a customer is deleted, prevent the deletion if the customer has any orders."

11. "When an author is deleted, all their blog posts should be deleted automatically."

12. "When a course is deleted, all enrollments for that course should be removed."

> [!NOTE]
> ***Your SQL***
>
> ```sql
> -- Write constraints 9–12 here
>-- 9. 
--    (department_id must be nullable)
ALTER TABLE employees ADD CONSTRAINT fk_employees_department
    FOREIGN KEY (department_id) REFERENCES departments (department_id)
    ON DELETE SET NULL;

-- 10. 
ALTER TABLE orders ADD CONSTRAINT fk_orders_customer
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
    ON DELETE RESTRICT;

-- 11. 
ALTER TABLE blog_posts ADD CONSTRAINT fk_blog_posts_author
    FOREIGN KEY (author_id) REFERENCES authors (author_id)
    ON DELETE CASCADE;

-- 12. 
ALTER TABLE enrollments ADD CONSTRAINT fk_enrollments_course
    FOREIGN KEY (course_id) REFERENCES courses (course_id)
    ON DELETE CASCADE;
>
> ```

---

## Submission Checklist

- [ ] Exercise 1: `.sql` file with all CREATE TABLE statements + written justifications
- [ ] Exercise 2: All 12 theory review answers
- [ ] Exercise 3: Hotel booking schema with all tables and explanations
- [ ] Exercise 4: Data type selections with justifications for all 15 columns
- [ ] Exercise 5: All 12 constraints written in valid PostgreSQL syntax

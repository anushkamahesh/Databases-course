Week 45 — Normalization: Exercises
Important

How to Complete These Exercises Write your answers directly in the highlighted Your Answer / Your SQL fields below each task. Replace the placeholder text with your own work before submitting.

1. TrailShop Project Task
Task 1.1: Analyze a Denormalized Table
Consider this denormalized table that TrailShop's old system used:

supplier_products(
    supplier_id, supplier_name, supplier_email, supplier_city,
    product_id, product_name, category_id, category_name,
    supply_price, lead_time_days
)
Sample data:

supplier_id	supplier_name	supplier_email	supplier_city	product_id	product_name	category_id	category_name	supply_price	lead_time_days
1	NordGear Oy	info@nordgear.fi	Helsinki	101	Trail Runner X	10	Footwear	45.00	7
1	NordGear Oy	info@nordgear.fi	Helsinki	102	Summit Boot	10	Footwear	62.00	7
2	OutdoorPro AB	sales@outdoorpro.se	Stockholm	201	Rain Jacket Pro	30	Clothing	55.00	14
2	OutdoorPro AB	sales@outdoorpro.se	Stockholm	101	Trail Runner X	10	Footwear	43.00	10
Tasks:

Identify the primary key of this table.
[!NOTE] Your SQL

The primary key is the composite key (supplier_id, product_id). Each row describes one supplier supplying one product, and supply_price and lead_time_days are specific to that pair (e.g. product 101 costs 45.00 from NordGear but 43.00 from OutdoorPro).

Identify any insertion, update, and deletion anomalies (give specific examples).
[!NOTE] Your SQL

-- INSERTION anomalies
--   A new supplier cannot be added until they supply at least one product,
--    because product_id is part of the primary key and cannot be NULL.
--   A new product or category (e.g. "Backpacks") cannot be stored
--    until some supplier supplies it.
-- UPDATE anomalies
--  *NordGear's email is stored in 2 rows (supplier 1). Changing it in one row
--    but not the other leaves contradictory data.
--   "Trail Runner X" (product 101) appears in rows 1 and 4. Renaming it
--    requires updating every row, and "Footwear" is repeated in 3 rows.
---- DELETION anomalies
--  * If OutdoorPro stops supplying Rain Jacket Pro (delete row 3), we lose
--    product 201 and the whole "Clothing" category, since this was the only
--    row that mentioned them.
--  * Deleting a supplier's last product row also deletes the supplier's
--    contact information.

Normalize this table to 3NF. Show each step (1NF, then 2NF, then 3NF) with the resulting tables.
[!NOTE] Your SQL

-- STEP 1: 1NF
-- Already in 1NF: all values are atomic, there are no repeating groups,
-- and there is a primary key (supplier_id, product_id).
-- supplier_products(supplier_id, supplier_name, supplier_email, supplier_city,
--                   product_id, product_name, category_id, category_name,
--                   supply_price, lead_time_days)

-- STEP 2: 2NF (remove partial dependencies)
-- supplier_id -> supplier_name, supplier_email, supplier_city
-- product_id  -> product_name, category_id, category_name
-- (supplier_id, product_id) -> supply_price, lead_time_days   (full dependency)
--
-- Result:
-- suppliers(supplier_id PK, supplier_name, supplier_email, supplier_city)
-- products(product_id PK, product_name, category_id, category_name)
-- supplier_products(supplier_id, product_id, supply_price, lead_time_days)
--                   PK (supplier_id, product_id)

-- STEP 3: 3NF (remove transitive dependencies)
-- In products: product_id -> category_id -> category_name
-- category_name depends on category_id, which is not the key, so split it out.
--
-- Final result:
-- suppliers(supplier_id PK, supplier_name, supplier_email, supplier_city)
-- categories(category_id PK, category_name)
-- products(product_id PK, product_name, category_id FK)
-- supplier_products(supplier_id FK, product_id FK, supply_price, lead_time_days)
--                   PK (supplier_id, product_id)

Task 1.2: Review Your Existing TrailShop Schema
For each table, confirm it is in 3NF by verifying:
No partial dependencies (check tables with composite keys or surrogate keys)
No transitive dependencies
[!NOTE] Your SQL

--TODO: replace the rows below with YOUR actual TrailShop tables.

Explain why unit_price in order_items is NOT a normalization violation.
[!NOTE] Your SQL

---- products.price is the CURRENT price and can change over time.
-- order_items.unit_price is a snapshot of the price the customer actually
-- paid when the order was placed. It is a fact about that specific order line,
-- so it depends on the order_items key, not on product_id alone.
-- It cannot be derived from products (the price may have changed since),
-- so it is not redundant data and does not break 3NF.

Task 1.3: Add a Suppliers Table (Optional Extension)
You may skip this task. Suppliers are not part of the TrailShop project schema.

If TrailShop wanted to track suppliers:

Design a normalized schema that includes suppliers. Consider:
Each product can have multiple suppliers
Each supplier offers different prices and lead times
Each supplier has contact info (name, email, city)
Write the CREATE TABLE statements.
[!NOTE] Your SQL

-- Write your query here

Verify your design is in 3NF.
Note

Your Answer

(Write your answer here.)

2. Theory Review Questions
Answer in your own words (2–4 sentences each):

What is normalization, and what problem does it solve?
Note

Your Answer

(Normalization is the process of organizing data into well-structured tables by following the normal forms, so each fact is stored in exactly one place. It solves data redundancy and the insertion, update, and deletion anomalies that come with it, which keeps the data consistent.)

Explain the difference between an insertion anomaly and a deletion anomaly, using an example.
Note

Your Answer

(An insertion anomaly means you cannot record one fact without also recording another unrelated fact, e.g. you cannot add a new supplier until they supply a product. A deletion anomaly means deleting one fact unintentionally destroys another, e.g. deleting the only row for a product also removes the supplier's contact details.)

What is the difference between a partial dependency and a transitive dependency?
Note

Your Answer

(A partial dependency is when a non-key attribute depends on only part of a composite key, such as supplier_id -> supplier_name in the key (supplier_id, product_id). A transitive dependency is when a non-key attribute depends on another non-key attribute, such as product_id -> category_id -> category_name)

State the "informal rule" for 3NF. Explain what each part means.
Note

Your Answer

("Every non-key attribute must depend on the key, the whole key, and nothing but the key." The key: a key exists and values are atomic (1NF). The whole key: no attribute depends on just part of a composite key (2NF). Nothing but the key: no attribute depends on another non-key attribute (3NF).)

Why can partial dependencies only occur in tables with composite primary keys?
Note

Your Answer

(A partial dependency means depending on only a part of the key. A single-column key has no smaller part, so every non-key attribute automatically depends on the whole key. Only a composite key can have a proper subset to depend on.)

What is BCNF, and how does it differ from 3NF? In what rare case can a table be in 3NF but not BCNF?
Note

Your Answer

(BCNF requires that for every non-trivial functional dependency X -> Y, X is a superkey. 3NF is more lenient and allows Y to be part of a candidate key even if X is not a superkey. A table can be in 3NF but not BCNF when it has overlapping candidate keys, e.g. (student, course, teacher) where each teacher teaches only one course: teacher -> course, but teacher is not a superkey.)

Give two legitimate reasons to denormalize a database.
Note

Your Answer

(First, read performance: in reporting or analytics systems, joining many tables can be too slow, so storing precomputed or duplicated data speeds up queries. Second, keeping historical snapshots: for example, storing the price at the time of purchase in order_items so past orders stay correct even when product prices change.)

3. Normalization Exercise (Optional)
Tip

Recommended practice. Do this section. It is not required to finish the TrailShop project. It prepares you for the exams.

Normalize each table to 3NF. Show your work for each step.

Table 1: event_registrations
event_id	event_name	event_date	venue_id	venue_name	venue_city	attendee_id	attendee_name	ticket_type	ticket_price
E1	Trail Run 2025	2025-06-15	V1	City Park Arena	Helsinki	A1	Matti Aho	VIP	75.00
E1	Trail Run 2025	2025-06-15	V1	City Park Arena	Helsinki	A2	Sara Lund	Standard	35.00
E2	Mountain Fest	2025-07-20	V2	Summit Center	Tampere	A1	Matti Aho	Standard	40.00
Business rules:

Each event has one name, date, and venue.
Each venue has one name and city.
Each attendee has one name.
Ticket price depends on the event and ticket type combination.
Steps:

Identify the PK
[!NOTE] Your SQL

-- Write your query here

Check 1NF, 2NF, 3NF
Decompose as needed
Write final CREATE TABLE statements
[!NOTE] Your SQL

-- Write your query here

Table 2: store_inventory
store_id	store_name	store_city	product_id	product_name	category	quantity	reorder_level	supplier_name
S1	TrailShop Helsinki	Helsinki	101	Trail Runner X	Footwear	50	10	NordGear Oy
S1	TrailShop Helsinki	Helsinki	201	Rain Jacket Pro	Clothing	20	5	OutdoorPro AB
S2	TrailShop Tampere	Tampere	101	Trail Runner X	Footwear	30	8	NordGear Oy
Business rules:

Each store has one name and city.
Each product has one name, category, and supplier.
Quantity and reorder_level depend on the specific store-product combination.
Steps: Same as above.

4. True/False
For each statement, write TRUE or FALSE and briefly explain why.

A table with a single-column primary key can violate 2NF.
If a table is in 3NF, it is automatically in 2NF.
Normalization always improves query performance.
Storing a customer's current address in the orders table is always a normalization violation.
BCNF is stricter than 3NF — every table in BCNF is also in 3NF.
Denormalization should be done before normalization to save time.
Submission Checklist
Required

 Existing TrailShop schema reviewed and confirmed in 3NF (Task 1.2)
 Theory review questions answered
 True/False questions answered with a short explanation
Recommended practice

 Denormalized supplier_products table analyzed and normalized (Task 1.1)
 Normalization exercise completed for both tables
Optional extension

 Suppliers schema designed (Task 1.3) — you may skip this

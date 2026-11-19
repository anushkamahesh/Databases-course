Week 47 — Exercises: Indexes and Query Performance
Important

How to Complete These Exercises Write your answers directly in the highlighted Your Answer / Your SQL fields below each task. Replace the placeholder text with your own work before submitting.

These exercises walk you through measuring, creating, and evaluating indexes on your TrailShop database. You will use PostgreSQL's EXPLAIN ANALYZE to gather real execution data and make evidence-based decisions about indexing.

1. TrailShop Project Task
Step 1 — Baseline Measurement
Before creating any indexes, run EXPLAIN ANALYZE on the following five queries. For each, record the scan type, execution time (ms), and rows removed by filter.

-- Query A: Find a product by name
SELECT * FROM products WHERE name = 'Trail Runner Pro 3';

-- Query B: Get all items for a specific order
SELECT * FROM order_items WHERE order_id = 42;

-- Query C: Get all orders for a customer
SELECT * FROM orders WHERE customer_id = 7;

-- Query D: Get products in a category
SELECT * FROM product_categories WHERE category_id = 3;

-- Query E: Join order_items to products
SELECT oi.quantity, p.name, p.price
FROM order_items oi
JOIN products p ON p.id = oi.product_id
WHERE oi.order_id = 42;
Record your results in a table like this:

Query	Scan Type	Exec Time (ms)	Rows Removed by Filter
A			
B			
C			
D			
E			
Step 2 — Create Indexes
Now create the following indexes:

CREATE INDEX idx_product_name ON products (name);
CREATE INDEX idx_order_item_order_id ON order_items (order_id);
CREATE INDEX idx_order_item_product_id ON order_items (product_id);
CREATE INDEX idx_orders_customer_id ON orders (customer_id);
CREATE INDEX idx_product_categories_category_id ON product_categories (category_id);
Step 3 — Re-measure
Because the project database is so small, the PostgreSQL optimizer will most likely default to Seq Scan even after creating indexes.

You can force PostgreSQL to use indexes by disabling the Seq scan using following commands:

--- Turn the seq scan off
SET enable_seqscan = OFF;

--- Turn the seq scan back on
SET enable_seqscan = ON;
Run the same five queries with EXPLAIN ANALYZE again. Fill in your comparison table:

Query	Before Scan	Before Time (ms)	After Scan	After Time (ms)	Improvement Factor
A					
B					
C					
D					
E					
Step 4 — Recommendation
Write a paragraph (4–6 sentences) recommending which indexes to keep in production and why. Consider table size, query frequency, and write overhead. If any index showed minimal improvement, explain why you might drop it.

Note

Your Answer

(Write your answer here.)

2. Theory Review
Answer the following questions in your own words. See the corresponding theory sections for reference.

Question 1 — What is a database index, and why is it needed? (See Theory Section 1)

Note

Your Answer

(Write your answer here.)

Question 2 — Explain the difference between B-tree search at O(log n) and sequential scan at O(n). If a table has 1,000,000 rows, approximately how many comparisons does each approach need? (See Theory Section 2)

Note

Your Answer

(Write your answer here.)

Question 3 — PostgreSQL automatically creates indexes on primary keys. Why doesn't it also auto-index foreign key columns? (See Theory Section 3)

Note

Your Answer

(Write your answer here.)

Question 4 — What is the difference between an Index Scan and an Index Only Scan? When can PostgreSQL use Index Only Scan? (See Theory Section 4)

Note

Your Answer

(Write your answer here.)

Question 5 — Give three situations where you should NOT create an index. Explain each briefly. (See Theory Section 5)

Note

Your Answer

(Write your answer here.)

Question 6 — What does EXPLAIN ANALYZE show that plain EXPLAIN does not? Why does this matter? (See Theory Section 6)

Note

Your Answer

(Write your answer here.)

Question 7 — What is a partial index? Give one concrete example where a partial index on a TrailShop table would be useful. (See Theory Section 7)

Note

Your Answer

(Write your answer here.)

Question 8 — What is the leftmost prefix rule for multi-column indexes? If you create CREATE INDEX idx ON orders (customer_id, order_date), which of the following queries can use the index and why?

-- a)
SELECT * FROM orders WHERE customer_id = 5;
-- b)
SELECT * FROM orders WHERE order_date = '2026-01-15';
-- c)
SELECT * FROM orders WHERE customer_id = 5 AND order_date = '2026-01-15';
(See Theory Section 8)

Note

Your Answer

(Write your answer here.)

3. EXPLAIN Reading Exercise (Optional)
Tip

Recommended practice. Do this section. It is not required to finish the TrailShop project. It prepares you for the exams.

Below are four EXPLAIN ANALYZE outputs. For each one, identify:

The scan type used
Estimated rows vs actual rows
Total execution time
Whether an index would help (and which column to index)
Output A — Sequential Scan
Seq Scan on products  (cost=0.00..25.00 rows=5 width=72) (actual time=0.015..0.285 rows=3 loops=1)
  Filter: (category_id = 4)
  Rows Removed by Filter: 497
Planning Time: 0.065 ms
Execution Time: 0.312 ms
Your analysis:

Scan type:
Estimated vs actual rows:
Execution time:
Would an index help? Which one?
Note

Your Answer

(Write your answer here.)

Output B — Index Scan
Index Scan using idx_orders_customer_id on orders  (cost=0.28..8.30 rows=1 width=48) (actual time=0.021..0.024 rows=4 loops=1)
  Index Cond: (customer_id = 12)
Planning Time: 0.082 ms
Execution Time: 0.041 ms
Your analysis:

Scan type:
Estimated vs actual rows:
Execution time:
Is the index effective here?
Note

Your Answer

(Write your answer here.)

Output C — Bitmap Index Scan
Bitmap Heap Scan on order_items  (cost=4.32..35.76 rows=25 width=24) (actual time=0.045..0.098 rows=28 loops=1)
  Recheck Cond: (product_id = 15)
  Heap Blocks: exact=12
  ->  Bitmap Index Scan on idx_order_item_product_id  (cost=0.00..4.31 rows=25 width=0) (actual time=0.030..0.030 rows=28 loops=1)
        Index Cond: (product_id = 15)
Planning Time: 0.091 ms
Execution Time: 0.132 ms
Your analysis:

Scan type:
Estimated vs actual rows:
Execution time:
Why did PostgreSQL choose a Bitmap scan instead of a plain Index Scan?
Note

Your Answer

(Write your answer here.)

Output D — Hash Join
Hash Join  (cost=33.50..75.82 rows=120 width=52) (actual time=0.452..1.205 rows=115 loops=1)
  Hash Cond: (oi.product_id = p.id)
  ->  Seq Scan on order_items oi  (cost=0.00..30.40 rows=2040 width=16) (actual time=0.008..0.195 rows=2040 loops=1)
  ->  Hash  (cost=20.00..20.00 rows=500 width=40) (actual time=0.410..0.411 rows=500 loops=1)
        Buckets: 1024  Batches: 1  Memory Usage: 45kB
        ->  Seq Scan on products p  (cost=0.00..20.00 rows=500 width=40) (actual time=0.005..0.180 rows=500 loops=1)
Planning Time: 0.215 ms
Execution Time: 1.340 ms
Your analysis:

Scan type:
Estimated vs actual rows:
Execution time:
Would adding an index improve this join? Which column?
Note

Your Answer

(Write your answer here.)

4. Index Design Exercise (Optional)
Tip

Recommended practice. Do this section. It is not required to finish the TrailShop project. It prepares you for the exams.

For each query below, recommend the best index(es), explain why, and predict the scan type PostgreSQL will use after indexing.

Query 1

SELECT * FROM customers WHERE email = 'anna.korhonen@email.fi';
Query 2

SELECT * FROM orders WHERE customer_id = 5 ORDER BY order_date DESC;
Query 3

SELECT product_id, SUM(quantity) FROM order_items GROUP BY product_id;
Query 4

SELECT * FROM products WHERE price BETWEEN 50 AND 100;
Query 5

SELECT p.name, c.name AS category
FROM products p
JOIN product_categories pc ON pc.product_id = p.product_id
JOIN categories c ON c.category_id = pc.category_id
WHERE pc.category_id = 2;
Query 6

SELECT * FROM payments WHERE order_id = 88;
Query 7

SELECT * FROM orders WHERE status = 'shipped' AND order_date > '2026-06-01';
Query 8

SELECT customer_id, COUNT(*) FROM orders GROUP BY customer_id HAVING COUNT(*) > 5;
Query 9

SELECT oi.quantity, p.name
FROM order_items oi
JOIN products p ON p.id = oi.product_id
WHERE oi.order_id = 100;
Query 10

SELECT * FROM products WHERE name LIKE 'Trail%';
For each query, fill in:

#	Recommended Index	Why It Helps	Expected Scan Type
1			
2			
3			
4			
5			
6			
7			
8			
9			
10			
5. Performance Comparison Exercise
Tip

Recommended practice. Do this section. It is not required to finish the TrailShop project. It prepares you for the exams.

For each query below, follow these steps:

Run EXPLAIN ANALYZE without an index — record the full output
Create the recommended index
Run EXPLAIN ANALYZE again — record the full output
Calculate the improvement factor (before time ÷ after time)
Write one sentence explaining why the improvement occurred (in the Explanation field under each comparison)
Comparison 1
-- Query
SELECT * FROM order_items WHERE order_id = 55;

-- Index to create
CREATE INDEX idx_oi_order_id ON order_items (order_id);
Metric	Before	After
Scan type		
Execution time (ms)		
Rows examined		
Improvement factor	—	
Explanation:

Note

Your Answer

(Write your answer here.)

Comparison 2
-- Query
SELECT * FROM products p
JOIN product_categories pc ON pc.product_id = p.product_id
WHERE pc.category_id = 2 AND p.price < 80;

CREATE INDEX idx_product_categories_category_id ON product_categories (category_id);
CREATE INDEX idx_products_price ON products (price);

-- Index to create
CREATE INDEX idx_products_cat_price ON products (category_id, price);
Metric	Before	After
Scan type		
Execution time (ms)		
Rows examined		
Improvement factor	—	
Explanation:

Note

Your Answer

(Write your answer here.)

Comparison 3
-- Query
SELECT * FROM customers WHERE email = 'test.user@example.com';

-- Index to create
CREATE UNIQUE INDEX idx_customers_email ON customers (email);
Metric	Before	After
Scan type		
Execution time (ms)		
Rows examined		
Improvement factor	—	
Explanation:

Note

Your Answer

(Write your answer here.)

Comparison 4
-- Query
SELECT order_id, SUM(quantity * unit_price) AS total
FROM order_items
WHERE order_id IN (10, 20, 30, 40, 50)
GROUP BY order_id;

-- Index to create
CREATE INDEX idx_oi_order_id_covering ON order_items (order_id) INCLUDE (quantity, unit_price);
Metric	Before	After
Scan type		
Execution time (ms)		
Rows examined		
Improvement factor	—	
Explanation:

Note

Your Answer

(Write your answer here.)

Comparison 5
-- Query
SELECT * FROM orders WHERE status = 'pending';

-- Index to create (partial index)
CREATE INDEX idx_orders_pending ON orders (status) WHERE status = 'pending';
Metric	Before	After
Scan type		
Execution time (ms)		
Rows examined		
Improvement factor	—	
Explanation:

Note

Your Answer

(Write your answer here.)

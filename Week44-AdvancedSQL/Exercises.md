Week 44 — Advanced SQL: Exercises
Important

How to Complete These Exercises Write your answers directly in the highlighted Your Answer / Your SQL fields below each task. Replace the placeholder text with your own work before submitting.

1. TrailShop Project Task
Continue building the TrailShop database. This week, use advanced query techniques to extract meaningful insights.

Task 1.1: Subqueries
Write the following queries using subqueries:

Find all products priced above the average price (use a scalar subquery).
[!NOTE] Your SQL

-- SELECT product_name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products);

Find all customers who have placed more than 2 orders (use a subquery in WHERE with IN).
[!NOTE] Your SQL

-- SELECT first_name, last_name
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(*) > 2
);

Show each product's name, price, and how much it differs from its category's average price (use a correlated subquery or derived table).
[!NOTE] Your SQL

SELECT p.product_name, p.price,
       p.price - (
           SELECT AVG(p2.price)
           FROM products p2
           JOIN product_categories pc2 ON pc2.product_id = p2.product_id
           WHERE pc2.category_id = pc.category_id
       ) AS diff_from_avg
FROM products p
JOIN product_categories pc ON pc.product_id = p.product_id;

Task 1.2: EXISTS
Use EXISTS to find all customers who have ordered at least one product from the "Footwear" category.
[!NOTE] Your SQL

-- SELECT c.first_name, c.last_name
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    JOIN product_categories pc ON pc.product_id = oi.product_id
    JOIN categories cat ON cat.category_id = pc.category_id
    WHERE o.customer_id = c.customer_id
      AND cat.category_name = 'Footwear'
);

Use NOT EXISTS to find all products that have never been ordered.
[!NOTE] Your SQL

-- SELECT p.product_name
FROM products p
WHERE NOT EXISTS (
    SELECT 1 FROM order_items oi WHERE oi.product_id = p.product_id
);

Task 1.3: CASE Expressions
Add a price_tier column to a product query that labels products as 'Budget' (< €25), 'Standard' (€25–€74.99), or 'Premium' (≥ €75).
[!NOTE] Your SQL

-- SELECT product_name, price,
       CASE
           WHEN price < 25 THEN 'Budget'
           WHEN price < 75 THEN 'Standard'
           ELSE 'Premium'
       END AS price_tier
FROM products;

Write a query that counts orders by status using CASE inside COUNT.
[!NOTE] Your SQL

SELECT COUNT(CASE WHEN status = 'pending'   THEN 1 END) AS pending,
       COUNT(CASE WHEN status = 'shipped'   THEN 1 END) AS shipped,
       COUNT(CASE WHEN status = 'delivered' THEN 1 END) AS delivered,
       COUNT(CASE WHEN status = 'cancelled' THEN 1 END) AS cancelled
FROM orders;

Task 1.4: Create Three Views
Create the following views in your TrailShop database:

v_product_catalog — Shows product name, category name, price, and stock status ('In Stock', 'Low Stock' for < 5 units, 'Out of Stock' for 0). Join through product_categories. A product in two categories may appear twice (once per category).
v_customer_summary — Shows each customer's full name, email, number of orders, and total spent.
v_monthly_revenue — Shows revenue grouped by month.
Verify each view works with a simple SELECT.

Note

Your SQL

-- CREATE VIEW v_product_catalog AS
SELECT p.product_name, c.category_name, p.price,
       CASE
           WHEN p.stock_quantity = 0 THEN 'Out of Stock'
           WHEN p.stock_quantity < 5 THEN 'Low Stock'
           ELSE 'In Stock'
       END AS stock_status
FROM products p
JOIN product_categories pc ON pc.product_id = p.product_id
JOIN categories c ON c.category_id = pc.category_id;

CREATE VIEW v_customer_summary AS
SELECT c.first_name || ' ' || c.last_name AS full_name,
       c.email,
       COUNT(DISTINCT o.order_id) AS order_count,
       COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS total_spent
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
LEFT JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;

CREATE VIEW v_monthly_revenue AS
SELECT DATE_TRUNC('month', o.order_date) AS month,
       SUM(oi.quantity * oi.unit_price) AS revenue
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY DATE_TRUNC('month', o.order_date);

-- Check them
SELECT * FROM v_product_catalog;
SELECT * FROM v_customer_summary;
SELECT * FROM v_monthly_revenue ORDER BY month;

Task 1.5: UNION
Write a UNION query that combines product names from two different categories into one list (without duplicates).
[!NOTE] Your SQL

-- SELECT p.product_name
FROM products p
JOIN product_categories pc ON pc.product_id = p.product_id
JOIN categories c ON c.category_id = pc.category_id
WHERE c.category_name = 'Footwear'
UNION
SELECT p.product_name
FROM products p
JOIN product_categories pc ON pc.product_id = p.product_id
JOIN categories c ON c.category_id = pc.category_id
WHERE c.category_name = 'Clothing';


Write a query using EXCEPT to find categories that have products but no orders.
[!NOTE] Your SQL

-- -- Categories with products but no orders
SELECT c.category_name
FROM categories c
JOIN product_categories pc ON pc.category_id = c.category_id
EXCEPT
SELECT c.category_name
FROM categories c
JOIN product_categories pc ON pc.category_id = c.category_id
JOIN order_items oi ON oi.product_id = pc.product_id;

Task 1.6: CTE
Write a CTE that calculates total revenue per category, then use it to find categories with above-average revenue.
[!NOTE] Your SQL

--WITH category_revenue AS (
    SELECT pc.category_id, SUM(oi.quantity * oi.unit_price) AS revenue
    FROM order_items oi
    JOIN product_categories pc ON pc.product_id = oi.product_id
    GROUP BY pc.category_id
)
SELECT c.category_name, cr.revenue
FROM category_revenue cr
JOIN categories c ON c.category_id = cr.category_id
WHERE cr.revenue > (SELECT AVG(revenue) FROM category_revenue);

Write a query with two CTEs: one for customer order counts, another for average order count, then find "top customers" (above average).
[!NOTE] Your SQL

-- WITH order_counts AS (
    SELECT customer_id, COUNT(*) AS n_orders
    FROM orders
    GROUP BY customer_id
),
avg_count AS (
    SELECT AVG(n_orders) AS avg_orders FROM order_counts
)
SELECT c.first_name, c.last_name, oc.n_orders
FROM order_counts oc
JOIN avg_count a ON oc.n_orders > a.avg_orders
JOIN customers c ON c.customer_id = oc.customer_id;

2. Theory Review Questions
Answer these in your own words (2–4 sentences each):

What is the difference between an INNER JOIN and a LEFT JOIN? When would you choose LEFT JOIN?
Note

Your Answer

(INNER JOIN only returns rows that have a match in both tables. LEFT JOIN keeps every row from the left table and fills in NULLs when there’s no match on the right. I’d use LEFT JOIN when I don’t want to lose rows, like listing all customers including ones who never ordered.)

Explain what a correlated subquery is. Why can it be slower than an uncorrelated subquery?
Note

Your Answer

(It’s a subquery that uses a column from the outer query, so it depends on the current outer row. It can be slower because it may run once for every outer row, while an uncorrelated subquery runs once and the result is reused.)

What is the difference between IN and EXISTS? When might you prefer EXISTS?
Note

Your Answer

(IN checks whether a value is in a list the subquery returns. EXISTS just checks whether the subquery returns any row at all. I’d prefer EXISTS when the subquery is big or correlated, or when NULLs are involved, because NOT IN behaves badly if the list contains a NULL.)

What rules must two SELECT statements follow to be combined with UNION?
Note

Your Answer

(Both SELECTs need the same number of columns, and the matching columns need compatible data types. The column names come from the first SELECT.)

Explain the difference between UNION and UNION ALL. When would you use each?
Note

Your Answer

(UNION removes duplicate rows, and UNION ALL keeps everything. I’d use UNION when I want unique results. I’d use UNION ALL when duplicates don’t matter or can’t happen, since it’s faster (no sorting or dedup step).)

What is a view? Name two advantages of using views.
Note

Your Answer

(A view is a saved SELECT query that you can use like a table. Two advantages: it simplifies complex queries because you write the logic once and reuse it, and it can hide columns or rows you don’t want certain users to see.)

What does WITH CHECK OPTION do on an updatable view?
Note

Your Answer

(On an updatable view, it stops you from inserting or updating rows that wouldn’t be visible through the view’s WHERE condition afterwards.)

How does a CTE differ from a derived table (subquery in FROM)? What's the main advantage of CTEs?
Note

Your Answer

(Both give you a temporary result set for one query. A CTE is defined at the top with a name, so it’s easier to read, you can reference it several times in the same query, and it allows chaining several steps. A derived table is written inline in FROM and can only be used once.)

3. Query Writing Exercises (Optional)
Tip

Recommended practice. Do this section. It is not required to finish the TrailShop project. It prepares you for the exams.

Write SQL queries for the following (use the TrailShop schema):

Find the most expensive product in each category using a correlated subquery.
[!NOTE] Your SQL

-- Write your query here

List all customers along with their most recent order date. Include customers who have never ordered (show NULL).
[!NOTE] Your SQL

-- Write your query here

Find categories where the total revenue exceeds €500 (use a subquery or CTE).
[!NOTE] Your SQL

-- Write your query here

Write a query that shows each order's total and whether it's 'Small' (< €50), 'Medium' (€50–€149.99), or 'Large' (≥ €150).
[!NOTE] Your SQL

-- Write your query here

Create a view called v_never_ordered that shows products that have never appeared in an order_item.
[!NOTE] Your SQL

-- Write your query here

Use EXCEPT to find products that exist in the products table but have never been ordered.
[!NOTE] Your SQL

-- Write your query here

Write a CTE that ranks categories by number of products, then selects only the top 3.
[!NOTE] Your SQL

-- Write your query here

Use NOT EXISTS to find categories that have no products.
[!NOTE] Your SQL

-- Write your query here

Write a query using CASE that creates a "customer loyalty" label: 'New' (1 order), 'Regular' (2–5 orders), 'VIP' (6+ orders).
[!NOTE] Your SQL

-- Write your query here

Use GREATEST to find the higher value between each product's current price and the average price of all products in its category.
[!NOTE] Your SQL

-- Write your query here

Write a query using COALESCE that shows order shipping dates, substituting 'Not yet shipped' for NULL values.
[!NOTE] Your SQL

-- Write your query here

Use a scalar subquery in the SELECT clause to show each product alongside the total number of times it has been ordered.
[!NOTE] Your SQL

-- Write your query here

4. Query Comparison Exercise (Optional)
Tip

Recommended practice. Do this section. It is not required to finish the TrailShop project. It prepares you for the exams.

For each pair of queries below, both produce the same result. Explain which approach you'd prefer and why (consider readability, performance, and maintainability).

Note

Your Answer

(Write your answer here.)

Pair A: Finding customers with orders
Version 1 — Subquery with IN:

SELECT first_name, last_name
FROM customers
WHERE customer_id IN (SELECT customer_id FROM orders);
Version 2 — JOIN:

SELECT DISTINCT c.first_name, c.last_name
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id;
Pair B: Finding products never ordered
Version 1 — LEFT JOIN + IS NULL:

SELECT p.product_name
FROM products p
LEFT JOIN order_items oi ON oi.product_id = p.product_id
WHERE oi.order_item_id IS NULL;
Version 2 — NOT EXISTS:

SELECT p.product_name
FROM products p
WHERE NOT EXISTS (
    SELECT 1 FROM order_items oi WHERE oi.product_id = p.product_id
);
Pair C: Customer total spending
Version 1 — Derived table (subquery in FROM):

SELECT sub.full_name, sub.total_spent
FROM (
    SELECT c.first_name || ' ' || c.last_name AS full_name,
           SUM(oi.quantity * oi.unit_price) AS total_spent
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
    JOIN order_items oi ON oi.order_id = o.order_id
    GROUP BY c.customer_id, c.first_name, c.last_name
) sub
WHERE sub.total_spent > 200;
Version 2 — CTE:

WITH customer_totals AS (
    SELECT c.first_name || ' ' || c.last_name AS full_name,
           SUM(oi.quantity * oi.unit_price) AS total_spent
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
    JOIN order_items oi ON oi.order_id = o.order_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT full_name, total_spent
FROM customer_totals
WHERE total_spent > 200;
For each pair, discuss: readability, performance (in PostgreSQL), and when you'd choose one over the other.

Note

Your Answer

(Write your answer here.)

Submission Checklist
Required

 TrailShop queries written for subqueries, EXISTS, and CASE expressions
 Three views created (v_product_catalog, v_customer_summary, v_monthly_revenue)
 UNION/EXCEPT and CTE queries written
 Theory review questions answered
Recommended practice

 Query writing exercises completed
 Query comparison exercise completed
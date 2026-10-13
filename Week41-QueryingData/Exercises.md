# Week 41 — Exercises: Querying Data

> [!IMPORTANT]
> ***How to Complete These Exercises***
> Write your answers directly in the highlighted **Your Answer** / **Your SQL** fields below each task. Replace the placeholder text with your own work before submitting.

## Exercise 1: TrailShop Project Task — Business Questions

Use the TrailShop database you created in Week 40. Write SQL queries to answer each business question below. Run each query and verify the results make sense.

### Basic Queries (SELECT + WHERE)

1. List all products in the 'Footwear' category (show name, price, stock).
> [!NOTE]
> ***Your SQL***
>
> ```sql
> SELECT p.name, p.price, p.stock
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE c.name = 'Footwear';
>
>
> ```

2. Find all products priced between €50 and €150, sorted by price ascending.
> [!NOTE]
> ***Your SQL***
>
> ```sql
> 
>SELECT name, price
FROM products
WHERE price BETWEEN 50 AND 150
ORDER BY price ASC;
>
> ```

3. Show all customers whose last name starts with the letter 'M' or 'K'.
> [!NOTE]
> ***Your SQL***
>
> ```sql
> SELECT *
FROM customers
WHERE last_name LIKE 'M%' OR last_name LIKE 'K%';
>
>
> ```

4. List all orders with status 'pending' or 'shipped', sorted by order date (most recent first).
> [!NOTE]
> ***Your SQL***
>
> ```sql
> SELECT *
FROM orders
WHERE status IN ('pending', 'shipped')
ORDER BY order_date DESC;
>
> ```

5. Find all products that have the word 'Pro' or 'pro' somewhere in their name.
> [!NOTE]
> ***Your SQL***
>
> ```sql
> SELECT *
FROM products
WHERE LOWER(name) LIKE '%pro%';
>
>
> ```

### Aggregate Queries

6. What is the total number of products in the database?

> [!NOTE]
> ***Your SQL***
>
> ```sql
>SELECT COUNT(*) AS total_products
FROM products;
>
>
> ```

7. What is the average price of all products? Round to 2 decimal places.
> [!NOTE]
> ***Your SQL***
>
> ```sql
>SELECT ROUND(AVG(price), 2) AS avg_price
FROM products;
>
>
> ```

8. Which is the most expensive product and which is the cheapest? Show both in one query.
> [!NOTE]
> ***Your SQL***
>
> ```sql
> SELECT name, price, 'most expensive' AS label
FROM products
WHERE price = (SELECT MAX(price) FROM products)
UNION ALL
SELECT name, price, 'cheapest' AS label
FROM products
WHERE price = (SELECT MIN(price) FROM products);
>
>
> ```

9. How many orders does each customer have? Show customer name and order count, sorted by count descending.
> [!NOTE]
> ***Your SQL***
>
> ```sql
> SELECT c.first_name || ' ' || c.last_name AS customer,
       COUNT(o.order_id) AS order_count
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY order_count DESC;
>
>
> ```

10. What is the total revenue (sum of quantity × unit_price from order_items) for each order status?

> [!NOTE]
> ***Your SQL***
>
> ```sql
> SELECT o.status,
       SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.status;
>
>
> ```

### JOIN Queries

11. List all products with their category names (not just category_id). Sort by category name, then product name.
> [!NOTE]
> ***Your SQL***
>
> ```sql
> SELECT p.name AS product, c.name AS category
FROM products p
JOIN categories c ON p.category_id = c.category_id
ORDER BY c.name, p.name;
>
>
> ```

12. Show each order with the customer's full name, order date, and status.
> [!NOTE]
> ***Your SQL***
>
> ```sql
> SELECT o.order_id,
       c.first_name || ' ' || c.last_name AS customer,
       o.order_date,
       o.status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;
>
>
> ```

13. Show a detailed breakdown of order #1: product name, quantity, unit price, and line total.
> [!NOTE]
> ***Your SQL***
>
> ```sql
> SELECT p.name,
       oi.quantity,
       oi.unit_price,
       oi.quantity * oi.unit_price AS line_total
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
WHERE oi.order_id = 1;
>
>
> ```

14. Find all customers who have NOT placed any orders. (Hint: use LEFT JOIN + IS NULL pattern.)
> [!NOTE]
> ***Your SQL***
>
> ```sql
> SELECT c.customer_id, c.first_name, c.last_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
>
>
> ```

15. For each category, show the category name, number of products, average price, and total inventory value (price × stock summed). Only include categories with total inventory value greater than €500.
> [!NOTE]
> ***Your SQL***
>
> ```sql
> SELECT c.name AS category,
       COUNT(p.product_id) AS num_products,
       ROUND(AVG(p.price), 2) AS avg_price,
       SUM(p.price * p.stock) AS inventory_value
FROM categories c
JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_id, c.name
HAVING SUM(p.price * p.stock) > 500;
>
>
> ```

---

## Exercise 2: Theory Review Questions

Answer in your own words:

1. What is the logical execution order of a SQL query? Why does it matter?

> [!NOTE]
> ***Your Answer***
>
> *(SQL doesn’t run in the order you write it. It runs FROM (and JOINs), then WHERE, GROUP BY, HAVING, SELECT, DISTINCT, ORDER BY, and finally LIMIT/OFFSET. It matters because it explains things that otherwise look like bugs. For example, you can’t use a SELECT alias in WHERE, because WHERE runs before SELECT even exists.)*
>
>
>
>



2. What is the difference between WHERE and HAVING? Give an example of when you would use each.

> [!NOTE]
> ***Your Answer***
>
> *(WHERE filters individual rows before they get grouped. HAVING filters groups after the aggregation. I’d use WHERE for something like WHERE price > 50, and HAVING for something like HAVING COUNT(*) > 1 to keep only customers with more than one order. An aggregate like COUNT can’t go in WHERE, because the groups don’t exist yet at that stage.)*
>
>
>
>

3. Explain the difference between COUNT(*), COUNT(column), and COUNT(DISTINCT column).

> [!NOTE]
> ***Your Answer***
>
> *(COUNT(*) counts all rows, NULLs included. COUNT(column) counts only the rows where that column isn’t NULL. COUNT(DISTINCT column) counts the unique non-NULL values, so a customer who ordered 5 times is counted once.)*
>
>
>
>

4. What is the difference between INNER JOIN and LEFT JOIN? When would you choose one over the other?

> [!NOTE]
> ***Your Answer***
>
> *(INNER JOIN returns only rows that have a match in both tables. LEFT JOIN keeps every row from the left table and fills the right side with NULLs when there’s no match. I’d use INNER JOIN when I only care about matching data, like orders with their items. I’d use LEFT JOIN when I need the unmatched rows too, like customers who never ordered.)*
>
>
>
>



5. Why should you avoid SELECT * in production code?

> [!NOTE]
> ***Your Answer***
>
> *(It pulls columns you don’t need, which wastes bandwidth and memory and can stop the database from using covering indexes. It also breaks easily: if someone adds, removes or reorders a column, the code reading the result can break or leak data it shouldn’t. Naming the columns makes the query clearer and safer.)*
>
>
>
>



6. What does DISTINCT do? On what level does it operate (columns or entire rows)?

> [!NOTE]
> ***Your Answer***
>
> *(It removes duplicate rows from the result. It works on the entire row, meaning the whole combination of selected columns, not on one column. SELECT DISTINCT a, b gives you the unique (a, b) pairs.)*
>
>
>
>



7. Can you use a column alias in a WHERE clause? Why or why not?



> [!NOTE]
> ***Your Answer***
>
> *(No, not in standard SQL. WHERE runs before SELECT, so the alias hasn’t been created yet. You have to repeat the expression in WHERE or wrap the query in a subquery/CTE. ORDER BY runs after SELECT, so aliases do work there.)*
>
>
>
>
8. Explain what happens when you GROUP BY a column and there's a column in SELECT that isn't aggregated and isn't in GROUP BY.

> [!NOTE]
> ***Your Answer***
>
> *(It’s a problem because the database doesn’t know which value to show for a group that contains several different values. PostgreSQL and most others throw an error. Older MySQL (and SQLite) will quietly pick an arbitrary value from the group, which gives misleading results. The fix is to add the column to GROUP BY or wrap it in an aggregate.)*
>
>
>
>

---

## Exercise 3: Query Writing Exercises

Write the SQL for each task. Use the TrailShop schema (categories, customers, products, orders, order_items).

### Simple SELECT + WHERE

**3.1** — Select product names and prices for all products with stock less than 15.

> [!NOTE]
> ***Your SQL***
>
> ```sql
> SELECT name, price
FROM products
WHERE stock < 15;
>
>
> ```


**3.2** — Find all customers who registered (created_at) in 2026. Show first name, last name, and registration date.

> [!NOTE]
> ***Your SQL***
>
> ```sql
>SELECT first_name, last_name, created_at
FROM customers
WHERE created_at >= '2026-01-01' AND created_at < '2027-01-01';
>
>
> ```


**3.3** — Show all products that do NOT have a description (description IS NULL).

> [!NOTE]
> ***Your SQL***
>
> ```sql
>SELECT *
FROM products
WHERE description IS NULL;
>
>
> ```


### Multi-condition Filtering

**3.4** — Find products in category 1 OR category 2, priced above €100, with stock greater than 0. Sort by price descending.

> [!NOTE]
> ***Your SQL***
>
> ```sql
> SELECT *
FROM products
WHERE category_id IN (1, 2)
  AND price > 100
  AND stock > 0
ORDER BY price DESC;
>
>
> ```


**3.5** — Find orders that are either 'delivered' or placed by customer_id 1. Show order_id, customer_id, status.

> [!NOTE]
> ***Your SQL***
>
> ```sql
> SELECT order_id, customer_id, status
FROM orders
WHERE status = 'delivered' OR customer_id = 1;
>
>
> ```


### Aggregation

**3.6** — For each category_id, show the minimum, maximum, and average price. Round averages to 2 decimal places.

> [!NOTE]
> ***Your SQL***
>
> ```sql
>SELECT category_id,
       MIN(price) AS min_price,
       MAX(price) AS max_price,
       ROUND(AVG(price), 2) AS avg_price
FROM products
GROUP BY category_id; 
>
>
> ```


**3.7** — Count how many distinct customers have placed at least one order.

> [!NOTE]
> ***Your SQL***
>
> ```sql
> SELECT COUNT(DISTINCT customer_id) AS customers_with_orders
FROM orders;
>
>
> ```


**3.8** — Find the total quantity of items sold across all orders.

> [!NOTE]
> ***Your SQL***
>
> ```sql
> SELECT SUM(quantity) AS total_items_sold
FROM order_items;
>
>
> ```


### JOIN Queries

**3.9** — Show each product name alongside its category name. Include all products (even if somehow a category was deleted — use LEFT JOIN).

> [!NOTE]
> ***Your SQL***
>
> ```sql
> SELECT p.name AS product_name, c.name AS category_name
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id;
>
>
> ```


**3.10** — List all orders showing: order_id, customer full name, order date, number of items in the order, and order total cost.

> [!NOTE]
> ***Your SQL***
>
> ```sql
> SELECT o.order_id,
       c.first_name || ' ' || c.last_name AS customer,
       o.order_date,
       SUM(oi.quantity) AS num_items,
       SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, c.first_name, c.last_name, o.order_date
ORDER BY o.order_id;
>
>
> ```


**3.11** — Show all products that have NEVER been ordered. (Hint: LEFT JOIN order_items, then IS NULL on order_item_id.)

> [!NOTE]
> ***Your SQL***
>
> ```sql
> SELECT p.product_id, p.name
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.order_item_id IS NULL;
>
>
> ```


### GROUP BY + HAVING

**3.12** — Show categories where the average product price exceeds €100. Display category name and average price.

> [!NOTE]
> ***Your SQL***
>
> ```sql
> SELECT c.name AS category, ROUND(AVG(p.price), 2) AS avg_price
FROM categories c
JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_id, c.name
HAVING AVG(p.price) > 100;
>
>
> ```


**3.13** — Find customers who have placed more than 1 order. Show their name and order count.

> [!NOTE]
> ***Your SQL***
>
> ```sql
> SELECT c.first_name || ' ' || c.last_name AS customer,
       COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) > 1;
>
>
> ```


### Pagination

**3.14** — Write a paginated query that returns products 4 through 6 (page 2, page size 3), ordered by product_id.

> [!NOTE]
> ***Your SQL***
>
> ```sql
>SELECT *
FROM products
ORDER BY product_id
LIMIT 3 OFFSET 3;
>
>
> ```


### Complex

**3.15** — Write a "sales report" query that shows: category name, total units sold (from order_items), total revenue, and number of distinct products sold — for each category. Sort by revenue descending.

> [!NOTE]
> ***Your SQL***
>
> ```sql
> SELECT c.name AS category,
       SUM(oi.quantity) AS units_sold,
       SUM(oi.quantity * oi.unit_price) AS total_revenue,
       COUNT(DISTINCT p.product_id) AS distinct_products_sold
FROM categories c
JOIN products p ON c.category_id = p.category_id
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY c.category_id, c.name
ORDER BY total_revenue DESC;
>
>
> ```


---

## Exercise 4: Query Reading Exercise

For each query below, explain in **plain English** what it does and what the result would look like.

### 4.1

```sql
SELECT c.name, COUNT(p.product_id) AS num_products
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
GROUP BY c.name
ORDER BY num_products DESC;
```

> [!NOTE]
> ***Error(s) Identified***
>
> *(This counts how many products each category has and lists them with the biggest category first. Because it’s a LEFT JOIN, categories with no products still appear with a count of 0. It counts p.product_id instead of *, which is what makes the empty ones show 0 and not 1. The result has two columns, category name and num_products, one row per category.)*
>
>
>
>
> [!NOTE]
> ***Corrected SQL***
>
> ```sql
> -- Write the corrected statement here
>
>
> ```


### 4.2

```sql
SELECT first_name, last_name
FROM customers
WHERE customer_id NOT IN (
    SELECT DISTINCT customer_id FROM orders
);
```

> [!NOTE]
> ***Error(s) Identified***
>No error with the current data, but NOT IN returns zero rows if the subquery ever contains a NULL. It’s safer to use NOT EXISTS.
> *(This returns the first and last names of customers who have never placed an order. The subquery collects every customer_id found in orders, and the outer query keeps the customers who aren’t in that list. The result is just a list of names.)*
>
>
>
>
> [!NOTE]
> ***Corrected SQL***
>
> ```sql
> SELECT first_name, last_name
FROM customers c
WHERE NOT EXISTS (
    SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id
);
>
>
> ```


### 4.3

```sql
SELECT p.name, p.price, p.stock,
       p.price * p.stock AS inventory_value
FROM products p
WHERE p.stock > 0
ORDER BY inventory_value DESC
LIMIT 3;
```

> [!NOTE]
> ***Error(s) Identified***
>
> *(This finds the 3 products with the highest stock value (price × stock), ignoring anything that’s out of stock. It shows name, price, stock and the calculated inventory_value, highest first. The result is 3 rows.)*
>
>
>
>
> [!NOTE]
> ***Corrected SQL***
>
> ```sql
> -- Write the corrected statement here
>
>
> ```


### 4.4

```sql
SELECT o.order_id,
       SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status <> 'cancelled'
GROUP BY o.order_id
HAVING SUM(oi.quantity * oi.unit_price) > 200
ORDER BY order_total DESC;
```

> [!NOTE]
> ***Error(s) Identified***
>None. One small thing is that <> 'cancelled' would also drop orders where status is NULL, but that only matters if NULL statuses exist.
> *(This lists orders worth more than €200. It leaves out cancelled orders, adds up quantity × unit_price for each order’s items, and keeps only orders whose total is above 200, largest first. The result has order_id and order_total, one row per order.)*
>
>
>
>
> [!NOTE]
> ***Corrected SQL***
>
> ```sql
> -- Write the corrected statement here
>
>
> ```


### 4.5

```sql
SELECT c.first_name || ' ' || c.last_name AS customer,
       COUNT(DISTINCT o.order_id) AS num_orders,
       SUM(oi.quantity) AS total_items,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC NULLS LAST;
```

> [!NOTE]
> ***Error(s) Identified***
>NULLS LAST isn’t supported in MySQL or SQLite older than 3.30, but it works in PostgreSQL and modern SQLite.
> *(This is a summary per customer: full name, number of distinct orders, total items bought and total money spent (rounded to 2 decimals). Both joins are LEFT JOINs, so customers who never ordered still show up, with 0 orders and NULL for items and spend. The biggest spenders come first and the NULL ones are pushed to the bottom. COUNT(DISTINCT o.order_id) is needed so an order with several line items isn’t counted more than once.)*
>
>
>
>
> [!NOTE]
> ***Corrected SQL***
>
> ```sql
> -- Write the corrected statement here
>
>
> ```


---

## Submission Checklist

- [ ] All 15 business questions answered with working SQL
- [ ] Theory review questions answered in your own words
- [ ] All 15 query writing exercises completed
- [ ] All 5 query reading explanations written
- [ ] Results verified by running queries against your TrailShop database

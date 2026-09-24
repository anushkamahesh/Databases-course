# Week 36 — Exercises & Project Task

> [!IMPORTANT]
> ***How to Complete These Exercises***
> Write your answers directly in the highlighted **Your Answer** / **Your SQL** fields below each task. Replace the placeholder text with your own work before submitting.

These exercises accompany the Week 36 Theory material. Complete all sections.

---

## Part 1: TrailShop Project Task

### Task 1: Set Up PostgreSQL

Goal: install a working PostgreSQL server on your computer and confirm you can start `psql` (or an equivalent client).

---

### Local installation

**Step 1 — Download the installer**

1. Open [https://www.postgresql.org/download/windows/](https://www.postgresql.org/download/windows/).
2. Click **Download the installer** (EDB installer is fine).
3. Choose a recent stable version (e.g. 16 or 17) for **Windows x86-64**.
4. Save the `.exe` file and run it.

_(macOS / Linux: start from [https://www.postgresql.org/download/](https://www.postgresql.org/download/) and follow the OS-specific guide.)_

**Step 2 — Run the setup wizard**

Work through the wizard. Suggested choices for this course:

1. **Installation directory** — leave the default.
2. **Select components** — keep at least **PostgreSQL Server**, **pgAdmin 4**, **Command Line Tools**, and **Stack Builder** (Stack Builder can be skipped later).
3. **Data directory** — leave the default.
4. **Password** — set a password for the superuser account `postgres`.
   **Write it down.** You will need it every time you connect.
5. **Port** — leave **5432** (default) unless that port is already in use.
6. **Locale** — leave the default.
7. Finish the install. You can decline launching Stack Builder if prompted.

**Step 3 — Confirm the service is running (Windows)**

1. Press `Win`, type **Services**, open **Services**.
2. Find a service named like `postgresql-x64-16` (version number may differ).
3. Status should be **Running**. If not, right-click → **Start**.

**Step 4 — Open a terminal where** `psql` **is available**

On Windows, the easiest reliable options are:

- **Option 4a:** Start Menu → **SQL Shell (psql)** (installed with PostgreSQL), **or**
- **Option 4b:** Open **PowerShell** or **Command Prompt**.

If `psql` is not found in PowerShell, either use **SQL Shell (psql)** or add the PostgreSQL `bin` folder to your PATH, for example:

```
C:\Program Files\PostgreSQL\16\bin
```

(Adjust `16` to match your installed version.)

**Step 5 — Verify the installation**

In PowerShell / Command Prompt, run:

```
psql --version
```

You should see something like `psql (PostgreSQL) 16.x`.

If you used **SQL Shell (psql)** instead, you can skip `--version` and go straight to connecting in Task 2 — successful connection also proves the install works.

**Step 6 — Capture evidence for submission**

Take a screenshot of `psql --version` output (or of a successful `psql` connection prompt).

---

### Task 2: Create the TrailShop Database

Goal: create an empty database named `trailshop` and confirm you are connected to it.

Complete these steps after Task 1 succeeds.

**Step 1 — Connect to the PostgreSQL server as** `postgres`

**If you use SQL Shell (psql) on Windows**, press Enter to accept defaults for Server, Database, Port, and Username (`postgres`), then type the password you set during install when prompted.

**If you use PowerShell / Command Prompt**, run:

```
psql -U postgres -h localhost -p 5432
```

Enter the `postgres` password when asked.

You should see a prompt similar to:

```
postgres=#
```

That means you are connected to the default `postgres` maintenance database — which is normal before creating `trailshop`.

**Step 2 — List existing databases (optional but useful)**

At the `postgres=#` prompt, run:

```
\l
```

Scan the list. If `trailshop` already exists from an earlier attempt, skip Step 3 and go to Step 4.

**Step 3 — Create the database**

Still at the `postgres=#` prompt, run exactly:

```sql
CREATE DATABASE trailshop;
```

Expected result:

```
CREATE DATABASE
```

If you see `ERROR: database "trailshop" already exists`, the database is already there — continue to Step 4.

**Step 4 — Connect to** `trailshop`

In `psql`, run:

```
\c trailshop
```

Expected result (wording may vary slightly):

```
You are now connected to database "trailshop" as user "postgres".
```

**Step 5 — Confirm the prompt and that the database is empty**

1. Check that your prompt shows `trailshop`, for example:

```
trailshop=#
```

1. List tables:

```
\dt
```

You should see **no tables** (or a message that no relations were found). That is expected in Week 36 — tables come later.

1. Confirm the current database name with SQL:

```sql
SELECT current_database();
```

Expected: one row with `trailshop`.

**Step 6 — Quit psql (when finished)**

```
\q
```

**Step 7 — Capture evidence for submission**

Take a screenshot showing:

- successful `\c trailshop` (or the `trailshop=#` prompt), **and**
- `\dt` with an empty result / “Did not find any relations”

---

### Troubleshooting (Tasks 1–2)

| Problem                                | What to try                                                                                                                  |
| -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| `psql` is not recognized               | Use **SQL Shell (psql)**, or add PostgreSQL’s `bin` folder to PATH and open a **new** terminal                               |
| Password authentication failed         | Use the password set for user `postgres` during install; check Caps Lock                                                     |
| Connection refused / could not connect | Confirm the PostgreSQL Windows service is **Running**; confirm port **5432**                                                 |
| Port already in use                    | Either stop the other service using 5432, or reinstall/reconfigure PostgreSQL to another port and always pass `-p` that port |
| Permission denied to create database   | Connect as `postgres` (superuser), not as a limited role                                                                     |

---

### Task 3: Reflection Worksheet

Answer the following in your own words (write 2–3 sentences per point):

1. List **3 specific problems** TrailShop would face if they kept using spreadsheets as their product catalog grows to 5,000+ items with 10 staff members.

> [!NOTE]
> ***Your Answer***
> Editing Conflicts constantly and a possibility to overwrite each other's changes.
> Severe slowdowns and Crashes.
> No real time inventory control.

2. List **3 benefits** of switching to a database system, explaining how each one solves a problem from your list above.

> [!NOTE]
> ***Your Answer***
>
> Data is better organised.
> A database system can avoid storing the same information multiple times
> And finally, better data security as the system only allows access to be controlled through users and permissions.

3. Explain the three-schema architecture in your own words. Why is the separation into three levels useful?

> [!NOTE]
> ***Your Answer***
>
> The three-schema architecture has 3 different levels: External (what the users see), conceptual (how the data is organized) and internal (how the data is stored). Separating them makes the database easier to manage because changes in one level do not always affect the others.

---

## Part 2: Theory Review Questions

Answer each question in 2–4 sentences. Reference the Theory material sections as needed.

### Short-Answer Questions

**Q1.** What is the difference between data and information? Give a concrete example using TrailShop data.
_(See Section 1 of this week's Theory material.)_

> [!NOTE]
> ***Your Answer***
>
> Data is raw facts or values that have not been processed. Information is data that has been organized so it has meaning. For eg, in trailshop 120 euros is data. If we know that 120 euro is the price of hiking backpack, it becomes an information.

**Q2.** List and explain three disadvantages of file-based data management systems. For each, describe how it would affect TrailShop specifically.
_(See Section 2 of this week's Theory material.)_

> [!NOTE]
> ***Your Answer***
>
> Data duplication- The same data may be stored in multiple files. For trailshop customer information could be repeated in different files and can cause confusion
> Data Inconsistency- Different files may contain different versions of the same data. For trailshop a customers address could be updated in one file but remain old in another.
> Difficulty to access data- Finding and managing data can be difficult when it is spread across multiple files. In trailshop finding all orders from a specific customer can take alot of time.

**Q3.** What is a DBMS? List four of its core functions.
_(See Sections 3 and 4 of this week's Theory material.)_

> [!NOTE]
> ***Your Answer***
>
> A DBMS Database management system is a software used to create, store, manage and access data in a database. It's four core functions are: Storing data, retrieving data, updating data and managing data security and access.

**Q4.** Explain program-data independence with a concrete example. Why is it important?
_(See Section 5.2 of this week's Theory material.)_

> [!NOTE]
> ***Your Answer***
>
> Program data independence means that a program does not need to change when the database structure changes. For eg, if trailshop adds new column to the products table, existing programs can still work. It's important because it makes the system easier to maintain.

**Q5.** What is metadata? Give two examples of metadata for a `products` table.
_(See Section 8 of this week's Theory material.)_

> [!NOTE]
> ***Your Answer***
>
> Metadata is data that describes other data. Two eg for a products table are, the column name such as the product_name and the data type like the price being a decimal number.

**Q6.** What is the three-schema architecture? Name and briefly describe each level.
_(See Section 3.3 of this week's Theory material.)_

> [!NOTE]
> ***Your Answer***
>
>the three-schema architecture divides a database into 3 levels. External level:It's what the users see. Conceptual level: How the data is organized and connected. And finally the Internal Level: How data is physically stored.

**Q7.** Explain the difference between logical data independence and physical data independence.
_(See Section 3.4 of this week's Theory material.)_

> [!NOTE]
> ***Your Answer***
>
>Logical data independence means changing the database structure without changing applications. Physical data independence means changing how data is stored without changing the database structure or applications.

**Q8.** What is a transaction? Why is atomicity important? Give a TrailShop example.
_(See Section 5.5 of this week's Theory material.)_

> [!NOTE]
> ***Your Answer***
>
> A transaction is a group of database operations treated as one unit. Atomicity means that all operations must succeed or none of them happen. For example, when a customer buys a trailshop product the order and payment should both be completed or neither should happen.

### True/False

For each statement, write **True** or **False** and correct any false statements.

1. A DBMS stores only data, not information about the data's structure.
2. In a file-based system, changing the format of a data file requires updating every program that reads it.
3. Data redundancy means the same data is stored in multiple places.
4. PostgreSQL is a commercial, closed-source database system.
5. The conceptual level of the three-schema architecture describes how data is physically stored on disk.

> [!NOTE]
> ***Your Answer***
>
> 1.False
> 2.True
> 3.True
> 4.False
> 5.False

### Matching Exercise

Match each term (1–10) with its definition (A–J).

| #   | Term              |
| --- | ----------------- |
| 1   | Data dictionary   |
| 2   | RDBMS             |
| 3   | Concurrency       |
| 4   | View              |
| 5   | Schema            |
| 6   | Data isolation    |
| 7   | Transaction       |
| 8   | SQL               |
| 9   | Data independence |
| 10  | ACID              |

| Letter | Definition                                                                          |
| ------ | ----------------------------------------------------------------------------------- |
| A      | A virtual table defined by a query, showing a subset of data                        |
| B      | Multiple users accessing data at the same time                                      |
| C      | The formal definition of a database's structure (tables, columns, types)            |
| D      | A logical unit of work that must complete fully or not at all                       |
| E      | The standard language for querying and managing relational databases                |
| F      | The system catalog storing metadata about the database                              |
| G      | Data trapped in separate files/formats that are hard to combine                     |
| H      | A DBMS based on the relational model, using tables and SQL                          |
| I      | The ability to change storage or structure without affecting applications           |
| J      | Atomicity, Consistency, Isolation, Durability — properties of reliable transactions |

> [!NOTE]
> ***Your Answers***
>
> | #   | Your Match |
> | --- | ---------- |
> | 1   |    f        |
> | 2   |     h       |
> | 3   |     b     |
> | 4   |     a       |
> | 5   |      c      |
> | 6   |      g      |
> | 7   |       d     |
> | 8   |       e     |
> | 9   |       i     |
> | 10  |       j     |

---

## Part 3: Practical Exercises

These exercises require a working PostgreSQL installation. See Part 1, Task 1 if you haven't set it up yet.

### Exercise 3.1: Explore psql

Connect to PostgreSQL using psql and complete the following. Write down the command you used and the output (or a summary of it).

1. List all databases on your server.
2. Connect to the `trailshop` database.
3. List all tables in the `trailshop` database.
4. Use `\?` to display the list of psql meta-commands. Find and write down the commands for:

- Describing a specific table's structure
- Listing all users/roles
- Showing help for a specific SQL command

5. Quit psql.

> [!NOTE]
> ***Your Answer***
>
> 1. \l
> 2. \c trailshop
> 3. \dt
> 4. \d table_name, \du
> 5. \h
> 6. \q

### Exercise 3.2: Explore the System Catalog

While connected to `trailshop`, run the following queries and write down what they return:

```sql
SELECT current_database();
```

```sql
SELECT version();
```

```sql
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public';
```

Why does the last query return no rows? What would you expect to see after creating tables in future weeks?

> [!NOTE]
> ***Your Answer***
>
> It returns no rows because no tables have been created yet in the public schema of the trailshop database yet. In the future weeks I expect the sanmes of tables I create in the upcoming excrcises and lectures.

### Exercise 3.3: Create and Drop a Test Database

Practice database creation and deletion:

```sql
-- Create a test database
CREATE DATABASE test_playground;

-- List databases to confirm it exists
\l

-- Drop (delete) the test database
DROP DATABASE test_playground;

-- List databases again to confirm it's gone
\l
```

**Warning:** `DROP DATABASE` permanently deletes a database and all its data. Always double-check the database name before running this command.

---

## Submission Checklist

- [ ] PostgreSQL installed and working (screenshot of `psql --version` or equivalent)
- [ ] `trailshop` database created (screenshot of `\c trailshop` showing successful connection)
- [ ] Reflection Worksheet answers (Part 1, Task 3)
- [ ] Theory Review Questions answered (Part 2)
- [ ] Practical Exercise outputs documented (Part 3)

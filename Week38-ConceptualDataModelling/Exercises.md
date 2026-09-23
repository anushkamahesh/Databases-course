# Week 38 — Conceptual Data Modelling: Exercises

> [!IMPORTANT]
> ***How to Complete These Exercises***
> Write your answers directly in the highlighted **Your Answer** / **Your SQL** fields below each task. Replace the placeholder text with your own work before submitting.

These exercises accompany the Week 38 Theory material. Refer to the theory sections indicated in brackets when you need help.

---

## Exercise 1: TrailShop Project Task — Create the ER Diagram

**Goal:** Create a complete Entity-Relationship diagram for the TrailShop database using crow's foot notation.

> **From Week 37:** Last week each product had a single `category_id` (Category 1:N Product). That cannot store a product in two categories. This week's diagram must **not** put `category_id` on Product. Use **ProductCategory** as the junction that resolves Category M:N Product (see Theory Section 1.4).

### Instructions

Using the entity descriptions from Theory Section 12, create an ER diagram that includes:

1. **All six entities**: Category, Product, ProductCategory, Customer, Order, OrderItem
2. **All attributes** for each entity (as listed in Section 12.1)
3. **Primary keys** clearly marked (underline or "PK" label)
4. **Foreign keys** clearly marked (dashed underline or "FK" label)
5. **Relationships** between entities with:
   - Relationship name (verb)
   - Crow's foot notation showing cardinality and participation
6. **Identify weak / junction entities** — mark OrderItem as a weak entity, and mark ProductCategory as the junction that resolves Category M:N Product. Do **not** draw a direct M:N line between Category and Product.

### Requirements

- Use crow's foot notation (see Theory Section 9)
- You may use any tool: draw.io, Lucidchart, ERDPlus, dbdiagram.io, or even pen and paper (photograph and submit)
- The diagram must be readable — avoid crossing lines where possible
- Include a brief legend explaining your notation if using pen and paper

### Deliverables

- The ER diagram (image or link to online tool)
- A short written paragraph (3–5 sentences) that **must** explain why Week 37's 1:N `products.category_id` is being replaced by ProductCategory. You may also discuss another design decision (for example why OrderItem is a weak entity, or why `unit_price` is stored in OrderItem).

> [!NOTE]
> ***Your Answer***
>
> *(https://dbdiagram.io/d/6ab40cbe0f25a52d01ea9fc2
> Week 37’s design puts `category_id` directly in `Product`, which creates a 1:N relationship and only allows each product to have one category. A `ProductCategory` junction table is needed to support a true many-to-many relationship between products and categories. `OrderItem` is a weak entity because it depends on an order and uses `order_id` + `product_id` as its composite key. `unit_price` is stored in `OrderItem` to keep the original price paid, even if the product’s price changes later.
)*
>
>
>
>

---

## Exercise 2: Theory Review Questions

Answer each question in 2–4 sentences. Reference the relevant theory section. Question 11b is extra: it connects last week's 1:N category FK to this week's junction.

1. Why should you create a conceptual data model before writing SQL? Give two specific reasons. *(Section 1)*

> [!NOTE]
> ***Your Answer***
>
> *(Creating a concepetual model helps understand the requirements and rules before committing to a technical setup. It is also easier to fix the model before creating the actual database.)*
>
>
>
>

2. What is the difference between the conceptual level and the logical level of a data model? *(Section 2)*

> [!NOTE]
> ***Your Answer***
>
> *(The conceptual level shows the main entities and relationships at a high level. The logical level turns these into tables, coloumns and keys.)*
>
>
>
>

3. Explain logical data independence with an example. *(Section 3)*

> [!NOTE]
> ***Your Answer***
>
> *(It means changing the database structure without changing the applications or user views. For example, Splitting one table into two while keeping the same view for users.)*
>
>
>
>

4. Explain physical data independence with an example. *(Section 3)*

> [!NOTE]
> ***Your Answer***
>
> *(It means changing how data is stored without changing the database structure or SQL queries. For ex, adding an index to make searches faster.)*
>
>
>
>

5. What is the difference between a strong entity and a weak entity? Give one example of each (not from TrailShop). *(Section 5)*

> [!NOTE]
> ***Your Answer***
>
> *(A string entity can be identified by itself like building with a building ID. A weak entity depends on another entity like a room that needs a building ID)*
>
>
>
>

6. What is a composite attribute? How does it differ from a multivalued attribute? Give an example of each. *(Section 6)*

> [!NOTE]
> ***Your Answer***
>
> *(A composite attribute can be divided into smaller parts, like Address street city or postal code. A multivalued attribute can have several values, like a person's phone numbers.)*
>
>
>
>

7. What is a derived attribute? Why is it usually not stored in the database? *(Section 6)*

> [!NOTE]
> ***Your Answer***
>
> *(A derived attribute is calculated from other data. It is usually not stored because the value can be calculated when needed and storing it can cause errors.)*
>
>
>
>

8. Explain the difference between a binary relationship and a unary (recursive) relationship. Give an example of each. *(Section 7)*
> [!NOTE]
> ***Your Answer***
>
> *(A binary relationship connects two type of entity like customer places order. A unary relationship connects the same entity type like employee manages employee.)*
>




9. What is the difference between an identifying relationship and a non-identifying relationship? How does this affect the child table's primary key? *(Section 7)*
> [!NOTE]
> ***Your Answer***
>
> *(In an identifying relationship, the parent's key becomes part of the child's primary key. In a non-identifying relationship, the parent's key is only a foreign key.)*
>




10. In crow's foot notation, what does the following endpoint mean: a circle followed by a crow's foot (fork)? *(Section 9)*

11. Why can't a many-to-many (M:N) relationship be directly implemented in a relational database? What is the solution? *(Section 10)*

> [!NOTE]
> ***Your Answer***
>
> *(A relational database cannot directly handle many records on both sides. We use a junction table to create two 1:N relationships.)*
>
>
>
>

11b. Last week TrailShop used `products.category_id` so each product belonged to exactly one category. Why is that insufficient, and what ER construct replaces it? *(Section 1.4)*

> [!NOTE]
> ***Your Answer***
>
> *(This means each department has at least 1 employee, and each employee belongs to exactly 1 department.)*
>
>
>
>

12. A business rule states: "Every employee must belong to exactly one department, and every department must have at least one employee." Express this using min-max notation for both sides. *(Section 8)*

> [!NOTE]
> ***Your Answer***
>
> *(Write your answer here.)*
>
>
>
>

---

## Exercise 3: ER Diagram Reading Exercise

### Diagram A: Library System

Study the following ER description and answer the questions below.

```
┌──────────┐                        ┌──────────┐
│  AUTHOR  │──||──────O<────────────│   BOOK   │
└──────────┘                        └─────┬────┘
                                          │
                                    ||    │
                                          │
                                    O<    │
                                          │
                                   ┌──────┴─────┐
                                   │    LOAN     │
                                   └──────┬──────┘
                                          │
                                    ||    │
                                          │
                                    O<    │
                                          │
                                   ┌──────┴──────┐
                                   │   MEMBER    │
                                   └─────────────┘
```

Relationships (in crow's foot):
- Author `──||──────O<──` Book
- Book `──||──────O<──` Loan
- Member `──||──────O<──` Loan

**Questions:**

a) Can an author exist without having written any books? Explain using the notation.
> [!NOTE]
> ***Your Answer***
>
> *(Yes. The O< means zero or many books, so an author can exist in the system even if they have not written or been connected to any books yet.)*
>
>
>
>

b) Can a book exist without being loaned? Explain using the notation.
> [!NOTE]
> ***Your Answer***
>
> *(Yes. The relationship allows zero loans, so a book can be added to the library even if nobody has borrowed it yet.)*
>
>
>
>

c) What type of entity is Loan in this diagram? Is it a junction/associative entity? Why?


> [!NOTE]
> ***Your Answer***
>
> *(Loan is a junction/associative entity. It connects Book and Member and records information about a specific loan, such as dates. It also helps resolve the many-to-many relationship between books and members.)*
>
>
>
>

d) What is the cardinality of the Author-Book relationship? Is this realistic? What might be a more accurate model?


> [!NOTE]
> ***Your Answer***
>
> *(The diagram shows a 1:N relationship, meaning one author can have many books but each book has only one author. This is not always realistic because books can have multiple authors. A many-to-many relationship with a junction table such as BookAuthors would handle this better.)*
>
>
>
>

e) What attributes would you add to the Loan entity?


> [!NOTE]
> ***Your Answer***
>
> *(Some useful attributes would be loan_date, due_date and return_date. You could also add renewal_count or fine_amount if those are needed by the library.)*
>
>
>
>

### Diagram B: School System

```
STUDENT ──O|──────O<── ENROLLMENT ──>|──||── COURSE
                                        │
                                    ||  │
                                        │
                                    O<  │
                                        │
                                   TEACHER
```

Relationships:
- Student `──O|──────O<──` Enrollment (a student may have zero or many enrollments)
- Enrollment `──||──────||──` Course (each enrollment is for exactly one course)
- Teacher `──||──────O<──` Course (each course has zero or many sections, each taught by exactly one teacher)

**Questions:**

a) Can a student exist without being enrolled in any course?


> [!NOTE]
> ***Your Answer***
>
> *(Yes. A student can have zero enrollments, so they can exist in the system without currently being enrolled in a course.)*
>
>
>
>

b) Can a course exist without having any enrolled students?


> [!NOTE]
> ***Your Answer***
>
> *(Write your answer here.)*
>
>
>
>


> [!NOTE]
> ***Your Answer***
>
> 
According to the diagram, no. The relationship requires at least one enrollment. However, this could be considered a modelling problem because normally a course should be allowed to exist before students enroll.
)*
>
>
>
>

d) Can a teacher exist without teaching any courses?
The relationship is many-to-many. A student can take multiple courses, and a course can have multiple students. Enrollment is used as the junction entity.


> [!NOTE]
> ***Your Answer***
>
> *(Yes. The O< shows zero or many courses, so a teacher can exist without currently being assigned to a course.)*
>
>
>
>

e) Is the Teacher-Course relationship 1:1 or 1:N? What does this imply about team teaching?


> [!NOTE]
> ***Your Answer***
>
> *(It is 1:N. One teacher can teach several courses, but each course can only have one teacher. This means the current design does not support team teaching. To support multiple teachers per course, a junction table could be added.)*
>
>
>
>

---

## Exercise 4: ER Diagram Creation — Gym/Fitness Center

### Scenario

FitZone is a local gym and fitness center. They need a database to manage their operations. Here are the business rules:

1. The gym has **members**. Each member has an ID, first name, last name, email, phone, date of birth, and membership start date.

2. The gym offers **membership plans** (e.g., "Basic", "Premium", "Student"). Each plan has a plan ID, name, monthly price, and description. Each member subscribes to exactly one plan. A plan can have many members.

3. The gym has **trainers** (employees who lead classes). Each trainer has an ID, first name, last name, specialization (e.g., "Yoga", "CrossFit"), and hire date.

4. The gym offers **classes** (e.g., "Morning Yoga", "HIIT Blast"). Each class has an ID, name, day of the week, start time, end time, and maximum capacity. Each class is led by exactly one trainer, but a trainer can lead many classes.

5. Members can **register** for classes. A member can register for many classes, and a class can have many registered members. The registration records the registration date.

6. The gym has **equipment** (treadmills, dumbbells, etc.). Each piece of equipment has an ID, name, type, purchase date, and status ("working", "maintenance", "retired").

7. When equipment breaks, a **maintenance request** is created. Each request has an ID, request date, description of the problem, status ("open", "in progress", "closed"), and resolution date. Each request is for exactly one piece of equipment. One piece of equipment can have many maintenance requests over time.

### Task

1. Identify all entities and their attributes (including key attributes).

> [!NOTE]
> ***Your Answer***
>
> *(1. Entities and attributes

Member: member_id (PK), first_name, last_name, email, phone, date_of_birth, membership_start_date, plan_id (FK)
MembershipPlan: plan_id (PK), plan_name, monthly_price, description
Trainer: trainer_id (PK), first_name, last_name, specialization, hire_date
Class: class_id (PK), class_name, day_of_week, start_time, end_time, max_capacity, trainer_id (FK)
Registration: member_id (PK, FK), class_id (PK, FK), registration_date
Equipment: equipment_id (PK), name, type, purchase_date, status
MaintenanceRequest: request_id (PK), equipment_id (FK), request_date, description, status, resolution_date)*
>
>
>
>

2. Identify all relationships with their cardinality and participation constraints.

> [!NOTE]
> ***Your Answer***
>
> *(One MembershipPlan can have many Members, while each member belongs to one plan.
One Trainer can teach many Classes, while each class has one trainer.
Member and Class have an M:N relationship through Registration. A member can join many classes and a class can have many members.
One Equipment item can have many MaintenanceRequests, while each request belongs to one piece of equipment.)*
>
>
>
>

3. Draw a complete ER diagram using crow's foot notation.

> [!NOTE]
> ***Your Answer***
>
> *(https://dbdiagram.io/d/6ab40df45869425612764805)*
>
>
>
>

4. Identify any entity that might be considered a weak entity or a junction/associative entity. Justify your answer.

> [!NOTE]
> ***Your Answer***
>
> *(Registration is a junction entity because it connects Member and Class and resolves their many-to-many relationship. Its primary key consists of member_id and class_id. MaintenanceRequest depends on equipment, but it is not a weak entity because it has its own primary key, request_id.)*
>
>
>
>

5. Are there any M:N relationships? If so, what junction entity resolves them?

> [!NOTE]
> ***Your Answer***
>
> *(Yes. Member and Class have a many-to-many relationship. This is handled through the Registration table.)*
>
>
>
>
---

## Exercise 5: Find and Correct the Errors

The following ER diagram description contains **four errors**. Find each error, explain why it's wrong, and provide the correction.

### Scenario: Online Bookstore

**Entities and attributes:**

1. **Books**
   - book_id (PK)
   - title
   - author_name
   - price
   - genres (stores "Fiction, Mystery, Thriller" as a comma-separated string)

2. **Customer**
   - customer_id (PK)
   - full_name
   - address

3. **Purchase**
   - purchase_id (PK)
   - purchase_date
   - total_amount

**Relationships:**
- Books to Customer: M:N (implemented directly — no junction table)
- Customer to Purchase: 1:N (one customer, many purchases)
- Books to Purchase: no relationship defined

### Your Task

Find the four errors in this design and for each one:

a) State what the error is
> [!NOTE]
> ***Your Answer***
>
>  Multivalued attribute, M:N implemented directly, Entity naming and Missing relationship
>
>
>

b) Explain why it's a problem (reference the relevant theory section)

> [!NOTE]
> ***Your Answer***
>
> *(A better solution is to create a Genre table and a BookGenres junction table. This allows each book to have multiple genres.
> )*
>
>
>
>

c) Describe how to fix it

> [!NOTE]
> ***Your Answer***
>
> *(A better solution is to create a Genre table and a BookGenres junction table. This allows each book to have multiple genres.)*
>
>
>
>

**Hints:** Think about multivalued attributes, M:N relationships, entity naming conventions, and missing relationships.

---

## Submission Checklist

- [ ] Exercise 1: ER diagram + design decision paragraph (including why Week 37's category FK is replaced)
- [ ] Exercise 2: All 12 theory review answers, plus 11b
- [ ] Exercise 3: All questions answered for both Diagram A and Diagram B
- [ ] Exercise 4: Entity list, relationship list, ER diagram, and justifications
- [ ] Exercise 5: Four errors identified with explanations and corrections

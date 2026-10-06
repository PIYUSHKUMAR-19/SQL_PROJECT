 # 📚 Library Management System — MySQL

A **MySQL-based relational database project** designed to manage books, members, employees, branches, book issues, and returns while performing real-world analysis using SQL.

## 🛠️ Tech Stack

* MySQL
* SQL
* CTEs
* Window Functions
* Joins
* Aggregate Functions

## 🗂️ Database Tables

| Table           | Purpose                     |
| --------------- | --------------------------- |
| `books`         | Book details & availability |
| `branch`        | Library branch information  |
| `employees`     | Employee details            |
| `members`       | Member information          |
| `issued_status` | Book issue records          |
| `return_status` | Book return records         |

## 🔑 Key SQL Concepts

* `SELECT`, `WHERE`, `ORDER BY`
* `GROUP BY`, `HAVING`
* `JOIN`
* `COUNT()`, `SUM()`, `AVG()`
* Conditional Aggregation
* CTE (`WITH`)
* `ROW_NUMBER()`
* `PARTITION BY`

## 📊 Analysis Examples

```sql
SUM(status = 'yes') AS available_books
```

Used to calculate available books through conditional aggregation.

```sql
ROW_NUMBER() OVER(
    PARTITION BY issued_member_id
    ORDER BY issued_date DESC
)
```

Used to identify the latest issue for each member.

## 🎯 Project Goals

* Practice relational database design
* Understand Primary & Foreign Keys
* Perform SQL-based data analysis
* Solve practical library management problems
* Generate meaningful insights from transactional data

## 🚀 Future Scope

* Power BI dashboard
* Python-based analysis
* Automated library reports

## 👨‍💻 Author

**Piyush Kumar**
 

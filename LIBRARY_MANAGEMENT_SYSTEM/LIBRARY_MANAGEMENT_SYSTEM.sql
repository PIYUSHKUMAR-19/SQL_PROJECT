#---------------------------------------LIBRARY_MANAGEMENT_SYSTEM----------------------------------------------------#


#CREATING DATABASE -LIBRARY_MANAGEMENT_SYSTEM
create database LIBRARY_MANAGEMENT_SYSTEM;


#TAKING ITS ACCESS
USE LIBRARY_MANAGEMENT_SYSTEM;


#INVISILATING THE BRANCH TABLE DATA
SELECT * FROM branch;
desc branch;


##INVISILATING THE EMPLOYEE TABLE DATA
SELECT * FROM employees;
desc employees;


##INVISILATING THE BOOKS TABLE DATA
SELECT * FROM books;
desc books;


#INVISILATING THE MEMBERS TABLE DATA
select * from members;
desc members;

#INVISILATING THE ISSUED TABLE DATA
SELECT * FROM issued_status;
desc issued_status;


#INVISILATING THE RETURN TABLE DATA
SELECT * FROM return_status;
desc return_status;


SELECT branch_id FROM branch;
SELECT emp_id FROM employees;
SELECT member_id FROM members;

SELECT isbn FROM books;

SELECT issued_id, issued_member_id, issued_book_isbn, issued_emp_id
FROM issued_status;

SELECT return_id, issued_id
FROM return_status;


SELECT b.manager_id
FROM branch b
LEFT JOIN employees e
    ON b.manager_id = e.emp_id
WHERE b.manager_id IS NOT NULL
  AND e.emp_id IS NULL;
  
  
SELECT i.issued_member_id
FROM issued_status i
LEFT JOIN members m
    ON i.issued_member_id = m.member_id
WHERE i.issued_member_id IS NOT NULL
  AND m.member_id IS NULL;

 

SELECT i.issued_book_isbn
FROM issued_status i
LEFT JOIN books b
    ON i.issued_book_isbn = b.isbn
WHERE i.issued_book_isbn IS NOT NULL
  AND b.isbn IS NULL;
 

SELECT i.issued_emp_id
FROM issued_status i
LEFT JOIN employees e
    ON i.issued_emp_id = e.emp_id
WHERE i.issued_emp_id IS NOT NULL
  AND e.emp_id IS NULL;
  
  
SELECT r.issued_id
FROM return_status r
LEFT JOIN issued_status i
    ON r.issued_id = i.issued_id
WHERE r.issued_id IS NOT NULL
  AND i.issued_id IS NULL;
  
  
SELECT issued_id
FROM issued_status
WHERE issued_id IN ('IS101', 'IS105', 'IS103');  



SELECT *
FROM return_status
WHERE issued_id IN ('IS101', 'IS105', 'IS103');



SELECT issued_id
FROM issued_status
ORDER BY issued_id;


SELECT COUNT(*) AS total_issued_records
FROM issued_status;


SELECT COUNT(*) AS total_return_records
FROM return_status;



SELECT *
FROM return_status
ORDER BY return_id;


SELECT *
FROM issued_status
ORDER BY issued_date
LIMIT 10;


SELECT 
    MIN(issued_date) AS first_issue_date,
    MAX(issued_date) AS last_issue_date
FROM issued_status;


CREATE TABLE return_status_backup AS
SELECT *
FROM return_status
WHERE issued_id IN ('IS101', 'IS105', 'IS103');
 


SELECT * FROM return_status_backup;


DELETE FROM return_status
WHERE issued_id IN ('IS101', 'IS105', 'IS103');



DELETE FROM return_status
WHERE return_id IN ('RS101', 'RS102', 'RS103');


SELECT COUNT(*) AS total_return_records
FROM return_status;


ALTER TABLE employees
ADD CONSTRAINT fk_employees_branch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);



ALTER TABLE branch
ADD CONSTRAINT fk_branch_manager
FOREIGN KEY (manager_id)
REFERENCES employees(emp_id);



ALTER TABLE issued_status
ADD CONSTRAINT fk_issued_member
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);


ALTER TABLE issued_status
ADD CONSTRAINT fk_issued_book
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);



ALTER TABLE issued_status
ADD CONSTRAINT fk_issued_employee
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);


SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    COLUMN_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'library_management_system'
  AND COLUMN_NAME = 'issued_id'
  AND TABLE_NAME IN ('issued_status', 'return_status');
  
  
  
ALTER TABLE return_status
MODIFY COLUMN issued_id VARCHAR(15);


SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    COLUMN_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'library_management_system'
  AND COLUMN_NAME = 'issued_id'
  AND TABLE_NAME IN ('issued_status', 'return_status');
  
  

ALTER TABLE return_status
ADD CONSTRAINT fk_return_issued
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);



SELECT
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'library_management_system'
  AND REFERENCED_TABLE_NAME IS NOT NULL;
  
  
  
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    COLUMN_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'library_management_system'
  AND COLUMN_KEY = 'PRI'
ORDER BY TABLE_NAME;  


SHOW CREATE TABLE issued_status;



SELECT
    TABLE_NAME,
    COLUMN_NAME,
    COLUMN_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'library_management_system'
  AND COLUMN_NAME IN (
      'branch_id',
      'manager_id',
      'emp_id',
      'member_id',
      'issued_id',
      'issued_member_id',
      'issued_book_isbn',
      'issued_emp_id',
      'return_id',
      'isbn'
  )
ORDER BY TABLE_NAME, COLUMN_NAME;



SELECT
    TABLE_NAME,
    COLUMN_NAME,
    COLUMN_TYPE,
    CHARACTER_SET_NAME,
    COLLATION_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'library_management_system'
  AND COLUMN_NAME IN (
      'emp_id',
      'manager_id',
      'member_id',
      'issued_member_id',
      'issued_emp_id'
  );



START TRANSACTION;

INSERT INTO issued_status
(issued_id, issued_member_id)
VALUES
('TEST999', 'INVALID_MEMBER');

 
 
 ROLLBACK;
 
 
START TRANSACTION;

INSERT INTO issued_status
(issued_id, issued_book_isbn)
VALUES
('TEST998', 'INVALID_ISBN');

ROLLBACK;



START TRANSACTION;

INSERT INTO issued_status
(issued_id, issued_emp_id)
VALUES
('TEST997', 'INVALID_EMP');


ROLLBACK;


START TRANSACTION;

INSERT INTO return_status
(return_id, issued_id)
VALUES
('TEST996', 'INVALID_ISSUE');

ROLLBACK;


SELECT COUNT(*) AS backup_records
FROM return_status_backup;


SELECT
    (SELECT COUNT(*)
     FROM branch b
     LEFT JOIN employees e
        ON b.manager_id = e.emp_id
     WHERE b.manager_id IS NOT NULL
       AND e.emp_id IS NULL) AS invalid_manager_ids,

    (SELECT COUNT(*)
     FROM employees e
     LEFT JOIN branch b
        ON e.branch_id = b.branch_id
     WHERE e.branch_id IS NOT NULL
       AND b.branch_id IS NULL) AS invalid_branch_ids,

    (SELECT COUNT(*)
     FROM issued_status i
     LEFT JOIN members m
        ON i.issued_member_id = m.member_id
     WHERE i.issued_member_id IS NOT NULL
       AND m.member_id IS NULL) AS invalid_member_ids,

    (SELECT COUNT(*)
     FROM issued_status i
     LEFT JOIN books b
        ON i.issued_book_isbn = b.isbn
     WHERE i.issued_book_isbn IS NOT NULL
       AND b.isbn IS NULL) AS invalid_book_ids,

    (SELECT COUNT(*)
     FROM issued_status i
     LEFT JOIN employees e
        ON i.issued_emp_id = e.emp_id
     WHERE i.issued_emp_id IS NOT NULL
       AND e.emp_id IS NULL) AS invalid_employee_ids,

    (SELECT COUNT(*)
     FROM return_status r
     LEFT JOIN issued_status i
        ON r.issued_id = i.issued_id
     WHERE r.issued_id IS NOT NULL
       AND i.issued_id IS NULL) AS invalid_issued_ids;

 
SELECT
    'books' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(isbn) AS non_null_ids,
    COUNT(DISTINCT isbn) AS unique_ids
FROM books

UNION ALL

SELECT
    'branch',
    COUNT(*),
    COUNT(branch_id),
    COUNT(DISTINCT branch_id)
FROM branch

UNION ALL

SELECT
    'employees',
    COUNT(*),
    COUNT(emp_id),
    COUNT(DISTINCT emp_id)
FROM employees

UNION ALL

SELECT
    'members',
    COUNT(*),
    COUNT(member_id),
    COUNT(DISTINCT member_id)
FROM members

UNION ALL

SELECT
    'issued_status',
    COUNT(*),
    COUNT(issued_id),
    COUNT(DISTINCT issued_id)
FROM issued_status

UNION ALL

SELECT
    'return_status',
    COUNT(*),
    COUNT(return_id),
    COUNT(DISTINCT return_id)
FROM return_status; 


SELECT
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'library_management_system'
ORDER BY TABLE_NAME, COLUMN_NAME;

SELECT
    kcu.TABLE_NAME,
    kcu.COLUMN_NAME,
    kcu.CONSTRAINT_NAME,
    kcu.REFERENCED_TABLE_NAME,
    kcu.REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS kcu
JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS tc
    ON kcu.CONSTRAINT_SCHEMA = tc.CONSTRAINT_SCHEMA
    AND kcu.TABLE_NAME = tc.TABLE_NAME
    AND kcu.CONSTRAINT_NAME = tc.CONSTRAINT_NAME
WHERE kcu.TABLE_SCHEMA = 'library_management_system'
  AND tc.CONSTRAINT_TYPE = 'FOREIGN KEY'
ORDER BY kcu.TABLE_NAME, kcu.COLUMN_NAME;


SELECT
    'books' AS table_name, COUNT(*) AS total_rows FROM books

UNION ALL

SELECT
    'branch', COUNT(*) FROM branch

UNION ALL

SELECT
    'employees', COUNT(*) FROM employees

UNION ALL

SELECT
    'members', COUNT(*) FROM members

UNION ALL

SELECT
    'issued_status', COUNT(*) FROM issued_status

UNION ALL

SELECT
    'return_status', COUNT(*) FROM return_status

UNION ALL

SELECT
    'return_status_backup', COUNT(*) FROM return_status_backup;

 
SELECT
    i.issued_id,
    m.member_name,
    b.book_title,
    e.emp_name,
    i.issued_date
FROM issued_status i
JOIN members m
    ON i.issued_member_id = m.member_id
JOIN books b
    ON i.issued_book_isbn = b.isbn
JOIN employees e
    ON i.issued_emp_id = e.emp_id;
    
    

SELECT
    r.return_id,
    r.issued_id,
    m.member_name,
    b.book_title,
    i.issued_date,
    r.return_date
FROM return_status r
JOIN issued_status i
    ON r.issued_id = i.issued_id
JOIN members m
    ON i.issued_member_id = m.member_id
JOIN books b
    ON i.issued_book_isbn = b.isbn
ORDER BY r.return_id;    



SELECT
    r.return_id,
    r.issued_id,
    i.issued_date,
    r.return_date
FROM return_status r
JOIN issued_status i
    ON r.issued_id = i.issued_id
WHERE r.return_date < i.issued_date;



SHOW CREATE TABLE return_status;



SELECT
    branch_id,
    manager_id
FROM branch
ORDER BY branch_id;



SELECT
    b.branch_id,
    b.manager_id,
    e.emp_name,
    e.branch_id AS manager_branch_id
FROM branch b
JOIN employees e
    ON b.manager_id = e.emp_id
ORDER BY b.branch_id;



SELECT
    b.branch_id,
    b.manager_id,
    e.emp_name,
    e.branch_id AS employee_branch_id
FROM branch b
JOIN employees e
    ON b.manager_id = e.emp_id
WHERE e.branch_id <> b.branch_id;



SELECT
    emp_id,
    emp_name,
    position,
    branch_id
FROM employees
WHERE emp_id IN ('E109', 'E110');



SELECT
    'Branch' AS id_type,
    branch_id AS id
FROM branch

UNION ALL

SELECT
    'Employee',
    emp_id
FROM employees

UNION ALL

SELECT
    'Member',
    member_id
FROM members

UNION ALL

SELECT
    'Issue',
    issued_id
FROM issued_status

UNION ALL

SELECT
    'Return',
    return_id
FROM return_status

ORDER BY id_type, id;




SELECT *
FROM members
ORDER BY member_id;



SELECT CONCAT(
    'C',
    LPAD(
        COALESCE(MAX(CAST(SUBSTRING(member_id, 2) AS UNSIGNED)), 100) + 1,
        3,
        '0'
    )
) AS next_member_id
FROM members;



INSERT INTO members
(member_id, member_name, member_address, reg_date)
VALUES
('C120', 'Test Member', 'Jamshedpur, Jharkhand', CURDATE());



SELECT *
FROM members
WHERE member_id = 'C120';

SELECT CONCAT(
    'IS',
    LPAD(
        COALESCE(MAX(CAST(SUBSTRING(issued_id, 3) AS UNSIGNED)), 100) + 1,
        3,
        '0'
    )
) AS next_issued_id
FROM issued_status;



SELECT isbn
FROM books
LIMIT 1;


SELECT emp_id
FROM employees
LIMIT 1;


INSERT INTO issued_status
(
    issued_id,
    issued_member_id,
    issued_book_name,
    issued_date,
    issued_book_isbn,
    issued_emp_id
)
SELECT
    'IS141',
    'C120',
    book_title,
    CURDATE(),
    isbn,
    'E101'
FROM books
WHERE isbn = '978-0-06-025492-6';


SELECT
    i.issued_id,
    i.issued_member_id,
    m.member_name,
    i.issued_book_isbn,
    b.book_title,
    i.issued_emp_id,
    e.emp_name,
    i.issued_date
FROM issued_status i
JOIN members m
    ON i.issued_member_id = m.member_id
JOIN books b
    ON i.issued_book_isbn = b.isbn
JOIN employees e
    ON i.issued_emp_id = e.emp_id
WHERE i.issued_id = 'IS141';



SELECT CONCAT(
    'RS',
    LPAD(
        COALESCE(MAX(CAST(SUBSTRING(return_id, 3) AS UNSIGNED)), 100) + 1,
        3,
        '0'
    )
) AS next_return_id
FROM return_status;



INSERT INTO return_status
(
    return_id,
    issued_id,
    return_book_name,
    return_date,
    return_book_isbn
)
SELECT
    'RS119',
    issued_id,
    issued_book_name,
    CURDATE(),
    issued_book_isbn
FROM issued_status
WHERE issued_id = 'IS141';


SELECT
    r.return_id,
    r.issued_id,
    r.return_book_name,
    r.return_book_isbn,
    r.return_date
FROM return_status r
WHERE r.return_id = 'RS119';


SELECT
    isbn,
    book_title,
    status
FROM books
WHERE isbn = '978-0-06-025492-6';


SELECT
    status,
    COUNT(*) AS total_books
FROM books
GROUP BY status;


SELECT
    isbn,
    book_title,
    status
FROM books
WHERE status = 'no';


SELECT
    i.issued_id,
    i.issued_book_isbn,
    i.issued_book_name,
    i.issued_date,
    r.return_id,
    r.return_date
FROM issued_status i
LEFT JOIN return_status r
    ON i.issued_id = r.issued_id
WHERE i.issued_book_isbn IN (
    '978-0-307-58837-1',
    '978-0-375-41398-8',
    '978-0-7432-7357-1'
);

SELECT
    b.isbn,
    b.book_title,
    b.status,
    i.issued_id,
    i.issued_date
FROM books b
LEFT JOIN issued_status i
    ON b.isbn = i.issued_book_isbn
LEFT JOIN return_status r
    ON i.issued_id = r.issued_id
WHERE b.status = 'no'
  AND r.return_id IS NULL;
 
 

SELECT
    b.isbn,
    b.book_title,
    b.status,
    i.issued_id,
    i.issued_date
FROM books b
JOIN issued_status i
    ON b.isbn = i.issued_book_isbn
WHERE b.status = 'yes'
  AND NOT EXISTS (
      SELECT 1
      FROM return_status r
      WHERE r.issued_id = i.issued_id
  ); 
  
  
  
 

SELECT
    b.status,
    CASE
        WHEN r.return_id IS NULL THEN 'Not Returned'
        ELSE 'Returned'
    END AS return_state,
    COUNT(*) AS total_books
FROM books b
JOIN issued_status i
    ON b.isbn = i.issued_book_isbn
LEFT JOIN return_status r
    ON i.issued_id = r.issued_id
GROUP BY
    b.status,
    return_state
ORDER BY
    b.status,
    return_state; 
    
    
 
 
 
 
 
SELECT
    b.status,
    CASE
        WHEN r.return_id IS NULL THEN 'Not Returned'
        ELSE 'Returned'
    END AS return_state,
    COUNT(*) AS total_books
FROM books b
JOIN issued_status i
    ON b.isbn = i.issued_book_isbn
LEFT JOIN return_status r
    ON i.issued_id = r.issued_id
GROUP BY
    b.status,
    return_state
ORDER BY
    b.status,
    return_state; 
 
 
 SELECT
    b.status,
    CASE
        WHEN r.return_id IS NULL THEN 'Not Returned'
        ELSE 'Returned'
    END AS return_state,
    COUNT(*) AS total_books
FROM books b
JOIN issued_status i
    ON b.isbn = i.issued_book_isbn
LEFT JOIN return_status r
    ON i.issued_id = r.issued_id
GROUP BY
    b.status,
    return_state
ORDER BY
    b.status,
    return_state;
 
 
SELECT
    issued_book_isbn,
    issued_book_name,
    COUNT(*) AS issue_count,
    GROUP_CONCAT(issued_id ORDER BY issued_date) AS issue_ids
FROM issued_status
GROUP BY issued_book_isbn, issued_book_name
HAVING COUNT(*) > 1;



WITH latest_issue AS (
    SELECT
        i.*,
        ROW_NUMBER() OVER (
            PARTITION BY i.issued_book_isbn
            ORDER BY i.issued_date DESC, i.issued_id DESC
        ) AS rn
    FROM issued_status i
)
SELECT
    b.isbn,
    b.book_title,
    b.status,
    l.issued_id AS latest_issued_id,
    l.issued_date AS latest_issued_date,
    r.return_id,
    r.return_date,
    CASE
        WHEN r.return_id IS NULL THEN 'Currently Issued'
        ELSE 'Returned'
    END AS latest_transaction_status
FROM books b
LEFT JOIN latest_issue l
    ON b.isbn = l.issued_book_isbn
   AND l.rn = 1
LEFT JOIN return_status r
    ON l.issued_id = r.issued_id
WHERE l.issued_id IS NOT NULL
ORDER BY b.isbn;




WITH latest_issue AS (
    SELECT
        i.*,
        ROW_NUMBER() OVER (
            PARTITION BY i.issued_book_isbn
            ORDER BY i.issued_date DESC, i.issued_id DESC
        ) AS rn
    FROM issued_status i
)
SELECT
    b.isbn,
    b.book_title,
    b.status AS current_status,
    l.issued_id AS latest_issued_id,
    CASE
        WHEN r.return_id IS NULL THEN 'Currently Issued'
        ELSE 'Available'
    END AS correct_status
FROM books b
JOIN latest_issue l
    ON b.isbn = l.issued_book_isbn
   AND l.rn = 1
LEFT JOIN return_status r
    ON l.issued_id = r.issued_id
WHERE
    (b.status = 'yes' AND r.return_id IS NULL)
    OR
    (b.status = 'no' AND r.return_id IS NOT NULL)
ORDER BY b.isbn;



START TRANSACTION;

UPDATE books
SET status = 'no'
WHERE isbn IN (
    '978-0-06-112008-4',
    '978-0-06-112241-5',
    '978-0-06-440055-8',
    '978-0-14-027526-3',
    '978-0-330-25864-8',
    '978-0-345-39180-3',
    '978-0-385-33312-0',
    '978-0-451-52993-5',
    '978-0-451-52994-2',
    '978-0-525-47535-5',
    '978-0-553-29698-2',
    '978-0-679-76489-8',
    '978-0-679-77644-3',
    '978-0-7432-4722-5',
    '978-0-7434-7679-3'
);




SELECT
    isbn,
    book_title,
    status
FROM books
WHERE isbn IN (
    '978-0-06-112008-4',
    '978-0-06-112241-5',
    '978-0-06-440055-8',
    '978-0-14-027526-3',
    '978-0-330-25864-8',
    '978-0-345-39180-3',
    '978-0-385-33312-0',
    '978-0-451-52993-5',
    '978-0-451-52994-2',
    '978-0-525-47535-5',
    '978-0-553-29698-2',
    '978-0-679-76489-8',
    '978-0-679-77644-3',
    '978-0-7432-4722-5',
    '978-0-7434-7679-3'
)
ORDER BY isbn;





SELECT
    status,
    COUNT(*) AS total_books
FROM books
GROUP BY status
ORDER BY status;



COMMIT;



WITH latest_issue AS (
    SELECT
        i.*,
        ROW_NUMBER() OVER (
            PARTITION BY i.issued_book_isbn
            ORDER BY i.issued_date DESC, i.issued_id DESC
        ) AS rn
    FROM issued_status i
)
SELECT
    b.isbn,
    b.book_title,
    b.status AS stored_status,
    CASE
        WHEN l.issued_id IS NULL THEN 'yes'
        WHEN r.return_id IS NULL THEN 'no'
        ELSE 'yes'
    END AS calculated_status
FROM books b
LEFT JOIN latest_issue l
    ON b.isbn = l.issued_book_isbn
   AND l.rn = 1
LEFT JOIN return_status r
    ON l.issued_id = r.issued_id
WHERE b.status <> (
    CASE
        WHEN l.issued_id IS NULL THEN 'yes'
        WHEN r.return_id IS NULL THEN 'no'
        ELSE 'yes'
    END
)
ORDER BY b.isbn;




SELECT
    i.issued_id,
    i.issued_date,
    r.return_id,
    r.return_date
FROM issued_status i
LEFT JOIN return_status r
    ON i.issued_id = r.issued_id
WHERE i.issued_book_isbn = '978-0-7432-7356-4';


START TRANSACTION;

UPDATE books
SET status = 'no'
WHERE isbn = '978-0-7432-7356-4';



SELECT
    isbn,
    book_title,
    status
FROM books
WHERE isbn = '978-0-7432-7356-4';




WITH latest_issue AS (
    SELECT
        i.*,
        ROW_NUMBER() OVER (
            PARTITION BY i.issued_book_isbn
            ORDER BY i.issued_date DESC, i.issued_id DESC
        ) AS rn
    FROM issued_status i
)
SELECT
    b.isbn,
    b.book_title,
    b.status AS stored_status,
    CASE
        WHEN l.issued_id IS NULL THEN 'yes'
        WHEN r.return_id IS NULL THEN 'no'
        ELSE 'yes'
    END AS calculated_status
FROM books b
LEFT JOIN latest_issue l
    ON b.isbn = l.issued_book_isbn
   AND l.rn = 1
LEFT JOIN return_status r
    ON l.issued_id = r.issued_id
WHERE b.status <> (
    CASE
        WHEN l.issued_id IS NULL THEN 'yes'
        WHEN r.return_id IS NULL THEN 'no'
        ELSE 'yes'
    END
)
ORDER BY b.isbn;



COMMIT;




SELECT
    COUNT(*) AS total_returns,
    COUNT(return_id) AS return_ids_present,
    COUNT(issued_id) AS issued_ids_present,
    COUNT(return_book_name) AS book_names_present,
    COUNT(return_date) AS return_dates_present,
    COUNT(return_book_isbn) AS book_isbns_present
FROM return_status;



SELECT
    COUNT(*) AS total_rows,

    SUM(issued_id IS NULL) AS issued_id_nulls,
    SUM(TRIM(issued_id) = '') AS issued_id_empty,

    SUM(return_book_name IS NULL) AS book_name_nulls,
    SUM(TRIM(return_book_name) = '') AS book_name_empty,

    SUM(return_book_isbn IS NULL) AS isbn_nulls,
    SUM(TRIM(return_book_isbn) = '') AS isbn_empty

FROM return_status;



SELECT
    r.return_id,
    r.issued_id,
    r.return_book_name,
    r.return_book_isbn,
    i.issued_book_name,
    i.issued_book_isbn
FROM return_status r
JOIN issued_status i
    ON r.issued_id = i.issued_id
WHERE r.return_book_name IS NULL
   OR r.return_book_isbn IS NULL
ORDER BY r.return_id;




START TRANSACTION;

UPDATE return_status r
JOIN issued_status i
    ON r.issued_id = i.issued_id
SET
    r.return_book_name = i.issued_book_name,
    r.return_book_isbn = i.issued_book_isbn
WHERE r.return_book_name IS NULL
   OR r.return_book_isbn IS NULL;
   
   
UPDATE return_status r
JOIN issued_status i
    ON r.issued_id = i.issued_id
SET
    r.return_book_name = i.issued_book_name,
    r.return_book_isbn = i.issued_book_isbn
WHERE r.return_id IN (
    'RS104',
    'RS105',
    'RS106',
    'RS107',
    'RS108',
    'RS109',
    'RS110',
    'RS111',
    'RS112',
    'RS113',
    'RS114',
    'RS115',
    'RS116',
    'RS117',
    'RS118'
);



UPDATE return_status
SET
    return_book_name = (
        SELECT i.issued_book_name
        FROM issued_status i
        WHERE i.issued_id = return_status.issued_id
    ),
    return_book_isbn = (
        SELECT i.issued_book_isbn
        FROM issued_status i
        WHERE i.issued_id = return_status.issued_id
    )
WHERE return_id IN (
    'RS104',
    'RS105',
    'RS106',
    'RS107',
    'RS108',
    'RS109',
    'RS110',
    'RS111',
    'RS112',
    'RS113',
    'RS114',
    'RS115',
    'RS116',
    'RS117',
    'RS118'
);



SELECT
    r.return_id,
    r.issued_id,
    r.return_book_name,
    r.return_book_isbn
FROM return_status r
WHERE r.return_id BETWEEN 'RS104' AND 'RS118'
ORDER BY r.return_id;



SELECT
    COUNT(*) AS total_returns,
    SUM(return_book_name IS NULL) AS missing_book_names,
    SUM(return_book_isbn IS NULL) AS missing_book_isbns
FROM return_status;



COMMIT;


SELECT
    r.return_id,
    r.issued_id,
    r.return_book_name,
    i.issued_book_name,
    r.return_book_isbn,
    i.issued_book_isbn
FROM return_status r
JOIN issued_status i
    ON r.issued_id = i.issued_id
WHERE NOT (
    r.return_book_name <=> i.issued_book_name
)
OR NOT (
    r.return_book_isbn <=> i.issued_book_isbn
);




SELECT
    (SELECT COUNT(*)
     FROM branch b
     LEFT JOIN employees e
        ON b.manager_id = e.emp_id
     WHERE b.manager_id IS NOT NULL
       AND e.emp_id IS NULL) AS invalid_manager_ids,

    (SELECT COUNT(*)
     FROM employees e
     LEFT JOIN branch b
        ON e.branch_id = b.branch_id
     WHERE e.branch_id IS NOT NULL
       AND b.branch_id IS NULL) AS invalid_branch_ids,

    (SELECT COUNT(*)
     FROM issued_status i
     LEFT JOIN members m
        ON i.issued_member_id = m.member_id
     WHERE i.issued_member_id IS NOT NULL
       AND m.member_id IS NULL) AS invalid_member_ids,

    (SELECT COUNT(*)
     FROM issued_status i
     LEFT JOIN books b
        ON i.issued_book_isbn = b.isbn
     WHERE i.issued_book_isbn IS NOT NULL
       AND b.isbn IS NULL) AS invalid_book_ids,

    (SELECT COUNT(*)
     FROM issued_status i
     LEFT JOIN employees e
        ON i.issued_emp_id = e.emp_id
     WHERE i.issued_emp_id IS NOT NULL
       AND e.emp_id IS NULL) AS invalid_employee_ids,

    (SELECT COUNT(*)
     FROM return_status r
     LEFT JOIN issued_status i
        ON r.issued_id = i.issued_id
     WHERE r.issued_id IS NOT NULL
       AND i.issued_id IS NULL) AS invalid_issued_ids;
       
       
       
       

SELECT
    i.issued_id,
    m.member_name,
    b.book_title,
    e.emp_name,
    i.issued_date
FROM issued_status i
JOIN members m
    ON i.issued_member_id = m.member_id
JOIN books b
    ON i.issued_book_isbn = b.isbn
JOIN employees e
    ON i.issued_emp_id = e.emp_id
LEFT JOIN return_status r
    ON i.issued_id = r.issued_id
WHERE r.return_id IS NULL
ORDER BY i.issued_date;       




WITH latest_issue AS (
    SELECT
        i.*,
        ROW_NUMBER() OVER (
            PARTITION BY i.issued_book_isbn
            ORDER BY i.issued_date DESC, i.issued_id DESC
        ) AS rn
    FROM issued_status i
)
SELECT
    l.issued_id,
    m.member_name,
    b.book_title,
    e.emp_name,
    l.issued_date
FROM latest_issue l
JOIN members m
    ON l.issued_member_id = m.member_id
JOIN books b
    ON l.issued_book_isbn = b.isbn
JOIN employees e
    ON l.issued_emp_id = e.emp_id
WHERE l.rn = 1
  AND NOT EXISTS (
      SELECT 1
      FROM return_status r
      WHERE r.issued_id = l.issued_id
  )
ORDER BY l.issued_date;



SELECT
    status,
    COUNT(*) AS total_books
FROM books
GROUP BY status
ORDER BY status;



SELECT
    isbn,
    book_title,
    category,
    status
FROM books
WHERE status = 'yes'
ORDER BY book_title;



SELECT
    isbn,
    book_title,
    category,
    status
FROM books
WHERE status = 'yes'
  AND isbn NOT IN (
      SELECT issued_book_isbn
      FROM issued_status
  )
ORDER BY book_title;





WITH latest_issue AS (
    SELECT
        i.*,
        ROW_NUMBER() OVER (
            PARTITION BY i.issued_book_isbn
            ORDER BY i.issued_date DESC, i.issued_id DESC
        ) AS rn
    FROM issued_status i
)
SELECT
    l.issued_id,
    m.member_id,
    m.member_name,
    b.book_title,
    l.issued_date
FROM latest_issue l
JOIN members m
    ON l.issued_member_id = m.member_id
JOIN books b
    ON l.issued_book_isbn = b.isbn
WHERE l.rn = 1
  AND NOT EXISTS (
      SELECT 1
      FROM return_status r
      WHERE r.issued_id = l.issued_id
  )
ORDER BY m.member_name, l.issued_date;




WITH latest_issue AS (
    SELECT
        i.*,
        ROW_NUMBER() OVER (
            PARTITION BY i.issued_book_isbn
            ORDER BY i.issued_date DESC, i.issued_id DESC
        ) AS rn
    FROM issued_status i
)
SELECT
    m.member_id,
    m.member_name,
    COUNT(*) AS currently_issued_books
FROM latest_issue l
JOIN members m
    ON l.issued_member_id = m.member_id
WHERE l.rn = 1
  AND NOT EXISTS (
      SELECT 1
      FROM return_status r
      WHERE r.issued_id = l.issued_id
  )
GROUP BY
    m.member_id,
    m.member_name
HAVING COUNT(*) > 1
ORDER BY currently_issued_books DESC;




WITH latest_issue AS (
    SELECT
        i.*,
        ROW_NUMBER() OVER (
            PARTITION BY i.issued_book_isbn
            ORDER BY i.issued_date DESC, i.issued_id DESC
        ) AS rn
    FROM issued_status i
),
member_loans AS (
    SELECT
        m.member_id,
        m.member_name,
        COUNT(*) AS currently_issued_books
    FROM latest_issue l
    JOIN members m
        ON l.issued_member_id = m.member_id
    WHERE l.rn = 1
      AND NOT EXISTS (
          SELECT 1
          FROM return_status r
          WHERE r.issued_id = l.issued_id
      )
    GROUP BY
        m.member_id,
        m.member_name
)
SELECT
    member_id,
    member_name,
    currently_issued_books
FROM member_loans
WHERE currently_issued_books = (
    SELECT MAX(currently_issued_books)
    FROM member_loans
);




SELECT
    issued_book_isbn,
    issued_book_name,
    COUNT(*) AS total_times_issued
FROM issued_status
GROUP BY
    issued_book_isbn,
    issued_book_name
ORDER BY total_times_issued DESC, issued_book_name;





SELECT
    m.member_id,
    m.member_name,
    COUNT(i.issued_id) AS total_books_issued
FROM members m
JOIN issued_status i
    ON m.member_id = i.issued_member_id
GROUP BY
    m.member_id,
    m.member_name
ORDER BY total_books_issued DESC, m.member_name;



SELECT
    m.member_id,
    m.member_name
FROM members m
LEFT JOIN issued_status i
    ON m.member_id = i.issued_member_id
WHERE i.issued_id IS NULL
ORDER BY m.member_id;



SELECT
    b.category,
    COUNT(i.issued_id) AS total_issues
FROM books b
JOIN issued_status i
    ON b.isbn = i.issued_book_isbn
GROUP BY
    b.category
ORDER BY total_issues DESC;




SELECT
    e.emp_id,
    e.emp_name,
    COUNT(i.issued_id) AS total_issues_processed
FROM employees e
JOIN issued_status i
    ON e.emp_id = i.issued_emp_id
GROUP BY
    e.emp_id,
    e.emp_name
ORDER BY
    total_issues_processed DESC,
    e.emp_name;
    
    
    

SELECT
    b.branch_id,
    COUNT(i.issued_id) AS total_issues
FROM branch b
JOIN employees e
    ON b.branch_id = e.branch_id
JOIN issued_status i
    ON e.emp_id = i.issued_emp_id
GROUP BY
    b.branch_id
ORDER BY total_issues DESC;    


SELECT
    ROUND(AVG(DATEDIFF(r.return_date, i.issued_date)), 2) AS avg_borrowing_days
FROM return_status r
JOIN issued_status i
    ON r.issued_id = i.issued_id;
    
    
    
SELECT
    r.return_id,
    m.member_name,
    b.book_title,
    i.issued_date,
    r.return_date,
    DATEDIFF(r.return_date, i.issued_date) AS borrowing_days
FROM return_status r
JOIN issued_status i
    ON r.issued_id = i.issued_id
JOIN members m
    ON i.issued_member_id = m.member_id
JOIN books b
    ON i.issued_book_isbn = b.isbn
ORDER BY borrowing_days DESC
LIMIT 5;    




SELECT
    m.member_id,
    m.member_name,
    COUNT(r.return_id) AS books_returned,
    ROUND(
        AVG(DATEDIFF(r.return_date, i.issued_date)),
        2
    ) AS avg_borrowing_days
FROM return_status r
JOIN issued_status i
    ON r.issued_id = i.issued_id
JOIN members m
    ON i.issued_member_id = m.member_id
GROUP BY
    m.member_id,
    m.member_name
ORDER BY avg_borrowing_days DESC;
  
 



SELECT
    m.member_id,
    m.member_name,
    COUNT(r.return_id) AS books_returned,
    SUM(DATEDIFF(r.return_date, i.issued_date)) AS total_borrowing_days
FROM return_status r
JOIN issued_status i
    ON r.issued_id = i.issued_id
JOIN members m
    ON i.issued_member_id = m.member_id
GROUP BY
    m.member_id,
    m.member_name
ORDER BY total_borrowing_days DESC;




WITH current_loans AS (
    SELECT
        i.issued_member_id,
        COUNT(*) AS currently_issued_books
    FROM issued_status i
    WHERE NOT EXISTS (
        SELECT 1
        FROM return_status r
        WHERE r.issued_id = i.issued_id
    )
    GROUP BY i.issued_member_id
)
SELECT
    m.member_id,
    m.member_name,
    COUNT(i.issued_id) AS total_issues,
    COUNT(r.return_id) AS books_returned,
    COALESCE(cl.currently_issued_books, 0) AS currently_issued_books
FROM members m
LEFT JOIN issued_status i
    ON m.member_id = i.issued_member_id
LEFT JOIN return_status r
    ON i.issued_id = r.issued_id
LEFT JOIN current_loans cl
    ON m.member_id = cl.issued_member_id
GROUP BY
    m.member_id,
    m.member_name,
    cl.currently_issued_books
ORDER BY
    total_issues DESC,
    m.member_name;
    
    
    
    
    
 
WITH latest_issue AS (
    SELECT
        i.*,
        ROW_NUMBER() OVER (
            PARTITION BY i.issued_book_isbn
            ORDER BY i.issued_date DESC, i.issued_id DESC
        ) AS rn
    FROM issued_status i
),
current_loans AS (
    SELECT
        l.issued_member_id,
        COUNT(*) AS currently_issued_books
    FROM latest_issue l
    WHERE l.rn = 1
      AND NOT EXISTS (
          SELECT 1
          FROM return_status r
          WHERE r.issued_id = l.issued_id
      )
    GROUP BY l.issued_member_id
)
SELECT
    m.member_id,
    m.member_name,
    COUNT(DISTINCT i.issued_id) AS total_issues,
    COUNT(DISTINCT r.return_id) AS books_returned,
    COALESCE(cl.currently_issued_books, 0) AS currently_issued_books
FROM members m
LEFT JOIN issued_status i
    ON m.member_id = i.issued_member_id
LEFT JOIN return_status r
    ON i.issued_id = r.issued_id
LEFT JOIN current_loans cl
    ON m.member_id = cl.issued_member_id
GROUP BY
    m.member_id,
    m.member_name,
    cl.currently_issued_books
ORDER BY
    total_issues DESC,
    m.member_name;
    
    


WITH latest_issue AS (
    SELECT
        i.*,
        ROW_NUMBER() OVER (
            PARTITION BY i.issued_book_isbn
            ORDER BY i.issued_date DESC, i.issued_id DESC
        ) AS rn
    FROM issued_status i
),
current_loans AS (
    SELECT
        l.issued_member_id,
        COUNT(*) AS currently_issued_books
    FROM latest_issue l
    WHERE l.rn = 1
      AND NOT EXISTS (
          SELECT 1
          FROM return_status r
          WHERE r.issued_id = l.issued_id
      )
    GROUP BY l.issued_member_id
)
SELECT
    m.member_id,
    m.member_name,
    cl.currently_issued_books
FROM current_loans cl
JOIN members m
    ON m.member_id = cl.issued_member_id
WHERE cl.currently_issued_books = (
    SELECT MAX(currently_issued_books)
    FROM current_loans
);    





SELECT
    category,
    COUNT(*) AS total_books,
    SUM(status = 'yes') AS available_books,
    SUM(status = 'no') AS currently_issued_books
FROM books
GROUP BY category
ORDER BY total_books DESC, category;
 



SELECT
    category,
    COUNT(*) AS total_books,
    SUM(status = 'no') AS currently_issued_books,
    ROUND(
        SUM(status = 'no') / COUNT(*) * 100,
        2
    ) AS utilization_rate_percent
FROM books
GROUP BY category
ORDER BY utilization_rate_percent DESC, category;




SELECT
    issued_book_isbn,
    issued_book_name,
    COUNT(*) AS total_issues,
    DENSE_RANK() OVER (
        ORDER BY COUNT(*) DESC
    ) AS borrowing_rank
FROM issued_status
GROUP BY
    issued_book_isbn,
    issued_book_name
ORDER BY borrowing_rank, issued_book_name;




WITH book_issue_counts AS (
    SELECT
        issued_book_isbn,
        issued_book_name,
        COUNT(*) AS total_issues
    FROM issued_status
    GROUP BY
        issued_book_isbn,
        issued_book_name
)
SELECT
    issued_book_isbn,
    issued_book_name,
    total_issues
FROM book_issue_counts
WHERE total_issues = (
    SELECT MAX(total_issues)
    FROM book_issue_counts
);




WITH latest_issue AS (
    SELECT
        i.*,
        ROW_NUMBER() OVER (
            PARTITION BY i.issued_book_isbn
            ORDER BY i.issued_date DESC, i.issued_id DESC
        ) AS rn
    FROM issued_status i
)
SELECT
    l.issued_id,
    m.member_name,
    b.book_title,
    l.issued_date,
    DATEDIFF(CURDATE(), l.issued_date) AS days_held
FROM latest_issue l
JOIN members m
    ON l.issued_member_id = m.member_id
JOIN books b
    ON l.issued_book_isbn = b.isbn
WHERE l.rn = 1
  AND NOT EXISTS (
      SELECT 1
      FROM return_status r
      WHERE r.issued_id = l.issued_id
  )
ORDER BY days_held DESC;





WITH latest_issue AS (
    SELECT
        i.*,
        ROW_NUMBER() OVER (
            PARTITION BY i.issued_book_isbn
            ORDER BY i.issued_date DESC, i.issued_id DESC
        ) AS rn
    FROM issued_status i
)
SELECT
    COUNT(*) AS currently_issued_books,
    ROUND(
        AVG(DATEDIFF(CURDATE(), l.issued_date)),
        2
    ) AS avg_current_holding_days,
    MIN(DATEDIFF(CURDATE(), l.issued_date)) AS shortest_holding_days,
    MAX(DATEDIFF(CURDATE(), l.issued_date)) AS longest_holding_days
FROM latest_issue l
WHERE l.rn = 1
  AND NOT EXISTS (
      SELECT 1
      FROM return_status r
      WHERE r.issued_id = l.issued_id
  );
 
 
 
 
 WITH latest_issue AS (
    SELECT
        i.*,
        ROW_NUMBER() OVER (
            PARTITION BY i.issued_book_isbn
            ORDER BY i.issued_date DESC, i.issued_id DESC
        ) AS rn
    FROM issued_status i
),
current_loans AS (
    SELECT
        l.issued_member_id,
        l.issued_id,
        l.issued_date
    FROM latest_issue l
    WHERE l.rn = 1
      AND NOT EXISTS (
          SELECT 1
          FROM return_status r
          WHERE r.issued_id = l.issued_id
      )
)
SELECT
    m.member_id,
    m.member_name,
    COUNT(cl.issued_id) AS currently_held_books,
    ROUND(
        AVG(DATEDIFF(CURDATE(), cl.issued_date)),
        2
    ) AS avg_holding_days,
    SUM(DATEDIFF(CURDATE(), cl.issued_date)) AS total_holding_days
FROM current_loans cl
JOIN members m
    ON cl.issued_member_id = m.member_id
GROUP BY
    m.member_id,
    m.member_name
ORDER BY
    avg_holding_days DESC,
    m.member_name;
    
    
    
  
  

SELECT
    m.member_id,
    m.member_name,
    COUNT(DISTINCT i.issued_id) AS total_issues,
    COUNT(DISTINCT r.return_id) AS total_returns,
    ROUND(
        COUNT(DISTINCT r.return_id)
        / COUNT(DISTINCT i.issued_id) * 100,
        2
    ) AS return_rate_percent
FROM members m
LEFT JOIN issued_status i
    ON m.member_id = i.issued_member_id
LEFT JOIN return_status r
    ON i.issued_id = r.issued_id
GROUP BY
    m.member_id,
    m.member_name
HAVING COUNT(DISTINCT i.issued_id) > 0
ORDER BY
    return_rate_percent DESC,
    m.member_name;  
    
    
    
    
SELECT
    m.member_id,
    m.member_name,
    COUNT(DISTINCT i.issued_id) AS total_issues,
    COUNT(DISTINCT r.return_id) AS total_returns,
    ROUND(
        COUNT(DISTINCT r.return_id)
        / COUNT(DISTINCT i.issued_id) * 100,
        2
    ) AS return_rate_percent
FROM members m
JOIN issued_status i
    ON m.member_id = i.issued_member_id
LEFT JOIN return_status r
    ON i.issued_id = r.issued_id
GROUP BY
    m.member_id,
    m.member_name
HAVING COUNT(DISTINCT i.issued_id) >= 2
ORDER BY
    return_rate_percent DESC,
    total_issues DESC;    
    
    
 

WITH latest_issue AS (
    SELECT
        i.*,
        ROW_NUMBER() OVER (
            PARTITION BY i.issued_book_isbn
            ORDER BY i.issued_date DESC, i.issued_id DESC
        ) AS rn
    FROM issued_status i
),
current_loans AS (
    SELECT
        l.issued_member_id,
        COUNT(*) AS currently_issued_books
    FROM latest_issue l
    WHERE l.rn = 1
      AND NOT EXISTS (
          SELECT 1
          FROM return_status r
          WHERE r.issued_id = l.issued_id
      )
    GROUP BY l.issued_member_id
)
SELECT
    m.member_id,
    m.member_name,
    cl.currently_issued_books,
    ROUND(
        cl.currently_issued_books
        / (SELECT SUM(currently_issued_books) FROM current_loans)
        * 100,
        2
    ) AS share_of_current_loans_percent
FROM current_loans cl
JOIN members m
    ON cl.issued_member_id = m.member_id
ORDER BY
    share_of_current_loans_percent DESC,
    m.member_name; 
    
    
    
    
  

WITH latest_issue AS (
    SELECT
        i.*,
        ROW_NUMBER() OVER (
            PARTITION BY i.issued_book_isbn
            ORDER BY i.issued_date DESC, i.issued_id DESC
        ) AS rn
    FROM issued_status i
),
current_loans AS (
    SELECT
        l.issued_id,
        l.issued_emp_id
    FROM latest_issue l
    WHERE l.rn = 1
      AND NOT EXISTS (
          SELECT 1
          FROM return_status r
          WHERE r.issued_id = l.issued_id
      )
)
SELECT
    b.branch_id,
    COUNT(cl.issued_id) AS currently_issued_books
FROM current_loans cl
JOIN employees e
    ON cl.issued_emp_id = e.emp_id
JOIN branch b
    ON e.branch_id = b.branch_id
GROUP BY
    b.branch_id
ORDER BY
    currently_issued_books DESC,
    b.branch_id;  
    
    
    
    
 
 

WITH latest_issue AS (
    SELECT
        i.*,
        ROW_NUMBER() OVER (
            PARTITION BY i.issued_book_isbn
            ORDER BY i.issued_date DESC, i.issued_id DESC
        ) AS rn
    FROM issued_status i
),
current_loans AS (
    SELECT
        l.issued_id,
        l.issued_emp_id
    FROM latest_issue l
    WHERE l.rn = 1
      AND NOT EXISTS (
          SELECT 1
          FROM return_status r
          WHERE r.issued_id = l.issued_id
      )
),
branch_loans AS (
    SELECT
        b.branch_id,
        COUNT(cl.issued_id) AS currently_issued_books
    FROM current_loans cl
    JOIN employees e
        ON cl.issued_emp_id = e.emp_id
    JOIN branch b
        ON e.branch_id = b.branch_id
    GROUP BY b.branch_id
)
SELECT
    branch_id,
    currently_issued_books,
    ROUND(
        currently_issued_books
        / (SELECT SUM(currently_issued_books) FROM branch_loans) * 100,
        2
    ) AS share_of_current_loans_percent
FROM branch_loans
ORDER BY share_of_current_loans_percent DESC; 
    



WITH latest_issue AS (
    SELECT
        i.*,
        ROW_NUMBER() OVER (
            PARTITION BY i.issued_book_isbn
            ORDER BY i.issued_date DESC, i.issued_id DESC
        ) AS rn
    FROM issued_status i
),
current_loans AS (
    SELECT
        l.issued_id,
        l.issued_emp_id
    FROM latest_issue l
    WHERE l.rn = 1
      AND NOT EXISTS (
          SELECT 1
          FROM return_status r
          WHERE r.issued_id = l.issued_id
      )
),
branch_stats AS (
    SELECT
        b.branch_id,
        COUNT(DISTINCT e.emp_id) AS employee_count,
        COUNT(DISTINCT cl.issued_id) AS current_loans
    FROM branch b
    LEFT JOIN employees e
        ON b.branch_id = e.branch_id
    LEFT JOIN current_loans cl
        ON e.emp_id = cl.issued_emp_id
    GROUP BY b.branch_id
)
SELECT
    branch_id,
    employee_count,
    current_loans,
    ROUND(
        current_loans / NULLIF(employee_count, 0),
        2
    ) AS loans_per_employee
FROM branch_stats
ORDER BY loans_per_employee DESC, branch_id;    
    
 
 
 
 
WITH latest_issue AS (
    SELECT
        i.*,
        ROW_NUMBER() OVER (
            PARTITION BY i.issued_book_isbn
            ORDER BY i.issued_date DESC, i.issued_id DESC
        ) AS rn
    FROM issued_status i
),
current_loans AS (
    SELECT
        l.issued_id,
        l.issued_emp_id
    FROM latest_issue l
    WHERE l.rn = 1
      AND NOT EXISTS (
          SELECT 1
          FROM return_status r
          WHERE r.issued_id = l.issued_id
      )
),
branch_stats AS (
    SELECT
        b.branch_id,
        COUNT(DISTINCT i.issued_id) AS total_issues,
        COUNT(DISTINCT r.return_id) AS total_returns,
        COUNT(DISTINCT cl.issued_id) AS current_loans
    FROM branch b
    LEFT JOIN employees e
        ON b.branch_id = e.branch_id
    LEFT JOIN issued_status i
        ON e.emp_id = i.issued_emp_id
    LEFT JOIN return_status r
        ON i.issued_id = r.issued_id
    LEFT JOIN current_loans cl
        ON e.emp_id = cl.issued_emp_id
    GROUP BY
        b.branch_id
)
SELECT
    branch_id,
    total_issues,
    total_returns,
    current_loans,
    ROUND(
        current_loans /
        NULLIF((SELECT SUM(current_loans) FROM branch_stats), 0) * 100,
        2
    ) AS current_loan_share_percent
FROM branch_stats
ORDER BY current_loans DESC, branch_id; 



SELECT
    b.branch_id,
    COUNT(DISTINCT i.issued_id) AS total_issues,
    COUNT(DISTINCT r.return_id) AS total_returns,
    ROUND(
        COUNT(DISTINCT r.return_id)
        / NULLIF(COUNT(DISTINCT i.issued_id), 0) * 100,
        2
    ) AS return_rate_percent
FROM branch b
LEFT JOIN employees e
    ON b.branch_id = e.branch_id
LEFT JOIN issued_status i
    ON e.emp_id = i.issued_emp_id
LEFT JOIN return_status r
    ON i.issued_id = r.issued_id
GROUP BY b.branch_id
ORDER BY return_rate_percent DESC, b.branch_id;





SELECT
    e.emp_id,
    e.emp_name,
    COUNT(DISTINCT i.issued_id) AS total_issues,
    COUNT(DISTINCT r.return_id) AS total_returns,
    ROUND(
        COUNT(DISTINCT r.return_id)
        / NULLIF(COUNT(DISTINCT i.issued_id), 0) * 100,
        2
    ) AS return_rate_percent
FROM employees e
JOIN issued_status i
    ON e.emp_id = i.issued_emp_id
LEFT JOIN return_status r
    ON i.issued_id = r.issued_id
GROUP BY
    e.emp_id,
    e.emp_name
ORDER BY
    return_rate_percent DESC,
    total_issues DESC;
    
    
    
    
    
SELECT
    YEAR(issued_date) AS issue_year,
    MONTH(issued_date) AS issue_month,
    COUNT(*) AS total_issues
FROM issued_status
GROUP BY
    YEAR(issued_date),
    MONTH(issued_date)
ORDER BY
    issue_year,
    issue_month;  
    
    
    
    
  
SELECT
    YEAR(issued_date) AS issue_year,
    MONTH(issued_date) AS issue_month,
    COUNT(*) AS total_issues,
    ROUND(
        COUNT(*) /
        (SELECT COUNT(*) FROM issued_status) * 100,
        2
    ) AS issue_share_percent
FROM issued_status
GROUP BY
    YEAR(issued_date),
    MONTH(issued_date)
ORDER BY
    issue_year,
    issue_month;  
    
    
    
    
    
    
    
  
SELECT
    ROUND(
        COUNT(*) / COUNT(DISTINCT issued_member_id),
        2
    ) AS avg_issues_per_borrowing_member
FROM issued_status;




SELECT
    COUNT(DISTINCT i.issued_id) AS total_issues,
    COUNT(DISTINCT r.return_id) AS total_returns,
    ROUND(
        COUNT(DISTINCT r.return_id)
        / COUNT(DISTINCT i.issued_id) * 100,
        2
    ) AS overall_return_rate_percent
FROM issued_status i
LEFT JOIN return_status r
    ON i.issued_id = r.issued_id;
    
    
    
    
    
 SELECT
    b.category,
    COUNT(DISTINCT i.issued_id) AS total_issues,
    COUNT(DISTINCT r.return_id) AS total_returns,
    ROUND(
        COUNT(DISTINCT r.return_id)
        / NULLIF(COUNT(DISTINCT i.issued_id), 0) * 100,
        2
    ) AS return_rate_percent
FROM books b
JOIN issued_status i
    ON b.isbn = i.issued_book_isbn
LEFT JOIN return_status r
    ON i.issued_id = r.issued_id
GROUP BY
    b.category
ORDER BY
    return_rate_percent DESC,
    total_issues DESC;  
    
    
 

SELECT
    b.category,
    COUNT(DISTINCT i.issued_id) AS total_issues,
    COUNT(DISTINCT r.return_id) AS total_returns,
    ROUND(
        COUNT(DISTINCT r.return_id)
        / NULLIF(COUNT(DISTINCT i.issued_id), 0) * 100,
        2
    ) AS return_rate_percent
FROM books b
JOIN issued_status i
    ON b.isbn = i.issued_book_isbn
LEFT JOIN return_status r
    ON i.issued_id = r.issued_id
GROUP BY
    b.category
ORDER BY
    return_rate_percent DESC,
    total_issues DESC; 
    
    
    
    
SELECT
    b.category,
    COUNT(r.return_id) AS returned_books,
    ROUND(
        AVG(DATEDIFF(r.return_date, i.issued_date)),
        2
    ) AS avg_borrowing_days
FROM books b
JOIN issued_status i
    ON b.isbn = i.issued_book_isbn
JOIN return_status r
    ON i.issued_id = r.issued_id
GROUP BY
    b.category
ORDER BY
    avg_borrowing_days DESC;   
    
    
    
    
SELECT
    b.category,
    COUNT(r.return_id) AS returned_books,
    ROUND(
        AVG(DATEDIFF(r.return_date, i.issued_date)),
        2
    ) AS avg_borrowing_days
FROM books b
JOIN issued_status i
    ON b.isbn = i.issued_book_isbn
JOIN return_status r
    ON i.issued_id = r.issued_id
GROUP BY
    b.category
HAVING COUNT(r.return_id) >= 2
ORDER BY avg_borrowing_days DESC;    



WITH category_issues AS (
    SELECT
        b.category,
        COUNT(i.issued_id) AS total_issues
    FROM books b
    JOIN issued_status i
        ON b.isbn = i.issued_book_isbn
    GROUP BY b.category
)
SELECT
    category,
    total_issues
FROM category_issues
WHERE total_issues = (
    SELECT MAX(total_issues)
    FROM category_issues
);




WITH book_issue_counts AS (
    SELECT
        b.category,
        b.book_title,
        b.isbn,
        COUNT(i.issued_id) AS total_issues
    FROM books b
    JOIN issued_status i
        ON b.isbn = i.issued_book_isbn
    GROUP BY
        b.category,
        b.book_title,
        b.isbn
),
ranked_books AS (
    SELECT
        category,
        book_title,
        isbn,
        total_issues,
        DENSE_RANK() OVER (
            PARTITION BY category
            ORDER BY total_issues DESC
        ) AS category_rank
    FROM book_issue_counts
)
SELECT
    category,
    book_title,
    isbn,
    total_issues
FROM ranked_books
WHERE category_rank = 1
ORDER BY category, book_title;




SELECT
    m.member_id,
    m.member_name,
    COUNT(DISTINCT b.category) AS distinct_categories_borrowed
FROM members m
JOIN issued_status i
    ON m.member_id = i.issued_member_id
JOIN books b
    ON i.issued_book_isbn = b.isbn
GROUP BY
    m.member_id,
    m.member_name
ORDER BY
    distinct_categories_borrowed DESC,
    m.member_name;
    
    
    
 
SELECT
    b.isbn,
    b.book_title,
    b.category,
    b.status
FROM books b
LEFT JOIN issued_status i
    ON b.isbn = i.issued_book_isbn
WHERE i.issued_id IS NULL
ORDER BY b.book_title; 




SELECT
    COUNT(*) AS total_books,
    SUM(status = 'no') AS currently_issued,
    SUM(status = 'yes') AS currently_available,
    ROUND(
        SUM(status = 'no') / COUNT(*) * 100,
        2
    ) AS current_utilization_percent
FROM books;




SELECT
    COUNT(*) AS total_books,
    SUM(
        NOT EXISTS (
            SELECT 1
            FROM issued_status i
            WHERE i.issued_book_isbn = b.isbn
        )
    ) AS never_borrowed_books,
    ROUND(
        SUM(
            NOT EXISTS (
                SELECT 1
                FROM issued_status i
                WHERE i.issued_book_isbn = b.isbn
            )
        ) / COUNT(*) * 100,
        2
    ) AS never_borrowed_percent
FROM books b;






SELECT
    b.category,
    COUNT(*) AS never_borrowed_books
FROM books b
LEFT JOIN issued_status i
    ON b.isbn = i.issued_book_isbn
WHERE i.issued_id IS NULL
GROUP BY b.category
ORDER BY never_borrowed_books DESC, b.category;




SELECT
    b.category,
    COUNT(*) AS total_books,
    SUM(
        NOT EXISTS (
            SELECT 1
            FROM issued_status i
            WHERE i.issued_book_isbn = b.isbn
        )
    ) AS never_borrowed_books,
    ROUND(
        SUM(
            NOT EXISTS (
                SELECT 1
                FROM issued_status i
                WHERE i.issued_book_isbn = b.isbn
            )
        ) / COUNT(*) * 100,
        2
    ) AS never_borrowed_percent
FROM books b
GROUP BY b.category
ORDER BY never_borrowed_percent DESC, b.category;





WITH book_issue_counts AS (
    SELECT
        b.isbn,
        b.book_title,
        b.status,
        COUNT(i.issued_id) AS total_issues
    FROM books b
    JOIN issued_status i
        ON b.isbn = i.issued_book_isbn
    GROUP BY
        b.isbn,
        b.book_title,
        b.status
)
SELECT
    isbn,
    book_title,
    total_issues,
    status
FROM book_issue_counts
WHERE total_issues > 1
ORDER BY total_issues DESC, book_title;




WITH repeat_demand_books AS (
    SELECT
        b.isbn,
        b.book_title,
        b.status,
        COUNT(i.issued_id) AS total_issues
    FROM books b
    JOIN issued_status i
        ON b.isbn = i.issued_book_isbn
    GROUP BY
        b.isbn,
        b.book_title,
        b.status
    HAVING COUNT(i.issued_id) > 1
)
SELECT
    COUNT(*) AS repeat_demand_books,
    SUM(status = 'no') AS currently_issued,
    SUM(status = 'yes') AS currently_available,
    ROUND(
        SUM(status = 'no') / COUNT(*) * 100,
        2
    ) AS current_issued_percent
FROM repeat_demand_books;





WITH issue_history AS (
    SELECT
        issued_book_isbn,
        issued_book_name,
        issued_id,
        issued_date,
        LAG(issued_date) OVER (
            PARTITION BY issued_book_isbn
            ORDER BY issued_date
        ) AS previous_issue_date
    FROM issued_status
)
SELECT
    issued_book_isbn,
    issued_book_name,
    issued_id,
    issued_date,
    previous_issue_date,
    DATEDIFF(issued_date, previous_issue_date) AS days_between_issues
FROM issue_history
WHERE previous_issue_date IS NOT NULL
ORDER BY days_between_issues;



WITH book_issue_counts AS (
    SELECT
        b.isbn,
        b.book_title,
        b.status,
        COUNT(i.issued_id) AS total_issues
    FROM books b
    JOIN issued_status i
        ON b.isbn = i.issued_book_isbn
    GROUP BY
        b.isbn,
        b.book_title,
        b.status
)
SELECT
    isbn,
    book_title,
    total_issues,
    status
FROM book_issue_counts
WHERE total_issues > 1
  AND status = 'no'
ORDER BY total_issues DESC, book_title;




WITH repeat_demand_books AS (
    SELECT
        b.isbn,
        b.book_title,
        b.category,
        b.status,
        COUNT(i.issued_id) AS total_issues
    FROM books b
    JOIN issued_status i
        ON b.isbn = i.issued_book_isbn
    GROUP BY
        b.isbn,
        b.book_title,
        b.category,
        b.status
    HAVING COUNT(i.issued_id) > 1
)
SELECT
    category,
    COUNT(*) AS repeat_demand_unavailable_books
FROM repeat_demand_books
WHERE status = 'no'
GROUP BY category
ORDER BY repeat_demand_unavailable_books DESC, category;




WITH repeat_demand_books AS (
    SELECT
        b.isbn,
        b.book_title,
        b.category,
        b.status,
        COUNT(i.issued_id) AS total_issues
    FROM books b
    JOIN issued_status i
        ON b.isbn = i.issued_book_isbn
    GROUP BY
        b.isbn,
        b.book_title,
        b.category,
        b.status
    HAVING COUNT(i.issued_id) > 1
),
category_totals AS (
    SELECT
        category,
        COUNT(*) AS total_books
    FROM books
    GROUP BY category
)
SELECT
    c.category,
    c.total_books,
    COUNT(r.isbn) AS repeat_demand_unavailable_books,
    ROUND(
        COUNT(r.isbn) / c.total_books * 100,
        2
    ) AS pressure_rate_percent
FROM category_totals c
LEFT JOIN repeat_demand_books r
    ON c.category = r.category
   AND r.status = 'no'
GROUP BY
    c.category,
    c.total_books
ORDER BY
    pressure_rate_percent DESC,
    c.category;
    
    
    
    
WITH book_issue_counts AS (
    SELECT
        b.isbn,
        b.book_title,
        COUNT(i.issued_id) AS total_issues
    FROM books b
    LEFT JOIN issued_status i
        ON b.isbn = i.issued_book_isbn
    GROUP BY
        b.isbn,
        b.book_title
)
SELECT
    COUNT(*) AS total_books,
    SUM(total_issues > 1) AS repeat_demand_books,
    ROUND(
        SUM(total_issues > 1) / COUNT(*) * 100,
        2
    ) AS repeat_demand_rate_percent
FROM book_issue_counts;    





SELECT
    b.isbn,
    b.book_title,
    b.category,
    COUNT(i.issued_id) AS total_issues
FROM books b
JOIN issued_status i
    ON b.isbn = i.issued_book_isbn
LEFT JOIN return_status r
    ON i.issued_id = r.issued_id
WHERE r.return_id IS NULL
GROUP BY
    b.isbn,
    b.book_title,
    b.category
ORDER BY
    total_issues DESC,
    b.book_title;
    
    
    
    
 SELECT
    b.isbn,
    b.book_title,
    b.category,
    COUNT(i.issued_id) AS total_issues
FROM books b
JOIN issued_status i
    ON b.isbn = i.issued_book_isbn
LEFT JOIN return_status r
    ON i.issued_id = r.issued_id
GROUP BY
    b.isbn,
    b.book_title,
    b.category
HAVING COUNT(r.return_id) = 0
ORDER BY
    total_issues DESC,
    b.book_title;   
    
    
    
    SELECT
    b.isbn,
    b.book_title,
    COUNT(i.issued_id) AS total_issues,
    COUNT(r.return_id) AS total_returns,
    ROUND(
        COUNT(r.return_id)
        / COUNT(i.issued_id) * 100,
        2
    ) AS return_rate_percent
FROM books b
JOIN issued_status i
    ON b.isbn = i.issued_book_isbn
LEFT JOIN return_status r
    ON i.issued_id = r.issued_id
GROUP BY
    b.isbn,
    b.book_title
ORDER BY
    return_rate_percent DESC,
    b.book_title;
    
    
    
   
SELECT
    b.isbn,
    b.book_title,
    COUNT(i.issued_id) AS total_issues,
    COUNT(r.return_id) AS total_returns,
    ROUND(
        COUNT(r.return_id)
        / COUNT(i.issued_id) * 100,
        2
    ) AS return_rate_percent
FROM books b
JOIN issued_status i
    ON b.isbn = i.issued_book_isbn
LEFT JOIN return_status r
    ON i.issued_id = r.issued_id
GROUP BY
    b.isbn,
    b.book_title
HAVING COUNT(i.issued_id) > 1
ORDER BY
    return_rate_percent DESC,
    b.book_title;   
    
    
    
    
    
    
SELECT
    b.isbn,
    b.book_title,
    b.category,
    b.status,
    COUNT(i.issued_id) AS total_issues
FROM books b
JOIN issued_status i
    ON b.isbn = i.issued_book_isbn
WHERE b.status = 'yes'
GROUP BY
    b.isbn,
    b.book_title,
    b.category,
    b.status
ORDER BY
    total_issues DESC,
    b.book_title;    
    
    
    
    
  
  
 WITH member_issues AS (
    SELECT
        m.member_id,
        m.member_name,
        COUNT(i.issued_id) AS total_issues
    FROM members m
    LEFT JOIN issued_status i
        ON m.member_id = i.issued_member_id
    GROUP BY
        m.member_id,
        m.member_name
)
SELECT
    member_id,
    member_name,
    total_issues,
    RANK() OVER (
        ORDER BY total_issues DESC
    ) AS activity_rank
FROM member_issues
ORDER BY activity_rank, member_name; 




WITH category_issues AS (
    SELECT
        b.category,
        COUNT(i.issued_id) AS total_issues
    FROM books b
    JOIN issued_status i
        ON b.isbn = i.issued_book_isbn
    GROUP BY b.category
)
SELECT
    category,
    total_issues,
    ROUND(
        total_issues / SUM(total_issues) OVER () * 100,
        2
    ) AS category_share_percent,
    ROUND(
        SUM(total_issues) OVER (
            ORDER BY total_issues DESC, category
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        )
        / SUM(total_issues) OVER () * 100,
        2
    ) AS cumulative_share_percent
FROM category_issues
ORDER BY total_issues DESC, category;





WITH category_issues AS (
    SELECT
        b.category,
        COUNT(i.issued_id) AS total_issues
    FROM books b
    JOIN issued_status i
        ON b.isbn = i.issued_book_isbn
    GROUP BY b.category
),
category_contribution AS (
    SELECT
        category,
        total_issues,
        ROUND(
            total_issues / SUM(total_issues) OVER () * 100,
            2
        ) AS category_share_percent,
        ROUND(
            SUM(total_issues) OVER (
                ORDER BY total_issues DESC, category
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ) / SUM(total_issues) OVER () * 100,
            2
        ) AS cumulative_share_percent
    FROM category_issues
)
SELECT
    category,
    total_issues,
    category_share_percent,
    cumulative_share_percent
FROM category_contribution
WHERE cumulative_share_percent <= 80
   OR (
       cumulative_share_percent > 80
       AND cumulative_share_percent - category_share_percent < 80
   )
ORDER BY total_issues DESC, category;





WITH member_issues AS (
    SELECT
        m.member_id,
        m.member_name,
        COUNT(i.issued_id) AS total_issues
    FROM members m
    JOIN issued_status i
        ON m.member_id = i.issued_member_id
    GROUP BY
        m.member_id,
        m.member_name
),
member_contribution AS (
    SELECT
        member_id,
        member_name,
        total_issues,
        ROUND(
            total_issues / SUM(total_issues) OVER () * 100,
            2
        ) AS issue_share_percent,
        ROUND(
            SUM(total_issues) OVER (
                ORDER BY total_issues DESC, member_name
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ) / SUM(total_issues) OVER () * 100,
            2
        ) AS cumulative_share_percent
    FROM member_issues
)
SELECT
    member_id,
    member_name,
    total_issues,
    issue_share_percent,
    cumulative_share_percent
FROM member_contribution
WHERE cumulative_share_percent <= 80
   OR (
       cumulative_share_percent > 80
       AND cumulative_share_percent - issue_share_percent < 80
   )
ORDER BY total_issues DESC, member_name;



SELECT
    (SELECT COUNT(*) FROM books) AS total_books,

    (SELECT COUNT(*) 
     FROM books 
     WHERE status = 'yes') AS available_books,

    (SELECT COUNT(*) 
     FROM books 
     WHERE status = 'no') AS currently_issued_books,

    (SELECT COUNT(*) 
     FROM issued_status) AS total_issue_transactions,

    (SELECT COUNT(*) 
     FROM return_status) AS total_return_transactions,

    ROUND(
        (SELECT COUNT(*) FROM books WHERE status = 'no')
        / (SELECT COUNT(*) FROM books) * 100,
        2
    ) AS current_utilization_percent,

    ROUND(
        (SELECT COUNT(*) FROM return_status)
        / (SELECT COUNT(*) FROM issued_status) * 100,
        2
    ) AS overall_return_rate_percent,

    (SELECT COUNT(*)
     FROM books b
     WHERE NOT EXISTS (
         SELECT 1
         FROM issued_status i
         WHERE i.issued_book_isbn = b.isbn
     )) AS never_borrowed_books;
     
     
     
     
SELECT
    book_title,
    COUNT(*) AS number_of_isbns,
    GROUP_CONCAT(isbn ORDER BY isbn SEPARATOR ', ') AS isbns
FROM books
GROUP BY book_title
HAVING COUNT(*) > 1
ORDER BY number_of_isbns DESC, book_title;     





SELECT
    book_title,
    COUNT(*) AS total_isbn_records,
    SUM(status = 'yes') AS available_records,
    SUM(status = 'no') AS issued_records
FROM books
GROUP BY book_title
HAVING COUNT(*) > 1
ORDER BY book_title;




SELECT
    issued_date,
    COUNT(*) AS total_issues
FROM issued_status
GROUP BY issued_date
ORDER BY total_issues DESC, issued_date;



SELECT
    YEAR(return_date) AS return_year,
    MONTH(return_date) AS return_month,
    COUNT(*) AS total_returns
FROM return_status
GROUP BY
    YEAR(return_date),
    MONTH(return_date)
ORDER BY
    return_year,
    return_month;
    
    
    
    
    
SELECT
    YEAR(return_date) AS return_year,
    MONTH(return_date) AS return_month,
    COUNT(*) AS total_returns,
    ROUND(
        COUNT(*) / (SELECT COUNT(*) FROM return_status) * 100,
        2
    ) AS return_share_percent
FROM return_status
GROUP BY
    YEAR(return_date),
    MONTH(return_date)
ORDER BY
    return_year,
    return_month;    
    
    
    
    
    
WITH monthly_issues AS (
    SELECT
        YEAR(issued_date) AS year_num,
        MONTH(issued_date) AS month_num,
        COUNT(*) AS total_issues
    FROM issued_status
    GROUP BY
        YEAR(issued_date),
        MONTH(issued_date)
),
monthly_returns AS (
    SELECT
        YEAR(return_date) AS year_num,
        MONTH(return_date) AS month_num,
        COUNT(*) AS total_returns
    FROM return_status
    GROUP BY
        YEAR(return_date),
        MONTH(return_date)
)
SELECT
    COALESCE(i.year_num, r.year_num) AS year_num,
    COALESCE(i.month_num, r.month_num) AS month_num,
    COALESCE(i.total_issues, 0) AS total_issues,
    COALESCE(r.total_returns, 0) AS total_returns
FROM monthly_issues i
LEFT JOIN monthly_returns r
    ON i.year_num = r.year_num
   AND i.month_num = r.month_num

UNION

SELECT
    COALESCE(i.year_num, r.year_num) AS year_num,
    COALESCE(i.month_num, r.month_num) AS month_num,
    COALESCE(i.total_issues, 0) AS total_issues,
    COALESCE(r.total_returns, 0) AS total_returns
FROM monthly_issues i
RIGHT JOIN monthly_returns r
    ON i.year_num = r.year_num
   AND i.month_num = r.month_num
ORDER BY
    year_num,
    month_num;   
    
    
    
    
    
  
  
 
 SELECT
    YEAR(i.issued_date) AS issue_year,
    MONTH(i.issued_date) AS issue_month,
    COUNT(r.return_id) AS returned_books,
    ROUND(
        AVG(DATEDIFF(r.return_date, i.issued_date)),
        2
    ) AS avg_borrowing_days
FROM issued_status i
JOIN return_status r
    ON i.issued_id = r.issued_id
GROUP BY
    YEAR(i.issued_date),
    MONTH(i.issued_date)
ORDER BY
    issue_year,
    issue_month;
    
    
    
    
WITH monthly_issues AS (
    SELECT
        YEAR(issued_date) AS issue_year,
        MONTH(issued_date) AS issue_month,
        COUNT(*) AS monthly_issues
    FROM issued_status
    GROUP BY
        YEAR(issued_date),
        MONTH(issued_date)
)
SELECT
    issue_year,
    issue_month,
    monthly_issues,
    SUM(monthly_issues) OVER (
        ORDER BY issue_year, issue_month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_issues
FROM monthly_issues
ORDER BY
    issue_year,
    issue_month;    
    
    
    
    
    
WITH monthly_returns AS (
    SELECT
        YEAR(return_date) AS return_year,
        MONTH(return_date) AS return_month,
        COUNT(*) AS monthly_returns
    FROM return_status
    GROUP BY
        YEAR(return_date),
        MONTH(return_date)
)
SELECT
    return_year,
    return_month,
    monthly_returns,
    SUM(monthly_returns) OVER (
        ORDER BY return_year, return_month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_returns
FROM monthly_returns
ORDER BY
    return_year,
    return_month;
    
    
 
WITH monthly_issues AS (
    SELECT
        YEAR(issued_date) AS issue_year,
        MONTH(issued_date) AS issue_month,
        COUNT(*) AS monthly_issues
    FROM issued_status
    GROUP BY
        YEAR(issued_date),
        MONTH(issued_date)
),
monthly_returns AS (
    SELECT
        YEAR(return_date) AS return_year,
        MONTH(return_date) AS return_month,
        COUNT(*) AS monthly_returns
    FROM return_status
    GROUP BY
        YEAR(return_date),
        MONTH(return_date)
),
all_periods AS (
    SELECT issue_year AS year_num, issue_month AS month_num
    FROM monthly_issues

    UNION

    SELECT return_year AS year_num, return_month AS month_num
    FROM monthly_returns
),
monthly_activity AS (
    SELECT
        p.year_num,
        p.month_num,
        COALESCE(i.monthly_issues, 0) AS monthly_issues,
        COALESCE(r.monthly_returns, 0) AS monthly_returns
    FROM all_periods p
    LEFT JOIN monthly_issues i
        ON p.year_num = i.issue_year
       AND p.month_num = i.issue_month
    LEFT JOIN monthly_returns r
        ON p.year_num = r.return_year
       AND p.month_num = r.return_month
)
SELECT
    year_num,
    month_num,
    monthly_issues,
    monthly_returns,
    SUM(monthly_issues) OVER (
        ORDER BY year_num, month_num
    ) AS cumulative_issues,
    SUM(monthly_returns) OVER (
        ORDER BY year_num, month_num
    ) AS cumulative_returns,
    ROUND(
        SUM(monthly_returns) OVER (
            ORDER BY year_num, month_num
        )
        /
        NULLIF(
            SUM(monthly_issues) OVER (
                ORDER BY year_num, month_num
            ),
            0
        ) * 100,
        2
    ) AS cumulative_return_rate_percent
FROM monthly_activity
ORDER BY year_num, month_num; 




WITH latest_issue AS (
    SELECT
        i.*,
        ROW_NUMBER() OVER (
            PARTITION BY i.issued_book_isbn
            ORDER BY i.issued_date DESC, i.issued_id DESC
        ) AS rn
    FROM issued_status i
)
SELECT
    l.issued_id,
    m.member_name,
    b.book_title,
    l.issued_date,
    DATEDIFF(CURDATE(), l.issued_date) AS days_held
FROM latest_issue l
JOIN members m
    ON l.issued_member_id = m.member_id
JOIN books b
    ON l.issued_book_isbn = b.isbn
WHERE l.rn = 1
  AND NOT EXISTS (
      SELECT 1
      FROM return_status r
      WHERE r.issued_id = l.issued_id
  )
  AND DATEDIFF(CURDATE(), l.issued_date) > 60
ORDER BY days_held DESC;





WITH latest_issue AS (
    SELECT
        i.*,
        ROW_NUMBER() OVER (
            PARTITION BY i.issued_book_isbn
            ORDER BY i.issued_date DESC, i.issued_id DESC
        ) AS rn
    FROM issued_status i
)
SELECT
    COUNT(*) AS currently_issued_books,
    SUM(
        DATEDIFF(CURDATE(), l.issued_date) > 60
    ) AS books_held_over_60_days,
    ROUND(
        SUM(
            DATEDIFF(CURDATE(), l.issued_date) > 60
        ) / COUNT(*) * 100,
        2
    ) AS over_60_days_percent
FROM latest_issue l
WHERE l.rn = 1
  AND NOT EXISTS (
      SELECT 1
      FROM return_status r
      WHERE r.issued_id = l.issued_id
  );
  
  
WITH latest_issue AS (
    SELECT
        i.*,
        ROW_NUMBER() OVER (
            PARTITION BY i.issued_book_isbn
            ORDER BY i.issued_date DESC, i.issued_id DESC
        ) AS rn
    FROM issued_status i
),
current_loans AS (
    SELECT
        l.issued_member_id,
        l.issued_date
    FROM latest_issue l
    WHERE l.rn = 1
      AND NOT EXISTS (
          SELECT 1
          FROM return_status r
          WHERE r.issued_id = l.issued_id
      )
)
SELECT
    m.member_id,
    m.member_name,
    COUNT(*) AS long_held_books,
    ROUND(
        AVG(DATEDIFF(CURDATE(), cl.issued_date)),
        2
    ) AS avg_days_held,
    MAX(DATEDIFF(CURDATE(), cl.issued_date)) AS max_days_held
FROM current_loans cl
JOIN members m
    ON cl.issued_member_id = m.member_id
WHERE DATEDIFF(CURDATE(), cl.issued_date) > 60
GROUP BY
    m.member_id,
    m.member_name
ORDER BY
    long_held_books DESC,
    avg_days_held DESC;  
    
    
    
    

WITH latest_issue AS (
    SELECT
        i.*,
        ROW_NUMBER() OVER (
            PARTITION BY i.issued_book_isbn
            ORDER BY i.issued_date DESC, i.issued_id DESC
        ) AS rn
    FROM issued_status i
),
current_loans AS (
    SELECT
        l.issued_id,
        l.issued_emp_id
    FROM latest_issue l
    WHERE l.rn = 1
      AND NOT EXISTS (
          SELECT 1
          FROM return_status r
          WHERE r.issued_id = l.issued_id
      )
)
SELECT
    e.emp_id,
    e.emp_name,
    COUNT(cl.issued_id) AS current_active_loans
FROM employees e
JOIN current_loans cl
    ON e.emp_id = cl.issued_emp_id
GROUP BY
    e.emp_id,
    e.emp_name
ORDER BY
    current_active_loans DESC,
    e.emp_name;
    
    
    
  
 
WITH latest_issue AS (
    SELECT
        i.*,
        ROW_NUMBER() OVER (
            PARTITION BY i.issued_book_isbn
            ORDER BY i.issued_date DESC, i.issued_id DESC
        ) AS rn
    FROM issued_status i
),
current_loans AS (
    SELECT
        l.issued_id,
        l.issued_emp_id
    FROM latest_issue l
    WHERE l.rn = 1
      AND NOT EXISTS (
          SELECT 1
          FROM return_status r
          WHERE r.issued_id = l.issued_id
      )
),
employee_loans AS (
    SELECT
        e.emp_id,
        e.emp_name,
        COUNT(cl.issued_id) AS current_active_loans
    FROM employees e
    JOIN current_loans cl
        ON e.emp_id = cl.issued_emp_id
    GROUP BY
        e.emp_id,
        e.emp_name
)
SELECT
    emp_id,
    emp_name,
    current_active_loans,
    ROUND(
        current_active_loans
        / (SELECT SUM(current_active_loans) FROM employee_loans)
        * 100,
        2
    ) AS current_loan_share_percent
FROM employee_loans
ORDER BY
    current_loan_share_percent DESC,
    emp_name;
    
    
    
    
    
    
SELECT
    b.branch_id,
    COUNT(DISTINCT e.emp_id) AS employee_count,
    COUNT(DISTINCT CASE
        WHEN i.issued_id IS NOT NULL
             AND NOT EXISTS (
                 SELECT 1
                 FROM return_status r
                 WHERE r.issued_id = i.issued_id
             )
        THEN i.issued_id
    END) AS current_active_loans,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN i.issued_id IS NOT NULL
                 AND NOT EXISTS (
                     SELECT 1
                     FROM return_status r
                     WHERE r.issued_id = i.issued_id
                 )
            THEN i.issued_id
        END)
        / NULLIF(COUNT(DISTINCT e.emp_id), 0),
        2
    ) AS loans_per_employee
FROM branch b
LEFT JOIN employees e
    ON b.branch_id = e.branch_id
LEFT JOIN issued_status i
    ON e.emp_id = i.issued_emp_id
GROUP BY
    b.branch_id
ORDER BY
    loans_per_employee DESC;    
    
    
    
    
 
WITH latest_issue AS (
    SELECT
        i.*,
        ROW_NUMBER() OVER (
            PARTITION BY i.issued_book_isbn
            ORDER BY i.issued_date DESC, i.issued_id DESC
        ) AS rn
    FROM issued_status i
),
current_loans AS (
    SELECT
        l.issued_id,
        l.issued_emp_id
    FROM latest_issue l
    WHERE l.rn = 1
      AND NOT EXISTS (
          SELECT 1
          FROM return_status r
          WHERE r.issued_id = l.issued_id
      )
)
SELECT
    b.branch_id,
    COUNT(DISTINCT e.emp_id) AS employee_count,
    COUNT(cl.issued_id) AS current_active_loans,
    ROUND(
        COUNT(cl.issued_id) / NULLIF(COUNT(DISTINCT e.emp_id), 0),
        2
    ) AS loans_per_employee
FROM branch b
LEFT JOIN employees e
    ON b.branch_id = e.branch_id
LEFT JOIN current_loans cl
    ON e.emp_id = cl.issued_emp_id
GROUP BY
    b.branch_id
ORDER BY
    loans_per_employee DESC,
    b.branch_id;
    
    

WITH latest_issue AS (
    SELECT
        i.*,
        ROW_NUMBER() OVER (
            PARTITION BY i.issued_book_isbn
            ORDER BY i.issued_date DESC, i.issued_id DESC
        ) AS rn
    FROM issued_status i
),
derived_status AS (
    SELECT
        b.isbn,
        b.book_title,
        b.status AS stored_status,
        CASE
            WHEN l.issued_id IS NULL THEN 'yes'
            WHEN EXISTS (
                SELECT 1
                FROM return_status r
                WHERE r.issued_id = l.issued_id
            ) THEN 'yes'
            ELSE 'no'
        END AS derived_status
    FROM books b
    LEFT JOIN latest_issue l
        ON b.isbn = l.issued_book_isbn
       AND l.rn = 1
)
SELECT
    isbn,
    book_title,
    stored_status,
    derived_status
FROM derived_status
WHERE stored_status <> derived_status
ORDER BY book_title;    




SELECT
    issued_id,
    COUNT(*) AS occurrence_count
FROM issued_status
GROUP BY issued_id
HAVING COUNT(*) > 1;




SELECT
    return_id,
    COUNT(*) AS occurrence_count
FROM return_status
GROUP BY return_id
HAVING COUNT(*) > 1;




SELECT
    isbn,
    COUNT(*) AS occurrence_count
FROM books
GROUP BY isbn
HAVING COUNT(*) > 1;



SELECT
    member_id,
    COUNT(*) AS occurrence_count
FROM members
GROUP BY member_id
HAVING COUNT(*) > 1;



SELECT
    member_id,
    COUNT(*) AS occurrence_count
FROM members
GROUP BY member_id
HAVING COUNT(*) > 1;



SELECT
    member_id,
    COUNT(*) AS occurrence_count
FROM members
GROUP BY member_id
HAVING COUNT(*) > 1;



SELECT
    emp_id,
    COUNT(*) AS occurrence_count
FROM employees
GROUP BY emp_id
HAVING COUNT(*) > 1;



SELECT
    branch_id,
    COUNT(*) AS occurrence_count
FROM branch
GROUP BY branch_id
HAVING COUNT(*) > 1;



SELECT
    i.issued_id,
    i.issued_book_isbn,
    i.issued_emp_id,
    i.issued_member_id
FROM issued_status i
LEFT JOIN books b
    ON i.issued_book_isbn = b.isbn
LEFT JOIN employees e
    ON i.issued_emp_id = e.emp_id
LEFT JOIN members m
    ON i.issued_member_id = m.member_id
WHERE b.isbn IS NULL
   OR e.emp_id IS NULL
   OR m.member_id IS NULL;
   
   
   
   
SELECT
    r.return_id,
    r.issued_id
FROM return_status r
LEFT JOIN issued_status i
    ON r.issued_id = i.issued_id
WHERE i.issued_id IS NULL;   


SELECT
    issued_id,
    issued_date
FROM issued_status
WHERE issued_date IS NULL;



SELECT
    return_id,
    issued_id,
    return_date
FROM return_status
WHERE return_date IS NULL;



SELECT
    r.return_id,
    r.issued_id,
    i.issued_date,
    r.return_date
FROM return_status r
JOIN issued_status i
    ON r.issued_id = i.issued_id
WHERE r.return_date < i.issued_date;





SELECT
    (SELECT COUNT(*) FROM books) AS total_books,
    (SELECT COUNT(*) FROM books WHERE status = 'yes') AS available_books,
    (SELECT COUNT(*) FROM books WHERE status = 'no') AS issued_books,
    (SELECT COUNT(*) FROM issued_status) AS total_issues,
    (SELECT COUNT(*) FROM return_status) AS total_returns,
    (SELECT COUNT(*) FROM members) AS total_members,
    (SELECT COUNT(*) FROM employees) AS total_employees,
    (SELECT COUNT(*) FROM branch) AS total_branches,
    (SELECT COUNT(*)
     FROM books b
     WHERE NOT EXISTS (
         SELECT 1
         FROM issued_status i
         WHERE i.issued_book_isbn = b.isbn
     )) AS never_borrowed_books;
create database db3;
use db3;
CREATE DATABASE IF NOT EXISTS employeedb1;
USE employeedb1;

CREATE TABLE IF NOT EXISTS employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    dept_id INT,
    salary DECIMAL(10,2)
);

INSERT INTO employees VALUES
(101,'Rahul',1,50000),
(102,'Priya',2,65000),
(103,'Anil',1,55000),
(104,'Sneha',3,70000),
(105,'Kiran',2,48000);
SELECT * FROM employees;
DELIMITER $$

CREATE PROCEDURE GetEmployees()
BEGIN
    SELECT * FROM employees;
END $$
DELIMITER ;

CALL GetEmployees();
DELIMITER $$

CREATE PROCEDURE GetEmployeeById(IN eid INT)
BEGIN
    SELECT * FROM employees
    WHERE emp_id = eid;
END $$

DELIMITER ;
CALL GetEmployeeById(102);


DELIMITER $$

CREATE PROCEDURE IncreaseSalary(
    IN eid INT,
    IN amount DECIMAL(10,2)
)
BEGIN
    UPDATE employees
    SET salary = salary + amount
    WHERE emp_id = eid;
END $$

DELIMITER ;

CALL IncreaseSalary(101,5000);
SELECT * FROM employees WHERE emp_id=101;



DELIMITER $$

CREATE PROCEDURE AvgSalary()
BEGIN
    SELECT AVG(salary) AS AverageSalary
    FROM employees;
END $$
DELIMITER ;

CALL AvgSalary();


CREATE TABLE IF NOT EXISTS departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

INSERT IGNORE INTO departments VALUES
(1,'CSE'),(2,'ECE'),(3,'EEE');

DELIMITER $$

CREATE PROCEDURE EmployeeDepartment()
BEGIN
    SELECT e.emp_name, d.dept_name, e.salary
    FROM employees e
    JOIN departments d ON e.dept_id=d.dept_id;
END $$

DELIMITER ;

CALL EmployeeDepartment();

DELIMITER $$

CREATE PROCEDURE DepartmentAverageSalary()
BEGIN
    SELECT d.dept_name,
           COUNT(e.emp_id) AS EmployeeCount,
           AVG(e.salary) AS AverageSalary
    FROM employees e
    JOIN departments d ON e.dept_id=d.dept_id
    GROUP BY d.dept_id, d.dept_name;
END $$

DELIMITER ;

CALL DepartmentAverageSalary();


DELIMITER $$

CREATE PROCEDURE SalaryStatus(IN eid INT)
BEGIN
    DECLARE sal DECIMAL(10,2);

    SELECT salary INTO sal
    FROM employees
    WHERE emp_id=eid;

    IF sal >= 60000 THEN
        SELECT 'High Salary' AS Status;
    ELSE
        SELECT 'Low Salary' AS Status;
    END IF;
END $$

DELIMITER ;

CALL SalaryStatus(102);

DELIMITER $$

CREATE PROCEDURE EmployeeCount(OUT total INT)
BEGIN
    SELECT COUNT(*) INTO total
    FROM employees;
END $$

DELIMITER ;

CALL EmployeeCount(@total);
SELECT @total AS TotalEmployees;


DROP PROCEDURE IF EXISTS AddBonus;
DELIMITER $$

CREATE PROCEDURE AddBonus(INOUT bonus DECIMAL(10,2))
BEGIN
    SET bonus = bonus + 5000;
END $$

DELIMITER ;

SET @bonus=10000;
CALL AddBonus(@bonus);
SELECT @bonus AS UpdatedBonus;


DROP PROCEDURE IF EXISTS TransferSalaryAmount;
DELIMITER $$

CREATE PROCEDURE TransferSalaryAmount(
    IN fromEmp INT,
    IN toEmp INT,
    IN amount DECIMAL(10,2)
)
BEGIN
    START TRANSACTION;

    UPDATE employees
    SET salary=salary-amount
    WHERE emp_id=fromEmp;

    UPDATE employees
    SET salary=salary+amount
    WHERE emp_id=toEmp;

    COMMIT;
END $$

DELIMITER ;

CALL TransferSalaryAmount(101,102,2000);
SELECT * FROM employees WHERE emp_id IN (101,102);

SHOW PROCEDURE STATUS
WHERE Db='employeedb1';

SHOW CREATE PROCEDURE GetEmployees;

DROP PROCEDURE IF EXISTS GetEmployees;

DELIMITER $$
CREATE PROCEDURE Example()
BEGIN
    SELECT * FROM employees;
END $$
DELIMITER ;




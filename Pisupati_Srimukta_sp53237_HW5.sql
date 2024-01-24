

--problem 1 

SELECT sysdate AS "SYSDATE", TO_CHAR(sysdate, 'FMDAY, MONTH, YEAR') AS Day_Month_Year, TO_CHAR(sysdate, 'MM/DD/YYYY - HH24:MI') AS Date_With_Hours, TO_CHAR((TO_DATE('31-12-' || TO_CHAR(sysdate, 'YYYY'), 'DD-MM-YYYY') - sysdate), '999') AS days_til_end_of_year,
LOWER(TO_CHAR(sysdate, 'Mon Dy YYYY')) AS lowercase, TO_CHAR(40 * 8 * 5 * 52, '$999,999') AS Initial_Salary
FROM DUAL;

--problem 2 

SELECT e.employee_id AS "Employee_ID", e.first_name || ' ' || e.last_name ||  NVL2(l.origination_date, ' has processed a loan.', ' has not processed a loan.') AS "Employee Information",
'Loan started: ' || TO_CHAR(l.origination_date, 'Mon-DD-YYYY') AS "Loan Origination Date"
FROM employee e LEFT JOIN loans l ON e.employee_id = l.employee_id
ORDER BY e.employee_id, "Loan Origination Date";


--problem 3 

SELECT UPPER(last_name) || ', ' || UPPER(SUBSTR(first_name, 1, 1)) AS Employee_Name, branch.branch_state AS Branch_State,
TO_CHAR(birthdate, 'DD-Mon-YYYY') AS "Date of Birth", phone_number AS Phone_Number
FROM employee JOIN branch ON employee.branch_id = branch.branch_id
WHERE birthdate >= TO_DATE('2000-01-01', 'YYYY-MM-DD')AND (branch.branch_state = 'NY' OR branch.branch_state = 'MD')
ORDER BY birthdate desc;

--problem 4 

SELECT UPPER(first_name || ' ' || last_name) AS "Name", emp_level AS "Emp_level",
CASE
  WHEN emp_level = 1 THEN '$' || TO_CHAR('38,000') || ' to ' || TO_CHAR('50,000')
  WHEN emp_level = 2 THEN '$' || TO_CHAR('50,001') || ' to ' || TO_CHAR('80,000')
  WHEN emp_level = 3 THEN '$' || TO_CHAR('80,0001') || ' to ' || TO_CHAR('105,000')
  END AS "Salary"
FROM Employee
ORDER BY emp_level DESC, "Name" ASC;
  
--problem 5 

SELECT NVL2(middle_name, first_name || ' ' || SUBSTR(middle_name, 1, 1) || '. ' || last_name, first_name || ' ' || last_name) AS Full_Name,
email_address AS Email_address,LENGTH(email_address) AS email_length,loan_number,
TRUNC(SYSDATE - origination_date) AS days_since_loan_originated
FROM members JOIN loans ON members.member_id = loans.member_id
WHERE TRUNC(SYSDATE - origination_date) > 500
ORDER BY days_since_loan_originated;

--problem 6 

SELECT employee_id, first_name, last_name,
SUBSTR(phone_number, 1, 3) AS phone_area_code,
SUBSTR(email, 1, INSTR(email, '@') - 1) AS email_id
FROM employee
ORDER BY phone_area_code;

--problem 7 

SELECT m.first_name || ' ' || m.last_name AS Member_Name, SUBSTR(mt.tax_id, 1, 3) || '-***-*****' AS redacted_tax_id
FROM members m JOIN member_tax_id mt ON m.member_id = mt.member_id
WHERE m.member_id IN 
(SELECT DISTINCT l.member_id
FROM loans l
WHERE l.origination_date >= TO_DATE('2023-01-01', 'YYYY-MM-DD'))
ORDER BY Member_Name;


--problem 8 

SELECT
CASE
   WHEN interest_rate > 5.5 THEN 'High Interest Rate'
   WHEN interest_rate BETWEEN 3.5 AND 5.5 THEN 'Medium Interest Rate'
   WHEN interest_rate < 3.5 THEN 'Low Interest Rate'
   END AS interest_type, interest_rate, loan_type, loan_number
FROM loans
ORDER BY interest_rate DESC;

--problem 9 

SELECT first_name, last_name, emp_level, SUM(original_amount) AS total_original_amount,
DENSE_RANK() OVER (ORDER BY SUM(original_amount) DESC) AS total_amount_rank
FROM employee
JOIN loans ON employee.employee_id = loans.employee_id
GROUP BY first_name, last_name, emp_level
ORDER BY total_original_amount DESC;

--problem 10 

--part a

SELECT first_name, last_name, emp_level, total_original_amount, total_amount_rank
FROM (SELECT e.first_name, e.last_name, e.emp_level, SUM(l.original_amount) AS total_original_amount,
DENSE_RANK() OVER (ORDER BY SUM(l.original_amount) DESC) AS total_amount_rank
FROM employee e JOIN loans l ON e.employee_id = l.employee_id
GROUP BY e.first_name, e.last_name, e.emp_level
ORDER BY total_original_amount DESC) subquery
WHERE ROWNUM <= 6;

--part b

SELECT first_name, last_name, emp_level, total_original_amount, total_amount_rank
FROM (SELECT e.first_name, e.last_name, e.emp_level, SUM(l.original_amount) AS total_original_amount,
DENSE_RANK() OVER (ORDER BY SUM(l.original_amount) DESC) AS total_amount_rank
FROM employee e JOIN loans l ON e.employee_id = l.employee_id
GROUP BY e.first_name, e.last_name, e.emp_level
ORDER BY total_original_amount DESC) subquery
WHERE total_amount_rank <= 4;












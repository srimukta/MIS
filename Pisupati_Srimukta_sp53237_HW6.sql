--problem 1

SET SERVEROUTPUT ON;

DECLARE
  count_loans NUMBER;
BEGIN
  SELECT COUNT(*) INTO count_loans
  FROM loans
  WHERE member_id = 1018;
  
  IF count_loans > 1 THEN
    DBMS_OUTPUT.PUT_LINE('The member has taken out more than 1 loan.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('The member has taken only 1 loan.');
  END IF;
END;
/

DELETE FROM loans
WHERE loan_number = 'SNB000100112' AND member_id = 1018;

ROLLBACK;

--problem 2

SET SERVEROUTPUT ON;

ACCEPT member_id NUMBER PROMPT 'Enter Member ID: '

DECLARE
  v_member_id NUMBER := &member_id;
  v_count_loans NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count_loans
  FROM loans
  WHERE member_id = v_member_id;
  
  IF v_count_loans > 1 THEN
    DBMS_OUTPUT.PUT_LINE('The member with ID:' || v_member_id || ', has taken out more than 1 loans.');
  ELSIF v_count_loans = 1 THEN
    DBMS_OUTPUT.PUT_LINE('The member with ID:' || v_member_id || ', has taken out only 1 loan.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('No loans found for the member with ID:' || v_member_id);
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Invalid member ID entered. Please enter a valid member ID.');
END;
/

--problem 3

SET SERVEROUTPUT ON;

DECLARE
  v_branch_id CHAR(4); 
BEGIN
  SELECT 'B' || branch_id_sq.NEXTVAL INTO v_branch_id FROM DUAL;

  INSERT INTO branch (branch_id, branch_name, street, city, branch_state, zip_code)
  VALUES (v_branch_id, 'New Branch', '2463 Oak Dr', 'Austin', 'TX', '75686');

  IF SQL%ROWCOUNT = 1 THEN
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('1 row was inserted into the branch table.');
  ELSE
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Row was not inserted. Unexpected exception occurred.');
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Row was not inserted. Unexpected exception occurred.');
END;
/

--problem 4

SET SERVEROUTPUT ON;

DECLARE
  TYPE loan_status_table IS TABLE OF loans.loan_status%TYPE INDEX BY PLS_INTEGER;
  v_loan_statuses loan_status_table;
BEGIN
  SELECT DISTINCT loan_status
  BULK COLLECT INTO v_loan_statuses
  FROM loans
  ORDER BY loan_status;

  FOR i IN 1..v_loan_statuses.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE('Loan status ' || i || ': ' || v_loan_statuses(i));
  END LOOP;
END;
/

--problem 5

SET SERVEROUTPUT ON;

DECLARE
  CURSOR loan_cursor IS
    SELECT l.loan_number, l.loan_status, COUNT(*) AS payment_count
    FROM loans l JOIN transaction_history t ON l.loan_number = t.loan_number
    GROUP BY l.loan_number, l.loan_status
    ORDER BY l.loan_status, l.loan_number;
    
BEGIN
  FOR i IN loan_cursor LOOP
    DBMS_OUTPUT.PUT_LINE('Loan Number: '||i.loan_number || ' of status ' || i.loan_status || 'has ' || i.payment_count || ' payments.');
  END LOOP;

END;
/

--problem 6

CREATE OR REPLACE PROCEDURE insert_branch (
  p_branch_name IN VARCHAR2,
  p_street IN VARCHAR2,
  p_city IN VARCHAR2,
  p_branch_state IN CHAR,
  p_zip_code IN CHAR
)
AS
  v_branch_id CHAR(4);
BEGIN
  SELECT 'B' || branch_id_sq.NEXTVAL INTO v_branch_id FROM DUAL;

  INSERT INTO branch (branch_id, branch_name, street, city, branch_state, zip_code)
  VALUES (v_branch_id, p_branch_name, p_street, p_city, p_branch_state, p_zip_code);

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('1 row was inserted into the branch table.');
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Row was not inserted. Unexpected exception occurred.');
END;
/

--test
CALL insert_branch ('Austin 22', '22 Austin St', 'Austin', 'TX', '72222');
BEGIN
insert_branch ('Houston 33', '33 Houston St', 'Houston', 'TX', '73333');
END;
/

--problem 7

CREATE OR REPLACE FUNCTION loan_count (p_member_id IN NUMBER)
RETURN NUMBER
IS
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM loans
  WHERE member_id = p_member_id;
  
  RETURN v_count;
END;
/

SET SERVEROUTPUT ON;
DECLARE
  v_member_id NUMBER := 1018; 
  v_total_loans NUMBER;
BEGIN
  v_total_loans := loan_count(v_member_id);
  DBMS_OUTPUT.PUT_LINE('Total number of loans for member ' || v_member_id || ': ' || v_total_loans);
END;
/

--test
select member_id, last_name, loan_count(member_id)
from members
group by member_id, last_name
order by member_id;

select member_id, last_name, loan_count(member_id)
from members
where loan_count(member_id) > 1
group by member_id, last_name
order by member_id;








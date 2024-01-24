--problem 1
select *
from employee;

select employee_id, first_name, last_name, phone_number
from employee
order by last_name;

--problem 2

select first_name||' '||substr(middle_name, 1, 1)||'. '||last_name
from members
where middle_name is not null
and last_name like 'A%' OR last_name like 'B%' OR last_name like 'C%'
order by first_name, substr(last_name, 1, 1);

--other:
select first_name||' '||substr(middle_name, 1, 1)||'. '||last_name as member_full_name
from members
where middle_name is not null
and substr(last_name, 1, 1) in ('A', 'B', 'C')
order by first_name asc, substr(last_name, 1, 1) asc;

--problem 3

select loan_type, member_id, original_amount, origination_date
from loans
where original_amount > 30000 and original_amount <= 40000
order by loan_type, original_amount desc;

--problem 4

--part a
select loan_type, member_id, original_amount, origination_date
from loans
where original_amount between 30001 and  40000
order by loan_type, original_amount desc;

--part b
(select loan_type, member_id, original_amount, origination_date
from loans
where original_amount > 30000 and original_amount <= 40000)
minus
(select loan_type, member_id, original_amount, origination_date
from loans
where original_amount between 30001 and  40000);

--problem 5

select loan_type, origination_date, original_amount, number_of_payments,payment_amount,
(number_of_payments * payment_amount) as total_payment,
((number_of_payments * payment_amount) - original_amount) as total_interest
from loans
where rownum <= 4
order by total_payment desc;

--problem 6

select loan_number, transaction_date, amount, updated_balance,
(round(updated_balance / amount, 2)) as average_number_payment_to_date
from transaction_history
where round(updated_balance / amount, 2)  > 250
order by average_number_payment_to_date;

--problem 7

select loan_number, member_id, origination_date, loan_notes
from loans
where loan_notes is null
order by 1;

--problem 8

select 
to_char(sysdate, 'mm/dd/yyyy') as today_unformatted,
to_char(sysdate, 'mm/dd/yyyy') as today_formatted,
250000 as loan,
0.075 as mortgage_rate,
(250000 * 0.075) as annual_interest_amount,
(250000 * 0.075 * 15) as total_interest_15_years
from dual;

--problem 9

select loan_number, loan_type, original_amount, origination_date
from loans
where loan_type <> 'MO' and rownum <=5
order by original_amount desc;

--problem 10

select b.branch_id, branch_state, branch_name, first_name, last_name, emp_level
from employee e join branch b on e.branch_id = b.branch_id
order by branch_state, branch_name, emp_level desc;

--problem 11

select m.member_id, address_line_1, address_line_2, city, member_state, zip_code, email_address,
first_name||' '||last_name as "Member Name"
from members m, member_address a 
where m.email_address = 'aheapez@naver.com';

--problem 12

select m.member_id, first_name, last_name, phone_number, phone_type
from members m join member_phone p on m.member_id = p.member_id
where m.member_id in (1001, 1002) and p.phone_type = 'P';

--problem 13

select m.first_name as "Member First Name", m.last_name as "Member Last Name", branch_id, e.first_name as "Employee First Name", e.last_name as "Employee Last Name", 
l.loan_number, l.original_amount, l.origination_date, th.updated_balance
from members m join loans l on m.member_id = l.member_id
join employee e on l.employee_id = e.employee_id
join transaction_history th on l.loan_number = th.loan_number
order by e.branch_id, l.loan_number, th.updated_balance desc;

--problem 14

select m.member_id, p.phone_id
from members m left join member_phone p on m.member_id = p.member_id
where p.phone_id is null;


--problem 15

select interest_rate, loan_type, loan_number, 
'High Interest Rate' as interest_type
from loans
where interest_rate > 5.5

union

select interest_rate, loan_type, loan_number, 
'Medium Interest Rate' as interest_type
from loans
where interest_rate >= 3.5 and interest_rate <= 5.5

union

select interest_rate, loan_type, loan_number, 
'Low Interest Rate' as interest_type
from loans
where interest_rate < 3.5
order by interest_rate desc;






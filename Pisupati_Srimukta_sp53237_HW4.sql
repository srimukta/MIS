--problem 1

select count(loan_number) as number_of_loans, 
min(original_amount) as lowest_loan_amount, 
max(original_amount)  as highest_loan_amount
from loans;

--problem 2

select e.first_name as first_name, e.last_name as last_name,
count(l.loan_number) as loan_count,
round(avg(l.original_amount), 2) as average_loan_amount
from employee e left join loans l on e.employee_id = l.employee_id
group by e.employee_id, e.first_name, e.last_name
order by loan_count desc;

--problem 3

select e.first_name, e.last_name, count(l.loan_number) as loan_count,
round(avg(l.original_amount), 2) as avg_loan_amount,
(max(l.interest_rate) - min(l.interest_rate)) as range_int,
round(avg(l.interest_rate), 2) as avg_int
from employee e left join loans l on e.employee_id = l.employee_id
group by e.first_name, e.last_name
order by loan_count desc, range_int desc;

--problem 4

select m.first_name as First_Name, m.last_name as Last_Name,  mp.phone_number as phone_number,
sum(l.original_amount) as total_loan_amount,
count(l.loan_number) as total_number_of_loan
from members m join member_phone mp on m.member_id = mp.member_id
left join loans l on m.member_id = l.member_id
where mp.phone_type = 'P'
group by m.member_id, m.first_name, m.last_name, mp.phone_number
order by total_loan_amount desc;

--problem 5

select m.first_name as "First_Name", m.last_name as "Last_Name", m.email_address as "Email",
count(th.transaction_id) as "Transaction_count"
from members m inner join loans l on m.member_id = l.member_id
left join transaction_history th on l.loan_number = th.loan_number
group by m.member_id, m.first_name, m.last_name, m.email_address having count(th.transaction_id) > 22
order by "Transaction_count" desc, "First_Name";

--problem 6

select m.first_name as first_name, m.last_name as last_name, m.email_address,
count(case when th.amount >= 700.00 then 1 else null end) as transaction_count,
avg(case when th.amount >= 700.00 then th.amount else null end) as average_transaction_amount
from members m left join loans l on m.member_id = l.member_id
left join transaction_history th on l.loan_number = th.loan_number
group by m.member_id, m.first_name, m.last_name, m.email_address
order by transaction_count desc;

--problem 7

select b.branch_state, b.branch_name,
count(l.loan_number) as total_loans_processed
from branch b left join employee e on b.branch_id = e.branch_id
left join loans l on e.employee_id = l.employee_id
group by rollup (b.branch_state, b.branch_name)
having grouping(b.branch_state) = 0 or (grouping(b.branch_state) = 1 and grouping(b.branch_name) = 0)
order by total_loans_processed desc;

--the state with the highest number of loans processed is NY with 43 loans processed

--problem 8

select b.branch_state, b.branch_name, sum(l.original_amount) as total_loan_amount
from employee e join branch b on e.branch_id = b.branch_id
join loans l on e.employee_id = l.employee_id
group by b.branch_state, b.branch_name
having sum(l.original_amount) > 2000000
order by total_loan_amount desc;

--problem 9

select loan_number, original_amount
from loans
where original_amount > (select avg(original_amount) from loans)
order by original_amount;

--problem 10

select distinct m.member_id, last_name, first_name
from members m
where m.member_id in (select member_id from loans)
order by m.member_id;

--problem 11

select e.employee_id, e.first_name, e.last_name, e.email
from employee e full outer join loans l on e.employee_id = l.employee_id
where l.employee_id is null;

--problem 12

select m.email, l.loan_number, sum(th.amount) as max_total_payment
from members m join loans l on m.member_id = l.member_id
join transaction_history th on l.loan_number = th.loan_number
group by m.email, l.loan_number;

--just for grins!!
select email, max(total_payment_amount) as "max_payment_total"
from (select m.email_address as email, l.loan_number, sum(th.amount) as total_payment_amount
from members m join loans l on m.member_id = l.member_id
left join transaction_history th on l.loan_number = th.loan_number
group by m.email_address, l.loan_number)
group by email
order by email;

--problem 13

select mal.member_id, mal.address_status, ma.address_line_1, ma.address_line_2, ma.city, ma.member_state, ma.zip_code
from member_address_link mal join member_address ma on mal.address_id = ma.address_id
where mal.member_id in 
(select member_id
from member_address_link
group by member_id
having count(*) >= 3)
order by mal.member_id, mal.address_status;

--problem 14

with oldesttransaction as 
(select t.loan_number, min(t.transaction_date) as transaction_start_date
from transaction_history t
group by t.loan_number)

select ot.transaction_start_date, l.loan_number, l.origination_date, l.original_amount
from oldesttransaction ot
join loans l on ot.loan_number = l.loan_number
where l.loan_status = 'P'
order by ot.transaction_start_date, l.loan_number;

















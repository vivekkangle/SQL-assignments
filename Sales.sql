
create table salespeople(
snum number,
sname varchar2(15),
city varchar2(10),
comm number(2,2),
constraint sales_pk primary key(snum)
);

insert into salespeople values(1001,'Peel','London',.12);
INSERT INTO salespeople (snum, sname, city, comm) VALUES (1002, 'Serres', 'San Jose', 0.13);
INSERT INTO salespeople (snum, sname, city, comm) VALUES (1003, 'Axelrod', 'New York', 0.10);
INSERT INTO salespeople (snum, sname, city, comm) VALUES (1004, 'Monika', 'London', 0.11);
INSERT INTO salespeople (snum, sname, city, comm) VALUES (1005, 'Franc', 'London', 0.26);
INSERT INTO salespeople (snum, sname, city, comm) VALUES (1007, 'Rifkin', 'Barcelona', 0.15);


-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------

create table customers(
cnum number,
cname varchar2(10),
city varchar2(10),
rating number,
snum number,
constraint customer_pk primary key(cnum),
constraint customer_fk foreign key(snum) references salespeople(snum));

insert into customers values(2001,'Hoffman','London',100,1001);
INSERT INTO customers (cnum, cname, city, rating, snum) VALUES (2002, 'Giovanni', 'Rome', 200, 1003);
INSERT INTO customers (cnum, cname, city, rating, snum) VALUES (2003, 'Liu', 'San Jose', 200, 1002);
INSERT INTO customers (cnum, cname, city, rating, snum) VALUES (2004, 'Grass', 'Berlin', 300, 1002);
INSERT INTO customers (cnum, cname, city, rating, snum) VALUES (2006, 'Clemens', 'London', 100, 1001);
INSERT INTO customers (cnum, cname, city, rating, snum) VALUES (2008, 'Cisneros', 'San Jose', 300, 1007);
INSERT INTO customers (cnum, cname, city, rating, snum) VALUES (2007, 'Pereira', 'Rome', 100, 1004);

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------


create table orders(
onum number,
amt number(6,2),
odate date,
cnum number,
snum number,
constraint orders_pk primary key(onum),
constraint orders_cnum foreign key(cnum) references customers(cnum),
constraint orders_snum foreign key (snum) references salespeople(snum)
);

insert into orders values(3001,18.69,to_date('03-oct-96 12:30', 'dd-mon-yy hh24:mi'),2008,1007)
INSERT INTO orders (onum, amt, odate, cnum, snum) VALUES (3003, 767.19, TO_DATE('03-Oct-1996 13:45', 'DD-Mon-YYYY HH24:MI'), 2001, 1001);
INSERT INTO orders (onum, amt, odate, cnum, snum) VALUES (3002, 1900.10, TO_DATE('03-Oct-1996 12:05', 'DD-Mon-YYYY HH24:MI'), 2007, 1004);
INSERT INTO orders (onum, amt, odate, cnum, snum) VALUES (3005, 5160.45, TO_DATE('03-Oct-1996 14:00', 'DD-Mon-YYYY HH24:MI'), 2003, 1002);
INSERT INTO orders (onum, amt, odate, cnum, snum) VALUES (3006, 1098.16, TO_DATE('03-Oct-1996 13:37', 'DD-Mon-YYYY HH24:MI'), 2008, 1007);
INSERT INTO orders (onum, amt, odate, cnum, snum) VALUES (3009, 1713.23, TO_DATE('04-Oct-1996 15:21', 'DD-Mon-YYYY HH24:MI'), 2002, 1003);
INSERT INTO orders (onum, amt, odate, cnum, snum) VALUES (3007, 75.75, TO_DATE('04-Oct-1996 16:02', 'DD-Mon-YYYY HH24:MI'), 2002, 1003);
INSERT INTO orders (onum, amt, odate, cnum, snum) VALUES (3008, 4723.00, TO_DATE('05-Oct-1996 12:07', 'DD-Mon-YYYY HH24:MI'), 2006, 1001);
INSERT INTO orders (onum, amt, odate, cnum, snum) VALUES (3010, 1309.95, TO_DATE('06-Oct-1996 13:12', 'DD-Mon-YYYY HH24:MI'), 2004, 1002);
INSERT INTO orders (onum, amt, odate, cnum, snum) VALUES (3011, 9891.88, TO_DATE('06-Oct-1996 13:09', 'DD-Mon-YYYY HH24:MI'), 2006, 1001);
INSERT INTO orders (onum, amt, odate, cnum, snum) VALUES (3012, 3455.78, TO_DATE('04-Oct-1996 15:21', 'DD-Mon-YYYY HH24:MI'), 2002, 1003);
INSERT INTO orders (onum, amt, odate, cnum, snum) VALUES (3013, 1245.98, TO_DATE('04-Oct-1996 16:32', 'DD-Mon-YYYY HH24:MI'), 2002, 1003);
INSERT INTO orders (onum, amt, odate, cnum, snum) VALUES (3014, 3721.53, TO_DATE('05-Oct-1996 12:45', 'DD-Mon-YYYY HH24:MI'), 2006, 1001);
INSERT INTO orders (onum, amt, odate, cnum, snum) VALUES (3015, 734.50, TO_DATE('06-Oct-1996 13:16', 'DD-Mon-YYYY HH24:MI'), 2004, 1002);
INSERT INTO orders (onum, amt, odate, cnum, snum) VALUES (3016, 1729.67, TO_DATE('06-Oct-1996 13:07', 'DD-Mon-YYYY HH24:MI'), 2006, 1001);

-----------------------------------------------------------------------------------------------------

select * from salespeople;
select * from customers;
select * from orders;

-----------------------------------

--- Q1 List all customers with a rating of 100

select * from customers
where rating =100;
--- Q2 Find all records in the Customer table with NULL values in the city column

select * from customers
where city is null;

select * from customers;
--- Q3 Find the largest order taken by each salesperson on each date


select snum,trunc(odate) ,max(amt),count(*)
from orders
group by snum,trunc(odate);

select snum,to_char(odate,'dd-mm-yy') ,max(amt),count(*)
from orders
group by snum,to_char(odate,'dd-mm-yy');

--- Q4 Arrange the Orders table by descending customer number

select * from orders
order by cnum desc;

--- Q5 Find which salespeople currently have orders in the Orders table

select distinct s.*
from salespeople s,orders o
where s.snum=o.snum;

select s.* from salespeople s
where exists(
select 1
from orders o
where o.snum=s.snum);
--- Q6 List names of all customers matched with the salespeople serving them



select *
from orders o inner join salespeople s
on o.snum=s.snum
inner join customers c
on c.cnum=o.cnum
where upper(cname)=upper(sname);


--- Q7 Find the names and numbers of all salespeople who had more than one customer

select * from salespeople where snum in(
select snum from orders
group by snum
having count(cnum)>1);
--- Q8 Count the orders of each of the salespeople and output the results in descending order

select snum,count(*) as number_of_orders
from orders
group by snum
order by number_of_orders desc;


--- Q9 List the Customer table if and only if one or more of the customers in the Customer tables are located in San Jose




select * from customers
where exists(
select * from customers
where upper(city)='SAN JOSE');

select * from customers
where 'SAN JOSE' = any (
select upper(city) from customers
where upper(city)='SAN JOSE');

select * from customers
where 'SAN JOSE' in  (
select upper(city) from customers
where upper(city)='SAN JOSE');



select amt from orders
where amt > any (select amt from orders);

--- Q10 Match salespeople to customers according to what city they lived in

select * from customers c,salespeople s
where s.city=c.city;


select * from customers c
inner join salespeople s    
on c.city=s.city;
select * from customers;
select * from salespeople;
--- Q11 Find the largest order taken by each salesperson

select * from orders
where amt in (
select max(amt) from orders
group by snum);

select * from orders
where amt in(
select distinct max(amt) over(partition by snum)as amt from orders);




--- Q12 Find customers in San Jose who have a rating above 200

select * from customers
where rating >100 and upper(city)='SAN JOSE';

--- Q13 List the names and commissions of all salespeople in London

select sname,comm from salespeople
where city='London';

--- Q14 List all the orders of salesperson Monika from the Orders table
select * from orders 
where snum=
(select snum from salespeople 
where upper(sname)='MONIKA');

select *
from salespeople s inner join orders o
on o.snum=s.snum
where upper(sname)='MONIKA';

select snum_1 from orders;
--- Q15 Find all customers with orders on October 3

select c.*,O.*
    
    from orders o left join customers c
    on o.cnum=c.cnum
  --  where extract(month from odate)=10 and extract(day from odate)=3;
    where UPPER(TRIM(to_char(odate,'MONTH')))='OCTOBER' and (to_char(odate,'DD'))='03';
    
    
    SELECT * FROM ORDERS;
    select c.*
    
    from orders o left join customers c
    on o.cnum=c.cnum
  --  where extract(month from odate)=10 and extract(day from odate)=3;
    where extract(month from odate)=10 and TRIM(to_char(odate,'DD'))='03';
    
--- Q16 Give the sums of the amounts from the orders table, grouped by date

SELECT ODATE,SUM(AMT) FROM ORDERS
GROUP BY ODATE;

--- Q17 Eliminate all those dates where the SUM was not at least 2000.00 above the MAX amount

SELECT ODATE,SUM(AMT),MAX(AMT) FROM ORDERS
GROUP BY ODATE
HAVING SUM(AMT)<(MAX(AMT)+2000);

--- Q18 Select all orders that had amounts greater than at least one of the orders from October 6

SELECT * FROM ORDERS
WHERE AMT > ANY 
    (SELECT AMT 
        FROM ORDERS 
        WHERE EXTRACT(DAY FROM ODATE)=06 AND TRIM(UPPER(TO_CHAR(ODATE,'MONTH')))='OCTOBER');


--- Q19 Use the EXISTS operator to extract all salespeople who have customers with a rating of 300

SELECT * FROM CUSTOMERS;
WHERE EXISTS (SELECT * FROM );


SELECT *
FROM ORDERS O  INNER JOIN SALESPEOPLE S 
ON  O.SNUM=S.SNUM
INNER JOIN CUSTOMERS C
ON O.CNUM=C.CNUM
WHERE RATING=300;



SELECT DISTINCT S.*
FROM SALESPEOPLE S
WHERE EXISTS (
    SELECT 1
    FROM CUSTOMERS C
    WHERE C.SNUM = S.SNUM
      AND C.RATING = 300
);

SELECT * FROM SALESPEOPLE S
WHERE EXISTS (SELECT 1 FROM CUSTOMERS C
WHERE S.SNUM=C.SNUM AND RATING=300);
SELECT * FROM CUSTOMERS;

SELECT * FROM SALESPEOPLE S
WHERE EXISTS(
SELECT 1 FROM CUSTOMERS C
WHERE C.SNUM=S.SNUM AND RATING=300);

--- Q20 Find all pairs of customers having the same rating

SELECT A.CNUM,A.RATING,B.CNUM,B.RATING FROM CUSTOMERS A,CUSTOMERS B
WHERE A.RATING=B.RATING AND A.CNUM != B.CNUM ;

SELECT * FROM CUSTOMERS C
WHERE EXISTS(
SELECT 1 FROM CUSTOMERS A
WHERE C.RATING=A.RATING); AND C.CNUM<>A.CNUM);


SELECT * FROM CUSTOMERS A
WHERE A.RATING IN (SELECT RATING FROM CUSTOMERS B
WHERE A.RATING=B.RATING);


---Select 20 % of salary from John, 10% of Salary for Roy and for other 15 % of salary from employee table

100 --20
100--10
--15
--15
--



SELECT FIRST_NAME,SALARY,CASE 
WHEN UPPER(FIRST_NAME)='JOHN' then 0.20*salary 
when UPPER(FIRST_NAME)='ROY' then 0.1*salary
ELSE  0.15*SALARY
END SALARY_CALCULATION
FROM EMPLOYEE_I;
;

SELECT FIRST_NAME ,CASE FIRST_NAME
WHEN 'JOHN' then (update employee_i set salary=1 where first_name='JOHN')
when 'RoY' then 0.1*salary
ELSE  0.15*SALARY
END SALARY_CALCULATION
FROM EMPLOYEE_I;

SELECT * FROM EMPLOYEE_I;

UPDATE EMPLOYEE_I
SET SALARY = CASE
               WHEN FIRST_NAME = 'JOHN' THEN 1
               WHEN FIRST_NAME = 'RoY'  THEN 0.1 * SALARY
               ELSE 0.15 * SALARY
             END;
             
             rollback;
             
             
select * from customers;
select * from orders;


select * from customers
where cnum in (
select cnum from orders
where to_date(odate,'dd-mm-yy')=to_date('06-10-96','dd-mm-yy'));

commit;

select c.*,o.*
from customers c inner join orders o
on  c.cnum=o.cnum
where to_date(odate,'dd-mm-yy')=to_date('06-10-96','dd-mm-yy');



--- Q21 Find all customers with CNUM 1000 above the SNUM of Serres


select * from customers
where cnum= any (select snum+1000 from salespeople
where upper(sname)='SERRES');

select * from customers
where cnum=  (select snum+1000 from salespeople
where upper(sname)='SERRES');

SELECT C.*
FROM CUSTOMERS C, SALESPEOPLE S 
WHERE C.CNUM=C.SNUM+1000 AND (UPPER(SNAME)='SERRES'); 

SELECT C.*
FROM CUSTOMERS C
WHERE EXISTS (
SELECT 1 FROM SALESPEOPLE 
WHERE C.CNUM=C.SNUM+1000 AND (UPPER(SNAME)='SERRES'));


--- Q22 Give the salespeople’s commissions as percentage instead of decimal numbers

SELECT S.*,(COMM*100)||'%' AS PERCENTAGE FROM SALESPEOPLE S;

--- Q23 Find the largest order taken by each salesperson on each date, eliminating those MAX orders less than $3000.00
WITH A AS (SELECT SNUM,MAXIMUM_AMOUNT,ODATE  FROM (SELECT SNUM,ODATE, MAX(AMT) OVER(PARTITION BY SNUM,TO_DATE(ODATE,'DD-MM-YYYY')) AS MAXIMUM_AMOUNT FROM ORDERS)
WHERE MAXIMUM_AMOUNT>3000);
---


SELECT O.*, S.*
FROM ORDERS O
INNER JOIN SALESPEOPLE S
    ON O.SNUM = S.SNUM
INNER JOIN (
    SELECT O.SNUM,
           TO_CHAR(O.ODATE,'DD-MM-YYYY') AS ORDER_DATE,
           MAX(O.AMT) AS MAX_AMT
    FROM ORDERS O
    GROUP BY O.SNUM, TO_CHAR(O.ODATE,'DD-MM-YYYY')
    HAVING MAX(O.AMT) > 3000
) X
    ON O.SNUM = X.SNUM
   AND TO_CHAR(O.ODATE,'DD-MM-YYYY') = X.ORDER_DATE;

--- Q24 List the largest orders on October 3 for each salesperson
SELECT * FROM SALESPEOPLE S
INNER JOIN ORDERS O
ON O.SNUM=S.SNUM
INNER JOIN (
SELECT SNUM,ODATE,MAX(AMT) AS AMT
FROM ORDERS
GROUP BY SNUM,ODATE
HAVING (trim(to_char(odate,'dd-MONTH')))='03-OCTOBER') X 
ON X.SNUM=O.SNUM AND X.ODATE=O.ODATE AND X.AMT=O.AMT ;


--- Q25 Find all customers located in cities where Serres (SNUM 1002) has customers


SELECT * FROM CUSTOMERS
WHERE CITY IN (
SELECT CITY
FROM CUSTOMERS
WHERE SNUM=1002);

SELECT * FROM CUSTOMERS A
JOIN CUSTOMERS B
ON UPPER(A.CITY)= UPPER(B.CITY) AND B.SNUM=1002 ;

--HERE I HAVE FOUND SERRES LOCATION CUSTOMERS--
SELECT CNAME,CITY FROM CUSTOMERS 
WHERE CITY IN (
SELECT CITY FROM SALESPEOPLE
WHERE UPPER(SNAME)='SERRES');

SELECT ONUM,SNAME,S.CITY,C.CNUM,CNAME,C.CITY
FROM ORDERS O
INNER JOIN CUSTOMERS C
ON O.CNUM=C.CNUM
INNER JOIN SALESPEOPLE S
ON S.SNUM=O.SNUM
WHERE UPPER(C.CITY)=UPPER((SELECT CITY FROM SALESPEOPLE WHERE UPPER(SNAME)='SERRES'));

SELECT * FROM CUSTOMERS;
--- Q26 Select all customers with a rating above 200.00

SELECT * FROM CUSTOMERS
WHERE RATING > 200;
--- Q27 Count the number of salespeople currently listing orders in the Orders table



SELECT COUNT(DISTINCT SNUM) AS Num_Salespeople
FROM ORDERS;
--- Q28 Produce all customers serviced by salespeople with a commission above 12%. Output the customer’s name and the salesperson‘s commission


SELECT * FROM CUSTOMERS;
SELECT * FROM SALESPEOPLE;

SELECT *
FROM CUSTOMERS C INNER JOIN SALESPEOPLE S
ON C.SNUM=S.SNUM AND S.COMM>0.12;

--- Q29 Find salespeople who have multiple customers



SELECT SNUM,COUNT(*)
FROM CUSTOMERS
GROUP BY SNUM
HAVING COUNT(*)>1;

SELECT *
FROM CUSTOMERS A
JOIN CUSTOMERS B
ON A.SNUM=B.SNUM AND A.CNUM > B.CNUM; --THIS A.CNUM>B.CNUM ALLOW US TO MATCH ONLY SINGLE TIME AND PROHIBATES  ROW TO MATCH WITH HIMSELF 


--- Q30 Find salespeople with customers located in their city

SELECT * FROM SALESPEOPLE S INNER JOIN CUSTOMERS C
ON S.CITY=C.CITY;

SELECT *
FROM CUSTOMERS C,SALESPEOPLE S
WHERE C.CITY=S.CITY;
--- Q31 Find all salespeople whose name starts with ‘P’ and the fourth character is ‘I’

SELECT * FROM SALESPEOPLE
--WHERE SUBSTR(UPPER(SNAME),1,1)='P' and SUBSTR(UPPER(SNAME),4,1)='I';
WHERE UPPER(SNAME) LIKE 'P__I%';  --LIKE OPERATOR IS FOR PATTERN MATCHING WE NEED TO FOCUS ON THIS MAKING MISTAKE BY APPLYING '=' INSTEAD OF 'LIKE'


--- Q32 Use a subquery to obtain all orders for the customer named ‘Cisneros’ (without knowing his CNUM)

SELECT * FROM ORDERS
WHERE CNUM =(SELECT CNUM FROM CUSTOMERS WHERE UPPER(CNAME)='CISNEROS');


SELECT * FROM SALESPEOPLE;

--- Q33 Find the largest orders for ‘Serres’ and ‘Rifkin’


SELECT SNUM,MAX(AMT)
FROM ORDERS 
GROUP BY SNUM
HAVING SNUM IN (
SELECT SNUM  FROM SALESPEOPLE
WHERE UPPER(SNAME) IN ('SERRES','RIFKIN'));




SELECT S.SNUM,MAX(AMT)
FROM ORDERS O INNER JOIN SALESPEOPLE S
ON O.SNUM=S.SNUM AND UPPER(SNAME) IN ('SERRES','RIFKIN')
GROUP BY S.SNUM;
--- Q34 Extract the Salespeople table in the order: SNUM, SNAME, COMMISSION, CITY

SELECT SNUM, SNAME, COMM, CITY FROM SALESPEOPLE 
ORDER BY SNUM, SNAME, COMM, CITY;

--- Q35 Select all customers whose names fall between ‘A’ and ‘G’ alphabetically


SELECT * FROM CUSTOMERS
WHERE UPPER(CNAME)  BETWEEN 'A' AND 'G'; --HERE WE DIDNT USE LIKE OPERATOR NOTE THAT

--- Q36 Select all possible combinations of customers

SELECT * FROM CUSTOMERS A,CUSTOMERS B;

--- Q37 Select all orders greater than the average for October 4

SELECT * FROM ORDERS
WHERE AMT> 
(SELECT AVG(AMT) FROM ORDERS
WHERE TRIM(TO_CHAR(ODATE,'DD-MON'))='04-OCT');



--- Q38 Use a correlated subquery to select names and numbers of all customers with ratings equal to the maximum for their city

SELECT * FROM CUSTOMERS A
WHERE A.RATING IN (
SELECT MAX(RATING)
FROM CUSTOMERS B
WHERE A.CITY=B.CITY);

--- Q39 Total the orders for each day and place the results in descending order


SELECT TO_DATE(ODATE,'DD-MM-YYYY') AS ORDERDATE ,SUM(AMT) TOTAL
FROM ORDERS
GROUP BY TO_DATE(ODATE,'DD-MM-YYYY')
ORDER BY TOTAL DESC;

--- Q40 Produce the rating followed by the name of each customer in San Jose

SELECT RATING,CNAME FROM CUSTOMERS
WHERE UPPER(CITY)='SAN JOSE';

--- Q41 Find all orders with amounts smaller than any amount for a customer in San Jose


SELECT * FROM ORDERS WHERE AMT < ALL (
SELECT AMT FROM ORDERS 
WHERE CNUM IN (SELECT CNUM FROM CUSTOMERS WHERE UPPER(CITY)='SAN JOSE'));



--- Q42 Find all orders with above average amounts for their customers


SELECT * FROM (
SELECT  CNUM,AMT,AVG(AMT) OVER(PARTITION BY CNUM) AVG_AMT FROM ORDERS)
WHERE AMT>AVG_AMT;

SELECT * FROM ORDERS A
WHERE EXISTS(
SELECT 1
FROM ORDERS O
GROUP BY O.CNUM
HAVING O.CNUM=A.CNUM AND A.AMT> AVG(O.AMT));



--- Q43 Select the highest rating in each city

SELECT CITY, MAX(RATING)
 FROM CUSTOMERS 
 GROUP BY CITY;
 
 SELECT * FROM CUSTOMERS A
 WHERE EXISTS (
 SELECT 1 FROM CUSTOMERS B
 GROUP BY B.CITY,CNUM
 HAVING MAX(B.RATING)=A.RATING AND  A.CNUM=B.CNUM);
 

 
 
--- Q44 Calculate the amount of the salesperson’s commission on orders by customers with a rating above 100.00

SELECT A.CNUM,A.SNUM,COMM*AMT AS COMMISSION
FROM ORDERS A INNER JOIN SALESPEOPLE B
ON A.SNUM=B.SNUM
INNER JOIN CUSTOMERS C
ON A.CNUM=C.CNUM
WHERE RATING>100
ORDER BY RATING;


--- Q45 Count customers with rating above San Jose’s average


SELECT COUNT(*) FROM CUSTOMERS
WHERE RATING >(
SELECT AVG(RATING) FROM CUSTOMERS 
WHERE UPPER(CITY)='SAN JOSE');

SELECT COUNT(*) FROM CUSTOMERS A
WHERE EXISTS(SELECT 1 FROM CUSTOMERS B
GROUP BY B.CITY
HAVING UPPER(B.CITY)='SAN JOSE' AND AVG(RATING)<A.RATING);


SELECT *
FROM CUSTOMERS A
INNER JOIN 
(SELECT AVG(RATING) AS RATING FROM CUSTOMERS 
WHERE UPPER(CITY)='SAN JOSE')  B
ON A.RATING>B.RATING;

--- Q46 Produce all pairs of salespeople with themselves as well as duplicate rows with the order reversed

SELECT * FROM SALESPEOPLE A CROSS JOIN SALESPEOPLE B
ORDER BY B.SNUM DESC;

--- Q47 Find all salespeople located in either Barcelona or London

SELECT * FROM SALESPEOPLE 
WHERE INITCAP(CITY) IN ('Barcelona' ,'London');

--- Q48 Find all salespeople with only one customer
SELECT SNUM
FROM CUSTOMERS
GROUP BY SNUM
HAVING COUNT(*)=1;

SELECT * FROM (
SELECT A.*,COUNT(*) OVER(PARTITION BY SNUM) AS COUNT FROM CUSTOMERS A)
WHERE COUNT=1;;

--- Q49 Join the Customer table to itself to find all pairs of customers served by a single salesperson


SELECT   * FROM CUSTOMERS A, CUSTOMERS B
WHERE A.SNUM=B.SNUM 
ORDER BY A.SNUM;

SELECT * FROM CUSTOMERS A, CUSTOMERS B
WHERE A.SNUM=B.SNUM AND A.CNUM<B.CNUM;


--- Q50 List all orders greater than $1000.00

SELECT * FROM ORDERS  
WHERE AMT>1000;
--- Q51 List each order number followed by the name of the customer who made that order

SELECT ONUM,B.CNAME
FROM ORDERS A,CUSTOMERS B
WHERE B.CNUM=A.CNUM;

SELECT  ONUM,B.CNAME
FROM ORDERS A LEFT JOIN CUSTOMERS B
ON A.CNUM=B.CNUM;


SELECT  *
FROM ORDERS A LEFT JOIN CUSTOMERS B
ON A.CNUM=B.CNUM;
SELECT * FROM ORDERS;
--- Q52 Select all salespeople (by name and number) who have customers in their cities whom they do not service (one using a join, one using a correlated subquery)


SELECT B.SNUM,B.SNAME,A.*
FROM CUSTOMERS A CROSS JOIN SALESPEOPLE B
WHERE A.SNUM<>B.SNUM AND A.CITY=B.CITY;

SELECT SNAME,SNUM FROM SALESPEOPLE A
WHERE EXISTS(
SELECT 1 FROM CUSTOMERS B
WHERE A.CITY=B.CITY AND A.SNUM<B.SNUM);



--- Q53 Select all customers whose ratings are equal to ANY of Serres

SELECT * FROM CUSTOMERS 
WHERE RATING IN (
SELECT RATING FROM CUSTOMERS 
WHERE SNUM=(
SELECT SNUM FROM SALESPEOPLE 
WHERE UPPER(SNAME)='SERRES'));



SELECT A.*,B.*
FROM CUSTOMERS A JOIN CUSTOMERS B
ON A.RATING=B.RATING
INNER JOIN SALESPEOPLE C
ON C.SNUM=B.SNUM
WHERE UPPER(SNAME)='SERRES' AND A.CNUM<>B.CNUM;

SELECT * FROM SALESPEOPLE;






--- Q54 Produce all orders taken on October 3 or October 4

SELECT * FROM ORDERS
WHERE (EXTRACT(DAY FROM ODATE) BETWEEN 3 AND 4) AND EXTRACT(MONTH FROM ODATE)=10;

SELECT * FROM ORDERS
WHERE (TRIM(TO_CHAR(ODATE,'DD-MONTH'))) IN ( '03-OCTOBER' , '04-OCTOBER'); 

--- Q55 Produce all pairs of orders by a given customer. Name that customer and eliminate duplicates

SELECT A.*,B.* FROM ORDERS A JOIN ORDERS C
ON A.CNUM=C.CNUM LEFT JOIN CUSTOMERS B
ON A.CNUM=B.CNUM 
WHERE UPPER(CNAME)='LIU' AND A.ONUM<C.ONUM;




--- Q56 Find customers whose ratings are higher than every customer in Rome


SELECT * FROM CUSTOMERS
WHERE RATING > ALL(
SELECT RATING FROM CUSTOMERS
WHERE UPPER(CITY)='ROME');




--- Q57 Exclude all customers with a rating <= 100.00 unless they are located in Rome


select * from customers
where rating >100 or upper(city)='Rome';

--- Q58 Find all rows from the Customer table for which the salesperson number is 1001

select * from customers
where snum=1001;

--- Q59 Find the total amount in Orders for each salesperson where the total is greater than the largest order in the table


select snum from (
select snum,
max(amt) over() as max_amount,sum(amt) over(partition by snum) as salespeople_total from orders)
where max_amount<salespeople_total;


select snum
from orders

group by snum
having  sum(amt)>(
select max(amt) from orders);


--- Q60 Select all orders with zeroes or NULL in the Amount field 

select * from orders
where amt=0 or amt is null;



--- Q61 Produce all combinations of salespeople and customer names such that the former precedes the latter alphabetically, and the latter has a rating < 200

select cname,sname from customers a cross join salespeople b
where a.cname>b.sname and rating <200;

--- Q62 List all salespeople’s names and the commission they have earned

select sname,comm from salespeople;


--- Q63 Produce the names and cities of all customers with the same rating as Hoffman (using Hoffman’s CNUM)

select A.*
from customers a join customers b
on a.rating=b.rating
where (upper(B.cname))='HOFFMAN';


SELECT * FROM CUSTOMERS A
WHERE RATING=(SELECT RATING FROM CUSTOMERS WHERE CNUM=2001);


--- Q64 Find all salespeople for whom there are customers that follow them alphabetically

select * from salespeople a,customers b
where a.sname<b.cname;


--- Q65 Produce the names and ratings of all customers who have above average orders


select * from customers
where cnum in (
select cnum from orders
where amt>(
select avg(amt) from orders));

select * from customers
where cnum in (
select distinct cnum from (
select avg(amt) over() as total_avg_amt,cnum,amt from orders)
where total_avg_amt<amt);



select distinct b.*
from orders a inner join customers b
on a.cnum=b.cnum
where amt>(select avg(amt) from orders);



--- Q66 Find the sum of all purchases from the Orders table

select sum(amt) from orders;

--- Q67 Produce the order number, amount, and date for all rows in the Orders table

select onum,amt,odate from orders;

--- Q68 Count the number of not null rating fields in the Customer table including duplicates

select count(rating) from customers;

select count(distinct rating) from customers;  --- to avoid duplicates

--- Q69 Give the names of both the salesperson and the customer for each order after the order number


select distinct b.cname,c.sname 
from orders a inner join customers b 
on b.cnum=a.cnum
inner join salespeople c
on a.snum=c.snum;

--- Q70 List the commissions of all salespeople servicing customers in London

select b.snum,sname,comm
from customers a inner join salespeople b
on a.snum=b.snum
where a.city='London';


select c.snum,sname,comm
from orders a inner join customers b
on a.cnum=b.cnum
inner join salespeople c
on a.snum=c.snum
where b.city='London';

--- Q71 Use ANY or ALL to find all salespeople who have no customers located in their city



select * from salespeople 
where city <> all(select city from customers);
--- Q72 Use EXISTS to select all salespeople with customers located in their cities who are not assigned to them


select a.* from salespeople a
where exists(
select 1 from customers b
where a.city=b.city and a.snum!=b.snum);


select b.* from customers a cross join salespeople b
where a.city=b.city and a.snum!=b.snum;

SELECT DISTINCT b.*
FROM salespeople b
JOIN customers a 
  ON a.city = b.city 
 AND a.snum != b.snum;
 
--- Q73 Select all customers serviced by Peel or Motika

select * from customers 
where snum in (select snum from salespeople
where sname in ('Peel','Monika'));

select * from customers a inner join salespeople b
on a.snum=b.snum and sname in ('Peel','Monika');

select * from customers a
where exists(
select 1 from salespeople b
where b.snum=a.snum and sname in ('Peel','Monika'));

--- Q74 Count the number of salespeople registering orders for each day (count each salesperson once per day)


select to_date(odate,'dd-mm-yyyy') as odate,count(distinct snum) from orders
group by to_date(odate,'dd-mm-yyyy');



--- Q75 Find all orders attributed to salespeople in London

select * from orders a
inner join customers b
on a.cnum=b.cnum
where city='London';

SELECT a.*
FROM orders a
JOIN salespeople s 
  ON a.snum = s.snum
WHERE s.city = 'London';

--- Q76 Find all orders by customers not located in the same cities as their salespeople



select *
from orders a
inner join customers b
on a.cnum=b.cnum
inner join salespeople c
on c.snum=a.snum
where b.city<>c.city;

--- Q77 Find all salespeople who have customers with more than one current order

select snum ,cnum,count(cnum)
from orders 
group by snum,cnum
having count(*)>1;


select * from orders
where exists (
select 1
from orders 
group by snum,cnum
having count(*)>1);

SELECT snum,
       cnum,
       onum,
       DENSE_RANK() OVER (PARTITION BY snum order by onum) AS rank_by_date
FROM orders;

--- Q78 Extract every customer assigned to a salesperson who currently has at least one other customer with orders


select * from orders where snum in (
select snum
from orders
group by snum
having count(distinct cnum) >1);

select * from orders a
where exists(
select 1 from orders b
group by b.snum
having count(distinct b.cnum)>1 and b.snum=a.snum);


SELECT *
FROM orders a
WHERE EXISTS (
    SELECT 1
    FROM orders b
    WHERE b.snum = a.snum
    GROUP BY b.snum
    HAVING COUNT(DISTINCT b.cnum) > 1
);

--- Q79 Select all customers whose name begins with ‘C’

select * from customers 
where initcap(cname) like 'C%';

--- Q80 Find the highest rating in each city (output: “for the city (city) the highest rating is : (rating)”)

SELECT CITY,MAX(RATING) AS RAITING
FROM CUSTOMERS
GROUP BY CITY;

--- Q81 Produce the SNUM values of all salespeople with orders currently in the Orders table without repeats

SELECT DISTINCT SNUM
FROM ORDERS;

--- Q82 List customers in descending order of rating (output rating first, then name and number)

SELECT RATING,CNAME,CNUM FROM CUSTOMERS 
ORDER BY RATING DESC;

--- Q83 Find the average commission for salespeople in London

SELECT round(AVG(COMM),2) FROM salespeople
WHERE CITY='London';


--- Q84 Find all orders credited to the same salesperson that services Hoffman

select * from orders
where snum = (
select snum from customers
where cname='Hoffman');


select * from orders
where snum in (
select snum from orders
where cnum in (
select cnum from customers 
where cname='Hoffman'));  -- as hoffman is not in order table getting no result




select * from orders a
where exists(
select 1 from customers b
where a.snum=b.snum and cname='Hoffman');   ----this is good way

--- Q85 Find all salespeople whose commission is between 0.10 and 0.12 inclusive

select * from salespeople
where comm between 0.10 and 0.12;

--- Q86 List names and cities of all salespeople in London with commission above 0.10

select * from salespeople
where city='London' and COMM>0.10;

--- Q87 Evaluate: SELECT * FROM ORDERS WHERE (AMT < 1000 OR NOT (ODATE = 10/03/1996 AND CNUM > 2003))

- Final WHERE clause:
(Condition A OR NOT Condition B) A row is selected if either AMT < 1000 or NOT(B) is true.

- If the order date is 10‑Mar‑1996 and the customer number is greater than 2003, the inside condition is TRUE → NOT(TRUE) = FALSE.
- If either the date is different or the customer number is not greater than 2003, the inside condition is FALSE → NOT(FALSE) = TRUE.
-------------------------------------
--- Q88 Select each customer’s smallest order-----



SELECT *
FROM ORDERS A
WHERE A.AMT = (
    SELECT MIN(B.AMT)
    FROM ORDERS B
    WHERE B.CNUM = A.CNUM
);

SELECT * FROM ORDERS A
WHERE EXISTS (
SELECT 1
FROM ORDERS B
GROUP BY CNUM
HAVING MIN(B.AMT)=A.AMT AND A.CNUM=B.CNUM);

--- Q89 Select the first customer alphabetically whose name begins with ‘G’

SELECT * FROM (
SELECT  A.*, ROW_NUMBER() OVER(ORDER BY CNAME) RN FROM CUSTOMERS A
WHERE CNAME LIKE 'G%')
WHERE RN=1;


SELECT  * FROM CUSTOMERS 
WHERE CNAME LIKE 'G%'
FETCH FIRST 5 ROWS ONLY;  - ---THIS WAY WE CAN DO ,BUT THIS SYNATX DONT SUPPORT CURRENT VERSION

SELECT  * FROM CUSTOMERS 
WHERE CNAME LIKE 'G%' AND ROWNUM=1;

--- Q90 Count the number of different not NULL city values in the Customers table

SELECT COUNT(DISTINCT CITY) FROM CUSTOMERS;

--- Q91 Find the average amount from the Orders table

SELECT AVG(AMT) FROM ORDERS;

--- Q92 Evaluate: SELECT * FROM ORDERS WHERE NOT (Odate = 10/03/1996 OR Snum > 1006) AND amt >= 1500 
- The date is any value other than 10/03/1996,
- The supplier number is less than or equal to 1006,
- The amount is greater than or equal to 1500.
-------------------------------------

--- Q93 Find all customers not located in San Jose & whose rating is above 200


SELECT * FROM CUSTOMERS 
WHERE CITY NOT in ( 'San Jose') and rating >200;

--- Q94 Simplify: SELECT Snum, Sname, city, Comm FROM salespeople WHERE (Comm > 0.12 and Comm < 0.14)

SELECT Snum, Sname, city, Comm FROM salespeople WHERE comm=0.13;

--- Q95 Evaluate: SELECT * FROM orders WHERE NOT ((Odate = 10/03/1996 AND Snum > 1002) OR amt > 2000)

The query returns all rows where:
- Either the date is not 10/03/1996 or the supplier number is ≤ 1002,
- And the amount is ≤ 2000.

--- Q96 Which salespeople attend to customers not in the city they have been assigned to

select * from customers a inner join salespeople b
on a.snum=b.snum and a.city<>b.city;

select * from salespeople a
where exists(
select 1 from customers b
where a.snum=b.snum and a.city<>b.city);

--- Q97 Which salespeople get commission greater than 0.11 and serve customers rated less than 250


select * from salespeople a
where exists(
select 1 from customers b
where a.snum=b.snum and comm>0.11 and rating <250);

select * from salespeople a inner join customers b
on a.snum=b.snum 
where comm>0.11 and rating <250;

--- Q98 Which salespeople have been assigned to the same city but get different commission percentages


select * from salespeople a
where exists(
select 1 from salespeople b
where a.city=b.city and a.comm<>b.comm);

select * from salespeople a join salespeople b
on a.city=b.city 
where a.comm<>b.comm and a.snum>b.snum ; ---here and a.snum=b.snum to avoid the reverse duplicate values, 
----point to be remember here we applied a.snum>b.snum which is diffrent than join condition both shouldnt be diff  ;
- ON a.city = b.city → ensures we’re comparing salespeople in the same city.
- a.snum > b.snum → ensures we don’t get both (A,B) and (B,A).

select *from salespeople;
---------------------------------------------------------------------------
--- Q99 Which salesperson has earned the most by way of commission



select * from (
select a.snum as snum,(sum(amt)*comm) as commission_amt
from orders a
inner join salespeople b
on a.snum=b.snum
group by a.snum,comm
order by commission_amt desc)
where rownum=1;






--- Q100 Does the customer who placed the maximum number of orders have the maximum rating


WITH order_counts AS (
  SELECT b.cnum,
         COUNT(*) AS total_orders,
         a.rating
  FROM customers a
  JOIN orders b ON a.cnum = b.cnum
  GROUP BY b.cnum, a.rating
),
max_orders AS (
  SELECT *
  FROM order_counts
  WHERE total_orders = (SELECT MAX(total_orders) FROM order_counts)
),
max_rating AS (
  SELECT *
  FROM order_counts
  WHERE rating = (SELECT MAX(rating) FROM order_counts)
)
SELECT CASE
         WHEN EXISTS (
           SELECT 1
           FROM max_orders mo
           JOIN max_rating mr ON mo.cnum = mr.cnum
         )
         THEN 'Yes, same customer'
         ELSE 'No, different customers'
       END AS answer
FROM dual;



with max_rating as (select * from customers
where rating=(select max(rating) from customers))

,max_orders as (select * from (
select cnum, dense_rank() over(order by count(*) desc) as drk
from orders
group by cnum)
where drk=1)

select case when exists 
(select 1 from max_rating a join max_orders b
on a.cnum=b.cnum) 
then 'same employee' 
else 'diff employee' 
end as result from dual; 



select case 
         when exists (
           select 1
           from orders a 
           join customers b on a.cnum = b.cnum
           group by a.cnum, b.rating
           having count(*) = (
               select max(count1) 
               from (select count(*) as count1 from orders group by cnum)
           )
           and rating = (select max(rating) from customers)
         )
         then 'Same customer'
         else 'Different customers'
       end as result
from dual;


,max_orders as (select * from (
select cnum, COUNT(*)
from orders
group by cnum
ORDER BY COUNT(*) DESC)
where ROWNUM=1)

--- Q101 Has the customer who spent the largest amount of money been given the highest rating


with high_rating as ( select * from customers 
                        where rating=(select max(rating) from customers))
,high_amount as 
              ( select * 
                from (select cnum,total_amt,dense_rank() over(order by total_amt desc) as drk 
                      from (select cnum,sum(amt)as total_amt 
                            from orders
                            group by cnum))
                where drk=1) 
                    
,high_amounts as (select cnum,sum(amt)   ----this is just andother way of fidning max amount but this is more efficient
                  from orders 
                  group by cnum
                  having sum(amt)=(select max(sum_amt)
                  from (select sum(amt) as sum_amt from orders group by cnum)))


select case 
        when exists( 
                   select 1 from high_rating a join high_amounts b
                    on a.cnum=b.cnum
                    )
        then 'matching employee both having high amount and high rating '
        else 'not matching'
        end result
from dual ;


--- Q102 List all customers in descending order of customer rating

select * from customers
order by rating desc;

--- Q103 On which days has Hoffman placed orders


-- Overall status
select b.cname,
       case 
         when count(a.odate) = 0 then 'No orders placed'
         else 'Orders exist'
       end as order_status
from customers b
left join orders a on a.cnum = b.cnum
where upper(b.cname) = 'HOFFMAN'
group by b.cname;

-- Individual dates (if any)
select b.cname, a.odate
from customers b
left join orders a on a.cnum = b.cnum
where upper(b.cname) = 'HOFFMAN'
order by a.odate;

--- Q104 Do all salespeople have different commissions




select case when
            (select count(distinct comm) from salespeople)
            =
            (select count(*) from salespeople)
            then 'yes all people have diff commission'
            else 'some have diff comm'
            end result
from dual;
            
--- Q105 Which salespeople have no orders between 10/03/1996 and 10/05/1996

select *
from salespeople a left join orders b
on a.snum=b.snum and b.odate between to_date('10/03/1996','dd/mm/yyyy') and to_date('10/05/1996','dd/mm/yyyy') 
where b.snum is null;

select *
from salespeople a left join orders b
on a.snum=b.snum 
where b.odate between to_date('10/03/1996','dd/mm/yyyy') and to_date('10/05/1996','dd/mm/yyyy')   ---this will not work
and  b.snum is null;

--- Q106 How many salespersons have succeeded in getting

--- Q106 How many salespersons have succeeded in getting orders

select distinct a.* from salespeople  a inner join orders b
on a.snum=b.snum;
--- Q107 How many customers have placed orders

select distinct a.* from customers  a inner join orders b
on a.cnum=b.cnum;

select * from customers where cnum in (select cnum from orders);

--- Q108 On which date has each salesperson booked an order of maximum value

select cnum,to_date(odate,'dd-mm-yyyy'),amt from orders
group by cnum,to_date(odate,'dd-mm-yyyy'),amt
having amt in (
select max(amt) as amt from orders group by cnum);

select * from (
select snum,odate,amt,max(amt) over(partition by cnum) amt_max from orders)
where amt=amt_max;

SELECT cnum, TO_DATE(odate,'dd-mm-yyyy') AS order_date, amt
FROM orders o
WHERE amt = (
    SELECT MAX(amt)
    FROM orders
    WHERE cnum = o.cnum
);

--- Q109 Who is the most successful salesperson

select snum,sum(amt)
from orders
group by snum
having sum(amt)=(select max(amt) from (select sum(amt) as amt
from orders
group by snum));


select * from (
select snum,sum(amt) as sum_amt
from orders
group by snum
order by sum_amt desc)
where rownum=1;


select * from (
select snum,sum(amt) as total_amt, dense_rank() over(order by sum(amt) desc) as rk 
from orders
group by snum) 
where rk =1;

--- Q110 Who is the worst customer with respect to the company

select cnum,sum(amt)
from orders
group by cnum
having sum(amt)=(select min(amt) as amt  from (
                            select sum(amt) as amt from orders group by cnum));


select snum,sum(amt)
from orders
group by snum
having sum(amt)=(select max(amt) from (select sum(amt) as amt
from orders
group by snum));


--- Q111 Are all customers not having placed orders greater than 200 totally been serviced by salesperson Peel or Serres

select a.sname,sum(amt),case when sum(amt)>200 then a.sname     ---we able to add single column here in case statement
else 'not qualified as total not greater than 200'
end result
from salespeople a right join orders b
on a.snum=b.snum 
where upper(a.sname) in ('PEEL','SERRES')
group by a.sname;


--- Q112 Which customers have the same rating

select a.cname,a.rating,b.cname,b.rating from customers a join customers b
on a.rating=b.rating and a.cnum>b.cnum
group by a.cname,b.cname,a.rating,b.rating;

--- Q113 Find all orders greater than the average for October 4th


select * from orders 
where amt>(
select avg(amt) from orders 
where trim(to_char(odate,'dd-month'))=('04-october'));


SELECT *
FROM orders a
WHERE EXISTS (
    SELECT 1
    FROM orders b
    WHERE TRIM(TO_CHAR(b.odate,'DD-MONTH')) = '04-OCTOBER'
    GROUP BY TRIM(TO_CHAR(b.odate,'DD-MONTH'))
    HAVING a.amt > AVG(b.amt)
);


--- Q114 Which customers have above average orders


select * from orders
where amt>(
select avg(amt) from orders);


select * from orders a
where exists(
select 1 from orders b
group by cnum
having avg(b.amt)<a.amt and a.cnum=b.cnum);

select * from (
select cnum,avg(amt) over()  as avg_amt,amt from orders)
where  avg_amt<amt;

--- Q115 List all customers with ratings above San Jose’s average


select * from customers 
where rating >(
select avg(rating) from customers
where upper(city)='SAN JOSE');


select * from customers a
where exists(
select 1 from customers b
where upper(city)='SAN JOSE'
group by b.city,b.cnum
having avg(b.rating)<a.rating and upper(a.city)  not in  'SAN JOSE' );

--- Q116 Select the total amount in orders for each salesperson for which the total is greater than the amount of the largest order in the table

select snum,sum(amt)
from orders
group by snum
having sum(amt)>(select max(amt) from orders);


select distinct amt,snum,max_amt,sum_amt from (
select snum,amt, max(amt) over() as max_amt,sum(amt) over(partition by snum) as sum_amt from orders)
where sum_amt>max_amt or amt=max_amt;

select snum,amt from orders
where amt=(select max(amt) from orders)
union
select snum,sum(amt)
from orders
group by snum
having sum(amt)>(select max(amt) from orders);



select snum,sum(amt),max(amt)
from orders a
group by
having sum(amt)>(select max(amt) from orders) or max(amt) =(select max(amt) from orders);




select a.snum, a.total_amt, 
       b.snum as max_order_person, b.amt as max_order_amt
from (
    select snum, sum(amt) as total_amt
    from orders
    group by snum
) a
join (
    select snum, amt
    from orders
    where amt = (select max(amt) from orders)
) b
on a.total_amt > b.amt;


--- Q117 Give names and numbers of all salesperson that have more than one customer

select a.snum,b.sname,count(*)
from orders a inner join salespeople b
on a.snum=b.snum
group by a.snum,b.sname
having count(*)>1;


select snum, count(*)
from orders
group by snum
order by snum;

select snum, cnum,count(*)
from orders
group by snum,cnum
order by snum;
--- Q118 Select all salesperson by name and numbers who have customers in their city whom they don’t service



select * from salespeople a inner join customers b
on a.city=b.city
where a.snum<>b.snum;

--- Q119 Which customers’ rating should be lowered

select a.cnum,sum(amt),rating
from orders a inner join customers b
on a.cnum=b.cnum
group by a.cnum,rating
having sum(a.amt)=( select min(sum(amt)) as amt
from orders
group by cnum);


select min(sum(amt)) as amt
from orders
group by cnum;

--- Q120 Is there a case for assigning a salesperson to Berlin

select * from 
customers
where upper(city)='BERLIN';

SELECT cnum ,CASE CITY WHEN 'Berlin' then 'Yes' end result FROM CUSTOMERS;

--- Q121 Is there any evidence linking the performance of a salesperson to commission that he or she is being paid

select a.snum,sum(amt),c.comm,trunc(avg(rating)) as avg_rating
from orders a
inner join customers b
on a.cnum=b.cnum
inner join salespeople c
on a.snum=c.snum
group by a.snum,c.comm;

SELECT a.snum, SUM(a.amt) AS total_sales, c.comm, AVG(b.rating) AS avg_rating
FROM orders a
INNER JOIN customers b ON a.cnum = b.cnum
INNER JOIN salespeople c ON a.snum = c.snum
GROUP BY a.snum, c.comm;

--- Q122 Does the total amount in orders by customer in Rome and London exceed the commission paid to salespeople in London and New York by more than 5 times


select case 
when  (select sum(amt) as total_amt
from orders a
inner join customers b
on a.cnum=b.cnum and b.city in ('Rome','London'))  >
5*
(select sum(b.comm*amt) as commisssion_amount
from orders a 
inner join salespeople b 
on a.snum=b.snum and b.city in ('New York','London')
)
then 'yes' else 'no'
end result
from dual;


SELECT
  CASE
    WHEN
      (
        SELECT SUM(o.amt)
        FROM orders o
        JOIN customers c
          ON o.cnum = c.cnum
        WHERE c.city IN ('Rome', 'London')
      )
      >
      5 *
      (
        SELECT SUM(b.comm * o.amt)
        FROM orders o
        JOIN salespeople b
          ON o.snum = b.snum
        WHERE b.city IN ('London', 'New York')
      )
    THEN 'YES'
    ELSE 'NO'
  END AS result
FROM dual;


--- Q123 Which is the date, order number, amount and city for each salesperson (by name) for the maximum order he has obtained



select odate,onum,amt,city from orders a inner join salespeople b
on a.snum=b.snum
where amt = (select max(amt) from orders c
group by snum
having a.snum=c.snum  );


SELECT
  o.odate,
  o.onum,
  o.amt,
  s.city
FROM orders o
JOIN salespeople s
  ON o.snum = s.snum
WHERE o.amt = (
  SELECT MAX(o2.amt)
  FROM orders o2
  WHERE o2.snum = o.snum
);


SELECT
  odate,
  onum,
  amt,
  sname,
  city
  from orders a1 inner join salespeople b
  on a1.snum=b.snum
  where amt=(select max(amt) from orders a2
  where a1.snum=a2.snum);
  
select odate,onum,max_amt,sname from (  select odate,onum,amt,max(amt) over(partition by a1.snum) as max_amt,sname from orders a1
  inner join salespeople b
  on a1.snum=b.snum)
  where max_amt=amt
  order by amt;
  
--- Q124 Which salesperson(s) should be fired

select snum ,sum(amt)from orders a
group by snum
having sum(amt)=(select min(sum(amt)) from orders b group by snum);

--- Q125 What is the total income for the company

select sum(amt) as total_income from orders;


-----employee joined in last 3 months  -----imp 

SELECT employee_id,
       employee_name,
       join_date
FROM   employee
WHERE  join_date >= ADD_MONTHS(SYSDATE, -3);



SELECT employee_id,
       employee_name,
       join_date
FROM   employee
WHERE  join_date BETWEEN ADD_MONTHS(SYSDATE, -3) AND SYSDATE;



select * from orders;


update orders
set amt=onum,onum=amt;


select * from orders;


select * from orders
where amt >= all(select amt from orders);


select a.*, 
row_number() over (partition by cnum order by cnum) as row_ from orders a;

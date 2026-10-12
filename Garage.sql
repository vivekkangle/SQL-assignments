

select * from customer;
select * from vendors;
select * from employee;
select * from sparepart;
select * from purchase;
select * from servicedetails;




Garage System Questions.
---Q.1 List all the customers serviced.--


select * from customer
where c_id in (
select c_id from servicedetails);

select a.*
from customer a inner join servicedetails b
on a.c_id=b.c_id;


select * from customer a
where  exists(
select 1
from servicedetails b
where a.c_id=b.c_id);
 
-----------------
---Q.2 Customers who are not serviced.


select * from customer
where c_id not in (
select c_id from servicedetails);

select *
from customer a left join servicedetails b
on a.c_id=b.c_id
where b.c_id is null;

select * from customer a
where not exists(
select 1
from servicedetails b
where a.c_id=b.c_id);

--- Q.3 Employees who have not received the commission

select * from employee;
select * from servicedetails;


select * from employee
where e_id in (select e_id from sd
where comm=0);

select a.*,b.*
from employee a inner join sd b
on a.e_id=b.e_id
where comm=0;

select * from employee a
where exists(
select 1 from sd b
where a.e_id=b.e_id and comm=0);

--- Q.4 Name the employee who have maximum Commission


select * from employee
where e_id in (
select e_id from sd
where comm=(
select max(comm) from sd));


select *
from employee a inner join sd b
on a.e_id=b.e_id
where comm=(select max(comm) from sd);

--- Q.5 Show employee name and minimum commission amount received by an employee

select *
from employee a inner join sd b
on a.e_id=b.e_id
where comm=(select min(comm) from sd);

select  b.e_id,e_name
from employee a inner join sd b
on a.e_id=b.e_id
group by b.e_id,e_name,comm
having min(comm) = (select min(comm) as comm from sd);

--- Q.6 Display the Middle record from any table


select * from (
select a.* ,
row_number() over( order by s_id) rn,
count(*) over() as total_count 
from sd a)
where rn=trunc((total_count)/2);
--- Q.7 Display last 4 records of any table

select * from (select * from sd
order by s_id desc)
where rownum <=4;

select * from (
select  a.*, ntile(3) over(order by s_id desc) as nt from sd a)
where nt=1;

--- Q.8 Count the number of records without count function from any table


select max(rn) from (
select  row_number() over(order by s_id) rn from sd);

--- Q.9 Delete duplicate records from "Ser_det" table on cid (note Please rollback after execution)


delete from sd
where rowid not in (
select min (rowid) 
from sd
group by c_id);

rollback;



delete from sd
where rowid in (
select rowid from (
select rowid,row_number() over(partition by c_id order by s_id) as rn from sd)
where rn>1);






--- Q.10 Show the name of Customer who have paid maximum amount

select *
from customer a inner join sd b
on a.c_id=b.c_id
where b.e_id=(select rcv_eid  from purchase where total=(select max(total) from purchase));


select *
from customer a inner join sd b
on a.c_id=b.c_id
inner join purchase c
on b.e_id=c.rcv_eid
where c.total in (select max(total) from purchase);



select * from purchase;
select * from sd;



--- Q.11 Display Employees who are not currently working


select * from employee
where e_dol is not null;




--- Q.12 How many customers serviced their two wheelers
select * from sd;

select count(*) from sd
where upper(typ_vehi)='TWO WHEELER';

--- Q.13 List the Purchased Items which are used for Customer Service with Unit of that Item

 

SELECT C_ID,SP_NAME,SP_UNIT,B.TOTAL    ----THIS VERSION FROM PURCASE TABLE THROUGH
FROM SD A INNER JOIN PURCHASE B 
ON A.E_ID=B.RCV_EID
INNER JOIN SPAREPART C
ON B.SP_ID=C.SP_ID;

SELECT C_ID,SP_NAME,SP_UNIT
FROM SD A INNER JOIN SPAREPART B
ON A.SP_ID=B.SP_ID
INNER JOIN PURCHASE C
ON A.SP_ID=C.SP_ID;

SELECT * FROM PURCHASE;
SELECT * FROM SD;
SELECT * FROM SPAREPART;

ALTER TABLE SD
RENAME COLUMN GP_G TO SP_G;

--- Q.14 Customers who have Colored their vehicles

SELECT A.C_ID,C_NAME,SP_NAME
FROM SD A INNER JOIN SPAREPART B
ON A.SP_ID=B.SP_ID
INNER JOIN CUSTOMER C
ON A.C_ID=C.C_ID
WHERE UPPER(SP_NAME) LIKE '%COLOUR%';

--- Q.15 Find the annual income of each employee inclusive of Commission


SELECT A.E_ID,SUM((COMM/100)*SER_AMT+(SER_AMT)) AS ANNUAL_INCOME   ---THIS DIFF REQUIREMENT.... ITS BASED ON SD TABLE INDIVIDUAL EMPLOYEEINCOME
FROM SD A INNER JOIN EMPLOYEE B
ON A.E_ID=B.E_ID
WHERE EXTRACT(YEAR FROM SER_DATE)=2011
GROUP BY A.E_ID;


SELECT A.E_ID,SUM(NVL(COMM,0)+NVL(E_SAL,0))*12 AS ANNUAL_SAL   ---THIS IS THE ANSWR
FROM EMPLOYEE A LEFT JOIN SD B
ON A.E_ID=B.E_ID
GROUP BY A.E_ID;
M 



--- Q.16 Vendor Names who provides the engine oil

SELECT V_NAME
FROM VENDORS A INNER JOIN PURCHASE B
ON A.V_ID=B.V_ID
INNER JOIN SPAREPART C
ON B.SP_ID=C.SP_ID
WHERE UPPER(SP_NAME) LIKE '%OIL%'; 


--- Q.17 Total Cost to purchase the Color and name the color purchased

SELECT SP_NAME,TOTAL
FROM PURCHASE A INNER JOIN SPAREPART B
ON A.SP_ID=B.SP_ID
WHERE UPPER(SP_NAME) LIKE '%COLOUR%';


--- Q.18 Purchased Items which are not used in "Ser_det"

SELECT *
FROM PURCHASE A LEFT JOIN SD B
ON A.SP_ID=B.SP_ID
WHERE B.SP_ID IS NULL;

SELECT * FROM PURCHASE
WHERE SP_ID NOT  IN (
SELECT SP_ID FROM SD );

--- Q.19 Spare Parts Not Purchased but existing in Sparepart

SELECT * FROM SPAREPART
WHERE SP_ID NOT IN (
SELECT SP_ID FROM PURCHASE);

SELECT * FROM SPAREPART A
WHERE NOT   EXISTS(
SELECT 1 FROM PURCHASE B
WHERE A.SP_ID=B.SP_ID);

SELECT A.*
FROM SPAREPART A LEFT JOIN PURCHASE B
ON A.SP_ID=B.SP_ID
WHERE B.SP_ID IS NULL;

--- Q.20 Calculate the Profit/Loss of the Firm. consider one month salary of each employee for Calculation

SELECT  C.REVENUE-(A.PURCHASE_EXPENSE+B.SAL_EXPENSE) AS COMPONY_PROFIT 
FROM(SELECT SUM(TOTAL) AS PURCHASE_EXPENSE FROM PURCHASE) A,
(SELECT SUM(E_SAL) AS SAL_EXPENSE FROM EMPLOYEE) B,
(SELECT SUM(TOTAL) AS REVENUE FROM SD) C;




WITH 
    A AS (SELECT SUM(TOTAL) AS PURCHASE_EXPENSE FROM PURCHASE),
    B AS (SELECT SUM(E_SAL) AS SAL_EXPENSE FROM EMPLOYEE),
    C AS (SELECT SUM(TOTAL) AS REVENUE FROM SD)
SELECT 
    C.REVENUE - (A.PURCHASE_EXPENSE + B.SAL_EXPENSE) AS COMPANY_PROFIT
FROM A, B, C;


--- Q.21 Specify the names of customers who have serviced their vehicles more than one time


SELECT C_NAME, COUNT(*)
FROM SD A INNER JOIN CUSTOMER B
ON A.C_ID=B.C_ID
GROUP BY C_NAME
HAVING COUNT(*)>1;


SELECT * FROM CUSTOMER
WHERE C_ID IN (
SELECT C_ID
FROM SD
GROUP BY C_ID
HAVING COUNT(*)>1);



SELECT  * FROM (
SELECT A.*,DENSE_RANK() OVER(PARTITION BY A.C_ID ORDER BY A.S_ID)  AS DK

FROM SD A INNER JOIN CUSTOMER B
ON A.C_ID=B.C_ID)
WHERE DK>1;

--- Q.22 List the Items purchased from vendors locationwise


SELECT SP_NAME,V_ADD
FROM PURCHASE A INNER JOIN VENDORS B
ON A.V_ID=B.V_ID
INNER JOIN SPAREPART C
ON A.SP_ID=C.SP_ID;

--- Q.23 Display count of two wheeler and four wheeler from ser_details

SELECT TYP_VEHI,COUNT(*) 
FROM SD
GROUP BY TYP_VEHI;

--- Q.24 Display name of customers who paid highest SPGST and for which item

SELECT C_NAME,SP_NAME
FROM SD A INNER JOIN CUSTOMER B
ON A.C_ID=B.C_ID
INNER JOIN SPAREPART C
ON A.SP_ID=C.SP_ID
WHERE A.SP_G =(SELECT MAX(SP_G) FROM SD);

--- Q.25 Display vendors name who have charged highest SPGST rate for which item


SELECT *
FROM PURCHASE A INNER JOIN VENDORS B
ON A.V_ID=B.V_ID
WHERE SP_GST=(
SELECT MAX(SP_GST) FROM PURCHASE);

SELECT * FROM VENDORS A
WHERE EXISTS(
SELECT * FROM 
PURCHASE B
WHERE A.V_ID=B.V_ID AND SP_GST=(SELECT MAX(SP_GST) FROM PURCHASE));



SELECT * FROM (
SELECT  B.*,A.V_ID AS P_V_ID,A.SP_GST,MAX(SP_GST) OVER() AS MAX_SP_GST 
FROM PURCHASE A INNER JOIN VENDORS B
ON A.V_ID=B.V_ID)
WHERE SP_GST=MAX_SP_GST;

--- Q.26 List name of item and employee name who have received item

SELECT C.SP_NAME,B.E_NAME
FROM PURCHASE A INNER JOIN EMPLOYEE B ON A.RCV_EID=B.E_ID
INNER JOIN SPAREPART C ON A.SP_ID=C.SP_ID;

--- Q.27 Display the Name and Vehicle Number of Customer who serviced his vehicle, 
-----And Name the Item used for Service, And specify the purchase date of that Item with his vendor and Item Unit and Location, 
-----And employee Name who serviced the vehicle. for Vehicle NUMBER "MH-14PA335"


SELECT C_NAME,VEH_NO,SP_NAME,P_DATE,V_NAME,V_ADD,SP_UNIT,E_NAME
FROM SD A INNER JOIN CUSTOMER B ON A.C_ID=B.C_ID
INNER JOIN SPAREPART C ON  A.SP_ID=C.SP_ID 
INNER JOIN PURCHASE D ON C.SP_ID=D.SP_ID
INNER JOIN VENDORS E ON D.V_ID=E.V_ID
INNER JOIN EMPLOYEE F ON F.E_ID=A.E_ID
WHERE UPPER(VEH_NO)='MH14PA335';


SELECT
    B.C_NAME,
    A.VEH_NO,
    C.SP_NAME,
    D.P_DATE,
    E.V_NAME,
    E.V_ADD,
    C.SP_UNIT,
    F.E_NAME
FROM SD A
JOIN CUSTOMER  B ON A.C_ID = B.C_ID
JOIN SPAREPART C ON A.SP_ID = C.SP_ID
JOIN PURCHASE  D ON C.SP_ID = D.SP_ID
JOIN VENDORS   E ON D.V_ID = E.V_ID
JOIN EMPLOYEE  F ON A.E_ID = F.E_ID
WHERE REPLACE(UPPER(A.VEH_NO), '-', '') = 'MH14PA335';




--- Q.28 Who belong this vehicle "MH-14PA335" Display the customer name

SELECT * FROM CUSTOMER 
WHERE C_ID=(SELECT C_ID 
            FROM SD 
            WHERE REPLACE(VEH_NO,'-','')='MH14PA335');
            
SELECT C_NAME
FROM SD A INNER JOIN CUSTOMER B
ON A.C_ID=B.C_ID
WHERE REPLACE(VEH_NO,'-','')='MH14PA335';

--- Q.29 Display the name of customer who belongs to New York and when he/she serviced their vehicle on which date


SELECT C_NAME,SER_DATE
FROM SD A INNER JOIN CUSTOMER B ON A.C_ID=B.C_ID
WHERE upper(C_ADD) LIKE '%NEW%YORK%';


SELECT * FROM SD 
WHERE C_ID IN (SELECT C_ID FROM CUSTOMER 
WHERE UPPER(C_ADD)='NEW YORK');


--- Q.30 From whom we have purchased items having maximum cost



SELECT * FROM VENDORS
WHERE V_ID IN (
SELECT V_ID FROM PURCHASE 
WHERE SP_RATE =(
SELECT MAX(SP_RATE) FROM PURCHASE));

SELECT *
FROM PURCHASE A INNER JOIN VENDORS B ON A.V_ID=B.V_ID
WHERE SP_RATE=(SELECT MAX(SP_RATE) FROM PURCHASE ) ;

--- Q.31 Display the names of employees who are not working as Mechanic and that employee done services

SELECT * FROM SD
WHERE E_ID IN (SELECT E_ID FROM EMPLOYEE
                WHERE E_DOL IS NOT NULL);
                
SELECT *
FROM EMPLOYEE A INNER JOIN SD B ON A.E_ID=B.E_ID
WHERE B.E_ID IN (SELECT E_ID FROM EMPLOYEE
                WHERE E_DOL IS NOT NULL);
                
--- Q.32 Display the various jobs along with total number of employees in each job. The output should contain only those jobs with more than two employees

SELECT E_JOB,COUNT(*) FROM EMPLOYEE
GROUP BY E_JOB
HAVING COUNT(*)>2;



--- Q.33 Display the details of employees who done service and give them rank according to their no. of services

SELECT A.E_ID,A.E_NAME,
E_JOB,
E_CONTACT,
E_SAL,
E_DOJ,
A.E_ADD,
COUNT(*),
DENSE_RANK() OVER(ORDER BY COUNT(*) DESC)
FROM EMPLOYEE A INNER JOIN SD B
ON A.E_ID=B.E_ID
GROUP BY A.E_ID,
A.E_NAME,
E_JOB,
E_CONTACT,
E_SAL,
E_DOJ,
A.E_ADD;





WITH A AS 
(SELECT E_ID,COUNT(*) AS COUNTS
FROM SD 
GROUP BY E_ID) 
, B AS (SELECT * FROM EMPLOYEE)

SELECT A.*,B.*, DENSE_RANK() OVER(ORDER BY COUNTS DESC) FROM A,B
WHERE A.E_ID=B.E_ID;



SELECT A.*,B.*,DENSE_RANK() OVER(ORDER BY COUNTS DESC)FROM (
((SELECT E_ID,COUNT(*) AS COUNTS
FROM SD 
GROUP BY E_ID) A JOIN 
(SELECT * FROM EMPLOYEE) B
ON A.E_ID=B.E_ID));








--- Q.34 Display those employees who are working as Painter and fitter and who provide service and total count of service done by fitter and painter


SELECT A.E_ID,A.E_JOB,COUNT(*) AS SERVICE_COUNT
FROM EMPLOYEE A INNER JOIN SD B ON A.E_ID=B.E_ID
GROUP BY A.E_ID,A.E_JOB
HAVING UPPER(E_JOB) IN ('PAINTER','FITTER');

SELECT E_ID ,COUNT(*)
FROM SD
GROUP BY E_ID
HAVING E_ID IN ( SELECT E_ID FROM EMPLOYEE  WHERE UPPER(E_JOB) IN ('PAINTER','FITTER'));

--- Q.35 Display employee salary and as per highest salary provide Grade to employee

SELECT A.*, DENSE_RANK() OVER(ORDER BY NVL(E_SAL,0) DESC) AS GRADE
FROM EMPLOYEE A;

SELECT A.*, NTILE(3) OVER(ORDER BY NVL(E_SAL,0) DESC) AS GRADE
FROM EMPLOYEE A;
--- Q.36 Display the 4th record of emp table without using group by and rowid


SELECT * FROM (
SELECT ROWNUM AS SEQUENCE_, A.* FROM EMPLOYEE A)
WHERE SEQUENCE_=4;

SELECT * FROM (
SELECT A.*, DENSE_RANK() OVER(ORDER BY E_ID) RK FROM EMPLOYEE A)
WHERE RK=4;
SELECT * FROM (
SELECT ROWID AS SEQUENCE_ ,A.* FROM EMPLOYEE A)
WHERE SEQUENCE_='AAAFNJAABAAALF5AAD';

--- Q.37 Provide a commission 100 to employees who are not earning any commission


SELECT E_ID,
       NVL(NULLIF(COMM,0),100) AS COMMISSION
FROM SD;


SELECT E_ID,NVL(NULLIF(COMM,0),100) FROM SD;  ---IMP ONE

--- Q.38 Write a query that totals no. of services for each day and place the results in descending order
SELECT SER_DATE, COUNT(*) AS SERVICE_COUNT
FROM SD 
GROUP BY SER_DATE
ORDER BY SERVICE_COUNT DESC;

SELECT * FROM SD;

--- Q.39 Display the service details of those customer who belong from same city

---ALL LOGICS WRITTEN ARE IMP
SELECT *
FROM SD A INNER JOIN CUSTOMER B 
ON A.C_ID=B.C_ID
WHERE EXISTS(SELECT 1 FROM CUSTOMER C
            WHERE C.C_ADD=B.C_ADD AND B.C_ID<>C.C_ID);  ---SANJU SAMSUNG NOT BENN SERVICED WE NOT SEEING HIS RECORDS

SELECT B.C_ID, B.C_NAME, B.C_ADD
FROM CUSTOMER B
WHERE EXISTS (
  SELECT 1 
  FROM CUSTOMER C
  WHERE C.C_ADD = B.C_ADD 
    AND B.C_ID <> C.C_ID
);




SELECT C_ADD,S_ID
FROM SD A INNER JOIN CUSTOMER B 
ON A.C_ID=B.C_ID
GROUP BY C_ADD,S_ID
HAVING COUNT(*)>1;


SELECT *
FROM SD A
JOIN CUSTOMER B ON A.C_ID = B.C_ID
WHERE B.C_ADD IN (
    SELECT C_ADD
    FROM SD A2
    JOIN CUSTOMER C ON A2.C_ID = C.C_ID
    GROUP BY C_ADD
    HAVING COUNT(DISTINCT C.C_ID) > 1
);



SELECT *
 FROM SD A INNER JOIN CUSTOMER B
 ON A.C_ID=B.C_ID
 WHERE B.C_ADD IN (SELECT C.C_ADD
                  FROM SD D INNER JOIN CUSTOMER C
                  ON D.C_ID=C.C_ID
                  GROUP BY C.C_ADD,C.C_ID
                --  HAVING COUNT(*)>1 AND C.C_ID<>B.C_ID)
                  HAVING COUNT(DISTINCT C.C_ID)>1);
                  
--- Q.40 Write a query join customers table to itself to find all pairs of customers serviced by a single employee


SELECT 
A.E_ID,
A.C_ID AS FIRST_C_ID,
B.C_NAME AS FIRST_C_NAME,
A2.E_ID,
A2.C_ID AS SECOUND_C_ID,
B2.C_NAME AS SECOUND_CUSOMERE_NAME

FROM 
SD A  JOIN SD A2 
    ON A.E_ID=A2.E_ID AND A.C_ID<A2.C_ID
JOIN CUSTOMER B 
    ON A.C_ID=B.C_ID
JOIN CUSTOMER B2
    ON A2.C_ID=B2.C_ID;




SELECT
    A.E_ID,
    C1.C_NAME AS CUSTOMER_1,
    C2.C_NAME AS CUSTOMER_2
FROM SD A
JOIN SD B
    ON A.E_ID = B.E_ID
   AND A.C_ID < B.C_ID          -- prevents mirror duplicates
JOIN CUSTOMER C1
    ON C1.C_ID = A.C_ID
JOIN CUSTOMER C2
    ON C2.C_ID = B.C_ID;


SELECT *
FROM CUSTOMER A INNER JOIN SD B
ON A.C_ID=B.C_ID;

--- Q.41 List each service number followed by name of the customer who made that service

SELECT S_ID,
       C_NAME
FROM SD A INNER JOIN CUSTOMER B
      ON A.C_ID=B.C_ID;
      
--- Q.42 Write a query to get details of employee and provide rating on basis of maximum services provided by employee (rating should be like A,B,C,D)

with service_details as (select e_id,service_count,dense_rank() over(order by service_count desc) as rk 
                        from (select e_id,count(*) as service_count
                                from sd
                                group by e_id))
                                
select a.*,
       b.*,
       case rk 
        when 1 then 'A'
        when 2 then 'b'
        when 3 then 'c'
        else 'd'
        end rating
from employee a join service_details b
    on a.e_id=b.e_id;
                                

--- Q.43 Write a query to get maximum service amount of each customer with their customer details
select b.*,total
from sd a inner join customer b
on a.c_id=b.c_id
where total =(select max(total) from sd c where a.c_id=c.c_id);


select * from 
((select c_id,max(total)
from sd 
group by c_id) a 

join 

(select * from customer) b
on a.c_id=b.c_id);




select  b.*,max(total) over(partition by a.c_id)as max_total
from sd a inner join customer b
on a.c_id=b.c_id;


select * from
(select a.*, row_number() over(partition by a.c_id order by s_id desc) as rn 
from sd a inner join customer b
on a.c_id=b.c_id)
where rn=1;

--- Q.44 Get the details of customers with his total no of services

select a.*,
(select count(*) 
from sd b
group by c_id
having a.c_id=b.c_id) service_count

from customer a;

with a as (select c_id, count(*) as service_count
from sd 
group by c_id)

select * from customer b join a
on a.c_id=b.c_id;

--- Q.45 From which location sparepart purchased with highest cost



select * from vendors
where v_id =(
                select v_id from purchase
                where total=(
                                select max(total)
                                from purchase
                             )
             ;
             
select *
from purchase a inner join vendors b
on a.v_id=b.v_id
where total=(select max(total) from purchase);


--- Q.46 Get the details of employee with their service details who has salary is null


select * from 
sd a inner join employee b
    on a.e_id=b.e_id
where b.e_sal is null;


--- Q.47 Find the sum of purchase location wise

select v_add, sum(total) as location_wise_sum
from purchase a inner  join vendors b
     on a.v_id=b.v_id
    group by v_add;
    
--- Q.48 Write a query sum of purchase amount in word location wise


select v_add, to_char(to_date(trunc(sum(total)),'j'),'jsp') as location_wise_sum
from purchase a inner  join vendors b
     on a.v_id=b.v_id
    group by v_add;
  -------------  
to_char(to_date(trunc(sum(total)),'j'),'jsp')    
- TRUNC(sum(total)) → ensures the sum is an integer (Julian days must be whole numbers).
- TO_DATE(...,'J') → interprets that integer as a Julian day date.
- Example: TO_DATE(1234,'J') means “the date corresponding to Julian day 1234.”
- TO_CHAR(...,'JSP') → spells out the Julian day number in words.
- Oracle internally knows the Julian day number, so it can output "One Thousand Two Hundred Thirty Four".
------
--- Q.49 Has the customer who has spent the largest amount of money been given highest rating
----

select * from employee;
select * from sd;
--- Q.50 Select the total amount in service for each customer for which the total is greater than the amount of the largest service amount in the table

select c_id,sum(total)
from sd
group by c_id
having sum(total)>(select max(total) from sd);

--- Q.51 List the customer name and sparepart name used for their vehicle and vehicle type


select c_name,sp_name,typ_vehi
from sd a inner join customer b
    on a.c_id=b.c_id
inner join sparepart c
    on a.sp_id=c.sp_id;
    
   
--- Q.52 Write a query to get spname, ename, cname, quantity, rate, service amount for record exist in service table

select C_NAME,E_NAME,SP_NAME,QTY,D.SP_RATE,TOTAL
from sd a inner join customer b ON A.C_ID=B.C_ID
         INNER JOIN  EMPLOYEE C ON A.E_ID=C.E_ID
         INNER JOIN SPAREPART D ON A.SP_ID=D.SP_ID;
         
         SELECT * FROM SD;
         ALTER TABLE SD
         RENAME COLUMN OTY TO QTY;
         
--- Q.53 Specify the vehicles owners whose tube damaged

SELECT B.*
FROM SD A INNER JOIN CUSTOMER B ON A.C_ID=B.C_ID
WHERE UPPER(TYP_SER)='TUBE DAMAGED';


--- Q.54 Specify the details who have taken full service

SELECT B.*
FROM SD A INNER JOIN CUSTOMER B ON A.C_ID=B.C_ID
WHERE UPPER(TYP_SER)='FULL SERVICING';

UPDATE SD
SET TYP_SER='FULL SERVICING'
WHERE S_ID=6002;

SELECT * FROM CUSTOMER WHERE C_ID IN (
SELECT C_ID FROM SD WHERE TYP_SER='FULL SERVICING');

--- Q.55 Select the employees who have not worked yet and left the job



SELECT * FROM EMPLOYEE 
WHERE E_DOL IS NOT NULL 
AND 
E_ID NOT IN (SELECT E_ID FROM SD);

SELECT *
FROM SD A RIGHT JOIN EMPLOYEE B
ON A.E_ID=B.E_ID
WHERE E_DOL IS NOT NULL AND A.E_ID IS NULL;

--- Q.56 Select employee who have worked first ever

SELECT E_ID
FROM SD
GROUP BY E_ID
HAVING COUNT(*)=1;
--- Q.57 Display all records falling in odd date

SELECT * FROM SD
WHERE MOD(EXTRACT(DAY FROM SER_DATE),2)=1;
--- Q.58 Display all records falling in even date
SELECT * FROM SD
WHERE MOD(EXTRACT(DAY FROM SER_DATE),2)=0;

--- Q.59 Display the vendors whose material is not yet used


SELECT * FROM VENDORS 
WHERE V_ID IN (
               SELECT V_ID FROM PURCHASE 
               WHERE SP_ID NOT IN (
                                    SELECT SP_ID FROM SD
                                   )
               );
               
SELECT *
FROM SD A FULL JOIN PURCHASE B ON A.SP_ID=B.SP_ID
          FULL JOIN VENDORS C ON B.V_ID=C.V_ID
          WHERE A.SP_ID IS NULL;
          
SELECT DISTINCT C.*
FROM VENDORS C
LEFT JOIN PURCHASE B ON C.V_ID = B.V_ID
LEFT JOIN SD A ON B.SP_ID = A.SP_ID
WHERE A.SP_ID IS NULL;



SELECT *
FROM VENDORS A LEFT JOIN PURCHASE B ON A.V_ID=B.V_ID
LEFT JOIN SD C ON B.SP_ID=C.SP_ID
WHERE C.SP_ID IS NULL;
;
--- Q.60 Difference between purchase date and used date of spare part

SELECT TRUNC(MONTHS_BETWEEN(SER_DATE,P_DATE)/12) AS YEAR, 
        TRUNC(MONTHS_BETWEEN(SER_DATE,P_DATE)) AS NO_OF_MONTHS,
        MOD(TRUNC(MONTHS_BETWEEN(SER_DATE,P_DATE)),12) AS MONTHS,
        (SER_DATE - (ADD_MONTHS(P_DATE,
                                      TRUNC(MONTHS_BETWEEN(SER_DATE,P_DATE))))) AS DAYS,
         (SER_DATE-P_DATE) AS NUMBER_OF_DAYS
FROM SD A INNER JOIN PURCHASE B 
ON A.SP_ID=B.SP_ID;

commit;

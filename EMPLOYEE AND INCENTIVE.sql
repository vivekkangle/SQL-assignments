


CREATE TABLE EMPLOYEE_I
(
EMP_ID  NUMBER (1),
FIRST_NAME VARCHAR2(10),
LAST_NAME VARCHAR2(10),
SALARY NUMBER,
JOINING_DATE DATE,
DEPARTMENT VARCHAR2(10),
CONSTRAINTS PK PRIMARY KEY (EMP_ID)
);

INSERT INTO EMPLOYEE_I
VALUES(1,'JOHN','ABRAHAM',1000000,TO_DATE('01-JAN-13','DD-MON-YY'),'BANKING');


INSERT INTO EMPLOYEE_I VALUES (2, 'Michael', 'Clarke', 800000, TO_DATE('01-JAN-13', 'DD-MON-RR'), 'Insurance');
INSERT INTO EMPLOYEE_I VALUES (3, 'Roy', 'Thomas', 700000, TO_DATE('01-FEB-13', 'DD-MON-RR'), 'Banking');
INSERT INTO EMPLOYEE_I VALUES (4, 'Tom', 'Jose', 600000, TO_DATE('01-FEB-13', 'DD-MON-RR'), 'Insurance');
INSERT INTO EMPLOYEE_I VALUES (5, 'Jerry', 'Pinto', 650000, TO_DATE('01-FEB-13', 'DD-MON-RR'), 'Insurance');
INSERT INTO EMPLOYEE_I VALUES (6, 'Philip', 'Mathew', 750000, TO_DATE('01-JAN-13', 'DD-MON-RR'), 'Services');

SELECT * FROM EMPLOYEE_I;

CREATE TABLE INCENTIVES(
EMPLOYEE_REF_ID NUMBER(1),
INCENTIVE_DATE DATE,
INCENTIVE_AMOUNT NUMBER,
CONSTRAINT INCENTIVE_FK FOREIGN KEY(EMPLOYEE_REF_ID) REFERENCES EMPLOYEE_I(EMP_ID)
);

INSERT INTO INCENTIVES VALUES(1,TO_DATE('1-FEB-13','DD-MON-YY'),5000);
INSERT INTO INCENTIVES VALUES(2,TO_DATE('1-FEB-13','DD-MON-YY'),3000);
INSERT INTO INCENTIVES VALUES(3,TO_DATE('1-FEB-13','DD-MON-YY'),4000);
INSERT INTO INCENTIVES VALUES(1,TO_DATE('1-FEB-13','DD-MON-YY'),4500);
INSERT INTO INCENTIVES VALUES(2,TO_DATE('1-FEB-13','DD-MON-YY'),3500);

SELECT * FROM INCENTIVES;

UPDATE INCENTIVES
SET INCENTIVE_DATE=TO_DATE('01-JAN-13','DD-MON-YY')
WHERE INCENTIVE_AMOUNT IN (4500,3500);

SELECT FIRST_NAME, LAST_NAME FROM EMPLOYEE_I;




5.	Get First_Name from employee table using alias name “Employee Name”--

SELECT FIRST_NAME AS EMPLOYEE_NAME FROM EMPLOYEE_I;



6.	Get First_Name from employee table in upper case--

SELECT UPPER(FIRST_NAME) FROM EMPLOYEE_I;

7.	Select first 3 characters of FIRST_NAME from EMPLOYEE--


SELECT SUBSTR(FIRST_NAME,1,3) FROM EMPLOYEE_I;

8.	Get position of 'o' in name 'John' from employee table--

SELECT FIRST_NAME,INSTR(UPPER(FIRST_NAME),'O',-1,1) FROM EMPLOYEE_I
WHERE UPPER(FIRST_NAME)='JOHN';

SELECT INSTR('THIS IS STRING','I',-1,2) FROM DUAL;

select substr('this is string',1,1)='a' from dual;

9.	Get FIRST_NAME from employee table after removing white spaces from right side.--

SELECT RTRIM(FIRST_NAME) FROM EMPLOYEE_I;

10.	Get First_Name from employee table after replacing 'o' with '$'--

SELECT TRANSLATE(UPPER(FIRST_NAME),'O','$') FROM EMPLOYEE_I;

11.	Get First_Name and Last_Name as single column from employee table separated by a '_'--

SELECT FIRST_NAME || '_'||LAST_NAME FROM EMPLOYEE_I;

12.	Get FIRST_NAME, Joiningyear, Joining Month and Joining Date from employee table--

SELECT FIRST_NAME,EXTRACT(MONTH FROM JOINING_DATE) AS JOINING_MONTH,EXTRACT(DAY FROM JOINING_DATE) AS JOINING_DAY FROM EMPLOYEE_I;

SELECT FIRST_NAME,TO_CHAR(JOINING_DATE,'DD') FROM EMPLOYEE_I
WHERE TO_CHAR(JOINING_DATE,'DD')=01;

SELECT * FROM EMPLOYEE_I;

13.	Get all employee details from the employee table order by First_Name Ascending

SELECT FIRST_NAME FROM EMPLOYEE_I
ORDER BY FIRST_NAME;

14.	Get all employee details from the employee table order by First_Name Ascending and Salary Descending?--

SELECT FIRST_NAME,SALARY FROM EMPLOYEE_I
ORDER BY FIRST_NAME ASC,SALARY DESC;

15.	Get employee details from employee table whose employee name is “John”--

SELECT * FROM EMPLOYEE_I
WHERE UPPER(FIRST_NAME)='JOHN';

16.	Get employee details from employee table whose employee name are “John” and “Roy”--


SELECT * FROM EMPLOYEE_I
WHERE UPPER(FIRST_NAME)IN ('JOHN','ROY');
17.	Get employee details from employee table whose employee name are not “John” and “Roy”.


SELECT * FROM EMPLOYEE_I
WHERE UPPER(FIRST_NAME) NOT IN ('JOHN','ROY');

18.	Get employee details from employee table whose first name starts with 'J'.--

SELECT * FROM EMPLOYEE_I
WHERE lower(FIRST_NAME) like 'j%';

SELECT * FROM EMPLOYEE_I;

19.	Get employee details from employee table whose first name contains 'o'.

select * from employee_i
where upper(first_name) like '%O%';

20.	Get employee details from employee table whose first name ends with 'n'.

select * from employee_i
where upper(first_name) like '%N';
21.	Get employee details from employee table whose first name ends with 'n' and name contains 4 letters.

select * from employee_i
where upper(first_name) like '___N';

22.	Get employee details from employee table whose first name starts with 'J' and name contains 4 letters.

select * from employee_i
where upper(first_name) like 'J___';

23.	Get employee details from employee table who’s Salary greater than 600000.--

select * from employee_i
where salary> 600000;

24.	Get employee details from employee table whose joining year is “2013”.
select * from employee_i
where to_char(joining_date,'yyyy')=2013;

25.	Get employee details from employee table whose joining month is “January”.

select * from employee_i
where extract(month from joining_date)=1;

select * from employee_i
where TRIM(UPPER(to_char(JOINING_DATE,'MM')))='JANUARY';

SELECT * FROM EMPLOYEE_I
WHERE TRIM(UPPER(TO_CHAR(TO_DATE(JOINING_DATE,'DD-MM-YYYY'),'MM')))= '01';




26.	Get employee details from employee table who joined before January 1st 2013.--

SELECT * FROM EMPLOYEE_I
WHERE EXTRACT(YEAR FROM JOINING_DATE)<2013;

SELECT * FROM EMPLOYEE_I
WHERE TO_CHAR(JOINING_DATE,'YYYY')<2013;

27.	Get employee details from employee table who joined after January 31st--

SELECT * FROM EMPLOYEE_I
WHERE  EXTRACT(MONTH FROM JOINING_DATE)>1;

  

28.	Get Joining Date and Time from employee table--


SELECT TO_CHAR(JOINING_DATE,'DD-MM-YYYY HH24-MI-SS') FROM EMPLOYEE_I;

29.	Get Joining Date, Time including milliseconds from employee table--

SELECT TO_CHAR(JOINING_DATE,'DD-MM-YYYY HH24-MI-SS') FROM EMPLOYEE_I;
SELECT TO_CHAR(JOINING_DATE,'DD-MM-YYYY HH24-MI-SS-FF3') FROM EMPLOYEE_I;

SELECT TO_CHAR(SYSTIMESTAMP,'DD-MM-YYYY HH24-MI-SS-FF3') FROM DUAL;

30.	Get difference between JOINING_DATE and INCENTIVE_DATE from employee and incentives table.--

select * from employee_i;
select * from incentives;

SELECT joining_date,incentive_date, MONTHS_BETWEEN (INCENTIVE_DATE,joining_date) as MONTHS,
incentive_date-last_day(add_months(joining_date,trunc(months_between(incentive_date,joining_date))-1))as days  
FROM EMPLOYEE_I,INCENTIVES
where emp_id=employee_ref_id;



31.	Get department, total salary with respect to a department from employee table.

select * from employee_i;

select department,sum(salary) as total_salary from employee_i
group by department;

32.	Get department, total salary with respect to a department from employee table order by total salary descending.--


select department,sum(salary) as total_salary from employee_i
group by department
order by total_salary desc;

33.	Get department, no of employees in a department, total salary with respect to a department
from employee table order by total salary descending.

select department,sum(salary) as total_salary ,count(*) as no_of_employee from employee_i
group by department
order by total_salary desc;


34.	Get department wise average salary from employee table order by salary ascending?

select department,trunc(avg(salary)) avg_salary from employee_i
group by department
order by avg_salary;

35.	Get department wise maximum salary from employee table order by salary ascending?

select department,max(salary)  as maximum_salary from employee_i
group by department
order by maximum_salary;

36.	Get department wise minimum salary from employee table order by salary ascending?

select department,min(salary)  as minimum_salary from employee_i
group by department
order by minimum_salary;


37.	Select no of employees joined with respect to year and month from employee table.

select extract(year from joining_date),to_char(joining_date,'month'), count(*) as number_of_employees from employee_i
group by extract(year from joining_date),to_char(joining_date,'month');

select  * from (
select  emp_id,first_name,joining_date,row_number() over(partition by extract(year from joining_date) 
order by extract(month from joining_date)) from employee_i);



38.	Select department,total salary with respect to a department from employee table 
where total salary greater than 800000 order by Total_Salary descending

select department,sum(salary) as total_salary from employee_i
group by department
having sum(salary) > 800000;

39.	Select employee details from employee table if data in incentive table?

select distinct e.* from employee_i e
inner join incentives i
on emp_id=employee_ref_id;

select * from employee_i;

40.	Select 20 % of salary from John, 10% of Salary for Roy and for other 15 % of salary from employee table

select FIRST_NAME,SALARY,case when upper(first_name)='JOHN' THEN SALARY*0.2
WHEN upper(first_name)='ROY' THEN SALARY*0.1
ELSE SALARY*0.15
END SALARY_CALCULATOR
FROM EMPLOYEE_I;


41.	Select Banking as 'Bank Dept', Insurance as 'Insurance Dept' and Services as    'Services Dept' from employee table.

SELECT FIRST_NAME ,CASE  WHEN upper(department)='BANKING' THEN 'BANK DEPT'
WHEN upper(department)='INSURANCE' THEN 'Insurance Dept'
WHEN upper(department)='SERVICES' THEN  'Services Dept'
else department
END DEPARTMENT
FROM EMPLOYEE_I;

SELECT * FROM EMPLOYEE_I;


42.	Delete employee data from employee table who got incentives in incentive table --

DELETE FROM EMPLOYEE_I
WHERE  ( EMP_ID ) IN (SELECT EMPLOYEE_REF_ID FROM INCENTIVES
WHERE INCENTIVE_AMOUNT IS NOT NULL);

DELETE FROM EMPLOYEE_I
WHERE EMP_ID IN (
SELECT EMP_ID FROM EMPLOYEE_I
INNER JOIN INCENTIVES
ON EMP_ID=EMPLOYEE_REF_ID);

SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME='INCENTIVES';

ALTER TABLE INCENTIVES
DROP CONSTRAINT INCENTIVE_FK;

ALTER TABLE INCENTIVES
ADD CONSTRAINT INCENTIVES_FK FOREIGN KEY(EMPLOYEE_REF_ID) REFERENCES EMPLOYEE_I(EMP_ID) ON DELETE SET NULL;

SELECT * FROM INCENTIVES;


43.	Select first_name, incentive amount from employee and incentives table for those employees who have incentives.

ROLL BACK;
SELECT * FROM EMPLOYEE_I;

SELECT DISTINCT FIRST_NAME,INCENTIVE_AMOUNT FROM EMPLOYEE_I
INNER JOIN INCENTIVES
ON EMP_ID=EMPLOYEE_REF_ID;

SELECT * FROM EMPLOYEE_I;

SELECT FIRST_NAME,INCENTIVE_AMOUNT FROM EMPLOYEE_I
RIGHT JOIN INCENTIVES
ON EMP_ID=EMPLOYEE_REF_ID;

44.	Select first_name, incentive amount from employee and incentives table for those employees 
who have incentives and incentive amount greater than 3000

SELECT DISTINCT FIRST_NAME,INCENTIVE_AMOUNT FROM EMPLOYEE_I
INNER JOIN INCENTIVES
ON EMP_ID=EMPLOYEE_REF_ID
WHERE INCENTIVE_AMOUNT>3000;

---45.	Select first_name, incentive amount from employee and incentives table for all employees even if they didn't get incentives  ----

SELECT FIRST_NAME,INCENTIVE_AMOUNT FROM EMPLOYEE_I
FULL JOIN INCENTIVES
ON EMPLOYEE_REF_ID=EMP_ID;

46.	Select first_name, incentive amount from employee and incentives table for all employees 
even if they didn't get incentives and set incentive amount as 0 for those employees who didn't get incentives.

SELECT FIRST_NAME,NVL(INCENTIVE_AMOUNT,0) FROM EMPLOYEE_I
FULL JOIN INCENTIVES
ON EMPLOYEE_REF_ID=EMP_ID;

47.	Select first_name, incentive amount from employee and incentives table for all employees who got incentives using left join

SELECT FIRST_NAME,INCENTIVE_AMOUNT FROM INCENTIVES
LEFT JOIN EMPLOYEE_I
ON EMP_ID=EMPLOYEE_REF_ID;


48.	Select max incentive with respect to employee from employee and incentives table using sub query.

select first_name,max(i.incentive_amount)
from employee_i e,incentives i
where emp_id=employee_ref_id
group by i.employee_ref_id,first_name;



SELECT 
    e.first_name,
 (SELECT MAX(i.incentive_amount)
         FROM incentives i
         WHERE e.emp_id = i.employee_ref_id)
         AS max_incentive
FROM employee e;



SELECT FIRST_NAME,(SELECT MAX(INCENTIVE_AMOUNT) FROM INCENTIVES
WHERE EMP_ID=EMPLOYEE_REF_ID
GROUP BY EMPLOYEE_REF_ID) 
FROM EMPLOYEE_I;

48.	Select max incentive with respect to employee from employee and incentives table using sub query.

select * from incentives;

select emp_id,first_name,(select max(incentive_amount) from incentives
where emp_id=employee_ref_id
group by employee_ref_id) from employee_i;






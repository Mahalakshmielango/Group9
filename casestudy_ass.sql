
--- Create a database

create database cstudy;
use cstudy;

--- Table creation

create table employee (
    employee_id int primary key,
	ename varchar (30),
	department varchar(30),
	email varchar(30),
	epassword varchar(30) 
);

create table assets(
     asset_id int primary key,
	 aname varchar (30),
	 atype varchar(30),
	 s_no varchar(30),
	 purchase_date date,
	 loc varchar(30),
	 astatus varchar(20),
	 owner_id int,
	 constraint assests_emp foreign key(owner_id) references employee(employee_id)
);
create table maintenance (
     maintenance_id int primary key,
	 asset_id int,
	 maintenance_date date,
	 mdescription varchar(50),
	 cost decimal(10,2),
	 constraint main_ass foreign key(asset_id) references assets(asset_id)
);

create table asset_allocation(
allocation_id int primary key,
assert_id int,
employee_id int,
allocation_date date,
return_date date,
constraint main_ask foreign key(assert_id) references assets(asset_id),
constraint main_em foreign key(employee_id) references employee(employee_id)
);

create table reservations(
reservation_id int primary key,
assert_id int,
employee_id int,
reservation_date date,
start_date1 date,
end_date1 date,
status1 varchar(20),
constraint main_atb foreign key(assert_id) references assets(asset_id),
constraint main_tem foreign key(employee_id) references employee(employee_id)
);

--- Inserting values for the created tables 

insert into employee(employee_id, ename, department,email,epassword)values
(1,'Sathish Kumar','Cyber Security','sathish@gamil.com','alpha123'),
(2, 'Ram Naidu','Data Science','ramnaidu@gmail.com','beta124'),
(3, 'Saranya Sri','UX Design','saranyasri@gmail.com','gama123'),
(4, 'Gopal Sai','Machine Learning','gopalsai@gmail.com','gpu246'),
(5, 'Karthiga' ,'Testing','karthiga@gmail.com','kpi678');

INSERT INTO assets (asset_id,aname, atype, s_no, purchase_date, loc, astatus, owner_id)
VALUES 
(101,'HP ', 'Laptop', 'SNO1', '2020-01-01', 'chennai', 'in use', 1),
(102,'dell ', 'Laptop', 'SNO2', '2024-11-21', 'madurai', 'under maintenance', 2),
(103,'bi-cyle', 'vehicle', 'SNO3', '2022-03-01', 'trichy', 'in use', 3),
(104,'samsung', 'Mobile', 'SNO4', '2023-05-15', 'chennai', 'under maintenance', 4),
(105,'apple', 'Mobile', 'SNO5', '2023-05-25', 'coimbatore', 'decommissioned', 5);

INSERT INTO maintenance (maintenance_id , asset_id, maintenance_date, mdescription,cost) values
(201, 101, '2022-01-09','Part-replacement',78547.89),
(202, 102, '2023-02-08','Cleaning',68347.69),
(203, 103, '2021-04-06','Lubrication',56834.32),
(204, 104, '2022-07-12','Testing',68347.69),
(205, 105, '2022-09-05','Part-replacement',98564.37);

INSERT INTO asset_allocation (allocation_id,assert_id, employee_id, allocation_date, return_date)
VALUES 
(301, 101,1, '2024-11-22', '2024-12-31'),
(302, 102,2, '2023-12-21', '2023-12-31'),
(303, 103,3, '2022-01-13', '2024-06-30'),
(304, 104,4, '2021-05-21', '2023-11-30'),
(305, 105,5, '2023-03-11', '2024-10-31');

INSERT INTO reservations (reservation_id,assert_id,employee_id,reservation_date,start_date1,end_date1,status1) values
(401,101,1,'2024-12-28','2020-05-03','2021-04-12','Pending'),
(402,102,2,'2023-12-24','2021-04-12','2022-02-18','Approved'),
(403,103,3,'2023-08-17','2022-08-09','2023-05-13','Canceled'),
(404,104,4,'2022-05-15','2021-03-02','2023-05-16','Pending'),
(405,105,5,'2024-08-23','2022-06-07','2022-09-14','Approved');

----- To show the relation of each table

SELECT *from employee   ---1

SELECT *from assets   ---2

SELECT *from asset_allocation   ---3

SELECT *from maintenance   ---4

SELECT *from reservations   ---5

---- 1. Simple query to execute the details of employee whose id = 5

SELECT *from employee
where employee_id = 5;

--- 2. Implementing LEFT JOIN to execute the table employee and table asset_allocation

SELECT employee.employee_id, employee.ename, employee.department from employee
LEFT JOIN asset_allocation ON employee.employee_id = asset_allocation.employee_id;

--- 3. Implementing FULL JOIN to execute the table assets and table maintenance

SELECT assets.asset_id, assets.aname, assets.atype from assets
FULL JOIN maintenance ON assets.asset_id = maintenance.asset_id;

--- 4. Executing the asset_id of a employee using a sub-query

SELECT assert_id from asset_allocation where employee_id = 
(select employee_id from employee where employee.employee_id=asset_allocation.employee_id); 

--- 5. Executing the reservation_id of a employee using a sub query

SELECT reservation_id from reservations where assert_id = 
(select assert_id from asset_allocation where asset_allocation.assert_id = reservations.assert_id);

--- 6. Retrive the count of assests by using group by

select atype , count(*) from assets
group by atype

--- Adding new values for the next set of queries 

insert into assets (asset_id,aname,atype,s_no,purchase_date,loc,astatus,owner_id)
values(106,'vivo','mobile','SNO5','2024-06-26','banglore','in use',1)

insert into assets (asset_id,aname,atype,s_no,purchase_date,loc,astatus,owner_id)
values(107,'hero honda','vehicle','SNO6','2024-07-26','dellhi','under maintenance',1)

--- 7. To execute assets that are not allocated to any employee

select * from assets 
where asset_id not in (select assert_id from asset_allocation);


--- 8. By using RIGHT JOIN select a.asset_id,a.aname,e.employee_id

select a.asset_id,a.aname,e.employee_id
from assets a 
right join employee e on e.employee_id=a.owner_id

--- 9. To retrive employees who own assests located in chennai or delhi

SELECT *
FROM employee
WHERE employee_id IN (SELECT owner_id
                      FROM assets
                      WHERE loc IN ('chennai', 'delhi'));


--- 10. To Retrieve the total cost of maintenance for each asset.

SELECT a.aname, m.cost
FROM assets a 
JOIN maintenance m ON a.asset_id = m.asset_id 
GROUP BY a.aname,m.cost;
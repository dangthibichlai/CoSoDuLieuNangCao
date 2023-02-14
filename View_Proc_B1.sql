CREATE VIEW viewDemo
AS
 SELECT e.employee_id, first_name +" " + last_name AS FullName, 
 hire_date,department_name,
 job_title,min_salary,max_salary
 FROM  jobs j join employees e on j.job_id = e.job_id
		      join departments d on e.department_id = d.department_id;
SELECT * FROM viewDemo;

DELIMITER $$
CREATE PROCEDURE Procedure_demo ()
BEGIN
    SELECT e.employee_id, CONCAT(first_name, ' ', last_name)  AS FullName, 
 hire_date,department_name,
 job_title,min_salary,max_salary
 FROM  jobs j join employees e on j.job_id = e.job_id
		      join departments d on e.department_id = d.department_id;
END;$$
call Procedure_demo
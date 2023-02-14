use nhansu;
-- VIEW 1: Tạo View có tên View_Sala  với những nhân  viên mức lương trên 10.000.00 và ở phòng ban 10 
CREATE VIEW View_Sala  
AS
SELECT * FROM employees
WHERE salary > 10000.00 AND department_id = 10;

select * from view_sala

/* CAU VIEW 2: Tạo view  có tên View_oldLuong hiện những người đủ điều kiện tăng lương  nhân viên (
1.Nhân viên có năm làm việc > 20 năm lương tăng 5%; 
2.có năm làm việc > 25 năm lương tăng 10% 
3. có năm làm việc > 30 năm lương tăng 20%; */
CREATE VIEW View_oldLuong AS
SELECT employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, manager_id, department_id,
CASE
WHEN DATEDIFF(CURDATE(), hire_date) / 365 > 30 THEN salary * 1.2
WHEN DATEDIFF(CURDATE(), hire_date) / 365 > 25 THEN salary * 1.1
WHEN DATEDIFF(CURDATE(), hire_date) / 365 > 20 THEN salary * 1.05
ELSE salary
END AS new_salary
FROM employees;

 select * from View_oldLuong
 /*
 CAU pROCEDURE 1:Search_Name
 */
 DELIMITER $$
CREATE PROCEDURE Search_Name (IN name VARCHAR (50))
BEGIN
	SELECT * FROM employees WHERE first_name = name OR last_name  = name ;
END$$

CALL Search_Name ('Steven');

/*
CAU pROCEDURE 1:Tạo một thủ tục hàm lưu trữ để thông thủ tục này có thể bổ sung thêm một ghi mới cho bảng Employees (thủ tục phải thực hiện kiểm ta tính hợp lệ của dữ liệu cần bổ sung. không trùng khóa chính và đảm bản toàn vẹn tham chiếu

*/
DELIMITER $$
CREATE PROCEDURE `insert_employee`(
IN `p_first_name` VARCHAR(20),
IN `p_last_name` VARCHAR(25),
IN `p_email` VARCHAR(100),
IN `p_phone_number` VARCHAR(20),
IN `p_hire_date` DATE,
IN `p_job_id` INT(11),
IN `p_salary` DECIMAL(8,2),
IN `p_manager_id` INT(11),
IN `p_department_id` INT(11)
)
BEGIN
DECLARE `v_count` INT(11);
-- KIỂM TRA JOB_ID COMMENT
SELECT COUNT(*) INTO `v_count` FROM `jobs` WHERE `job_id` = `p_job_id`;
IF `v_count` = 0 THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Job ID does not exist';
END IF;
-- KIỂM TRA DEPARTMENT_ID COMMENT
SELECT COUNT(*) INTO `v_count` FROM `departments` WHERE `department_id` = `p_department_id`;
IF `v_count` = 0 THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'p_department_id does not exist';
END IF;
-- KIỂM TRA MANAGER_ID COMMENT
SELECT COUNT(*) INTO `v_count` FROM `employees` WHERE `employee_id` = `p_manager_id`;
IF `v_count` = 0 THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'p_manager_id does not exist';
END IF;

INSERT INTO `employees`(`first_name`, `last_name`, `email`, `phone_number`, `hire_date`, `job_id`, `salary`, `manager_id`, `department_id`) VALUES (`p_first_name`, `p_last_name`, `p_email`, `p_phone_number`, `p_hire_date`, `p_job_id`, `p_salary`, `p_manager_id`, `p_department_id`);
END$$


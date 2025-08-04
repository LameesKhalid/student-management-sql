-- 📝 Student Management Mini Project using SQL
-- 👩‍💻 Prepared by: Lamees Khalid
-- 📄 Description:
-- This file contains all SQL queries for a mini student management system.
-- It includes answers to exercises and training questions, based on a sample database
-- with the following table structures:

-- 📌 Table structures used:
-- students(id, name, branch, stage)
-- grades(id, student_id, subject, grade)
-- subjects(id, name, doctor_id)
-- doctors(id, name, department)


-- • SELECT, WHERE, and ORDER BY Basics

-- 1/ Display the names of all students.
-- ANS:

SELECT `students`.`name` FROM `students`;

-- 2/ Display only the names of students in the fourth grade.
-- ANS: 

SELECT `students`.`name` FROM `students` WHERE `students`.`stage` = 4;

-- 3/ Display the names of students whose branch is "CS" and who are in the second grade.
-- ANS:

SELECT `students`.`name` FROM `students` WHERE `students`.`branch` = "CS" and `students`.`stage` = 2;

-- 4/ Display the names of students who are not in the third grade.
-- ANS:

SELECT `students`.`name` FROM `students` WHERE not `students`.`stage` = 3;
-- or 
SELECT `students`.`name` FROM `students` WHERE `students`.`stage` != 3;

-- 5/ Display students in descending order by name.
-- ANS:

SELECT `students`.* FROM `students` ORDER by `students`.`name` desc;

-- 6/ Display the top 3 students by ID number.
-- ANS:

SELECT `students`.* FROM `students` ORDER by id limit 3;

-- ////////////////////////////////////////////

-- • Aggregate functions: COUNT, AVG, SUM, MAX, MIN

-- 7/ Calculate the number of students present.
-- ANS:

SELECT COUNT(`students`.`id`) FROM `students`;

-- 8/ Calculate the highest grade entered in the grade table.
-- ANS:

SELECT MAX(`grades`.`grade`) FROM `grades`;

-- 9/ Calculate the average grade of student "Lamees Khalid."
-- ANS:

SELECT `students`.`name`, AVG(`grades`.`grade`) 
FROM `grades` 
INNER JOIN `students` ON `students`.`id` = `grades`.`student_id` 
WHERE `students`.`name` = "Lamees khalid";

-- 10/ Calculate the total grades for each student (group by name).
-- ANS:

SELECT `students`.`name`, SUM(`grades`.`grade`) 
FROM `grades` 
INNER JOIN `students` ON `students`.`id` = `grades`.`student_id` 
GROUP BY `students`.`name`;

-- ////////////////////////////////////////////

-- • Relationships and JOINs

-- 11/ Display the student's name, course name, and grade.
-- ANS:

SELECT students.name, subjects.name, grades.grade 
FROM grades 
INNER JOIN students ON students.id = grades.student_id 
INNER JOIN subjects ON subjects.id = grades.subject_id;

-- 12/ Display the course names and the name of the professor responsible for each course.
-- ANS:

SELECT subjects.name, doctors.name 
FROM subjects 
INNER JOIN doctors ON doctors.id = subjects.doctor_id;

-- 13/ Display the students' names, their branch, their course, and their grade (using a join between three tables).
-- ANS:

SELECT students.name, students.branch, subjects.name, grades.grade 
FROM grades 
INNER JOIN students ON students.id = grades.student_id 
INNER JOIN subjects ON subjects.id = grades.subject_id;

-- 14/ Display the students' names with their grades, even if they don't have grades yet (left join).
-- ANS:

SELECT students.name, grades.grade 
FROM students 
LEFT JOIN grades ON students.id = grades.student_id;

-- ////////////////////////////////////////////

-- • GROUP BY and HAVING

-- 15/ Display student names and their grade point averages.
-- ANS:

SELECT `students`.`name`, AVG(`grades`.`grade`) AS Average_of_student
FROM `grades`
INNER JOIN `students` ON `students`.`id` = `grades`.`student_id`
GROUP BY `students`.`name`;

-- 16/ Display only students with a grade point average of 75 or higher.
-- ANS:

SELECT `students`.`name`, AVG(`grades`.`grade`) AS Average_of_student
FROM `grades`
INNER JOIN `students` ON `students`.`id` = `grades`.`student_id`
GROUP BY `students`.`name`
HAVING AVG(`grades`.`grade`) > 75

-- 17/ Display the name of each course and the number of students enrolled in it.
-- ANS:

SELECT `subjects`.`name`, COUNT(`students`.`id`) AS number_of_student
FROM `grades`
INNER JOIN `subjects` ON `subjects`.`id` = `grades`.`subject_id`
INNER JOIN `students` ON `students`.`id` = `grades`.`student_id`
GROUP BY `subjects`.`name`

-- ////////////////////////////////////////////

-- • SELECT DISTINCT and ALIASES

-- 18/ Display all existing branches without duplicates.
-- ANS:

SELECT DISTINCT `students`.`branch` FROM `students`;

-- 19/ Display the student's name and subject name, but change the column name to "Student", "Subject".
-- ANS:

SELECT DISTINCT `students`.`name` as student , `subjects`.`name` as subject 
FROM `grades` 
INNER JOIN `students` ON `students`.`id` = `grades`.`student_id`
INNER JOIN `subjects` ON `subjects`.`id` = `grades`.`subject_id`;

-- ////////////////////////////////////////////

-- • BETWEEN, IN, LIKE

-- 20/ Display the names of students with grades between 70 and 90.
-- ANS:

SELECT `students`.`name`, `grades`.`grade` 
FROM `grades` 
INNER JOIN `students` ON `students`.`id` = `grades`.`student_id`  
WHERE `grades`.`grade` BETWEEN 70 AND 90;

-- 21/ Display only the names of students with grades of 50, 70, or 90.
-- ANS:

SELECT `students`.`name`, `grades`.`grade` 
FROM `grades` 
INNER JOIN `students` ON `students`.`id` = `grades`.`student_id`  
WHERE `grades`.`grade` IN (50, 70, 90);

-- 22/ Display only the names of students whose names begin with the letter "L."
-- ANS:

SELECT `students`.`name` 
FROM `students` 
WHERE `students`.`name` LIKE 'l%';

-- ////////////////////////////////////////////

-- • EXIST and ANY

-- 23/ Display the names of students with grades in any subject.
-- ANS:

SELECT  students.name FROM students 
WHERE EXISTS ( SELECT * FROM grades 
WHERE grades.student_id = students.id);

-- 24/ Display the names of students with a higher grade than any student in the "CE" section.
-- ANS:

SELECT `students`.`name`, `grades`.`grade`
FROM `grades`
INNER JOIN `students` ON `students`.`id` = `grades`.`student_id`
WHERE `grades`.`grade` > ANY (
    SELECT `grades`.`grade`
    FROM `grades`
    INNER JOIN `students` ON `students`.`id` = `grades`.`student_id`
    WHERE `students`.`branch` = 'CE'
);

-- ////////////////////////////////////////////

-- • UNION, COALESCE, and IFNULL

-- 25/ Create a query that displays student names and professor names in the same column using UNION.
-- ANS:

SELECT `students`.`name` AS name_of_students_and_doctors FROM `students` 
UNION  
SELECT `doctors`.`name` AS name_of_students_and_doctors FROM `doctors`;

-- NOTE !! If you want to show all names, even if they are duplicated, replace UNION with UNION ALL.

-- 26/ Display student names and grades, and if none are present, display "Not Recorded" using COALESCE or IFNULL.
-- ANS:

SELECT `students`.`name`, COALESCE(`grades`.`grade`, 'لم تُرصد') AS grade
FROM `students`
LEFT JOIN `grades` ON `students`.`id` = `grades`.`student_id`;

-- OR by using IFNULL

SELECT `students`.`name`, IFNULL(`grades`.`grade`, 'لم تُرصد') AS grade
FROM `students`
LEFT JOIN `grades` ON `students`.`id` = `grades`.`student_id`;

-- ////////////////////////////////////////////

-- • Views

-- 27/ Create a view named students_grades_view that displays the student's name, subject, and grade.
-- ANS:

CREATE VIEW students_grades_view AS
SELECT 
  students.name AS student_name, 
  subjects.name AS subject_name, 
  grades.grade
FROM students
INNER JOIN grades ON students.id = grades.student_id
INNER JOIN subjects ON subjects.id = grades.subject_id;

-- 28/ Display the data from this view.
-- ANS:

SELECT * FROM students_grades_view;

-- ////////////////////////////////////////////

-- • BONUS | Additional exercise ideas:

-- 29/ Display the student's name and subject, writing "Pass" if the grade is >= 50, and "Fail" if it is less.
-- ANS:

SELECT 
  students_name,
  subject_name,
  grades_of_students,
  CASE 
    WHEN grades_of_students >= 50 THEN 'Pass'
    ELSE 'Fail'
  END AS status_of_pass
FROM students_grades_view;

-- 30/ Edit the grades table and add a semester column.
-- ANS:

ALTER TABLE grades
ADD COLUMN semester VARCHAR(10);

-- Name: Nur Aisyah Bte Abdul Mutalib
-- Matric: U2110399H
-- Class Exercise 4

-- 1.	Which students are enrolled with a first name ‘Ben’? Show their last names, first names, age, and gender. Order by gender, and then age.

select *
from student
where FirstName = 'Ben'
order by Gender, Age;

-- 2.	What are the studentIDs, last names, and first names of the students that have failed at least one course?

select student.StudentID, LastName, FirstName
from student inner join enrollment
on student.StudentID = enrollment.StudentID
where Grade = 'F';

-- 3.	Which students (by studentID) have gotten a grade of ‘D’ or ‘F’ for at least one course?

select student.StudentID, LastName, FirstName
from student inner join enrollment
on student.StudentID = enrollment.StudentID
where Grade = 'D' or Grade = 'F'
order by studentID;

-- 4.	What are the studentIDs, last names and first names of the students who have been taught by John Chua?  Sort the students in alphabetical order by last name.

select student.StudentID, student.LastName, student.FirstName
from student, enrollment, instructor
where student.StudentID = enrollment.StudentID
and enrollment.InstructorID = instructor.InstructorID
and instructor.LastName = 'Chua' and instructor.FirstName = 'John'
order by LastName;
-- Comment: The output given in the question was sorted by StudentID instead of alphabetical order by last name.

-- 5.	How many sections of any course has John Chua taught in Semester 2 2018?

select count(SectionID) as amt_section_john
from section inner join instructor
on section.InstructorID = instructor.InstructorID
where instructor.LastName = 'Chua'
and instructor.FirstName = 'John'
and section.sem = '2';

-- 6.	How many students are taking each section of 8881 taught by Kris Tan in Semester 1 2018?

select count(StudentID) as amt_student
from enrollment, section, instructor
where enrollment.CourseID = section.CourseID
and enrollment.InstructorID = instructor.InstructorID
and section.CourseID = '8881' 
and instructor.LastName = 'Tan'
and instructor.FirstName = 'Kris'
and enrollment.Sem = '1';

-- 7.	Which students (by name) have taken at least three courses from 2017-2018?

select StudentID, LastName, FirstName, Gender, Age
from student
where exists
	(select StudentID,
	count(CourseID)
	from enrollment
	where Year between '2017' and '2018'
	and enrollment.StudentID = student.StudentID
	group by StudentID
	having count(CourseID) >= 3);

-- 8.	Which instructors teach at least 3 sections in Semester 2 2018?

select InstructorID, LastName, FirstName
from instructor
where exists
	(select InstructorID,
	count(SectionID)
	from section
	where Sem = '2'
    and Year = '2018'
	and section.InstructorID = instructor.InstructorID
	group by InstructorID
	having count(SectionID) >= 3);

-- 9.	Which students (by name) have obtained at least 3 ‘A’ grades from 2017-2018?

select StudentID, LastName, FirstName, Gender, Age
from student
where exists
	(select StudentID,
	count(Grade)
	from enrollment
	where Year between 2017 and 2018
	and student.StudentID = enrollment.StudentID
    and Grade = 'A'
	group by StudentID
	having count(Grade) >= 3);

-- 10.	Create a new record for a new course called ‘Advanced Database Development’ (CourseID: 8887).  The course has 4 course credits.

delete from course where CourseID = '9887';

insert into course
values ('8887', 'Advanced Database Development', '4');


-- 11.	[observe the unexpected outcome] Add the instructor “WuShin Yi” with instructor ID 5507.

insert into instructor
values( '5507', 'WuShin', 'Yi');
-- Comment: Error 1062 is observed because there is an existing instructor with the InstructorID 5507 and a duplicate entry is created.

update instructor
set firstname = 'WuShin', lastname = 'Yi'
where InstructorID = '5507';


-- 12.	[observe the unexpected outcome] Add that ‘WuShin Yi’ teaches the section 15 for Advanced Database Development (courseID: 8887) in Semester 1 2018.  

insert into section
values('8887', '1', '2018', '5507', '15');
-- Comment: Error 1452 is observed because some values in the referencing  field of the child table do not exist in the candidate field of the parent table.


-- 13.	[observe the unexpected outcome] The course called ‘Advanced Database Development’ is to be recoded as ‘9887.’ (You can assume that cascade on update is implemented on FKs)

update course set CourseID = 9887 where CourseID = 8887;

-- 14.	The instructor ‘John Chua’ is very generous.  Every student in his class for 2018 Sem 1 is going to get an ‘A.’

update enrollment
set Grade = 'A'
where InstructorID
	= (select InstructorID
	from instructor
	where LastName = 'John'
	and FirstName = 'Chua')
and Sem = '1'
and Year = '2018';

-- 15.	Show all students who are not taking a course in Semester 2 2018.

select StudentID, LastName, FirstName, Gender, Age
from student
where StudentID not in
	(select StudentID
	from enrollment
	where sem = '2'
	and Year = '2018');

-- 16.	Show instructors who have never taught a course.

select InstructorID, LastName, FirstName
from instructor
where InstructorID not in
	(select distinct(InstructorID)
	from section);

-- 17.	Count the number of courses each instructor has ever taught.  Remember, some instructors can teach no classes.

select instructor.InstructorID, LastName, FirstName, ifnull(amt,0)
as course_taught
from instructor
left outer join
(
	select InstructorID, count(distinct CourseID) as amt
	from enrollment
	group by InstructorID
) as T on instructor.InstructorID = T.InstructorID
order by course_taught desc;





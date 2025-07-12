Student Elective Subject Allotment – MySQL Workbench Assignment

📝 Problem Statement.

A college wants to automate the Open Elective Subject Allotment process for students.
Each student provides 5 subject choices (preferences), and allocation is done based on GPA.

Students with the highest GPA get their preferred subject first.
If the preferred subject is full, the next preference is checked.
Students who don’t get any of their 5 choices are marked Unallotted.
🛠️ Database Tables

1. StudentDetails
Column Name	Data Type	Description
StudentId	INT (PK)	Unique student identifier
StudentName	VARCHAR	Student's name
GPA	DECIMAL	GPA of the student
Branch	VARCHAR	Branch of the student
Section	VARCHAR	Section of the student
2. SubjectDetails
Column Name	Data Type	Description
SubjectId	VARCHAR (PK)	Unique subject identifier
SubjectName	VARCHAR	Name of the subject
MaxSeats	INT	Total seats in the subject
RemainingSeats	INT	Available seats
3. StudentPreference
Column Name	Data Type	Description
StudentId	INT (FK)	Reference to StudentDetails
SubjectId	VARCHAR (FK)	Reference to SubjectDetails
Preference	INT	Preference ranking (1 to 5)
4. Allotments
Stores the successful allotments.

Column Name	Data Type
SubjectId	VARCHAR (FK)
StudentId	INT (FK)
5. UnallottedStudents
Stores students who couldn’t be allotted any subject.

Column Name	Data Type
StudentId	INT (FK)
🔍 Task Objectives

Design the tables.
Insert sample data (students, subjects, preferences).
Write a stored procedure AllocateSubjects() that:
Allocates subjects according to GPA and preference.
Updates the remaining seats.
Records unallotted students.
⚙️ How to Run in MySQL Workbench

1. Create the Database
CREATE DATABASE CollegeAllotment;
USE CollegeAllotment;
2. Create Tables
Run the CREATE TABLE statements provided in the SQL script.

3. Insert Sample Data
Run the provided INSERT INTO statements for all tables.

4. Create the Stored Procedure
Run the final version of the AllocateSubjects() procedure.

5. Execute the Procedure
CALL AllocateSubjects();
6. View Results
SELECT * FROM Allotments;
SELECT * FROM UnallottedStudents;
SELECT * FROM SubjectDetails;
🛡️ Notes


Tested on MySQL 8.x.

Prepared by: Prathamesh lad


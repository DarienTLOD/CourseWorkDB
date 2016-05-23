Create Database CourseWorkDB;
Go

use CourseWorkDB;

--Tables that associated with university

Create Table Faculty
(
    [id] int Primary Key Identity(1,1) not null,
	[phone_number] int not null,
	[faculty_name] nvarchar(20) not null,
) 

Create Table Ñathedra
(
    [id] int Primary Key Identity(1,1) not null,
	[cathedra_name] nvarchar(20) not null,
	[phone_number] int not null,
	[faculty_id] int Foreign Key References Faculty(id) not null
) 

Create Table Specialties
(
    [id] int Primary Key not null,
	[specialty_name] nvarchar(20) not null,
	[cathedra_id] int Foreign Key References Ñathedra(id) not null
) 

Create Table Groups
(
    [id] int Primary Key not null,
	[specialty_code] int Foreign Key References Specialties(id) not null,
) 

Create Table Lecturers 
(
    [id] int Primary Key Identity(1,1) not null,
	[lecturer_name] nvarchar(20) not null,
	[lecturer_surname] nvarchar(20) not null,
	[lecturer_second_name] nvarchar(20) not null,
	[phone_number] int not null,
	[position] nvarchar(10) not null,
	[id_curator_of_group] int not null,
	[password] nvarchar(max) not null,
	[cathedra_id] int Foreign Key References Ñathedra(id) not null
) 

Create Table Students
(
    [student_record_book_id] int Primary Key not null,
	[student_name] nvarchar(20) not null,
	[student_surname] nvarchar(20) not null,
	[student_second_name] nvarchar(20) not null,
	[phone_number] int not null,
	[is_praepostor] bit not null, 
	[group_id] int Foreign Key References Groups(id) not null
) 

--Table that is associated with companies providing places for practice

Create Table Companies
(
	[id] int Primary Key Identity(1,1) not null,
	[address] nvarchar(50) not null,
	[company_name] nvarchar(20) not null,
	[phone_number] int not null,
	[head_of_the_practice] nvarchar(50) not null
)

--Table that are associated with places for practice

Create Table Places_for_practice
(
	[id] int Primary Key Identity(1,1) not null,
	[request] nvarchar(500),
	[description] nvarchar(500),
	[date_of_the_beginning] date not null,
	[date_of_the_ending] date not null,
	[company_id] int Foreign Key References Companies(id) not null
)

Create Table Students_at_practice
(
	[id] int Primary Key Identity(1,1) not null,
	[places_for_practice_id] int Foreign Key References Places_for_practice(id) not null,
	[student_id] int Foreign Key References Students(student_record_book_id) not null,
	[curator_Of_practice_id] int Foreign Key References Lecturers(id) not null
)
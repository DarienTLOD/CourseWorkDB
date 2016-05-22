Create Database CourseWorkDB;
Go

use CourseWorkDB;

--Tables that associated with university

Create Table Faculty
(
    [id] int Primary Key Identity(1,1) not null,
	[faculty_name] nvarchar(20) not null,
) 

Create Table Ñathedra
(
    [id] int Primary Key Identity(1,1) not null,
	[cathedra_name] nvarchar(20) not null,
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
    [lecturer_id] int Primary Key Identity(1,1) not null,
	[lecturer_name] nvarchar(20) not null,
	[lecturer_surname] nvarchar(20) not null,
	[lecturer_second_name] nvarchar(20) not null,
	[position] nvarchar(10) not null,
	[id_curator_of_group] int not null,
	[cathedra_id] int Foreign Key References Ñathedra(id) not null
) 

Create Table Students
(
    [student_record_book_id] int Primary Key not null,
	[student_name] nvarchar(20) not null,
	[student_surname] nvarchar(20) not null,
	[student_second_name] nvarchar(20) not null,
	[is_praepostor] bit not null, 
	[group_id] int Foreign Key References Groups(id) not null
) 
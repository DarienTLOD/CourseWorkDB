Create Database CourseWorkDb;
Go

use CourseWorkDB;

--Tables that associated with university

Create Table Faculty
(
    [id] int Primary Key Identity(1,1) not null,
	[phone_number] int not null,
	[faculty_name] nvarchar(20) not null,
) 

Create Table Cathedra
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
	[cathedra_id] int Foreign Key References Cathedra(id) not null
) 

Create Table Groups
(
    [id] int Primary Key not null,
	[specialty_code] int Foreign Key References Specialties(id) not null,
) 

Create Table Positions_of_lectureres
(
	[id] int Primary Key Identity(1,1) not null,
	[name_position] nvarchar(50) not null
)

Create Table Lecturers 
(
    [id] int Primary Key Identity(1,1) not null,
	[lecturer_name] nvarchar(20) not null,
	[lecturer_surname] nvarchar(20) not null,
	[lecturer_second_name] nvarchar(20) not null,
	[login] nvarchar(50) not null,
	[password] nvarchar(max) not null,
	[phone_number] int not null,
	[position_id] int Foreign Key References Positions_of_lectureres(id) not null,
	[id_curator_of_group] int not null,
	[cathedra_id] int Foreign Key References Cathedra(id) not null
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

--Table for the separation of user rights

Create Table Admins 
(
	[id] int Primary Key Identity(1,1) not null,
	[login] nvarchar(50) not null,
	[password] nvarchar(max) not null
)

--Login and user creation
If not Exists (select name from master.dbo.syslogins 
               where name = 'CourseworkDBUser')
Begin
    Create Login CourseworkDBUser With Password = '1234567890';
End
Create User CourseworkDBUser For Login CourseworkDBUser;

--Grant permissions to created user
Grant Insert, Select, Update, Delete On Faculty To CourseworkDBUser;
Grant Insert, Select, Update, Delete On Cathedra To CourseworkDBUser;
Grant Insert, Select, Update, Delete On Specialties To CourseworkDBUser;
Grant Insert, Select, Update, Delete On Groups To CourseworkDBUser;
Grant Insert, Select, Update, Delete On Positions_of_lectureres To CourseworkDBUser;
Grant Insert, Select, Update, Delete On Lecturers To CourseworkDBUser;
Grant Insert, Select, Update, Delete On Students To CourseworkDBUser;
Grant Insert, Select, Update, Delete On Companies To CourseworkDBUser;
Grant Insert, Select, Update, Delete On Places_for_practice To CourseworkDBUser;
Grant Insert, Select, Update, Delete On Students_at_practice To CourseworkDBUser;
Grant Insert, Select, Update, Delete On Admins To CourseworkDBUser;
Grant Execute To CourseworkDBUser;
Go
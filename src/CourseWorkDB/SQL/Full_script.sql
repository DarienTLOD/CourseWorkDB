Create Database CourseWorkDb;
Go

use CourseWorkDB;

--Tables that associated with university

Create Table Faculties
(
    [Id] int Primary Key Identity(1,1) not null,
	[Phone_Number] int not null,
	[Faculty_Name] nvarchar(20) not null,
) 

Create Table Cathedrals
(
    [Id] int Primary Key Identity(1,1) not null,
	[Phone_Number] int not null,
	[Cathedra_Name] nvarchar(20) not null,
	[Faculty_Id] int Foreign Key References Faculties(Id) not null
) 

Create Table Specialties
(
    [Id] int Primary Key not null,
	[Specialty_Name] nvarchar(20) not null,
	[Cathedra_Id] int Foreign Key References Cathedrals(Id) not null
) 

Create Table Groups
(
    [Id] int Primary Key not null,
	[Specialty_Code] int Foreign Key References Specialties(Id) not null,
) 

Create Table Positions_Of_Lectureres
(
	[Id] int Primary Key Identity(1,1) not null,
	[Name_Position] nvarchar(50) not null
)

Create Table Lecturers 
(
    [Id] int Primary Key Identity(1,1) not null,
	[Lecturer_Name] nvarchar(20) not null,
	[Lecturer_Surname] nvarchar(20) not null,
	[Lecturer_Second_Name] nvarchar(20) not null,
	[Login] nvarchar(50) not null,
	[Password] nvarchar(max) not null,
	[Phone_Number] int not null,
	[Position_Id] int Foreign Key References Positions_Of_Lectureres(Id) not null,
	[Id_Curator_Of_Group] int not null,
	[Cathedra_Id] int Foreign Key References Cathedrals(Id) not null
) 

Create Table Students
(
    [Student_Record_Book_Id] int Primary Key not null,
	[Student_Name] nvarchar(20) not null,
	[Student_Surname] nvarchar(20) not null,
	[Student_Second_Name] nvarchar(20) not null,
	[Phone_Number] int not null,
	[Is_Praepostor] bit not null, 
	[Group_Id] int Foreign Key References Groups(Id) not null
) 

--Table that is associated with companies providing places for practice

Create Table Companies
(
	[Id] int Primary Key Identity(1,1) not null,
	[Address] nvarchar(50) not null,
	[Company_Name] nvarchar(20) not null,
	[Phone_Number] int not null,
	[Head_Of_The_Practice] nvarchar(50) not null
)

--Table that are associated with places for practice

Create Table Places_For_Practice
(
	[Id] int Primary Key Identity(1,1) not null,
	[Request] nvarchar(500),
	[Description] nvarchar(500),
	[Date_Of_The_Beginning] date not null,
	[Date_Of_The_Ending] date not null,
	[Company_Id] int Foreign Key References Companies(Id) not null
)

Create Table Students_At_Practice
(
	[Id] int Primary Key Identity(1,1) not null,
	[Places_For_Practice_Id] int Foreign Key References Places_For_Practice(Id) not null,
	[Student_Id] int Foreign Key References Students(Student_Record_Book_Id) not null,
	[Curator_Of_Practice_Id] int Foreign Key References Lecturers(Id) not null
)

--Table for the separation of user rights

Create Table Admins 
(
	[Id] int Primary Key Identity(1,1) not null,
	[login] nvarchar(50) not null,
	[password] nvarchar(max) not null
)

--Login and user creation
If not Exists (select Name from master.dbo.syslogins 
               where Name = 'CourseworkDBUser')
Begin
    Create Login CourseworkDBUser With Password = '1234567890';
End
Create User CourseworkDBUser For Login CourseworkDBUser;

--Grant permissions to created user
Grant Insert, Select, Update, Delete On Faculties To CourseworkDBUser;
Grant Insert, Select, Update, Delete On Cathedrals To CourseworkDBUser;
Grant Insert, Select, Update, Delete On Specialties To CourseworkDBUser;
Grant Insert, Select, Update, Delete On Groups To CourseworkDBUser;
Grant Insert, Select, Update, Delete On Positions_Ff_Lectureres To CourseworkDBUser;
Grant Insert, Select, Update, Delete On Lecturers To CourseworkDBUser;
Grant Insert, Select, Update, Delete On Students To CourseworkDBUser;
Grant Insert, Select, Update, Delete On Companies To CourseworkDBUser;
Grant Insert, Select, Update, Delete On Places_For_Practice To CourseworkDBUser;
Grant Insert, Select, Update, Delete On Students_At_Practice To CourseworkDBUser;
Grant Insert, Select, Update, Delete On Admins To CourseworkDBUser;
Grant Execute To CourseworkDBUser;
Go

--Procedures for creating entities

---------------Faculty---------------

Create Procedure CreateFaculty
    @Phone_Number int, 
    @Faculty_Name nvarchar(20)
As
Begin
    Set Nocount On;
    Insert Into Faculties Values (@Phone_Number, @Faculty_Name);
End
Go

Create Procedure UpdateFaculty
    @Faculty_Id int,
    @Phone_Number int, 
    @Faculty_Name nvarchar(20)
As
Begin
    Set Nocount On;
    Update Faculties
    Set Phone_Number = @Phone_Number,  Faculty_Name = @Faculty_Name
    Where Id = @Faculty_Id;	
End
Go	

Create Procedure DeleteFaculty
   @Faculty_Id int
As
Begin
    Set Nocount On;
    Delete From Faculties Where Id = @Faculty_Id;  
End
Go

Create Function GetFaculties()	
Returns Table
As 
Return
(
    Select Phone_Number, Faculty_Name From Faculties
)
Go

-----------End Faculty---------------
------------Cathedrals---------------

Create Procedure CreateCathedra
    @Phone_Number int, 
    @Cathedra_Name nvarchar(20),
	@Faculty_Id int
As
Begin
    Set Nocount On;
    Insert Into Cathedra Values (@Phone_Number, @Cathedra_Name, @Faculty_Id);
End
Go

Create Procedure UpdateCathedra
	@Cathedra_Id int,
    @Phone_Number int, 
    @Cathedra_Name nvarchar(20),
	@Faculty_Id int
As
Begin
    Set Nocount On;
    Update Cathedrals
    Set Phone_Number = @Phone_Number,  Cathedra_Name = @Cathedra_Name, Faculty_Id = @Faculty_Id
    Where Id = @Cathedra_Id;	
End
Go	

Create Procedure DeleteCathedra
   @Cathedra_Id int
As
Begin
    Set Nocount On;
    Delete From Cathedrals Where Id = @Cathedra_Id;  
End
Go

Create Function GetCathedrals()	
Returns Table
As 
Return
(
    Select Phone_Number, Cathedra_Name, (Select Faculty_Name From Faculties where Cathedrals.Faculty_Id = Faculties.Id) as Faculty_Name  From Cathedrals
)
Go

--------End Cathedrals---------------
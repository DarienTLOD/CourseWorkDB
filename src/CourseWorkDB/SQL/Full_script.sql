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
    [Id] int Primary Key Identity(1,1) not null,
    [Specialty_Code] int not null,
	[Specialty_Name] nvarchar(20) not null,
	[Cathedra_Id] int Foreign Key References Cathedrals(Id) not null
) 

Create Table Groups
(
    [Id] int Primary Key Identity(1,1) not null,
	[Group_Code] int not null,
	[Specialty_Id] int Foreign Key References Specialties(Id) not null
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
Grant Insert, Select, Update, Delete On Positions_Of_Lectureres To CourseworkDBUser;
Grant Insert, Select, Update, Delete On Lecturers To CourseworkDBUser;
Grant Insert, Select, Update, Delete On Students To CourseworkDBUser;
Grant Insert, Select, Update, Delete On Companies To CourseworkDBUser;
Grant Insert, Select, Update, Delete On Places_For_Practice To CourseworkDBUser;
Grant Insert, Select, Update, Delete On Students_At_Practice To CourseworkDBUser;
Grant Insert, Select, Update, Delete On Admins To CourseworkDBUser;
Grant Execute To CourseworkDBUser;
Go

--Procedures for creating entities

---------------Faculties---------------

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

-----------End Faculties---------------

------------Cathedrals---------------

Create Function GetFacultyIdByName
(
 @Faculty_Name nvarchar(20)
)	
Returns int
As 
begin
	DECLARE @result  int
	Select @result =  Id From Faculties Where Faculties.Faculty_Name = @Faculty_Name
	Return @result
end
Go

Create Function GetFacultyNameById
(
 @Faculty_Id int
)	
Returns nvarchar(20)
As 
begin
	DECLARE @result  nvarchar(20)
	Select @result =  Faculty_Name From Faculties Where Faculties.Id = @Faculty_Id
	Return @result
end
Go

Create Procedure CreateCathedra
    @Phone_Number int, 
    @Cathedra_Name nvarchar(20),
	@Faculty_Name nvarchar(20)
As
Begin
    Set Nocount On;
    Insert Into Cathedra Values (@Phone_Number, @Cathedra_Name, (Select dbo.GetFacultyIdByName(@Faculty_Name)));
End
Go

Create Procedure UpdateCathedra
	@Cathedra_Id int,
    @Phone_Number int, 
    @Cathedra_Name nvarchar(20),
	@Faculty_Name nvarchar(20)
As
Begin
    Set Nocount On;
    Update Cathedrals
    Set Phone_Number = @Phone_Number,  Cathedra_Name = @Cathedra_Name, Faculty_Id = (Select dbo.GetFacultyIdByName(@Faculty_Name))
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
    Select Phone_Number, Cathedra_Name, (Select dbo.GetFacultyNameById(Faculty_Id)) as Faculty_Name  From Cathedrals
)
Go

--------End Cathedrals---------------

------------Specialties---------------

Create Function GetCathedralIdByName
(
 @Cathedra_Name nvarchar(20)
)	
Returns int
As 
begin
	DECLARE @result  int
	Select @result =  Id From Cathedrals Where Cathedrals.Cathedra_Name = @Cathedra_Name
	Return @result
end
Go

Create Function GetCathedralNameById
(
 @Cathedra_Id int
)	
Returns nvarchar(20)
As 
begin
	DECLARE @result  nvarchar(20)
	Select @result =  Cathedra_Name From Cathedrals Where Cathedrals.Id = @Cathedra_Id
	Return @result
end
Go

Create Procedure CreateSpecialty
    @Specialty_Code int, 
    @Specialty_Name nvarchar(20),
	@Cathedra_Name nvarchar(20)
As
Begin
    Set Nocount On;
    Insert Into Specialties Values (@Specialty_Code, @Specialty_Name, (select dbo.GetCathedralsIdByName(@Cathedra_Name)));
End
Go

Create Procedure UpdateSpecialty
	@Specialty_Id int, 
	@Specialty_Code int, 
	@Specialty_Name nvarchar(20),
	@Cathedra_Name nvarchar(20)
As
Begin
    Set Nocount On;
    Update Specialties
    Set Specialty_Name = @Specialty_Name, Cathedra_Id = (select dbo.GetCathedralsIdByName(@Cathedra_Name))
    Where Id = @Specialty_Id;	
End
Go	

Create Procedure DeleteSpecialty
   @Specialty_Id int
As
Begin
    Set Nocount On;
    Delete From Specialties Where Id = @Specialty_Id;  
End
Go

Create Function GetSpecialties()	
Returns Table
As 
Return
(
    Select Id, Specialty_Name, (select dbo.GetCathedralNameById(Cathedra_Id)) as Cathedra_Name  From Specialties
)
Go

--------End Specialties---------------

--------------Groups------------------

Create Function GetSpecialtyCodeById
(
	@Specialty_Id int
)	
Returns int
As 
begin
	DECLARE @result  int
	Select @result =  Specialty_Code From Specialties Where Specialties.Id = @Specialty_Id
	Return @result
end
Go

Create Function GetSpecialtyIdByCode
(
	@Specialty_Code int
)	
Returns int
As 
begin
	DECLARE @result  int
	Select @result =  Id From Specialties Where Specialties.Specialty_Code = @Specialty_Code
	Return @result
end
Go

Create Procedure CreateGroup
    @Group_Code int, 
    @Specialty_Code int
As
Begin
    Set Nocount On;
    Insert Into Groups Values (@Group_Code, (select dbo.GetSpecialtyIdByCode(@Specialty_Code)));
End
Go

Create Procedure UpdateGroup
	@Group_Id int,
	@Group_Code int, 
    @Specialty_Code int
As
Begin
    Set Nocount On;
    Update Groups
    Set Group_Code = @Group_Code, Specialty_Id = (select dbo.GetSpecialtyIdByCode(@Specialty_Code))
    Where Id = @Group_Id;	
End
Go	

Create Procedure DeleteGroup
   @Group_Id int
As
Begin
    Set Nocount On;
    Delete From Groups Where Id = @Group_Id;  
End
Go

Create Function GetGroups()	
Returns Table
As 
Return
(
    Select Id, Group_Code, (select dbo.GetSpecialtyCodeById(Specialty_Id)) as Specialty_Code  From Groups
)
Go

--------End Groups---------------

--------------Positions_Of_Lectureres------------------

Create Procedure CreatePositionOfLectureres
    @Name_Position nvarchar(50)
As
Begin
    Set Nocount On;
    Insert Into Positions_Of_Lectureres Values (@Name_Position);
End
Go

Create Procedure UpdatePositionOfLectureres
	@Position_Id int,
	@Name_Position nvarchar(50)
As
Begin
    Set Nocount On;
    Update Positions_Of_Lectureres
    Set Name_Position = @Name_Position 
    Where Id = @Position_Id;	
End
Go	

Create Procedure DeletePositionOfLectureres
   @Position_Id int
As
Begin
    Set Nocount On;
    Delete From Positions_Of_Lectureres Where Id = @Position_Id;  
End
Go

Create Function GetPositionsOfLectureres()	
Returns Table
As 
Return
(
    Select Id, Name_Position From Positions_Of_Lectureres
)
Go

--------End Positions_Of_Lectureres---------------
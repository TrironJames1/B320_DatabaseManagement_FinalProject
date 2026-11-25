/*
	Developer: Dessaure, Terrance
	Course:		B320
	Assignment: Final Project

*/


-- Dropping tables if they exist.
-- Child tables (the ones holding foreign keys) are dropped first,
-- otherwise SQL Server refuses to drop a table another table still points to.
DROP TABLE IF EXISTS CourseBillingLineItems;
DROP TABLE IF EXISTS Enrollments;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS CourseOfferings;
DROP TABLE IF EXISTS DegreeProgramPlans;
DROP TABLE IF EXISTS Professors;
DROP TABLE IF EXISTS Prereqs;
DROP TABLE IF EXISTS Classifications;
DROP TABLE IF EXISTS Restrictions;
DROP TABLE IF EXISTS [Degrees];
DROP TABLE IF EXISTS MeetingTypes;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS StudentTerms;
DROP TABLE IF EXISTS Locations;
DROP TABLE IF EXISTS Departments;
GO

-- Imported source data
SELECT *
FROM [USCB Course Offerings - 11.4.26];

SELECT *
FROM [USCB Course Catalog - 11.4.26];


SELECT *
FROM VendorCopy;
GO

/*
   Create look up tables first (the ones without foriegn keys)
 */

-- Terrance
CREATE TABLE Departments (
	DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
	DepartmentDescription VARCHAR(MAX)
);
GO

-- TRIRON
CREATE TABLE Locations (
	LocationID INT IDENTITY(1,1) PRIMARY KEY,
	CollegeDescription VARCHAR(MAX),
	BuildingDescription VARCHAR(MAX),
	RoomNum VARCHAR(50)
);
GO

-- TRIRON
CREATE TABLE StudentTerms (		-- Deleted Date due to the column Academic_Period_Desc within the CourseOfferings table 
-- offering both the term and the year of the term
-- Instead of the date will just input the Academic_Period_Desc into the Desction for the table
	TermID INT IDENTITY(1,1) PRIMARY KEY,
	Description VARCHAR(MAX)
);
GO

-- TRIRON
CREATE TABLE Courses (
	CourseID INT IDENTITY(1,1) PRIMARY KEY,
	CourseTitle VARCHAR(50),
	CourseDescription VARCHAR(MAX),
	CreditMin INT,
	CreditMax INT
);
GO

-- Terrance
CREATE TABLE MeetingTypes (
	MeetingTypeID INT IDENTITY(1,1) PRIMARY KEY,
	MeetingTypeDescription VARCHAR(MAX)
);
GO

-- TRIRON
CREATE TABLE [Degrees] (
	DegreeID INT IDENTITY(1,1) PRIMARY KEY,
	DegreeDescription VARCHAR(MAX)
);
GO

-- Terrance
CREATE TABLE Restrictions (
	RestrictionID INT IDENTITY(1,1) PRIMARY KEY,
	RestrictionDescription VARCHAR(MAX)
);
GO

-- Terrance
CREATE TABLE Classifications (
	ClassificationID INT IDENTITY(1,1) PRIMARY KEY,
	StudentClassificationDescription VARCHAR(MAX),
	StudentType VARCHAR(MAX)
);
GO

-- Terrance
CREATE TABLE Prereqs (
	PrereqID INT IDENTITY(1,1) PRIMARY KEY,
	PrereqDescription VARCHAR(MAX)
);
GO

/* 
Tables with foreign keys need to created after their parents
*/

-- TRIRON
CREATE TABLE Professors (
	ProfessorID INT IDENTITY(1,1) PRIMARY KEY,
	FullName VARCHAR(50),
	DepartmentID INT NOT NULL,

	CONSTRAINT FK_Professors_DepartmentID
	FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);
GO



-- TRIRON
CREATE TABLE CourseOfferings (
	CourseOfferingID INT IDENTITY(1,1) PRIMARY KEY,
	CourseID INT NOT NULL,
	Term             VARCHAR(50),
    Professor        VARCHAR(100),
    [Subject]        VARCHAR(20),
    CourseNumber     VARCHAR(20),
    Section          VARCHAR(20),
    Title            VARCHAR(200),
    Credits          VARCHAR(10),
    MeetingTypeDesc  VARCHAR(50),
    [Days]           VARCHAR(20),
    [Time]           VARCHAR(50),
    LocationID       INT NULL,

    CONSTRAINT FK_CourseOfferings_CourseID
        FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    CONSTRAINT FK_CourseOfferings_LocationID
        FOREIGN KEY (LocationID) REFERENCES Locations(LocationID)
);
GO



-- TRIRON
-- EnrollmentID removed: Enrollments already stores StudentID, so having
-- Students point back at Enrollments made a circular reference.
CREATE TABLE Students (
	StudentID INT IDENTITY(1,1) PRIMARY KEY,
	USCBID VARCHAR(20) NOT NULL,
	FirstName VARCHAR(50),
	LastName VARCHAR(50),
	StudentClassificationID INT NOT NULL,
	DegreeID INT,          
	Major VARCHAR(MAX),
	Minor VARCHAR(MAX),
	Concentration VARCHAR(MAX),
	RestrictionID INT,         

	CONSTRAINT FK_Students_RestrictionID
	FOREIGN KEY (RestrictionID) REFERENCES Restrictions(RestrictionID),

	CONSTRAINT FK_Students_DegreeID
	FOREIGN KEY (DegreeID) REFERENCES [Degrees](DegreeID),

	CONSTRAINT FK_Students_StudentClassificationID   
	FOREIGN KEY (StudentClassificationID) REFERENCES Classifications(ClassificationID),
);
GO



-- TRIRON
-- Making the assumption that all students financial responsibilities to the school are taken car of
CREATE TABLE Enrollments (
    EnrollmentID     INT IDENTITY(1,1) PRIMARY KEY,
    StudentID        INT NOT NULL,
    CourseOfferingID INT NOT NULL,

    CONSTRAINT UQ_Enrollments_Student_Course
        UNIQUE (StudentID, CourseOfferingID),

    CONSTRAINT FK_Enrollments_StudentID
        FOREIGN KEY (StudentID) REFERENCES Students(StudentID),

    CONSTRAINT FK_Enrollments_CourseOfferingID
        FOREIGN KEY (CourseOfferingID) REFERENCES CourseOfferings(CourseOfferingID)
);
GO

-- Data Scrubbing

-- Course offering start at column "Title"

-- Terrance Course Catalog Responsibility:

-- Prereq_Waiver_Authorization_Type, Prereq_Waiver_Authorization_Type_Description, Tuition_Fee_Exempt
-- Additional_Fees_Indicator, Prereq_Check_Method, Course_Coreq_Count, Corequisite_Text, Course_Fee
-- Course_Area_Restrictions, Course_Department_Restrictions, Course_Major_Minor_Concentrations_Restrictions, Course_Class_Restrictions
-- Course_Level_Restrictions, Course_Degree_Restrictions, Course_Program_Restrictions
-- Course_Campus_Restrictions, Course_College_Restrictions, Course_Std_Attribute_Restrictions, Course_Cohort_Restrictions

SELECT *
FROM [USCB Course Offerings - 11.4.26];


/* ================================================
				Data cleaning
=================================================== */



ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN IF EXISTS Prereq_Waiver_Authorization_Type

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN IF EXISTS Prereq_Waiver_Authorization_Type_Description

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN IF EXISTS Additioal_Fees_Indicator

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN IF EXISTS Prereq_Check_Method

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN IF EXISTS Course_Coreq_Count

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN IF EXISTS Corequisite_Text

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN IF EXISTS Course_Fee

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN IF EXISTS Course_Area_restrictions

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN IF EXISTS Course_Major_Minor_Concentrations_Restrictions

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN IF EXISTS Course_Class_Restrictions

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN IF EXISTS Couse_Level_Restrictions

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN IF EXISTS Course_Degree_Restrictions

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN IF EXISTS Course_Program_Restrictions

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN IF EXISTS Course_Campus_Restrictions

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN IF EXISTS Course_College_Restrictions

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN IF EXISTS Course_Std_Attribute_Restrictions

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN IF EXISTS Course_Cohort_Restrictions

-- Added Thursday November 19, 2027: 10:30 AM
ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN IF EXISTS Tuition_Fee_Exempt

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN IF EXISTS Additional_Fees_Indicator

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN IF EXISTS Other_Minimum

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN IF EXISTS Other_Maximum

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN IF EXISTS Other_Indicator

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN IF EXISTS Credit_Indicator


/* ====================================
	     COURSE OFFERINGS TABLE
======================================= */

SELECT *
FROM [USCB Course Offerings - 11.4.26];

ALTER TABLE [USCB Course Offerings - 11.4.26]
DROP COLUMN IF EXISTS Class_Status_TBA

ALTER TABLE [USCB Course Offerings - 11.4.26]
DROP COLUMN IF EXISTS Course_Text_Narrative



/* ====================================================
		Checking data with a lot of Null Values
=======================================================*/

-- Instrutional_Method only list face to face
SELECT Instructional_Method
FROM [USCB Course Catalog - 11.4.26]
WHERE Instructional_Method IS NOT NULL;

-- Maximum_Credit does have place where the credits are 4, 6, and 9
-- Should we get rid of the Maximum_Credit if we are goint to be giving the student the credits by hand
SELECT Title_Short_Description, Maximum_Credit
FROM [USCB Course Catalog - 11.4.26]
WHERE Maximum_Credit IS NOT NULL



/* =============================================
		     Tables to populate
============================================== */ 


-- Look up tables
SELECT *
FROM [USCB Course Catalog - 11.4.26]

SELECT *
FROM [USCB Course Offerings - 11.4.26];
-- Look up tables



-- Needs DepartmentID (Department ID does not need to be inserted because it is a primary key)
-- DepartmentDescription
-- Notes: We might want to get rid of Dept and keep in Department_Description

SELECT *
FROM Departments

/* ==================================
		Departments insert
===================================== */
INSERT INTO Departments (
	DepartmentDescription
)

SELECT DISTINCT Department_Description
FROM [USCB Course Catalog - 11.4.26]
/* ==================================
		Departments insert
===================================== */

DELETE FROM Departments
WHERE DepartmentID NOT IN (
	SELECT MIN(DepartmentID)
	FROM Departments
	GROUP BY DepartmentDescription
);

-- Note: we have a table called MeetingTypes but there is nothing in the data that
-- has Hybrid or Asynchronous it is all just in person so this table might not 
-- be needed.

-- MeetingTypes
-- Two different meeting tpyes (class and exam)

SELECT  DISTINCT MEETING_TYPE_DESC
FROM [USCB Course Offerings - 11.4.26]
WHERE MEETING_TYPE_DESC IS NOT NULL;


SELECT Professor, [Subject], Course, Section, Title, MEETING_TYPE_DESC
FROM [USCB Course Offerings - 11.4.26]
WHERE MEETING_TYPE_DESC IS NULL;

SELECT *
FROM [USCB Course Offerings - 11.4.26]
WHERE MEETING_TYPE_DESC IS NULL;

-- The is some data in the USCB course offfering that has "USCB Dummy course not offered"
-- We'll want to get rid of thats and there is also an "EB Test of Waitlisting" we are going to get rid of that aswell

DELETE FROM [USCB Course Offerings - 11.4.26]
WHERE MEETING_TYPE_DESC IS NULL
	AND (Title LIKE '%dummy%' OR Title LIKE '%test%');

/* ========================================
			MeetingTypes Insert
===========================================*/

INSERT INTO MeetingTypes (
	MeetingTypeDescription
)

SELECT DISTINCT MEETING_TYPE_DESC
FROM [USCB Course Offerings - 11.4.26]

/* =======================================
			MeetingTypes Insert
==========================================*/

-- look up meeting types
SELECT *
FROM MeetingTypes


/* ==================================
		Restrictions insert
===================================== */

INSERT INTO Restrictions(
	RestrictionDescription
)

SELECT Course_Major_Minor_Concentration_Restrictions
FROM [USCB Course Catalog - 11.4.26]
WHERE Course_Major_Minor_Concentration_Restrictions is not null 

UNION

SELECT Course_Level_Restrictions
FROM [USCB Course Catalog - 11.4.26]
WHERE Course_Level_Restrictions is not null 

/* ==================================
		Restrictions insert
===================================== */

SELECT *
FROM Restrictions


-- GET RID OF DEPARTMENT_RESTIONCTION BECAUSE EVERYTHING IS NULL
Select Course_Department_Restrictions
FROM [USCB Course Catalog - 11.4.26]
WHERE Course_Department_Restrictions IS NOT NULL


/* ============================================================
					Classifications insert 
=============================================================== */

INSERT INTO Classifications (StudentClassificationDescription)
VALUES ('Incoming'), ('Freshman'), ('Sophomore'), ('Junoir'), ('Senior');

-- In final version just make sure to add Alumni in the first insert statement
INSERT INTO Classifications (StudentClassificationDescription)
VALUES ('Alumni');

/* ============================================================
					Classifications insert 
=============================================================== */
SELECT *
FROM Classifications

-- ClassificationID
-- StudentClassificationDescription
-- StudentType 



/* ============================================================
		             Prereqs Insert
=============================================================== */

-- In the course description there is are a mixture of course descritpion and prereq
-- Problem: Prereq are combined with course description
-- Procedure: Separate the prereq from the course description and save the prereq into the prereq descrition

SELECT Course_Description
FROM [USCB Course Catalog - 11.4.26] -- 2311 ROWS OF PREREQS

SELECT
    Course_Description,
    SUBSTRING(
        Course_Description,
        CHARINDEX('(', Course_Description) + 1,
        CHARINDEX(')', Course_Description, CHARINDEX('(', Course_Description))
            - CHARINDEX('(', Course_Description) - 1
    ) AS PrereqText
FROM [USCB Course Catalog - 11.4.26]
WHERE Course_Description LIKE '%(%)%';

 -- OPTION 2:
 -- Could we just make the get rid of the prereq table
 -- and just have the course description just hold the 

/* =================================== 
			NEW INFORMATION
=====================================*/ 

-- SUBSTRING  pulls out part of a piece of text, given where to start and how many characters to take.
-- There are three arguements
-- test: the column or string to cut from
-- start: the position of the first character to take (counting starts at 1)
-- length: how many characters to take

-- CHARINDEX: finds the position of a character, so you can start or stop at that character instead of a fixed number

/* =================================== 
		END OF NEW INFORMATION
=====================================*/ 


select *
from [STUDENT_MOCK_DATA]

SELECT *
FROM [Degrees]

SELECT *
FROM Classifications

SELECT *
FROM Students

SELECT *
FROM Locations

/* ===================================
		CourseOfferings
======================================*/
 
INSERT INTO CourseOfferings
    (CourseID, Term, Professor, [Subject], CourseNumber, Section,
     Title, Credits, MeetingTypeDesc, [Days], [Time], LocationID)
SELECT DISTINCT
    c.CourseID, col.ACADEMIC_PERIOD_DESC, col.Professor, col.Subject,
    cc.Course_Number, col.Section, col.Title, col.Credits,
    col.MEETING_TYPE_DESC, col.Days, col.Time,
    l.LocationID
FROM [USCB Course Offerings - 11.4.26] AS col
INNER JOIN Courses AS c ON col.Title = c.CourseTitle
INNER JOIN [USCB Course Catalog - 11.4.26] AS cc ON c.CourseTitle = cc.Title_Short_Description
LEFT JOIN Locations AS l
    ON  l.CollegeDescription  = col.CAMPUS_DESC 
    AND l.BuildingDescription = col.Building
    AND l.RoomNum             = col.Room

ALTER TABLE [USCB Course Offerings - 11.4.26]
ADD CourseOfferingID INT IDENTITY(1,1) PRIMARY KEY;

SELECT *
FROM Courses

SELECT *
FROM StudentTerms

SELECT *
FROM Locations

SELECT *
FROM [USCB Course Offerings - 11.4.26]
/* ===================================
		CourseOfferings
======================================*/
SELECT *
FROM CourseOfferings

-- Each CourseOfferings row  should have:
-- A primary key `CourseOfferingID`
-- CourseID
-- ProffesorID
-- CRN 
-- MeetingType
-- LocationID (Tell where the class is located)
-- What term is this course in
SELECT *
FROM StudentTerms

ALTER TABLE StudentTerms
DROP COLUMN IF EXISTS [Date]

SELECT *
FROM [USCB Course Offerings - 11.4.26]
/* =================================== 
			Professors
=====================================*/ 
INSERT INTO Professors (FirstName, LastName)
SELECT DISTINCT
    LTRIM(RTRIM(SUBSTRING(Professor, CHARINDEX(',', Professor) + 1, LEN(Professor)))),
    LTRIM(RTRIM(LEFT(Professor, CHARINDEX(',', Professor) - 1)))
FROM [USCB Course Offerings - 11.4.26] 
WHERE Professor LIKE '%,%';

/* =================================== 
			Professors
=====================================*/ 
-- I believe we should leave out the CRN and the Department Id because if we realy want to include the CRN we can and
-- we dont need a department for the professor because can figure out the department from the Courses table.

SELECT
    Professor,
    LEFT(Professor, CHARINDEX(' ', Professor) - 1) AS FirstName,
    SUBSTRING(Professor, CHARINDEX(' ', Professor) + 1, LEN(Professor)) AS LastName

FROM [USCB Course Offerings - 11.4.26]
WHERE Professor LIKE '% %';

SELECT *
FROM Professors

SELECT *
FROM Departments

SELECT *
FROM [USCB Course Offerings - 11.4.26]

SELECT *
FROM [USCB Course Catalog - 11.4.26]

SELECT *
FROM Courses


/* =================================== 
			Enrollments
=====================================*/ 



/* =================================== 
			Enrollments
=====================================*/ 
-- EnrollemntID, PK
-- StudentID,FK
-- CourseOfferingID, FK
-- Grade
-- RestrictionID, FK

SELECT *
FROM Enrollments
/* =================================== 
		1ST YEAR STUDENT INSERT
=====================================*/ 

SELECT TOP 10 *
FROM STUDENT_MOCK_DATA

SELECT *
FROM Students


INSERT INTO Students (USCBID, FirstName, LastName)
SELECT USCB_ID, first_name, last_name
FROM STUDENT_MOCK_DATA
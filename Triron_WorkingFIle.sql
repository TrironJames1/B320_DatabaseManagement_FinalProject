/*
	Developer:	James, Triron & Terrance Dessaure
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


/* 
Tables with foreign keys need to created after their parents
*/

-- TRIRON
CREATE TABLE Professors (
	ProfessorID INT IDENTITY(1,1) PRIMARY KEY,
	FullName VARCHAR(50)

);
GO


-- TRIRON
CREATE TABLE CourseOfferings (
	CourseOfferingID INT IDENTITY(1,1) PRIMARY KEY,
	CourseID INT NOT NULL,
	ProfessorID INT NOT NULL,
	CRN VARCHAR(50),
	MeetingTypeID INT NOT NULL,
	LocationID INT NOT NULL,
	TermID INT NOT NULL,
	

	CONSTRAINT FK_CourseOfferings_CourseID
	FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),

	CONSTRAINT FK_CourseOfferings_ProfessorID
	FOREIGN KEY (ProfessorID) REFERENCES Professors(ProfessorID),

	CONSTRAINT FK_CourseOfferings_MeetingTypeID
	FOREIGN KEY (MeetingTypeID) REFERENCES MeetingTypes(MeetingTypeID),

	CONSTRAINT FK_CourseOfferings_LocationID
	FOREIGN KEY (LocationID) REFERENCES Locations(LocationID),

	CONSTRAINT FK_CourseOfferings_TermID
	FOREIGN KEY (TermID) REFERENCES StudentTerms(TermID)
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
	RestrictionID INT,           -- was VARCHAR(MAX); must match Restrictions.RestrictionID (INT)
	DegreeID INT,                -- was VARCHAR(MAX); must match Degrees.DegreeID (INT)
	ClassificationID INT,
	Major VARCHAR(50),
	Minor VARCHAR(50),
	Concentration VARCHAR(50)
	

	CONSTRAINT FK_Students_RestrictionID
	FOREIGN KEY (RestrictionID) REFERENCES Restrictions(RestrictionID),

	CONSTRAINT FK_Students_DegreeID
	FOREIGN KEY (DegreeID) REFERENCES [Degrees](DegreeID),

	CONSTRAINT FK_Students_ClassificationID
	FOREIGN KEY (ClassificationID) REFERENCES Classifications(ClassificationID),

	
);
GO



-- TRIRON
-- Making the assumption that all students financial responsibilities to the school are taken car of
CREATE TABLE Enrollments ( -- Got rid of CourseBillingLineItems and input that information here
	EnrollmentID INT IDENTITY(1,1) PRIMARY KEY,
	StudentID INT,
	CourseOfferingID INT NOT NULL,
	Grade VARCHAR(20),
	RestrictionID INT,
	CreditHours INT,
	CourseID INT  -- Added course ID instead of CRN

	CONSTRAINT FK_Enrollments_StudentID
	FOREIGN KEY (StudentID) REFERENCES Students(StudentID),

	CONSTRAINT FK_Enrollments_CourseOfferingID
	FOREIGN KEY (CourseOfferingID) REFERENCES CourseOfferings(CourseOfferingID),

	CONSTRAINT FK_Enrollments_RestrictionID
	FOREIGN KEY (RestrictionID) REFERENCES Restrictions(RestrictionID),

	CONSTRAINT FK_Enrollments_CourseID
	FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);
GO


/* ========================================================
						Data Scrubbing
 ============================================================ */
/*
-- Course Catalog Table Deletions
-- getting rid of:
-- Minimum_Billing, Maximum_Billing, Billing_Indicator
-- Maximum_Contact, Contact_Indicator, Minimum_Lecture, Maximum_Lecture
-- Lecture_Indicator, Minimum_Lab, Maximum_Lab, Lab_Indicator
-- More_Text_Narrative, Course_Degree_Attributes, Course_Degree_Attribute_Count
-- No_Of_Repeats_Allowed, Maximum_Repeat_Credits, Repeat_Status_Code, Repeat_Status_Description
-- Prereq_Waiver_Authorization_Type, Prereq_Waiver_Authorization_Type_Description, Tuition_Fee_Exempt
-- Additional_Fees_Indicator, Prereq_Check_Method, Course_Coreq_Count, Corequisite_Text, Course_Fee,
-- Course_Area_Restrictions, Course_Department_Restrictions, Course_Major_Minor_Concentrations_Restrictions, Course_Class_Restrictions
-- Course_Level_Restrictions, Course_Degree_Restrictions, Course_Program_Restrictions,
-- Course_Campus_Restrictions, Course_College_Restrictions, Course_Std_Attribute_Restrictions, Course_Cohort_Restrictions
*/ 
-- TRIRONs Course Catalog Responsibility:
-- Minimum_Billing, Maximum_Billing, Billing_Indicator
-- Maximum_Contact, Contact_Indicator, Minimum_Lecture, Maximum_Lecture
-- Lecture_Indicator, Minimum_Lab, Maximum_Lab, Lab_Indicator
-- More_Text_Narrative, Course_Degree_Attributes, Course_Degree_Attribute_Count
-- No_Of_Repeats_Allowed, Maximum_Repeat_Credits, Repeat_Status_Code, Repeat_Status_Description


-- Terrance Course Catalog Responsibility:
-- Prereq_Waiver_Authorization_Type, Prereq_Waiver_Authorization_Type_Description, Tuition_Fee_Exempt
-- Additional_Fees_Indicator, Prereq_Check_Method, Course_Coreq_Count, Corequisite_Text, Course_Fee
-- Course_Area_Restrictions, Course_Department_Restrictions, Course_Major_Minor_Concentrations_Restrictions, Course_Class_Restrictions
-- Course_Level_Restrictions, Course_Degree_Restrictions, Course_Program_Restrictions
-- Course_Campus_Restrictions, Course_College_Restrictions, Course_Std_Attribute_Restrictions, Course_Cohort_Restrictions

-- [USCB Course Catalog - 11.4.26]

--ALTER TABLE [USCB Course Catalog - 11.4.26]
--DROP COLUMN IF EXISTS Prereq_Waiver_Authorization_Type

--ALTER TABLE [USCB Course Catalog - 11.4.26]
--DROP COLUMN IF EXISTS Prereq_Waiver_Authorization_Type_Description

--ALTER TABLE [USCB Course Catalog - 11.4.26]
--DROP COLUMN IF EXISTS Additioal_Fees_Indicator

--ALTER TABLE [USCB Course Catalog - 11.4.26]
--DROP COLUMN IF EXISTS Prereq_Check_Method

--ALTER TABLE [USCB Course Catalog - 11.4.26]
--DROP COLUMN IF EXISTS Course_Coreq_Count

--ALTER TABLE [USCB Course Catalog - 11.4.26]
--DROP COLUMN IF EXISTS Corequisite_Text

--ALTER TABLE [USCB Course Catalog - 11.4.26]
--DROP COLUMN IF EXISTS Course_Fee

--ALTER TABLE [USCB Course Catalog - 11.4.26]
--DROP COLUMN IF EXISTS Course_Area_restrictions

--ALTER TABLE [USCB Course Catalog - 11.4.26]
--DROP COLUMN IF EXISTS Course_Major_Minor_Concentrations_Restrictions

--ALTER TABLE [USCB Course Catalog - 11.4.26]
--DROP COLUMN IF EXISTS Course_Class_Restrictions

--ALTER TABLE [USCB Course Catalog - 11.4.26]
--DROP COLUMN IF EXISTS Couse_Level_Restrictions

--ALTER TABLE [USCB Course Catalog - 11.4.26]
--DROP COLUMN IF EXISTS Course_Degree_Restrictions

--ALTER TABLE [USCB Course Catalog - 11.4.26]
--DROP COLUMN IF EXISTS Course_Program_Restrictions

--ALTER TABLE [USCB Course Catalog - 11.4.26]
--DROP COLUMN IF EXISTS Course_Campus_Restrictions

--ALTER TABLE [USCB Course Catalog - 11.4.26]
--DROP COLUMN IF EXISTS Course_College_Restrictions

--ALTER TABLE [USCB Course Catalog - 11.4.26]
--DROP COLUMN IF EXISTS Course_Std_Attribute_Restrictions

--ALTER TABLE [USCB Course Catalog - 11.4.26]
--DROP COLUMN IF EXISTS Course_Cohort_Restrictions

--ALTER TABLE [USCB Course Catalog - 11.4.26]
--DROP COLUMN Minimum_Billing;

--ALTER TABLE [USCB Course Catalog - 11.4.26]
--DROP COLUMN Maximum_Billing;

--ALTER TABLE [USCB Course Catalog - 11.4.26]
--DROP COLUMN Billing_Indicator;

--ALTER TABLE [USCB Course Catalog - 11.4.26]
--DROP COLUMN Maximum_Contact; 

--ALTER TABLE [USCB Course Catalog - 11.4.26]
--DROP COLUMN Contact_Indicator;

--ALTER TABLE [USCB Course Catalog - 11.4.26]
--DROP COLUMN Minimum_Lecture;

--ALTER TABLE [USCB Course Catalog - 11.4.26]
--DROP COLUMN Maximum_Lecture;

--ALTER TABLE [USCB Course Catalog - 11.4.26]
--DROP COLUMN Lecture_Indicator; 

--ALTER TABLE [USCB Course Catalog - 11.4.26]
--DROP COLUMN Minimum_Lab;

--ALTER TABLE [USCB Course Catalog - 11.4.26]
--DROP COLUMN Maximum_Lab;

--ALTER TABLE [USCB Course Catalog - 11.4.26]
--DROP COLUMN Lab_Indicator;

--ALTER TABLE [USCB Course Catalog - 11.4.26]
--DROP COLUMN More_Text_Narrative;

--ALTER TABLE [USCB Course Catalog - 11.4.26]
--DROP COLUMN Course_Degree_Attributes;

--ALTER TABLE [USCB Course Catalog - 11.4.26]
--DROP COLUMN Course_Degree_Attribute_Count;

--ALTER TABLE [USCB Course Catalog - 11.4.26]
--DROP COLUMN No_Of_Repeats_Allowed;

--ALTER TABLE [USCB Course Catalog - 11.4.26]
--DROP COLUMN Maximum_Repeat_Credits;

--ALTER TABLE [USCB Course Catalog - 11.4.26]
--DROP COLUMN Repeat_Status_Code;

--ALTER TABLE [USCB Course Catalog - 11.4.26]
--DROP COLUMN Repeat_Status_Description;

--ALTER TABLE Students
--ADD USCBID int; -- Added USCBID into the Students table

--/*
---- Course Offerings Table Deletions
---- Get rid of Billing table
---- Course Offerings
---- I am beginning at the start and stopping at the column named "Section" within the Course Offerings table
--*/

---- [USCB Course Offerings - 11.4.26]

--ALTER TABLE [USCB Course Offerings - 11.4.26]
--DROP COLUMN IF EXISTS Class_Status_TBA

--ALTER TABLE [USCB Course Offerings - 11.4.26]
--DROP COLUMN IF EXISTS Course_Text_Narrative

--ALTER TABLE [USCB Course Offerings - 11.4.26]
--DROP COLUMN SUBJECT_DESC

--ALTER TABLE [USCB Course Offerings - 11.4.26]
--DROP COLUMN ACADEMIC_PERIOD;

/*
======================================================
			Querying For Table Inserts
====================================================== */


/* =======================================
		 Locations (Status: Complete)
  ========================================= */
INSERT INTO Locations
SELECT DISTINCT Campus_Desc, Room, Building
FROM [USCB Course Offerings - 11.4.26];

SELECT *
FROM Locations

/* ===================================
	MeetingTypes (Status: Complete)
   =================================== */
INSERT INTO MeetingTypes
SELECT  DISTINCT Meeting_Type_Desc
FROM [USCB Course Offerings - 11.4.26];

/* =====================================
	StudentTerms (Status: Complete) 
========================================= */
INSERT INTO StudentTerms
SELECT DISTINCT Academic_Period_Desc
FROM [USCB Course Offerings - 11.4.26];

SELECT *
FROM StudentTerms

/* ==================================
	 Departments (Status: Complete)
 ===================================== */
INSERT INTO Departments
SELECT DISTINCT Department_Description
FROM [USCB Course Catalog - 11.4.26];

SELECT *
FROM Departments

/* ===================================
	 Professors (Status: Complete)
   ==================================== */

INSERT INTO Professors
(
	FullName
)
SELECT DISTINCT Professor 
FROM [USCB Course Offerings - 11.4.26]

/* ================================
		Courses (Status: Complete)
 =================================== */
INSERT INTO Courses
SELECT DISTINCT Title_Short_Description, Course_Description, Minimum_Credit, Maximum_Credit
FROM [USCB Course Catalog - 11.4.26];

-- Courses (Test)
SELECT *
FROM Courses 

/* ===================================
			CourseOfferings -- Terrance is taking care of this table
  ==================================== */
-- CourseOfferings -- Still needs the CourseOfferingsID (Will automatically be generated), CourseID, ProfessorID,
-- Location ID, TermID
INSERT INTO CourseOfferings
SELECT CRN
FROM [USCB Course Offerings - 11.4.26];
	


SELECT * 
FROM [USCB Course Offerings - 11.4.26];



SELECT *
FROM [USCB Course Catalog - 11.4.26];

SELECT *
FROM Students

/* ===========================
		Restrictions (Status: Completed)
 ============================= */
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
UNION
SELECT Course_Department_Restrictions
FROM [USCB Course Catalog - 11.4.26]
WHERE Course_Department_Restrictions is not null 
UNION
SELECT Course_Class_Restrictions
FROM [USCB Course Catalog - 11.4.26]
WHERE Course_Class_Restrictions is not null
UNION
SELECT Course_Degree_Restrictions
FROM [USCB Course Catalog - 11.4.26]
WHERE Course_Degree_Restrictions is not null
UNION
SELECT Course_Program_Restrictions
FROM [USCB Course Catalog - 11.4.26]
WHERE Course_Program_Restrictions is not null
UNION
SELECT Course_Campus_Restrictions
FROM [USCB Course Catalog - 11.4.26]
WHERE Course_Campus_Restrictions is not null
UNION
SELECT Course_College_Restrictions
FROM [USCB Course Catalog - 11.4.26]
WHERE Course_College_Restrictions is not null
UNION 
SELECT Course_Std_Attribute_Restrictions
FROM [USCB Course Catalog - 11.4.26]
WHERE Course_Std_Attribute_Restrictions is not null
UNION 
SELECT Course_Cohort_Restrictions
FROM [USCB Course Catalog - 11.4.26]
WHERE Course_Cohort_Restrictions is not null
-- Restrictions (Test)
SELECT *
FROM Restrictions

SELECT *
FROM [USCB Course Catalog - 11.4.26]

/* ============================================================
					Classifications insert (Status: Completed)
=============================================================== */

INSERT INTO Classifications (StudentClassificationDescription)
VALUES ('Incoming'), ('Freshman'), ('Sophomore'), ('Junior'), ('Senior'), ('Alumni');

-- Classifications (Test)
SELECT *
FROM Classifications

-- ClassificationID
-- StudentClassificationDescription
-- StudentType 

/* ===========================================
			Degrees (Status: Complete)
	========================================== */

-- Assigning values based off of the student majors that we will be mocking
INSERT INTO [Degrees] (DegreeDescription)
VALUES ('ISAT'), ('CSCI'), ('MATH'), ('PSYC')

-- Degrees (Test)
SELECT *
FROM [Degrees]

/* =======================================
		Enrollments (Status: In Progress) -- FINISH TN
========================================== */
SELECT *
FROM [USCB Course Catalog - 11.4.26];


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




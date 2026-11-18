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
FROM [USCB Course Catalog - 11.4.26];

SELECT *
FROM [USCB Course Offerings - 11.4.26];

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
	RoomNum INT
);
GO

-- TRIRON
CREATE TABLE StudentTerms (
	TermID INT IDENTITY(1,1) PRIMARY KEY,
	[Date] DATE,
	Description VARCHAR(MAX)
);
GO

-- TRIRON
CREATE TABLE Courses (
	CourseID INT IDENTITY(1,1) PRIMARY KEY,
	CourseTitle VARCHAR(50),
	CourseDescription VARCHAR(MAX),
	CreditMin INT NOT NULL,
	CreditMax INT NOT NULL
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
Tables with foriegn keys need to created after their parents
*/

-- TRIRON
CREATE TABLE Professors (
	ProfessorID INT IDENTITY(1,1) PRIMARY KEY,
	FirstName VARCHAR(50),
	LastName VARCHAR(50),
	CRN VARCHAR(50),
	DepartmentID INT NOT NULL,

	CONSTRAINT FK_Professors_DepartmentID
	FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);
GO


-- Terrance
CREATE TABLE DegreeProgramPlans (
	DegreeProgramPlanID INT IDENTITY(1,1) PRIMARY KEY,
	DegreeProgramPlanDescription VARCHAR(MAX),
	DegreeID INT,
	ClassificationID INT,
	Major INT,
	Minor INT,
	Concentration VARCHAR(MAX), -- What type do we want Concentration to be

	CONSTRAINT FK_DegreeProgramPlans_DegreeID
	FOREIGN KEY (DegreeID) REFERENCES [Degrees](DegreeID),

	CONSTRAINT FK_DegreeProgramPlans_ClassificationID
	FOREIGN KEY (ClassificationID) REFERENCES Classifications(ClassificationID)
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
	FirstName VARCHAR(50),
	LastName VARCHAR(50),
	[Address] VARCHAR(50),
	[State] CHAR(2),
	[City] VARCHAR(50),
	StudentType VARCHAR(50),
	RestrictionID INT,           -- was VARCHAR(MAX); must match Restrictions.RestrictionID (INT)
	DegreeID INT,                -- was VARCHAR(MAX); must match Degrees.DegreeID (INT)
	StudentClassificationID INT NOT NULL,
	DegreeProgramPlanID INT NOT NULL,

	CONSTRAINT FK_Students_RestrictionID
	FOREIGN KEY (RestrictionID) REFERENCES Restrictions(RestrictionID),

	CONSTRAINT FK_Students_DegreeID
	FOREIGN KEY (DegreeID) REFERENCES [Degrees](DegreeID),

	CONSTRAINT FK_Students_StudentClassificationID
	FOREIGN KEY (StudentClassificationID) REFERENCES Classifications(ClassificationID),

	CONSTRAINT FK_Students_DegreeProgramPlanID
	FOREIGN KEY (DegreeProgramPlanID) REFERENCES DegreeProgramPlans(DegreeProgramPlanID)
);
GO



-- TRIRON
CREATE TABLE Enrollments (
	EnrollmentID INT IDENTITY(1,1) PRIMARY KEY,
	StudentID INT,
	CourseOfferingID INT NOT NULL,
	Grade VARCHAR(20),
	RestrictionID INT,

	CONSTRAINT FK_Enrollments_StudentID
	FOREIGN KEY (StudentID) REFERENCES Students(StudentID),

	CONSTRAINT FK_Enrollments_CourseOfferingID
	FOREIGN KEY (CourseOfferingID) REFERENCES CourseOfferings(CourseOfferingID),

	CONSTRAINT FK_Enrollments_RestrictionID
	FOREIGN KEY (RestrictionID) REFERENCES Restrictions(RestrictionID)
);
GO

-- Terrance
CREATE TABLE CourseBillingLineItems (
	CourseBillingLineItemsID INT IDENTITY(1,1) PRIMARY KEY,
	StudentID INT,
	[CRN/CourseID] INT, -- * consider CourseOfferingID INT with an FK to CourseOfferings
	CreditHours INT,

	-- renamed: FK_Enrollments_StudentID was already used by Enrollments
	CONSTRAINT FK_CourseBillingLineItems_StudentID
	FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);
GO

/*
	=======================================================
					TABLE CREATION TEST
	======================================================= */

SELECT *
FROM Departments

SELECT *
FROM Locations

SELECT *
FROM Terms

SELECT *
FROM Courses

SELECT *
<<<<<<< HEAD
FROM Classifications;

SELECT *
FROM StudentTerms;
=======
FROM MeetingTypes

SELECT *
FROM [Degrees]

SELECT *
FROM Restrictions

SELECT *
FROM Classifications

SELECT *
FROM Prereqs

SELECT *
FROM Professors

SELECT *
FROM DegreeProgramPlans

SELECT *
FROM CourseOfferings

SELECT *
FROM Students

SELECT *
FROM Enrollments

SELECT *
FROM CourseBillingLineItems

>>>>>>> 8b0025cfefb7f257ebd23f5ccb344d13977641b9

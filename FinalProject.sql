/*
	Developer:	James, Triron & Terrance Dessaure
	Course:		B320
	Assignment: Final Project
*/

-- Dropping Tables if they exist
--DROP TABLE IF EXISTS Locations;
--DROP TABLE IF EXISTS Professors;
--DROP TABLE IF EXISTS Terms;
--DROP TABLE IF EXISTS Courses;
--DROP TABLE IF EXISTS Students;
--DROP TABLE IF EXISTS Enrollments;
--DROP TABLE IF EXISTS [Degrees];
--GO

SELECT *
FROM [USCB Course Catalog - 11.4.26]

<<<<<<< HEAD
--SELECT *
--FROM [USCB Course Offerings - 11.4.26]

--TRIRON
CREATE TABLE Locations (
LocationID INT IDENTITY(1,1) PRIMARY KEY,
CollegeDescription VARCHAR(MAX),
BuildingDescription VARCHAR(MAX),
RoomNum INT
)
GO

--TRIRON
CREATE TABLE Professors (
	ProfessorID INT IDENTITY(1,1) PRIMARY KEY,
	FirstName VARCHAR(50),
	LastName VARCHAR(50),
	CRN VARCHAR(50),
	DepartmentID INT NOT NULL

	CONSTRAINT FK_Departments_Professors -- cannot finish creating this table until the Departments table is created
	-- receiving the error "invalid table Departments"
	FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
)
GO

--TRIRON
CREATE TABLE Terms (
	TermID INT IDENTITY(1,1) PRIMARY KEY,
	[Date] DATE,
	Description VARCHAR(MAX)
)
GO

-- TRIRON
CREATE TABLE Courses (
	CourseID INT IDENTITY(1,1) PRIMARY KEY,
	CourseTitle VARCHAR(50),
	CourseDescription VARCHAR(MAX),
	CreditMin INT NOT NULL,
	CreditMax INT NOT NULL
)
GO

--SELECT *
--FROM Locations

--TRIRON
CREATE TABLE CourseOfferings -- cannot finish creating this table until the Professors table is created
(
	CourseOfferingID INT IDENTITY(1,1) PRIMARY KEY,
	CourseID INT NOT NULL,
	ProfessorID INT NOT NULL,
	CRN VARCHAR(50),
	MeetingTypeID INT NOT NULL,
	LocationID INT NOT NULL,
	TermID INT NOT NULL

	CONSTRAINT FK_CourseOfferings_LocationID
	FOREIGN KEY (LocationID)
	REFERENCES Locations(LocationID),
	CONSTRAINT FK_CourseOfferings_ProfessorID
	FOREIGN KEY (ProfessorID)
	REFERENCES Professors(ProfessorID),
	CONSTRAINT FK_CourseOfferings_TermID
	FOREIGN KEY (TermID)
	REFERENCES Terms(TermID),
	CONSTRAINT FK_CourseOfferings_CourseID
	FOREIGN KEY (CourseID)
	REFERENCES Courses(CourseID)
)
GO

--TRIRON
CREATE TABLE Students -- cannot finish creating this table until the StudentClassifications table is created
(
	StudentID INT IDENTITY(1,1) PRIMARY KEY,
	FirstName VARCHAR(50),
	LastName VARCHAR(50),
	[Address] VARCHAR(50),
	[State] CHAR(2),
	[City] VARCHAR(50),
	StudentType VARCHAR(50),
	EnrollmentID INT NOT NULL,
	RestrictionID VARCHAR(MAX),
	DegreeID VARCHAR(MAX),
	StudentClassificationID INT NOT NULL,
	DegreeProgramPlanID INT NOT NULL


	CONSTRAINT FK_Students_StudentType
	FOREIGN KEY (StudentType)
	REFERENCES StudentClassifications(StudentType),
	CONSTRAINT FK_Students_EnrollmentID
	FOREIGN KEY (EnrollmentID)
	REFERENCES Enrollments(EnrollmentID),
	CONSTRAINT FK_Students_RestrictionID
	FOREIGN KEY (RestrictionID)
	REFERENCES Restrictions(RestrictionID),
	CONSTRAINT FK_Students_DegreeID
	FOREIGN KEY (DegreeID)
	REFERENCES [Degrees](DegreeID),
	CONSTRAINT FK_Students_StudentClassificationID
	FOREIGN KEY (StudentClassificationID)
	REFERENCES StudentClassifications(StudentClassificationID),
	CONSTRAINT FK_Students_DegreeProgramPlanID
	FOREIGN KEY (DegreeProgramPlanID)
	REFERENCES DegreeProgramPlans(DegreeProgramPlanID)
)
GO

-- TRIRON
CREATE TABLE Enrollments -- cannot finish creating this table until the Students and StudentClassifications table is created
(
	EnrollmentID INT IDENTITY(1,1) PRIMARY KEY,
	StudentID INT,
	CourseOfferingID INT NOT NULL,
	Grade VARCHAR(20),
	RestrictionID INT,

	CONSTRAINT FK_Enrollments_StudentID
	FOREIGN KEY (StudentID)
	REFERENCES Students(StudentID),
	CONSTRAINT FK_Enrollments_CourseOfferingID
	FOREIGN KEY (CourseOfferingID)
	REFERENCES CourseOfferings(CourseOfferingID)
)
GO

--TRIRON
CREATE TABLE [Degrees] 
(
	DegreeID INT IDENTITY(1,1) PRIMARY KEY,
	DegreeDescription VARCHAR(MAX)
)
GO

CREATE TABLE [Departments] (
[DepartmentID, PK] <type>,
[DepartmentDescription] <type>
);

CREATE TABLE [Restrictions] (
[RestrictionID, Pk] <type>,
[RestrictionDescription] <type>
);

CREATE TABLE [CourseBillingLineItems] (
[CourseBillingLineItemsID, PK] <type>,
[StudentID] <type>,
[CRN/CourseID] <type>,
[CreditHours] <type>
);

CREATE TABLE [Prereqs] (
[PrereqID, PK] <type>,
[PrereqDescription] <type>
);

CREATE TABLE [MeetingTypes] (
[MeetingTypeID, PK] <type>,
[MeetingTypeDescription] <type>
);

CREATE TABLE [StudentClassifications] (
[StudentClassificationID, PK] <type>,
[StudentClassificationDescription] <type>,
[StudentType] <type>
);

CREATE TABLE [DegreeProgramPlans] (
[DegreeProgramPlanID] <type>,
[DegreeProgramPlanDescription] <type>,
[DegreeID] <type>,
[ClassificationID] <type>,
[Major] <type>,
[Minor] <type>,
[Concentration] <type>,
CONSTRAINT [FK_DegreeProgramPlans_DegreeID]
FOREIGN KEY ([DegreeID])
REFERENCES [Degrees]([DegreeID, PK])
);
=======
SELECT *
FROM [USCB Course Offerings - 11.4.26]

SELECT *
FROM VendorCopy
>>>>>>> d26557cc4098144fe3e537b8a53aecc923c34aac

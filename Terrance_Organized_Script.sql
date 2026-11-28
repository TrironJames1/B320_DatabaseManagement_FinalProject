/*
	Developer:  Dessaure, Terrance
	Course:     B320
	Assignment: Final Project

	Requires these imported tables to exist before running:
	  [USCB Course Offerings - 11.4.26]
	  [USCB Course Catalog - 11.4.26]
	  STUDENT_MOCK_DATA
*/


/* ==================================================================
		1. DROP TABLES
		Child tables (the ones holding foreign keys) are dropped first,
		otherwise SQL Server refuses to drop a table another table points to.
===================================================================== */
DROP TABLE IF EXISTS CourseBillingLineItems;
DROP TABLE IF EXISTS Enrollments;
DROP TABLE IF EXISTS Persons;
DROP TABLE IF EXISTS CourseOfferings;
DROP TABLE IF EXISTS DegreeProgramPlans;
DROP TABLE IF EXISTS Professors;
DROP TABLE IF EXISTS Prereqs;           -- removed: prereqs stay inside the course description
DROP TABLE IF EXISTS Classifications;
DROP TABLE IF EXISTS Restrictions;
DROP TABLE IF EXISTS [Degrees];
DROP TABLE IF EXISTS MeetingTypes;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS StudentTerms;
DROP TABLE IF EXISTS Locations;
DROP TABLE IF EXISTS Departments;
GO


/* ==================================================================
		2. CREATE LOOKUP TABLES (no foreign keys)
===================================================================== */

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
-- No Date column: ACADEMIC_PERIOD_DESC already holds both the term and the year,
-- so it goes into Description instead.
CREATE TABLE StudentTerms (
	TermID INT IDENTITY(1,1) PRIMARY KEY,
	Description VARCHAR(MAX)
);
GO

-- TRIRON
CREATE TABLE Courses ( 
	CourseID INT IDENTITY(1,1) PRIMARY KEY,
	CourseTitle VARCHAR(50),
	CourseSubject VARCHAR(20),
	CourseNum VARCHAR(20),
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
	StudentClassificationDescription VARCHAR(MAX)
);
GO

-- TRIRON
-- No DepartmentID: a professor's department can be found through the courses they teach.
CREATE TABLE Professors (
	ProfessorID INT IDENTITY(1,1) PRIMARY KEY,
	FirstName VARCHAR(50),
	LastName VARCHAR(50)
);
GO

/* ==================================================================
		3. CREATE TABLES WITH FOREIGN KEYS (after their parents)
===================================================================== */

-- Terrance
CREATE TABLE CourseOfferings (
	CourseOfferingID INT IDENTITY(1,1) PRIMARY KEY,
	CourseID         INT NOT NULL,
	Term             VARCHAR(50),
	Professor        VARCHAR(100),
	CourseNumber     VARCHAR(20),
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
-- EnrollmentID removed: Enrollments already stores PersonalID, so having
-- Persons point back at Enrollments made a circular reference.
CREATE TABLE Persons (
	PersonalID INT IDENTITY(1,1) PRIMARY KEY,
	ProfessorID INT,
	FirstName VARCHAR(50),
	LastName VARCHAR(50),
	RestrictionID INT,
	DegreeID INT,
	ClassificationID INT,
	Major VARCHAR(50),
	Minor VARCHAR(50),
	Concentration VARCHAR(50),

	CONSTRAINT FK_Persons_ProfessorID
		FOREIGN KEY (ProfessorID) REFERENCES Professors(ProfessorID),
	CONSTRAINT FK_Persons_RestrictionID
		FOREIGN KEY (RestrictionID) REFERENCES Restrictions(RestrictionID),
	CONSTRAINT FK_Persons_ClassificationID
		FOREIGN KEY (ClassificationID) REFERENCES Classifications(ClassificationID)

);
GO

-- TRIRON
-- Assumes all students' financial responsibilities to the school are taken care of.
CREATE TABLE Enrollments (
	EnrollmentID     INT IDENTITY(1,1) PRIMARY KEY,
	PersonalID       INT NOT NULL,
	CourseOfferingID INT NOT NULL,

	CONSTRAINT UQ_Enrollments_Person_Course
		UNIQUE (PersonalID, CourseOfferingID),
	CONSTRAINT FK_Enrollments_PersonalID
		FOREIGN KEY (PersonalID) REFERENCES Persons(PersonalID),
	CONSTRAINT FK_Enrollments_CourseOfferingID
		FOREIGN KEY (CourseOfferingID) REFERENCES CourseOfferings(CourseOfferingID)
);
GO


/* ==================================================================
		4. DATA CLEANING (imported tables)
===================================================================== */

-- Remove "USCB Dummy course not offered" and "EB Test of Waitlisting".
-- They are the only NULL meeting-type rows that aren't real courses.
DELETE FROM [USCB Course Offerings - 11.4.26]
WHERE MEETING_TYPE_DESC IS NULL
	AND (Title LIKE '%dummy%' OR Title LIKE '%test%');

-- Unused course offering columns
ALTER TABLE [USCB Course Offerings - 11.4.26]
DROP COLUMN IF EXISTS Class_Status_TBA,
     COLUMN IF EXISTS Course_Text_Narrative;

-- Unused course catalog columns
-- (Course_Major_Minor_Concentration_Restrictions and Course_Level_Restrictions
--  are dropped later, after the Restrictions insert reads them.)
ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN IF EXISTS
	Prereq_Waiver_Authorization_Type,
	Prereq_Waiver_Authorization_Type_Description,
	Tuition_Fee_Exempt,
	Additional_Fees_Indicator,
	Prereq_Check_Method,
	Course_Coreq_Count,
	Corequisite_Text,
	Course_Fee,
	Course_Area_Restrictions,
	Course_Department_Restrictions,     -- every value is NULL
	Course_Class_Restrictions,
	Course_Degree_Restrictions,
	Course_Program_Restrictions,
	Course_Campus_Restrictions,
	Course_College_Restrictions,
	Course_Std_Attribute_Restrictions,
	Course_Cohort_Restrictions,
	Other_Minimum,
	Other_Maximum,
	Other_Indicator,
	Credit_Indicator;
GO

/* ==================================================================
		5. POPULATE LOOKUP TABLES
===================================================================== */


-- Departments
INSERT INTO Departments (DepartmentDescription)
SELECT DISTINCT Department_Description
FROM [USCB Course Catalog - 11.4.26]
WHERE Department_Description IS NOT NULL;

-- MeetingTypes (the data only has two: class and exam)
INSERT INTO MeetingTypes (MeetingTypeDescription)
SELECT DISTINCT MEETING_TYPE_DESC
FROM [USCB Course Offerings - 11.4.26]
WHERE MEETING_TYPE_DESC IS NOT NULL;

-- Restrictions
INSERT INTO Restrictions (RestrictionDescription)
SELECT Course_Major_Minor_Concentration_Restrictions
FROM [USCB Course Catalog - 11.4.26]
WHERE Course_Major_Minor_Concentration_Restrictions IS NOT NULL
UNION
SELECT Course_Level_Restrictions
FROM [USCB Course Catalog - 11.4.26]
WHERE Course_Level_Restrictions IS NOT NULL;
GO

-- Now that Restrictions is populated, drop the two restriction columns
ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN IF EXISTS
	Course_Major_Minor_Concentration_Restrictions,
	Course_Level_Restrictions;
GO

-- Classifications
INSERT INTO Classifications (StudentClassificationDescription)
VALUES ('Incoming'), ('Freshman'), ('Sophomore'), ('Junior'), ('Senior'), ('Alumni');

-- Locations
INSERT INTO Locations (CollegeDescription, BuildingDescription, RoomNum)
SELECT DISTINCT CAMPUS_DESC, Building, Room
FROM [USCB Course Offerings - 11.4.26]
WHERE Building IS NOT NULL;

-- Student Terms
INSERT INTO StudentTerms
SELECT DISTINCT Academic_Period_Desc
FROM [USCB Course Offerings - 11.4.26];

-- Courses
INSERT INTO Courses (CourseTitle, CourseSubject, CourseNum, CourseDescription, CreditMin, CreditMax)
SELECT DISTINCT MAX(Title_Short_Description), Subject, Course_Number, MAX(Course_Description), MIN(Minimum_Credit), MAX(Maximum_Credit)
FROM [USCB Course Catalog - 11.4.26]
GROUP BY Subject, Course_Number;

-- Professors 
INSERT INTO Professors (FirstName, LastName)
SELECT DISTINCT
	LTRIM(RTRIM(SUBSTRING(Professor, CHARINDEX(',', Professor) + 1, LEN(Professor)))),
	LTRIM(RTRIM(LEFT(Professor, CHARINDEX(',', Professor) - 1)))
FROM [USCB Course Offerings - 11.4.26]
WHERE Professor LIKE '%,%';
GO


/* ==================================================================
		6. POPULATE MAIN TABLES
===================================================================== */

-- Course Offerings
INSERT INTO CourseOfferings
    (CourseID, Term, CourseNumber, Professor, Credits, [Days], [Time], MeetingTypeDesc, LocationID)
SELECT DISTINCT
    c.CourseID,
    col.ACADEMIC_PERIOD_DESC,
    col.Course,
    col.Professor,
    col.Credits,
    col.Days,
    col.Time,
    col.MEETING_TYPE_DESC,
    l.LocationID
FROM [USCB Course Offerings - 11.4.26] AS col
INNER JOIN Courses AS c
    ON  c.CourseSubject = col.Subject
    AND c.CourseNum     = col.Course
LEFT JOIN Locations AS l
    ON  l.CollegeDescription  = col.CAMPUS_DESC
    AND l.BuildingDescription = col.Building
    AND l.RoomNum             = col.Room;

-- Persons (the 400 mock students + 644 professors)
INSERT INTO Persons
	(ProfessorID, FirstName,LastName)
SELECT ProfessorID, FirstName, LastName
FROM Professors
UNION ALL -- Use UNION ALL Here because if a student and a professor has the same first and last name we would lose data
SELECT NULL, first_name, last_name
FROM STUDENT_MOCK_DATA;

WITH Numbered AS (            -- the students, numbered 0, 1, 2, ...
    SELECT PersonalID,
           ROW_NUMBER() OVER (ORDER BY PersonalID) - 1 AS rn
    FROM Persons
    WHERE ProfessorID IS NULL
),
Majors AS (                   -- the 4 majors, numbered 0–3
    SELECT * 
	FROM (VALUES
        (0, 'ISAT'),       -- ← replace with your real major names
        (1, 'CSCI'),
        (2, 'MATH'),
        (3, 'PSYC')
    ) AS m(idx, MajorName)
),
Classes AS (                  -- the 6 classifications, numbered 0–5
    SELECT * 
	FROM (VALUES
        (0, 'Incoming'), (1, 'Freshman'), (2, 'Sophomore'),
        (3, 'Junior'),   (4, 'Senior'),   (5, 'Alumni')
    ) AS c(idx, Descr)
)
UPDATE p
SET Major            = m.MajorName,
    ClassificationID = cl.ClassificationID
FROM Persons p
JOIN Numbered n         ON n.PersonalID = p.PersonalID
JOIN Majors m           ON m.idx = n.rn / 60                  -- every 60 students → next major
JOIN Classes c          ON c.idx = (n.rn % 60) / 10           -- every 10 within a major → next classification
JOIN Classifications cl ON cl.StudentClassificationDescription = c.Descr;

/* ============================================================
	NOTES: Assigning majors and classifications to students
   ============================================================
	Goal: 240 students -> 60 per major (4 majors),
	      and within each major, 10 per classification (6 classifications).
	      The other 160 mock students are extras and stay NULL.

	WITH (CTE):
	  Creates temporary, named results that only exist for the one
	  statement right after it (the UPDATE). Nothing is saved.
	  Run the whole block, from WITH to the final semicolon, together.

	Numbered:
	  Numbers only the students (ProfessorID IS NULL skips professors)
	  0, 1, 2, ... in order of PersonalID.
	  The first student (PersonalID 645) gets rn = 0.

	Majors / Classes:
	  Small lookup lists that map a position number to a value.
	  Majors:  0-3 -> major name
	  Classes: 0-5 -> classification description

	The math:
	  rn / 60         -> which major (integer division drops the decimal)
	                     rn 0-59 = major 0, 60-119 = major 1, ...
	                     rn 240+ = 4 or more -> no match -> student skipped
	  (rn % 60) / 10  -> which classification within that major
	                     % (modulo) = the remainder after dividing
	                     positions 0-9 = Incoming, 10-19 = Freshman, ...

	JOIN Classifications
	  Turns the description (e.g. 'Freshman') into the real
	  ClassificationID from the Classifications table, so the
	  foreign key always gets a valid ID, even if IDs change.

	SET
	  Saves the major name and the ClassificationID into Persons.

	Example: PersonalID 720 -> rn 75
	  75 / 60 = 1           -> Major 2
	  (75 % 60) / 10 = 1    -> Freshman -> ClassificationID looked up

	Note: descriptions in Classes must be spelled exactly like the
	      ones in the Classifications table, or those students get no classification.
   ============================================================ */


-- TODO: Enrollments insert


/* ==================================================================
		NOTES
===================================================================== */
-- SUBSTRING pulls out part of a piece of text, given where to start and how many characters to take.
--   text:   the column or string to cut from
--   start:  the position of the first character to take (counting starts at 1)
--   length: how many characters to take
-- CHARINDEX finds the position of a character, so you can start or stop at that
-- character instead of at a fixed number.
-- UNOIN ALL: does not merge duplicats
-- LTRIM and RTRIM: remove an spaces from the left and right of a selected text
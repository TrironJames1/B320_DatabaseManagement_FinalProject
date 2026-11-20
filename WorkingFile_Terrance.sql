/*
	Developer: Dessaure, Terrance
	Course:		B320
	Assignment: Final Project

*/

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
		Classifications insert (dependent on student data)
=============================================================== */
INSERT INTO Classifications(
	-- StudentClasifcationDescription
	-- Student
);

/* ============================================================
		Classifications insert (dependent on student data)
=============================================================== */



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

/* =================================== 
		1ST YEAR STUDENT INSERT
=====================================*/ 

SELECT TOP 10 *
FROM STUDENT_MOCK_DATA


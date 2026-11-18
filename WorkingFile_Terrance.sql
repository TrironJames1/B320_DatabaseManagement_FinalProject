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

SELECT *
FROM [USCB Course Catalog - 11.4.26];

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

/*
	COURSE OFFERINGS TABLE
*/

SELECT *
FROM [USCB Course Offerings - 11.4.26];

ALTER TABLE [USCB Course Offerings - 11.4.26]
DROP COLUMN IF EXISTS Class_Status_TBA

ALTER TABLE [USCB Course Offerings - 11.4.26]
DROP COLUMN IF EXISTS Course_Text_Narrative





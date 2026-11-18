/* =========================================================
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

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN Minimum_Billing;

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN Maximum_Billing;

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN Billing_Indicator;

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN Maximum_Contact; 

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN Contact_Indicator;

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN Minimum_Lecture;

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN Maximum_Lecture;

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN Lecture_Indicator; 

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN Minimum_Lab;

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN Maximum_Lab;

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN Lab_Indicator;

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN More_Text_Narrative;

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN Course_Degree_Attributes;

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN Course_Degree_Attribute_Count;

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN No_Of_Repeats_Allowed;

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN Maximum_Repeat_Credits;

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN Repeat_Status_Code;

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN Repeat_Status_Description;


/*
-- Course Offerings Table Deletions
-- Get rid of Billing table
-- Course Offerings
-- I am beginning at the start and stopping at the column named "Section" within the Course Offerings table
*/

SELECT *
FROM [USCB Course Offerings - 11.4.26];

ALTER TABLE [USCB Course Offerings - 11.4.26]
DROP COLUMN SUBJECT_DESC

ALTER TABLE [USCB Course Offerings - 11.4.26]
DROP COLUMN ACADEMIC_PERIOD;








-- Terrance Course Catalog Responsibility:
-- Prereq_Waiver_Authorization_Type, Prereq_Waiver_Authorization_Type_Description, Tuition_Fee_Exempt
-- Additional_Fees_Indicator, Prereq_Check_Method, Course_Coreq_Count, Corequisite_Text, Course_Fee
-- Course_Area_Restrictions, Course_Department_Restrictions, Course_Major_Minor_Concentrations_Restrictions, Course_Class_Restrictions
-- Course_Level_Restrictions, Course_Degree_Restrictions, Course_Program_Restrictions
-- Course_Campus_Restrictions, Course_College_Restrictions, Course_Std_Attribute_Restrictions, Course_Cohort_Restrictions
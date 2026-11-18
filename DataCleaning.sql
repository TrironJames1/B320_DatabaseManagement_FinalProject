/* =========================================================
						Data Scrubbing
 ============================================================ */

/*
	Dropping Columns that from the [USCB Course Catalog - 11.4.26] Table
	Each of these columns were dropped due to them not being useful and will document this
	within the Project documentation
*/
SELECT *
FROM [USCB Course Catalog - 11.4.26]

ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN Credit_Indicator;
ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN Other_Minimum;
ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN Other_Maximum;
ALTER TABLE [USCB Course Catalog - 11.4.26]
DROP COLUMN Other_Indicator; 

-- Test and see that the columns mentioned above have been dropped 
SELECT *
FROM [USCB Course Catalog - 11.4.26]

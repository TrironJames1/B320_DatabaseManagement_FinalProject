## 11-9-26: Triron James
- 5 hours spent toward helping design the ERD file. Finding appropriate table names, and relationships.

## 11-9-26: Terrance Dessaure
- 5 hours helping design the ERD file. Finding relationships and creating tables.

## 11-10-26: Triron James
- 2 hours converting file to csv, inputing files into sql server and confirming ERD design.

## 11-11-26: ERD organiztion notes Terrance Dessaure:
- While working one the connection of the Degree, DegreeProgramPlans, and Students.
-   I figure that haveing the Degree connect to the DegreeeProgramPlans table would be redundant. Why not have the DegreeProgramPlans connect to the the Students table, instead of having both connect to the Students table
-   That idea would be good if our assumption was that the student never changes classes. But we could prepare for the fact the a Student could change degree plaths. Having the degree path directly on the students can better repensent the students current status. The student could change their plans or have multiple plans. 
(1 hr)

## 11-12-26: ERD organiztion notes Terrance Dessaure (2hrs):
- Static vs Dynamic
- Shoud we have a CourseDescription table if we already have a course table. We could just have a description inside of the Course table instead of of having a different table for the course description, since each course will be different.

Possible Static Parent Tables:
( These are going to be the tables that we reference to get the information from the other tables)
- Departments
- MeetingTypes
- StudentTypes
- Restrictions
- Buildings
- Campuses
- StudentClassifications
- Degreees
- DegreeProgramPlans
- Terms
- Prereq
- Programs

Possible Dynamic Child Table:
- Students
- Course
- Sections
- Professors
- CouseBillingLineItems

## 11-12-26: ERD Review and Notes Triron James (2hrs):
- While looking over the ERD I received feedback from Racheal and Julia
- While conversating they suggested that we change the waly that we view designing our ERD and that we may have been thinking from a OOP mindset rather than a relational mindset.
- Discussed static vs dynamic tables
  . Information should be pulled from static tables into dynamic tables and not vice versa
  . As a result the static tables would the parents while the dynamic would be the children in the relationship
- We also discussed the importance of the documentation of assumptions

## 11-13-26 ERD Review and changes continued, Triron James (2.5hrs):
- That morning I had Jalyn quickly look over our ERD and give some basic suggestions
- During the conversation he suggested that we should have some sort of course offerings table to hold all of the dynamic information that we were previously keeping within the courses table
- We also worked towards condensing some of the tables within our ERD and remapping the connections with the addition of the course offerings table and the removal of other tables
- We condensed our table count from 20 to 15 while still keeping track of the valuable relationships that will need to be tracked within the ERD

## 11-16-26 Adjustments to SSMS sql file, Triron James (2.5hrs):
- Created half of the tables described in the ERD
- Had to adjust all of the datatypes for each specified column that we wanted to include within the table
- Specified which columns are primary or foreign keys
- Some tables were not able to be generated, due to the foreign keys referring to tables that have not been created yet
- Upon partners completion of the second half of the create tables script, I will go back and ensure that each table can be created as intended.

## 11-16-26 Adjustments to SSMS sql file, Terrance Dessaure (3 hrs)
- Created half of the table described in the ERD
- Adjusted the datatypes for each column in the tables
- Specified primary and foreign keys

Some Debugging that we need to do:
- Tables were created in wrong order. `Professors` was created before `Departments`, and `CourseOfferings` and `Students` were created before the tables they reference. We must make sure that every parent table is created before that tables that point to it
- Tables were dropped in the wrong order. The `DROP`s need to be reversed so the child tables go first. Otherwise, SQL Server refuses to drop a table that another table still references.
- Students and Enrollments point to each other, so they cannot be created first. We can get rid of EnrollmentID from Students. `Enrollments.StudentID` already thinks them.
- Some data types didn’t match. Students.RestrictionID and Students.DegreeID were VARCHAR(MAX) but referenced INT keys.  We should change them to INT.
- A foreign key pointed at a non-key column. FK_Students_StudentType referenced Classifications(StudentType), which isn’t a key. StudentClassificationID already links to that table.
- Two constraints had the same name. CourseBillingLineItems reused FK_Enrollments_StudentID, and constraint names have to be unique. It’s now FK_CourseBillingLineItems_StudentID.
- Missing foreign keys added: CourseOfferings.MeetingTypeID now links to MeetingTypes, and Enrollments.RestrictionID now links to Restrictions.

I added a second file that has these corrections so we can look over and review them 

## 11-18-26 Creation of Separate sql files and Start of Data Scrubbing Triron James (3.5hrs):
- Created a separate file to prevent both Terrance and I from having to wait for each other to push and pull the content we are each working on
- We each have created our on separate files and are spliting the course offerings tables and course catalogs table in half to

## 11-19-26 Beginning of Population of Data within Tables Triron James (2hrs):
- Used the course data population script as a reference to generate the Insert into script
- Successfully populated the proper data into the Courses table
- Adjusted some of the data types for the tables to allow for data population
- All done within Triron_WorkingFile.sql
- Plan to populate more tables later today as well

## 11-19-26 Populating Data: Terrance Dessaure
Tables I am propulating:
- [x] Departments
- [x] MeetingTypes
- [x] Restrictions
- [x] Classifications
- [] Prereqs
- [] DegreeProgramPlans
- [] CourseBillingLineItems

Notes about table inserts:
- I was successful with inserting the data into the Departments Table
- MeetingTypes currently does not have any data in it because there is only one meeting type in the data which is face to face
- Restrictions
- [] RestrictionID - This is our Primary key for this table
- [] RestrictionDescription - There should be a description for each restriction and there should be an ID for each unique description

## 11-21-26 Populating Data: Triron James
  Tables I am populating:
  - [] Locations
  - [] StudentTerms
  - [x] Courses
  - [] Degrees
  - [] Professors
  - [] CourseOfferings
  - [] Students
  - [] Enrollments

## 11-22-26, Terrance Dessaure (2.5 hrs):
Making changes to the Students table:
- I changed the Students table so it only holds the data we actually have for the 400 mock students: a USCB ID, first name and last name (I know we only need 240 but Dr. Erdi told me to do 400. We can get rid of the extra at the end)

Remove these columns from your students table:
- Address
- State
- City

Add this column:
- USCBID

When you add USCBID your going to want to move it be after students. Here are the steps to change the order:
- In the Object Explorer, expand the database, then Tables.
- Right-click Students and choose Design.

<img width="470" height="507" alt="image" src="https://github.com/user-attachments/assets/71623243-604e-411a-a0c6-dd22a6dfe4fa" />


- click the small box to the left of USCBID to select the row
- Drag it up so it sits right under StudentID
- Then Save with Ctrl + S

If SSMS says "Saving changes is not permitted":
- Go to Tools --> Options --> Designers --> Table and Database Designers
- Uncheck Prevent saving changes that require table re-creation
- Click OK and save again

If you have any questions about that process or why I did something, feel free to ask.

## 11-22-26, Triron James (4hrs):
- Accidentally deleted the course catalog and course offerings tables and as a result had to spend some time reuploading those flat files.
- After doing so I Removed columns from my students table:
  . Address
  . State
  . City
- I then added the USCBID column and organized it to be right after the studentID

- Following this I continued with populating data into the tables:
  - [x] Locations
  - [x] StudentTerms
  - [x] Courses
  - [] Degrees 
  - [] Professors -- In Progress
  - [] CourseOfferings -- In Progress
  - [] Students -- In progress, however other adjustments have been made
  - [] Enrollments
 
- Notes:
  . Changed the data types for the RestrictionID and DegreeID columns from VARCHAR(MAX) to ints
  . Deleted the date column out of the StudentTerms table due to the column Academic_Period_Desc within the CourseOfferings table containing both the semester and year of the term. There is no use for the date.
  . I am running into issues populating some of these tables that have foreign keys within them due to not being able to inner join tables on values that the current table that you are working on not technically having those values yet to join on.

- Questions:
  . Why are the Major and Minor data types INT instead of VARCHAR?
    - I am assuming that this is to assign values to each major, minor type. If so then I believe we would want to do the same thing to the Concentration column, otherwise I think the data types would all be varchar for those columns.
 
  - I will continue to attempt to populate tables later today

## 11-23-26: (12 am - ... )
Currently working on the Classifications table. The Classifications table holds a primary key ID, StudentClassificationDescription, and a StudentType.

What is in StudentClassificationDescription:
- This should tell what year the student is. (In-Coming, Freshman, Softmore, Junior, Senior)

What is a StudentType:
- I believe we were either going to use StudentType as in wether this student live on campus or is an online only student. I don't think that is nessicary, so I think we should get rid of student type.
- I currently had a Student type in the Students table. I am going to drop that column and remove it from the create table script because StudentClassicationID should handle what year the student is in.

**Make sure if you make any changes like altering and dropping a table, go back to the create table scripts and remove or add anything to make sure it reflects the changes we are making as we go along. That way when we run the final script at the end there are no errors.
- I went back to the create table scripts and removed, city, state, address, and `StudentType` from the Students table.

Began working on DegreeProgramPlans:
** Answer to previous question:
- Major and Minor should not be INT. When I was creating the table I was probably thinking about credits and the min and max.
- I made the change and now in DegreeProgramPlans, Major and Minor, are VARCHAR(MAX).

What is in `DegreeProgramPlans` :
- `DegreeProgramPlanID` - Primary Key
- `DegreeProgramPlanDescription` - This is what will be (Information Science and Technology (ISAT), Computational Science (CSCI), Mathematics (MATH), Pychology (PSYC))
- `DegreeID` - Foreign key
- `ClassificationID` - Foreign key
- `Major`
- `Minor`
- `Concentration`

11-23-26: Triron James (11am - ...):
Notes: I agree that we can git rid of the prereq table and just have the course descriptions hold the mixture of prereq and course description. The data already does so, so I don't see any issue with this option.
- I cleaned up my create table scripts so that there is no delay between the changes that were made while populating the data and the create table scripts.
- I noticed that you have a typo in your classifications table "junoir" instead of "junior"

Table Population Progress:
  - [x] Locations
  - [x] StudentTerms
  - [x] Courses
  - [x] Degrees  -- Populated with the 4 majors that are required but will possibly add Nursing for extra credit (ISAT, CSCI, MATH, PSYC)
  - [] Professors -- In Progress
  - [] CourseOfferings -- In Progress
  - [] Students -- In progress, however other adjustments have been made
  - [] Enrollments

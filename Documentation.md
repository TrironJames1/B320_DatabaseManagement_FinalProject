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

## 11-23-26: (12 am - 2 am)
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

## 11-23-26: Triron James (11am - 3pm and 10pm - 11) (5hrs):
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
  - [] Enrollments -- In Progress

. Resolved git hub conflict and successfully pushed my work to github
. Deleted CourseBIllingLineItems table from create table script and altered the enrollments table
. Using the CourseID number instead of the CRN

## 11-24-26: Terrance Dessaure (10 am - 2 pm)
We made the decision to get rid of DegreeProgramPlans because we can put that data in places that fit better.

Table Progresstion:
- [x] Departments
- [x] MeetingTypes
- [x] Restrictions
- [x] Classifications
- [x] Prereqs (Getting rid of prereqs)
- [x] DegreeProgramPlans (Getting rid of DegreeProgramPlans)
- [x] CourseBillingLineItems (Changed to Enrollments)

I made some changes to the students Table:
- Removed, DegreepProgramPlans and StudentType
- Then I changed the order of the Student table
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/e7df99f4-5785-494a-b72c-1c4fcbf5b7a7" />

Working on the Professors table:
- I think that we should leave out the CRN and the DepartmentID because we can figure out both from the Courses table.

Working on the CourseOfferingTable:
- The CourseOfferingsTable that we planned to create needs a lot of the stuff that the original USCB Course Offerings table already has:
- The original course offering table holds some pretty valuable information:
- - ACADEMIC_PERIOD_DESC: We have this stored in our StudentTerms table
  - MEETING_TYPE_DESC:  This is stored in our MeetingType table
  - CRN: We don't really need this but I think that it is good to have
  - Professor: We have this stored in the Professors table
  - Subject: This list the subject for each class. I was thinking that we can get rid of any of the class that we do not need, but we will need some other subjects because we need to assign student to elective classes.
  - Course: This is another Course identifier that I think would be good to add to our own Course offerings table
  - Section: I think we should get rid of this column
  - Title: We can include the title of course. I don't think we have this anywhere else.
  - Credits: This shows how many credits class is worth
  - Building and Room: included in the Locations table
  - Sub_Academic_Term: This is important information that I would like to include in our table as well.
  - Days and Time: Also need to be include in the Course Offerings table.
 
We can have all this information in one table called Course Offerings. The connector, the bridges our Course offerings and our students will be our Enrollments table. This Enrollments table should hold the StudendID and the CourseOfferingsID. The Primary key for the Enrollments table would be a composite key (StudentID and CourseOfferingsID). Then we can have foriegn keys that prevent a student from  enrolling in a course that does not exists.

11-24-26: Triron James (12am-2pm)(3pm-4pm)(3hrs):
- Imported Mock Student Data
- Deleted DegreeProgramPlans Table
- Cleaned up CREATE TABLE statements
- Input the classificationID, Major, Minor, and Concentration directly into the students table
- Populated the students table
. Working on professors table:
  - I agree that CRN And DepartmentID aren't needed and can be tied back to courses. The only issue with this is that we have the departments tied to the professors table, so would we get rid of departments and only include the department description and crn columns within the courses table.
  - This would show the assigned CRN for each course as well as the department that the course is offered through for each course.
Total tables progress:
- [x] Departments
- [x] MeetingTypes
- [x] Restrictions
- [x] Classifications
- [x] Locations
- [x] StudentTerms
- [x] Courses
- [x] Degrees  -- Populated with the 4 majors that are required but will possibly add Nursing for extra credit (ISAT, CSCI, MATH, PSYC)
- [x] Professors -- In Progress
- We may possibly need another table or way to account for professors having the ability to take classes
- We can either create a persons table that will have capabilities to access both student and professorID
- Option 2: we include studentID into professors and leave the ability for the colunmn to be null
- [] CourseOfferings -- In Progress. Will add CRN and DepartmentID from Professors table
- [x] Students -- Still need to input RestrictionID, DegreeID, ClassificationID, Major, Minor, Concentration for each student. The inputting of this information starts the next sprint 3 believe
- [] Enrollments -- In Progress

. Populated the professors table

11-25-26: Terrance Dessaure (5hrs)

Course Offering table:
- This table should hold all the information about the course that we are allowing the students to enroll in.
- The column in this table consists of:
- - The identity column CourseOfferingID
  - CourseID: is the foreign key that points back to the Courses table
  - Term: the term when the course was offered
  - Professors: name of the professor that is teaching the course
  - CourseNumber
  - Section
  - Title: title of the couse
  - Credits: how many credits the course is worth
  - MeetingTypeDesc: whether the meeting is a class or exam
  - Days: what days the classes meet on
  - Time: what time the classes meet at
  - LocationID: point back to the locations table that tell what building and room number (Need to finishing joining: every column is currently null)
Enrollments table:
- Enrollment shows what student is enrolled in which class  offering
- -There is going to be a composite key for this table
- - It will handle if a student has to retake a course, A students obviously can retake a class in the same term so having it be a composite key always ensures that the student can take the class. Just not in the same term
  - RestrictionID
  - Grade
  - Credit hours

TODO:
- [x] Male sure persons table is loaded in correctly
- [x] Make sure other tables are all loaded in and ready for student data population
- [x] Reorganize the script and get rid of any unused code.
- [x]  Update the md file on git hub and push the changes
- [ ] Update the doc file 

## 11-25-26: Triron James (4 hrs)
- Adjusted Course Offering Information
- Got rid of students table and turned it into Persons table
- Adjusted enrollments table as well as the terms table
  
## 11-27-26: Triron James (4hrs)
Persons:
- Adjusted the Persons table insert script to not allow null values
Courses:
- Notes
    . The table was producing a large amount of duplicate data when being joined to the course offerings table due to the table created new rows for each variation within the course title although it is the same course
- Adjustments
    . Max(Title_Short_Description) picks the latest title when there may be multiple versions of the course name
    . Max(Course_Description) picks the latest value of course description when there may be multiple variations of the description
    . Min(Minimum_Credit) picks the minimum credit value
    . Max(Maximum_Credit) picks the maximum value
Course Offerings:
Adjustments:
- Adjusted the course offerings table by adding CourseNumber, Days, Time, and MeetingType to the create table script
  . The data types for [Days] and [Time] will be Varchar(20)
- The original Courses join was was joining only on the course title which would make one row for each different description or difference within the other data within the row that have the same course title
- Fixed that by joining courses not only on the course title, but also the course number
- Locations ws creating duplicates because the table was originally joined only on the room number
- Fixed that by joining on the campus, building, and room together to minimize duplication
- Left joined Locations instead of Inner joined to keep the classes that were online and don't have a room

## 11-27-26: Terrance Dessaure (2hrs)
Making changes:
- The Persons table should be allowed to have Nulls ProfessorID is going to be null for every student. The only thing that should not be null is the primary key.
- I made some changes to my Courses and Course Offerings  table:
- - The Course table  now groups but the subject
  - We technically do not need the `DISTINCT`  in the select statement because the `GROUP BY` eliminates the duplicates
  - Also the `MAX` on the text picks the value that comes lsat alphabetically, not the newest version
  - Corrected my CourseOfferings to use a left join  that compares the same three columns
 
Populated the students in the Persons table:
- I gave each student there ClassificationID and Major
- The goal was to have 240 students with 60 student per major and 40 students for each classification (Incoming - Alumni). Since there are 160 other mock students we are going to leave them null for the time being.
- Used a Common Table Expression with 3 parts
- - The CTE  creates temporary, named results that only only exist for the statement that is right after it. In this case that would be the `UPDATE` statement.
  - Numbered: This skips over the professors and only starts the count where there the ProfessorID  `IS NULL`. It ranks them in order, starting at 0.
  - Majors / Classes: These are small look up list that  map a position number to a value
  - There is some math that I want to include a description for, just for documentation purposes.
  - rn / 60: this determines which major the student gets assigned. (ex. rn 0-59 get  ISAT , rn 60-119 gets CSCI...
  - rn % 60: positions 0-9 get assigned incoming, 10-19 gets assigned freshman...
- Join Classification:
- - This turns the descriptions into the classificationID from our classifications table.

I have not started on the enrollments yet so the table is created there are just no inserts.

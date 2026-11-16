11-9-26: Triron James, 5 hours spent toward helping design the ERD file. Finding appropriate table names, and relationships.

11-9-26: Terrance Dessaure, 5 hours helping design the ERD file. Finding relationships and creating tables.

11-10-26: Triron James, 2 hours converting file to csv, inputing files into sql server and confirming ERD design.

11-11-26: ERD organiztion notes Terrance Dessaure:
- While working one the connection of the Degree, DegreeProgramPlans, and Students.
-   I figure that haveing the Degree connect to the DegreeeProgramPlans table would be redundant. Why not have the DegreeProgramPlans connect to the the Students table, instead of having both connect to the Students table
-   That idea would be good if our assumption was that the student never changes classes. But we could prepare for the fact the a Student could change degree plaths. Having the degree path directly on the students can better repensent the students current status. The student could change their plans or have multiple plans. 
(1 hr)

11-12-26: ERD organiztion notes Terrance Dessaure (2hrs):
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

11-12-26: ERD Review and Notes Triron James (2hrs):
- While looking over the ERD I received feedback from Racheal and Julia
- While conversating they suggested that we change the waly that we view designing our ERD and that we may have been thinking from a OOP mindset rather than a relational mindset.
- Discussed static vs dynamic tables
  . Information should be pulled from static tables into dynamic tables and not vice versa
  . As a result the static tables would the parents while the dynamic would be the children in the relationship
- We also discussed the importance of the documentation of assumptions

11-13-26 ERD Review and changes continued, Triron James (2.5hrs):
- That morning I had Jalyn quickly look over our ERD and give some basic suggestions
- During the conversation he suggested that we should have some sort of course offerings table to hold all of the dynamic information that we were previously keeping within the courses table
- We also worked towards condensing some of the tables within our ERD and remapping the connections with the addition of the course offerings table and the removal of other tables
- We condensed our table count from 20 to 15 while still keeping track of the valuable relationships that will need to be tracked within the ERD

11-16-26 Adjustments to SSMS sql file, Triron James (2.5hrs):
- Created half of the tables described in the ERD
- Had to adjust all of the datatypes for each specified column that we wanted to include within the table
- Specified which columns are primary or foreign keys
- Some tables were not able to be generated, due to the foreign keys referring to tables that have not been created yet
- Upon partners completion of the second half of the create tables script, I will go back and ensure that each table can be created as intended. 

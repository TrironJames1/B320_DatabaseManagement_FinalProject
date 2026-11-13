Triron James, 5 hours spent toward helping design the ERD file. Finding appropriate table names, and relationships.

11-9-26: Terrance Dessaure, 5 hours helping design the ERD file. Finding relationships and creating tables.

11-10-26: Triron James, 2 hours converting file to csv, inputing files into sql server and confirming ERD design.

11-11-26: ERD organiztion notes Terrance Dessaure:
- While working one the connection of the Degree, DegreeProgramPlans, and Students.
-   I figure that haveing the Degree connect to the DegreeeProgramPlans table would be redundant. Why not have the DegreeProgramPlans connect to the the Students table, instead of having both connect to the Students table
-   That idea would be good if our assumption was that the student never changes classes. But we could prepare for the fact the a Student could change degree plaths. Having the degree path directly on the students can better repensent the students current status. The student could change their plans or have multiple plans. 
(1 hr)

11-12-26: ERD organiztion notes Terrance Dessaure:
- Static vs Dynamic
- Shoud we have a CourseDescription table if we already have a course table. We could just have a description inside of the Course table instead of of having a different table for the course description, since each course will be different.
Recommended Static Parent Tables:

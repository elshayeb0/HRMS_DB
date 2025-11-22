[1mdiff --cc db/schema/01_core_hr.sql[m
[1mindex bd8bff8,ae80865..0000000[m
[1m--- a/db/schema/01_core_hr.sql[m
[1m+++ b/db/schema/01_core_hr.sql[m
[36m@@@ -136,12 -136,3 +136,15 @@@[m [mCREATE TABLE LineManager [m
      FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)[m
  );[m
  GO[m
[32m++<<<<<<< HEAD[m
[32m +[m
[32m +CREATE TABLE Employee_Skill ([m
[32m +    employee_id INT,[m
[32m +    skill_id INT,[m
[32m +    proficiency_level VARCHAR(50),[m
[32m +    PRIMARY KEY (employee_id, skill_id),[m
[32m +    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),[m
[32m +    FOREIGN KEY (skill_id) REFERENCES Skill(skill_id)[m
[32m +);[m
[32m++=======[m
[32m++>>>>>>> a8242a66c50695b461c476c7cdb63962ac84fdf7[m

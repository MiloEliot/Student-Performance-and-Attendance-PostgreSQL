alter table students 
add column "age" int;

update students
set "age" =  extract(year from age(current_date, date_of_birth));
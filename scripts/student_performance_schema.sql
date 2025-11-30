-- import student.csv
drop domain if exists student_id_domain cascade;
create domain student_id_domain as text check (value ~ '^S[0-9]+');

drop table if exists students;
create table students(
student_id student_id_domain primary key,
full_name varchar(32),
date_of_birth date,
grade_level text check(grade_level ~ '^Grade [0-9]+'),
emergency_contact text
);

copy students(student_id, full_name, date_of_birth, grade_level, emergency_contact)
from './data/Student_Performance_and_Attendance_PostgreSQL/data/students.csv'
delimiter ','
csv header;


-- import homework.csv
drop table if exists homework;
create table homework( 
homework_id bigint generated always as identity primary key,
student_id student_id_domain references students(student_id)
	on update cascade
	on delete cascade,
subject varchar(32),
assignment_name text,
due_date date,
status text,
grade_feedback varchar(8),
guardian_signature varchar(8)
);

copy homework(student_id, subject, assignment_name, due_date, status, grade_feedback, guardian_signature)
from './data/homework.csv'
delimiter ','
csv header;


-- import attendance.csv
drop table if exists attendance;
create table attendance( 
attendance_id bigint generated always as identity primary key,
student_id student_id_domain references students(student_id)
	on update cascade 
	on delete cascade,
"date" date,
subject varchar(32),
attendance_status varchar(32)
);

copy attendance(student_id, "date", subject, attendance_status)
from './data/attendance.csv'
delimiter ','
csv header;


-- import performance.csv
drop table if exists performance;
create table performance ( 
performance_id bigint generated always as identity primary key,
student_id student_id_domain,
subject varchar(32),
exam_score int,
homework_completion text,
teacher_comments text
);

alter table performance
add constraint student_id_fk
foreign key (student_id)
references students(student_id)
on update cascade
on delete cascade;

copy performance(student_id, subject, exam_score, homework_completion, teacher_comments)
from './data/performance.csv'
delimiter ','
csv header;


-- import teacher_parent_communication.csv
drop table if exists communication;
create table communication ( 
communication_id bigint generated always as identity primary key,
student_id student_id_domain references students(student_id)
	on delete cascade
	on update cascade,
"date" date,
message_type text,
message_content text
);

copy communication(student_id, "date", message_type, message_content)
from './data/teacher_parent_communication.csv'
delimiter ','
csv header;
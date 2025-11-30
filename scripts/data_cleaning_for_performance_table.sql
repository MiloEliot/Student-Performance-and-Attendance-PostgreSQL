-- check the exam_score out of the range in performance table
select min(exam_score), max(exam_score)
from performance;

-- update the exam score exceeding the range 0-100
alter table performance 
add column updated_exam_score int;

update performance
set updated_exam_score=case
	when exam_score > 100 then 100
	else exam_score
end;


-- check the existing data format in the homework_completion
select distinct homework_completion 
from performance;

-- update the data in homework_completion to have consistent format
alter table performance 
add column homework_completion_consistent numeric;

update performance 
set homework_completion_consistent=case
	when homework_completion ~ '^[0-9]+%$' then regexp_substr(homework_completion, '^[0-9]+')::int/100.0
	when homework_completion ~'^-[0-9]+' then 0::numeric
	else homework_completion::int/100.0
end;
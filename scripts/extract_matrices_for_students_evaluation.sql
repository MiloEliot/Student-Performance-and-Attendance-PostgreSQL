-- convert the categorical data to numeric data including attendance_status in attendace and grade_feedback in homework 

do $$
import pandas as pd

query="""
with rate as (
    select 
        student_id,
        case
            when attendance_status = 'present' then 1
            when attendance_status in ('left early', 'late') then 0.5
            else 0
        end as attendance_rate
    from attendance
),
gpa as (
	select
		student_id,
		case 
			when grade_feedback='A+' then 4.3
			when grade_feedback='A' then 4
			when grade_feedback='B' then 3
			when grade_feedback='B-' then 2.7
			when grade_feedback='C' then 2
			when grade_feedback='C-' then 1.7
			when grade_feedback='D' then 1
			else 0
		end as homework_grade
	from homework	
) 
select 
	r. student_id, 
	avg(r.attendance_rate) as avg_rate, 
	avg(p.updated_exam_score) as avg_score, 
	avg(p.homework_completion_consistent) as avg_homework_completion, 
	avg(g.homework_grade) as avg_homework_grade
from rate r
join students s
on r.student_id=s.student_id
join performance p
on p.student_id=s.student_id
join gpa g
on g.student_id=s.student_id
group by r.student_id;"""

result=plpy.execute(query)

df=pd.DataFrame([dict(row) for row in result])

df.to_csv('./outputs/student_evaluation.csv', index=False)

$$ language plpython3u;
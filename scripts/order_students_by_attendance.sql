-- find out the student who has the lowest attendance rate
with total as (
    select student_id, count(*) as total_classes
    from attendance
    group by student_id
),
present as (
    select student_id, count(*) as present
    from attendance
    where attendance_status in ('presence', 'left early', 'late')
    group by student_id
)
select t.student_id,
       round(p.present / t.total_classes::numeric, 2) as present_rate
from total t
join present p
on t.student_id = p.student_id
order by present_rate;
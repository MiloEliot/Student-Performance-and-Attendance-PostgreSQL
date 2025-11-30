-- the unique ways of contacting
select distinct message_type
from communication;

-- the number of each message_type for grade
select s.grade_level, c.message_type, count(c.message_type), rank() over(partition by c.message_type order by count(c.message_type))
from communication c 
join students s 
on c.student_id=s.student_id 
group by c.message_type, s.grade_level
order by c.message_type, s.grade_level;
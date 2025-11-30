select distinct attendance_status from attendance;

update attendance 
set attendance_status=case
	when attendance_status='absnt' then 'absent'
	else lower(trim(attendance_status))
end;

select distinct attendance_status from attendance;
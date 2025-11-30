-- unite the format of status 
do $$
<<block_1>>
declare
	sign1 text;
	sign2 text;
	sign3 text;
begin
	select status into sign1 from homework where homework_id=1;
	select status into sign2 from homework where homework_id=5;
	select status into sign3 from homework where homework_id=11;
	
	alter table homework
	add column consistent_status boolean;
    update homework
	set consistent_status = case 
		when status=sign1 then false
		when status=sign2 then true
		when status=sign3 then true
		when status='Done' then true 
		else false
	end;
end block_1 $$;
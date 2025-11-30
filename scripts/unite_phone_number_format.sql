-- update the emergency_contact to unite the format
alter table students
add column updated_contact text;

update students 
set updated_contact = case
    when emergency_contact ~ '^\+1-[0-9]+-[0-9]+-[a-z0-9]+$'
    then regexp_replace(emergency_contact,
                        '^\+1-([0-9]+)-([0-9]+)-([a-z0-9]+)$',
                        '\1-\2-\3')
    when emergency_contact ~ '^001-([0-9]+)-([0-9]+)-([a-z0-9]+)$'
    then regexp_replace(emergency_contact,
                        '^001-([0-9]+)-([0-9]+)-([a-z0-9]+)$',
                        '\1-\2-\3')
    when emergency_contact ~ '^([0-9]+).([0-9]+).([a-z0-9]+)$'          
    then regexp_replace(emergency_contact,
                        '^([0-9]+).([0-9]+).([a-z0-9]+)$',
                        '\1-\2-\3')
    when emergency_contact ~ '^([0-9]{3})([0-9]{3})([a-z0-9]+)$'          
    then regexp_replace(emergency_contact,
                        '^([0-9]{3})([0-9]{3})([a-z0-9]+)$',
                        '\1-\2-\3')
    when emergency_contact ~ '^\(([0-9]+)\)([0-9]+)-([a-z0-9]+)$'          
    then regexp_replace(emergency_contact,
                        '^\(([0-9]+)\)([0-9]+)-([a-z0-9]+)$',
                        '\1-\2-\3')                 
    else emergency_contact
end;
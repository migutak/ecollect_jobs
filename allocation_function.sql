create or replace FUNCTION get_section(in_accnumber IN varchar2, in_arocode IN varchar2) 
   RETURN varchar2
IS 
   section varchar2(100);
   memo varchar2(100);
   cursor c1 is
     SELECT division
     FROM memogroups
     WHERE memogroup = substr(in_accnumber,3,3);

BEGIN 
   open c1;
   fetch c1 into memo;
   close c1;

	 IF substr(in_arocode, 0,4) = 'CMDR' THEN
      section := 'REMEDIAL';
   ELSIF in_arocode != 'RR0000' THEN
      section := 'REMEDIAL';
   ELSIF memo = 'CMDR' THEN
      section := 'REMEDIAL';
   ELSE
      section := 'Free';

   END IF;
RETURN(section); 
END get_section;
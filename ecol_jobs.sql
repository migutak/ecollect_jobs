-- execute dbms_scheduler.drop_job(job_name => 'ALLOC_JOB');

BEGIN
                Dbms_Scheduler.create_job(
                    job_name   => 'ZERO_JOB'
                   ,job_type   => 'STORED_PROCEDURE' 
                   ,job_action   => 'Default_Zero' -- Procedure Name 2mins
                   ,start_date   => SYSDATE
                   ,repeat_interval => 'freq=daily;byhour=14;byminute=15;bysecond=0'
                   ,enabled   => TRUE
                   ,comments   => 'Assigns default zero balance on null fields Loans_Stage table');
END; 
--
BEGIN
                Dbms_Scheduler.create_job(
                    job_name   => 'assign_section'
                   ,job_type   => 'STORED_PROCEDURE' 
                   ,job_action   => 'assign_section' -- duration ::2min
                   ,start_date   => SYSDATE
                   ,repeat_interval => 'freq=daily;byhour=14;byminute=20;bysecond=0'
                   ,enabled   => TRUE
                   ,comments   => 'Section Assignment');
END; 
--
BEGIN
                Dbms_Scheduler.create_job(
                    job_name   => 'colofficer_cmd'
                   ,job_type   => 'STORED_PROCEDURE' 
                   ,job_action => 'colofficer_cmd' -- duration : 2sec
                   ,start_date   => SYSDATE
                   ,repeat_interval => 'freq=daily;byhour=4;byminute=25;bysecond=0'
                   ,enabled   => TRUE
                   ,comments   => 'Collector allocation CMD');
END; 
--
/*BEGIN
                Dbms_Scheduler.create_job(
                    job_name   => 'ALLOC_JOB'
                   ,job_type   => 'STORED_PROCEDURE' 
                   ,job_action   => 'colofficer_portfolio' -- duration : 
                   ,start_date   => SYSDATE
                   ,repeat_interval => 'freq=daily;byhour=8;byminute=0;bysecond=0'
                   ,enabled   => TRUE
                   ,comments   => 'Collector allocation Portfolio');
END; */
--
BEGIN
                Dbms_Scheduler.create_job(
                    job_name   => 'colofficer_AF'
                   ,job_type   => 'STORED_PROCEDURE' 
                   ,job_action   => 'colofficer_AF'
                   ,start_date   => SYSTIMESTAMP
                   ,repeat_interval => 'freq=daily;byhour=4;byminute=30;bysecond=0'
                   ,enabled   => TRUE
                   ,comments   => 'Collector allocation AF');
END; 
--
/*BEGIN
                Dbms_Scheduler.create_job(
                    job_name   => 'colofficer_AFwithIPF'
                   ,job_type   => 'STORED_PROCEDURE' 
                   ,job_action   => 'colofficer_AFwithIPF' -- duration : 2SEC
                   ,start_date   => SYSDATE
                   ,repeat_interval => 'freq=daily;byhour=6;byminute=20;bysecond=0'
                   ,enabled   => TRUE
                   ,comments   => 'Collector allocation AFwithIPF');
END; */
--
BEGIN
                Dbms_Scheduler.create_job(
                    job_name   => 'colofficer_corporate'
                   ,job_type   => 'STORED_PROCEDURE' 
                   ,job_action   => 'colofficer_corporate' -- duration : 2 SEC
                   ,start_date   => SYSDATE
                   ,repeat_interval => 'freq=daily;byhour=4;byminute=45;bysecond=0'
                   ,enabled   => TRUE
                   ,comments   => 'Collector allocation CORPORATE');
END; 

---
BEGIN
                Dbms_Scheduler.create_job(
                    job_name   => 'job_colofficer_corporate_2'
                   ,job_type   => 'STORED_PROCEDURE' 
                   ,job_action   => 'colofficer_corporate_2' -- duration : 2 SEC
                   ,start_date   => SYSDATE
                   ,repeat_interval => 'freq=daily;byhour=5;byminute=0;bysecond=0'
                   ,enabled   => TRUE
                   ,comments   => 'Collector allocation CORPORATE');
END; 
--
BEGIN
                Dbms_Scheduler.create_job(
                    job_name   => 'colofficer_mcu'
                   ,job_type   => 'STORED_PROCEDURE' 
                   ,job_action   => 'colofficer_mcu' -- duration 10 sec
                   ,start_date   => SYSDATE
                   ,repeat_interval => 'freq=daily;byhour=14;byminute=40;bysecond=0'
                   ,enabled   => TRUE
                   ,comments   => 'Collector allocation MCU');
END; 
--
BEGIN
                Dbms_Scheduler.create_job(
                    job_name   => 'colofficer_sme'
                   ,job_type   => 'STORED_PROCEDURE' 
                   ,job_action   => 'colofficer_sme' -- duration 10 sec
                   ,start_date   => SYSDATE
                   ,repeat_interval => 'freq=daily;byhour=14;byminute=45;bysecond=0'
                   ,enabled   => TRUE
                   ,comments   => 'Collector allocation SME');
END; 
--
BEGIN
                Dbms_Scheduler.create_job(
                    job_name   => 'colofficer_cc'
                   ,job_type   => 'STORED_PROCEDURE' 
                   ,job_action   => 'colofficer_cc' -- 2sec
                   ,start_date   => SYSDATE
                   ,repeat_interval => 'freq=daily;byhour=14;byminute=50;bysecond=0'
                   ,enabled   => TRUE
                   ,comments   => 'Collector allocation credit cards');
END; 
--
BEGIN
                Dbms_Scheduler.create_job(
                    job_name   => 'sendSMS'
                   ,job_type   => 'STORED_PROCEDURE' 
                   ,job_action   => 'sendSMS' -- duration 1.4 sec
                   ,start_date   => SYSDATE
                   ,repeat_interval => 'freq=daily;byhour=14;byminute=55;bysecond=0'
                   ,enabled   => TRUE
                   ,comments   => 'Sends automatic SMS');
END; 
--
BEGIN
                Dbms_Scheduler.create_job(
                    job_name   => 'adddemands'
                   ,job_type   => 'STORED_PROCEDURE' 
                   ,job_action   => 'adddemands' -- duration 1.4 sec
                   ,start_date   => SYSDATE
                   ,repeat_interval => 'freq=daily;byhour=15;byminute=0;bysecond=0'
                   ,enabled   => TRUE
                   ,comments   => 'Adds Demand Letters');
END; 
--
BEGIN
                Dbms_Scheduler.create_job(
                    job_name   => 'chk_allocation'
                   ,job_type   => 'STORED_PROCEDURE' 
                   ,job_action   => 'chk_allocation' -- duration 1.4 sec
                   ,start_date   => SYSDATE
                   ,repeat_interval => 'freq=daily;byhour=6;byminute=0;bysecond=0'
                   ,enabled   => TRUE
                   ,comments   => 'Last Check Allocation');
END; 
---016F7188642000
BEGIN
                Dbms_Scheduler.create_job(
                    job_name   => 'job_bounce_notifications'
                   ,job_type   => 'STORED_PROCEDURE' 
                   ,job_action  => 'bounce_notifications'
                   ,start_date  => SYSDATE
                   ,repeat_interval => 'FREQ=MINUTELY;INTERVAL=1'
                   ,enabled   => TRUE
                   ,comments   => 'bounce unread notifications'
                   );
END; 
----repeat_interval => 'freq=hourly; byminute=0',
--Start bounce_notifications

---- End bounce_notifications

---add accnumebr to tblrollrates
BEGIN
                Dbms_Scheduler.create_job(
                    job_name   => 'job_addrollrate'
                   ,job_type   => 'STORED_PROCEDURE' 
                   ,job_action  => 'addrollrate'
                   ,start_date  => SYSDATE
                   ,repeat_interval => 'freq=daily;byhour=12;byminute=0;bysecond=0'
                   ,enabled   => TRUE
                   ,comments   => 'add new accnumber to tblrollrates'
                );
END; 
----
--- update bucketsfor tblrollrates
BEGIN
                Dbms_Scheduler.create_job(
                    job_name   => 'job_updaterollrate'
                   ,job_type   => 'STORED_PROCEDURE' 
                   ,job_action  => 'addrollrate'
                   ,start_date  => SYSDATE
                   ,repeat_interval => 'freq=daily;byhour=21;byminute=0;bysecond=0'
                   ,enabled   => TRUE
                   ,comments   => 'add new accnumber to tblrollrates'
                );
END; 
----
--- exstaff allocations
BEGIN
                Dbms_Scheduler.create_job(
                    job_name   => 'job_colofficerexstaff'
                   ,job_type   => 'STORED_PROCEDURE' 
                   ,job_action  => 'colofficer_exstaff'
                   ,start_date  => SYSDATE
                   ,repeat_interval => 'freq=daily;byhour=5;byminute=0;bysecond=0'
                   ,enabled   => TRUE
                   ,comments   => 'allocates exstaff accounts'
                );
END; 
----
--- insert into watch_static
BEGIN
                Dbms_Scheduler.create_job(
                    job_name   => 'job_new_watch_static'
                   ,job_type   => 'STORED_PROCEDURE' 
                   ,job_action  => 'new_into_watch_static'
                   ,start_date  => SYSDATE
                   ,repeat_interval => 'freq=daily;byhour=5;byminute=30;bysecond=0'
                   ,enabled   => TRUE
                   ,comments   => 'insert new accounts into watch_static'
                );
END; 
----
--- schedule predlinquent sms day 2
BEGIN
                Dbms_Scheduler.create_job(
                    job_name   => 'job_sendSMS_predelq_day2'
                   ,job_type   => 'STORED_PROCEDURE' 
                   ,job_action  => 'sendSMS_predelq_day2'
                   ,start_date  => SYSDATE
                   ,repeat_interval => 'freq=daily;byhour=11;byminute=0;bysecond=0'
                   ,enabled   => TRUE
                   ,comments   => 'schedule predlinquent sms day 2'
                );
END; 
----
---- schedule predlinquent sms day 5
BEGIN
                Dbms_Scheduler.create_job(
                    job_name   => 'job_sendSMS_predelq_day5'
                   ,job_type   => 'STORED_PROCEDURE' 
                   ,job_action  => 'sendSMS_predelq_day5'
                   ,start_date  => SYSDATE
                   ,repeat_interval => 'freq=daily;byhour=11;byminute=30;bysecond=0'
                   ,enabled   => TRUE
                   ,comments   => 'schedule predlinquent sms day 5'
                );
END; 
----
---- drop and create tbl_q_all
BEGIN
                Dbms_Scheduler.create_job(
                    job_name   => 'job_create_tbl_q_all'
                   ,job_type   => 'STORED_PROCEDURE' 
                   ,job_action  => 'create_tbl_q_all'
                   ,start_date  => SYSDATE
                   ,repeat_interval => 'freq=daily;byhour=7;byminute=30;bysecond=0'
                   ,enabled   => TRUE
                   ,comments   => 'drop and create table tbl_q_all'
                );
END; 
----




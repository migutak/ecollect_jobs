--start create_tbl_q_all
CREATE OR REPLACE procedure ecol.create_tbl_q_all 
AS
BEGIN
  execute immediate 'drop table tbl_q_all';
  execute immediate 'create table tbl_q_all as select * from q_all'; 
  execute immediate 'alter table tbl_q_all add stagedate varchar2(50) default sysdate';
END;
---- End create_tbl_q_all

--start create_tbl_q_portfolio
CREATE OR REPLACE procedure ecol.create_tbl_q_portfolio 
AS
BEGIN
  execute immediate 'drop table tbl_q_portfolio';
  execute immediate 'create table tbl_q_portfolio as select * from q_portfolio';
END;
---- End create_tbl_q_all


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

---- drop and create tbl_q_portfolio
BEGIN
                Dbms_Scheduler.create_job(
                    job_name   => 'job_create_tbl_q_portfolio'
                   ,job_type   => 'STORED_PROCEDURE' 
                   ,job_action  => 'create_tbl_q_portfolio'
                   ,start_date  => SYSDATE
                   ,repeat_interval => 'freq=daily;byhour=8;byminute=30;bysecond=0'
                   ,enabled   => TRUE
                   ,comments   => 'drop and create table tbl_q_portfolio'
                );
END; 
----

---- For admin daily checks

SELECT job_name, log_date, status, actual_start_date, run_duration, cpu_used FROM dba_scheduler_job_run_details where status = 'FAILED';
SELECT job_name, log_date, status FROM dba_scheduler_job_run_details where status = 'FAILED'
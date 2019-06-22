-- Run at 0815 Daily to know status
--SELECT job_name, session_id, running_instance, elapsed_time, cpu_used FROM dba_scheduler_running_jobs;
--SELECT job_name, log_date, status, actual_start_date, run_duration, cpu_used FROM dba_scheduler_job_run_details;
SELECT job_name, log_date, status, actual_start_date, run_duration, cpu_used FROM dba_scheduler_job_run_details where status = 'FAILED';
--job_name, log_date, status, actual_start_date FROM dba_scheduler_job_run_details where status = 'FAILED'; 1057800
SELECT job_name, log_date, status FROM dba_scheduler_job_run_details where status = 'FAILED'

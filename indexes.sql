CREATE INDEX accnumber_port_static_idx ON tbl_portfolio_static (accnumber);
CREATE INDEX custnumber_port_static_idx ON tbl_portfolio_static (custnumber);

CREATE INDEX accnumber_loans_idx ON loans_stage (accnumber);
CREATE INDEX custnumber_loans_idx ON loans_stage (custnumber);

CREATE INDEX accnumber_customers_idx ON customers_stage (accnumber);
CREATE INDEX custnumber_customers_idx ON customers_stage (custnumber);

CREATE INDEX custnumber_notehis_idx ON notehis (custnumber);
CREATE INDEX custnumber_ptps_idx ON ptps (custnumber);

CREATE INDEX custnumber_activitylogs_idx ON activitylogs (custnumber);
CREATE INDEX accountnumber_activitylogs_idx ON activitylogs (accountnumber);
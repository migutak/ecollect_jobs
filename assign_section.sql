--start assign_section
CREATE OR REPLACE procedure assign_section as
BEGIN
	insert into tbl_portfolio_static(accnumber,custnumber,branchcode,datereceived) select distinct accnumber,custnumber,branchcode,stagedate from qnew; --4sec
	insert into TBLcard_STATIC(CARDNUMBER,CARDNAME,CARDACCT,ACCOUNTNO,LIMIT,ADDRESS,CITY,TEL,MOBILE,DAYSINARREARS) select CARDNUMBER,CARDNAME,CARDACCT,ACCOUNTNO,LIMIT,ADDRESS,CITY,TEL,MOBILE,DAYSINARREARS from qnewcards;
	insert into meta(custnumber) select custnumber from Qmetanew;
	insert into meta(custnumber) select cardacct from Qmetanewcc;
	insert into tempcards select cardacct||cardno from quniqcards;
  	update tblcard_static s set s.sqnumber = (select sqnumber from cards_stage c where s.cardnumber = c.cardnumber) where s.sqnumber is null;-- added on 16FEB2017 to resolve missing cards error
	UPDATE TBLcard_STATIC SET TBLcard_STATIC.primary = 'P' where cardacct||sqnumber in( select prim from tempcards);
	delete tempcards;

	update tblcard_static set branchSTATUS = 'Hardcore' where branchSTATUS is null;
	update tblcard_static set cmdSTATUS = 'Hardcore' where cmdSTATUS is null;
	update tblcard_static set routetostate = 'ACTIVE COLLECTION' where routetostate IS NULL;
	update tblcard_static set excuse = 'Hardship' where excuse is null;
	update tbl_portfolio_static set branchSTATUS = 'Hardcore' where branchSTATUS is null;
	update tbl_portfolio_static set cmdSTATUS = 'Hardcore' where cmdSTATUS is null;
	update tbl_portfolio_static set routetostate = 'ACTIVE COLLECTION' where routetostate IS NULL;
	update tbl_portfolio_static set excuse = 'Hardship' where excuse is null;
	--CMDR
	UPDATE tbl_portfolio_static SET section	= 'CMD' where accnumber in (select accnumber from loans_stage where substr(arocode,0,4) = 'CMDR');
	UPDATE tbl_portfolio_static set section = 'CMD' where section is null and substr(accnumber,3,3) IN (SELECT MEMOGROUP from MEMOGROUPS where DIVISION = 'CMDR');
	--STAFF
	UPDATE tbl_portfolio_static set section = 'STAFF' where substr(accnumber,3,2) IN ('6M');
	UPDATE tbl_portfolio_static set section = 'EXSTAFF' where substr(accnumber,3,2) IN ('6G');

	UPDATE tbl_portfolio_static SET section = 'PORTFOLIO' where section is null and accnumber in (select accnumber from loans_stage where substr(arocode,0,4) = 'CMDP');
	UPDATE tbl_portfolio_static SET section = 'PORTFOLIO' where section is null and accnumber in (select accnumber from loans_stage where substr(PRODUCTcode,0,5) ='CAwOD');
	UPDATE tbl_portfolio_static SET section = 'PORTFOLIO' where section is null and accnumber in (select accnumber from loans_stage where substr(PRODUCTcode,0,4) ='Call');
	UPDATE tbl_portfolio_static SET section = 'PORTFOLIO' where section is null and accnumber in (select accnumber from loans_stage where substr(PRODUCTcode,0,3) ='sav');
	UPDATE tbl_portfolio_static SET section = 'PORTFOLIO' where section is null and accnumber in (select accnumber from loans_stage where substr(PRODUCTcode,0,3) ='SAM' and oustbalance <=-1000);
	UPDATE tbl_portfolio_static set section = 'PORTFOLIO' where section is null and substr(accnumber,3,3) IN (SELECT MEMOGROUP from MEMOGROUPS where DIVISION = 'PORTFOLIO');
	UPDATE tbl_portfolio_static SET section = 'PORTFOLIOEXC' where section is null and accnumber in (select accnumber from loans_stage where substr(PRODUCTcode,0,3) ='SAM' and oustbalance >-1000);
	commit;
	--PBBSCHEME
	UPDATE tbl_portfolio_static set section = 'PBBSCHEME' where section is null and substr(accnumber,3,3) IN (SELECT MEMOGROUP from MEMOGROUPS where DIVISION = 'PBBSCHEME');
	--PBBSCORED
	UPDATE tbl_portfolio_static set section = 'PBBSCORED' where section is null and substr(accnumber,3,3) IN (SELECT MEMOGROUP from MEMOGROUPS where DIVISION = 'PBBSCORED');
	-- MORTGAGE
	UPDATE tbl_portfolio_static set section = 'MORTGAGE' where section is null and substr(accnumber,3,3) IN (SELECT MEMOGROUP from MEMOGROUPS where DIVISION = 'MORTGAGE');
	-- ASSET FINANCE
	UPDATE tbl_portfolio_static set section = 'ASSETFINANCE' where section is null and substr(accnumber,3,3) IN (SELECT MEMOGROUP from MEMOGROUPS where DIVISION = 'ASSETFINANCE');
	--IPF
	UPDATE tbl_portfolio_static set section = 'IPF' where section is null and substr(accnumber,3,3) IN (SELECT MEMOGROUP from MEMOGROUPS where DIVISION = 'IPF');
	--CORPORATE
	UPDATE tbl_portfolio_static SET section	= 'CORPORATE' where section is null and accnumber in (select accnumber from loans_stage where substr(arocode,0,4) = 'CORP');
	UPDATE tbl_portfolio_static set section = 'CORPORATE' where section is null and substr(accnumber,3,3) IN (SELECT MEMOGROUP from MEMOGROUPS where DIVISION = 'CORPORATE');
	--SACCO
	UPDATE tbl_portfolio_static set section = 'SACCO' where section is null and substr(accnumber,3,3) IN (SELECT MEMOGROUP from MEMOGROUPS where DIVISION = 'SACCO');
	UPDATE tbl_portfolio_static SET section	= 'SACCO' where section is null and accnumber in (select accnumber from loans_stage where substr(arocode,0,4) = 'SACO');
	UPDATE tbl_portfolio_static SET section	= 'SACCO' where section is null and accnumber in (select accnumber from loans_stage where substr(arocode,0,4) = 'THSE');
	--AGRI
	UPDATE tbl_portfolio_static SET section	= 'AGRIBUSINESS' where  section is null and accnumber in (select accnumber from loans_stage where substr(arocode,0,3) = 'AGR');
	UPDATE tbl_portfolio_static set section = 'AGRIBUSINESS' where 	section is null and substr(accnumber,3,3) IN (SELECT MEMOGROUP from MEMOGROUPS where DIVISION = 'AGRIBUSINESS');
	--SME
	UPDATE tbl_portfolio_static set section = 'SME' where section is null and substr(accnumber,3,3) IN (SELECT MEMOGROUP from MEMOGROUPS where DIVISION = 'SME');
	--MCU
	UPDATE tbl_portfolio_static set section = 'MICROCREDIT' where section is null and substr(accnumber,3,3) IN (SELECT MEMOGROUP from MEMOGROUPS where DIVISION = 'MICROCREDIT');

	update tbl_portfolio_static set colofficer= '' where section = 'PORTFOLIOEXC' and colofficer is not null;
	--update tbl_portfolio_static set colofficer= '' where section = 'PORTFOLIO' and colofficer is not null;
	update tbl_portfolio_static set section = 'SACCO' where section is null and accnumber in (select accnumber from loans_stage where substr(arocode,0,4) = 'SACO');

END;
---- End assign_section




--start create_tbl_q_all
CREATE OR REPLACE procedure ecol.create_tbl_q_all 
AS
BEGIN
  execute immediate 'drop table tbl_q_all';
  execute immediate 'create table tbl_q_all as select * from q_all'; 
  execute immediate 'alter table tbl_q_all add stagedate varchar2(50) default sysdate';
END;
---- End create_tbl_q_all

--start Default_Zero
CREATE OR REPLACE procedure Default_Zero as
BEGIN
	update LOANS_STAGE set PRINCARREARS = 0 where PRINCARREARS is null;
	update LOANS_STAGE set PENALARREARS = 0 where PENALARREARS is null;
	update LOANS_STAGE set INTRATEARR = 0 where INTRATEARR is null;
END;
---- End Default_Zero

--start assign_section
CREATE OR REPLACE procedure assign_section as
BEGIN
	insert into tbl_portfolio_static(accnumber,custnumber,branchcode,datereceived) select distinct accnumber,custnumber,branchcode,stagedate from qnew; --4sec
	insert into TBLcard_STATIC(CARDNUMBER,CARDNAME,CARDACCT,ACCOUNTNO,LIMIT,ADDRESS,CITY,TEL,MOBILE,DAYSINARREARS) select CARDNUMBER,CARDNAME,CARDACCT,ACCOUNTNO,LIMIT,ADDRESS,CITY,TEL,MOBILE,DAYSINARREARS from qnewcards;
	insert into meta(custnumber) select custnumber from Qmetanew;
	insert into meta(custnumber) select cardacct from Qmetanewcc;
  -- delete tempcards;
	insert into tempcards select cardacct||cardno from quniqcards;
  update tblcard_static s set s.sqnumber = (select sqnumber from cards_stage c where s.cardnumber = s.cardnumber);-- added on 16FEB2017 to resolve missing cards error
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

----
CREATE OR REPLACE procedure chk_allocation as
BEGIN
	update tbl_portfolio_static set colofficer= 'echepkosgei' where section ='MORTGAGE' and colofficer is null;
	UPDATE tbl_portfolio_static SET colofficer= 'kmathenge' where section = 'IPF' and colofficer is null;
	--UPDATE tbl_portfolio_static SET colofficer= 'gmwikali' 	where  section = 'AGRIBUSINESS';
	--UPDATE tbl_portfolio_static SET colofficer= 'anyatichi' where  section = 'CORPORATE';
	UPDATE tbl_portfolio_static SET colofficer= 'vnderi' where COLOFFICER IS NULL AND accnumber in (select accnumber from loans_stage where substr(arocode,0,3) = 'THS');
	UPDATE tbl_portfolio_static SET colofficer= 'pmuta'  where COLOFFICER IS NULL AND  substr(accnumber,3,3) IN (SELECT MEMOGROUP from MEMOGROUPS where DIVISION = 'SACCO');
	UPDATE tbl_portfolio_static SET colofficer= 'pmuta'  where COLOFFICER IS NULL AND  accnumber in (select accnumber from loans_stage where substr(arocode,0,3) = 'SAC');

	update tbl_portfolio_static set colofficer = 'ekuria' 	where colofficer is null and section ='PBBSCORED' and custnumber in (select custnumber from loans_stage where DAYSINARR>7 AND DAYSINARR<=30);
	update tbl_portfolio_static set colofficer = 'tgachiri' where colofficer is null and section ='PBBSCORED' and custnumber in (select custnumber from loans_stage where DAYSINARR>30 OR DAYSINARR is null);

	update tbl_portfolio_static set colofficer = 'poloo' 	where colofficer is null and section ='PBBSCHEME' and custnumber in (select custnumber from loans_stage where DAYSINARR>=30 and DAYSINARR<=60);
	--update tbl_portfolio_static set colofficer = 'pmbugua' 	where colofficer not in('pmbugua','poloo') and section ='PBBSCHEME' and custnumber in (select custnumber from loans_stage where DAYSINARR>=30 and DAYSINARR<=60); --CHANGED from 8-30days to 30-60 days on 15/01/2016
  update tbl_portfolio_static set colofficer = 'okyele'  where colofficer not in('okyele','poloo') and section ='PBBSCHEME' and custnumber in (select custnumber from loans_stage where DAYSINARR>=30 and DAYSINARR<=60); --CHANGED from 8-30days to 30-60 days on 15/01/2016

	update tbl_portfolio_static set colofficer = 'njorogem' where colofficer not in('njorogem') and section ='PBBSCHEME' and custnumber in (select custnumber from loans_stage where DAYSINARR>=60);
	--update tbl_portfolio_static set colofficer = 'emwafula' where rownum<=90 and colofficer not in('njorogem','emwafula','okyele') and section ='PBBSCHEME' and custnumber in (select custnumber from loans_stage where DAYSINARR>=60);
	--update tbl_portfolio_static set colofficer = 'okyele' 	where rownum<=90 and colofficer not in('njorogem','emwafula','okyele') and section ='PBBSCHEME' and custnumber in (select custnumber from loans_stage where DAYSINARR>=60);

	update tbl_portfolio_static set colofficer = 'njorogem' where colofficer is null and custnumber in (select custnumber from loans_stage where daysinarr>60 and daysinarr<=90); 
  
END;
-----

----
CREATE OR REPLACE procedure colofficer_AFwithIPF as
  cursor cur is 
    select qassetfinance.colofficer
        from qassetfinance join qipf using(custnumber) for update of qipf.COLOFFICER;
    
    c_f qassetfinance.colofficer%type;
    
begin
  open cur;
  loop
    fetch cur into c_f;
    exit when cur%notfound;
    update tbl_portfolio_static set colofficer=c_f where current of cur;
  end loop;

  close cur;
END;
------

------
CREATE OR REPLACE procedure colofficer_assetfinance as
  cursor cur is 
    select regassetfinance
        from branches join qassetfinance using(branchcode) for update of qassetfinance.COLOFFICER;
    
    c_f branches.regportfolio%type;
    
begin
  open cur;
  loop
    fetch cur into c_f;
    exit when cur%notfound;
    update tbl_portfolio_static set colofficer=c_f where current of cur;
  end loop;

  close cur;
end;
-----

-----
CREATE OR REPLACE procedure colofficer_AF as
  cursor cur is 
    select regassetfinance
        from branches join qassetfinance using(branchcode) for update of qassetfinance.COLOFFICER;
    
    c_f branches.regassetfinance%type;
    
begin
  open cur;
  loop
    fetch cur into c_f;
    exit when cur%notfound;
    update tbl_portfolio_static set colofficer=c_f where current of cur;
  end loop;

  close cur;
end;
----

----
CREATE OR REPLACE procedure colofficer_cc as
  cursor cur is 
    select owner
        from arocodes join qcards on(arocode=cycle) where qcards.cycle!='17'  for update of qcards.COLOFFICER;  
    		c_f arocodes.owner%type;
    
begin
  open cur;
  loop
    fetch cur into c_f;
    exit when cur%notfound;
    update tblcard_static set colofficer=c_f where current of cur;
  end loop;

  close cur;
end;
----

----
CREATE OR REPLACE procedure colofficer_cmd as
  cursor cur is 
    select owner
        from arocodes join qcmd using(arocode) for update of qcmd.COLOFFICER;  
    		c_f arocodes.owner%type;
    
begin
  open cur;
  loop
    fetch cur into c_f;
    exit when cur%notfound;
    update tbl_portfolio_static set colofficer=c_f where current of cur;
  end loop;

  close cur;
end;
----
----
CREATE OR REPLACE procedure colofficer_exstaff as
  cursor cur is 
    select owner
        from arocodes join qexstaff using(arocode) for update of qcmd.COLOFFICER;  
    		c_f arocodes.owner%type;
    
begin
  open cur;
  loop
    fetch cur into c_f;
    exit when cur%notfound;
    update tbl_portfolio_static set colofficer=c_f where current of cur;
  end loop;

  close cur;
end;
---

---
CREATE OR REPLACE procedure colofficer_corporate as
  cursor cur is 
    select owner
        from arocodes join qcorporate using(arocode) for update of qcorporate.COLOFFICER;  
    		c_f arocodes.owner%type;
    
begin
  open cur;
  loop
    fetch cur into c_f;
    exit when cur%notfound;
    update tbl_portfolio_static set colofficer=c_f where current of cur;
  end loop;

  close cur;
end;
--
---
CREATE OR REPLACE procedure colofficer_corporate_2 as
  cursor cur is 
    select owner
        from MEMOGROUPS join qcorporate_2 using(MEMOGROUP) for update of qcorporate_2.COLOFFICER;  
    		c_f arocodes.owner%type;
    
begin
  open cur;
  loop
    fetch cur into c_f;
    exit when cur%notfound;
    update tbl_portfolio_static set colofficer=c_f where current of cur;
  end loop;

  close cur;
end;
--

----
CREATE OR REPLACE procedure colofficer_mcu as
  cursor cur is 
    select regmicrocredit
        from branches join qmicrocredit using(branchcode) for update of qmicrocredit.COLOFFICER;
    c_f branches.regmicrocredit%type;
    
begin
  --open cur;
  --loop
    --fetch cur into c_f;
    --exit when cur%notfound;
    --update tbl_portfolio_static set colofficer=c_f where current of cur;
    -- update tbl_portfolio_static set colofficer='vtatu' where section = 'MICROCREDIT';
    update tbl_portfolio_STATIC set colofficer='vtatu' where colofficer is null and section = 'MICROCREDIT' and accnumber in (select accnumber from loans_stage where daysinarr<=30) and rownum<=10;
    update tbl_portfolio_STATIC set colofficer='bmukhobi' where colofficer is null and section = 'MICROCREDIT' and accnumber in (select accnumber from loans_stage where daysinarr<=30) and rownum<=10;
  --end loop;

  --close cur;
end;
----


---
CREATE OR REPLACE procedure colofficer_sme as
  cursor cur is 
    select regsme
        from branches join qsme using(branchcode) for update of qsme.COLOFFICER;
    
    c_f branches.regmicrocredit%type;
    
begin
  --open cur;
  --loop
    --fetch cur into c_f;
    --exit when cur%notfound;
    update tbl_portfolio_static set colofficer='bmukhobi' where section = 'SME' and accnumber in (select accnumber from loans_stage where daysinarr>30;
    update tbl_portfolio_STATIC set colofficer='ikimari' where section = 'SME' and accnumber in (select accnumber from loans_stage where daysinarr<=30);
  --end loop;

  --close cur;
end;
---


---
CREATE OR REPLACE procedure colofficer_portfolio as
  cursor cur is 
    select regportfolio
        from branches join qportfolio using(branchcode) for update of qportfolio.COLOFFICER;
    
    c_f branches.regportfolio%type;
    
	begin
	  open cur;
	  loop
	    fetch cur into c_f;
	    exit when cur%notfound;
	    update tbl_portfolio_static set colofficer=c_f where current of cur;
	  end loop;

	  close cur;
	end;
---

----
CREATE OR REPLACE procedure adddemands as
begin
	insert into demandsdue (ACCNUMBER,CUSTNUMBER,ORIGDATE,CURRENCY,ORIGBALANCE,OUSTBALANCE,INSTAMOUNT,PRINCARREARS,PENALARREARS
	,INTRATEARR,PRODUCTCODE,AROCODE,BRANCHCODE,INTRATE,DAYSINARR,MATDATE,LASTCREDAMNT,LASTCREDDATE,SECTORCODE,LASTPAYDATE
	,NEXTREPAYDATE,SETTLEACCNO,SETTLEACCBAL,STAGEDATE,BRANCHNAME,AROBRANCH,ARONAME,SECTION,COLOFFICER,REVIEWDATE,EXCUSE,ROUTETOSTATE,
	CMDSTATUS,CURING,BRANCHSTATUS,TOTALARREARS,DEMAND
	) 
	select ACCNUMBER,CUSTNUMBER,ORIGDATE,CURRENCY,ORIGBALANCE,OUSTBALANCE,INSTAMOUNT,PRINCARREARS,PENALARREARS,INTRATEARR,PRODUCTCODE,
	 AROCODE,BRANCHCODE,INTRATE,DAYSINARR,MATDATE,LASTCREDAMNT,LASTCREDDATE,SECTORCODE,LASTPAYDATE,NEXTREPAYDATE,SETTLEACCNO
	,SETTLEACCBAL,STAGEDATE,BRANCHNAME,AROBRANCH,ARONAME,SECTION,COLOFFICER,REVIEWDATE,EXCUSE,ROUTETOSTATE
	,CMDSTATUS,CURING,BRANCHSTATUS,TOTALARREARS,'Demand 1' from tbl_portfolio where section in('PBBSCHEME','PBBSCORED') and daysinarr in ('30');

	insert into demandsdue (ACCNUMBER,CUSTNUMBER,ORIGDATE,CURRENCY,ORIGBALANCE,OUSTBALANCE,INSTAMOUNT,PRINCARREARS,PENALARREARS
	,INTRATEARR,PRODUCTCODE,AROCODE,BRANCHCODE,INTRATE,DAYSINARR,MATDATE,LASTCREDAMNT,LASTCREDDATE,SECTORCODE,LASTPAYDATE
	,NEXTREPAYDATE,SETTLEACCNO,SETTLEACCBAL,STAGEDATE,BRANCHNAME,AROBRANCH,ARONAME,SECTION,COLOFFICER,REVIEWDATE,EXCUSE,ROUTETOSTATE,
	CMDSTATUS,CURING,BRANCHSTATUS,TOTALARREARS,DEMAND
	) 
	select ACCNUMBER,CUSTNUMBER,ORIGDATE,CURRENCY,ORIGBALANCE,OUSTBALANCE,INSTAMOUNT,PRINCARREARS,PENALARREARS,INTRATEARR,PRODUCTCODE,
	 AROCODE,BRANCHCODE,INTRATE,DAYSINARR,MATDATE,LASTCREDAMNT,LASTCREDDATE,SECTORCODE,LASTPAYDATE,NEXTREPAYDATE,SETTLEACCNO
	,SETTLEACCBAL,STAGEDATE,BRANCHNAME,AROBRANCH,ARONAME,SECTION,COLOFFICER,REVIEWDATE,EXCUSE,ROUTETOSTATE
	,CMDSTATUS,CURING,BRANCHSTATUS,TOTALARREARS,'Demand 2' from tbl_portfolio where section in('PBBSCHEME','PBBSCORED') and daysinarr in ('45');

	insert into demandsdue (ACCNUMBER,CUSTNUMBER,ORIGDATE,CURRENCY,ORIGBALANCE,OUSTBALANCE,INSTAMOUNT,PRINCARREARS,PENALARREARS
	,INTRATEARR,PRODUCTCODE,AROCODE,BRANCHCODE,INTRATE,DAYSINARR,MATDATE,LASTCREDAMNT,LASTCREDDATE,SECTORCODE,LASTPAYDATE
	,NEXTREPAYDATE,SETTLEACCNO,SETTLEACCBAL,STAGEDATE,BRANCHNAME,AROBRANCH,ARONAME,SECTION,COLOFFICER,REVIEWDATE,EXCUSE,ROUTETOSTATE,
	CMDSTATUS,CURING,BRANCHSTATUS,TOTALARREARS,DEMAND
	) 
	select ACCNUMBER,CUSTNUMBER,ORIGDATE,CURRENCY,ORIGBALANCE,OUSTBALANCE,INSTAMOUNT,PRINCARREARS,PENALARREARS,INTRATEARR,PRODUCTCODE,
	 AROCODE,BRANCHCODE,INTRATE,DAYSINARR,MATDATE,LASTCREDAMNT,LASTCREDDATE,SECTORCODE,LASTPAYDATE,NEXTREPAYDATE,SETTLEACCNO
	,SETTLEACCBAL,STAGEDATE,BRANCHNAME,AROBRANCH,ARONAME,SECTION,COLOFFICER,REVIEWDATE,EXCUSE,ROUTETOSTATE
	,CMDSTATUS,CURING,BRANCHSTATUS,TOTALARREARS,'Demand 3' from tbl_portfolio where section in('PBBSCHEME','PBBSCORED') and daysinarr in ('60');
	--mcu letters
	insert into demandsdue (ACCNUMBER,CUSTNUMBER,ORIGDATE,CURRENCY,ORIGBALANCE,OUSTBALANCE,INSTAMOUNT,PRINCARREARS,PENALARREARS
	,INTRATEARR,PRODUCTCODE,AROCODE,BRANCHCODE,INTRATE,DAYSINARR,MATDATE,LASTCREDAMNT,LASTCREDDATE,SECTORCODE,LASTPAYDATE
	,NEXTREPAYDATE,SETTLEACCNO,SETTLEACCBAL,STAGEDATE,BRANCHNAME,AROBRANCH,ARONAME,SECTION,COLOFFICER,REVIEWDATE,EXCUSE,ROUTETOSTATE,
	CMDSTATUS,CURING,BRANCHSTATUS,TOTALARREARS,DEMAND
	) 
	select ACCNUMBER,CUSTNUMBER,ORIGDATE,CURRENCY,ORIGBALANCE,OUSTBALANCE,INSTAMOUNT,PRINCARREARS,PENALARREARS,INTRATEARR,PRODUCTCODE,
	 AROCODE,BRANCHCODE,INTRATE,DAYSINARR,MATDATE,LASTCREDAMNT,LASTCREDDATE,SECTORCODE,LASTPAYDATE,NEXTREPAYDATE,SETTLEACCNO
	,SETTLEACCBAL,STAGEDATE,BRANCHNAME,AROBRANCH,ARONAME,SECTION,COLOFFICER,REVIEWDATE,EXCUSE,ROUTETOSTATE
	,CMDSTATUS,CURING,BRANCHSTATUS,TOTALARREARS,'Demand 1' from tbl_portfolio where section in('ASSETFINANCE','MICROCREDIT') and daysinarr in ('7');

	insert into demandsdue (ACCNUMBER,CUSTNUMBER,ORIGDATE,CURRENCY,ORIGBALANCE,OUSTBALANCE,INSTAMOUNT,PRINCARREARS,PENALARREARS
	,INTRATEARR,PRODUCTCODE,AROCODE,BRANCHCODE,INTRATE,DAYSINARR,MATDATE,LASTCREDAMNT,LASTCREDDATE,SECTORCODE,LASTPAYDATE
	,NEXTREPAYDATE,SETTLEACCNO,SETTLEACCBAL,STAGEDATE,BRANCHNAME,AROBRANCH,ARONAME,SECTION,COLOFFICER,REVIEWDATE,EXCUSE,ROUTETOSTATE,
	CMDSTATUS,CURING,BRANCHSTATUS,TOTALARREARS,DEMAND
	) 
	select ACCNUMBER,CUSTNUMBER,ORIGDATE,CURRENCY,ORIGBALANCE,OUSTBALANCE,INSTAMOUNT,PRINCARREARS,PENALARREARS,INTRATEARR,PRODUCTCODE,
	 AROCODE,BRANCHCODE,INTRATE,DAYSINARR,MATDATE,LASTCREDAMNT,LASTCREDDATE,SECTORCODE,LASTPAYDATE,NEXTREPAYDATE,SETTLEACCNO
	,SETTLEACCBAL,STAGEDATE,BRANCHNAME,AROBRANCH,ARONAME,SECTION,COLOFFICER,REVIEWDATE,EXCUSE,ROUTETOSTATE
	,CMDSTATUS,CURING,BRANCHSTATUS,TOTALARREARS,'Demand 1' from tbl_portfolio where section in('CORPORATE','SACCO','MORTGAGE','AGRIBUSINESS') and daysinarr in ('15');

	insert into demandsdue (ACCNUMBER,CUSTNUMBER,ORIGDATE,CURRENCY,ORIGBALANCE,OUSTBALANCE,INSTAMOUNT,PRINCARREARS,PENALARREARS
	,INTRATEARR,PRODUCTCODE,AROCODE,BRANCHCODE,INTRATE,DAYSINARR,MATDATE,LASTCREDAMNT,LASTCREDDATE,SECTORCODE,LASTPAYDATE
	,NEXTREPAYDATE,SETTLEACCNO,SETTLEACCBAL,STAGEDATE,BRANCHNAME,AROBRANCH,ARONAME,SECTION,COLOFFICER,REVIEWDATE,EXCUSE,ROUTETOSTATE,
	CMDSTATUS,CURING,BRANCHSTATUS,TOTALARREARS,DEMAND
	) 
	select ACCNUMBER,CUSTNUMBER,ORIGDATE,CURRENCY,ORIGBALANCE,OUSTBALANCE,INSTAMOUNT,PRINCARREARS,PENALARREARS,INTRATEARR,PRODUCTCODE,
	 AROCODE,BRANCHCODE,INTRATE,DAYSINARR,MATDATE,LASTCREDAMNT,LASTCREDDATE,SECTORCODE,LASTPAYDATE,NEXTREPAYDATE,SETTLEACCNO
	,SETTLEACCBAL,STAGEDATE,BRANCHNAME,AROBRANCH,ARONAME,SECTION,COLOFFICER,REVIEWDATE,EXCUSE,ROUTETOSTATE
	,CMDSTATUS,CURING,BRANCHSTATUS,TOTALARREARS,'Demand 2' from tbl_portfolio where section in('CORPORATE','SACCO','MORTGAGE','AGRIBUSINESS','ASSETFINANCE') and daysinarr in ('30');

	insert into demandsdue (ACCNUMBER,CUSTNUMBER,ORIGDATE,CURRENCY,ORIGBALANCE,OUSTBALANCE,INSTAMOUNT,PRINCARREARS,PENALARREARS
	,INTRATEARR,PRODUCTCODE,AROCODE,BRANCHCODE,INTRATE,DAYSINARR,MATDATE,LASTCREDAMNT,LASTCREDDATE,SECTORCODE,LASTPAYDATE
	,NEXTREPAYDATE,SETTLEACCNO,SETTLEACCBAL,STAGEDATE,BRANCHNAME,AROBRANCH,ARONAME,SECTION,COLOFFICER,REVIEWDATE,EXCUSE,ROUTETOSTATE,
	CMDSTATUS,CURING,BRANCHSTATUS,TOTALARREARS,DEMAND
	) 
	select ACCNUMBER,CUSTNUMBER,ORIGDATE,CURRENCY,ORIGBALANCE,OUSTBALANCE,INSTAMOUNT,PRINCARREARS,PENALARREARS,INTRATEARR,PRODUCTCODE,
	 AROCODE,BRANCHCODE,INTRATE,DAYSINARR,MATDATE,LASTCREDAMNT,LASTCREDDATE,SECTORCODE,LASTPAYDATE,NEXTREPAYDATE,SETTLEACCNO
	,SETTLEACCBAL,STAGEDATE,BRANCHNAME,AROBRANCH,ARONAME,SECTION,COLOFFICER,REVIEWDATE,EXCUSE,ROUTETOSTATE
	,CMDSTATUS,CURING,BRANCHSTATUS,TOTALARREARS,'Demand 3' from tbl_portfolio where section in('CORPORATE','SACCO','MORTGAGE','AGRIBUSINESS','ASSETFINANCE') and daysinarr in ('60');

	insert into demandsdue (ACCNUMBER,CUSTNUMBER,ORIGDATE,CURRENCY,ORIGBALANCE,OUSTBALANCE,INSTAMOUNT,PRINCARREARS,PENALARREARS
	,INTRATEARR,PRODUCTCODE,AROCODE,BRANCHCODE,INTRATE,DAYSINARR,MATDATE,LASTCREDAMNT,LASTCREDDATE,SECTORCODE,LASTPAYDATE
	,NEXTREPAYDATE,SETTLEACCNO,SETTLEACCBAL,STAGEDATE,BRANCHNAME,AROBRANCH,ARONAME,SECTION,COLOFFICER,REVIEWDATE,EXCUSE,ROUTETOSTATE,
	CMDSTATUS,CURING,BRANCHSTATUS,TOTALARREARS,DEMAND
	) 
	select ACCNUMBER,CUSTNUMBER,ORIGDATE,CURRENCY,ORIGBALANCE,OUSTBALANCE,INSTAMOUNT,PRINCARREARS,PENALARREARS,INTRATEARR,PRODUCTCODE,
	 AROCODE,BRANCHCODE,INTRATE,DAYSINARR,MATDATE,LASTCREDAMNT,LASTCREDDATE,SECTORCODE,LASTPAYDATE,NEXTREPAYDATE,SETTLEACCNO
	,SETTLEACCBAL,STAGEDATE,BRANCHNAME,AROBRANCH,ARONAME,SECTION,COLOFFICER,REVIEWDATE,EXCUSE,ROUTETOSTATE
	,CMDSTATUS,CURING,BRANCHSTATUS,TOTALARREARS,'Demand 2' from tbl_portfolio where section in('MICROCREDIT') and daysinarr in ('14');

	insert into demandsdue (ACCNUMBER,CUSTNUMBER,ORIGDATE,CURRENCY,ORIGBALANCE,OUSTBALANCE,INSTAMOUNT,PRINCARREARS,PENALARREARS
	,INTRATEARR,PRODUCTCODE,AROCODE,BRANCHCODE,INTRATE,DAYSINARR,MATDATE,LASTCREDAMNT,LASTCREDDATE,SECTORCODE,LASTPAYDATE
	,NEXTREPAYDATE,SETTLEACCNO,SETTLEACCBAL,STAGEDATE,BRANCHNAME,AROBRANCH,ARONAME,SECTION,COLOFFICER,REVIEWDATE,EXCUSE,ROUTETOSTATE,
	CMDSTATUS,CURING,BRANCHSTATUS,TOTALARREARS,DEMAND
	) 
	select ACCNUMBER,CUSTNUMBER,ORIGDATE,CURRENCY,ORIGBALANCE,OUSTBALANCE,INSTAMOUNT,PRINCARREARS,PENALARREARS,INTRATEARR,PRODUCTCODE,
	 AROCODE,BRANCHCODE,INTRATE,DAYSINARR,MATDATE,LASTCREDAMNT,LASTCREDDATE,SECTORCODE,LASTPAYDATE,NEXTREPAYDATE,SETTLEACCNO
	,SETTLEACCBAL,STAGEDATE,BRANCHNAME,AROBRANCH,ARONAME,SECTION,COLOFFICER,REVIEWDATE,EXCUSE,ROUTETOSTATE
	,CMDSTATUS,CURING,BRANCHSTATUS,TOTALARREARS,'Demand 3' from tbl_portfolio where section in('MICROCREDIT') and daysinarr in ('21');
	-----end
end;
----

----
CREATE OR REPLACE procedure sendSMS as
  cursor cur is 
    select c.custnumber,c.TELNUMBER,(p.PRINCARREARS+p.PENALARREARS+p.INTRATEARR) Arrears 
    from tbl_portfolio p, CUSTOMERS_STAGE c where p.custnumber=c.custnumber and p.DAYSINARR = '8' and section = 'PBBSCORED'and c.TELNUMBER is not null;
  
    cust tbl_portfolio.custnumber%type;
    tel tbl_portfolio.custnumber%type;
    arr tbl_portfolio.custnumber%type;
    
	begin
	  open cur;
	  loop
	    fetch cur into cust,tel,arr;
	    exit when cur%notfound;
	    insert into sms(custnumber,telnumber,arrears) values(cust,tel,arr);
	    update sms set owner = 'AutoDAY8' where owner is null; -- changed Auto to AutoDAY8 on 05JUNE
			update sms set message = 'Dear Customer, Your loan payment is late by 8 days. Amount in arrears is Kes '||arrears||'. Please pay within seven days. Enquire details on 0711049000/020-3276000.' where message is null;

	  end loop;
	  close cur;
	end;
---

----sms predelq day 5
CREATE OR REPLACE procedure sendSMS_predelq_day5 as
  cursor cur is 
    select custnumber,CELNUMBER,repaymentamount,NEXTPAYMENT,currency
    from qsmspredelq_day5;
  
    cust qsmspredelq_day5.custnumber%type;
    tel qsmspredelq_day5.CELNUMBER%type;
    arr qsmspredelq_day5.repaymentamount%type;
    nextpayment qsmspredelq_day5.nextpayment%type;
    currency qsmspredelq_day5.currency%type;
    
	begin
	  open cur;
	  loop
	    fetch cur into cust,tel,arr,nextpayment,currency;
	    exit when cur%notfound;
	    insert into sms(custnumber,telnumber,arrears,owner,message) values(cust,tel,arr,'AutoPREDLQ5','Dear Customer, Your loan payment is due on '||nextpayment||'. Amount to be paid is '||currency||' '||arr||'. To make deposit, visit our branch, agent or M-Pesa PayBill 400200.Enquire details on 0711049000/020-3276000.');
	  --update sms set owner = 'Auto' where owner is null;
		--update sms set message = 'Dear Customer, Your loan payment is due on '||nextpayment||'. Amount to be paid is '||currency||' '||arr||'. To make deposit, visit our branch, agent or M-Pesa PayBill 400200.Enquire details on 0711049000/020-3276000.' where message is null;
	  end loop;
	  close cur;
end;
---

----sms predelq day 2
CREATE OR REPLACE procedure sendSMS_predelq_day2 as
  cursor cur is 
    select custnumber,CELNUMBER,repaymentamount,NEXTPAYMENT,currency
    from qsmspredelq_day2;
  
    cust qsmspredelq_day2.custnumber%type;
    tel qsmspredelq_day2.CELNUMBER%type;
    arr qsmspredelq_day2.repaymentamount%type;
    nextpayment qsmspredelq_day2.nextpayment%type;
    currency qsmspredelq_day2.currency%type;
    
	begin
	  open cur;
	  loop
	    fetch cur into cust,tel,arr,nextpayment,currency;
	    exit when cur%notfound;
	    insert into sms(custnumber,telnumber,arrears,owner,message) values(cust,tel,arr,'AutoPREDLQ2','Dear Customer, Your loan payment is due on '||nextpayment||'. Amount to be paid is '||currency||' '||arr||'. To make deposit, visit our branch, agent or M-Pesa PayBill 400200.Enquire details on 0711049000/020-3276000.');
	    --update sms set owner = 'Auto' where owner is null;
		--update sms set message = 'Dear Customer, Your loan payment is due on '||nextpayment||'. Amount to be paid is '||currency||' '||arr||'. To make deposit, visit our branch, agent or M-Pesa PayBill 400200.Enquire details on 0711049000/020-3276000.' where message is null;
	  end loop;
	  close cur;
end;
---

---- Add new accnumber to tblrollrates
CREATE OR REPLACE procedure addrollrate as
BEGIN
	Insert into tblrollrates(accnumber,custnumber,branchcode,colofficer,section) 
		select accnumber,custnumber,branchcode,colofficer,section from tbl_portfolio 
			where accnumber not in (select accnumber from tblrollrates);
END;
----
---- Update bucket in tblrollrates
CREATE OR REPLACE procedure updaterollrate as
BEGIN
	UPDATE tblrollrates SET Jul_2016 = (SELECT tbl_portfolio.bucket
            FROM tbl_portfolio WHERE tblrollrates.accnumber = tbl_portfolio.accnumber)
	WHERE EXISTS (SELECT tbl_portfolio.accnumber
            FROM tbl_portfolio 
            WHERE tblrollrates.accnumber = tbl_portfolio.accnumber);
END;
---
--start new into watch_static
CREATE OR REPLACE procedure new_into_watch_static as
BEGIN
	insert into watch_static(accnumber) select accnumber from watch_stage where accnumber not in (select accnumber from watch_static);
END;
---- End new into watch_static

----card collector update---
alter table tblcard_static add cycle  int;
--///--
UPDATE tblcard_static t1
   SET (cycle) = (select t2.cycle from cards_stage t2 where t1.cardnumber = t2.cardnumber)
     WHERE EXISTS (
        select 1 from cards_stage t2 where t1.cardnumber = t2.cardnumber);
--///--
UPDATE tblcard_static t1
   SET (colofficer) = (select t2.owner from arocodes t2 where to_char(t1.cycle) = t2.arocode)
     WHERE EXISTS (
        SELECT 1 from arocodes t2 where to_char(t1.cycle) = t2.arocode);
--///--
UPDATE tblcard_static SET tblcard_static.colofficer = (SELECT arocodes.owner
              FROM arocodes where to_char(tblcard_static.cycle) = arocodes.arocode)
WHERE tblcard_static.colofficer is not null
AND EXISTS (SELECT arocodes.owner
    FROM arocodes where to_char(tblcard_static.cycle) = arocodes.arocode);

---end card collector update---





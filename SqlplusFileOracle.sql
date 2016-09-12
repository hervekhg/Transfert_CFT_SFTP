SET ECHO OFF
SET HEAD OFF
SET FEED OFF
SPOOL /exec/71m/atm2/soutien/envoi_stats/result/tmp.csv
SET TRIMSPOOL ON
SET TERMOUT OFF
SET PAGESIZE 0
SET TERM OFF
SET AUTOTRACE OFF
SET VERIFY OFF
SET FEEDBACK OFF
set LINESIZE 500
--SPOOL '&1';

-- sqlplus -S Prod_Masse_SEBA.sql \@sql/Prod_.sql ./result/test.csv
select 'SEBA' || ';' || m_dateandhour || ';'||  m_eventreque || ';' || m_eventt || ';' || m_dateandhou  || ';' || m_exception || ';' || substr (m_parametersevent,1,20) || ';' || m_result
from PRIMARYEVENTI
where to_date(m_dateandhourstart, 'YYYY/MM/DD HH24:MI:SS') > to_date(to_char(SYSDATE, 'YYYYMMDD') || ' 020000', 'YYYYMMDD HH24MISS')
and to_date(m_dateandhourstart, 'YYYY/MM/DD HH24:MI:SS') < to_date(to_char(SYSDATE, 'YYYYMMDD') || ' 050000', 'YYYYMMDD HH24MISS')
order by m_dateandhourstart desc;    
   

SPOOL OFF;
QUIT;
/

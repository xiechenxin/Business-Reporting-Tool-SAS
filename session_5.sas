libname sec5 'C:\Users\cxie\Desktop\BAT-Comm\SESSION_5';
data sec5.realmadrid;
infile 'C:\Users\cxie\Desktop\BAT-Comm\SESSION_5\fifa_realmadrid.csv' DLM=',' firstobs=2 DSD TRUNCOVER;
input Name :$30. Age Nationality :$25. overall Wage Joined_Date yymmdd10.;
;
proc print data=sec5.realmadrid;
run;

proc univariate data=sec5.realmadrid;
  VAR Age Wage;
  run;

proc sort data=sec5.realmadrid;
by Wage;
run;

data _null_;
set sec5.realmadrid;
file 'C:\Users\cxie\Desktop\BAT-Comm\SESSION_5\player_report.txt' print;
put 'Player ' Name '(' Nationality '), ' Age ' years old, earns ' overall DOLLAR7. 'k per week.' / 'He joined Real Madrid on ' Joined_Date wordDATE18. ' . ';
put _page_;
run;


data sec5.tranfer;
infile 'C:\Users\cxie\Desktop\BAT-Comm\SESSION_5\transfers.csv' DLM=',' firstobs=2 DSD;
input Name $ Age Nationality $ overall Wage Joined_Date yymmdd10.;
run;
proc print data=sec5.tranfer;
run;

data sec5.realmadrid_upd;
set sec5.realmadrid sec5.tranfer;
run;
proc print data=sec5.realmadrid_upd;
run;

data sec5.interlands;
infile 'C:\Users\cxie\Desktop\BAT-Comm\SESSION_5\interlands.txt' DLM='09'X firstobs=2 DSD TRUNCOVER;
input Nationality $ 0-18  Dummy_play :2.;
IF Nationality = 'BE' THEN Nationality = 'Belgium';
run;

proc sort data=sec5.realmadrid_upd;
by Nationality;
run;
proc sort data=sec5.interlands;
by Nationality;
run;

data sec5.realmadrid_upd2;
merge sec5.realmadrid_upd sec5.interlands;
by Nationality;
run;
proc print data=sec5.realmadrid_upd2;
run;

data sec5.interlands2;
infile 'C:\Users\cxie\Desktop\BAT-Comm\SESSION_5\interlands_2.txt' DLM='09'X firstobs=2 DSD TRUNCOVER;
input Nationality $ 0-18  Dummy_play :2.;
IF Nationality = 'BE' THEN Nationality = 'Belgium';
run;
proc sort data=sec5.realmadrid_upd;
by Nationality;
run;
proc sort data=sec5.interlands2;
by Nationality;
run;
data sec5.realmadrid_upd3;
merge sec5.realmadrid_upd (IN= InNation) sec5.interlands2;
by Nationality;
IF InNation=1;
run;
proc print data=sec5.realmadrid_upd3;
run;


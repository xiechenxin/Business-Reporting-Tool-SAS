libname churn "C:\Users\cxie\Desktop\BAT-Comm\class_execise_chun"; run;
Data churn_ds;
set "C:\Users\cxie\Desktop\BAT-Comm\class_execise_chun\churn.sas7bdat";
mon_purch_dol = mon_purch * 1.15;
run;

data churners;
set churn_ds;
if churn = 'Y';
run;

data non_churners;
set churn_ds;
if churn = 'N';
run;

data churn_ds2;
set churners non_churners;
run;

proc print data=churn_ds2;
run;

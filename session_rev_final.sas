/* Reading in data */


*1) list input with blank as delimiter with standard variable length;
data input1;
infile "C:\MBD\REV_1\input1.txt";
input id name $ product $ dollar;
run;



* list input with blank as delimiter with data-adjusted variable length;
data input1;
infile "C:\MBD\REV_1\input1.txt";
input id name :$20. product $ dollar;
run;

*2) list input with , as delimiter;
data input2;
infile "C:\MBD\REV_1\input2.txt"
dlm = ',';
input id name $ product $ dollar;
run;

*You can do the same using PROC IMPORT, but remember it is not allowed on the final exam. You should know it for the certification though;
proc import datafile = "C:\MBD\REV_1\input2.txt"
out = input2 replace; delimiter = ','; getnames = no; run;

*3) list input with , as delimiter with DSD
- removes "" in character values
- considers two delimiters as missing 
- it ignores delimiters in "";
data input3;
infile "C:\MBD\REV_1\input3.txt"
dlm = ',' dsd;
input id name $ product $ dollar;
run;

data input3_adj;
infile "C:\MBD\REV_1\input3_adj.txt"
dlm = ',' dsd;
input id name $ product $ dollar;
run;




*4) list input with semicolon as delimiter;
data input4;
infile "C:\MBD\REV_1\input4.txt"
dlm = ';';
input id name $ product $ dollar;
run;

*5) list input with blank as delimiter and indicated missing values;
data input5;
infile "C:\MBD\REV_1\input5.txt";
input id name $ product $ dollar;
run;

*6) list input with blank as delimiter and non-indicated missing values;
data input6;
infile "C:\MBD\REV_1\input6.txt"
missover;
input id name $ product $ dollar;
run;

*7) column & list input;
data input7;
infile "C:\MBD\REV_1\input7.txt";
input id 1-2 name $3-9 @10 product $ @16 dollar;
run;

*8) column & list input with indicated missing values;
data input8;
infile "C:\MBD\REV_1\input8.txt";
input id 1-2 name $3-9 @10 product $ @16 dollar;
run;

*9) column & list input with non-indicated missing values;
data input9;
infile "C:\MBD\REV_1\input9.txt"
missover;
input id 1-2 name $3-9 @10 product $ @16 dollar;
run;

* column & list input with non-indicated missing values & column input in last column;

/* If you would use missover, shorter values than the specified column input would be considered as missings!!! */
/* check for yourself: */
/*
data input9;
infile "C:\MBD\REV_1\input9.txt"
missover;
input id 1-2 name $3-9 @10 product $ dollar 16-20 ;
run;
*/

data input9;
infile "C:\Users\cxie\Desktop\BAT-Comm\Additional\input9.txt"
truncover;
input id 1-2 name $3-9 @10 product $ dollar 16-20 ;
run;


*10) list input with blank as delimiter;
data input10;
infile "C:\Users\cxie\Desktop\BAT-Comm\Additional\input10.txt";
input id name $ product $ dollar  @@;
run;

*11) proc print;
data input11;
infile "C:\Users\cxie\Desktop\BAT-Comm\Additional\input11.txt";
input id name $ product $ dollar;
run;

/* Note: if you don't specify DATA in proc print, SAS takes the lastest by default. */
proc print;
run;

*using format statement for dollar;
proc print;
format dollar dollar10.;
run;

/* Note: Data has not changed. */

data input11;
format dollar dollar6.;
set input11;
run;

/* Note: Data has changed. */
proc print;
run;

proc print;
format dollar dollar10.;
run;

*using format statement for dollar
only for product A;
proc print;
format dollar dollar10.;
where product in ("A");
run;

*using format statement for dollar
only for product A
amount money spent > 100;
proc print;
format dollar dollar10.;
where product="A" and dollar > 100;
run;

*using format statement for dollar
only for product A
amount money spent > 100
only name;
proc print;
var name;
format dollar dollar10.;
where product in ("A") and dollar > 100;
run;

*12) define new variable 
euro - 1 euro = 1.10 dollar
day_analysis - today
convert names to uppercase;
data input12;
format euro 6.2;
infile "C:\Users\cxie\Desktop\BAT-Comm\Additional\input12.txt";
input id name $ product $ dollar;
euro = dollar/1.10;
day_analysis1 = today();
day_analysis2 = mdy(11,10,2017);
name = upcase(name);
run;

* print the dataset using a format for the currencies & dates;
proc print;
format day_analysis1 mmddyy10. 
day_analysis2 mmddyy10.
euro euro8.2
dollar dollar8.2;
run; 


*13) define new variable profit - if-then 
product A = dollar * 0.5
product B = dollar * 0.4
product C = dollar * 0.9;
data input13;
format profit 10.2;
infile "C:\Users\cxie\Desktop\BAT-Comm\Additional\input13.txt";
input id name $ product $ dollar;
if product = 'A' then profit = dollar * 0.5;
else if product = 'B' then profit = dollar * 0.4;
else profit = dollar * 0.9;
run;

*14) subset data - if
if product ~= 'B';
data input14;
infile "C:\Users\cxie\Desktop\BAT-Comm\Additional\input14.txt";
input id name $ product $ dollar;
if product ~= 'B';
run;

*14) retaining
dollar_total1 = total amount spent
dollar_total2 = total amount spent this quarter + total amount spent previous quarter + 5000;


data input14;
infile "C:\Users\cxie\Desktop\BAT-Comm\Additional\input14.txt";
input id name $ product $ dollar;
dollar_total1 + dollar;
retain dollar_total2 5000;
dollar_total2 = dollar_total2 + dollar;
run;
/* Note that a sum statement also retains the values! */


/* Note it is easier to set a libname, you should also be able to set a libname on the exam!! */
libname k "C:\Users\cxie\Desktop\BAT-Comm";run;

*15) Array = create output15 using input15
convert all dollar variables to euro
euro - 1 euro = 1.10 dollar
;
data dec.output15 (drop = i);
set dec.input15;
array old (3) dollar dollar_total1 dollar_total2;
array new (3) euro euro_total1 euro_total2;
do i = 1 to 3;
	new (i) = old(i)/1.10;
end;
run;

*16) proc sort = create output16 using input15;
proc sort data =dec.input15 out =  dec.output16;
by descending dollar;
run;

*17) proc means = using input15
calculate some summary statistics for the dollar value;
proc means data = dec.input15;
var dollar; run;

/* Note var specifies the analysis variables */ 

*18) proc freq = using input15
calculate the number of purchases per product type;
proc freq data = dec.input15;
tables product; run;

*19) ods pdf 
create pdf file from k.input15;
ods pdf file = "C:\Users\cxie\Desktop\BAT-Comm\Additional\input15.pdf";
proc print data =dec.input15; run;
ods pdf close;

*20) writing multiple datasets
create 2 datasets: churners and non-churners;
data churn_y churn_n;
set dec.churn;
if churn="Y" then output churn_y;
else output churn_n; run;

*21) stacking datasets
stack datasets k.churn_y & k.churn_n;
data churn;
set k.churn_y k.churn_n; run;

* 22) interleaving;
data churn;
set k.churn_n k.churn_y; 
by cust_id;
run;


* 23)merge;
* a) outer join;
data dec.churn_o;
merge dec.churn_age (in = a) dec.churn_los (in = b);
by cust_id;
run;
* b) left join;
data dec.churn_l;
merge dec.churn_age (in = a) dec.churn_los (in = b);
by cust_id;
if a = 1;
run;
* c) right join;
data churn_r;
merge k.churn_age (in = a) k.churn_los (in = b);
by cust_id;
if b = 1;
run;
* d) inner join;
data churn_i;
merge k.churn_age (in = a) k.churn_los (in = b);
by cust_id;
if a = 1 and b = 1;
run;

* 24) 
a) first.cust_id + sum statement;
proc sort data = dec.churn_trans out = dec.churn_trans;
by cust_id; run;

data dec.churn_trans_total;
set dec.churn_trans;
by cust_id;
if first.cust_id then mon_purch_total = mon_purch;
else mon_purch_total + mon_purch;
run;

* b) first.cust_id + retain statement;
data churn_trans_total;
set churn_trans;
retain mon_purch_total 0;
by cust_id;
if first.cust_id then mon_purch_total = mon_purch;
else mon_purch_total = mon_purch_total + mon_purch;
run;

* c) first.cust_id + retain statement + last.cust_id;
data dec.churn_trans_total (drop = mon_purch);
set dec.churn_trans;
retain mon_purch_total 0;
by cust_id;
if first.cust_id then mon_purch_total = mon_purch;
else mon_purch_total = mon_purch_total + mon_purch;
if last.cust_id;
run;

* 25) macro flexible restriction on LOS;
options mprint mlogic symbolgen;
%macro LOS_x (m_los = );
data churn_x;
set k.churn;
if LOS > &m_los;
run;
ods pdf file = 'C:\Users\cxie\Desktop\BAT-Comm\Additional\los.pdf';
proc print data = churn_x;
var cust_id los; run;
ods pdf close;
%mend;
%LOS_x (m_los = 50);

* 26) macro flexible restriction on LOS + %DO on print;
%macro LOS_x (m_los = , print = );
data dec.churn_x;
set dec.churn;
if LOS > &m_los;
run;
%if &print = Y %then %do;
	ods pdf file = 'C:\Users\cxie\Desktop\BAT-Comm\Additional\los.pdf';
	proc print data = dec.churn_x;
	var cust_id los; run;
	ods pdf close;
%end;
%mend;
%LOS_x (m_los = 50, print=Y);


* 27) PROC FORMAT - PROC PRINT - PROC TABULATE;
/* Create a nice report for the homework 1*/ 

DATA dec.websessions;
	INFILE "C:\Users\cxie\Desktop\BAT-Comm\Data\mbd_session2_url2.csv" DLM =";" FIRSTOBS = 2 MISSOVER DSD;
	INPUT Label $ Url :$200. @;
	*Url_clean = SUBSTR(Url, 5);
	Url= SUBSTR(Url, 5, index(CATS(url, "/"),"/")-5);
	Url_ending = substr(Url, find(Url, ".", 1));
	INPUT StartDate :DDMMYY10. StartTime :TIME. EndDate :DDMMYY10. EndTime :TIME.;
	StartDateTime = dhms(StartDate, 0,0,StartTime);
	EndDateTime = dhms(EndDate, 0,0,EndTime);
	*Day = Day(datepart(EndDateTime));
	WeekDay = Weekday(datepart(EndDateTime));
	SessionTime = intck('sec', StartDateTime, EndDateTime);
	Recency = Today() -  datepart(EndDateTime);
	*DROP StartDate -- EndDateTime;
RUN;

PROC FORMAT;
	value longshortsession
		0-200 = "short session"
		200 - HIGH = "long session";
RUN;

PROC PRINT data= dec.websessions (KEEP = Url SessionTime);
	format SessionTime longshortsession.;
RUN;


PROC FORMAT;
	value colorlongshortsession
		0-200 = 'RED'
		200 - HIGH = "GREEN";
RUN;


PROC PRINT DATA= dec.websessions;
	ID Url;
	VAR EndDate;
	VAR SessionTime / STYLE = {BACKGROUND= colorlongshortsession.};
	FORMAT EndDate weekdate29.;
RUN;


PROC TABULATE DATA= dec.websessions;
	CLASS Url label;
	VAR SessionTime recency;
	TABLE Url, Label *((Mean * SessionTime) (Mean * Recency));
RUN; 








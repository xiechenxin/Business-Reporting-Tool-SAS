**SAS Exam Answer from Chenxin Xie ;
**Create library;
libname  mbd 'C:\Users\cxie\Desktop\Exam_Chenxin\solution_Chenxin';

**Answer for 1.1;
data mbd.sales_sociodem;
INFILE 'C:\Users\cxie\Desktop\Exam_Chenxin\customer_sales_sociodem.csv' DSD DLM=',' FIRSTOBS=2 LRECL=1500 TRUNCOVER;
INPUT customerID :$12. gender $ SeniorCitizen sub_date MMDDYY12. ;
run;

**Answer for 1.2;
data mbd.sales_monval;
INFILE 'C:\Users\cxie\Desktop\Exam_Chenxin\customer_sales_monval.txt' FIRSTOBS=2 LRECL=9000 MISSOVER;
INPUT customerID :$12. Amount ;
run;

**Answer for 1.3;
data mbd.sales_freq;
INFILE 'C:\Users\cxie\Desktop\Exam_Chenxin\customer_sales_freq.csv' FIRSTOBS=2 LRECL=9000 DSD MISSOVER;
INPUT customerID :$12. Product_Category_1 Product_Category_2 Product_Category_3 ;
run;


**Answer for 2.1;
data mbd.sales_freq_2 (drop = i);
set mbd.sales_freq ;
**calculate total;
array freq (3) Product_Category_1 Product_Category_2 Product_Category_3;
Do i = 1 to 3;
 IF freq(i) = . THEN freq(i) = 0;
END;
Product_Category_Total = Product_Category_1 + Product_Category_2 + Product_Category_3 ;
run;

**Answer for 2.2;
proc sort data = mbd.sales_freq_2;
  by customerID;
run;
data mbd.sales_freq_3 (drop = Product_Category_1 Product_Category_2 Product_Category_3 Product_Category_Total);
set mbd.sales_freq_2 ;
**use retain to calculate;
retain sum_total 0;
retain Number_transactions 0;
by customerID;
if first.customerID then do;
   sum_total = Product_Category_Total;
   Number_transactions = 1;
   end;
else do;
   sum_total = sum_total + Product_Category_Total;
   Number_transactions = Number_transactions + 1;
   end;
if last.customerID;
rename sum_total = Product_Category_Total;
run;

**Answer for 2.3;
proc sort data = mbd.sales_monval;
  by customerID;
run;
**using the retain statement;
data mbd.sales_monval_2 (drop = Amount);
set mbd.sales_monval;
retain Total_amount 0;
by customerID;
if first.customerID then Total_amount = Amount;
else Total_amount = Total_amount + Amount;
if last.customerID;
run;

**Using the sum statement;
data mbd.sales_monval_2 (drop = Amount);
  do until(last.customerID);
    set mbd.sales_monval;
    by customerID;
    Total_amount + Amount;
    end;
run;

**Answer for 3.1;
proc sort data = mbd.sales_sociodem;
by customerID;
run;
data mbd.basetable;
merge mbd.sales_freq_3 mbd.sales_monval_2 mbd.sales_sociodem;
by customerID;
run;

**Answer for 4.1;
data mbd.basetable_2 (drop = userName domain);
set mbd.basetable;
  **calculate the diffence in number of days;
recency = intck ('DAYS', sub_date, TODAY());
  **create dummy_gender;
if gender = 'Female' then dummy_gender = 0;
else dummy_gender = 1;
  ** create email;
userName = substr(customerID, 6, 5);
domain = '@company.com';
email = CATS(userName, domain);
run;

**Answer for 4.2;
ODS PDF FILE = 'C:\Users\cxie\Desktop\Exam_Chenxin\solution_Chenxin\Gender_FREQ.pdf' STARTPAGE = NO;
ODS NOPROCTITLE;
proc freq data = mbd.basetable_2;
 tables gender gender*SeniorCitizen;
 title 'Frequency summary between Gender and SeniorCitizen';
 run;
 ODS PDF CLOSE;

 **Answer for 4.3;
data _NULL_;
 set mbd.basetable_2;
 FILE 'C:\Users\cxie\Desktop\Exam_Chenxin\solution_Chenxin\sales_report_bigshots.txt';
 if dummy_gender = 0 then realGender = 'She ';
 else realGender = 'He ';
 PUT 'The customer with customer ID ' customerID 'has a subscription since' sub_date WORDDATE18. '.' / 
   realGender 'has ' Number_transactions 'with a total value of ' Total_amount DOLLAR7. '.' /
   'Internal emial: ' email ;
 PUT PAGE;
 run;

 **Answer for 4.4;
**define macro variable;
%LET Gen_F = 'She';
%LET Gen_M = 'He';
 data _NULL_;
 set mbd.basetable_2;
 FILE 'C:\Users\cxie\Desktop\Exam_Chenxin\solution_Chenxin\sales_report_bigshots.txt';
 if dummy_gender = 0 then realGender = &Gen_F;
 else realGender = &Gen_M;
 PUT 'The customer with customer ID ' customerID 'has a subscription since' sub_date WORDDATE18. '.' / 
   realGender 'has ' Number_transactions 'with a total value of ' Total_amount DOLLAR7. '.' /
   'Internal emial: ' email ;
 PUT PAGE;
 run;


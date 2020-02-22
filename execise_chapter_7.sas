%Let selected_id = 3;
Data data_01;
INPUT ID Date MMDDYY10.;
datalines;
1 10/28/2019
2 11/20/2019
3 01/12/2019
4 05/05/2019
5 02/06/2019
;
run;
Data data_02;
Set data_01;
if ID = "&selected_id";
run;
proc print Data= data_02;
run;

data data_03;
INPUT id order;
datalines;
1 10
2 1
3 3
4 6
5 9
;
run;
%macro selected_customers(Order_threahold=);
Data data_04;
SET data_03;
IF order > &Order_threahold;
run;
proc print data=data_04;
run;
%mend selected_customers;
%selected_customers(Order_threahold=2);


data data_05;
INPUT id order;
datalines;
1 10
2 1
3 3
4 6
5 9
;
run;
%macro selected_customer(Order_number=);
Data data_06;
SET data_05;
IF order > &Order_number;
run;
%IF &sysnobs > 3 %THEN %DO;
    proc print data = data_06;
    title 'There are many customers with &Order_number.orders';
    run;
%END;
%ELSE %DO;
   proc print data =data_06;
   title 'There are less customers with &Order_number.orders';
   run;
%END
%mend selected_customer;
%selected_customer(Order_number=3);


data data_07;
INPUT id order;
datalines;
1 10
2 1
3 3
4 6
5 9
;
run;
Data data_08;
SET data_07;
IF id > order;
run;
proc sort data=data_08;
 BY ASCENDING order;
 run;
Data _NULL_;
set data_08;
if _N_= 1 then call symput("selectedOrder",order);
else stop;
run;
proc print data=data_08;
WHERE order="&selectedOrder";
title "&selectedOrder is the minimum order";
run;

proc mean noprint data=data_08;
 var order;
 output out=summary_data_09 Min(order)=min_order;
 run;
Data data_10;
set summary_data_09;
if _N_= 1 then call symput("selectedOrder",min_order);
else stop;
run;

proc print data=data_10;
where order="&selectedOrder";
run;

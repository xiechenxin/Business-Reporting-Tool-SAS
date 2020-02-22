libname homework "C:\Users\cxie\Desktop\BAT-Comm\Data\SAS_Additional_Exercises\Chapter2_data";run;
data homework_43;
infile "C:\Users\cxie\Desktop\BAT-Comm\Data\SAS_Additional_Exercises\Chapter2_data\CancerRates.dat";
input ranking$cancer_site$incidence_rate;
run;

proc print data=homework_43;
title 'output set: Canser Rate';
run;


data homework_44;
infile "C:\Users\cxie\Desktop\BAT-Comm\Data\SAS_Additional_Exercises\Chapter2_data\AKCbreeds.dat";
input name$ranking_1$ranking_2$ranking_3$ranking_4;
run;
proc print data=homework_44;
title 'output set: AKC Breeds';
run;

data homework_45;
infile "C:\Users\cxie\Desktop\BAT-Comm\Data\SAS_Additional_Exercises\Chapter2_data\Vaccines.dat";
input name$mode_of_transmission$worldwilde_incidence$worldwide_death$recommendation_Chile$recommendation_Cuba$recommendation_US$recommendation_UK$recommendation_Finland$recommendation_Germany$recommendation_Saudi_Arabia$recommendation_Ethiopia$recommendation_Bostswana$recommendation_India$recommendation_Australia$recommendation_China$recommendation_Japan;
run;
proc print data=homework_45;
title 'output set: Vaccines';
run;

data homework_46;
infile "C:\Users\cxie\Desktop\BAT-Comm\Data\SAS_Additional_Exercises\Chapter2_data\BigCompanies.dat";
input Ranking$name$conutry$sales$profit$assets$market_value;
run;
proc print data=homework_46;
title 'output set: Big Companies';
run;

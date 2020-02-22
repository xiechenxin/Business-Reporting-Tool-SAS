* 1 ;
DATA realmadrid;
	INFILE "C:/MBD/SESSION_5/fifa_realmadrid.csv" DLM = "," TRUNCOVER FIRSTOBS=2 DSD;
	INPUT Name :$25. Age Nationality :$25. Overall Wage Joined yymmdd10.;
RUN;

*2;
DATA transfer;
	INFILE "C:/MBD/SESSION_5/transfers.csv" DLM = "," TRUNCOVER FIRSTOBS=2 DSD;
	INPUT Name :$25. Age Nationality :$25. Overall Wage Joined yymmdd10.;
RUN;

* 3;
DATA realmadrid_upd;
	SET realmadrid transfer;
RUN;

*4;
DATA interlands;
	INFILE "C:/MBD/SESSION_5/interlands.txt";
	INPUT nationality $19. @20 dummy_play;
	IF nationality = "BE" THEN nationality = "Belgium";
RUN;

*5;
PROC SORT DATA=interlands;
	BY nationality;
RUN;
PROC SORT DATA=realmadrid_upd;
	BY nationality;
RUN;

DATA realmadrid_upd2;
	MERGE realmadrid_upd interlands;
	BY nationality;
RUN;

* 6;
DATA interlands2;
	INFILE "C:/MBD/SESSION_5/interlands_2.txt";
	INPUT nationality $19. @20 dummy_play;
	IF nationality = "BE" THEN nationality = "Belgium";
RUN;

*7;
PROC SORT DATA=interlands2;
	BY nationality;
RUN;
PROC SORT DATA=realmadrid_upd;
	BY nationality;
RUN;

DATA realmadrid_upd3;
	MERGE realmadrid_upd (IN = a) interlands2;
	BY nationality;
	IF a = 1;
RUN;

*8;
PROC SORT DATA= realmadrid_upd3;
	BY Name;
RUN;

DATA realmadrid_upd4;
     set realmadrid_upd3;
     by Name;
     Retain Id 0;
     if first.Name then Id=Id+1;
     else Id = Id;
run;

*9;
DATA realmadrid_upd5;
     set realmadrid_upd4;
     if Joined = . THEN dummy_joined =1;
	 ELSE dummy_joined=0;
run;

*10;
PROC MEANS NOPRINT DATA= realmadrid_upd5;
	VAR Joined;
	OUTPUT OUT = sumstats MIN(Joined) = min_date;
RUN;

DATA realmadrid_upd6 (DROP= _TYPE_ _FREQ_ min_date);
	IF _N_ =1 THEN SET sumstats;
	SET realmadrid_upd5;
    if Joined = . THEN Joined = min_date;
run;

*11;

DATA realmadrid_upd7;
	SET realmadrid_upd6;
	Recency = today() - Joined;
run;

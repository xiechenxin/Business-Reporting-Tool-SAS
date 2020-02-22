DATA websessions;
   INFILE 'C:\Users\cxie\Desktop\BAT-Comm\Data\mbd_session2_url2.csv'
   DLM = ";" 
   FIRSTOBS = 2 
   MISSOVER DSD;
   INPUT Lable $ URL:$200. @;
   URL_Cleaned = SUBSTR(Url, 5, index(CATS(url,"/"),"/")-5);
   INPUT StartDate : DDMMYY10. StartTime : TIME. EndDate :DDMMYY10. EndTime : TIME. ;
   StartDateTime = dhms(StartDate, 0,0,StartTime);
   EndDateTime = dhms(EndDate, 0,0,EndTime);
   SessionTime = intck('sec', StartDateTime, EndDateTime);
   Day_Week = Weekday(datepart(EndDateTime));
   Recency = Today() - datepart(EndDateTime);
RUN;
PROC SORT DATA = websessions OUT = websort ;
   BY Lable URL_Cleaned descending SessionTime Recency Day_Week ;
   PROC FORMAT;
   VALUE $Lable 'good' = 'Good'
                 'bad' = 'Bad';
   Value Day_Week 1 = 'Mon'
                  2 = 'Tue' 
                  3 = 'Wed'
                  4 = 'Thu'
                  5 = 'Fri'
                  6 = 'Sat'
                  7 = 'Sun';
PROC MEANS NOPRINT DATA = websort;
   BY URL_Cleaned;
   VAR Lable URL_Cleaned StartDateTime EndDateTime Recency Day_Week SessionTime;
   OUTPUT OUT = final  
      MEAN(SessionTime) = Avg_SessionTime
      SUM(SessionTime) = Sum_SessionTime;
PROC PRINT DATA = websort;
   VAR Lable URL_Cleaned StartDateTime EndDateTime Recency Day_Week SessionTime Avg_SessionTime;
   BY Lable;
   SUM SessionTime;
   TITLE 'Web Session Report';
   FOOTNOTE 'Good = Recommended | Bad = Not Recommended';
RUN;

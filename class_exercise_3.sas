DATA class_3;
   INFILE 'C:\Users\cxie\Desktop\BAT-Comm\Data\mbd_session2_url2.csv'
   DLM = ";" 
   FIRSTOBS = 2 
   MISSOVER DSD;
   INPUT Lable $ URL:$200. @;
   Url_clean = SUBSTR(Url, 5, index(CATS(url,"/"),"/")-5);
   INPUT StartDate : DDMMYY10. StartTime : TIME. EndDate :DDMMYY10. EndTime : TIME. ;
   
RUN;
PROC PRINT DATA = class_3;
   TITLE 'URL List';
RUN;

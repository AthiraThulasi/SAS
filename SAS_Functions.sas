*------------------------------------------------------------------                     
                      *SAS FUNTIONS
*------------------------------------------------------------------
-------------------------------------------------------------------
MEAN - To find the average
-------------------------------------------------------------------
-------------------------------------------------------------------;
Data price_out;
set sashelp.pricedata (keep = price1 price2 price3);
avg_price = mean(of price1-price3);
run;
*-----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
INPUT function - INPUT(source, informat) 
Convert character data values to numeric values
INPUT function requires an informat
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------;
Data price;
input price : comma9.;this input is doing job       
Datalines;
2,615,033
8,135,239
9,114,243
3,105,133
;
run;
*-----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
PUT function - INPUT(source, format) - Convert character data values to numeric values
PUT function requires a format
------------------------------------------------------------------------------------------
•The PUT function always returns a character string.

•The PUT function returns the source written with a format.

•The format must agree with the source in type.

•Numeric formats right-align the result, character formats left-align the result.

•When you use the PUT function to create a variable that has not been previously identified,
it creates a character variable whose length is equal to the format width;

*=============================================================================================;
Data price_out;
set sashelp.pricedata (keep = date sale);
date_sale = put (date,monyy5.)||'/'||sale; 
run;

*-----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
mdy() - today() - date() - time()
------------------------------------------------------------------------------------------;

Data dat_time;
date = mdy(10,01,2008); *O/P - SAS date;
now1 = today();         *O/P - Today's date as Numerical value if no format is given;
now2 = date();
curtime = time(); 
run;                       *O/P - current time as a SAS time;

proc print data = dat_time;
format date mmddyy10.;  *????;
format now1 mmdddyy10.; *???;
format curtime  time8.;
run;
*-----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
YEAR() - MONTH() - QUARTER() - DAY() - WEEKDAY() 
------------------------------------------------------------------------------------------;
Data type;
date  = '20feb2024'd;
yr=year(date);              *O/P - Numerical value if no format is given;
month=month(date);
quarter=qtr(date);
day=day(date);
wkday=weekday(date);
run;
*----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
INTCK function - Date function in SAS that is used to calculate the difference between (i) two dates (ii) two times or two datetime values.
*----------------------------------------------------------------------------------------------------------------------------------
INTCK(date-or-time-interval, start-date-or-time, end-date-or-time)
INTCK returns numerical output
WEEK intervals are counted by Sundays rather than seven-day multiples from the from argument. 
MONTH intervals are counted by day 1 of each month 
YEAR intervals are counted from 01JAN, not in 365-day multiples
----------------------------------------------------------------------------------------------------------------------------------;

Data days;                 *OUTPUT - *x1,x2,x3,x4 and x5 have numeric datatypes;
d1 = '1mar2024'd;      
d2 = '1mar2025'd;
x1=intck('day',d1,d2);        *days from D1 to D2;
x2=intck('week',d1,d2);       *Week from D1 to D2;
x3=intck('month',d1,d2);      *Month from D1 to D2;
x4=intck('qtr',d1,d2);        *Qrtr from D1 to D2;
x5=intck('year',d1,d2); 
x6=intck('semiyear',d1,d2); 
x7=intck('month4',d1,d2);  *interval is of 4 months
x7=intck('year2',d1,d2);   *'YEAR2' tells SAS the interval is of 2 years;
format d1 d2 date9.;
 run;                      *if format is given for dates D1 to D2, output will show the date itself instead of no: of days;
 
 
Data time;
t1 = '13:00:05't;
t2 = '24:05:00't;
hours=intck('hour',t1,t2 );
minutes=intck('minute',t1,t2);
seconds=intck('second',t1,t2);
date_time = intck(1mar2024'd:13:00:0,5mar2024'd:13:00:0) 
format now mmddyy10.;
format t1 t2 time10.;
run;


proc print Data = time;
run;
*-------------------------------------------------------------------------------
---------------------------------------------------------------------------------
data work.anniversary;
set cert.mechanics(keep=id lastname firstname hired);
Years=intck('year',hired,today());
if years=20 and month(hired)=month(today());
run;
proc print data=work.anniversary;
title '20-Year Anniversaries';
run;
*-----------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
INTNX function - INTNX is used to increment SAS date by a specified number of intervals
-----------------------------------------------------------------------------------------------------
INTNX(interval, start-from, increment)
INTnx returns numerical output
INTNX function identify past or future days, weeks, months, and so on
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------;
Data time;
TargetYear=intnx('year','20Jul18'd,3,'b');
run;
*-----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
YRDIF - calculate the difference in years
YRDIF(start_date,end_date,basis)
basis specifies a character constant or variable that describes how SAS calculates the date difference
There are 4 character strings that are valid for basis in the YRIF function
------------------------------------------------------------------------------------------;
data _null_;
x=yrdif('16feb2016'd,'16jun2018'd,'30/360'); *specifies a 30-day month and a 360-day year;
put x;
run;

data _null_;
x=yrdif('16feb2016'd, '16jun2018'd, 'ACT/ACT');*uses the actual number of days or years between dates;
put x;
run;

data _null_;
x=yrdif('16feb2016'd, '16jun2018'd, 'ACT/360');*uses the actual number of days between dates in calculating the number of years;
put x;
run;

data _null_;
x=yrdif('16feb2016'd, '16jun2018'd, 'ACT/365');*uses the actual number of days between dates in calculating the number of years;
put x;
run;

*-----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
DATEDIF - calculate the difference in days 
DATDIF(start_date,end_date,basis))
There are 2 character strings that are valid for basis in the DATEDIF function.
*-----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------;
data _null_;
x=yrdif('16feb2016'd,'16jun2018'd,'30/360');
put x;
run;

data _null_;
x=yrdif('16feb2016'd, '16jun2018'd, 'ACT/ACT');
put x;
run;

*-----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
SCAN() - SCAN function extracts words from a character string in SAS
SCAN(argument,nth word,delimiter,modifiers)
*-----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
Leading delimiters before the first word in the character string do not affect the SCAN function.
If there are two or more continuous delimiters, the SCAN function treats them as one.
If n is greater than the number of words in the character string, the SCAN function returns a blank value.
If n is negative, the SCAN function selects the word in the character string starting from the end of the string
--------------------------------------------------------------------------------------------
*Default Delimiters used by SAS - . < ( + | & ! $ * ) ; ^ - / , % if do not specify any;

Data scan_fun;
name1 = scan('she is here',3);
name2 = scan('she is here',-3);
run;

*-----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
SUBSTR() - The SUBSTR function extracts a substring from an argument, starting at a specific position in the string.
SUBSTR function can be used on either the right or left of the equal sign to replace character value constants.
SUBSTR(argument, position,n) n is the num of characters to extract
If n is omitted, all remaining characters are included in the substring.
*-----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------;
Data sub;
result1 = SUBSTR('she is here',2);
result2 = SUBSTR('she is here',2,3);
result3 = SUBSTR('she is here',1,1);
run;

*-----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
TRANWRD -  for Word Replacement
TRANWRD(string,find_what,replace_with)
*-----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------;
Data Tran;
T = TRANWRD('Are you there','there', 'here');
run;

*-----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------;
data one;
addressl = '  214 London Way';  * character - len - 15;
run;

data one;
length address $10; 
old = '  214 London WaystreetWay'; 
address = tranwrd(old, 'Way', 'Drive'); *char - len - 200 ;
run;
*What are the length and value of the variable ADDRESS?;
Tranward always return 200 as length, if the length is not given;
run;

*-----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
FIND() -  for Word Replacement
TRANWRD(string,find_what,replace_with)
*-----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------;
data newdata;
first_name = find('My name is SAS', "name", "i", 6);
run;





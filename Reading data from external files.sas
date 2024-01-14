*INFORMATS & FORMATS IN SAS
------------------------------
INFORMAT - tell SAS how to interpret data from external files( txt, csv , tab delimited file etc) 
FORMAT - controls how data values rae displayed in the output
-------------------------------------------------------------------------------------------------------
RON CODY : LEARNING SAS BY EXAMPLE - CHAP.3 - READING RAW DATA FROM EXTERNAL FILES
-------------------------------------------------------------------------------------------------------
*(Q1) You have a text file called Scores.txt containing information on gender (M or F) and four test
scores (English, history, math, and science). Each data value is separated from the others by one or
more blanks. Here is a listing of the data file Scores.txt:
M 80 82 85 88
F 94 92 88 96
M 96 88 89 92
F 95 . 92 92

a. Write a DATA step to read in these values. Choose your own variable names. 

-------------------------------------------------
NOTES
--------------------------------------------------
Used List Input : 
All values separated by at least one space
No embedded space in between
characters not more than 8
Missing values are indicated by period
---------------------------------------------------;
Data subjects;
infile'/home/u60674716/Datasets/Roncody_dataset/scores.txt';
input gender $1
	  English 
	  history
	  math
	  science;
run;

*b. Include an assignment statement computing the average of the four test scores;
*As the 4th row has a missing column, average computed will be missing for the forth column;

Data average;
set subjects;
Av = (English + history + math +  science) /4;
run;
	  
*c. Write the appropriate PROC PRINT statements to list the contents of this data set;
 proc print data = average;
 run;
 
*###################################################################################
(Q2) You are given a (comma-separated values) file called Political containing state,
political party, and age. 

*The following is the data in text file political:
"NJ",Ind,55
"CO",Dem,45
"NY",Rep,23
"FL",Dem,66
"NJ",Rep,34

-------------------------------------------------------------------------------------------
NOTES - Why we use DSD here ? What are the functions of dsd ?
-------------------------------------------------------------------------------------------
dsd is used as the data values are comma separated and not blank separated.

First dsd changes the default delimiter from a blank to a comma. 
Next, if there are two delimiters in a row, it assumes there is a missing value between. 
Finally, if character values are placed in quotes (single/double) the quotes are stripped from the value.

Here dsd (delimiter sensitive data) will convert the default delimiter (blank) to comma
------------------------------------------------------------------------------------------------;
a. Write a SAS program to create a temporary SAS data set called Vote. Use the variable names
State, Party, and Age. Age should be stored as a numeric variable. State and Party should be
stored as character variables;

Data Vote;
infile '/home/u60674716/Datasets/Roncody_dataset/vote.txt' dsd ;
input state $ party $ age;
run;

*b. Include a procedure to list the observations in this data set;

*---------------------------------------------------------------------------------------
NOTE
----------------------------------------------------------------------------------------
*nocum is no cumulative - suppress the display of cumulative statistics in the output
-----------------------------------------------------------------------------------------;
proc print data = vote;
run;

*c. Include a procedure to compute frequencies for Party;
proc freq data = vote ;
tables party / nocum ;
run;


###############################################################################################;
*(Q3) You are given a text file where dollar signs were used as delimiters. To indicate missing values,
two dollars signs were entered. Values in this file represent last name, employee number, and
annual salary.

*The following is the data in text file
Roberts$M234$45000
Chien$M74777$$
Walters$$75000
Rogers$F7272$78131

--------------------------------------------------------------------------------------
NOTES
--------------------------------------------------------------------------------------
Here dsd (delimiter sensitive data) will convert the default delimiter (blank) to $
And dlm = $ specifies the delimiter used in the dataset
---------------------------------------------------------------------------------------;
Data company;
infile'/home/u60674716/Datasets/Roncody_dataset/company.txt' dsd dlm ='$';
input last_name  $ employee_number  $ salary;
run;

title "Listing of COMPANY";
proc print data=company noobs;
run;

*##############################################################################
(Q4) Repeat Problem 2 using a FILENAME statement to create a fileref instead of using the file name
on the INFILE statements;

FILENAME comp '/home/u60674716/Datasets/Roncody_dataset/company.txt' ;
Data company;
INFILE comp dsd dlm ='$';
input last_name  $ employee_number  $ salary;
run;

*###################################################################################
(Q5) You want to create a program that uses a DATALINES statement to read in values for X and Y. In
the DATA step, you want to create a new variable, Z, equal to 100 + 50X + 2X2 – 25Y + Y2. Use
the following (X,Y) data pairs: (1,2), (3,6), (5,9), and (9,11);

Data values;
infile Datalines;
input X Y;
Z = 100 + 50*X + 2*X**2 - 25*Y + Y**2;
Datalines;
1 2
3 6
5 9
9 11
;

*#################################################################################
(Q6) You have a text file called Bankdata.txt with data values arranged as follows:
Include in this data set a variable called Interest computed by multiplying
Balance by Rate. List the contents of this data set using PROC PRINT;


*The following is the data in the text file;
Philip Jones V1234 4322.32
Nathan Philips V1399 15202.45
Shu Lu W8892 451233.45
Betty Boop V7677 50002.78;

Data Bank;
infile '/home/u60674716/Datasets/Roncody_dataset/bankdata.txt';
input @1Name $14. Acct $ @21 Balance 7.  @27 Interest_rate 4.;
Interest = Balance * Interest_rate;
run;

proc print data = Bank;
run;

*############################################################
7. You have a text file called Geocaching.txt with data values arranged as follows
Create a temporary SAS data set called Cache using this data file. Use column input to read the
data values.

*The following is the data in text file
Higgensville Hike 4030.2937446.539
Really Roaring 4027.4047442.147
Cushetunk Climb 4037.0247448.014
Uplands Trek 4030.9907452.794

------------------------------------------------------------------------------------
NOTES - Column input
------------------------------------------------------------------------------------
Column input is used to read values from each column mentioning the column numbers
Data can have embedded space
Missing values can be left blank
Spaces are not required between values
Can't handle non-std numeric values 
-------------------------------------------------------------------------------------;
Data Cache;
infile '/home/u60674716/Datasets/Roncody_dataset/geocache.txt';
input  Name $1-17 LongDeg 21-22  LongMin 23-28 LatDeg 29-30 LatMin 31-36 ;
run;

*#######################################################################
8. Repeat Problem 6 using formatted input to read the data values .

*The following is the data in the text file
Philip Jones V1234 4322.32
Nathan Philips V1399 15202.45
Shu Lu W8892 451233.45
Betty Boop V7677 50002.78

-------------------------------------------------------------------------------------
NOTES - FORMATTED INPUT
-------------------------------------------------------------------------------------
Formatted input is used to read both std and non-std numeric values
@starting position of column followed by informat
-------------------------------------------------------------------------------------;
Data Cache;
Data Bank_formatted;
infile '/home/u60674716/Datasets/Roncody_dataset/bankdata.txt';
input @1Name $14. @16 Acct $5. @22Interest_rate 6.2;
run;


*##########################################################################################
9. Repeat Problem 7 using formatted input to read the data values instead of column input;


*The following is the data in text file
Higgensville Hike 4030.2937446.539
Really Roaring 4027.4047442.147
Cushetunk Climb 4037.0247448.014
Uplands Trek 4030.9907452.794;


data cache;
infile '/home/u60674716/Datasets/Roncody_dataset/geocache.txt';
input 
@1 GeoName $20.
@21 LongDeg 2.
@23 LongMin 6.
@29 LatDeg 2.
@31 LatMin 6.;
run;

*###############################################################################;

*Q10. You are given a text file called Stockprices.txt containing information on the purchase and
sale of stocks. Use formatted input.
Compute several new variables as follows:Compute several new variables as follows:
Variable Description Computation
TotalPur Total purchase price Number times PurPrice
TotalSell Total selling price Number times SellPrice
Profit Profit TotalSell minus TotalPur
Print out the contents of this data set using PROC PRINT;

*The following is the data in text file
IBM  5/21/2006 $80.0 10007/20/2006 $88.5
CSCO04/05/2005 $17.5 20009/21/2005 $23.6
MOT 03/01/2004 $14.7 50010/10/2006 $19.9
XMSR04/15/2006 $28.4 20004/15/2006 $12.7
BBY 02/15/2005 $45.2 10009/09/2006 $56.8;


Data Stock;
infile '/home/u60674716/Datasets/Roncody_dataset/stockprices.txt';
input @1 stock $4. @5 purdate mmddyy10. @16 purprice dollar4.1 @22 number 3. @25selldate mmddyy10. @36sellprice dollar4.1;
format purdate mmddyy10. purprice dollar4.1 selldate mmddyy10. sellprice dollar4.1;
totalPur =  number * PurPrice;
totalsell = number * sellprice;
profit = totalsell - totalpur;
run;

*########################################################################################
Q11)Use list input to read data from this file. You will need an informat to read most of these values
correctly (i.e., DateHire needs a date informat). You can do this in either of two ways. First is to
include an INFORMAT statement to associate each variable with the appropriate informat. The
other is to use the colon modifier and supply the informats directly in the INPUT statement. Create
a temporary SAS data set (Employ) from this data file. Use PROC PRINT to list the observations
in your data set and the appropriate procedure to compute frequencies for the variable Depart.

*The following is the data in csv file - Employee.csv:
123,"Harold Wilson",Acct,01/15/1989,$78123.
128,"Julia Child",Food,08/29/1988,$89123
007,"James Bond",Security,02/01/2000,$82100
828,"Roger Doger",Acct,08/15/1999,$39100
900,"Earl Davenport",Food,09/09/1989,$45399
906,"James Swindler",Acct,12/21/1978,$78200

------------------------------------------------------------------------------------
NOTES
------------------------------------------------------------------------------------
When the data is separated by blank (SAS default delimiter) comma. 
Use List input + informat column modifier (:)
------------------------------------------------------------------------------------;
Data employee;
infile '/home/u60674716/Datasets/Roncody_dataset/employee.txt' dsd missover;
input ID  
      Name : $13. 
      Dept $ : 8.
      Datehire : mmddyy10. 
      Salary  dollar7.;
format Datehire mmddyy10. Salary dollar7.;
run;




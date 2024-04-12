*-------------------------------------------------------------------------------------------
                              PROC IMPORT
---------------------------------------------------------------------------------------------
The IMPORT procedure reads data from an external data source and writes it to a SAS data set. 
PROC IMPORT can import structured and unstructured data.
PROC IMPORT can import delimited files (blank, comma, or tab) along with Microsoft Excel files.
----------------------------------------------------------------------------------------------- 
PROC IMPORT - SYNTAX
----------------------------------------------------------------------------------------------- ;
PROC IMPORT DATAFILE=FileName 
DBMS=identifier 
OUT=SASDatasetName REPLACE;
GETNAMES=Yes;
RUN;
*------------------------------------------------------------------
*DATAFILE = Name of the external file to import
OUT = output SASDatasetName
DBMS = format of the file being imported (txt, csv, xls, xlsx)
GETNAMES = Yes (By default) IMPORT procedure expects the variable names to appear in the first row
----------------------------------------------------------------------------------------------- 
----------------------------------------------------------------------------------------------- 
CODE 1 - TEXT FILE
----------------------------------------------------------------------------------------------- 
-----------------------------------------------------------------------------------------------;
PROC IMPORT datafile = '/home/u60674716/Datasets/Roncody_dataset/parks.txt' 
DBMS = TAB 
out = work.parksout replace;
getnames = no; *Variable names are not present in the first column in the importing datafile;
run;

*----------------------------------------------------------------------------------------------- 
----------------------------------------------------------------------------------------------- 
CODE 2 - CSV FILE
-----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------- ;
PROC IMPORT datafile = '/home/u60674716/Datasets/Roncody_dataset/presidents.csv' 
DBMS = CSV 
out = work.presidentsout replace;
getnames= no;
run;

*using filename;

filename presi '/home/u60674716/Datasets/Roncody_dataset/parks.txt';
proc import datafile=presi out = presidents1
DBMS = TAB replace;
getnames= no; *Variable names are not present in the first column in the importing datafile;
run;
*----------------------------------------------------------------------------------------------- 
----------------------------------------------------------------------------------------------- 
CODE 3 - XLSX FILE
-----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------- ;
PROC IMPORT datafile = '/home/u60674716/Datasets/Roncody_dataset/Wages.xlsx' 
DBMS = XLSX 
out = work.wagesout replace;
getnames= yes; *Variable names are present in the first column in the importing datafile;
run;
*----------------------------------------------------------------------------------------------- 
----------------------------------------------------------------------------------------------- 
CODE 4 - EXCEL FILE
*-----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------- 
To import a specific sheet in EXCEL,the sheet name needs to be explicitly specified 
otherwise, SAS will automatically import the first sheet of the Excel file by default;

PROC IMPORT DATAFILE="/home/u60674716/Datasets/Roncody_dataset/Div.xlsx" 
DBMS=XLSX
OUT=Divout REPLACE;
SHEET="DIV2";
GETNAMES=YES; 
DATAROW=3;    *DATAROW = 3 tells SAS to start reading data from row number 5;
RUN;

*----------------------------------------------------------------------------------------------- 
----------------------------------------------------------------------------------------------- 
CODE 4 - DELIMITED FILE
*-----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------- ;
PROC IMPORT DATAFILE="/home/u60674716/Datasets/Roncody_dataset/employee.txt" 
DBMS = DLM
OUT=empout REPLACE;
DELIMITER=',';
GETNAMES=no;       
run;

*----------------------------------------------------------------------------------------------- 
----------------------------------------------------------------------------------------------- 
CODE 5 - Guessing Rows - This statement applies only to text/delimited files not Excel.
*-----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------- ;
*Always use the higher number of GUESSINGROWS to avoid TRUNCATION
Maximum value of GUESSINGROWS is 2147483647
If the file is SMALL - Use GUESSINGROWS = MAX
If the file is LARGE - Use of GUESSINGROWS = MAX will slow down PROC IMPORT
-----------------------------------------------------------------------------------------------;
PROC IMPORT datafile = '/home/u60674716/Datasets/Roncody_dataset/Wages.xlsx' out = work.wagesout
DBMS = XLSX replace;
getnames= yes;  **Variable names are present in the first column in the importing datafile;
run;

PROC IMPORT datafile = '/home/u60674716/Datasets/Roncody_dataset/school.txt' 
DBMS = TAB 
out = work.schoolout replace;
getnames= no; *Variable names are not present in the first column in the importing datafile;
guessingrows=3;
run;


PROC IMPORT datafile = '/home/u60674716/Datasets/Roncody_dataset/Sales.txt' 
DBMS = TAB 
out = work.salesout replace;
guessingrows=3; *6th obs - Glenda Johnson is truncated as SAS is taking the length of first 3 rows;
getnames = no; *Variable names are not present in the first column in the importing datafile;
run;

*By running a PROC FREQ to generate a frequency table on the newly created dataset
we can test whether or not the GUESSINGROWS option was effective;

proc freq data = salesout ;
table var2;
*----------------------------------------------------------------------------------------------- 
----------------------------------------------------------------------------------------------- 
CODE 6 - XLSX Engine - SAS treat an Excel spreadsheet as if it were a SAS data set by using XLS engine.
LIBNAME statement is used to connect to an xlsx spreadsheet.
The libref must not be more than 8 characters in length and must be a valid SAS name.
*-----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------- ;
LIBNAME wages XLSX '/home/u60674716/Datasets/Roncody_dataset/Wages.xlsx';
Data wages_out;
set wages.permanent;
run;



*libname single XLSX '/home/u60674716/Datasets/Roncody_dataset/single.xls';
#not wrking;

*----------------------------------------------------------------------------------------------- 
----------------------------------------------------------------------------------------------- 
CODE 7 - Using SAS Name Literal 
-----------------------------------------------------------------------------------------------
A SAS name literal is a name token that is expressed as a string within 
quotation marks, followed by the uppercase or lowercase letter n. 
The name literal tells SAS to allow the special character ($) in the data set name;
*-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------;
libname waglib XLSX '/home/u60674716/Datasets/Roncody_dataset/Wages1.xlsx';
data work.wages;
set waglib.'permanent'n;
run;

proc print data= work.wages;
run;

proc means data = waglib.'permanent'n mean;
var Wage ;
run;

libname waglib'/home/u60674716/Datasets/Roncody_dataset/Wages.xls';
data work.wages;
set waglib.permanent;
run;

proc print data= work.wages;
run;

*----------------------------------------------------------------------------------------------- ---------
---------------------------------------------------------------------------------------------------------- 
CODE 8 - How SAS can create Excel worksheets from SAS data sets/ WRITING TO EXCEL FROM SAS DATASET (EXPORT) 
------------------------------------------------------------------------------------------------------------
If the Excel workbook does not exist, SAS creates it.
If the Excel worksheet within the workbook does not exist, SAS creates it.
If the Excel workbook and the worksheet already exist, then SAS overwrites the existing Excel workbook and worksheet.
*-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------;
libname lib xlsx '/home/u60674716/Lib/newExcel.xlsx';*name of the new Excelfile;
data lib.excel_new;    *DATA step to create an Excel worksheet;
set sashelp.class;
run;













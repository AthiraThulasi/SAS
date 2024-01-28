*=============================================================================================================================
                             PROC TRANSPOSE 
==============================================================================================================================
OUT, SUFFIX, PREFIX, NAME - Arguments of PROC TRANSPOSE  (Equal sign required)
VAR statement - To Transpose specific variables 
VAR statement - To Transpose character variables 
ID statement - To create variable names in the output data set that are based on one or more variables from the input data set.
BY statement - Creates BY groups for each unique variable in a column. The procedure does not transpose the BY variables.
-------------------------------------------------------------------------------------------------------------------------------
PROC TRANSPOSE takes an input data set and outputs a data set where the original rows become
columns and the original columns become rows. 

PROC TRANSPOSE procedure only transforms numerical columns by default.

To TRANSPOSE Character variables - Add those character variables in the  VAR statement.

VAR statement can also be used if we want only specific columns.

PROC Transpose do not automatically produce output. PROC PRINT is required for subsequent analysis or printing of the OUTPUT

*** 5 Datasets used - Each code is separated by 3 lines for better understanding***

------------------------------------------------------------------------------
DATASET 1 
-------------------------------------------------------------------------------;
Data Stock;
input @1 stock $4. @5 purdate mmddyy10. @16 purprice dollar4.1 @22 number 3. @25selldate mmddyy10. @36sellprice dollar4.1 @42 Customer $6. ;
format purdate mmddyy10. purprice dollar4.1 selldate mmddyy10. sellprice dollar4.1;
Datalines;
IBM  5/21/2006 $80.0 10007/20/2006 $88.5  Alex
CSCO04/05/2005 $17.5 20009/21/2005 $23.6  Nora
MOT 03/01/2004 $14.7 50010/10/2006 $19.9  Alex
XMSR04/15/2006 $28.4 20004/15/2006 $12.7 John
BBY 02/15/2005 $45.2 10009/09/2006 $56.8 Mary
;
run;
*------------------------------------------------------------------------------
CODE 1 - Simple Transpose  ;


PROC TRANSPOSE data = stock out = new_stock ;
format purdate mmddyy10. purprice dollar4.1 selldate mmddyy10. sellprice dollar4.1;
run;

Title "Stock data";
PROC PRINT DATA  = new_stock;
run;

* CODE 1 - POINTS TO NOTE
--------------------------------------------------
Output of Transpose is saved in file: new_stock
Column names became row names with _NAME_ as default column name(To change this use name = )
SAS transpose only numerical columns by default.
To transpose Character columns OR Specific columns - Use VAR statement
SAS named the columns default as Col1, Col2, Col3.....(Use suffix = & Prefix = to rename columns)
To view ouput of TRANSPOSE - Use PROC PRINT

-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------

CODE 2 - PROC TRANSPOSE with arguments data, out, name, suffix & prefix;

PROC TRANSPOSE data = stock out = new_stock name = stock_details suffix =  Stock prefix=data;
run;

Title "Stock data with name | suffix | prefix";
PROC PRINT DATA  = new_stock noobs;
run;

*------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------

CODE 3 - Using VAR Statement
While using VAR statement, we can specify character columns as well as the specific columns we want to transpose
--------------------------------------------------------------------------------------------------;
PROC TRANSPOSE data = stock out = new_stock name = stock_details suffix =  Stock prefix=data;
var stock Customer purdate purprice ;
run;


Title "Stock data with var";
PROC PRINT DATA  = new_stock noobs;
run;

*----------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
Dataset 2 - ID Statement is meaningful for the type of datasets given below (Pets)
-----------------------------------------------------------------------------------------------;

data pets;
infile cards;
length pet_owner $10 pet_name $4 pet_count 4;
input pet_owner $1-10 pet_name $ pet_count;
cards;
Mr. Black dog 2
Mr. XXX   bird 1
Mrs. Green fish 5
Mr. White cat 3
;
run;
*-------------------------------
CODE 4 - Using ID Statement
--------------------------------
To understand the how ID works, removed suffix & prefix
Value of any ID variable is missing, then PROC TRANSPOSE writes a warning message to the log. 
The procedure does not transpose observations that have a missing value for any ID variable;

PROC TRANSPOSE data = pets out = new_pets name = pet_details;
var pet_owner  pet_count ;
id pet_name;
run;


Title "Pet data with ID";
PROC PRINT DATA  = new_pets noobs;
run;
*------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------

*CODE 5 - Using ID Statement + Prefix & Suffix
Lets see how the O/P looks with ID, Prefix & Suffix
When we use PREFIX = with an ID statement, the variable name begins with the prefix value followed by the ID value
-------------------------------------------------------------------------------------------------------;

PROC TRANSPOSE data = pets out = new_pets name = pet_details suffix =  Stock prefix=data;
var pet_owner  pet_count ;
id pet_name;
run;


Title "Pet data with ID , Prefix & Suffix";
PROC PRINT DATA  = new_pets noobs;
run;
*-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
Dataset 3 - Pets1 - Use of  'BY' Statement Duplicate name in pet_owner 
------------------------------------------------------------------------------------------------;
data pets_1;
infile cards;
length pet_owner $10 pet_name $4 pet_count 4;
input pet_owner $1-10 pet_name $ pet_count;
cards;
Mr. Black dog 2
Mr. Black cat 1
Mrs. Brown dog 1
Mrs. Brown cat 0
Mrs. Green fish 5
Mr. White fish 7
Mr. White dog 1
Mr. White cat 3
;
run;

*CODE 5
-------------------------------
Pet_owner column has duplicate values. Each pet owner owns different pets - If we try to TRANSPOSE, LOG will give ERROR message for CODE 5 saying duplicate.
How to fix the error ?
SOLUTION - Identify the unique variable and SORT before doing Transpose and use 'BY' to match each owner to each pet(explained in CODE 6);

PROC TRANSPOSE data = pets_1 out = new_pets1 name = pet_details ;
var pet_owner  pet_count ;
id pet_owner;
run;


Title "Pet data with Duplicate owner_names ";
PROC PRINT DATA  = new_pets1 noobs;
run;

*------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
CODE 6 - SORT - TRANSPOSE - BY STATEMENT
--------------------------------------------------------------------
The unique variable is pet_name. First SORT the Data set > Do Transpose using "BY" to perform operation for each pet_name
The BY statement creates BY groups for each unique pet_name. 
The procedure does not transpose the BY variables;

proc sort data= pets_1 out = sorted_pets ;
by pet_name;
run;


PROC TRANSPOSE data = sorted_pets out = new_pets1 (drop = pet_details) name = pet_details  ;
id pet_owner ; 
var pet_count ;
by pet_name;
run;


Title "Pet data using SORT and BY ";
PROC PRINT DATA  = new_pets1 noobs;
run;
*-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
DATASET 4 - Stock name is unique, but same customers has different stocks. How to use 'BY'statement
---------------------------------------------------------------------------------------------------;
Data Stock;
input @1 stock $4. @5 purdate mmddyy10. @16 purprice dollar4.1 @22 number 3. @25selldate mmddyy10. @36sellprice dollar4.1 @42 Customer $6. ;
format purdate mmddyy10. purprice dollar4.1 selldate mmddyy10. sellprice dollar4.1;
Datalines;
IBM  5/21/2006 $80.0 10007/20/2006 $88.5  Alex
CSCO04/05/2005 $17.5 20009/21/2005 $23.6  Nora
MOT 03/01/2004 $14.7 50010/10/2006 $19.9  Alex
XMSR04/15/2006 $28.4 20004/15/2006 $12.7 Nora
BBY 02/15/2005 $45.2 10009/09/2006 $56.8 Alex
;
run;

*------------------------------------------------------------------
CODE 7 - USING SORT & BY statement in the above Dataset
Unique variable is STOCK.
Output - For each STOCK, Purchase Date and customer is listed.
BY statement creates BY groups for each unique stock. 
--------------------------------------------------------------------;

proc sort data= Stock out = sortedstock;
by stock ;
run;

PROC TRANSPOSE data = sortedstock out = new_stock prefix = Details ;
format purdate mmddyy10. purprice dollar4.1 selldate mmddyy10. sellprice dollar4.1;
var customer purdate;
by stock;
run;

Title "stock data using SORT and BY ";
PROC PRINT DATA  = new_stock noobs;
run;
*-----------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
SAS HELP - CLASS DATASET 5
---------------------------------;
Data class;
set sashelp.class;
run;

proc print data = class;
run;

*In the class dataset - Currently M & F are in SEX column. 
Create two separate columns for Male and Female and transfer the AGE of each person to male and female columns respectively

CODE - 8
---------------;

proc sort data = class out = sorted_class;
by Name Height Weight;
run;

Proc transpose data = sorted_class out = trans_class;
id Sex;
var Age ;
by Name ;
run;

proc print data = trans_class;
run;
*-----------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
CODE - 9
-------------------------------------------------------------------------------------------------
Here, When we add Height and Weight with 'BY variable', Sort is not gonna dependent on NAME AND WEIGHT. 
It only sort based on NAME as NAME is unique.
By keeping Height and weight with 'By' the variables will remain in the data set as it is;

proc sort data = class out = sorted_class;
by Name Height Weight;
run;

Proc transpose data = sorted_class out = trans_class;
id Sex;
var Age;
by Name Height Weight;
run;

proc print data = trans_class;
run;

*-----------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
CODE - 10 - Adding "Height" and "Weight" to VAR will OUTPUT 19*3 = 57 observations as each name has age, height and weight. 
-------------------------------------------------------------------------------------------------------------

proc sort data = class out = sorted_class;
by Name ;
run;

Proc transpose data = sorted_class out = trans_class;
id Sex;
var Age Height Weight;
by Name ;
run;

proc print data = trans_class;
run;



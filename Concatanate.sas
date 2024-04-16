*---------------------------------------------------------------------------
CONCATANATE - combine data sets 
----------------------------------------------------------------------------			
Following are used for concatenation

SET STATEMENT
Concatenation Operator - ||
Concatenation Function - CAT CATS CATX 
---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------;
Data List1;
Input Sku $ Product:$11. QTY Price;
Datalines;
S1290001 Laptoprty 50 979
S1290002 Laptopyoojb 30 632
S1290003 Desktopvbb 100 1299
S1290004 Desktopbn 80 1599
S1290005 Laptopgkk 10 2999
;
Run;

Data List2;
Input id Sku $ Prod $ QTY Price;
Datalines;
1 S1290006 Printer 300 229
2 S1290007 Printer 400 467
3 S1290008 Printer 100 899
4 S1290009 Cable 1200 8.99
5 S1290010 Cable 900 7.99
;
Run;
*-----------------------------------------------------------------------
------------------------------------------------------------------------
CODE 1 - SET STATEMENT
------------------------------------------------------------------------
Both LIST1 and LIST2 data set contain the same set of variables.
Variable "PROD" name is diff in 2 datasets - RENAME
------------------------------------------------------------------------;	
Data List (rename = (Product = Prod));
Set List1 List2;
Run;

*-----------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
CODE 2 - CATS FUN - Strip the space and concatenate
------------------------------------------------------------------------;

Data cat;
Set sashelp.class;
con = CATS(Name,Age);    *Output : Alfred14;
Run;

Proc print data = cat;
run;

*--------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
CODE 3 - CATS FUN - Adding text in between name and age 
NOTE : Concatenated variable has a default size of 200 bytes, to fix this add LENGTH statement 
----------------------------------------------------------------------------------------------;

Data cat;
Set sashelp.class;
length con $50;
con = CATS(Name,', age: ' ,Age);       *Output : Alfred, age:14 ;
Run;

Proc print data = cat;
run;


*--------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
CODE 4 - CATX FUN - Concatenate + Adds a delimiter + Removes Blank
First argument is the delimiter followed by variable names
NOTE : Concatenated variable has a default size of 200 bytes, to fix this add LENGTH statement 
---------------------------------------------------------------------------------------------;
Data cat;
Set sashelp.class;
length con $50;
con = CATX(",  ",Name,Age,Height,Weight);       *Output : Alfred,14,69,112.5 ;
Run;

Proc print data = cat;
run;

*More space can be added after demiliter (here,comma) if need more space after each variable;
con = CATX(",  ",Name,Age,Height,Weight);         *Output :  Alfred, 14, 69, 112.5;


*--------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
CODE 5 - CATX + VARIABLE LIST/NAMED RANGE LIST--last variable name)
(delimiter,of,first variable name--last variable name)
---------------------------------------------------------------------------------------------;
Data cat;
Set sashelp.class;
length con $50;
con = CATX(",",of Name--Weight);       *Output : Alfred,14,69,112.5 ;
Run;

Proc print data = cat;
run;

*--------------------------------------------------------------------------------------------
4 Diff types of variable List
---------------------------------------------------------------------------------------------;
*--------------------------------------------------------------------------------------------
CODE 6 >> CATX + VARIABLE LIST/NAMED RANGE LiST >> For character variable concatenation
(|,of,first variable name--last variable name)
--------------------------------------------------------------------------------------------;
Data cat ;
Set sashelp.class;
length con $50;
con = CATX("|",of Name-character-Weight);       *Output : Alfred|M ;
Run;

Proc print data = cat;
run;

*--------------------------------------------------------------------------------------------
CODE 7 >> VARIABLE LIST/NAMED RANGE LiST >> _ALL_ >> Concatenate all variables
(|,of,first variable name--last variable name)
--------------------------------------------------------------------------------------------;
Data cat ;
Set sashelp.class;
length con $50;
con = CATX(",",of _ALL_);       *Output : Alfred,14,69,112.5 ;
Run;

Proc print data = cat;
run;
*---------------------------------------------------------------------------------------------
other examples of variable lists in functions
of month1 - month12 (this includes all 12 months)
of month: (this includes any variable beginning with 'month')
---------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
​EXCERCISE
--------------------------------------------------------------------------------------------
Locate the PRDSAL2 and PRDSAL3 data sets from the SASHelp library. 
Concatenate the two data sets. Save the data set in the WORK library. 
How many observations are there in the combined data set?
--------------------------------------------------------------------------------------------;
Data salary2;
set sashelp.prdsal2;
run;

Data salary3;
set sashelp.prdsal3;
run;
*--------------------------------------------------------------------------------------------
CODE 8 - SET
--------------------------------------------------------------------------------------------;
Data Sal;
set salary2 salary3;
run;
*----------------------------------------------------------------------------
Two common issues when concatenating data sets
-----------------------------------------------------------------------------
(1) Inconsistent Variable Name - Fix it by using "RENAME" statement
(2) Length of the variable not same - Fix it by using "LENGTH" statement
-----------------------------------------------------------------------------;
Data Report1;
Input PatientID $ Gender $ Age; *LEN of patientID is 5;
Datalines;
P0001 M 32
P0002 F 28
P0003 M 48
P0004 F 39
P0005 M 25
;
Run;

Data Report2;
Input PID : $12. Gender $ Age;  *LEN of PID is 12;
Datalines;
P00000000001 M 32
P00000000002 F 28
P00000000003 M 48
P00000000004 F 39
P00000000005 M 25
;
Run;
*---------------------------------------------------------------------------------------------
PatientID and PID can't be combined into one column because of the different variable names - RENAME it.
----------------------------------------------------------------------------------------------;
Data report;
set report1 report2 (rename=(patientID = PID)); 
run;

*SAS takes the length from the first data set where len of PID is 5
 so it won't be able to give room for PID with len of 12, gives the below error
*ERROR: Variable PatientID is not on file WORK.REPORT2.;

Data Report;
Set Report1 Report2 (rename=(PID=PatientID));
Run;
*---------------------------------------------------------------------------------------------
2. Define the length of the variable
----------------------------------------------------------------------------------------------;
The Length statement assigns the length of 12 to the PatientID variable.
This alows the variable to capture all of the data point without being truncated.
LENGTH statement must be added before the SET statement, which is where the variables attributes are defined;

Data Report;
Length PatientID :$12.;
Set Report1 Report2 (rename=(PID = PatientID )); 
Run;

*---------------------------------------------------------------------------------------
PROC PRINT - is used to list the observations in a SAS data set
-----------------------------------------------------------------------------------------
Dataset - Blood
------------------------------------------------------------------------------------------
CODE - 1 PROC PRINT
------------------------------------------------------------------------------------------;

data blood;
infile"/home/u60674716/Datasets/Roncody_dataset/blood.txt" ;
input patient_id gender$ blood_type$ age_group$ rbc cholesterol;
run;

Title "Blood data";
proc print data=blood;
run;

*---------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
CODE 2 - VAR - To order the variables in listing - Variables will be listed according to the order in VAR statement
----------------------------------------------------------------------------------------------------------------;

data blood;
infile"/home/u60674716/Datasets/Roncody_dataset/blood.txt" ;
input patient_id gender$ blood_type$ age_group$ rbc cholesterol;
run;

Title "Print using VAR statement";
proc print data=blood;
var gender blood_type age_group;
run;

*--------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
CODE 3 - LABEL - To LABEL variable names - Label statement should be added with proc Print 
----------------------------------------------------------------------------------------------;
Title "Print using LABEL statement";
proc print data=blood LABEL;
LABEL gender = "Gender of patients" age_group = 'Age';
var gender blood_type age_group;
run;

*--------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
CODE 4 - BY - To group variables - Variables needs to be SORTED before grouping
----------------------------------------------------------------------------------------------;
data blood;
infile"/home/u60674716/Datasets/Roncody_dataset/blood.txt" ;
input patient_id gender$ blood_type$ age_group$ rbc cholesterol;
run;

*Multi - Level Sort - PROC SORT statements sort data by GENDER and, within each GENDER Age_group is sorted
Add an OUT = option to specify the SORTED output data set;

Title "Sort age and age_group ";
Proc sort data = blood out = sorted_blood;
by gender age_group;
run;


Title "Group BY Gender and Age Group";
proc print data=sorted_blood ;
LABEL gender = "Gender of patients" age_group = 'Age';
by gender age_group;
run;


*--------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
CODE 5 - ID Statement - To omit obs column 
If "BY statement" and an "ID statement", are used with the same variables - PROC PRINT does not
repeat the variable in the first column if the value has not changed, which makes listing easier to read
---------------------------------------------------------------------------------------------------------;


Title "Sort age and age_group ";
Proc sort data = blood out = sorted_blood;
by gender age_group;
run;


Title "ID to omit obs BY Gender and Age Group" ;
proc print data=sorted_blood ;
LABEL gender = "Gender of patients" age_group = 'Age';
BY gender age_group;
ID gender age_group;
run;


*--------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
CODE 6 - SUM Statement - To add subtotals and totals to the listing by including SUM and BY statements.
---------------------------------------------------------------------------------------------------------;

Title "Sort age and age_group ";
Proc sort data = blood out = sorted_blood;
by gender age_group;
run;



Title "SUM of variable";
proc print data=sorted_blood ;
LABEL gender = "Gender of patients" age_group = 'Age';
SUM cholesterol rbc;
BY gender age_group;
ID gender age_group;
run;


*--------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
CODE 7 - SPLIT Statement - To split the variable display using a special character
---------------------------------------------------------------------------------------------------------
Here "#" is used to display variable name ("Gender of patients") in a split form; 

proc print data=sorted_blood ;
LABEL gender = "Gender of patients" age_group = 'Age';
SUM cholesterol rbc;
BY gender age_group;
ID gender age_group;
run;

Title "Splitting of variable name";
proc print data=sorted_blood label split='#' ;
LABEL gender = "Gender#of#patients" age_group = 'Age';
SUM cholesterol rbc;
BY gender age_group;
ID gender age_group;
run;

*--------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
CODE 8 - Adding Titles and Footnotes to the Listing
---------------------------------------------------------------------------------------------------------;
Title "Sort age and age_group ";
Proc sort data = blood out = sorted_blood;
by gender age_group;
run;

title1 "Blood Dataset";
title2 "Prepared by Athira";
footnote "All patient data are  Confidential";
proc print data=sorted_blood ;
LABEL gender = "Gender of patients" age_group = 'Age';
SUM cholesterol rbc;
BY gender age_group;
ID gender age_group;
run;
*--------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
DATASET - 2 - Stock
CODE 9 - Changing the appearence of values using FORMAT in PRINT Statement
---------------------------------------------------------------------------------------------------------
In the Listing - purprice, selldate and sellprice will be displayed with Dollar sign;

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

proc print data = Stock;
format purdate mmddyy10. purprice dollar5.1 selldate mmddyy10. sellprice dollar4.1; 
run;

*----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
DATASET - Blood
CODE 9 - Controlling the Observations That Appear in Listing (Controlling the vaue of cholesterol using WHERE Statement)
-----------------------------------------------------------------------------------------------------------------------------;

data blood;
infile"/home/u60674716/Datasets/Roncody_dataset/blood.txt" ;
input patient_id gender$ blood_type$ age_group$ rbc cholesterol;
run;

Title "Sort age and age_group ";
Proc sort data = blood out = sorted_blood;
by gender age_group;
run;

*Only patients with cholesterol > 5 will be listed ;

Title "Group BY Gender and Age Group";
proc print data=sorted_blood ;
WHERE cholesterol gt 5;
LABEL gender = "Gender of patients" age_group = 'Age';
by gender age_group;
run;

*----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
DATASET - Blood
CODE 9 - Adding the Number of Observations in Listing
-----------------------------------------------------------------------------------------------------------------------------;
data blood;
infile"/home/u60674716/Datasets/Roncody_dataset/blood.txt" ;
input patient_id gender$ blood_type$ age_group$ rbc cholesterol;
run;

Title "Sort age and age_group ";
Proc sort data = blood out = sorted_blood;
by gender age_group;
run;


Title1 "Demonstrating the N= option of PROC PRINT";
proc print data=sorted_blood n="Total number of Observations:" ;
WHERE cholesterol gt 5;
LABEL gender = "Gender of patients" age_group = 'Age';
by gender age_group;
run;

*----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
DATASET - Blood
CODE 10 - Listing the First n Observations of Your Data Set
----------------------------------------------------------------------------------------------------------------------------;

proc print data=sorted_blood (obs = 15);
WHERE cholesterol gt 5;
LABEL gender = "Gender of patients" age_group = 'Age';
by gender age_group;
run;

*----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
DATASET - Blood
CODE 11 - Listing a specific num of observations in the Data Set
----------------------------------------------------------------------------------------------------------------------------
Here first observation is 10 and last observation is 15 - total 6 observations will be listed;
 
proc print data=sorted_blood (firstobs=10 obs = 15);
WHERE cholesterol gt 5;
LABEL gender = "Gender of patients" age_group = 'Age';
by gender age_group;
run;

*----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
DATASET - Blood
CODE 12 - nobs - To remove the default obs column from the output Data Set
----------------------------------------------------------------------------------------------------------------------------;
data blood;
infile"/home/u60674716/Datasets/Roncody_dataset/blood.txt" ;
input patient_id gender$ blood_type$ age_group$ rbc cholesterol;
run;

proc print data =Blood noobs;
run;


*----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
DATASET - Blood
CODE 13 - HEADING - To present the column headings in vertical in output (Default is Horizontal)

----------------------------------------------------------------------------------------------------------------------------;
data blood;
infile"/home/u60674716/Datasets/Roncody_dataset/blood.txt" ;
input patient_id gender$ blood_type$ age_group$ rbc cholesterol;
run;

proc print data =Blood heading=vertical;
run;



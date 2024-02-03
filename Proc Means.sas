*---------------------------------------------------------------------------            
              *PROC MEANS 
----------------------------------------------------------------------------
PROC MEANS by default produce summary statistics for all Numeric Variables

Summary Statistics
----------------------------------------------------------------------------
N - Non - missing values
Mean - Mean of Numeric variables
SD - SD of numeric variables
Min - Min value
Max - Max value 
-----------------------------------------------------------------------------
Dataset - Blood.txt 
CODE - 1 - Find the summary statistics using PROC MEANS
-----------------------------------------------------------------------------;

data blood;
infile"/home/u60674716/Datasets/Roncody_dataset/blood.txt" ;
input patient_id gender$ blood_type$ age_group$ wbc rbc cholesterol;
run;


Title "Report for Blood data";
proc print data=blood;
run;

Title "PROC MEANS With All the Defaults";
proc means data=blood;
run;

*---------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
CODE - 2 - To find Missing values, Median, Variance, Upper Confidence Limit, Lower confidence Limit, Q1 (First Quartile)
 & Q3 (Third Quartile)
----------------------------------------------------------------------------------------------------------;
data blood;
infile"/home/u60674716/Datasets/Roncody_dataset/blood.txt" ;
input patient_id gender$ blood_type$ age_group$ wbc rbc cholesterol;
run;


Title "To find NMiss, median, uclm, lclm and var for blood Data";
proc means data=blood N mean median std uclm lclm var q1 q3;
run;


*---------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
CODE - 3 -  VAR statement - To control which variables to include in the statistics 
----------------------------------------------------------------------------------------------------------;
data blood;
infile"/home/u60674716/Datasets/Roncody_dataset/blood.txt" ;
input patient_id gender$ blood_type$ age_group$ wbc rbc cholesterol;
run;

Title "Selected Statistics Using VAR statement";
proc means data=blood maxdec=3 n nmiss mean median std var q1 q3;
var  RBC cholesterol;
run;

*---------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
CODE - 4 -  BY statement - To group Data - To see the descriptive statistics for each level of another variable
GENDER column has male and female - To separate analysis using GENDER, use BY Statement.
Column should be sorted before using 'BY'; 
----------------------------------------------------------------------------------------------------------;
data blood;
infile"/home/u60674716/Datasets/Roncody_dataset/blood.txt" ;
input patient_id gender$ blood_type$ age_group$ wbc rbc cholesterol;
run;

PROC SORT data = blood out = sorted_blood;
by gender age_group; *Sorting by Gender and Age;
run;

Title "Selected Statistics Using VAR statement";
proc means data=sorted_blood maxdec=3 n nmiss mean median std var Q1 Q3 ; *MAXDEC = value -> To control decimal places;
var rbc cholesterol;
BY gender age_group; *Grouping by Gender and Age;
where cholesterol gt 6 and rbc gt 5000; *Filtering values;
run;


*---------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
CODE - 5 -  CLASS statement - To group Data by 'GENDER' -  SORT is not required while using CLASS statement
----------------------------------------------------------------------------------------------------------;
data blood;
infile"/home/u60674716/Datasets/Roncody_dataset/blood.txt" ;
input patient_id gender$ blood_type$ age_group$ wbc rbc cholesterol;
run;


Title "Selected Statistics Using VAR statement";
proc means data = blood maxdec=3 n nmiss mean median std var Q1 Q3 ;
var rbc cholesterol;
CLASS gender;
where cholesterol gt 6 and rbc gt 5000;
run;

Why this dataset is printing all values rather than filtered ones?;

proc print data = blood n="obs";
run;

*---------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
CODE - 6 - OUTPUT OUT - To  Create a NEW DATASET that contains summary information with user-defined names 
----------------------------------------------------------------------------------------------------------;
data blood;
infile"/home/u60674716/Datasets/Roncody_dataset/blood.txt" ;
input patient_id gender$ blood_type$ age_group$ wbc rbc cholesterol;
run;

proc means data=blood noprint;
var RBC cholesterol;                     *An OUTPUT statement tells PROC MEANS that you want to create a summary SAS data set. 
                                          The keyword OUT = is used to name the new data set;
output out = blood_stats 
mean = M_RBC M_chole
n = N_RBC N_chole
nmiss = Miss_RBC Miss_chole
median = Med_RBC Med_chole;
run;
proc print data= blood_stats ;
run;

*---------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
CODE - 7 -  Creating a report with SAS Autoname 
----------------------------------------------------------------------------------------------------------;

data blood;
infile"/home/u60674716/Datasets/Roncody_dataset/blood.txt" ;
input patient_id gender$ blood_type$ age_group$ wbc rbc cholesterol;
run;

proc means data=blood noprint;
var RBC cholesterol;
output out = blood_stats
mean = 
n =
nmiss =
median = / autoname;
run;

proc print data= blood_stats;
run;

*---------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
CODE - 8 -  Using two CLASS variables with PROC MEANS 
----------------------------------------------------------------------------------------------------------
In the O/P 
_Type_ 0 analyze the mean of all non-missing values in the data set -  called the grand mean.
_Type_ 1 analysis is Age wise - Old & Young.
_Type_ 2 analysis is Gender wise - Male & Female
_Type _3 analysis is combination of Age & Gender  ;

data blood;
infile"/home/u60674716/Datasets/Roncody_dataset/blood.txt" ;
input patient_id gender$ blood_type$ age_group$ wbc rbc cholesterol;
run;

proc means data=blood ;
class Gender Age_Group;
var RBC cholesterol;
output out = summary
mean =
n = / autoname;
run;

proc print data= summary ;
run;

*---------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
CODE - 9 -  dding the CHARTYPE Procedure Option to PROC MEANS
-------------------------------------------------------------------------------------------------;
proc means data=Blood noprint chartype;
class Gender Age_Group;
var RBC WBC;
output out = Summary
mean =
n = / autoname;
run;

*_TYPE_ represents Character Type -  character string of 1’s and 0’s.

Gender	 AgeGroup 		Interpretation
0 			0 			Mean for all Genders and all AgeGroups
0 			1 			Mean for each level of AgeGroup
1 			0 			Mean for each level of Gender
1 			1 			Mean for each combination of Gender and AgeGroup

*---------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
CODE - 10 - nway - To display only combination values ( Not to display Grand mean)
----------------------------------------------------------------------------------------------------------;
In the O/P 
nway >> Gives only combination of variables - _Type _3;
 

data blood;
infile"/home/u60674716/Datasets/Roncody_dataset/blood.txt" ;
input patient_id gender$ blood_type$ age_group$ wbc rbc cholesterol;
run;

proc means data=blood nway; *nway -- Specifies that the output data set contain only statistics for the observations with the highest _TYPE_ and _WAY_ values;
class Gender Age_Group;
var RBC cholesterol;
output out = summary
mean =
n = / autoname;
run;

proc print data= summary ;
run;


*---------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
CODE - 11 -   Applying Format to class variable
----------------------------------------------------------------------------------------------------------;
proc format;  *User defined format for cholesterol;
value Chol_Group
low -< 200 = 'Low'
200 - high = 'High';
run;

title "Using a CLASS Statement with PROC MEANS";
proc means data=Blood n nmiss mean median maxdec=1;
class Cholesterol;
format Cholesterol Chol_Group.;
var RBC ;
run;


proc print data = blood;
where cholesterol lt 200;
run;
*----------------------------------------------------------------------------------------------------------
*"CLASS" Statement Vs "BY" Statement.
----------------------------------------------------------------------------------------------------------
CLASS Statement
---------------
When "Class" statement is used to GROUP variables - Sorting of variable is not required.
Output of CLASS default gives _type_ and _freq_ columns which can be dropped if not needed.
Use "nway" to give combination of data and remove _type_ and _freq_ columns.

BY Statement
----------------
When 'BY' statement is used to GROUP variables - Sorting of variable is required before Grouping.
By statement always gives combination of variables by default  
No default columns _type_ and _freq_ in the output


If the data set is unsorted and very large choose CLASS statement
if the data set is in the sorted order use either a CLASS or a BY statement
---------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
CODE - 12 -  Different statistics for each variable 
---------------------------------------------------------------------------------------------------------;
proc means data=blood  ;
class Gender Age_Group;
output out = Diff_Stat
mean(RBC cholesterol) =
n(RBC ) =
median(Cholesterol) = / autoname
 ;
run;

proc print data = Diff_Stat ;
run;



*---------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
CODE - 13 - printalltypes - Printing all Possible Combinations of  Class Variables
---------------------------------------------------------------------------------------------------------;

title " PRINTALLTYPES Option";
proc means data = Blood printalltypes;
class Gender Age_Group;
var RBC WBC;
run;

*---------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
CODE - 14 -  To store the analysis result in an output dataset in required format(sas/rtf)
---------------------------------------------------------------------------------------------------------;
data blood;
infile"/home/u60674716/Datasets/Roncody_dataset/blood.txt" ;
input patient_id gender$ blood_type$ age_group$ wbc rbc cholesterol;
run;


ods output summary=blood_output;
proc means data=sashelp.class stackodsoutput maxdec=1 n mean max median min  std stderr;
class sex;
var height weight;
run;
ods output close;








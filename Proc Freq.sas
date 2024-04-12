*=========================================================================================
              PROC FREQ - computes counts for each unique value of a variable
===========================================================================================
PROC FREQ can be used to count frequencies of both character and numeric variables in
(i) One-way
(ii) Two-way
(iii) Three-way tables.

PROC FREQ is used to create output data sets containing counts and percentages. 
It also compute various statistics such as chi-square, odds ratio, and relative risk

==============================================================================================
CODE 1 - PROC FREQ default generates frequency for all variables in the dataset +
It also generates cumulative percent and cumulative frequency
==============================================================================================;
data survey;
input s_no gender$ age salary Ques1 Ques2 Ques3 Ques4 Ques5 ;
cards;
001 M 23 28000 1 2 1 2 3
002 F 55 76123 4 5 2 1 1
003 M 38 36500 2 2 2 2 1
004 F 67 12000 5 3 2 2 4
005 M 22 23060 3 3 3 4 2
006 M 63 10000 2 3 5 4 3
007 F 45 76100 5 3 4 3 3
;
run;

proc freq data=survey ;
run;

proc print data=survey;
run;
*=============================================================================================
==============================================================================================
==============================================================================================
CODE 2 - Use "Table" satement to select the desired variables from dataset
----------------------------------------------------------------------------------------------
nocum -  NOCUM is a TABLES option that tells PROC FREQ not to include the two cumulatives
nopercent - For eliminating the percentages
==============================================================================================;
data survey;
input s_no gender$ age salary Ques1 Ques2 Ques3 Ques4 Ques5 ;
cards;
001 M 23 28000 1 2 1 2 3
002 F 55 76123 4 5 2 1 1
003 M 38 36500 2 2 2 2 1
004 F 67 12000 5 3 2 2 4
005 M 22 23060 3 3 3 4 2
006 M 63 10000 2 3 5 4 3
007 F 45 76100 . 3 4 3 3
;
run;

proc freq data=survey;
table gender Ques1-Ques3/ nocum nopercent;
run;

proc print data=survey;
run;
*=============================================================================================
==============================================================================================
==============================================================================================
CODE 3 - 'OUT'- To store the analysis in an output dataset
----------------------------------------------------------------------------------------------
use 'OUTPUT' with tables 
==============================================================================================;
data blood;
infile"/home/u60674716/Datasets/Roncody_dataset/blood.txt" ;
input patient_id gender$ blood_type$ age_group$ wbc rbc cholesterol;
run;

proc freq data=blood noprint;
where rbc ne .;
tables rbc*wbc /out = blood_out;
run;

proc print data = blood_out;
run;
*=============================================================================================
==============================================================================================
*=============================================================================================
CODE 4 - Using FORMAT to label and group values
---------------------------------------------------------------------------------------------
Datatype of variable "Question" should be character as the format used for the variable in proc format is character . 
Else SAS will through the following error
ERROR: You are trying to use the character format $LIKERT with the numeric variable Ques1 in data set WORK.SURVEY.
===================================================================================================================;
data survey;
input s_no gender$ age salary Ques1$ Ques2$ Ques3$ Ques4$ Ques5$ ;
cards;
001 M 23 28000 1 2 1 2 3
002 F 55 76123 4 5 2 1 1
003 M 38 36500 2 2 2 2 1
004 F 67 12000 5 3 2 2 4
005 M 22 23060 3 3 3 4 2
006 M 63 10000 2 3 5 4 3
007 F 45 76100 5 3 4 3 3
;
run;


proc format;
value $Gender
'F' = 'Female'
'M' = 'Male';
value $Likert
'1' = 'Strongly disagree'
'2' = 'Disagree'
'3' = 'No opinion'
'4' = 'Agree'
'5' = 'Strongly agree';
value age_group
low -  < 25 = "youngage"
25 - < 50 = "Middleage"
60 - high = "Seniors" ; *55 is not added in any of the age-groups,so it will appear as 55 in the report;
;
run;
title "Adding Formats";
proc freq data=survey;
tables Gender Ques1-Ques5 age/ nocum;
format Gender $Gender.
Ques1-Ques5 $Likert.
age age_group.;
run;

*==========================================================================================================
*=============================================================================================
CODE 5 - PROC FREQ - Handling missing values while using PROC FORMAT
Here percentages are computed as the frequency of each category divided by the number of nonmissing values
*=============================================================================================
===================================================================================================================;
data survey;
input s_no gender$ age salary Ques1 Ques2 Ques3 Ques4 Ques5 ;
cards;
001 M 23 28000 1 2 1 2 3
002 F 55 76123 4 5 2 1 1
003 M 38 36500 2 2 2 2 1
004 F .  12000 5 3 2 2 4
005 M 22 23060 3 3 3 4 2
006 M 63 10000 2 3 5 4 3
007 F .  56100 5 3 4 3 3 
008 M 13 88000 1 2 1 2 3
009 F 15 36123 4 5 2 1 1
;
run;

proc format;
value age_group
18 -< 25 = "youngage"
25 -< 50 = "Middleage"
50 - high = "Seniors"

;
run;

proc freq data = survey order = data;
tables age gender/nocum ;
format age age_group. ;
run;


*=============================================================================================
==============================================================================================
=============================================================================================
CODE 6 - PROC FREQ - TABLES option "MISSING" -  Displaying Missing Values in the Frequency Table
With "MISSING" option - SAS computes frequencies by dividing the frequencies by the number of missing and nonmissing observations
---------------------------------------------------------------------------------------------;
data survey;
input s_no gender$ age salary Ques1 Ques2 Ques3 Ques4 Ques5 ;
cards;
001 M 23 28000 1 2 1 2 3
002 F 55 76123 4 5 2 1 1
003 M 38 36500 2 2 2 2 1
004 F .  12000 5 3 2 2 4
005 M 22 23060 3 3 3 4 2
006 M 63 10000 2 3 5 4 3
007 F .  56100 5 3 4 3 3 
008 M 13 88000 1 2 1 2 3
009 F 15 36123 4 5 2 1 1
;
run;

proc format;
value age_group
18 -< 25 = "youngage"
25 -< 50 = "Middleage"
50 - high = "Seniors"
other = "other values"
;
run;

proc freq data = survey; 
tables age / missing;
format age age_group. ;
run;

*=============================================================================================
=============================================================================================
=============================================================================================
CODE 7 - PROC FREQ - Changing the Order of Values in PROC FREQ
---------------------------------------------------------------------------------------------
Formatted Orders - values by their formatted value
Freq Orders - values from the most frequent to the least frequent
Data Orders - values based on their order in the input data set
---------------------------------------------------------------------------------------------;
data survey;
input s_no gender$ age salary Ques1 Ques2 Ques3 Ques4 Ques5 ;
cards;
001 M 23 28000 1 2 1 2 3
002 F 55 76123 4 5 2 1 1
003 M 38 36500 2 2 2 2 1
004 F .  12000 5 3 2 2 4
005 M 22 23060 3 3 3 4 2
006 M 63 10000 2 3 5 4 3
007 F .  56100 5 3 4 3 3 
008 M 13 88000 1 2 1 2 3
009 F 15 36123 4 5 2 1 1
;
run;

proc format;
value age_group
18 -< 25 = "youngage"
25 -< 50 = "Middleage"
50 - high = "Seniors"
other = "other values"
;
run;

proc freq data = survey order=data  ;
tables age / missing;
format age age_group. ;
run;

*ORDER=freq option lists most frequent to the least frequent. 
Especially useful when you have a large number of categories and you want to see which values r most frequent;

                                   
proc freq data = survey order=freq;  
tables age / missing;
format age age_group. ;
run;

proc freq data = survey order=formatted;
tables age / missing;
format age age_group. ;
run;

*=============================================================================================
==============================================================================================
=============================================================================================
CODE 8 - PROC FREQ - Producing Two-Way Tables - Using "*" + nlevels
nlevels - Displays the "Number of Variable Levels" table, which provides the number of levels 
for each variable named in the TABLES statements.
---------------------------------------------------------------------------------------------;

proc freq data = survey nlevels;
tables age*gender/nocol norow nopercent;
run;

proc print data = survey;
run;

*=============================================================================================
==============================================================================================
=============================================================================================
CODE 9 - PROC FREQ - Producing Three-Way Tables - Using "*"
---------------------------------------------------------------------------------------------;
proc freq data = survey;
tables gender*age*salary/nocol norow nopercent; *eliminate the column percentage, row percentage, and overall percentage figures from the table;
run;
*=============================================================================================
==============================================================================================
=============================================================================================
CODE 10 - PROC FREQ - Producing Two-Way Table - Using format
---------------------------------------------------------------------------------------------;

data survey;
input s_no gender$ age salary Ques1 Ques2 Ques3 Ques4 Ques5 ;
cards;
001 M 23 28000 1 2 1 2 3
002 F 55 76123 4 5 2 1 1
003 M 38 36500 2 2 2 2 1
004 F 67 12000 5 3 2 2 4
005 M 22 23060 3 3 3 4 2
006 M 63 10000 2 3 5 4 3
007 F 45 76100 5 3 4 3 3
008 M 13 88000 1 2 1 2 3
009 F 15 36123 4 5 2 1 1
;
run;

proc format;
value $gender 
'M' = "Male"
'F' = "Female"
;
value age
18 -< 25 = "youngage"
25 -< 50 = "Middleage"
50 - high = "Seniors"
other = "other values"
;
run;

proc freq data = survey formchar=(1,2,3); 
tables gender*age;
format age age. 
gender $gender.;
run;
*=============================================================================================
==============================================================================================
=============================================================================================
CODE 11 - PROC FREQ - n Way Tables - using LIST & CROSSLIST
---------------------------------------------------------------------------------------------;
proc format;
value $gender 
'M' = "Male"
'F' = "Female"
;
value age
18 -< 25 = "youngage"
25 -< 50 = "Middleage"
50 - high = "Seniors"
other = "other values"
;
run;

proc freq data = survey ; 
tables gender*age*salary/list;
format age age. 
gender $gender.;
run;

proc freq data = survey ; 
tables gender*age*salary/crosslist;
format age age. 
gender $gender.;
run;

*--------------------------
formchar(1,2,7)
---------------------------;
vertical separators (position 1), the horizontal separators (position 2)
and the vertical-horizontal intersections (position 7)
data blood;
infile"/home/u60674716/Datasets/Roncody_dataset/blood.txt" ;
input patient_id gender$ blood_type$ age_group$ wbc rbc cholesterol;
run;

PROC freq data = blood formchar(1,2,7)='|-+';
run;
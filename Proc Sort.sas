*=================================================================================
                                 PROC SORT
==================================================================================
PROC SORT lets you see the listing in order from lowest to highest by default.

If precede the variable name with the keyword DESCENDING > list from lowest to highest

OUT = option can be added to the proc sort to specify an output data set to save the sorted dataset 
so that the original data set won't be changed.

BY statement - requires sorting variable
-----------------------------------------------------------------------------------------
Dataset - Blood
------------------------------------------------------------------------------------------
CODE - 1 PROC SORT - Default sort by ascending
------------------------------------------------------------------------------------------;

data blood;
infile"/home/u60674716/Datasets/Roncody_dataset/blood.txt" ;
input patient_id gender$ blood_type$ age_group$ wbc rbc cholesterol;
run;

PROC SORT DATA = blood OUT = sorted_blood;
BY wbc;
run;

proc print data = sorted_blood;
run;

* OUTPUT - All the missing values will be listed first followed by wbc values in the ascending order
-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
Dataset - Blood
------------------------------------------------------------------------------------------
CODE - 2 - PROC SORT -  Sorting 2 columns ASCENDING
------------------------------------------------------------------------------------------;

PROC SORT DATA = blood OUT = sorted_blood;
BY wbc rbc;
run;

*OUTPUT - All the missing values will be listed first followed by wbc values in the ascending order 


-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
Dataset - Blood
------------------------------------------------------------------------------------------
CODE - 3 - PROC SORT - SORT rbc and cholesterol by Ascending & wbc by Descending
------------------------------------------------------------------------------------------;
PROC SORT DATA = blood OUT = sorted_blood;
BY rbc cholesterol DESCENDING wbc;
run;


proc print data = sorted_blood;
run;

*----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
CODE - 4 - SORT wbc by Descending 
-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------;

PROC SORT DATA = blood OUT = sorted_blood;
BY DESCENDING wbc rbc cholesterol;
run;

proc print data = sorted_blood;
run;

*OUTPUT - The first level of sorting is: DESCENDING wbc

Within the same value for WBC rows, rbc get sorted by ascending and then within the same value of rbc 
cholesterol get sorted by ascending .

*----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
CODE - 5 
-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------;
data Employees;
input Eid Designation $ Salary;
cards;
101 Tester 3400
102 Progmer 4500
103 tester 3400
104 Analyst 2400
105 analyst 3000
;

proc sort data=Employees out=sorted_Emp;
by Designation;
run;

proc print data=Employees;
run;

*----------------------------------------------------------------------------------------
Character sorting
-----------------------------------------------------------------------------------------
Character sorting: char sorting is controlled by ASCII values.  
Upper case A, B, ---- Z 
SAS ASCII Values A=40 Z=66. 
Lower case a, b, c, ---- z, 
SAS ASCII Values a=70 --- z=96. 
As lowercase letters have higher value than uppercase letters, 
sorting order will be done in opposite order.

blank ! " # $ % & ' ( ) * + , - . /0 1 2 3 4 5 6 7 8 9 : ; < = > ? @
A B C D E F G H I J K L M N O P Q R S T U V W X Y Z[ \] ˆ_
a b c d e f g h i j k l m n o p q r s t u v w x y z { } ~;
*-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
CODE - 6 - Character sorting 
-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------;
data labs;
input pid$;
cards;
A
99
93
96
a
.
-1
$
;
run;

proc sort data =labs;
by  pid;
run;

proc print data=labs;
run;

*Output - Order -  missing value, special characters, Numbers , Capital letter and Small letter
-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
 CODE - 7 - Sorting 
-----------------------------------------------------------------------------------------;
-----------------------------------------------------------------------------------------
data lab;
input x y;
cards;
+1 10
-1 20
0 30
0 40
;
run;

proc sort data=lab;
by x;
run;

proc print data=lab;
run;

*Output - Order of x -> (-1, 0, 0, 1)
*-----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
 CODE - 8 - sorting - GROUPING
 ------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------;

data clinical;
input pid center$ year Age;
cards;
123 appolo 1999 56
134 nims   1998 60
123 appolo  1999 56
167 nims   1994 89
189 care   1889 90
167 nims   1994 56
178 care  1997    87
;
run;

proc print data=clinical;
run;

proc sort data=clinical ;
by center;
run;

proc print data=clinical;
id center;
by center;
run;

*-----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
  CODE - 9 - PAGE BY -  Generate the report in different pages
-----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------;

 proc print data=clinical;
 by center;
 pageby center;
 run;
 
*------------------------------------------------------------------------------------------
Dataset - EXAM
------------------------------------------------------------------------------------------;
Data Exam;
Input Subject $ Student $ Results;
Datalines;
Math Mary 78
Math John 67
Math Tom 98
Math Chris 56
Math Amy 89
English Mary 74
English John 79
English Tom 88
English Chris 92
English Amy 45
History Mary 32
History John 96
History Tom 55
History Chris 67
History Amy 86
;
Run;
*-----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
CODE - 10 - FLAGGING EXTREME VALUES - To identify the best and worst mark for each subject
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------;
Proc Sort Data=Exam out = exam_new;
By Subject Results;
Run;
*-------------------------------------------------------------------------------------------
TO FIND EXTREME VALUES - Use "FIRST" & "LAST"
--------------------------------------------------------------------------------------------
The variable "i" flags the students with the highest and lowest results.
The students with the highest results are all flagged as "2".
The students with the lowest results are all flagged as "1".
-------------------------------------------------------------------------------------------;
Data Exam2;
Set exam_new;
By Subject Results;
if first.subject then i=1;
else if last.subject then i=2;
if i in(1,2); *Subsetting to display only the lowest & highest;
Run;
*-----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
*-------------------------------------------------------------------------------------------
CODE - 11 - RAN the above code using "WHERE" for subsetting  - ERROR MESSAGE - Variable i is not on file WORK.EXAM_NEW.
-------------------------------------------------------------------------------------------;
Data Exam2;        
Set exam_new;
By Subject Results;
if first.subject then i=1;
else if last.subject then i=2;
where i in(1,2);
run;
*----------------------------------------------------------------------------------------------
POINT TO NOTE
--------------------------------------------------
WHERE statement subsets the data set before the data is read into the PDV.
As a result, it cannot be used on variables that don't already exist in the input data set
*------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
Dataset - FISH - Identify the heaviest fish from each species?
------------------------------------------------------------------------------------------
CODE - 12 - FISH
------------------------------------------------------------------------------------------;
Data fish;
set sashelp.fish;
run;

proc sort data = fish out = sor_fish;
by Species Weight;
run;

Data heaviest_fish;
set work.sor_fish;
By Species Weight; *"BY" variables used in SORT should be added in Data step ;
if first.Species then i=1;
else if last.Species then i = 2;
if i in (1,2);
run;

proc print data = heaviest_fish;
run;
*------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
Dataset - CARS - Identify the most and least powerful cars (HORSEPOWER) from each car maker (MAKE).
------------------------------------------------------------------------------------------
CODE - 12 - CARS
-----------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------;
Data cars;
set sashelp.cars;
run;

proc sort data =cars  out = sor_cars;
by Make Horsepower;
run;

Data hp_cars;
set work.sor_cars;
By Make Horsepower; *"BY" variables used in SORT should be added in Data step ;
if first.Make then i=1;
else if last.Make then i = 2;
if i in (1,2);
run;

proc print data = hp_cars;
run;










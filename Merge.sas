*==========================================================================================
							MERGE 
===========================================================================================
Merge multiple  datasets using common variable(merging variable)

STEP1 : SORT each dataset separately using "BY" ( common variable/ merging variable)
STEP2 : MERGE 2 datasets and use BY Statement with merging/common variable.
--------------------------------------------------------------------------------------------
The MERGE statement tells SAS to merge the data sets.
The BY statement tells SAS to merge them by matching the (merging) variable.

Different Types Of Merge:
---------------------------
ONE - to - ONE MERGE 
Each observation in one dataset has exactly one matching observation in the other dataset based on a common identifier.

ONE - to - MANY MERGE 
Each observation in the primary dataset can have multiple matching observations in the secondary dataset based on a common identifier.
However, each observation in the secondary dataset has only one corresponding match in the primary dataset.

MANY - tO - MANY MERGE 
Each observation in the primary dataset can have multiple corresponding matches in the secondary dataset.
Simultaneously, each observation in the secondary dataset can have multiple corresponding matches in the primary dataset.
-----------------------------------------------------------------------------------------------
Dataset Profile and Exam
-----------------------------------------------------------------------------------------------;
Data Profile;
Input Student $ Gender $ Grade;
Datalines;
SID0001 M 7
SID0004 F 7
SID0002 F 7
SID0003 M 8
SID0007 M 6
SID0005 F 9
SID0006 F 9
SID0009 M 7
SID0008 M 7
SID0010 F 10
;
Run;

Data Exam;
Input Student $ Result;
Datalines;
SID0009 70
SID0001 78
SID0004 99
SID0002 90
SID0003 81
SID0008 81
SID0005 78
SID0006 66
SID0007 34
SID0010 66
;
Run;
*----------------------------------------------------------
-----------------------------------------------------------
CODE 1 -  MERGE - ONE to ONE MERGE
-----------------------------------------------------------
Step 1: SORT both the datasets;

Proc Sort Data=Profile out = prof_out;
By Student;
Run;

Proc Sort Data=Exam out = Exam_out;
By Student;
Run;

Data Combined;
Merge prof_out Exam_out;
By Student;
Run;

proc print data = Combined;
run;

*----------------------------------------------------------
-----------------------------------------------------------
-----------------------------------------------------------
CODE 2 -  MERGE - ONE to ONE 
-----------------------------------------------------------
The POPULATION data set contains the population information related to 8 metropolitan cities across North America.
The UBER data set contains the number of Uber drivers in each of the metropolitan cities.
Merge the POPULATION and UBER data set and calculate the Driver to Population ratio:
Ratio = Number of Uber driver / Population.
Which city has the highest Uber driver to population ratio?
-----------------------------------------------------------;
Data Population;
Input Country $ City: $30. Population;
Datalines;
Canada Toronto 6000000
Canada Montreal 4000000
Canada Vancouver 2400000
US Chicago 2700000
US New_York 8400000
US Los_Angeles 3800000
Mexico Mexico_City 8500000
Mexico Cancun 620000
;
Run;

Data Uber;
Input Country $ Cities: $30. NumDriver;
Datalines;
US Chicago 20000
US New_York 14000
US Los_Angeles 16000
Canada Toronto 13000
Canada Montreal 5000
Mexico Mexico_City 20000
Mexico Cancun 11000
Canada Vancouver 7000
;
Run;

*----------------------------------------------------------
-----------------------------------------------------------
-----------------------------------------------------------
DATASET -  PARENT & FAMILY (DEALING WITH UNMATCHED OBSERVATIONS)
-----------------------------------------------------------;
DATA parent; 
INPUT famid name $ inc  ; 
Datalines; 
2 Art  22000 
1 Bill 30000 
3 Paul 25000 
5 jack 25000 
; 
RUN; 

DATA family; 
INPUT famid  famin96 famin97 famin98 ; 
Datalines;  
3    75000 76000 77000 
1    40000 40500 41000 
2    45000 45400 45800 
4    45000 45400 45800
;
run;

*-----------------------------------------------------------
CODE 3 -  MERGE - DEALING WITH UNMATCHED OBSERVATIONS 
-----------------------------------------------------------;
proc sort data=parent out=parent_sor;
by famid;
run;

proc sort data=family out=fam_sort ;
by famid;
run;
*-----------------------------------------------------------------------------------------------------------------------
The (in=) option identifies the input data sets when merging the data.
It creates a variable called "a" that is not visible in the data set(the variable "a" does not exist in the data set,However, it exists in the data step) 
That is, you can refer to this variable in your program.​The variable "a" contains either a 1's or 0's (binary).
In this example the variable "a" is associated with the data set Parent. It is flagged as "1" if the observation is contributed by Parent.
The observations that are NOT contributed by parent (i.e. famid 4) is flagged as "0".
When both "a" and "b" are 1's, the observations are contributed by both parent and family (matched observations are flagged as "MATCH"
​When the observations are not matching, and they are contributed by only parent, the observations are flagged as "PARENT".
when the observations are contributed by only family, they are flagged as "FAMILY".
-------------------------------------------------------------------------------------------------------------------------;
DATA fam ; 
MERGE parent_sor(in=a) fam_sort(in=b); 
BY famid;  
If a=1 and b=1 then Source = 'MATCH'; *OR a = b;
else if a=1 then Source='Parent';
else if b=1 then Source='family';
run;
  
proc print data = fam;
run;
 
 
*OR;

DATA fam1 ; 
  MERGE parent_sor(in=a) fam_sort(in=b); * a & b - indicator variables representing sorted datasets dad and fam;
  BY famid; 
  if a=b then x="1"; *If the observation is present in both dad and fam datasets 
                            indicator variables a and b are both 1, set x to "1";
  if a ne b then  x="2";  *If the observations in a and b are not equal, then
                             set x to "2";
  run;
  
  
*values common to only a and b; 
DATA fam2 ; 
  MERGE parent_sor(in=a) fam_sort(in=b); 
  BY famid; 
  if a = b ;
  run; 
 
*values not common to a and b; 
  DATA fam3 ; 
  MERGE parent_sor(in=a) fam_sort(in=b); 
  BY famid; 
  if a ne b ;
  run; 

*values in a not in b;  
  DATA fam4 ; 
  MERGE parent_sor(in=a) fam_sort(in=b); 
  BY famid; 
  if a and not b ;
  run; 
  
  *values only in a;  
  DATA fam5 ; 
  MERGE parent_sor(in=a) fam_sort(in=b); 
  BY famid; 
  if a  ;
  run; 
  
   *values only in b;  
  DATA fam6 ; 
  MERGE parent_sor(in=a) fam_sort(ina=b); 
  BY famid; 
  if b  ;
  run; 
*----------------------------------------------------------
-----------------------------------------------------------
-----------------------------------------------------------
Creating different datasets for each condition 
-----------------------------------------------------------;

Data common not_comn in_a in_b a_notb b_nota;
MERGE parent_sor(in=a) fam_sort(in=b); 
BY famid; 
if a=b then output common;
if a ne b then output not_comn;
if a then output in_a;
if b then output in_b;
if a and not b then output a_notb;
if b and not a then output b_nota;
run;

*----------------------------------------------------------
-----------------------------------------------------------
-----------------------------------------------------------
Creating different variables to store different conditions - where each satisfied condition is marked "Y"
-----------------------------------------------------------;

Data par_fam;
MERGE parent_sor(in=a) fam_sort(in=b); 
BY famid; 
if a=b then comn = "Y";
if a ne b then not_comn = "Y";
if a then in_a = "Y";
if b then in_b = "Y";
if a and not b then a_notb = "Y";
if b and not a then b_nota = "Y";
run;

*----------------------------------------------------------
-----------------------------------------------------------
-----------------------------------------------------------
CODE 3 -  MERGE - ONE to MANY 
-----------------------------------------------------------

DATA Dad; 
 INPUT famid dad_name $ inc ; 
CARDS; 
2 Art  22000 
1 Bill 30000 
3 Paul 25000 
4 jack 25000 
; 
RUN; 

DATA kids; 
  INPUT famid kidname $ birth_date age wt sex $ ; 
CARDS; 
1 Beth 1 9 60 f 
1 Bob  2 6 40 m 
1 Barb 3 3 20 f 
2 Andy 1 8 80 m 
2 Al   2 6 50 m 
2 Ann  3 2 20 f 
3 Pete 1 6 60 m 
3 Pam  2 4 40 f 
3 Phil 3 2 20 m 
5 pet  5 3 20 M
; 
RUN; 


proc sort data=Dad out=Dad_sor;
by famid;
run;

proc sort data=kids out=kids_sor;
by famid;
run;

Proc print data=kids_sor;
run;

data dadkid;
merge Dad_sor (in=a) kids_sor(in=b);
by famid;
if a;
run;
proc print data=dadkid;
run;


*-------------------------------------------------------------------
--------------------------------------------------------------------
--------------------------------------------------------------------
CODE 3 -  MERGE - MANY to MANY MERGE is usually performed using SQL
---------------------------------------------------------------------;
data Adverse_Event ;
input ptnum $ 1-3 @5 date date9. event $ 15-35;
format date date9.;
cards;
001 16NOV2009 Nausea
002 17NOV2009 Heartburn
002 16NOV2009 Acid Indigestion
002 18NOV2009 Nausea
003 17NOV2009 Fever
003 18NOV2009 Fever
005 17NOV2009 Fever
;
run;

data Medication ;
infile cards;
input ptnum $ 1-3 @5 date date9. medication $ 15-35;
format date date9.;
cards;
001 16NOV2009 Dopamine
002 17NOV2009 Antacid
002 16NOV2009 Sodium bicarbonate
002 18NOV2009 Dopamine
003 18NOV2009 Asprin
004 19NOV2009 Asprin
005 17NOV2009 Asprin
;
run;


proc sort data = Adverse_Event out = ad_sor;
by ptnum  date;
run;

proc sort data = Medication out = med_sor;
by ptnum date;
run;

*Here ptnum and date are the merging variables. 
For many to many merge, since the "ptnum" column in both the datasets has same values, 
SAS will give error - "more than one dataset with repeats of "by" values, and there will be descrepencies while merging .
To avoid this use more than one merging variable;

data adv_med;
merge ad_sor med_sor;
by ptnum date ; 
run;

title1 "Merge using the MERGE statement ";
proc print data=adv_med;
run;

*-------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
DATASET - Population & Uber
--------------------------------------------------------------------------------------------------------
The POPULATION data set contains the population information related to 8 metropolitan cities across North America.
The UBER data set contains the number of Uber drivers in each of the metropolitan cities.
Merge the POPULATION and UBER data set and calculate the Driver to Population ratio:
Ratio = Number of Uber driver / Population.
Which city has the highest Uber driver to population ratio?
--------------------------------------------------------------------------------------------------------;
Data Population;
Input Country $ City: $30. Population;
Datalines;
Canada Toronto 6000000
Canada Montreal 4000000
Canada Vancouver 2400000
US Chicago 2700000
US New_York 8400000
US Los_Angeles 3800000
Mexico Mexico_City 8500000
Mexico Cancun 620000
;
Run;

Data Uber;
Input Country $ Cities: $30. NumDriver;
Datalines;
US Chicago 20000
US New_York 14000
US Los_Angeles 16000
Canada Toronto 13000
Canada Montreal 5000
Mexico Mexico_City 20000
Mexico Cancun 11000
Canada Vancouver 7000
;
Run;
*-------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
CODE 4 -  MERGE - Population and Uber dataset has different names for city column. RENAME the column 
--------------------------------------------------------------------------------------------------------;
proc sort data = population out = pop_sort;
by country;
run;

proc sort data = uber out = uber_sort;
by country;
run;

Data ub_pop;
merge  uber_sort pop_sort(rename=(city = cities));
by country;
Ratio = (Numdriver) / (Population);
run;

proc print data = ub_pop;
run;


Data ub_pop2;
merge pop_sort uber_sort (rename=(cities = city));
by country;
Ratio = (Numdriver) / (Population);
run;

proc print data = ub_pop2;
run;
*-------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
DATASET -  TRANSAC & TAX
--------------------------------------------------------------------------------------------------------;
Data Transac;
Input Order $ Province : $30. Total;
Datalines;
BA00001 Ontario 1432
BA00002 Ontario 1455
BA00003 Ontario 2435
BA00004 Quebec 894
BA00005 Quebec 1745
BA00006 Quebec 997
BA00007 Alberta 562
BA00008 Alberta 132
BA00009 Alberta 987
BA00010 Manitoba 562
;
Run;

Data Tax;
Input Province : $30. Tax;
Datalines;
Ontario 13
Quebec 14.975
Alberta 5
Manitoba 5
;
Run;
*-------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
CODE 5 -  MERGE - Transac & Tax 
--------------------------------------------------------------------------------------------------------;
proc sort data = Transac out = tran_sort;
by Province;
run;

proc sort data = Tax out = Tax_sort;
by Province;
run;


Data Trans_Tax;
Merge tran_sort Tax_sort;
by province;
run;

proc print data = Trans_Tax;
run;


*-------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
DATASET - Allpop & Dropout
--------------------------------------------------------------------------------------------------------
The ALLPOP data set contains a list of 10 patients enrolled in a clinical study.
While the clinical study has been ongoing, some patients dropped out of the study due to various reasons.
The list of dropped out patients are stored in the DROPOUT data set.

Create a new variable that flags the patient:
1 for current patient
2 for dropped out patient
Create any additional data set or variable if needed.
----------------------------------------------------------------------------------------------------------;
Data Allpop;
Input PID $ Gender $ Age;
Datalines;
PT70001 M 39
PT70002 F 45
PT70003 M 38
PT70004 F 23
PT70005 F 25
PT70006 M 41
PT70007 M 36
PT70008 F 56
PT70009 F 42
PT70010 F 29
;
Run;

Data Dropout;
Input PID $ DDate;
Format DDate YYMMDD10.;
Datalines;
PT70003 19500
PT70004 19502
PT70007 19603
;
Run;

*-------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
CODE 6 -  MERGE - Transac & Tax 
--------------------------------------------------------------------------------------------------------;
Proc sort data = Allpop out = sort_all;
by PID;
run;

Proc sort data = dropout out = sort_drop;
by pid;
run;

Data Drop_All;
Merge sort_all(in = a) sort_drop(in = b);
by PID;
if a=b then i = 'dropout patient';
else if a=1 then i= "current patient";
run; 

proc print data = Drop_All;
run;
 
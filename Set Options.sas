*=============================================================
               SET STATEMENT
=============================================================;
Using set statement to read the data from existing dataset to another*/

data labdata;
input pid age name$ center$ area$ ;
cards;
100 24 kiran appolo hyd
101 25 kumar care   vij
102 26 madhu nims   nlr
104 32 mohan care   wng
105 30 midhi nims   hyd
;
run;
proc print data=labdata ;
run;

data lab; 
 set labdata; *using set statement to copy the dataset;
run;
proc print data=lab ;
run;
*=============================================================
               SET STATEMENT - KEEP
=============================================================;
*To keep only required variables;

data keep_lab;
set lab (keep= age name);
run;
proc print data=keep_lab;;
run;
*=============================================================
               SET STATEMENT - DROP
=============================================================;
*To drop the variables which are not required;

data drop_lab;
set lab(drop = pid age);
run;
proc print data=drop_lab;
run;
*=============================================================
               SET STATEMENT - RENAME
=============================================================
 To rename the variables;

data rename_lab;
set lab (rename=(pid=usubjid age=dm_age));
run;
proc print data=rename_lab;
run;

*=============================================================
               SET STATEMENT - WHERE
==============================================================
 Where option in set statement;
 
data where_lab;;
  set lab(where=(center="nims")) ;
run;

proc print data=where_lab noobs;
run;

/*Demonstrating saving of your program in SASuser library using set  to save the part of data*/
data labdata;
set sashelp.class (firstobs=2 );
run;
proc print;
run;


data a;
  set labdata(obs=3);
run;

*=============================================================
Randomly selecting observations to get the desired obs
==============================================================;

data observations;
set sashelp.class;
if _n_=3 then output;
if _n_=10 then output;
if _n_=15 then output;
run;
proc print data = observations;
run;
*-------------------------------------------------------
Certfication Questions on various SET combinations
SET xy || Set x set y
-------------------------------------------------------;
data x;                   *Dataset x;
input pid age gender$;
cards;
100 10 male
200 40 female
300 50 male
;
run;

data y;                  *Dataset y;
input pid age sex$;
cards;
101 20 female
200 30 male
;
run;


data aa;     *combining dataset x and y using 2 SET statements;
set x;
set y;
run;
proc print data=aa;
run;

data aa;   *combining dataset x and y using SINGLE SET statements;
set x y;    *The data program stops after it has read the last row from the smallest data set;
run;
proc print data=aa;
run;
*------------------------------------------------------------------------------------------------------
Different scenarios of set statements
-------------------------------------------------------------------------------------------------------;
data ab;
input pat_id years sex$;
cards;
104 10 f
200 30 m
300 50 f
;
run;


data bc;
input pid age sex$;
cards;
101 20 f
;
run;

data aa;
set bc ab;
run;

proc print data=aa; *5 observations;
run;


data bb;
set bc;
set ab ;
run;


proc print data=bb;     *2 observations in bb ;
run;                    * The data program stops after it has read the last row from the smallest data set;
                         *here bb is the smallest dataset;
*=========================================================;
Data class;           *Class dataset - 19 obs & 5 columns;
set sashelp.class; 
run;

Data air;             *Air dataset - 144 obs & 2 columns;
set sashelp.air;
run;


Data class1;        *Combining class  & air using 2 set statements;  
set sashelp.class;  * O/P - 19 - Obs of smallest dataset;
set sashelp.air;
run;

proc print data = class1; 
run;

Data class2;
set sashelp.class sashelp.air;
run;

proc print data = class2 n; 
run;

*------------------------------------------------------------;

Data class1;           * O/P - 1 obs - only one obs has age > 15 in the class (smallest) dataset;
set sashelp.class;     *The DATA step stops after it has read the last observation from the smallest data set;
if age gt 15;
set sashelp.air;
run;

proc print data = class1; 
run;
*------------------------------------------------------------;
data ab;
input pid years sex$;
cards;
101 10 f
101 70 m
200 30 m
300 50 f
;
run;


data bc;
input pid age sex$;
cards;
101 20 m
101 40 m
567 69 m
;
run;

proc sort data = ab out =sor_ab;
by pid;
run;


proc sort data = bc out = sor_bc;
by pid;
run;


data aa;
merge sor_ab sor_bc; *priority - first table is overwritten in merge;
By pid;
run;
*====================================================;
data ab;
input pid years sex$; 
cards;   *101-10-20-m ; * 101-25-40-m; *101-25-33-f;
101 10 f 
101 25 m 
300 50 f
;
run;
*101 in ab matches with every 101 in bc;


data bc;
input pid age sex$;
cards;
101 20 m
101 40 m
101 33 f
567 69 m
;
run;

proc sort data = ab out =sor_ab;
by pid;
run;


proc sort data = bc out = sor_bc;
by pid;
run;


data aa;
merge sor_ab sor_bc; *priority - first table is overwritten in merge;
By pid;
run;
*=================================================================;
data ab;
input pid years sex$; 
cards;                              *o/p - 101-10-20-m ; * 101-25-40-m; *101-33-40-m;
101 10 f 
101 25 m 
101 33 f
300 50 f
;
run;
*101 in ab matches with every 101 in bc;


data bc;
input pid age sex$;
cards;
101 20 m
101 40 m
567 69 m
;
run;

proc sort data = ab out =sor_ab;
by pid;
run;


proc sort data = bc out = sor_bc;
by pid;
run;


data aa;
merge sor_ab sor_bc; *priority - first table is overwritten in merge;
By pid;
run;
*=======================================================================;
data ab;
input pid years sex$; 
cards;                         *O/p - 101-10-28-m ; * 101-25-45-m; *101-33-45-m;
101 10 f 
101 25 m 
101 33 f
300 50 f
;
run;
*101 in ab matches with every 101 in bc;


data bc;
input pid age sex$;
cards; *not sorted, when sort 28 become first;
101 45 m
101 28 m 
567 69 m
;
run;

proc sort data = ab out =sor_ab;
by pid ;
run;


proc sort data = bc out = sor_bc;
by pid ;
run;


data aa;
merge sor_ab sor_bc; *priority - first table is overwritten in merge;
By pid;
run;
*-------------------------------------------------------------------------
CONCAT - Use SET & 'BY' - first grouped readings of 1st & 2nd dataset
-------------------------------------------------------------------------;
data ab;
input pid sex$;
cards;
101 f
200 m
300 f
;
run;


data bc;
input pid sex$;
cards;
101 m
300 f
;
run;

proc sort data = ab out = sor_bc;
by pid;
run;

proc sort data = bc out = sor_bc;
by pid ;
run;

data aa;
set ab bc;
by pid;
run;

*-----------------------------------------------------
Same code above - Using 'MERGE' and 'BY'
----------------------------------------------------;
Data ab;
input pid sex$;
cards;
101 f 
200 m
300 f
;
run;

data bc;
input pid sex$;
cards;
101 m
300 m
;
run;

proc sort data = ab out = sor_bc;
by pid;
run;

proc sort data = bc out = sor_bc;
by pid ;
run;

data aa;
merge ab bc;
by pid;
run;

*=================================================================;
USE 'WHERE' statement in the datastep to select obs to be processed
--------------------------------------------------------------------;
Data class;
set sashelp.class (where = (age gt 12)) ;
run;


*--------------------------------------------------
KEEP || DROP
---------------------------------------------------;
Data class(keep = name sex );
set sashelp.class;
run;

Data class;
set sashelp.class (keep = name sex );
run;

Data class;
set sashelp.class;
keep name sex ;
run;

-----------------------------------------------------------;
Data ab;
input pid sex$;
cards;
101 f 
200 m
300 f
;
run;

data bc;
input pid sex$;
cards;
101 m
300 m
;
run;
*--------------------;
data abc;
set work.ab(in = ina)
work.bc (in = inb);             
if ina and inb;
run;

proc freq data = abc;
tables gender * age / ;
run;
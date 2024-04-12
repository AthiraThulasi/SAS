*----------------------------------------------------------------------------------------------------------
                 RETAIN - Retain statement keeps the value once assigned
-----------------------------------------------------------------------------------------------------------
Causes a variable that is created by an INPUT or assignment statement to retain 
its value from one iteration of the DATA step to the next.

-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
3 ways to assign initial values with a Retain statement:
Retain Varname 0 - This assigns the initial value of 0 to the variable 
Retain Varname . - This assigns missing values to the variable 
Retain Varname   -
-----------------------------------------------------------------------------------------------------------
Dataset - Revenue
-----------------------------------------------------------------------------------------------------------;
Data Revenue;
Infile datalines dsd;
Input Week : $10. Revenue;
Datalines;
Week 1, 4000
Week 2, 5000
Week 3, 8000
Week 4, 6500
Week 5, 8900
Week 6, 4500
Week 7, 9800
Week 8, 10000
Week 9, 6800
Week 10, 6300
;
Run;
*-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
Code 1: RETAIN 0 - Retain Variablename using 0
-----------------------------------------------------------------------------------------------------------
Assign value of 0 to the variable Total.
Since the value is retained from one observation to the next, the entire column contains the value of 0
--------------------------------------------------------------------------------------------------------;
Data Revenue1;
Set Revenue;
retain Total 0;
Run;

*--------------------------------------------------------------------------;
​Data Revenue2;
Set Revenue1;
Retain Total 100; *retain a value of 100 in all rows;
Run;
*-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
Code 2: RETAIN . - Retain Variablename using .
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
Assign missing value (.) to the variable Total.
Since the value is retained from one observation to the next, the entire column contains (.)
--------------------------------------------------------------------------------------------------------; 
Data Revenue3;
Set Revenue;
Retain Total .;
Run;
*-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
Code 3: RETAIN - Retain Variablename without initial value
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
When no initial value is given in the Retain statement, the initial value is set as missing (dot).
However, the variable is NOT created when no initial value is given.
-----------------------------------------------------------------------------------------------------------;
​Data Revenue4;
Set Revenue;
Retain Total;
Run;
*-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
Code 4: To make first observation to be 0 in 'total' column
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------;
Data Revenue5;
Set Revenue;
if _n_ = 1 then Total = 0;  *_n_ = 1 means first observation;
Run;

*-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
Code 5: To make all observations to be 0 in 'total' column and to retain it in all rows
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------;
Data Revenue6;
Set Revenue;
if _n_ = 1 then Total = 0;   *_n_ = 1 means first observation;
Retain Total;                 * retaining '0' in all rows;
Run; 

*-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
CUMULATIVE SUMMATION : When computing cumulative summation, assigning the initial value is not needed.
-----------------------------------------------------------------------------------------------------------
Code 6: SUM ()
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------;
Data Revenue7;
Set Revenue;
Retain Total;
Total = sum(revenue, total); *SUM function;
Run; 

*OR;

Data Revenue8;
Set Revenue;
Retain Total;
if _n_ = 1 then Total = 0;
Total = sum(total, revenue);
Run;

Data Revenue9;
set Revenue;
retain Total 1500; 
total = sum(total, revenue);
run;

Data Revenue9;
set Revenue;
retain Total 1500;
output;                *First obs of Total will be 1500 bcs of OUTPUT statement;
total = sum(total, revenue);
run;

*-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
(+) Expression - achieves the same result as Retain statement and the SUM function
-----------------------------------------------------------------------------------------------------------
'+' creates the variable Total with no initial value (missing)
The variable Total has a built-in retain capability. Its value is retained from one observation to the next
The (+ Revenue) syntax adds the revenue to the variable Total on each observation.
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
Code 7: (+) Expression. 
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------;
Data Revenue2; *variable on the left side of the plus sign 'Total' begins at 0;
Set Revenue;   *and increases by the value of Revenue with each observation;
Total + Revenue ; 
Run;


Data Revenue2;
Set Revenue;
Total + Revenue; * o/p the cumulative (sum of revenue and total in 'total' column);
Run;


data rev;
set Revenue;
retain z 0;
z = z + 1;
run;

*-----------------------------------------------------------------------------------------------------------
Code 8: To generate a row index number by productname (Group by product name) - Dataset - sashelp.pricedata
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------;
*The number of unique rows by a group can easily be calculated with PROC FREQ and PROC MEANS.
The following program explains how we can calculate number of observations in a categorical variable with Data Step
HOW?;


Data price_out;
set sashelp.pricedata;
run;

proc sort data = price_out out = price_sorted ;
by productname;
run;

Data price;
set price_sorted (keep = productname sale);
retain amount ;
if first.productname then amount = 1;
else amount = amount + 1;
by productname;
if last.productname then output;
run;
*--------------------------------
SUM STATEMENT
--------------------------------;
Data prd;
set sashelp.prdsale;
run;

*SUM only works with PROC step not Data step;

*if the variable in the sum statement is also present with 'var'- it will follow the same order
else it will be displyed as last one;

proc print data = prd; 
var actual predict region;
sum predict ;
run;
*------------------------------------
SORT - PROC PRINT - SUM STATEMENT - BY
-------------------------------------;
Data prd;
set sashelp.prdsale;
run;

Proc sort data = prd  out = prd_out;
by region;
run;

proc print data = prd_out; 
var actual predict region;
sum actual ;
by region;
run;
*---------------------------------------------------------------------
To show the BY variable heading only once - ID + BY + SUM statement
----------------------------------------------------------------------;
proc print data = prd_out; 
var actual predict region;
sum actual ;
id region; *obs is omitted and ID will be listed;
by region; *grp by region;
run;

-----------------------------------------------------------------;
proc print data = prd_out; 
var actual predict region;
sum actual ;
id region;
by region;
pageby region;
run;
*==================================================================================
                                WHERE STATEMENT
===================================================================================
WHERE statement can be used to subset a data set (similar to the IF statement)

WHERE statement subsets the data set before the data is read into the PDV.
As a result, it cannot be used on variables that don't already exist in the input data set
---------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
Dataset 1 -  sashelp.class
-------------------------
CLASS data set contains five variables. create a data set that contains only the MALE students
Name,Sex,Age,Height,Weight
-----------------------------------------------------------------------------------------
CODE 1 - WHERE - Subsetting sex
------------------------------------------------------------------------------------------;
Data Male;
Set sashelp.class;
where sex = "M";
Run;
*------------------------------------------------------------------------------------------
Dataset 2- EXAM
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
------------------------------------------------------------------------------------------
CODE - 2 - FLAGGING EXTREME VALUES - FIRST & LAST
------------------------------------------------------------------------------------------;
Proc Sort Data=Exam out = exam_new;
By Subject Results;
Run;
*-------------------------------------------------------------------------------------------
TO FIND EXTREME VALUES - Using - FIRST & LAST + Subsetting using "IF"
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
*-------------------------------------------------------------------------------------------
TO FIND EXTREME VALUES - Subsetting using "WHERE"- ERROR MESSAGE - Variable i is not on file WORK.EXAM_NEW.
-------------------------------------------------------------------------------------------;
Data Exam2;        
Set exam_new;
By Subject Results;
if first.subject then i=1;
else if last.subject then i=2;
where i in(1,2);
run;

*The above code gives error 
ERROR MESSAGE - Variable i is not on file WORK.EXAM_NEW.
*----------------------------------------------------------------------------------------
										POINT TO NOTE
-----------------------------------------------------------------------------------------
WHERE statement subsets the data set before the data is read into the PDV.
As a result, it cannot be used on variables that don't already exist in the input data set

















































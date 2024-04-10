
*-----------------------------------------------------------------------------------------------
                     
        PROC CONTENTS - To examine the descriptor portion of a SAS data set
        
-----------------------------------------------------------------------------------------------
The CONTENTS procedure shows the contents of a SAS data set and prints the directory 
of the SAS library, which includes the following:

variable names
Data types
Attributes - length, type, format & informat
Number of observations 
Variables present 
Date Created etc...

**DATASETS procedure can also be used to display the descriptor portion of a data set;
----------------------------------------------------------------------------------------------- 
----------------------------------------------------------------------------------------------- 
CODE 1 -  PROC CONTENT - List the contents of dataset class
----------------------------------------------------------------------------------------------- 
----------------------------------------------------------------------------------------------;
Data class;
set sashelp.class;
run;

Proc contents data = class;
run;
*----------------------------------------------------------------------------------------------- 
----------------------------------------------------------------------------------------------- 
CODE 2 -  PROC CONTENT - _all_ - List all the dataset in a particular library
----------------------------------------------------------------------------------------------- 
-----------------------------------------------------------------------------------------------;
libname lib '/home/u60674716/Lib';
PROC CONTENTS DATA=lib._all_ OUT=contents_data;
RUN;

*----------------------------------------------------------------------------------------------- 
----------------------------------------------------------------------------------------------- 
CODE 3 -  PROC CONTENT - VARNUM - Prints a list of the variable names in the order of their 
                                  logical position in the data set.
----------------------------------------------------------------------------------------------- 
-----------------------------------------------------------------------------------------------
By default - PROC CONTENTS lists variables in the alphabetical order. 
when using the VARNUM option - SAS displays Prints a list of the variable names in the order 
of their logical position in the data set.
----------------------------------------------------------------------------------------------;
proc contents data=sashelp.class varnum;
run;
*----------------------------------------------------------------------------------------------- 
----------------------------------------------------------------------------------------------- 
CODE 4 -  PROC CONTENT - SHORT - Prints only the list of variable names the index information, 
                                 and the sort information for the SAS data set..                                                          
----------------------------------------------------------------------------------------------- 
-----------------------------------------------------------------------------------------------;
proc contents data=sashelp.class short varname ;
run;

Proc contents DATA=sashelp._all_ short;
run;
*----------------------------------------------------------------------------------------------- 
----------------------------------------------------------------------------------------------- 
CODE 5 -  PROC CONTENT - NOprint -  Suppress the printing of the output    
                         OUT     - print the contents in a datset                                                      
----------------------------------------------------------------------------------------------- 
-----------------------------------------------------------------------------------------------;
proc contents data=sashelp.class noprint out=out_class;
run;

*----------------------------------------------------------------------------------------------- 
----------------------------------------------------------------------------------------------- 
CODE 6 -  Print the descriptor portion of the BASEBALL data set in the SASHelp library.
          How many observations are there in the library? 322                                                
----------------------------------------------------------------------------------------------- 
-----------------------------------------------------------------------------------------------;
proc contents data=sashelp.baseball  ;
run;

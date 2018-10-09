MSDS 6372 - Applied Statistics: Inference and Modeling
Dr. Anthony Tanaydin
By Allen Crane and Brock Friedrich
October 10, 2018



/* Russian Real Estate Valuation and Prediction */
/* Problem 1 Step 2 - Convert incorrectly imported-as-character variables to numeric */

/* convert train variables to numeric */

data train2;
set train;
   n_build_year = input(build_year,8.);
   n_kitch_sq = input(kitch_sq,8.);
   n_material = input(material,8.);
   n_max_floor = input(max_floor,8.);
   n_num_room = input(num_room,8.);  
   n_state = input(state,8.);
run;

proc print data=train2 (obs=10);
run;

proc contents data=train2;
run;

proc means data=train2
	N Mean Std Min Q1 Median Q3 Max;
run;

/* this step just drops the original train character variables */

data train3;
set train2 (drop = 
build_year 
kitch_sq 
material 
max_floor 
num_room   
state 
); 
run;

proc print data=train3 (obs=10); 
run;

proc contents data=train3;
run;

proc means data=train3
	N Mean Std Min Q1 Median Q3 Max;
run; 

/* this step just renames the "n_*" variables to the origial variable names */

data train3;
set train3 (rename=( 
'n_build_year'n='build_year'n
'n_kitch_sq'n='kitch_sq'n
'n_material'n='material'n
'n_max_floor'n='max_floor'n
'n_num_room'n='num_room'n
'n_state'n='state'n
));
run;

proc print data=train3 (obs=10);
run;

proc means data = train3 n nmiss;
  var _numeric_;
run;

proc univariate data=train3;
var state
;
run;

proc contents data=train3;
run;

proc means data=train3
	N Mean Std Min Q1 Median Q3 Max;
run;

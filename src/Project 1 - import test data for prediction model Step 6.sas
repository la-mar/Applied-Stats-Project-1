MSDS 6372 - Applied Statistics: Inference and Modeling
Dr. Anthony Tanaydin
By Allen Crane and Brock Friedrich
October 10, 2018



/* Russian Real Estate Valuation and Prediction */
/* Problem 1 Step 6 - Import test data for prediction model */

/* import test data */

proc import datafile="/home/allen_crane0/Btest.csv"  /*You will need to change the path or use the import wizard.*/
          dbms=dlm out=test replace;
     delimiter=',';
     getnames=yes;
run;

proc print data=test (obs=10);
run;

proc contents data=test;
run;

proc print data=test (obs=10);
run;

/* test version of same step as train file: this step shortens long >32 char variable names 
and renames variables that start with a number */

options validvarname=any;
data test;
set test;
rename preschool_education_centers_raio='ps_educ_centers_raion'n;
rename school_education_centers_top_20_='s_educ_centers_top20_raion'n;
rename raion_build_count_with_material_='raion_bld_cnt_material_info'n;
rename public_transport_station_min_wal ='pub_trans_stn_min_walk'n; 
run;

options validvarname=any;
data test;
set test (rename=('0_6_all'n='group_0_6_all'n 
'0_6_male'n='group_0_6_male'n
'0_6_female'n='group_0_6_female'n 
'7_14_all'n='group_7_14_all'n
'7_14_male'n='group_7_14_male'n
'7_14_female'n='group_7_14_female'n
'0_17_all'n='group_0_17_all'n
'0_17_male'n='group_0_17_male'n
'0_17_female'n='group_0_17_female'n
'16_29_all'n='group_16_29_all'n
'16_29_male'n='group_16_29_male'n
'16_29_female'n='group_16_29_female'n 
'0_13_all'n='group_0_13_all'n
'0_13_male'n='group_0_13_male'n 
'0_13_female'n='group_0_13_female'n));
run;

options validvarname=any;
data test;
set test (rename=('build_count_1921-1945'n='build_count_1921_1945'n
'build_count_1946-1970'n='build_count_1946_1970'n
'build_count_1971-1995'n='build_count_1971_1995'n));
run;

/* we do not need to set test data fields as numeric, they already are */ 


/* this step uses PROC MI to impute missing values */

proc mi data=test seed=501213 mu0=0 out=test4;
var 
life_sq
floor
preschool_quota
school_quota
green_part_2000
hospital_beds_raion
raion_bld_cnt_material_info
build_count_block
build_count_wood
build_count_frame
build_count_brick
build_count_monolith
build_count_panel
build_count_foam
build_count_slag
build_count_mix
raion_build_count_with_builddate
build_count_before_1920
build_count_1921_1945
build_count_1946_1970
build_count_1971_1995
build_count_after_1995
metro_min_walk
metro_km_walk
railroad_station_walk_km
railroad_station_walk_min
id_railroad_station_walk
cafe_sum_500_min_price_avg
cafe_sum_500_max_price_avg
cafe_avg_price_500
cafe_sum_1000_min_price_avg
cafe_sum_1000_max_price_avg
cafe_avg_price_1000
cafe_sum_1500_min_price_avg
cafe_sum_1500_max_price_avg
cafe_avg_price_1500
cafe_sum_2000_min_price_avg
cafe_sum_2000_max_price_avg
cafe_avg_price_2000
cafe_sum_3000_min_price_avg
cafe_sum_3000_max_price_avg
cafe_avg_price_3000
cafe_sum_5000_min_price_avg
cafe_sum_5000_max_price_avg
cafe_avg_price_5000
prom_part_5000
build_year
kitch_sq
material
max_floor
num_room
state
;
run;

proc print data=test4 (obs=10);
run;

proc means data = test4 n nmiss;
  var _numeric_;
run;

proc means data=test4
	N Mean Std Min Q1 Median Q3 Max;
run; 

/* add empty predicted response field */

data test4;
set test4;
price_doc = .;
;
/* SAS code for Russian Real Estate data project */
/* Last updated 10/01/2018 @ 6:00PM by Allen Crane

/* import data                               */
/* rename long variable names                */
/* renames var names beginning with numbers  */
/* renames var names containing dashes       */

proc import datafile="/home/allen_crane0/Btrain.csv"  /*You will need to change the path or use the import wizard.*/
          dbms=dlm out=train replace;
     delimiter=',';
     getnames=yes;
run;

proc print data=train (obs=10);
run;

proc contents data=train;
run;

/* this step shortens long >32 char variable names and creates a new variable for the log of area_m */

options validvarname=any;
data train;
set train;
rename preschool_education_centers_raio='ps_educ_centers_raion'n;
rename school_education_centers_top_20_='s_educ_centers_top20_raion'n;
rename raion_build_count_with_material_='raion_bld_cnt_material_info'n;
rename public_transport_station_min_wal ='pub_trans_stn_min_walk'n; 
log_area_m = log(area_m);
log_price_doc = log(price_doc);
run;

options validvarname=any;
data train;
set train (rename=('0_6_all'n='group_0_6_all'n 
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
data train;
set train (rename=('build_count_1921-1945'n='build_count_1921_1945'n
'build_count_1946-1970'n='build_count_1946_1970'n
'build_count_1971-1995'n='build_count_1971_1995'n));
run;

proc contents data=train;
run;
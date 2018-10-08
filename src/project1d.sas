/* import data */

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

proc freq data=train;
tables 
big_market_raion
big_road1_1line
build_year
culture_objects_top_25
detention_facility_raion
ecology
incineration_raion
kitch_sq
material
max_floor
nuclear_reactor_raion
num_room
oil_chemistry_raion
product_type
radiation_raion
railroad_1line
railroad_termil_raion
state
sub_area
thermal_power_plant_raion
water_1line
/ nocum;
run;

/* convert these variables to numeric */

data train2;
set train;
   n_build_year = input(build_year, 8.);
   n_kitch_sq = input(kitch_sq, 8.);
   n_material = input(material, 8.);
   n_max_floor = input(max_floor, 8.);
   n_num_room = input(num_room, 8.);  
   n_state = input(state, 8.);
run;

proc print data=train2 (obs=10);
run;

proc contents data=train2;
run;

proc means data=train2
	N Mean Std Min Q1 Median Q3 Max;
run;

/* this step just drops the original character variables */

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


/* this step uses PROC MI to impute missing values */

proc mi data=train3 seed=501213 
     mu0=0 out=train4;
     var
build_year
kitch_sq
material
max_floor
num_room
state;
run;

proc print data=train4 (obs=10);
run;

proc contents data=train4;
run;

proc means data=train4
	N Mean Std Min Q1 Median Q3 Max;
run; 

proc corr data=train4;
	var 
green_part_500
green_part_1000;
run; 


/* MODEL 1 - PROC GLM AND GLMSELECT WITH SOME OPTIONS */

proc glmselect data = train4 plots=All;
class 
big_market_raion
big_road1_1line
culture_objects_top_25
detention_facility_raion
ecology
incineration_raion
nuclear_reactor_raion
oil_chemistry_raion
product_type
radiation_raion
railroad_1line
railroad_termil_raion
sub_area
thermal_power_plant_raion
water_1line
;
model price_doc = 
additiol_education_km
additiol_education_raion
area_m
basketball_km
big_church_count_500
big_church_count_1000
big_church_count_1500
big_church_count_2000
big_church_count_3000
big_church_count_5000
big_church_km
big_market_km
big_market_raion
big_road1_1line
big_road1_km
big_road2_km
bulvar_ring_km
bus_termil_avto_km
cafe_count_500
cafe_count_1000
cafe_count_1500
cafe_count_2000
cafe_count_3000
cafe_count_5000
cafe_count_1000__price
cafe_count_1000_price_500
cafe_count_1000_price_1000
cafe_count_1000_price_1500
cafe_count_1000_price_2500
cafe_count_1000_price_4000
cafe_count_1000_price_high
cafe_count_1500__price
cafe_count_1500_price_500
cafe_count_1500_price_1000
cafe_count_1500_price_1500
cafe_count_1500_price_2500
cafe_count_1500_price_4000
cafe_count_1500_price_high
cafe_count_2000__price
cafe_count_2000_price_500
cafe_count_2000_price_1000
cafe_count_2000_price_1500
cafe_count_2000_price_2500
cafe_count_2000_price_4000
cafe_count_2000_price_high
cafe_count_3000__price
cafe_count_3000_price_500
cafe_count_3000_price_1000
cafe_count_3000_price_1500
cafe_count_3000_price_2500
cafe_count_3000_price_4000
cafe_count_3000_price_high
cafe_count_5000__price
cafe_count_5000_price_500
cafe_count_5000_price_1000
cafe_count_5000_price_1500
cafe_count_5000_price_2500
cafe_count_5000_price_4000
cafe_count_5000_price_high
cafe_count_500__price
cafe_count_500_price_500
cafe_count_500_price_1000
cafe_count_500_price_1500
cafe_count_500_price_2500
cafe_count_500_price_4000
cafe_count_500_price_high
catering_km
cemetery_km
children_preschool
children_school
church_count_500
church_count_1000
church_count_1500
church_count_2000
church_count_3000
church_count_5000
church_sygogue_km
culture_objects_top_25
culture_objects_top_25_raion
detention_facility_km
detention_facility_raion
ecology
ekder_all
ekder_female
ekder_male
exhibition_km
female_f
fitness_km
full_all
full_sq
green_part_500
green_part_1000
green_part_1500
green_part_2000
green_part_3000
green_part_5000
green_zone_km
green_zone_part
group_0_13_all
group_0_13_female
group_0_13_male
group_0_17_all
group_0_17_female
group_0_17_male
group_0_6_all
group_0_6_female
group_0_6_male
group_16_29_all
group_16_29_female
group_16_29_male
group_7_14_all
group_7_14_female
group_7_14_male
healthcare_centers_raion
hospice_morgue_km
ice_rink_km
id
incineration_km
incineration_raion
indust_part
industrial_km
kindergarten_km
kremlin_km
leisure_count_500
leisure_count_1000
leisure_count_1500
leisure_count_2000
leisure_count_3000
leisure_count_5000
log_area_m
male_f
market_count_500
market_count_1000
market_count_1500
market_count_2000
market_count_3000
market_count_5000
market_shop_km
metro_km_avto
metro_min_avto
mkad_km
mosque_count_500
mosque_count_1000
mosque_count_1500
mosque_count_2000
mosque_count_3000
mosque_count_5000
mosque_km
museum_km
build_year
cafe_avg_price_500
cafe_avg_price_1000
cafe_avg_price_1500
cafe_avg_price_2000
cafe_avg_price_3000
cafe_avg_price_5000
cafe_sum_1000_max_price_avg
cafe_sum_1000_min_price_avg
cafe_sum_1500_max_price_avg
cafe_sum_1500_min_price_avg
cafe_sum_2000_max_price_avg
cafe_sum_2000_min_price_avg
cafe_sum_3000_max_price_avg
cafe_sum_3000_min_price_avg
cafe_sum_5000_max_price_avg
cafe_sum_5000_min_price_avg
cafe_sum_500_max_price_avg
cafe_sum_500_min_price_avg
kitch_sq
material
max_floor
metro_km_walk
metro_min_walk
num_room
preschool_quota
prom_part_5000
railroad_station_walk_km
railroad_station_walk_min
school_quota
state
nuclear_reactor_km
nuclear_reactor_raion
office_count_500
office_count_1000
office_count_1500
office_count_2000
office_count_3000
office_count_5000
office_km
office_raion
office_sqm_500
office_sqm_1000
office_sqm_1500
office_sqm_2000
office_sqm_3000
office_sqm_5000
oil_chemistry_km
oil_chemistry_raion
park_km
power_transmission_line_km
preschool_km
product_type
prom_part_500
prom_part_1000
prom_part_1500
prom_part_2000
prom_part_3000
ps_educ_centers_raion
pub_trans_stn_min_walk
public_healthcare_km
public_transport_station_km
radiation_km
radiation_raion
railroad_1line
railroad_km
railroad_station_avto_km
railroad_station_avto_min
railroad_termil_raion
raion_popul
s_educ_centers_top20_raion
sadovoe_km
school_education_centers_raion
school_km
shopping_centers_km
shopping_centers_raion
sport_count_500
sport_count_1000
sport_count_1500
sport_count_2000
sport_count_3000
sport_count_5000
sport_objects_raion
stadium_km
sub_area
swim_pool_km
theater_km
thermal_power_plant_km
thermal_power_plant_raion
timestamp
trc_count_500
trc_count_1000
trc_count_1500
trc_count_2000
trc_count_3000
trc_count_5000
trc_sqm_500
trc_sqm_1000
trc_sqm_1500
trc_sqm_2000
trc_sqm_3000
trc_sqm_5000
ts_km
ttk_km
university_km
university_top_20_raion
water_1line
water_km
water_treatment_km
work_all
work_female
work_male
workplaces_km
young_all
young_female
young_male
zd_vokzaly_avto_km
/selection=LASSO;
run;

/* alternate settings for proc glmselect

/selection=stepwise(stop=cv) cvmethod=random(10);
/selection=forward(stop=cv) cvmethod=random(10);
/selection=backward(stop=cv) cvmethod=random(10);
/selection=stepwise(select=SL SLE=0.1 SLS=0.08 choose=AIC);
/selection=stepwise(select=SL stop=SBC);
/selection=stepwise(select=AICC drop=COMPETITIVE);
/selection=LASSO;
/selection=LARS;

*/

/* check model variables for heteroscedasticity) 

proc model data=train4;
parms b0 b1;
price_doc = b0 + b1* additiol_education_km;
fit price_doc/white;
Run;
*/

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

/* add empty predicted response field */

data test;
set test;
price_doc = .;
;

options validvarname=any;
data test;
set test;
rename preschool_education_centers_raio='ps_educ_centers_raion'n;
rename school_education_centers_top_20_='s_educ_centers_top20_raion'n;
rename raion_build_count_with_material_='raion_bld_cnt_material_info'n;
rename public_transport_station_min_wal ='pub_trans_stn_min_walk'n; 
log_area_m = log(area_m);
log_price_doc = log(price_doc);
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

/* set test data fields as numeric */
/*
data test2;
set test;
   n_build_year = input(build_year, 8.);
   n_cafe_avg_price_500 = input(cafe_avg_price_500, 8.);
   n_cafe_avg_price_1000 = input(cafe_avg_price_1000, 8.);
   n_cafe_sum_1000_max_price_avg = input(cafe_sum_1000_max_price_avg, 8.);
   n_cafe_sum_1000_min_price_avg = input(cafe_sum_1000_min_price_avg, 8.);
   n_cafe_sum_500_max_price_avg = input(cafe_sum_500_max_price_avg, 8.);
   n_cafe_sum_500_min_price_avg = input(cafe_sum_500_min_price_avg, 8.);
   n_kitch_sq = input(kitch_sq, 8.);
   n_material = input(material, 8.);
   n_max_floor = input(max_floor, 8.);
   n_num_room = input(num_room, 8.);  
   n_state = input(state, 8.);
   n_preschool_quota = input(preschool_quota, 8.);
   n_school_quota = input(school_quota, 8.);
   n_metro_min_walk = input(metro_min_walk, 8.);
   n_metro_km_walk = input(metro_km_walk, 8.);
   n_railroad_station_walk_km = input(railroad_station_walk_km, 8.);
   n_railroad_station_walk_min = input(railroad_station_walk_min, 8.);
   n_cafe_sum_1500_min_price_avg = input(cafe_sum_1500_min_price_avg, 8.);
   n_cafe_sum_1500_max_price_avg = input(cafe_sum_1500_max_price_avg, 8.);
   n_cafe_avg_price_1500 = input(cafe_avg_price_1500, 8.);
   n_cafe_sum_2000_min_price_avg = input(cafe_sum_2000_min_price_avg, 8.);
   n_cafe_sum_2000_max_price_avg = input(cafe_sum_2000_max_price_avg, 8.);
   n_cafe_avg_price_2000 = input(cafe_avg_price_2000, 8.);
   n_cafe_sum_3000_min_price_avg = input(cafe_sum_3000_min_price_avg, 8.);
   n_cafe_sum_3000_max_price_avg = input(cafe_sum_3000_max_price_avg, 8.);
   n_cafe_avg_price_3000 = input(cafe_avg_price_3000, 8.);
   n_cafe_sum_5000_min_price_avg = input(cafe_sum_5000_min_price_avg, 8.);
   n_cafe_sum_5000_max_price_avg = input(cafe_sum_5000_max_price_avg, 8.);
   n_cafe_avg_price_5000 = input(cafe_avg_price_5000, 8.);
   n_prom_part_5000 = input(prom_part_5000, 8.);
run;
*/
proc print data=test2 (obs=10);
run;

proc contents data=test2;
run;

proc means data=test2
	N Mean Std Min Q1 Median Q3 Max;
run;

/* this step just drops the original character variables */
/*
data test3;
set test2 (drop = 
build_year 
cafe_avg_price_500 
cafe_avg_price_1000 
cafe_sum_1000_max_price_avg 
cafe_sum_1000_min_price_avg 
cafe_sum_500_max_price_avg 
cafe_sum_500_min_price_avg 
kitch_sq 
material 
max_floor 
num_room   
state 
preschool_quota 
school_quota 
metro_min_walk 
metro_km_walk 
railroad_station_walk_km 
railroad_station_walk_min 
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
); 
run;

data test3;
set test3 (rename=( 
'n_build_year'n='build_year'n
'n_cafe_avg_price_500'n='cafe_avg_price_500'n
'n_cafe_avg_price_1000'n='cafe_avg_price_1000'n
'n_cafe_sum_1000_max_price_avg'n='cafe_sum_1000_max_price_avg'n
'n_cafe_sum_1000_min_price_avg'n='cafe_sum_1000_min_price_avg'n
'n_cafe_sum_500_max_price_avg'n='cafe_sum_500_max_price_avg'n
'n_cafe_sum_500_min_price_avg'n='cafe_sum_500_min_price_avg'n
'n_kitch_sq'n='kitch_sq'n
'n_material'n='material'n
'n_max_floor'n='max_floor'n
'n_num_room'n='num_room'n
'n_state'n='state'n
'n_preschool_quota'n='preschool_quota'n
'n_school_quota'n='school_quota'n
'n_metro_min_walk'n='metro_min_walk'n
'n_metro_km_walk'n='metro_km_walk'n
'n_railroad_station_walk_km'n='railroad_station_walk_km'n
'n_railroad_station_walk_min'n='railroad_station_walk_min'n
'n_cafe_sum_1500_min_price_avg'n='cafe_sum_1500_min_price_avg'n
'n_cafe_sum_1500_max_price_avg'n='cafe_sum_1500_max_price_avg'n
'n_cafe_avg_price_1500'n='cafe_avg_price_1500'n
'n_cafe_sum_2000_min_price_avg'n='cafe_sum_2000_min_price_avg'n
'n_cafe_sum_2000_max_price_avg'n='cafe_sum_2000_max_price_avg'n
'n_cafe_avg_price_2000'n='cafe_avg_price_2000'n
'n_cafe_sum_3000_min_price_avg'n='cafe_sum_3000_min_price_avg'n
'n_cafe_sum_3000_max_price_avg'n='cafe_sum_3000_max_price_avg'n
'n_cafe_avg_price_3000'n='cafe_avg_price_3000'n
'n_cafe_sum_5000_min_price_avg'n='cafe_sum_5000_min_price_avg'n
'n_cafe_sum_5000_max_price_avg'n='cafe_sum_5000_max_price_avg'n
'n_cafe_avg_price_5000'n='cafe_avg_price_5000'n
'n_prom_part_5000'n='prom_part_5000'n));
run;
*/
proc print data=test3 (obs=10); 
run;

proc contents data=test;
run;

proc means data=test3
	N Mean Std Min Q1 Median Q3 Max;
run; 

/* combine data sets */

data test5;
set train4 test;
run;

proc print data=test5 (obs=10);
run;

proc contents data=test5;
run;

/* predict response field using desired method */

proc glmselect data = test5 plots=all;
class 
big_market_raion
big_road1_1line
culture_objects_top_25
detention_facility_raion
ecology
incineration_raion
nuclear_reactor_raion
oil_chemistry_raion
product_type
radiation_raion
railroad_1line
railroad_termil_raion
sub_area
thermal_power_plant_raion
water_1line
;
model price_doc = 
additiol_education_km
additiol_education_raion
area_m
basketball_km
big_church_count_500
big_church_count_1000
big_church_count_1500
big_church_count_2000
big_church_count_3000
big_church_count_5000
big_church_km
big_market_km
big_market_raion
big_road1_1line
big_road1_km
big_road2_km
bulvar_ring_km
bus_termil_avto_km
cafe_count_500
cafe_count_1000
cafe_count_1500
cafe_count_2000
cafe_count_3000
cafe_count_5000
cafe_count_1000__price
cafe_count_1000_price_500
cafe_count_1000_price_1000
cafe_count_1000_price_1500
cafe_count_1000_price_2500
cafe_count_1000_price_4000
cafe_count_1000_price_high
cafe_count_1500__price
cafe_count_1500_price_500
cafe_count_1500_price_1000
cafe_count_1500_price_1500
cafe_count_1500_price_2500
cafe_count_1500_price_4000
cafe_count_1500_price_high
cafe_count_2000__price
cafe_count_2000_price_500
cafe_count_2000_price_1000
cafe_count_2000_price_1500
cafe_count_2000_price_2500
cafe_count_2000_price_4000
cafe_count_2000_price_high
cafe_count_3000__price
cafe_count_3000_price_500
cafe_count_3000_price_1000
cafe_count_3000_price_1500
cafe_count_3000_price_2500
cafe_count_3000_price_4000
cafe_count_3000_price_high
cafe_count_5000__price
cafe_count_5000_price_500
cafe_count_5000_price_1000
cafe_count_5000_price_1500
cafe_count_5000_price_2500
cafe_count_5000_price_4000
cafe_count_5000_price_high
cafe_count_500__price
cafe_count_500_price_500
cafe_count_500_price_1000
cafe_count_500_price_1500
cafe_count_500_price_2500
cafe_count_500_price_4000
cafe_count_500_price_high
catering_km
cemetery_km
children_preschool
children_school
church_count_500
church_count_1000
church_count_1500
church_count_2000
church_count_3000
church_count_5000
church_sygogue_km
culture_objects_top_25
culture_objects_top_25_raion
detention_facility_km
detention_facility_raion
ecology
ekder_all
ekder_female
ekder_male
exhibition_km
female_f
fitness_km
full_all
full_sq
green_part_500
green_part_1000
green_part_1500
green_part_2000
green_part_3000
green_part_5000
green_zone_km
green_zone_part
group_0_13_all
group_0_13_female
group_0_13_male
group_0_17_all
group_0_17_female
group_0_17_male
group_0_6_all
group_0_6_female
group_0_6_male
group_16_29_all
group_16_29_female
group_16_29_male
group_7_14_all
group_7_14_female
group_7_14_male
healthcare_centers_raion
hospice_morgue_km
ice_rink_km
id
incineration_km
incineration_raion
indust_part
industrial_km
kindergarten_km
kremlin_km
leisure_count_500
leisure_count_1000
leisure_count_1500
leisure_count_2000
leisure_count_3000
leisure_count_5000
log_area_m
male_f
market_count_500
market_count_1000
market_count_1500
market_count_2000
market_count_3000
market_count_5000
market_shop_km
metro_km_avto
metro_min_avto
mkad_km
mosque_count_500
mosque_count_1000
mosque_count_1500
mosque_count_2000
mosque_count_3000
mosque_count_5000
mosque_km
museum_km
build_year
cafe_avg_price_500
cafe_avg_price_1000
cafe_avg_price_1500
cafe_avg_price_2000
cafe_avg_price_3000
cafe_avg_price_5000
cafe_sum_1000_max_price_avg
cafe_sum_1000_min_price_avg
cafe_sum_1500_max_price_avg
cafe_sum_1500_min_price_avg
cafe_sum_2000_max_price_avg
cafe_sum_2000_min_price_avg
cafe_sum_3000_max_price_avg
cafe_sum_3000_min_price_avg
cafe_sum_5000_max_price_avg
cafe_sum_5000_min_price_avg
cafe_sum_500_max_price_avg
cafe_sum_500_min_price_avg
kitch_sq
material
max_floor
metro_km_walk
metro_min_walk
num_room
preschool_quota
prom_part_5000
railroad_station_walk_km
railroad_station_walk_min
school_quota
state
nuclear_reactor_km
nuclear_reactor_raion
office_count_500
office_count_1000
office_count_1500
office_count_2000
office_count_3000
office_count_5000
office_km
office_raion
office_sqm_500
office_sqm_1000
office_sqm_1500
office_sqm_2000
office_sqm_3000
office_sqm_5000
oil_chemistry_km
oil_chemistry_raion
park_km
power_transmission_line_km
preschool_km
product_type
prom_part_500
prom_part_1000
prom_part_1500
prom_part_2000
prom_part_3000
ps_educ_centers_raion
pub_trans_stn_min_walk
public_healthcare_km
public_transport_station_km
radiation_km
radiation_raion
railroad_1line
railroad_km
railroad_station_avto_km
railroad_station_avto_min
railroad_termil_raion
raion_popul
s_educ_centers_top20_raion
sadovoe_km
school_education_centers_raion
school_km
shopping_centers_km
shopping_centers_raion
sport_count_500
sport_count_1000
sport_count_1500
sport_count_2000
sport_count_3000
sport_count_5000
sport_objects_raion
stadium_km
sub_area
swim_pool_km
theater_km
thermal_power_plant_km
thermal_power_plant_raion
timestamp
trc_count_500
trc_count_1000
trc_count_1500
trc_count_2000
trc_count_3000
trc_count_5000
trc_sqm_500
trc_sqm_1000
trc_sqm_1500
trc_sqm_2000
trc_sqm_3000
trc_sqm_5000
ts_km
ttk_km
university_km
university_top_20_raion
water_1line
water_km
water_treatment_km
work_all
work_female
work_male
workplaces_km
young_all
young_female
young_male
zd_vokzaly_avto_km
/selection=LASSO;
output out = results p = Predict;
run;

proc print data=results (obs=100);
where id > 30473; 
run;

proc contents data=test5; 
run;

proc means data=test5
	N Mean Std Min Q1 Median Q3 Max;
run; 

proc univariate data=test;
var price_doc;
run;


data results_final_sbc;
set results;
if price_doc < 1 then price_doc = predict;
keep id price_doc predict;
where id > 30473; 
run;

proc print data=results_final_sbc (obs=10);
run;

proc contents data=results_final_sbc; 
run;

proc means data=results
	N Mean Std Min Q1 Median Q3 Max;
run; 
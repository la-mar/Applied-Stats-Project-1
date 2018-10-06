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

/* train version: this step shortens long >32 char variable names 
and renames variables that start with a number */

options validvarname=any;
data train;
set train;
rename preschool_education_centers_raio='ps_educ_centers_raion'n;
rename school_education_centers_top_20_='s_educ_centers_top20_raion'n;
rename raion_build_count_with_material_='raion_bld_cnt_material_info'n;
rename public_transport_station_min_wal ='pub_trans_stn_min_walk'n; 
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

proc means data = train n nmiss;
  var _numeric_;
run;

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


/* this step uses PROC MI to impute missing values */

proc mi data=train3 seed=501213 mu0=0 out=train4;
var 
life_sq
floor
preschool_quota
school_quota
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

proc print data=train4 (obs=10);
run;

proc contents data=train4;
run;

proc means data=train4
	N Mean Std Min Q1 Median Q3 Max;
run; 

proc means data = train4 n nmiss;
  var _numeric_;
run;


/* MODEL 1 - PROC GLM and GLMSELECT with options. This model also tests for tolerance,
which is a measure of multicollinearity (tolerance = 1/VIF, where VIF is the Variance
Inflation Factor) After the model ran, we eliminated the variables that had tolerance
levels less than 0.1 (which corresponds to a VIF of 10 or greater, thus implying 
multicollinearity). We then removed these variables and ran a reduced model below */

proc glm data = train4 plots=All;
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
zd_vokzaly_avto_km/ tolerance;
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

proc contents data=train4;
run;

proc print data=train4 (obs=100);
run;

/* this is the reduced model - from above tolerance test for multicollinearity */

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
big_church_count_1000
big_church_count_500
big_church_km
big_market_km
big_market_raion
big_road1_1line
big_road1_km
big_road2_km
build_year
bus_termil_avto_km
cafe_avg_price_1000
cafe_avg_price_1500
cafe_avg_price_2000
cafe_avg_price_3000
cafe_avg_price_500
cafe_avg_price_5000
cafe_count_500
catering_km
cemetery_km
children_preschool
church_sygogue_km
culture_objects_top_25 
detention_facility_km
detention_facility_raion
ecology
ekder_all
female_f
fitness_km
full_sq
green_part_1000
green_part_1500
green_part_500
green_zone_km
green_zone_part
healthcare_centers_raion
hospice_morgue_km
ice_rink_km
id
incineration_km
incineration_raion
indust_part
industrial_km
kitch_sq
leisure_count_500
market_count_1000
market_count_1500
market_count_2000
market_count_3000
market_count_500
market_shop_km
material
max_floor
mosque_count_1000
mosque_count_1500
mosque_count_2000
mosque_count_3000
mosque_count_500
mosque_count_5000
nuclear_reactor_raion
num_room
office_count_500
office_sqm_1000
office_sqm_500
oil_chemistry_raion
preschool_quota
product_type
prom_part_1000
prom_part_500
prom_part_5000
radiation_raion
railroad_1line
railroad_station_walk_km
railroad_termil_raion
s_educ_centers_top20_raion
shopping_centers_raion
sport_count_1000
sport_count_500
state
sub_area
trc_count_500
trc_sqm_1000
trc_sqm_1500
trc_sqm_2000
trc_sqm_500
water_1line
water_km
/selection=stepwise(select=SL SLE=0.1 SLS=0.08 choose=AIC);
;
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

/* combine data sets */

data test5;
set train4 test4;
run;

proc print data=test5 (obs=10);
run;

proc contents data=test5;
run;


/* predict response field (price_doc) using desired method */

ods graphics on;
proc glm data = test5 plots=FITPLOT;
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
big_church_count_1000
big_church_count_500
big_church_km
big_market_km
big_market_raion
big_road1_1line
big_road1_km
big_road2_km
build_year
bus_termil_avto_km
cafe_avg_price_1000
cafe_avg_price_1500
cafe_avg_price_2000
cafe_avg_price_3000
cafe_avg_price_500
cafe_avg_price_5000
cafe_count_500
catering_km
cemetery_km
children_preschool
church_sygogue_km
culture_objects_top_25
detention_facility_km
detention_facility_raion
ecology
ekder_all
female_f
fitness_km
full_sq
green_part_1000
green_part_1500
green_part_500
green_zone_km
green_zone_part
healthcare_centers_raion
hospice_morgue_km
ice_rink_km
id
incineration_km
incineration_raion
indust_part
industrial_km
kitch_sq
leisure_count_500
market_count_1000
market_count_1500
market_count_2000
market_count_3000
market_count_500
market_shop_km
material
max_floor
mosque_count_1000
mosque_count_1500
mosque_count_2000
mosque_count_3000
mosque_count_500
mosque_count_5000
nuclear_reactor_raion
num_room
office_count_500
office_sqm_1000
office_sqm_500
oil_chemistry_raion
preschool_quota
product_type
prom_part_1000
prom_part_500
prom_part_5000
radiation_raion
railroad_1line
railroad_termil_raion
s_educ_centers_top20_raion
shopping_centers_raion
sport_count_1000
sport_count_500
state
sub_area
trc_count_500
trc_sqm_1000
trc_sqm_1500
trc_sqm_2000
trc_sqm_500
water_1line
water_km
;
output out = results p = Predict;
run;
ods graphics off;

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

proc means data = results n nmiss;
  var _numeric_;
run;

proc print data=results (obs=10);
where id > 30473; 
run;

proc contents data=results; 
run;

proc means data=results
	N Mean Std Min Q1 Median Q3 Max;
run; 

/* this is the final step that maps the predicted value into the price_doc variable
and then drops all variables except id and price_doc. Note: due to PROC MI, we have
many thousand more observations than we were asked to produce for the test data */

data results_final_sbc;
set results;
if price_doc < 1 then price_doc = predict;
keep id price_doc;
where id between 30474 and 38135; 
run;

proc print data=results_final_sbc (obs=100);
run;

proc contents data=results_final_sbc; 
run;




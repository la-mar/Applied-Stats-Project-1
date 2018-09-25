/* import data */

proc import datafile="/home/allen_crane0/train.csv"  /*You will need to change the path or use the import wizard.*/
          dbms=dlm out=train replace;
     delimiter=',';
     getnames=yes;
     missing=0;
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

/* convert NA values to missing, since the NA is causing SAS to recognize them as character */
/* the next step will convert them to numeric */

data train2;
set train;
if build_year="NA" then build_year="";
if cafe_avg_price_500="NA" then cafe_avg_price_500="";
if cafe_avg_price_1000="NA" then cafe_avg_price_1000="";
if cafe_sum_1000_max_price_avg="NA" then cafe_sum_1000_max_price_avg="";
if cafe_sum_1000_min_price_avg="NA" then cafe_sum_1000_min_price_avg="";
if cafe_sum_500_max_price_avg="NA" then cafe_sum_500_max_price_avg="";
if cafe_sum_500_min_price_avg="NA" then cafe_sum_500_min_price_avg="";
if hospital_beds_raion="NA" then hospital_beds_raion="";
if kitch_sq="NA" then kitch_sq="";
if material="NA" then material="";
if max_floor="NA" then max_floor="";
if num_room="NA" then num_room="";
if state="NA" then state="";
if preschool_quota="NA" then preschool_quota="";
if life_sq="NA" then life_sq="";
if floor="NA" then floor="";
if school_quota="NA" then school_quota="";
if raion_bld_cnt_material_info="NA" then raion_bld_cnt_material_info="";
if build_count_block="NA" then build_count_block="";
if build_count_wood="NA" then build_count_wood="";
if build_count_frame="NA" then build_count_frame="";
if build_count_brick="NA" then build_count_brick="";
if build_count_monolith="NA" then build_count_monolith="";
if build_count_panel="NA" then build_count_panel="";
if build_count_foam="NA" then build_count_foam="";
if build_count_slag="NA" then build_count_slag="";
if build_count_mix="NA" then build_count_mix="";
if raion_build_count_with_builddate="NA" then raion_build_count_with_builddate="";
if build_count_before_1920="NA" then build_count_before_1920="";
if build_count_1921_1945="NA" then build_count_1921_1945="";
if build_count_1946_1970="NA" then build_count_1946_1970="";
if build_count_1971_1995="NA" then build_count_1971_1995="";
if build_count_after_1995="NA" then build_count_after_1995="";
if metro_min_walk="NA" then metro_min_walk="";
if metro_km_walk="NA" then metro_km_walk="";
if railroad_station_walk_km="NA" then railroad_station_walk_km="";
if railroad_station_walk_min="NA" then railroad_station_walk_min="";
if ID_railroad_station_walk="NA" then ID_railroad_station_walk="";
if cafe_sum_1500_min_price_avg="NA" then cafe_sum_1500_min_price_avg="";
if cafe_sum_1500_max_price_avg="NA" then cafe_sum_1500_max_price_avg="";
if cafe_avg_price_1500="NA" then cafe_avg_price_1500="";
if cafe_sum_2000_min_price_avg="NA" then cafe_sum_2000_min_price_avg="";
if cafe_sum_2000_max_price_avg="NA" then cafe_sum_2000_max_price_avg="";
if cafe_avg_price_2000="NA" then cafe_avg_price_2000="";
if cafe_sum_3000_min_price_avg="NA" then cafe_sum_3000_min_price_avg="";
if cafe_sum_3000_max_price_avg="NA" then cafe_sum_3000_max_price_avg="";
if cafe_avg_price_3000="NA" then cafe_avg_price_3000="";
if cafe_sum_5000_min_price_avg="NA" then cafe_sum_5000_min_price_avg="";
if cafe_sum_5000_max_price_avg="NA" then cafe_sum_5000_max_price_avg="";
if cafe_avg_price_5000="NA" then cafe_avg_price_5000="";
if prom_part_5000="NA" then prom_part_5000="";
run;

proc print data=train2 (obs=10);
run;

proc contents data=train2;
run;

/* convert these variables to numeric */

data train3;
set train2;
   build_year = '';
   n_build_year = input(build_year, 8.);
   cafe_avg_price_500 = '';
   n_cafe_avg_price_500 = input(cafe_avg_price_500, 8.);
   cafe_avg_price_1000 = '';
   n_cafe_avg_price_1000 = input(cafe_avg_price_1000, 8.);
   cafe_sum_1000_max_price_avg = '';
   n_cafe_sum_1000_max_price_avg = input(cafe_sum_1000_max_price_avg, 8.);
   cafe_sum_1000_min_price_avg = '';
   n_cafe_sum_1000_min_price_avg = input(cafe_sum_1000_min_price_avg, 8.);
   cafe_sum_500_max_price_avg = '';
   n_cafe_sum_500_max_price_avg = input(cafe_sum_500_max_price_avg, 8.);
   cafe_sum_500_min_price_avg = '';
   n_cafe_sum_500_min_price_avg = input(cafe_sum_500_min_price_avg, 8.);
   hospital_beds_raion = '';
   n_hospital_beds_raion = input(hospital_beds_raion, 8.);
   kitch_sq = '';
   n_kitch_sq = input(kitch_sq, 8.);
   material = '';
   n_material = input(material, 8.);
   max_floor = '';
   n_max_floor = input(max_floor, 8.);
   num_room = '';
   n_num_room = input(num_room, 8.);
   state = '';   
   n_state = input(state, 8.);
   preschool_quota = '';
   n_preschool_quota = input(preschool_quota, 8.);
   life_sq ='';
   n_life_sq = input(life_sq, 8.);
   floor ='';
   n_floor = input(floor, 8.);
   school_quota ='';
   n_school_quota = input(school_quota, 8.);
   raion_bld_cnt_material_info ='';
   n_raion_bld_cnt_material_info = input(raion_bld_cnt_material_info, 8.);
   build_count_block ='';
   n_build_count_block = input(build_count_block, 8.);
   build_count_wood ='';
   n_build_count_wood = input(build_count_wood, 8.);
   build_count_frame ='';
   n_build_count_frame = input(build_count_frame, 8.);
   build_count_brick ='';
   n_build_count_brick = input(build_count_brick, 8.);
   build_count_monolith ='';
   n_build_count_monolith = input(build_count_monolith, 8.);
   build_count_panel ='';
   n_build_count_panel = input(build_count_panel, 8.);
   build_count_foam ='';
   n_build_count_foam = input(build_count_foam, 8.);
   build_count_slag ='';
   n_build_count_slag = input(build_count_slag, 8.);
   build_count_mix ='';
   n_build_count_mix = input(build_count_mix, 8.);
   raion_build_count_with_builddate ='';
   n_raion_build_count_with_date = input(raion_build_count_with_builddate, 8.);
   build_count_before_1920 ='';
   n_build_count_before_1920 = input(build_count_before_1920, 8.);
   build_count_1921_1945 ='';
   n_build_count_1921_1945 = input(build_count_1921_1945, 8.);
   build_count_1946_1970 ='';
   n_build_count_1946_1970 = input(build_count_1946_1970, 8.);
   build_count_1971_1995 ='';
   n_build_count_1971_1995 = input(build_count_1971_1995, 8.);
   build_count_after_1995 ='';
   n_build_count_after_1995 = input(build_count_after_1995, 8.);
   metro_min_walk ='';
   n_metro_min_walk = input(metro_min_walk, 8.);
   metro_km_walk ='';
   n_metro_km_walk = input(metro_km_walk, 8.);
   railroad_station_walk_km ='';
   n_railroad_station_walk_km = input(railroad_station_walk_km, 8.);
   railroad_station_walk_min ='';
   n_railroad_station_walk_min = input(railroad_station_walk_min, 8.);
   ID_railroad_station_walk ='';
   n_ID_railroad_station_walk = input(ID_railroad_station_walk, 8.);
   cafe_sum_1500_min_price_avg ='';
   n_cafe_sum_1500_min_price_avg = input(cafe_sum_1500_min_price_avg, 8.);
   cafe_sum_1500_max_price_avg ='';
   n_cafe_sum_1500_max_price_avg = input(cafe_sum_1500_max_price_avg, 8.);
   cafe_avg_price_1500 ='';
   n_cafe_avg_price_1500 = input(cafe_avg_price_1500, 8.);
   cafe_sum_2000_min_price_avg ='';
   n_cafe_sum_2000_min_price_avg = input(cafe_sum_2000_min_price_avg, 8.);
   cafe_sum_2000_max_price_avg ='';
   n_cafe_sum_2000_max_price_avg = input(cafe_sum_2000_max_price_avg, 8.);
   cafe_avg_price_2000 ='';
   n_cafe_avg_price_2000 = input(cafe_avg_price_2000, 8.);
   cafe_sum_3000_min_price_avg ='';
   n_cafe_sum_3000_min_price_avg = input(cafe_sum_3000_min_price_avg, 8.);
   cafe_sum_3000_max_price_avg ='';
   n_cafe_sum_3000_max_price_avg = input(cafe_sum_3000_max_price_avg, 8.);
   cafe_avg_price_3000 ='';
   n_cafe_avg_price_3000 = input(cafe_avg_price_3000, 8.);
   cafe_sum_5000_min_price_avg ='';
   n_cafe_sum_5000_min_price_avg = input(cafe_sum_5000_min_price_avg, 8.);
   cafe_sum_5000_max_price_avg ='';
   n_cafe_sum_5000_max_price_avg = input(cafe_sum_5000_max_price_avg, 8.);
   cafe_avg_price_5000 ='';
   n_cafe_avg_price_5000 = input(cafe_avg_price_5000, 8.);
   prom_part_5000 ='';
   n_prom_part_5000 = input(prom_part_5000, 8.);
run;

proc contents data=train3;
run;

/* this step just drops the original character variables */

data train4;
set train3 (drop = 
build_year 
cafe_avg_price_500 
cafe_avg_price_1000 
cafe_sum_1000_max_price_avg 
cafe_sum_1000_min_price_avg 
cafe_sum_500_max_price_avg 
cafe_sum_500_min_price_avg 
hospital_beds_raion 
kitch_sq 
material 
max_floor 
num_room 
state
preschool_quota
life_sq
floor
school_quota
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
ID_railroad_station_walk
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

proc contents data=train4;
run;

proc means data=train4
	N Mean Std Min Q1 Median Q3 Max;
run;


/* MODEL 1 */

proc glm data = train4 plots=All;
class sub_area
culture_objects_top_25 
thermal_power_plant_raion 
incineration_raion
oil_chemistry_raion 
radiation_raion
railroad_terminal_raion 
big_market_raion 
nuclear_reactor_raion 
detention_facility_raion 
ecology
water_1line 
big_road1_1line 
railroad_1line;
model price_doc = 
additional_education_km
additional_education_raion
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
bus_terminal_avto_km
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
church_synagogue_km
culture_objects_top_25
culture_objects_top_25_raion
detention_facility_km
detention_facility_raion
ecology
ekder_all
ekder_female
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
group_0_17_all
group_0_17_female
group_0_6_female
group_0_6_male
group_16_29_all
group_16_29_female
group_7_14_female
group_7_14_male
healthcare_centers_raion
hospice_morgue_km
ice_rink_km
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
prom_part_500
prom_part_1000
prom_part_1500
prom_part_2000
prom_part_3000
ps_educ_centers_raion
pub_trans_stn_min_walk
public_healthcare_km
radiation_km
radiation_raion
railroad_1line
railroad_km
railroad_station_avto_km
railroad_station_avto_min
railroad_terminal_raion
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
water_1line
water_km
water_treatment_km
workplaces_km
zd_vokzaly_avto_km
;
run;

/* alternate settings for proc glmselect

/selection=stepwise(stop=cv) cvmethod=random(10);
/selection=forward(stop=cv) cvmethod=random(10)
/selection=stepwise(stop=cv) cvmethod=random(10);

*/

/* MODEL 2 (removes all coefficients with p-values not < alpha*/

proc glmselect data = train4 plots=All;
class sub_area
culture_objects_top_25 
thermal_power_plant_raion 
incineration_raion
oil_chemistry_raion 
radiation_raion
railroad_terminal_raion 
big_market_raion 
nuclear_reactor_raion 
detention_facility_raion 
ecology
water_1line 
big_road1_1line 
railroad_1line;
model price_doc = 
additional_education_km
area_m
basketball_km
big_church_count_500
big_church_count_1000
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
bus_terminal_avto_km
catering_km
cemetery_km
children_preschool
children_school
church_count_500
church_count_1500
church_count_2000
church_count_3000
church_count_5000
church_synagogue_km
culture_objects_top_25
culture_objects_top_25_raion
ecology
ekder_all
ekder_female
exhibition_km
female_f
fitness_km
full_all
full_sq
green_part_500
green_part_1500
green_part_3000
green_zone_km
green_zone_part
group_0_13_all
group_0_13_female
group_0_17_all
group_0_17_female
group_0_6_female
group_0_6_male
group_16_29_female
group_7_14_female
group_7_14_male
healthcare_centers_raion
ice_rink_km
incineration_km
indust_part
industrial_km
kindergarten_km
kremlin_km
leisure_count_500
leisure_count_1000
leisure_count_1500
leisure_count_2000
leisure_count_3000
market_count_500
market_count_5000
market_shop_km
metro_min_avto
mkad_km
mosque_count_1000
mosque_count_1500
mosque_count_3000
museum_km
nuclear_reactor_km
office_count_500
office_count_1000
office_count_1500
office_count_2000
office_count_5000
office_km
office_raion
office_sqm_500
office_sqm_1000
office_sqm_1500
office_sqm_2000
office_sqm_3000
oil_chemistry_km
oil_chemistry_raion
park_km
power_transmission_line_km
preschool_km
prom_part_500
prom_part_1000
prom_part_1500
prom_part_2000
prom_part_3000
ps_educ_centers_raion
pub_trans_stn_min_walk
railroad_1line
railroad_km
raion_popul
sadovoe_km
shopping_centers_km
shopping_centers_raion
sport_count_1000
sport_count_2000
sport_count_3000
sub_area
swim_pool_km
theater_km
thermal_power_plant_km
timestamp
trc_count_5000
trc_sqm_500
trc_sqm_1000
ttk_km
/selection=stepwise(stop=cv) cvmethod=random(10);
run;

/* alternate settings for proc glmselect

/selection=forward(stop=cv) cvmethod=random(10);
/selection=backward(stop=cv) cvmethod=random(10)
/selection=stepwise(stop=cv) cvmethod=random(10);

*/

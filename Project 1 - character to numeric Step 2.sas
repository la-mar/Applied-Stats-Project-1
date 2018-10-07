/* SAS code for Russian Real Estate data project */
/* Last updated 10/01/2018 @ 6:00PM by Allen Crane

/* convert the following character variables to numeric */
/* drop the original variable names */


data train2;
set train;
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

proc contents data=train3;
run;

proc means data=train3
	N Mean Std Min Q1 Median Q3 Max;
run; 
MSDS 6372 - Applied Statistics: Inference and Modeling
Dr. Anthony Tanaydin
By Allen Crane and Brock Friedrich
October 10, 2018



/* Russian Real Estate Valuation and Prediction */
/* Problem 1 Step 3 - Impute missing values using PROC MI */

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
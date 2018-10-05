/* SAS code for Russian Real Estate data project */
/* Last updated 10/01/2018 @ 6:00PM by Allen Crane

/* data imputation using stochastic method (Expectation Maximization - EM)         */
/* this step uses PROC MI to impute missing values, it does not impute a single    */
/* value, but rather a distribution of values that maintains the original variance */
/* so the end result is a file with more than 761k observations                    */

proc mi data=train3 seed=501213 
     mu0=0 out=train4;
     var
n_build_year
n_cafe_avg_price_500
n_cafe_avg_price_1000
n_cafe_sum_1000_max_price_avg
n_cafe_sum_1000_min_price_avg
n_cafe_sum_500_max_price_avg
n_cafe_sum_500_min_price_avg
n_kitch_sq
n_material
n_max_floor
n_num_room
n_state
n_preschool_quota
n_school_quota
n_metro_min_walk
n_metro_km_walk
n_railroad_station_walk_km
n_railroad_station_walk_min
n_cafe_sum_1500_min_price_avg
n_cafe_sum_1500_max_price_avg
n_cafe_avg_price_1500
n_cafe_sum_2000_min_price_avg
n_cafe_sum_2000_max_price_avg
n_cafe_avg_price_2000
n_cafe_sum_3000_min_price_avg
n_cafe_sum_3000_max_price_avg
n_cafe_avg_price_3000
n_cafe_sum_5000_min_price_avg
n_cafe_sum_5000_max_price_avg
n_cafe_avg_price_5000
n_prom_part_5000;
run;

proc contents data=train4;
run;

proc means data=train4
	N Mean Std Min Q1 Median Q3 Max;
run;
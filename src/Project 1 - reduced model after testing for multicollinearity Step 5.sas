MSDS 6372 - Applied Statistics: Inference and Modeling
Dr. Anthony Tanaydin
By Allen Crane and Brock Friedrich
October 10, 2018



/* Russian Real Estate Valuation and Prediction */
/* Problem 1 Step 5 - Reduced model, after testing for multicollinearity */

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


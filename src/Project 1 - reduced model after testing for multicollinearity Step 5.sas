MSDS 6372 - Applied Statistics: Inference and Modeling
Dr. Anthony Tanaydin
By Allen Crane and Brock Friedrich
October 10, 2018



/* Russian Real Estate Valuation and Prediction */
/* Problem 1 Step 5 - Reduced model, after testing for multicollinearity */

/* this is the reduced model - from above tolerance test for multicollinearity */

proc glmselect data = train4 plots=All;
class
...
;
model price_doc =
...
/selection=stepwise(select=SL SLE=0.1 SLS=0.08 choose=AIC);
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



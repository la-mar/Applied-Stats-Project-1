import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd
import os
import numpy as np
import statsmodels.api as sm
import statsmodels.formula.api as smf
from scipy import stats

os.getcwd()
# Pandas global config
pd.options.display.max_rows = None
pd.set_option('display.float_format', lambda x: '%.2f' % x)
pd.set_option('large_repr', 'truncate')

# Matplotlib global config
plt.rcParams.update({'legend.fontsize': 'x-large',
          'figure.figsize': (15, 5),
         'axes.labelsize': 'x-large',
         'axes.titlesize':'x-large',
         'xtick.labelsize':'x-large',
         'ytick.labelsize':'x-large',
         'savefig.dpi' : 300,
         'savefig.format' : 'png',
         'savefig.transparent' : True,
         'axes.labelpad' : 6
         })
matplotlib.style.use('seaborn-deep') #print(plt.style.available)

amt = 10000000
def short_currency(amt: float) -> float:
        M = 1000000
        K = 1000
        if amt > M:
                return '$ {:.0f} MM'.format(amt/M)
        elif amt > K:
                return '$ {:.0f} MM'.format(amt/K)

tform_currency = plt.FuncFormatter(lambda x, p: short_currency(x))


#! Resources
# http://www.statsmodels.org/stable/examples/notebooks/generated/tsa_arma_0.html

train = pd.read_csv('data/train.csv')

train.describe().T

train.dtypes

pd.set_option('precision',2)

train.get_dtype_counts()

# list(train.select_dtypes('object').columns)

train.timestamp = pd.to_datetime(train.timestamp)


train['year'] = train.timestamp.apply(lambda x: (x.year))
train['month'] = train.timestamp.apply(lambda x: (x.month))
train['day'] = train.timestamp.apply(lambda x: (x.day))
train['yearmonth'] = train.timestamp.apply(lambda x: ('{:04d}{:02d}'.format(x.year, x.month)))





cols = ['timestamp', 'year', 'month', 'day', 'yearmonth', 'price_doc']
subtrain = train[cols].copy(deep = True)
subtrain.describe()

subtrain[['year', 'month', 'day']] = subtrain[['year', 'month', 'day']].astype('object')
subtrain.dtypes
# subtrain = subtrain.groupby('yearmonth').mean()
subtrain = subtrain.set_index('timestamp')
subtrain = subtrain.resample('M').mean()
subtrain = subtrain.sort_index()
subtrain['month_number'] = range(1, len(subtrain) + 1)
# subtrain['timestamp'] = subtrain.index
subtrain.head()

X = subtrain.month_number.values
Y = subtrain.price_doc.values

#! Problem 2-3
# sns.set_style("seaborn-deep")
with plt.style.context('seaborn-deep'):
        plot = sns.lineplot(x= X
                , y= Y
                #     , data=subtrain
                )
        plot.set(xlabel = 'Months'
                , ylabel = 'Price'
                , title = 'Price by Month'
                )
        plot.yaxis.set_major_formatter(tform_currency)
        # plot.get_figure().style.use('seaborn-deep')





plot.get_figure().savefig('figs/p2-3_price-v-months.png')

#! Problem 2-4

##? Part a


# X = subtrain.month_number#.values#.reshape(-1, 1)
# y = subtrain.price_doc#.values#.reshape(-1, 1)

reg = smf.ols("price_doc ~ month_number", data = subtrain).fit()

reg.summary()


influence_plot, ax = plt.subplots(figsize=(12,8))
influence_plot = sm.graphics.influence_plot(reg, ax=ax, criterion="cooks")
influence_plot



reg_plot, ax = plt.subplots(figsize=(12,8))
reg_plot = sm.graphics.plot_regress_exog(reg, "month_number", fig=reg_plot)
reg_plot


preg_plot, ax = plt.subplots(figsize=(12,8))
preg_plot = sm.graphics.plot_partregress_grid(reg, fig=preg_plot)
preg_plot



fit_plot, ax = plt.subplots(figsize=(12, 8))
fit_plot = sm.graphics.plot_fit(reg, "month_number", ax=ax)
fit_plot


##? Part b

subtrain = subtrain.join(reg.resid.rename('resid'))
R = subtrain.resid.values



line_plot, ax = plt.subplots(figsize=(12, 8))
line_plot = sns.lineplot(x = X
            , y = subtrain.resid.values
            , ax = ax
            , markers = True)
line_plot

# doc: https://seaborn.pydata.org/generated/seaborn.JointGrid.html#seaborn.JointGrid
g = sns.JointGrid(x = X, y = subtrain.price_doc.values)
g = g.plot_joint(sns.regplot, color = '#15D888')
g = g.plot_marginals(sns.distplot, color = '#15D888', kde = False)#, shade=True)
rsq = lambda a, b: stats.pearsonr(a, b)[0] ** 2
g = g.annotate(rsq, template="{stat}: {val:.2f}",
                        stat="$R^2$", loc="upper left", fontsize=12)
g.ax_joint.get_lines()[0].set_color('#D81565')


##? Part c


# plot autocorrelation of lm residuals
# doc: https://matplotlib.org/api/_as_gen/matplotlib.figure.Figure.html#matplotlib.figure.Figure.add_subplot
f, (ax1, ax2, ax3) = plt.subplots(3, sharex=True, sharey=False, figsize=(24,16))
ax1 = sm.graphics.tsa.plot_acf(subtrain.resid.values.squeeze(), lags=40, ax=ax1)
ax2 = sm.graphics.tsa.plot_pacf(subtrain.resid.values.squeeze(), lags=40, ax=ax2, method = 'ols')
ax3 = sm.graphics.tsa.plot_pacf(subtrain.resid.values.squeeze(), lags=40, ax=ax3, method = 'yw')



# Autoregress lm residuals
# doc: http://www.statsmodels.org/stable/generated/statsmodels.tsa.ar_model.AR.html#statsmodels.tsa.ar_model.AR
#** What p results in the best fit?
ts = sm.tsa.AR(subtrain.resid, dates = subtrain.index).fit(maxlag = 3)

# coefs

# AR Model Summary
ts.Summary =(ts.params.rename('param_est').to_frame()
                        .join(ts.tvalues.rename('t'))
                        .join(ts.pvalues.rename('p > |t|'))
                        .join(ts.conf_int().rename({0 : 'lcl',1 : 'ucl'}, axis = 1))
                        .join(ts.bse.rename('se'))
            )



# Information Criterion
ts.ics = pd.DataFrame({
        'AIC' : [ts.aic]
        ,'BIC' : [ts.bic]
        ,'Durbin-Watson' : sm.stats.durbin_watson(ts.resid.values)
        }).squeeze()

# plot ts residuals
fig = plt.figure(figsize=(12,8))
ax = fig.add_subplot(111)
ax = ts.resid.plot(ax=ax)

# Check normality of ts residuals
stats.normaltest(ts.resid).__dir__()

fig = plt.figure(figsize=(12,8))
ax = fig.add_subplot(111)
fig = sm.graphics.qqplot(ts.resid, line='q', ax=ax, fit=True)

fig = plt.figure(figsize=(12,8))
ax1 = fig.add_subplot(211)
fig = sm.graphics.tsa.plot_acf(ts.resid, lags=40, ax=ax1)
ax2 = fig.add_subplot(212)
fig = sm.graphics.tsa.plot_pacf(ts.resid, lags=40, ax=ax2)

##? Part d
# doc: http://www.statsmodels.org/stable/generated/statsmodels.tsa.ar_model.AR.predict.html#statsmodels.tsa.ar_model.AR.predict


#? Forecast residuals using OLS
p_start = pd.Timestamp(year = 2015, month = 6, day = 30, freq = 'M')
p_end = pd.Timestamp(year = 2016, month = 8, day = 31) #pd.Timestamp(year = 2016, month = 6, day = 30, freq = 'M')
d_start = subtrain.index.min()

# Define interval to predict
p_range = list(range(subtrain.month_number.max(), subtrain.month_number.max() + 12))
p_dt_range = pd.date_range(subtrain.index.max() + 1, periods=12, freq='M')
pred_range = pd.DataFrame(p_range).rename({0 : 'month_number'}, axis = 1)
p_dt_range = pd.DataFrame(p_dt_range).join(pred_range).set_index(0)
# In-sample prediction
p_in = ts.predict() # offset by number of auto regressors

# Out-of-sample prediction
p_out = ts.predict(start = p_start, end = p_end)

predX = np.hstack((X, pred_range.month_number.values))
predY = np.hstack((p_in, p_out))

fig = plt.figure()
fig = sns.scatterplot(X, R, label="Data")
fig = sns.lineplot(predX, predY, label="OLS prediction", color = 'red')



#? Forecast residuals using ARMA
arma = sm.tsa.ARMA(subtrain.resid, (4,0), dates = subtrain.index).fit(maxlag = 3)

f, (ax1, ax2) = plt.subplots(2, sharex=False, sharey=False, figsize=(24,16))
ax1 = subtrain.resid.loc[d_start:].plot(ax=ax1)
ax1 = arma.plot_predict(p_start, p_end, dynamic=True, ax=ax1)
ax2 = arma.plot_predict(p_start, p_end, dynamic=True, ax=ax2)


#! Problem 5


#? Forecast price using OLS
p_start = pd.Timestamp(year = 2015, month = 7, day = 31)
p_end = pd.Timestamp(year = 2016, month = 6, day = 30)
in_means = reg.get_prediction().summary_frame(alpha = 0.05).drop('mean_se', axis = 1)['mean']

pred_means = reg.get_prediction(pred_range).summary_frame(alpha = 0.05).drop('mean_se', axis = 1)['mean']

# In-sample prediction
p_in = reg.predict(subtrain.month_number).values

# Out-of-sample prediction
p_out = ts.predict(start = p_start, end = p_end)

predX = np.hstack((X, pred_range.month_number.values))
predY = np.hstack((p_in, p_out))

# FIXME: This section is hacked together. Use reg.get_prediciton output instead and fix plots.
fig, ax = plt.subplots()
ax.plot(X, Y, 'o', label="Data")
ax.plot(X, in_means.values, 'r', label="OLS prediction")
ax.plot(pred_range.month_number.values, pred_means.values+p_out.values, 'g', label="OLS prediction")
ax.legend(loc="best")




in_means = reg.get_prediction().summary_frame(alpha = 0.05)
out_means = reg.get_prediction(p_dt_range).summary_frame(alpha = 0.05).join(p_dt_range.reset_index()).set_index(0)
pred = pd.concat([in_means, out_means]).drop('month_number', axis = 1)

pred[['mean','mean_ci_lower', 'mean_ci_upper']].plot()


pred2 = pred[['mean','mean_ci_lower', 'mean_ci_upper']].astype('float')
pred2.index = pd.to_datetime(pred2.index).rename('timestamp')

sns.tsplot([pred2.mean_ci_lower, pred2.mean_ci_upper, pred2['mean']])#, err_style="ci_bars", interpolate=False)



# Save data for submission
pred.round(0).to_csv('data/p2preds.csv')

#? Forecast price using ARMA

p = ts.predict(start = p_start, end = p_end)

# Arma Model for prediction #! Fix CI, time permitting
arma = sm.tsa.ARMA(subtrain.price_doc, (4,0), dates = subtrain.index).fit(maxlag = 3)

f, (ax1, ax2) = plt.subplots(2, sharex=False, sharey=False, figsize=(24,16))
ax1 = subtrain.price_doc.loc[d_start:].plot(ax=ax1)
ax1 = arma.plot_predict(p_start, p_end, dynamic=True, ax=ax1, alpha = 0.05)
ax2 = arma.plot_predict(p_start, p_end, dynamic=True, ax=ax2, alpha = 0.05)




sm.tsa.ARMA.fit.__dir__()


# ts.conf_int()

# pd.DataFrame.roun

# type(p)

# ts.model


# dir(p)
# dir(ts)
# dir(ts.model)
# dir(ts.data)
# dir(ts.predict())

# dir(ts.predict())

# help(arma.plot_predict)

# pd.DataFrame.mer

# sm.stats.s




# ts.summary()


# subtrain


# subtrain.dtypes


# type(reg.resid)
# dir(pd.Timestamp)
# dir(reg)
# dir(reg.get_influence().summary_table())




# # Influence
# pd.DataFrame.from_records(reg.get_influence().summary_table().data)


# pd.DataFrame



# help(sns.lineplot)


# pd.DataFrame.sort_index

# import seaborn as sns
# sns.set(style="ticks")

# # Load the example dataset for Anscombe's quartet
# df = sns.load_dataset("iris")
# sns.pairplot(subtrain
#             # , hue = 'year'
#             , diag_kind = 'kde'
#             )



# sns.lmplot(x="month_number", y="price_doc", data=subtrain)


# # sns.set(style="whitegrid")

# rs = np.random.RandomState(365)
# values = rs.randn(365, 4).cumsum(axis=0)
# dates = pd.date_range("1 1 2016", periods=365, freq="D")
# data = pd.DataFrame(values, dates, columns=["A", "B", "C", "D"])
# data = data.rolling(7).mean()

# sns.lineplot(data=data, palette="tab10", linewidth=2.5)







# #! OLS Prediction bands
# # https://stackoverflow.com/questions/17559408/confidence-and-prediction-intervals-with-statsmodels
# # iv_l and iv_u give you the limits of the prediction interval for each point.

# # Prediction interval is the confidence interval for an observation and includes the estimate of the error.

# # I think, confidence interval for the mean prediction is not yet available in statsmodels. (Actually, the confidence interval for the fitted values is hiding inside the summary_table of influence_outlier, but I need to verify this.)

# # Proper prediction methods for statsmodels are on the TODO list.

# # Addition

# # Confidence intervals are there for OLS but the access is a bit clumsy.

# # To be included after running your script:

# # from statsmodels.stats.outliers_influence import summary_table

# st, data, ss2 = summary_table(re, alpha=0.05)

# fittedvalues = data[:, 2]
# predict_mean_se  = data[:, 3]
# predict_mean_ci_low, predict_mean_ci_upp = data[:, 4:6].T
# predict_ci_low, predict_ci_upp = data[:, 6:8].T

# # Check we got the right things
# print np.max(np.abs(re.fittedvalues - fittedvalues))
# print np.max(np.abs(iv_l - predict_ci_low))
# print np.max(np.abs(iv_u - predict_ci_upp))

# plt.plot(x, y, 'o')
# plt.plot(x, fittedvalues, '-', lw=2)
# plt.plot(x, predict_ci_low, 'r--', lw=2)
# plt.plot(x, predict_ci_upp, 'r--', lw=2)
# plt.plot(x, predict_mean_ci_low, 'r--', lw=2)
# plt.plot(x, predict_mean_ci_upp, 'r--', lw=2)
# plt.show()
















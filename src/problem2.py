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
pd.set_option('precision',2)
# Matplotlib global config
plt.rcParams.update({'legend.fontsize': 'x-large',
          'figure.figsize': (20, 10),
         'axes.labelsize': 'x-large',
         'axes.titlesize':'xx-large',
         'xtick.labelsize':'x-large',
         'ytick.labelsize':'x-large',
         'savefig.dpi' : 300,
         'savefig.format' : 'png',
         'savefig.transparent' : True,
         'axes.labelpad' : 10,
         'axes.titlepad' : 10,
         'axes.titleweight': 'bold'
         })
plt.style.use('seaborn-deep')
#print(plt.style.available)
# plt.rcParams.update(plt.rcParamsDefault)
# plt.rcParams.keys()

short_currency(100000)


def short_currency(amt: float) -> float:
        sign = '' if amt >= 0 else '-'
        amt = abs(amt)
        M = 1000000
        K = 1000
        div = 1
        divname = ''
        
        if amt >= M:
                div = M
                divname = 'M'
        elif amt >= K:
                div = K
                divname = 'K'
        return '{sign}${:.0f} {divname}'.format(amt/div, divname = divname, sign = sign)

tform_currency = plt.FuncFormatter(lambda x, p: short_currency(x))


#! Resources
# http://www.statsmodels.org/stable/examples/notebooks/generated/tsa_arma_0.html

train = pd.read_csv('data/train.csv')

# Summarize Features
htmlname = 'table-train-describe'
train.describe().T.to_html(open('html/{htmlname}.html'.format(htmlname = htmlname), 'w')
                                , table_id = htmlname)


# Data Type Counts
train.get_dtype_counts()


train.timestamp = pd.to_datetime(train.timestamp)


train['year'] = train.timestamp.apply(lambda x: (x.year))
train['month'] = train.timestamp.apply(lambda x: (x.month))
train['day'] = train.timestamp.apply(lambda x: (x.day))
train['yearmonth'] = train.timestamp.apply(lambda x:
                ('{:04d}{:02d}'.format(x.year, x.month)))


cols = ['timestamp', 'year', 'month', 'day', 'yearmonth', 'price_doc']
subtrain = train[cols].copy(deep = True)
subtrain.describe()

subtrain[['year', 'month', 'day']] = subtrain[['year', 'month', 'day']].astype('object')
# subtrain.dtypes
# subtrain = subtrain.groupby('yearmonth').mean()
subtrain = subtrain.set_index('timestamp')
subtrain = subtrain.resample('M').mean()
subtrain = subtrain.sort_index()
subtrain['month_number'] = range(1, len(subtrain) + 1)
subtrain.head()

X = subtrain.month_number.values
Y = subtrain.price_doc.values

#! Problem 2-3
# sns.set_style("seaborn-deep")
fig, ax = plt.subplots(figsize=(12,8))
ax.plot(X, Y
        , linewidth=2
        # , linestyle=':'
        , marker='o'
        )
ax.set_title('Price v Months')
ax.set_xlabel('Months')
ax.set_ylabel('Price')
ax.yaxis.set_major_formatter(tform_currency)
fig.savefig('figs/p2-3_price-v-months.png')





# import pprint
# import numpy as np

# # Plotly
# import plotly.plotly as py
# import plotly.tools as tls
# from plotly.graph_objs import *
# import plotly.offline as offline
# import plotly.graph_objs as go

# pp = pprint.PrettyPrinter(indent=4)

# plotly_fig = tls.mpl_to_plotly(fig)
# pp.pprint(plotly_fig['layout'])
# offline.plot(plotly_fig, filename='figs/name.html')







#! Problem 2-4

##? Part a

# OLS Regression Model
reg = smf.ols("price_doc ~ month_number", data = subtrain).fit()

# OLS Model Summary
# TODO: Capture output for report
reg.summary()

reg._results.outlier_test()

with open('html/p2-4_ols_summary.html', 'w') as f:
        f.write(reg._results.summary2().as_html())


line_plot, ax = plt.subplots(figsize=(12, 8))
ax = sns.scatterplot(x = reg._results.get_influence().cooks_distance[0]
                , y = reg._results.get_influence().cooks_distance[1]
                , ax = ax)
ax.set_title('Residuals')




# FIXME: Fix annotations
# influence_plot, ax = plt.subplots(figsize=(12,8))
influence_plot = sm.graphics.influence_plot(reg, criterion="cooks", obs_labels = False)
influence_plot.savefig('figs/p2-4a_influence_plot.png')
influence_plot.properties()

# Regression plots
reg_plot = sm.graphics.plot_regress_exog(reg, "month_number")
for ax in reg_plot.axes:
      ax.yaxis.set_major_formatter(tform_currency)
reg_plot.savefig('figs/p2-4a_reg_plot.png')

# reg_plot.axes[0].properties()
# reg_plot.properties()

# Partials
# FIXME: Format labels and tick marks
preg_plot, ax = plt.subplots(figsize=(12,8))
preg_plot = sm.graphics.plot_partregress_grid(reg, fig=preg_plot)
preg_plot.savefig('figs/p2-4a_preg_plot.png')


# Fit Plots
# FIXME: Format labels and tick marks
fit_plot, ax = plt.subplots(figsize=(12, 8))
fit_plot = sm.graphics.plot_fit(reg, "month_number", ax=ax)
fit_plot.savefig('figs/p2-4a_fit_plot.png')


##? Part b

# Join OLS residuals to original data
subtrain = subtrain.join(reg.resid.rename('resid'))

# Capture OLS residuals for use in later steps
R = subtrain.resid.values

# Plot OLS residuals as series
# FIXME: Format labels and tick marks
line_plot, ax = plt.subplots(figsize=(12, 8))
ax = sns.lineplot(x = X
            , y = subtrain.resid.values
            , ax = ax
            , markers = True)
ax.set_title('Residuals')
ax.set_xlabel('Months')
ax.set_ylabel('Price')
line_plot.savefig('figs/p2-4b_line_plot.png')

# doc: https://seaborn.pydata.org/generated/seaborn.JointGrid.html#seaborn.JointGrid

# OLS Residuals join distribution + scatterplot
# FIXME: Formatting. All of it. Add title and labels. Format y.
joint = sns.JointGrid(x = X, y = subtrain.resid.values)
joint = joint.plot_joint(sns.scatterplot, color = '#15D888')
joint = joint.plot_marginals(sns.distplot, color = '#15D888', kde = False)#, shade=True)
joint.savefig('figs/p2-4b_joint_plot.png')
# rsq = lambda a, b: stats.pearsonr(a, b)[0] ** 2
# g = g.annotate(rsq, template="{stat}: {val:.2f}",
#                         stat="$R^2$", loc="upper left", fontsize=12)
# g.ax_joint.get_lines()[0].set_color('#D81565')


##? Part c


# Plot autocorrelation of OLS residuals
# doc: https://matplotlib.org/api/_as_gen/matplotlib.figure.Figure.html#matplotlib.figure.Figure.add_subplot
f, (ax1, ax2, ax3) = plt.subplots(3, sharex=True, sharey=False, figsize=(24,16))
ax1 = sm.graphics.tsa.plot_acf(subtrain.resid.values.squeeze(), lags=40, ax=ax1)
ax2 = sm.graphics.tsa.plot_pacf(subtrain.resid.values.squeeze(), lags=40, ax=ax2, method = 'ols')
ax3 = sm.graphics.tsa.plot_pacf(subtrain.resid.values.squeeze(), lags=40, ax=ax3, method = 'yw')
f.savefig('figs/p2-4c_tsa_ar.png')


# Autoregress OLS residuals
# doc: http://www.statsmodels.org/stable/generated/statsmodels.tsa.ar_model.AR.html#statsmodels.tsa.ar_model.AR
#** What p results in the best fit?
ts = sm.tsa.AR(subtrain.resid, dates = subtrain.index).fit(maxlag = 3)

# coefs

# AR Model Summary
# TODO: Export for report
ts.Summary =(ts.params.rename('param_est').to_frame()
                        .join(ts.tvalues.rename('t'))
                        .join(ts.pvalues.rename('p > |t|'))
                        .join(ts.conf_int().rename({0 : 'lcl',1 : 'ucl'}, axis = 1))
                        .join(ts.bse.rename('se'))
            )



# Capture Information Criterion
# TODO: Export for report
ts.ics = pd.DataFrame({
        'AIC' : [ts.aic]
        ,'BIC' : [ts.bic]
        ,'Durbin-Watson' : sm.stats.durbin_watson(ts.resid.values)
        }).squeeze()

# Check normality of ts residuals
stats.normaltest(ts.resid)

# Plot AR qqplot
# FIXME: Format
fig = plt.figure(figsize=(12,8))
ax = fig.add_subplot(111)
fig = sm.graphics.qqplot(ts.resid, line='q', ax=ax, fit=True)
fig.savefig('figs/p2-4c_tsa_qqplot.png')

# Plot AR residuals
# FIXME: Format
fig = plt.figure(figsize=(12,8))
ax = fig.add_subplot(111)
ax = ts.resid.plot(ax=ax)
fig.savefig('figs/p2-4c_tsa_resid.png')

# Plot AR Residuals
# FIXME: Format
fig = plt.figure(figsize=(12,8))
ax1 = fig.add_subplot(211)
fig = sm.graphics.tsa.plot_acf(ts.resid, lags=40, ax=ax1)
ax2 = fig.add_subplot(212)
fig = sm.graphics.tsa.plot_pacf(ts.resid, lags=40, ax=ax2)
fig.savefig('figs/p2-4c_tsa_acf+pacf.png')

##? Part d
# doc: http://www.statsmodels.org/stable/generated/statsmodels.tsa.ar_model.AR.predict.html#statsmodels.tsa.ar_model.AR.predict


#? Forecast residuals using OLS
p_start = pd.Timestamp(year = 2015, month = 6, day = 30, freq = 'M')
p_end = pd.Timestamp(year = 2016, month = 8, day = 31) #pd.Timestamp(year = 2016, month = 6, day = 30, freq = 'M')
d_start = subtrain.index.min()

# Define interval to predict
# TODO: Make this less convoluted
p_range = list(range(subtrain.month_number.max(), subtrain.month_number.max() + 12))
p_dt_range = pd.date_range(subtrain.index.max() + 1, periods=12, freq='M')
pred_range = pd.DataFrame(p_range).rename({0 : 'month_number'}, axis = 1)
p_dt_range = pd.DataFrame(p_dt_range).join(pred_range).set_index(0)

# In-sample prediction
p_in = ts.predict() # offset by number of auto regressors

# Out-of-sample prediction
p_out = ts.predict(start = p_start, end = p_end)

# Stack prediction sets together for plotting
predX = np.hstack((X, pred_range.month_number.values))
predY = np.hstack((p_in, p_out))


# Plot OLS predictions
# FIXME: Format
fig = plt.figure()
fig = sns.scatterplot(X, R, label="Data")
fig = sns.lineplot(predX, predY, label="OLS prediction", color = 'red')
fig.savefig('figs/p2-4d_ols_predict.png')


#? Forecast residuals using ARMA (for fun?)
arma = sm.tsa.ARMA(subtrain.resid, (4,0), dates = subtrain.index).fit(maxlag = 3)

# FIXME: Format
fig, (ax1, ax2) = plt.subplots(2, sharex=False, sharey=False, figsize=(24,16))
ax1 = subtrain.resid.loc[d_start:].plot(ax=ax1)
ax1 = arma.plot_predict(p_start, p_end, dynamic=True, ax=ax1)
ax2 = arma.plot_predict(p_start, p_end, dynamic=True, ax=ax2)
fig.savefig('figs/p2-4d_arma_predict.png')

#! Problem 5


#? Forecast price using OLS
# Define forecast interval bounds
p_start = pd.Timestamp(year = 2015, month = 7, day = 31)
p_end = pd.Timestamp(year = 2016, month = 6, day = 30)

# Capture mean predictions
# TODO: Refactor
in_means = reg.get_prediction().summary_frame(alpha = 0.05).drop('mean_se', axis = 1)['mean']
pred_means = reg.get_prediction(pred_range).summary_frame(alpha = 0.05).drop('mean_se', axis = 1)['mean']

# In-sample prediction
p_in = reg.predict(subtrain.month_number).values

# Out-of-sample prediction
p_out = ts.predict(start = p_start, end = p_end)

# Stack prediction sets for plotting
predX = np.hstack((X, pred_range.month_number.values))
predY = np.hstack((p_in, p_out))

# Plot predict prices for ols predicted mean and AR predicted residuals
# FIXME: This section is hacked together. Use reg.get_prediciton output instead and fix plots.
fig, ax = plt.subplots()
ax.plot(X, Y, 'o', label="Data")
ax.plot(X, in_means.values, 'r', label="OLS prediction")
ax.plot(pred_range.month_number.values, pred_means.values+p_out.values, 'g', label="OLS prediction")
ax.legend(loc="best")
fig.savefig('figs/p2-5d_ar_predict.png')


# TODO: Refactor -> This is duplicated from above
in_means = reg.get_prediction().summary_frame(alpha = 0.05)
out_means = reg.get_prediction(p_dt_range).summary_frame(alpha = 0.05).join(p_dt_range.reset_index()).set_index(0)
pred = pd.concat([in_means, out_means]).drop('month_number', axis = 1)


# Plot predictions with CIs
# TODO: Finish this plot
pred[['mean','mean_ci_lower', 'mean_ci_upper']].plot()

# TODO: Refactor -> More duplication in an effort to hack it.
pred2 = pred[['mean','mean_ci_lower', 'mean_ci_upper']].astype('float')
pred2.index = pd.to_datetime(pred2.index).rename('timestamp')

# FIXME: Format
# TODO: Finish this plot
sns.tsplot([pred2.mean_ci_lower, pred2.mean_ci_upper, pred2['mean']])#, err_style="ci_bars", interpolate=False)
# TODO: Save plot


# Save data for submission
pred.round(0).to_csv('data/p2preds.csv')

#? Forecast price using ARMA (for fun?)
p = ts.predict(start = p_start, end = p_end)

# Arma Model for prediction
arma = sm.tsa.ARMA(subtrain.price_doc, (4,0), dates = subtrain.index).fit(maxlag = 3)

# FIXME: Format
# TODO: Finish this plot
f, (ax1, ax2) = plt.subplots(2, sharex=False, sharey=False, figsize=(24,16))
ax1 = subtrain.price_doc.loc[d_start:].plot(ax=ax1)
ax1 = arma.plot_predict(p_start, p_end, dynamic=True, ax=ax1, alpha = 0.05)
ax2 = arma.plot_predict(p_start, p_end, dynamic=True, ax=ax2, alpha = 0.05)
# TODO: Save plot




# sm.tsa.ARMA.fit.__dir__()


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
















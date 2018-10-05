
import pandas as pd
from math import sqrt, log
from IPython.display import display
from IPython.display import HTML
from IPython.display import IFrame
from scipy import stats
import plotly.plotly as py
import plotly.graph_objs as go
import cufflinks as cf
import plotly
import numpy as np
from pprint import pprint
import plotly.offline as offline
import plotly.tools as tls


pd.options.display.float_format = '{:.2f}'.format

train = pd.read_csv('data/train.csv')

tdesc = train.describe()

help(tdesc)

tdesc.T.to_html('src/report_graphics/html/tdesc.html')


train.select_dtypes(include=np.number).aggregate([np.mean, np.median, np.min, np.max, np.var, np.std]).T

train.plot.box()























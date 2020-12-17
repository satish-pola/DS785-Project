import pandas as pd
from functools import reduce
import numpy as np
import os


desired_width=320
pd.set_option('display.width', desired_width)
np.set_printoptions(linewidth=desired_width)
pd.set_option('display.max_columns',10)

directory="/Users/satishkumarpola/Documents/DS/project_data/DS785-Project/data_clean"
os.chdir(directory)


ts_recovered_global = pd.read_csv("time_series_covid19_recovered_global.csv")
ts_deaths_global = pd.read_csv("time_series_covid19_deaths_global.csv")
ts_confirmed_global = pd.read_csv("time_series_covid19_confirmed_global.csv")

ts_recovered_global = ts_recovered_global.drop(columns=["Province/State","Lat","Long"])

dates = ['1/22/20','1/23/20','1/24/20','1/25/20','1/26/20','1/27/20','1/28/20','1/29/20','1/30/20','1/31/20',
         '2/1/20','2/2/20','2/3/20','2/4/20','2/5/20','2/6/20','2/7/20','2/8/20','2/9/20','2/10/20','2/11/20','2/12/20','2/13/20','2/14/20','2/15/20','2/16/20','2/17/20','2/18/20','2/19/20','2/20/20','2/21/20','2/22/20','2/23/20','2/24/20','2/25/20','2/26/20','2/27/20','2/28/20','2/29/20',
         '3/1/20','3/2/20','3/3/20','3/4/20','3/5/20','3/6/20','3/7/20','3/8/20','3/9/20','3/10/20','3/11/20','3/12/20','3/13/20','3/14/20','3/15/20','3/16/20','3/17/20','3/18/20','3/19/20','3/20/20','3/21/20','3/22/20','3/23/20','3/24/20','3/25/20','3/26/20','3/27/20','3/28/20','3/29/20','3/30/20','3/31/20',
         '4/1/20','4/2/20','4/3/20','4/4/20','4/5/20','4/6/20','4/7/20','4/8/20','4/9/20','4/10/20','4/11/20','4/12/20','4/13/20','4/14/20','4/15/20','4/16/20','4/17/20','4/18/20','4/19/20','4/20/20','4/21/20','4/22/20','4/23/20','4/24/20','4/25/20','4/26/20','4/27/20','4/28/20','4/29/20','4/30/20',
         '5/1/20','5/2/20','5/3/20','5/4/20','5/5/20','5/6/20','5/7/20','5/8/20','5/9/20','5/10/20','5/11/20','5/12/20','5/13/20','5/14/20','5/15/20','5/16/20','5/17/20','5/18/20','5/19/20','5/20/20','5/21/20','5/22/20','5/23/20','5/24/20','5/25/20','5/26/20','5/27/20','5/28/20','5/29/20','5/30/20','5/31/20',
         '6/1/20','6/2/20','6/3/20','6/4/20','6/5/20','6/6/20','6/7/20','6/8/20','6/9/20','6/10/20','6/11/20','6/12/20','6/13/20','6/14/20','6/15/20','6/16/20','6/17/20','6/18/20','6/19/20','6/20/20','6/21/20','6/22/20','6/23/20','6/24/20','6/25/20','6/26/20','6/27/20','6/28/20','6/29/20','6/30/20',
         '7/1/20','7/2/20','7/3/20','7/4/20','7/5/20','7/6/20','7/7/20','7/8/20','7/9/20','7/10/20','7/11/20','7/12/20','7/13/20','7/14/20','7/15/20','7/16/20','7/17/20','7/18/20','7/19/20','7/20/20','7/21/20','7/22/20','7/23/20','7/24/20','7/25/20','7/26/20','7/27/20','7/28/20','7/29/20','7/30/20','7/31/20',
         '8/1/20','8/2/20','8/3/20','8/4/20','8/5/20','8/6/20','8/7/20','8/8/20','8/9/20','8/10/20','8/11/20','8/12/20','8/13/20','8/14/20','8/15/20','8/16/20','8/17/20','8/18/20','8/19/20','8/20/20','8/21/20','8/22/20','8/23/20','8/24/20','8/25/20','8/26/20','8/27/20','8/28/20','8/29/20','8/30/20','8/31/20',
         '9/1/20','9/2/20','9/3/20','9/4/20','9/5/20','9/6/20','9/7/20','9/8/20','9/9/20','9/10/20','9/11/20','9/12/20','9/13/20','9/14/20','9/15/20','9/16/20','9/17/20','9/18/20','9/19/20','9/20/20','9/21/20','9/22/20','9/23/20','9/24/20','9/25/20','9/26/20','9/27/20','9/28/20','9/29/20','9/30/20',
         '10/1/20','10/2/20','10/3/20','10/4/20','10/5/20','10/6/20','10/7/20','10/8/20','10/9/20','10/10/20','10/11/20','10/12/20','10/13/20','10/14/20','10/15/20','10/16/20','10/17/20','10/18/20','10/19/20','10/20/20','10/21/20','10/22/20','10/23/20','10/24/20','10/25/20','10/26/20','10/27/20','10/28/20','10/29/20','10/30/20','10/31/20',
         '11/1/20','11/2/20','11/3/20','11/4/20','11/5/20','11/6/20','11/7/20','11/8/20','11/9/20','11/10/20','11/11/20','11/12/20','11/13/20','11/14/20','11/15/20','11/16/20','11/17/20','11/18/20','11/19/20','11/20/20','11/21/20','11/22/20','11/23/20','11/24/20','11/25/20','11/26/20','11/27/20','11/28/20','11/29/20','11/30/20',
         '12/1/20','12/2/20','12/3/20','12/4/20','12/5/20','12/6/20','12/7/20','12/8/20','12/9/20','12/10/20','12/11/20','12/12/20']
cols = ["Country/Region"]
ts_recovered_global = pd.melt(ts_recovered_global, id_vars=cols, value_vars=dates)
ts_recovered_global.rename(columns={'variable': 'report_date', 'value': 'recovered'}, inplace=True)
ts_recovered_global1 = ts_recovered_global.groupby(["report_date","Country/Region"])['recovered'].sum().reset_index()


ts_deaths_global = pd.melt(ts_deaths_global, id_vars=cols, value_vars=dates)
ts_deaths_global.rename(columns={'variable': 'report_date', 'value': 'deaths'}, inplace=True)
ts_deaths_global1 = ts_deaths_global.groupby(["report_date","Country/Region"])['deaths'].sum().reset_index()


ts_confirmed_global = pd.melt(ts_confirmed_global, id_vars=cols, value_vars=dates)
ts_confirmed_global.rename(columns={'variable': 'report_date', 'value': 'confirmed'}, inplace=True)
ts_confirmed_global1 = ts_confirmed_global.groupby(["Country/Region","report_date"]).sum().reset_index()


new_df = pd.merge(ts_confirmed_global1, ts_recovered_global1,  how='inner', on=["Country/Region","report_date"])
new_df1 = pd.merge(new_df, ts_deaths_global1,  how='inner', on=["Country/Region","report_date"])


new_df1["report_date"]=new_df1["report_date"].apply(lambda x: pd.to_datetime(x).strftime('%Y-%m-%d'))
#print(new_df1.sort_values(by=['Country/Region','report_date']))
# #
new_df2 = new_df1.sort_values(by=['report_date','Country/Region'])
new_df2.rename(columns={'Country/Region':'country'}, inplace=True)
print(new_df2)
new_df2.to_csv(r'global_covid_data_cleaned.csv', index=False)


##Generate .sql file.
with open('global_covid_data_cleaned.sql', 'w') as f:
    for index, row in new_df2.iterrows():
        f.write('insert into global_covid_cases (`country`,`report_date`,`confirmed`,`recovered`,`deaths`)'
                ' values ("{}","{}",{},{},{});\n'.format(row['country'],row['report_date'],row['confirmed'],row['recovered'],row['deaths']))
f.close()

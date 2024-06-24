# -*- coding: utf-8 -*-
"""
Created on Thu May 11 13:57:16 2023

@author: mcook49
"""
import pandas as pd, os, re, numpy as np
import matplotlib.pyplot as plt
import scipy.stats as stats
path = 'C:\\Users\\mcook49\\Documents\\Mini_Crossword_Times.csv'

df=pd.read_csv(path)

#Filter to year
df = df[df.Date.str.contains('2024')]

x_axis = np.arange(0, 200, .001)

#Drop days where all 3 missed
df.dropna(subset =['Kevin_Time_Seconds','Ivan_Time_Seconds','Michael_Time_Seconds'], thresh = 1, inplace = True)

#Date
today = df[-1:].reset_index(drop = True).iloc[0]['Date']
text = "Stats for {}\n".format(today)
print(text)

#Overall avg
avg_all = 0

#Kevin
mean = df.Kevin_Time_Seconds.mean()
avg_all += mean #Add to overall avg
std = df.Kevin_Time_Seconds.std()
med = df.Kevin_Time_Seconds.median()
min = df.Kevin_Time_Seconds.min()
pct_60 = (len(df[df['Kevin_Time_Seconds'] < 60])/len(df[~df['Kevin_Time_Seconds'].isna()]))*100
text = "Kevin: \nMean: {}\nStandard Deviation: {}\nMedian: {}\nPercent under 60 seconds: {}%\nPersonal Best: {}\n".format(round(mean,2),round(std,2),med,round(pct_60,2),min)
print(text)
plt.plot(x_axis, stats.norm.pdf(x_axis,mean,std))
plt.show()

mean = df.Ivan_Time_Seconds.mean()
avg_all += mean #Add to overall avg
std = df.Ivan_Time_Seconds.std()
med = df.Ivan_Time_Seconds.median()
min = df.Ivan_Time_Seconds.min()
pct_60 = (len(df[df['Ivan_Time_Seconds'] < 60])/len(df[~df['Ivan_Time_Seconds'].isna()]))*100
text = "Ivan: \nMean: {}\nStandard Deviation: {}\nMedian: {}\nPercent under 60 seconds: {}%\nPersonal Best: {}\n".format(round(mean,2),round(std,2),med,round(pct_60,2),min)
print(text)
plt.plot(x_axis, stats.norm.pdf(x_axis,mean,std))
plt.show()

mean = df.Michael_Time_Seconds.mean()
avg_all += mean #Add to overall avg
std = df.Michael_Time_Seconds.std()
med = df.Michael_Time_Seconds.median()
min = df.Michael_Time_Seconds.min()
pct_60 = (len(df[df['Michael_Time_Seconds'] < 60])/len(df[~df['Michael_Time_Seconds'].isna()]))*100
text = "Michael: \nMean: {}\nStandard Deviation: {}\nMedian: {}\nPercent under 60 seconds: {}%\nPersonal Best: {}\n".format(round(mean,2),round(std,2),med,round(pct_60,2),min)
print(text)
plt.plot(x_axis, stats.norm.pdf(x_axis,mean,std))
plt.show()

#Overall avg
avg_all = avg_all/3
text = "Combined average for all three is: {} seconds\n".format(round(avg_all,2))
print(text)

#Get days with lowest and highest totals
df['total_time'] = 0 #reset values if needed
df['total_time'] = df.sum(axis=1, skipna=True)
df2 = df.dropna(thresh = 3) #Remove days all three missed
df2.dropna(subset =['Kevin_Time_Seconds','Ivan_Time_Seconds','Michael_Time_Seconds'], thresh = 2, inplace = True) #Drop days where two missed
df3 = df2[df2.isnull().any(axis=1)]
max_time = df3.sort_values(by = 'total_time',ascending = False).reset_index(drop = True).iloc[0]
min_time = df3.sort_values(by = 'total_time').reset_index(drop = True).iloc[0]

#Just two
long_date = max_time['Date']
long_time = max_time['total_time']
text = "Hardest day for just two of us was {}, with a total time of {} seconds.\n".format(long_date,int(long_time))
print(text)

short_date = min_time['Date']
short_time = min_time['total_time']
text = "Easiest day for just two of us was {}, with a total time of {} seconds.\n".format(short_date,int(short_time))
print(text)


#All three

df2.dropna(inplace = True) #Drop days where two missed
max_time = df2.sort_values(by = 'total_time',ascending = False).reset_index(drop = True).iloc[0]
min_time = df2.sort_values(by = 'total_time').reset_index(drop = True).iloc[0]

long_date = max_time['Date']
long_time = max_time['total_time']
text = "Hardest day for all three was {}, with a total time of {} seconds.\n".format(long_date,int(long_time))
print(text)

short_date = min_time['Date']
short_time = min_time['total_time']
text = "Easiest day for all three was {}, with a total time of {} seconds.\n".format(short_date,int(short_time))
print(text)

#Stats for just last week only? 
week = df.iloc[-7:]
week['play_count'] = (week.count(axis=1)) - 2
total_time = week.total_time.sum()
weekly_avg = total_time / week.play_count.sum()
text = "Total time played this week was {} seconds\nCombined average for this week was {} seconds.\n".format(round(total_time,2),round(weekly_avg,2))
print(text)

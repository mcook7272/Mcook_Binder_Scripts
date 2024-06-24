# -*- coding: utf-8 -*-
"""
Created on Tue Nov 28 09:13:59 2023

@author: mcook49
"""
CLIENT_ID = 'dARmLsT8XvGPudnKf2b_jg'
SECRET_KEY = 'nqo00raPRYgLbUstM-M5RT7hcaXGNA'

#Load in pw
with open('C:/Users/mcook49/AppData/Local/Programs/Python/pw.txt', 'r') as f:
    pw = f.read()
 
#Request auth token
import requests
auth = requests.auth.HTTPBasicAuth(CLIENT_ID, SECRET_KEY)
data = {
        'grant_type': 'password',
        'username': 'mcook5',
        'password': pw
        }
headers = {'User-Agent': 'MyAPI/0.0.1'}
res = requests.post('https://www.reddit.com/api/v1/access_token',auth =auth,data = data, headers = headers)
TOKEN = res.json()['access_token']
headers['Authorization'] = f'bearer {TOKEN}' 

#test
requests.get('https://oauth.reddit.com/api/v1/me', headers = headers).json()

#Access subreddit
res = requests.get('https://oauth.reddit.com/r/python/hot',headers = headers)
for post in res.json()['data']['children']:
    #print(post['data']['url'])
    print(post['data']['title'])
    #print(post['data']['flair'])
    
#Get data into df
import pandas as pd
df = pd.DataFrame()    
for post in res.json()['data']['children']:
    df = df.append({
        'subreddit': post['data']['subreddit'],
        'title': post['data']['title'],
        'url': post['data']['url'],
        'selftext': post['data']['selftext'],
        'link_flair_text': post['data']['link_flair_text'],
        },ignore_index = True)

#potential data
post['data'].keys()
post['kind'] +'_' + post['data']['id'] #full_name

#Access subreddit tipofmyotngue
res = requests.get('https://oauth.reddit.com/r/tipofmytongue/new',headers = headers,params = {'limit': '100', 'after': 't3_185rwar'})
for post in res.json()['data']['children']:
    #print(post['data']['url'])
    print(post['data']['title'])
    #print(post['data']['flair'])
    
#Get data into df
import pandas as pd
df = pd.DataFrame()    
for post in res.json()['data']['children']:
    df = df.append({
        'subreddit': post['data']['subreddit'],
        'title': post['data']['title'],
        'url': post['data']['url'],
        'selftext': post['data']['selftext'],
        'link_flair_text': post['data']['link_flair_text'],
        },ignore_index = True)

#praw?

import sys

# Add the new location to sys.path
new_location = r'C:\users\mcook49\appdata\local\programs\python\python38-32\lib\site-packages'
sys.path.append(new_location)

# Now you can import modules from the new location
import praw
from datetime import datetime, timedelta


# Replace these values with your own Reddit API credentials
reddit_client_id = CLIENT_ID
reddit_client_secret = SECRET_KEY
reddit_username = 'mcook5'
reddit_password = pw

# Set up the Reddit API connection
reddit = praw.Reddit(
    client_id=reddit_client_id,
    client_secret=reddit_client_secret,
    username=reddit_username,
    password=reddit_password,
    user_agent='python:MyAPI/0.0.1 (by /u/mcook5)'
)

# Define the subreddit and the desired flair
subreddit_name = 'tipofmytongue'
desired_flair = 'Solved'

# Get the subreddit
subreddit = reddit.subreddit(subreddit_name)

# Calculate the timestamp for 6 months ago
six_months_ago = datetime.utcnow() - timedelta(days=180)
timestamp_six_months_ago = int(six_months_ago.timestamp())

# Fetch all posts with the specified flair for the past 6 months
posts = subreddit.search(f'flair:{desired_flair}', time_filter='all', sort='new', limit = 200)

# Print information about each post
import pandas as pd
df = pd.DataFrame()    
for post in posts:
    # Check if the post is older than 6 months
    if post.created_utc < timestamp_six_months_ago:
        break
    df = df.append({
        'subreddit': 'tipofmytongue',
        'date': datetime.utcfromtimestamp(post.created_utc),
        'title': post.title,
        'url': post.url,
        'selftext': post.selftext[:50],
        'link_flair_text': post.link_flair_text,
        },ignore_index = True)

df.to_excel(r'C:\\Users\mcook49\Documents\reddit_API_data.xlsx', index = False)

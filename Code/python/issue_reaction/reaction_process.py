import pandas as pd
import numpy as np
import datetime
from datetime import timedelta
from datetime import date
from multiprocessing.pool import ThreadPool
from functools import partial
from tqdm import tqdm as tqdm
import os


def combine_reaction(reaction_file, reaction_dir, post_data, user_type):

    df_list = []
    ind = True
    for path in reaction_dir:    
	    try:
            df = pd.read_csv(f'{path}{reaction_file}', converters={'user_id': str})
            df_list.append(df)
	    except:
            ind = False
            break
        
    if ind:
        df = pd.concat(df_list, axis=0) 
    df = pd.merge(df, post_data, on='post_id', how='inner')
    df = pd.merge(df, user_type, on='user_id', how='inner')
    
    return df

def main():

    reaction_dir = ['/home3/usfb/analysis/analysis-YiWenC/input/reaction/1000-page/2015-01-01-to-2016-11-30/us-political-user/by-reaction-type/LIKE/by-post-date/', '/home3/usfb/analysis/analysis-YiWenC/input/reaction/politician/2015-05-01-to-2016-11-30/us-political-user/by-reaction-type/LIKE/by-post-date/']
    file_list = [f for f in os.listdir(reaction_dir[0]) if f >= '2015-05-03']
    df_list = []
    imm = pd.read_csv('/home3/r05322021/Desktop/FB Data/issue_post/immigration.csv', usecols=['page_id', 'page_name', 'post_id', 'post_reactions', 'post_likes', 'post_created_date_CT'])
    imm['post_type'] = 'immigration'
    race = pd.read_csv('/home3/r05322021/Desktop/FB Data/issue_post/race.csv', usecols=['page_id', 'page_name', 'post_id', 'post_reactions', 'post_likes', 'post_created_date_CT'])
    race['post_type'] = 'race'
    issue = pd.concat([imm, race], axis=0)
    issue = issue.drop_duplicates(subset=['post_id'])
    user_type = pd.read_csv('/home3/r05322021/Desktop/FB Data/user_type/user_type.csv', converters={'user_id': str})
    df_list = []

    if __name__ == '__main__':
        with ThreadPool(processes=9) as pool:
            for _, x in enumerate(tqdm(pool.imap_unordered(partial(combine_reaction, 
                reaction_dir=reaction_dir, post_data=issue, user_type=user_type), file_list),
                total=len(file_list)), 1):
                df_list.append(x)

    df = pd.concat(df_list, axis=0)
    df.to_csv('/home3/r05322021/Desktop/FB Data/issue_reaction/reaction_type')
                

    
if __name__ == '__main__':
    main()

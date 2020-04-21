##Calculate ideology_difference using distance between Trump and Clinton
import numpy as np 
import pandas as pd 
import os
from multiprocessing import Pool
from functools import partial
from tqdm import tqdm as tqdm
import pydata_google_auth
import pandas_gbq as gbq

def bigquery_auth():
    SCOPES = [
    'https://www.googleapis.com/auth/cloud-platform',
    'https://www.googleapis.com/auth/drive',]
    
    credentials = pydata_google_auth.get_user_credentials(
    SCOPES,
    # Set auth_local_webserver to True to have a slightly more convienient
    # authorization flow. Note, this doesn't work if you're running from a
    # notebook on a remote sever, such as over SSH or with Google Colab.
    auth_local_webserver=True,)

def find_match_candidate_ideology(user_file, page_dir, page_head):

	date = user_file[-28:]
	page_file = f'{page_dir}{page_head}{date}'

	page_df = pd.read_csv(page_file, usecols = ["page_id", "PC1_std"])
	trump = page_df[page_df.page_id == 153080620724]["PC1_std"].iloc[0]
	clinton = page_df[page_df.page_id == 889307941125736]["PC1_std"].iloc[0]

	return trump, clinton

def return_statistics(df):

	polarization_mean = df[df.partisan == 'Trump']['user_PC1_mean_weighted'].mean() - df[df.partisan == 'Clinton']['user_PC1_mean_weighted'].mean()
	polarization_median = df[df.partisan == 'Trump']['user_PC1_mean_weighted'].median() - df[df.partisan == 'Clinton']['user_PC1_mean_weighted'].median()
	total = len(df)
	trump_share = len(df[df.partisan == 'Trump'])/len(df)
	clinton_share = 1 - trump_share
	if 'state' not in df.columns:
		state = 'whole'
	else:
		state = df['state'].iloc[0]

	return [state, polarization_mean, polarization_median, total, trump_share, clinton_share]

def Calculate_difference(user_file, user_dir, page_dir, page_head, state_df):

	trump, clinton = find_match_candidate_ideology(user_file, page_dir, page_head)
	date = user_file[-14:-4]
	user_df = pd.read_csv(f'{user_dir}{user_file}', usecols = ["user_id", "user_PC1_mean"], converters={'user_id': str})
	user_df['partisan'] = user_df['user_PC1_mean'].apply(lambda x: 'Trump' if abs(x - trump) < abs(x - clinton) else 'Clinton')
	state = pd.merge(user_df, state_df, how='inner', on='user_id')

	state_list = [group[1] for group in df.groupby(df['state'])]
	df_list = state_list + ['user_df']
	result_list = []
	
	for df in df_list:
		result = return_statistics(df)
		result.append(result)

	result_df = pd.DataFrame(np.stack(result_list), columns=['state', 'polarization_mean', 'polarization_median', 'total', 'trump_share', 'clinton_share'])

	return [result_df, date]
	result_df.to_csv(f'{save_dir}ideology_state_{date}.csv', index=False)

def main():
	user_path = "/home3/r05322021/Desktop/FB Data/user_score/2015-05-03_to_2016-11-26_4weeks/"
	user_file_list = os.listdir(user_path)
	page_path = "/home3/r05322021/Desktop/FB Data/page_score/2015-05-03_to_2016-11-26_4weeks/"
	page_head = 'page_ideology_score_4_weeks'
	
	bigquery_auth()
	state_query = '''
	SELECT user_id,
			state
	FROM `us_user_info.user_like_state_max_exclude_primary`
	'''
	state_df = gbq.read_gbq(state_query, project_id='ntufbdata')
	save_dir = '/home3/r05322021/Desktop/FB Data/Polarization/'

	if __name__ == '__main__':
    		with Pool(processes=24) as pool:
			for _, x in enumerate(tqdm(pool.imap_unordered(partial(Calculate_difference, user_dir=user_path, page_dir=page_path, page_head=page_head, state_df=state_df), user_file_list), total=len(user_file_list)), 1):
				x[0].to_csv(f'{save_dir}ideology_state_{x[1]}.csv', index=False)
		

if __name__ == '__main__':
    main()

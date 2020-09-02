##Calculate ideology_difference using distance between Trump and Clinton
import numpy as np 
import pandas as pd 
import os
from multiprocessing import Pool
from functools import partial
from tqdm import tqdm as tqdm
import pydata_google_auth
import pandas_gbq as gbq
import sys

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

def find_match_candidate_ideology(file_name, input_path, user_type):

	page_file = f'{input_path}page_score/{user_type}/{file_name}'

	page_df = pd.read_csv(page_file, usecols = ["page_id", "PC1_std"])
	trump = page_df[page_df.page_id == 153080620724]["PC1_std"].iloc[0]
	clinton = page_df[page_df.page_id == 889307941125736]["PC1_std"].iloc[0]

	return trump, clinton

def return_statistics(df, total_mean, total_std):

	polarization_mean = df[df.partisan == 'Trump']['user_PC1_mean_weighted'].mean() - df[df.partisan == 'Clinton']['user_PC1_mean_weighted'].mean()
	polarization_median = df[df.partisan == 'Trump']['user_PC1_mean_weighted'].median() - df[df.partisan == 'Clinton']['user_PC1_mean_weighted'].median()
	total = len(df)
	trump_share = len(df[df.partisan == 'Trump'])/len(df)
	clinton_share = 1 - trump_share
	ideology_mean = df.user_PC1_mean_weighted.mean()
	ideology_std = df.user_PC1_mean_weighted.std()
	extreme_right_abs = len(df[df.user_PC1_mean_weighted > 1])/total
	extreme_left_abs = len(df[df.user_PC1_mean_weighted < -1])/total
	extreme_right_std = len(df[df.user_PC1_mean_weighted > (total_mean + total_std)])/total
	extreme_left_std = len(df[df.user_PC1_mean_weighted < (total_mean - total_std)])/total
	extreme_right_2std = len(df[df.user_PC1_mean_weighted > (total_mean + 2*total_std)])/total
	extreme_left_2std = len(df[df.user_PC1_mean_weighted < (total_mean - 2*total_std)])/total
	if 'state' not in df.columns:
		state = 'whole'
	else:
		state = df['state'].iloc[0]

	return [state, ideology_mean, ideology_std, polarization_mean, polarization_median, total, trump_share, clinton_share, extreme_right_abs, extreme_left_abs, extreme_right_std, extreme_left_std, extreme_right_2std, extreme_left_2std]

def Calculate_difference(file_name, input_path, user_type, state_df):

	trump, clinton = find_match_candidate_ideology(file_name, input_path, user_type)
	date = file_name
	if user_type != 'whole':
		type_df = pd.read_csv(f'{input_path}user_like_page/{user_type}/{file_name}', usecols=['user_id', 'TYPE'], converters={'user_id': str})
		user_df = pd.read_csv(f'{input_path}user_score/{user_type}/{file_name}', usecols = ["user_id", "user_PC1_mean_weighted"], converters={'user_id': str})
		user_df['partisan'] = user_df['user_PC1_mean_weighted'].apply(lambda x: 'Trump' if abs(x - trump) < abs(x - clinton) else 'Clinton')
		user_df = pd.merge(user_df, type_df, how='inner', on='user_id')
		type_list = [group[1] for group in user_df.groupby(by='TYPE')] + [user_df]
		result_df_list = []
		for df in type_list:
			total_mean = df.user_PC1_mean_weighted.mean()
			total_std = df.user_PC1_mean_weighted.std()
			state = pd.merge(df, state_df, how='inner', on='user_id')

			state_list = [group[1] for group in state.groupby(state['state'])]
			df_list = state_list + [df]
			result_list = []
	
			for d in df_list:
				result = return_statistics(d, total_mean, total_std)
				result_list.append(result)

			result_df = pd.DataFrame(np.stack(result_list), columns=['state', 'ideology_mean', 'ideology_std', 'polarization_mean', 'polarization_median', 'total', 'trump_share', 'clinton_share', 'extreme_right_abs', 'extreme_left_abs', 'extreme_right_std', 'extreme_left_std', 'extreme_right_2std', 'extreme_left_2std'])
			if len(df.TYPE.unique()) == 1:
				result_df['type'] = df.TYPE.unique()[0]
			else:
				result_df['type'] = 'all'

			result_df_list.append(result_df)

		result_df = pd.concat(result_df_list, axis=0)
			
	
	else:
		user_df = pd.read_csv(f'{input_path}user_score/{user_type}/{file_name}', usecols = ["user_id", "user_PC1_mean_weighted"], converters={'user_id': str})

		user_df['partisan'] = user_df['user_PC1_mean_weighted'].apply(lambda x: 'Trump' if abs(x - trump) < abs(x - clinton) else 'Clinton')
	
		total_mean = user_df.user_PC1_mean_weighted.mean()
		total_std = user_df.user_PC1_mean_weighted.std()
		state = pd.merge(user_df, state_df, how='inner', on='user_id')

		state_list = [group[1] for group in state.groupby(state['state'])]
		df_list = state_list + [user_df]
		result_list = []
	
		for df in df_list:
			result = return_statistics(df, total_mean, total_std)
			result_list.append(result)

		result_df = pd.DataFrame(np.stack(result_list), columns=['state', 'ideology_mean', 'ideology_std', 'polarization_mean', 'polarization_median', 'total', 'trump_share', 'clinton_share', 'extreme_right_abs', 'extreme_left_abs', 'extreme_right_std', 'extreme_left_std', 'extreme_right_2std', 'extreme_left_2std'])

	return [result_df, date]

def main(user_type):
	input_path = "/home3/r05322021/Desktop/FB Data/Polarization/"
	user_file_list = os.listdir(f'{input_path}user_score/{user_type}')
	
	#bigquery_auth()
	#state_query = '''
	#SELECT user_id,
			#state
	#FROM `us_user_info.user_like_state_max_exclude_primary_all`
	#'''
	#state_df = gbq.read_gbq(state_query, project_id='ntufbdata')
	#state_df.to_csv('/home3/r05322021/Desktop/FB Data/user_state/user_state_all.csv', index=False)
	state_df = pd.read_csv('/home3/r05322021/Desktop/FB Data/information/user_state_info.csv', converters={'user_id': str})
	save_dir = f'/home3/r05322021/Desktop/FB Data/Polarization/state/{user_type}/'

	if __name__ == '__main__':
		with Pool(processes=10) as pool:
			for _, x in enumerate(tqdm(pool.imap_unordered(partial(Calculate_difference, input_path=input_path, user_type=user_type, state_df=state_df), user_file_list), total=len(user_file_list)), 1):
				x[0].to_csv(f'{save_dir}ideology_state_{x[1]}', index=False)
		

if __name__ == '__main__':
    user_type = sys.argv[1]
    main(user_type)

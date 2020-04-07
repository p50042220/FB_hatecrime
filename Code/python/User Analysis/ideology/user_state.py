import pandas as pd 
import os
from tqdm import *

data_path = "/home3/r05322021/Desktop/FB Data/user_score/2015-05-03_to_2016-11-26_4weeks/"
output_path = "/home3/r05322021/Desktop/FB Data/user_score/user_score_with_state/"
data_list = os.listdir(data_path)
state = pd.read_csv("/home3/usfb/analysis/analysis-ideology-change/temp/user-state/us_user_like_state_max_unique.csv", converters = {"user_id": str })


for i ,file in enumerate(data_list):
	print("Start doing data " + str(i + 1))
	filename = data_path + file
	df = pd.read_csv(filename, converters = {"user_id": str })
	data = pd.merge(df, state, how = "inner", on = "user_id")
	date = file[30:55]
	data.to_csv(output_path + date + ".csv")
	print(str(i + 1) + " Data Done")

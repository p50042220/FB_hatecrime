import pandas as pd 
import os
from tqdm import *
import datetime
from datetime import timedelta
from datetime import datetime

data_path = "/home3/r05322021/Desktop/FB Data/Clinton_fans/"
ideology_path = "/home3/r05322021/Desktop/FB Data/user_score/2015-05-03_to_2016-11-26_4weeks/"
data_list = os.listdir(data_path)
ideology_list = os.listdir(ideology_path)
df_list = []

for i ,file in enumerate(data_list):
	if file[-3:] != "csv":
		continue

	filename = data_path + file
	print("Start doing data " + str(i + 1))
	df = pd.read_csv(filename, converters = {"user_id": str })
	df = df.drop_duplicates(subset = "user_id").reset_index(drop = True)
	date = datetime.strptime(file[0:4] + "-" + file[4:6] + "-" + file[6:8], "%Y-%m-%d")
	print(date)
	for j, file2 in enumerate(ideology_list):
		date2 = datetime.strptime(file2[30:40], "%Y-%m-%d")
		diff = date - date2
		if diff.days == 2:
			ideology_file = ideology_path + file2
			break
	print(date2)
	ideology = pd.read_csv(ideology_file, converters = {"user_id": str })
	data = pd.merge(df, ideology, how = "inner", on = "user_id")
	data.to_csv(data_path + "ideology/ideology_" + file, index = False)
	print(str(i + 1) + " Data Done")


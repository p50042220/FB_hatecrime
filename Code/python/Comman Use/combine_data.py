import pandas as pd 
import os

path = "/home3/r05322021/Desktop/FB Data/Clinton_fans/week_fans/20161101/"
file_list = os.listdir(path)
df_list = []
for i ,file in enumerate(file_list):
	filename = path + file
	df = pd.read_csv(filename)
	df_list.append(df)
	print(str(i + 1) + " data done")

df = pd.concat(df_list, sort = False)
df.to_csv(path[:-1] + ".csv", index = False)



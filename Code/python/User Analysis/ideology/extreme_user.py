import pandas as pd
import os
import numpy as np

def extreme_user_score(path):
	
	file_list = os.listdir(path)
	threshold = {}
	for i, file in enumerate(file_list):
		print("Start calculating data " + str(i + 1))
		filename = path + file
		data = pd.read_csv(filename)
		std = np.std(data["user_PC1_mean_weighted"])
		mean = np.mean(data["user_PC1_mean_weighted"])
		date = file[30:40]
		threshold[date] = [mean, std, mean + std, mean + std*1.645, mean + std*2, mean + std*3]
		print("Data " + str(i + 1) + " done")

	extreme_threshold = pd.DataFrame.from_dict(threshold, orient = "index")
	extreme_threshold.columns = ["mean", "std", "1std", "1.645std", "2std", "3std"]
	extreme_threshold.index.names = ["date"]
	
	return(extreme_threshold)

def main():
	input_path = "/home3/r05322021/Desktop/FB Data/user_score/2015-05-03_to_2016-11-26_4weeks/"
	data = extreme_user_score(input_path)
	data.to_csv("/home3/r05322021/Desktop/FB Data/Trump_fans/extreme_user.csv", sep = ",")

if __name__ == '__main__':
    main()


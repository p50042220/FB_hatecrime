##Calculate ideology_difference using distance between Trump and Clinton
import numpy as np 
import pandas as pd 
import os

def main():
	user_path = "/home3/r05322021/Desktop/FB Data/user_score/2015-05-03_to_2016-11-26_4weeks/"
	user_file_list = os.listdir(user_path)
	page_path = "/home3/r05322021/Desktop/FB Data/page_score/2015-05-03_to_2016-11-26_4weeks/"
	page_file_list = os.listdir(page_path)
	diff_df = pd.read_csv("/home3/r05322021/Desktop/FB Data/Polarization/ideology_mean_difference.csv")

	for i, file in enumerate(user_file_list):
		user_file = user_path + file
		page_file = page_path + page_file_list[i]
		user = pd.read_csv(user_file, usecols = ["user_id", "user_PC1_mean"])
		page = pd.read_csv(page_file, usecols = ["page_id", "PC1_std"])
		user["Trump"] = abs(user["user_PC1_mean"] - page[page.page_id == 153080620724]["PC1_std"].values)
		user["Clinton"] = abs(user["user_PC1_mean"] - page[page.page_id == 889307941125736]["PC1_std"].values)
		Trump = user[user.Trump < user.Clinton]
		Clinton = user[user.Trump > user.Clinton]
		diff_df["Candidate_diff_distance"][i] = Trump["user_PC1_mean"].mean() - Clinton["user_PC1_mean"].mean()
		print("week" + str(i + 1) + " Done")

	diff_df.to_csv("/home3/r05322021/Desktop/FB Data/Polarization/ideology_mean_difference.csv", sep = ",", index = False)

if __name__ == '__main__':
    main()

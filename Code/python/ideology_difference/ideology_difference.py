##Count ideology difference
import pandas as pd 
import numpy as np
import os

def main():
	path = "/home3/r05322021/Desktop/FB Data/user_score/2015-05-03_to_2016-11-26_4weeks/"
	file_list = os.listdir(path)
	party = pd.read_csv("/home3/r05322021/Desktop/FB Data/all_user_party_and_candidate.csv")
	diff_df = pd.DataFrame(np.zeros((len(file_list), 4)), columns = ["week", "party_diff", "Candidate_diff_counts", "Candidate_diff_distance"])

	for i, file in enumerate(file_list):
		filename = path + file
		df = pd.read_csv(filename, usecols = ["user_id", "user_PC1_mean"])
		df = pd.merge(party, df, on = "user_id", how = "inner")
		Republic = df[df.Rep > df.Dem]
		Democrat = df[df.Dem > df.Rep]
		Trump = df[df.Trump > df.Clinton]
		Clinton = df[df.Trump < df.Clinton]
		diff_df["week"][i] = i
		diff_df["party_diff"][i] = Republic["user_PC1_mean"].mean() - Democrat["user_PC1_mean"].mean()
		diff_df["Candidate_diff_counts"][i] = Trump["user_PC1_mean"].mean() - Clinton["user_PC1_mean"].mean()
		print("week" + str(i) + " Done")

	diff_df.to_csv("/home3/r05322021/Desktop/FB Data/Polarization/ideology_mean_difference.csv", sep = ",", index = False)

if __name__ == '__main__':
    main()





## combine all files of the same day
import os
import pandas as pd 

def main():
	path = "/home3/r05322021/Desktop/FB Data/1000_pages_politician_user_like_pages/"
	path_list = os.listdir(path)
	for folder in path_list:
		input_path = path + folder + "/"
		input_list = os.listdir(input_path)
		df_list = []
		output_file = input_path + folder + ".csv"

		for file in input_list:
			input_file = input_path + file
			df = pd.read_csv(input_file, header = None)
			df.ix[:,0] = df.ix[:,0].astype(str)
			df.ix[:,1] = df.ix[:,1].astype(str)
			df.ix[:,2] = df.ix[:,2].astype(str)
			df_list.append(df)
		output = pd.concat(df_list)
		output.to_csv(output_file, sep = ",", index = False, header = False)
		print(folder + "done")

if __name__ == '__main__':
    main()

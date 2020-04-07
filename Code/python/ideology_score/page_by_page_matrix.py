##create page_by_page_matrix
import pandas as pd 
import sys 
import os

sys.path.append('home3/usfb/analysis/analysis-prediction/code/bootstrap')
from fbscore import use

def main():
	path = "/home3/r05322021/Desktop/FB Data/1000_pages_politician_user_like_pages/"
	output_folder = "/home3/r05322021/Desktop/FB Data/page_by_page_matrix/"
	path_list = os.listdir(path)
	for folder in path_list:
		file = path + folder + "/" + folder + ".csv"
		use.fb_score(
			input_format = "user_like_page", 
    		output_format = "page_page_matrix", 
    		input_path = file,
    		output_path = output_folder + folder + "_page_by_page_matrix.csv",
    		overwrite_file = True)
		print(folder + " " + "done")

if __name__ == '__main__':
    main()







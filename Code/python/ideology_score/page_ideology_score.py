##create page ideology score
import pandas as pd 
import sys 
import os

sys.path.append('home3/usfb/analysis/analysis-prediction/code/bootstrap')
from fbscore import use

def main():
	path = "/home3/r05322021/Desktop/FB Data/page_by_page_matrix/"
	output_folder = "/home3/r05322021/Desktop/FB Data/page_ideology_score/"
	file_list = os.listdir(path)
	for file in file_list:
		filename = path + file + ".csv"
		use.fb_score(
    		input_format = "page_page_matrix",
    		output_format = "page_score",
    		input_path = filename,
    		output_path = output_folder + filename[:16] + "_page_ideology_score.csv",
    		page_info_path = "/home3/usfb/build/output/page/1000-page-and-politician-info.csv",
    		overwrite_file = True,
    		clinton_on_the_left = True, # To flip liberals on the left. Default=False.
    		page_id_column_index = 0)
		print(filename[:16] + " " + "done")

if __name__ == '__main__':
    main()
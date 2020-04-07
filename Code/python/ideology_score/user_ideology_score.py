##create user ideology score
import pandas as pd 
import sys 
import os

sys.path.append('home3/usfb/analysis/analysis-prediction/code/bootstrap')
from fbscore import use

def main():
	pagescore_path = "/home3/r05322021/Desktop/FB Data/page_ideology_score/"
    userlike_path = "/home3/r05322021/Desktop/FB Data/1000_pages_politician_user_like_pages/"
	output_folder = "/home3/r05322021/Desktop/FB Data/user_ideology_score/"
	score_file_list = os.listdir(pagescore_path)
    like_folder_list = os.listdir(userlike_path)
	for file in score_file_list:
		score = pagescore_path + file + ".csv"
        like = userlike_path + file[:16] + "/" + file[:16] + ".csv"
		use.fb_score(
            input_format = "page_score",
            output_format = "user_score",
            input_path = score,
            output_path = output_folder + file[:16] + "_user_ideology_score.csv",
            user_like_path = like,
            overwrite_file = True)
		print(file[:16] + " " + "done")

if __name__ == '__main__':
    main()
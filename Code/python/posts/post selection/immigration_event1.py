import pandas as pd 
from nltk.tokenize import wordpunct_tokenize as tokenize
import os
from tqdm import *

def combine_data(input_path):

	file_list = os.listdir(input_path)
	data_list = []

	print("Start reading data")
	for file in tqdm(file_list):
		filename = input_path + file
		data = pd.read_csv(filename, converters = {"post_id": str, "post_name": str, "post_message": str },  lineterminator = '\n')
		data_list.append(data)
	
	print("Start combining data")
	post_data = pd.concat(data_list, sort = False)[["page_id", "page_name", "post_id", "post_name", "post_message", "post_reactions", "post_likes", "post_comments", "post_shares", "post_created_date_CT", "page_talking_about_count"]]

	return post_data
	

def select_posts(data, output_path):
	
	print("Start reading data")
	post_data = pd.read_csv(data, converters = {"post_id": str, "post_name": str, "post_message": str, "post_description": str, "post_picture": str, "post_link": str },  lineterminator = '\n')
	post_data = post_data.drop_duplicates().reset_index(drop = True)
	immigration_index = []

	print("Start categorizing posts")
	for i in tqdm(range(0, len(post_data["post_id"]))):
		post_content = post_data["post_name"][i] + post_data["post_message"][i] + post_data["post_description"][i] + post_data["post_picture"][i] + post_data["post_link"][i]
		post = post_content.lower()
		if post.find("immigration") != -1 or post.find("immigrant") != -1 or post.find("immigrants") != -1:
			immigration_index.extend([i])
		elif post.find("mexico") != -1 or post.find("mexicans") != -1 or post.find("mexican") != -1:
			if post.find("trump") != -1:
				immigration_index.extend([i])
			elif post.find("rapist") != -1 or post.find("rapists") != -1 or post.find("criminal") != -1 or post.find("criminals") != -1:
				immigration_index.extend([i])

	immigration_posts = post_data.iloc[immigration_index]
	immigration_posts.index.name = "index"
	immigration_posts.to_csv(output_path + "immigration_posts_event1.csv")

	immigration_diff_index = set(range(len(post_data["post_id"]))) - set(immigration_index)
	none_posts = post_data.iloc[list(immigration_diff_index)]
	none_posts.index.name = "index"
	none_posts.to_csv(output_path + "immigration_none_posts_event1.csv")

def main():
	data = "/home3/r05322021/Desktop/FB Data/posts_rawdata/immigration_event1/immigration_event1.csv"
	output_path = "/home3/r05322021/Desktop/FB Data/posts_category/"
	select_posts(data, output_path)

if __name__ == '__main__':
    main()



			



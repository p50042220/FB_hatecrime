import pandas as pd 
import os

def calculate_extreme_user(data_path):
	data = pd.read_csv(data_path, usecols = ["week", "like_state_max", "ratio", "n"], converters = {"like_state_max": str, "week": str })
	states = data.like_state_max.unique()
	extreme_dict = {}
	for state_name in states:
		state = data[data["like_state_max"] == state_name]
		weeks = state.week.unique()
		for week_num in weeks:
			state_week = state[state["week"] == week_num]
			key_name = state_name + "-" + week_num
			total = state_week.n.unique()[0]
			ratio = state_week.ratio.unique()[0]
			extreme_dict[key_name] = [state_name, week_num, ratio, total]
			print(key_name + " Done")
	extreme_dataframe = pd.DataFrame.from_dict(extreme_dict, orient = 'index')
	extreme_dataframe.columns = ["state", "week", "ratio", "total"]
	return(extreme_dataframe)

def main():
	path = "/home3/r05322021/Desktop/FB Data/hate_crime_data/extreme_state_week.csv"
	data = calculate_extreme_user(path)
	output_path = "/home3/r05322021/Desktop/FB Data/hate_crime_data/"
	data.to_csv(output_path + "hate_crime_ideology.csv", sep = ",", index = False)

if __name__ == '__main__':
    main()

		

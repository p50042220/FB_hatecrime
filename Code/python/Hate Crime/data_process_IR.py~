import re
import csv
import os
import pandas as pd
from tqdm import *

path = "/home3/r05322021/Desktop/FB Data/hate_crime_data/Raw/"
data_list = os.listdir(path)
output_path = "/home3/r05322021/Desktop/FB Data/hate_crime_data/IR/"

for file in data_list:
        filename = path + file
        df = {}
        with open(filename, "r") as f:
                lines = f.readlines()
                for line in tqdm(lines):
                        if line[:2] == "IR":
                                df[line] = [str(line[2:4]), str(line[4:13]), str(line[13:25]), str(line[25:33]), str(line[33]), str(line[34]), str(line[35:38]), str(line[38:40]), line[40], str(line[41:44]), str(line[44:47]), str(line[47:49]), str(line[49:51]), str(line[51])]
        data_name = output_path + file[:4] + ".csv"

        with open(data_name, "w", encoding = "utf-8") as f:
                write = csv.writer(f)
                write.writerow(["state", "agency", "ID", "date", "source", "quarter", "number_of_victims", "total_offenders", "offenders_race", "offense_type", "number_of_group_victims", "location", "motivation", "victim_type"])
                for key in df:
                        write.writerow(df[key])
        

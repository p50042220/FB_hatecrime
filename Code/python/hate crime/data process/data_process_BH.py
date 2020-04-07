import re
import csv
import os
import pandas as pd
from tqdm import *

path = "/Volumes/ntu/研究/Master-Thesis---Political-Polarization-in-2016-US-Election/Data/Hate Crime/Raw Data/"
data_list = os.listdir(path)
output_path = "/Volumes/ntu/研究/Master-Thesis---Political-Polarization-in-2016-US-Election/Data/Hate Crime/Cleaned Data/BH/"

for file in data_list:
        if file[0] == "2":
                filename = path + file
                df = {}
                with open(filename, "r") as f:
                        lines = f.readlines()
                        for line in tqdm(lines):
                                line = str(line)
                                if line[:2] == "BH":
                                        df[line] = [str(line[4:13]), str(line[41:71]), str(line[73:75]), str(line[75]), str(line[76]), str(line[77]), line[78], str(line[105:114])]
                                        print(df[line])
                data_name = output_path + file[:4] + ".csv"

                with open(data_name, "w", encoding = "utf-8") as f:
                        write = csv.writer(f)
                        write.writerow(["agency", "city", "population_group", "country_division", "country_region", "agency_indicator", "core_city", "population"])
                        for key in df:
                                write.writerow(df[key])
        else:
                continue




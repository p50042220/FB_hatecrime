import pandas as pd
import numpy as np
import os

def count_likes(filename, path, user_dict):

    df = pd.read_csv(f'{path}{filename}', converters={'like_times': str})
    for i, user_id in enumerate(df['user_id']):

        like_times = 
        if user_id not in user_dict:
            user_dict[user_id] = 

def main():
    
    file_path = '/home3/r05322021/Desktop/FB Data/Polarization/user_like_page/new_quit/'
    file_list = os.listdir(file_path)

    user_dict = {}

import pandas as pd
import numpy as np
import datetime
import os
from datetime import timedelta
from datetime import date
from multiprocessing import Pool
from functools import partial
import sys
sys.path.append('/home3/r05322021/Desktop/FB_hatecrime/Code/python/')
from fbscore import use


def page_score(filename, user_type, path_head):

    input_path = f'{path_head}user_like_page/{user_type}/'
    output_path = f'{path_head}page_score/{user_type}/'

    use.fb_score(
        input_format = "user_like_page",
        output_format = "page_score",
        input_path = f'{input_path}{filename}',
        output_path = f'{output_path}{filename}',
        page_info_path = '/home3/usfb/build/input/page/1000-page-and-politician-info.csv',
        overwrite_file = True,
        clinton_on_the_left = True,
        page_id_column_index = 0)

def user_score(filename, user_type, path_head):

    input_path = f'{path_head}page_score/{user_type}/'
    output_path = f'{path_head}user_score/{user_type}/'
    user_path = f'{path_head}user_like_page/{user_type}/'

    use.fb_score(
        input_format = "page_score",
        output_format = "user_score",
        input_path = f'{input_path}{filename}',
        output_path = f'{output_path}{filename}',
        user_like_path = f'{user_path}{filename}',
        overwrite_file = True)


def main(user_type):

    path_head = '/home3/r05322021/Desktop/FB Data/Polarization/'
    file_list = [filename for filename in os.listdir(f'{path_head}user_like_page/')]

    print("Page Score Calculation")
    if __name__ == '__main__':
        with Pool(processes=24) as pool:
            pool.map(partial(page_score, user_type=user_type, path_head=path_head), file_list)

    print("User Score Calculation")
    if __name__ == '__main__':
        with Pool(processes=24) as pool:
            pool.map(partial(user_score, user_type=user_type, path_head=path_head), file_list)
    
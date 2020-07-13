import logging
import json
import sys,os
import time
import argparse
import csv
import pandas as pd
from tqdm import *
import mmap



class incorrect_file_type(Exception):
    pass



def get_num_lines(file_path):
    """Counting number of lines of the file before reading it.

    To find the number of lines of file that is going to be readed from
    file_path by Memory-Maped package.

    Args:
        file_path: A string of path of the file we are importing.

    Returns:
        lines: Number of lines of the file.
    """
    
    fp = open(file_path, "r+")
    buf = mmap.mmap(fp.fileno(), 0)
    lines = 0

    while buf.readline():
        lines += 1

    return lines



def read_us_user_like_page(input_file_path, user_range):
    """Reading data "us_user_like_page" into a python dictionary.

    First check the structure of the input file, then calulate the number
    of shared users between pages and store it with a dictionary.

    Args:
        input_file_path: A string of path of input file: us_user_like_page.
    
    Returns:
        page_page_dict: A dictionary, containes multiple dictionaries that 
            stores the numbers of shared useres betweeen two pages, using 
            page id as key and shared useres as values, ex. 
            {
                pageid1: {pageid2: (shared user pageid1 & pageid2)}, 
                         {pageid3: (shared user pageid1 & pageid3)}, ...
                pageid2: {pageid3: (shared user pageid2 & pageid3)}, ...
            }
    
    Raises:
        incorrect_file_type: Contradiction of correct input file structure.
            Example of correct structure:
            {
                user_id,like_pages,like_times
                1000000736695525,21785951839,1
                1000001070029820,"44473416732,50978409031,630067593722141","2,1,2"
            }
    """

    page_page_dict = {}

    try:
        inputfile = open(input_file_path, "r")
        reader = csv.DictReader(inputfile)
        for i, test in enumerate(reader):
            test["user_id"]
            test["like_pages"]
#            test["like_times"]
            break;
    except:
        raise incorrect_file_type("input should be an us_user_like_page data")

    with open(input_file_path, "r") as inputfile:
        reader = csv.DictReader(inputfile)

        for i, row in enumerate( tqdm( reader, 
                                    total = get_num_lines(input_file_path))):

            if user_range == 'pure' and row['TYPE'].lower() == 'whole':
                continue

            pageid_list = row['like_pages'].split(',')

            for j, p in enumerate(pageid_list):
                if p not in page_page_dict:
                    page_page_dict[p] = {}

                for k, p1 in enumerate(pageid_list):
                    if k < j:
                        continue
                    elif k == j:
                        page_page_dict[p][p] = page_page_dict[p].get(p,0) + 1
                    else:
                        if p1 not in page_page_dict:
                            page_page_dict[p1] = {}
                        page_page_dict[p][p1] = page_page_dict[p].get(p1,0) + 1
                        page_page_dict[p1][p] = page_page_dict[p1].get(p,0) + 1

    return(page_page_dict)



def read_page_page_matrix(input_path):

    """Read file page_page_matrix int of a pandas dataframe.

    Read the input file using Pandas.read_csv and assign column "page_id" as
    the dataframe's index. Then check if the dataframe is a square matrix.

    Args:
        input_path: A string of path of input file: page_page_matrix.

    Returns:
        us_user_like_page_pd_df: Pandas dataframe of page_page_matrix.

    Raise:
        incorrect_file_type: Contradiction of correct input file structure.
            Example of correct structure:
            {
                page_id,10018702564,100434040001314,100450643330760
                10018702564,39437,108,74
                100434040001314,108,3473,4            
            }

    """

    matrix_df = pd.read_csv(input_path, sep =',' , index_col="page_id")
    if(len(matrix_df.columns) - len(matrix_df.index)) != 0:
        raise incorrect_file_type("input file is not a square matrix")
    
    return(matrix_df)



def read_us_user_like_page_pd_df(input_path, user_range):
    """Reading file "us_user_like_page" into a python dictionary.

    First check the structure of the input file, then calulate the number
    of shared users between pages and store it with a dictionary.

    Args:
        input_file_path: A string of path of input file: us_user_like_page.
    
    Returns:
        page_page_dict: A dictionary, containes multiple dictionaries that 
            stores the numbers of shared useres betweeen two pages, using 
            page id as key and shared useres as values, ex. 
            {
                pageid1: {pageid2: (shared user pageid1 & pageid2)}, 
                         {pageid3: (shared user pageid1 & pageid3)}, ...
                pageid2: {pageid3: (shared user pageid2 & pageid3)}, ...
            }
    
    Raises:
        incorrect_file_type: Contradiction of correct input file structure.
            Example of correct structure:
            {
                user_id,like_pages,like_times
                1000000736695525,21785951839,1
                1000001070029820,"44473416732,50978409031,630067593722141","2,1,2"
            }
    """

    try:
        us_user_like_page_pd_df = pd.read_csv(input_path, converters={'like_pages': str, 'like_times': str}
        #                                    usecols = ["user_id", 
        #                                            "like_pages","like_times"]
                                            )  
        if user_range != 'all':
            us_user_like_page_pd_df = us_user_like_page_pd_df[~us_user_like_page_pd_df.TYPE.isin(['whole', 'WHOLE'])]      
    except:
        raise incorrect_file_type("Input path Error")

    if("user_id" not in us_user_like_page_pd_df.columns
        or "like_pages" not in us_user_like_page_pd_df.columns):
        raise incorrect_file_type("input should be an us_user_like_page data")   
        

    return(us_user_like_page_pd_df)



def read_page_info_data(input_path, page_id_column_index):
    """Reading file "page_info" data to a Pandas dataframe

        Read the file by Pandas.read_csv. Then change the column name inputed 
        into "page_id" to faciliate merging dataframes in later steps.

        Args:
            input_path: A string of path of input file: page_info_data.
            page_id_column_index: An integer as the index to the 
                column: "page_id"

        Returns:
            page_info: Pandas dataframe of page information.
    """

    page_info = pd.read_csv(input_path)

    print("column name: ",page_info.columns[page_id_column_index], 
        " will be changed to: page_id ")

    page_info.rename(columns = { page_info.columns[page_id_column_index]: 
                                "page_id"}, 
                    inplace = True) 

    return(page_info)



def read_page_score_data(input_path):
    """Read file "page_score_data" into a pandas dataframe.

        Read the file by Pandas.read_csv. Then check if columns "page_id"
        and "PC1_std" which faciliaes later steps.

        Args:
            input_path: A string of path of input file: page_score_data.

        Returns:
            page_score: Pandas dataframe of page ideology score.

        Raise:
            incorrect_file_type: Missing columns "page_id" and "PC1_std"
            necessary in input file.
    """

    page_score = pd.read_csv(input_path)

    if("page_id" not in page_score.columns):
        raise incorrect_file_type("file does not contain column: page_id")
    if("PC1_std" not in page_score.columns):
        raise incorrect_file_type("file does not contain column: PC1_std")

    return(page_score)


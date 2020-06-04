import logging
import json
import sys,os
import time
import argparse
import csv
import pandas as pd
import os.path
import numpy as np
from sklearn.preprocessing import StandardScaler
from scipy import linalg



class overwriting_file(Exception):
    pass



def write_page_page_matrix(page_page_dataframe, output_file,
                        overwrite_file = False):
    """Write page_page_dataframe into a csv file.

    Write pandas dataframe "page_page_dataframe" into a csv file after 
    checking whether to overwrite a file. And print the filename written
    after finish writing the csv file.

    Args:
        page_page_dataframe: A square pandas dataframe storing numbers of 
            shared users between pages, having ID of pages liked by users 
            as column names and row names, ex:
            {
                         pageid1                  pageid2                  pageid3
                pageid1  number of users          number of users          number of users
                         liked pageid1            liked pageid1 & pageid2  liked pageid1 & pageid3
        
                pageid2  number of users          number of users          number of users
                         liked pageid1 & pageid2  liked pageid2            liked pageid2 & pageid3

                pageid3  number of users          number of users          number of users
                         liked pageid1 & pageid3  liked pageid2 & pageid3  liked pageid
            }
        output_file: A string of path of output file.
        overwrite_file: Boolean expression of whether intends to overwrite 
            a file.

    Raise:
        overwriting_file: Return error if the file pointed by "output_file" 
            exist when the imputted parameter "overwrite_file" is False.
    """

    if(os.path.isfile(output_file) and overwrite_file == False):
        raise overwriting_file("You are overwriting an existing file")
    page_page_dataframe.index.name = "page_id"
    page_page_dataframe.to_csv(output_file)    
    print("done writing page score data: ", output_file.split("/")[-1])



def write_page_score_data(page_score_dataframe, output_file, 
                        overwrite_file = False):    
    """Write page_page_dataframe into a csv file.

    Write pandas dataframe "page_score_dataframe" into a csv file after 
    checking whether to overwrite a file. And print the filename written
    after finish writing the csv file.

    Args:
        page_score_dataframe: Pandas dataframe containing computed ideology
            score and other information of Facebook pages.
        output_file: A string of path of output file.
        overwrite_file: Boolean expression of whether intends to overwrite 
            a file.

    Raise:
        overwriting_file: Return error if the file pointed by "output_file" 
            exist when the imputted parameter "overwrite_file" is False.
    """

    if(os.path.isfile(output_file) and overwrite_file == False):
        raise overwriting_file("You are overwriting an existing file")
    page_score_dataframe.to_csv(output_file, index = False,
                columns = ["page_id","page_name", "PC1", "PC1_std", 
                        "PC2", "PC2_std", "type", "type_sub", 
                        "politician_name", "party", "chamber", 
                        "state", "main_page", "page_url"])
    print("done writing page score data: ", output_file.split("/")[-1])



def write_user_score_data(user_score_dataframe, output_file, 
                        overwrite_file = False):
    """Write user_score_dataframe into a csv file.

    Write pandas dataframe "user_score_dataframe" into a csv file after 
    checking whether to overwrite a file. And print the filename written
    after finish writing the csv file.

    Args:
        page_score_dataframe: Pandas dataframe containing computed ideology
            score and other information of Facebook users.
        output_file: A string of path of output file.
        overwrite_file: Boolean expression of whether intends to overwrite 
            a file.

    Raise:
        overwriting_file: Return error if the file pointed by "output_file" 
            exist when the imputted parameter "overwrite_file" is False.
    """

    if(os.path.isfile(output_file) and overwrite_file == False):
        raise overwriting_file("You are overwriting an existing file")
    user_score_dataframe.to_csv(output_file)
    print("done writing user score data: ", output_file.split("/")[-1])
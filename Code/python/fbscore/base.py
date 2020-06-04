# -*- coding: utf-8 -*-
import logging
import json
import sys,os
import time
import argparse
import csv
import pandas as pd
from tqdm import *
import mmap
import os.path
import numpy as np
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA as sklearnPCA
from scipy import linalg
import statistics as st



def us_user_page_to_page_page_matrix(page_page_dict):
    """ Generate a page by page matrix from data us_user_like

    Transform the page page dictionary read by read_us_user_like_page()
    into a pandas dataframe.

    Args: 
        page_page_dict: A dictionary, containes multiple dictionaries that 
            stores the numbers of shared useres betweeen two pages, using 
            page id as key and shared useres as values, ex. 
            {
                pageid1: {pageid2: (shared user pageid1 & pageid2)}, 
                         {pageid3: (shared user pageid1 & pageid3)}, ...
                pageid2: {pageid3: (shared user pageid2 & pageid3)}, ...
            }

    Returns:
        page_page_df: A square pandas dataframe storing numbers of shared users
            between pages, having ID of pages liked by users as column names 
            and row names, ex:
            {
                         pageid1                  pageid2                  pageid3
                pageid1  number of users          number of users          number of users
                         liked pageid1            liked pageid1 & pageid2  liked pageid1 & pageid3
        
                pageid2  number of users          number of users          number of users
                         liked pageid1 & pageid2  liked pageid2            liked pageid2 & pageid3

                pageid3  number of users          number of users          number of users
                         liked pageid1 & pageid3  liked pageid2 & pageid3  liked pageid
            }
    """

    sorted_dict_keys = sorted(page_page_dict.keys())
    page_page_df = pd.DataFrame(index = sorted_dict_keys, columns = sorted_dict_keys)

    for i in tqdm(sorted(page_page_dict.keys()), total= len(page_page_dict.keys())):    
        for j in sorted(page_page_dict[i].keys()):
            page_page_df[i][j] = page_page_dict[i][j]

    page_page_df= page_page_df.fillna(0) 

    return(page_page_df)



def page_page_matrix_to_page_score(page_page_dataframe, page_info_data, 
                                    clinton_on_the_left = False ):
    """Generate page ideology score using Singular Value Decomposition (SVD)
     
    Conduct SVD on the page page matrix after standardized to get ideology 
    score of different pages. Then we merge the scores with other information
    of the page.

    Args: 
        page_page_dataframe: Pandas dataframe of page by page matrix, which
            is the return of function us_user_page_to_page_page_matrix()
        page_info_data: Information of pages: page name, page ID, page URL, etc.
        clinton_on_the_left: A boolean expression indicating whether the 
            function ensures Hillary Clinton's computed ideology score being
            negative to make ideology score increases as the person being 
            more conservative.
    
    Returns:
        page_score_dataframe: Pandas dataframe of a page's score with other 
            information of the page.
    """
    df = page_page_dataframe
    A = df.values
    id_used = list(map(int , df.columns.values))
    matrix_size = len(df.columns)
    G = np.zeros((matrix_size, matrix_size)) 
    for i in range(0, matrix_size):
        for j in range(0, matrix_size):
            G[i,j] = A[i,j] / A[i,i]

    G_std = StandardScaler().fit_transform(G)
    pca = sklearnPCA(n_components = 2)
    P_PCA = pca.fit_transform(G_std)
    P_PCA_std = StandardScaler().fit_transform(P_PCA)
    SVD_df = pd.DataFrame({"page_id": id_used,
                         "PC1": P_PCA[:, 0], 
                         "PC2": P_PCA[:, 1],
                         "PC1_std": P_PCA_std[:, 0],
                         "PC2_std": P_PCA_std[:, 1]})
    # Ensure the liberal's have negative ideology score by checking Clinton's.
    if(clinton_on_the_left == True ):
        clinton_index = SVD_df.index[SVD_df["page_id"] 
                                        == 889307941125736].tolist()[0]
        if(SVD_df["PC1"][clinton_index] > 0):
            SVD_df["PC1"] = -SVD_df["PC1"]
            SVD_df["PC1_std"] = -SVD_df["PC1_std"]
    page_score_dataframe = pd.merge(page_info_data, SVD_df, 
                                    on = "page_id", how = "inner")

    return(page_score_dataframe)



def page_score_to_user_score(page_score_dataframe, user_like_page_data):
    """Calculate user ideology score from page_score_dataframe
    
    Compute user ideology score by the pages they liked in the chosen 
    period of time.

    Args:
        page_score_dataframe: Pandas dataframe of ideology score of pages,
            which is the return of page_page_matrix_to_page_score().
        user_like_page_data: Pandas dataframe of user's id, pages they liked,
            and times they liked those pages.

    Returns:
        user_score_datagrame: Pandas dataframe of with columns: 
            "user_PC1_mean", "user_PC1_median","user_PC1_mean_weighted" and
            "user_PC1_median_weighted, where user_id is the dataframe's index.

    """  
    page_score_dataframe.set_index("page_id", inplace = True)
    user_score_dict = {}

    for i in tqdm(range(0, len(user_like_page_data["user_id"]))):
        #get lists of pages liked, and liked times by user 
        user_id = user_like_page_data["user_id"][i]
        like_page_list_str = user_like_page_data["like_pages"][i].split(",")
        like_page_list = list(map( int, like_page_list_str))
    #    like_time_list = user_like_page_data["like_times"][i].split(",")
        page_score_list = []
    #    like_times_list = []
        page_score_ungroup = []
        
        """from two lists above, find pages that we have calculated ideology 
            scores by SVD, get their scores and like times, respectively.
        """
        for j, page_id in enumerate(like_page_list):
            if page_id in page_score_dataframe.index:
                page_score_list.append(float(
                    page_score_dataframe["PC1_std"][page_id]))
    #            like_times_list.append(int(like_time_list[j]))

        """Compute user ideology score if the user has liked at least one page
        that we calculated ideology scores by mean, median, weighted mean,
        weighted median. Where the weighted scores are weighted on the times
        that user liked the page's post. 
        """
        if len(page_score_list) > 0:
    #        for k in range(0, len(page_score_list)):
    #            page_score_ungroup += [page_score_list[k]] * like_times_list[k]
            
            user_score_dict[user_id] = [st.mean(page_score_list), 
                                        st.median(page_score_list), 
    #                                    st.mean(page_score_ungroup),
    #                                    st.median(page_score_ungroup)
                                        ]#
    
    user_score_dataframe = pd.DataFrame.from_dict(user_score_dict, 
        orient = 'index')
    user_score_dataframe.columns = ["user_PC1_mean", 
                                    "user_PC1_median", 
    #                                "user_PC1_mean_weighted", 
    #                                "user_PC1_median_weighted"
                                    ]
    user_score_dataframe.index.names = ["user_id"]

    return(user_score_dataframe)
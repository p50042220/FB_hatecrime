import pandas as pd
import numpy as np
import pandas_gbq as gbq
import pydata_google_auth
import datetime
import os
from multiprocessing import Pool
from functools import partial
from tqdm import tqdm as tqdm

def bigquery_auth():
    SCOPES = [
    'https://www.googleapis.com/auth/cloud-platform',
    'https://www.googleapis.com/auth/drive',]
    
    credentials = pydata_google_auth.get_user_credentials(
    SCOPES,
    # Set auth_local_webserver to True to have a slightly more convienient
    # authorization flow. Note, this doesn't work if you're running from a
    # notebook on a remote sever, such as over SSH or with Google Colab.
    auth_local_webserver=True,)

def read_data(input_path):

    df = pd.read_csv(input_path, converters={'user_id': str})

    return df

def main():

    path = '/home3/r05322021/Desktop/FB Data/comment/sentiment/'
    file_path = [f'{path}{f}' for f in os.listdir(path) if (f <= '2016-11-20') and (f >= '2015-05-03')]
    df_list = []

    if __name__ == '__main__':
        with Pool(processes=24) as pool:
            for _, x in enumerate(tqdm(pool.imap_unordered(read_data, file_path), total=len(file_path)), 1):
                df_list.append(x)

    df = pd.concat(df_list)
    gbq.to_gbq(df, 'comment.comment_sentiment', project_id='ntufbdata')


if __name__ == '__main__':
    main()


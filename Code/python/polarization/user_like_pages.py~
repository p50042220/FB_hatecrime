import pandas as pd
import numpy as np
import pandas_gbq as gbq
import pydata_google_auth
import seaborn as sns
import matplotlib.pylab as plt
import datetime
from datetime import timedelta
from datetime import date
from multiprocessing.pool import ThreadPool
from functools import partial
import sys
sys.path.append('/home3/r05322021/Desktop/FB_hatecrime/Code/python/')
import fbscore
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

def query_data(end_date, user_type, output_path):

    start_date = end_date - timedelta(days=27)
    start_date = start_date.strftime('%Y-%m-%d')
    end_date = end_date.strftime('%Y-%m-%d')
    query = f'''
            WITH OLD_USER AS(
                (SELECT user_id, TYPE
                FROM `ntufbdata.user_type.user_entering_type`
                WHERE TYPE = '{user_type}')
		UNION DISTINCT
		(SELECT user_id, TYPE
                FROM `ntufbdata.user_type.user_entering_type`
                WHERE TYPE = 'WHOLE')

            ), REACTION AS(
                (SELECT user_id,
                        SPLIT(post_id, '_')[ORDINAL(1)] AS page_id,
                        post_id
                FROM `ntufbdata.USdata.1000_page_us_user_like_post_201501_to_201611_all`
                WHERE TIMESTAMP(post_created_date_CT) >= TIMESTAMP('{start_date}')
                AND TIMESTAMP(post_created_date_CT) <= TIMESTAMP('{end_date}'))
                UNION DISTINCT
                (SELECT user_id,
                        SPLIT(post_id, '_')[ORDINAL(1)] AS page_id,
                        post_id
                FROM `ntufbdata.USdata.politician_us_user_post_like_all`
                WHERE TIMESTAMP(post_created_date_CT) >= TIMESTAMP('{start_date}')
                AND TIMESTAMP(post_created_date_CT) <= TIMESTAMP('{end_date}'))
            )

            SELECT user_id,
		    TYPE,
                    STRING_AGG(page_id, ',') AS like_pages,
                    STRING_AGG(CAST(like_time AS STRING), ',') AS like_times
            FROM(
            SELECT OLD_USER.user_id,
		    OLD_USER.TYPE,
                    REACTION.page_id,
                    COUNT(*) AS like_time
            FROM OLD_USER
            INNER JOIN REACTION ON OLD_USER.user_id = REACTION.user_id
            GROUP BY OLD_USER.user_id, OLD_USER.TYPE, REACTION.page_id)
            GROUP BY user_id, TYPE
            '''

    user_like_pages = gbq.read_gbq(query, project_id='ntufbdata')
    user_like_pages.to_csv(f'{output_path}{end_date}.csv', index=False)

def main(user_type):

    end_date_list = [date(2015,5,30) + timedelta(days=d) for d in range(0, 547, 7)]
    output_path = f'/home3/r05322021/Desktop/FB Data/Polarization/user_like_page/{user_type}/'

    if __name__ == '__main__':
        with ThreadPool(processes=10) as pool:
            pool.map(partial(query_data, user_type=user_type.upper(), output_path=output_path), end_date_list)
    
if __name__ == '__main__':
    user_type = sys.argv[1]
    main(user_type)


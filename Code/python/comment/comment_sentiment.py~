import pandas as pd
import numpy as np
import pandas_gbq as gbq
import pydata_google_auth
import seaborn as sns
import matplotlib.pylab as plt
import datetime
import nltk
nltk.download('vader_lexicon')
from nltk.sentiment.vader import SentimentIntensityAnalyzer
from nltk import word_tokenize, pos_tag
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

def sentiment_score_calculator(df):

    df = df.reindex(columns = [*df.columns.tolist(), "positive_score", "negative_score", "neutral_score", "compound_score"], fill_value = 0)
    week = df.Week.iloc[0]
    SIA = SentimentIntensityAnalyzer()

    for i in df.index:
        comment = df.loc[i, "comments"]
        score = SIA.polarity_scores(comment)
        df.loc[i, "positive_score"] = score["pos"]
        df.loc[i, "negative_score"] = score["neg"]
        df.loc[i, "neutral_score"] = score["neu"]
        df.loc[i, "compound_score"] = score["compound"]

    return [df, week]

def main():

    bigquery_auth()
    comment_query = '''
                    SELECT *
                    FROM
                    (SELECT
                    *,
                    CASE WHEN (post_id IN (SELECT post_id FROM post_category.immigration_related)) THEN 'immigration'
                        WHEN (post_id IN (SELECT post_id FROM post_category.race_related)) THEN 'race'   
                        ELSE 'None' END AS type,
                    DATE_ADD(DATE(2015,5,3), INTERVAL CAST(FLOOR(DATE_DIFF(CAST(comment_created_date AS DATE), DATE('2015-05-03'), DAY)/7) AS INT64) WEEK) AS Week
                    FROM
                    (SELECT comments.user_id,
                            comments.post_id,
                            comments.comments,
                            comments.comment_id,
                            user_state.state,
                            comments.comment_created_date
                    FROM `us_user_info.user_like_state_max_exclude_primary_all` AS user_state
                    INNER JOIN
                    (SELECT *
                    FROM `comment.comment_with_userid`
                    WHERE TIMESTAMP(comment_created_date) >= TIMESTAMP('2015-05-01')
                    AND TIMESTAMP(comment_created_date) < TIMESTAMP('2017-01-01')) AS comments
                    ON user_state.user_id = comments.user_id))
                    WHERE type != 'None'
                    '''
    #print("Query Data")
    #comment_data = gbq.read_gbq(comment_query, project_id='ntufbdata')
    #print("Save Raw Data")
    #comment_data.to_csv('/home3/r05322021/Desktop/FB Data/comment/comment.csv', index=False)

    comment_data = pd.read_csv('/home3/r05322021/Desktop/FB Data/comment/comment.csv', converters={'comments': str})

    df_list = [group[1] for group in comment_data.groupby(by='Week')]
    output_path = '/home3/r05322021/Desktop/FB Data/comment/sentiment/'

    if __name__ == '__main__':
        with Pool(processes=24) as pool:
            for _, x in enumerate(tqdm(pool.imap_unordered(sentiment_score_calculator, df_list), total=len(df_list)), 1):
                x[0].to_csv(f'{output_path}{x[1]}.csv', index = False)

if __name__ == '__main__':
    main()

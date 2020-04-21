import pandas_gbq as gbq
import pandas as pd
import numpy as np
import pydata_google_auth
import tensorflow as tf
import tensorflow_hub as hub
import bert
from tensorflow.keras.models import  Model, load_model
from tqdm import tqdm
import numpy as np
from collections import namedtuple
import pandas as pd
import re
import randomdef bigquery_auth():
    SCOPES = [
    'https://www.googleapis.com/auth/cloud-platform',
    'https://www.googleapis.com/auth/drive',]
    
    credentials = pydata_google_auth.get_user_credentials(
    SCOPES,
    # Set auth_local_webserver to True to have a slightly more convienient
    # authorization flow. Note, this doesn't work if you're running from a
    # notebook on a remote sever, such as over SSH or with Google Colab.
    auth_local_webserver=True,)


def clean(row, col):
    
    text = row[col]
    text = re.sub(r'http\S+', '', str(text))
    text = re.sub(r'\@\w+', '', str(text))
    text = re.sub(r'#\w+', '', str(text))
    text = re.sub(r'\[\w+\]', '', str(text))
    text = re.sub(r'\n', '', str(text))
    text = re.sub(r'\r', '', str(text))
    
    return text

def text_clean(df):
    df = df.fillna('')

    for column in ['post_name', 'post_message', 'post_description']:
        df[column] = df.apply(clean, col=column, axis=1)
    
    return df

def get_masks(tokens, max_seq_length):
    """Mask for padding"""
    if len(tokens)>max_seq_length:
        #Cutting down the excess length
        tokens = tokens[0:max_seq_length]
        return [1]*len(tokens)
    else :
      return [1]*len(tokens) + [0] * (max_seq_length - len(tokens))

def get_segments(tokens, max_seq_length):
    if len(tokens)>max_seq_length:
      #Cutting down the excess length
      tokens = tokens[:max_seq_length]
      segments = []
      current_segment_id = 0
      for token in tokens:
        segments.append(current_segment_id)
        if token == "[SEP]":
          current_segment_id = 1
      return segments
    else:
      segments = []
      current_segment_id = 0
      for token in tokens:
        segments.append(current_segment_id)
        if token == "[SEP]":
          current_segment_id = 1
      return segments + [0] * (max_seq_length - len(tokens))

def get_ids(tokens, tokenizer, max_seq_length):    
    if len(tokens) > max_seq_length:
      tokens = tokens[:max_seq_length]
      token_ids = tokenizer.convert_tokens_to_ids(tokens)
      return token_ids
    else:
      token_ids = tokenizer.convert_tokens_to_ids(tokens)
      input_ids = token_ids + [0] * (max_seq_length-len(token_ids))
      return input_ids

def preprocess_text(s, tokenizer, max_length):
    stokens = tokenizer.tokenize(s)
    stokens = ["[CLS]"] + stokens + ["[SEP]"]
    input_ids = get_ids(stokens, tokenizer, max_length)
    input_masks = get_masks(stokens, max_length)
    input_segments = get_segments(stokens, max_length)
    return input_ids, input_masks, input_segments

def preprocess_whole(df, tokenizer, max_length):
    
    df = text_clean(df)
    input_id, input_mask, input_segment = [], [], []
    
    for _, index in enumerate(tqdm(df.index.tolist(), total=len(df)), 1):
        text = df['post_name'].loc[index] + ' ' + df['post_message'].loc[index] + ' ' + df['post_description'].loc[index]
        ids, masks, segments = preprocess_text(text, tokenizer, max_length)
        
        input_id.append(ids)
        input_mask.append(masks)
        input_segment.append(segments)
        
    return [np.array(input_id, dtype=np.int32), 
            np.array(input_mask, dtype=np.int32), 
            np.array(input_segment, dtype=np.int32)]

def training_form(df, max_length):
    vocab_file = bert_layer.resolved_object.vocab_file.asset_path.numpy()
    do_lower_case = bert_layer.resolved_object.do_lower_case.numpy()
    tokenizer = bert.bert_tokenization.FullTokenizer(vocab_file,do_lower_case)
    
    document = preprocess_whole(df, tokenizer, max_length)
        
    return document


def predict(original_df, threshold, model):
    
    prediction = model.predict(original_df, batch_size=12800, verbose=1)
    pred = [1 if d[1] >= threshold else 0 for d in prediction]
    
    return pred


def main():
    
    bigquery_auth()
    immigration_query = '''
			SELECT
			  *
			FROM
			  `1000_page_post.201501_to_201611_all`
			WHERE
			    TIMESTAMP(post_created_date_CT) >= TIMESTAMP('2015-05-01') AND
			  (LOWER(post_name) LIKE "%black%" OR
			  LOWER(post_message) LIKE "%black%" OR
			  LOWER(post_caption) LIKE "%black%" OR
			  LOWER(post_description) LIKE "%black%" OR
			  LOWER(post_name) LIKE "%african-american" OR
			  LOWER(post_message) LIKE "%african-american%" OR
			  LOWER(post_caption) LIKE "%african-american%" OR
			  LOWER(post_description) LIKE "%african-american%" OR
			  LOWER(post_name) LIKE "%african american%" OR
			  LOWER(post_message) LIKE "%african american%" OR
			  LOWER(post_caption) LIKE "%african american%" OR
			  LOWER(post_description) LIKE "%african american%")
			'''
    race = gbq.read_gbq(immigration_query, project_id='ntufbdata')
    bert_layer=hub.KerasLayer("https://tfhub.dev/tensorflow/bert_en_uncased_L-12_H-768_A-12/1",trainable=True)

    MAX_SEQ_LEN = 500
    document = training_form(race, MAX_SEQ_LEN)
    model = load_model(r'/home3/r05322021/Desktop/FB_hatecrime/model/race.h5', custom_objects={'KerasLayer':hub.KerasLayer})

    race['race_related'] = pd.Series(predict(document, 0.5, model))

    race.to_csv(r'/home3/r05322021/Desktop/FB_hatecrime/Data/issue_post/race_predicted.csv', index=False)

    
    return pred



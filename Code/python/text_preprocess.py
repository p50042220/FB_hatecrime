import tensorflow as tf
import tensorflow_hub as hub
import bert
from tensorflow.keras.models import  Model
from tqdm import tqdm
import numpy as np
from collections import namedtuple
import pandas as pd
import re
import random
from sklearn.preprocessing import OneHotEnc

class BertPreprocess:

    def __init__(self, df, target_col, bert_layer):

        self.df = df
        self._Y = target_col
        self._bert_layer = bert_layer
        self._vocab_file = bert_layer.resolved_object.vocab_file.asset_path.numpy()
        self._do_lower_case = bert_layer.resolved_object.do_lower_case.numpy()
        self._tokenizer = bert.bert_tokenization.FullTokenizer(vocab_file,do_lower_case)

    
    def _clean(row, col):
    
        text = row[col]
        text = re.sub(r'http\S+', '', str(text))
        text = re.sub(r'\@\w+', '', str(text))
        text = re.sub(r'#\w+', '', str(text))
        text = re.sub(r'\[\w+\]', '', str(text))
        text = re.sub(r'\n', '', str(text))
        text = re.sub(r'\r', '', str(text))
        
        return text


    def _text_clean(self):
        self.df = self.df.fillna('')

        for column in ['post_name', 'post_message', 'post_description']:
            self.df[column] = self.df.apply(clean, col=column, axis=1)
                

    def _get_masks(self, tokens, max_seq_length):
        """Mask for padding"""
        if len(tokens)>max_seq_length:
            #Cutting down the excess length
            tokens = tokens[0:max_seq_length]
            return [1]*len(tokens)
        else :
        return [1]*len(tokens) + [0] * (max_seq_length - len(tokens))

    def _get_segments(self, tokens, max_seq_length):
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

    def _get_ids(self, tokens, max_seq_length):    
        if len(tokens) > max_seq_length:
        tokens = tokens[:max_seq_length]
        token_ids = self._tokenizer.convert_tokens_to_ids(tokens)
        return token_ids
        else:
        token_ids = self._tokenizer.convert_tokens_to_ids(tokens)
        input_ids = token_ids + [0] * (max_seq_length-len(token_ids))
        return input_ids

    def _preprocess_text(self, s,  max_seq_length):
        stokens = self._tokenizer.tokenize(s)
        stokens = ["[CLS]"] + stokens + ["[SEP]"]
        input_ids = self._get_ids(stokens, tokenizer, max_seq_length)
        input_masks = self._get_masks(stokens, max_seq_length)
        input_segments = self._get_segments(stokens, max_seq_length)

        return input_ids, input_masks, input_segments

    def preprocess_whole(self, max_seq_length):
        
        input_id, input_mask, input_segment = [], [], []
        
        for _, index in enumerate(tqdm(self.df.index.tolist(), total=len(self.df)), 1):
            text = self.df['post_name'].loc[index] + ' ' + self.df['post_message'].loc[index] + ' ' + self.df['post_description'].loc[index]
            ids, masks, segments = self._preprocess_text(text, max_seq_length)
            
            input_id.append(ids)
            input_mask.append(masks)
            input_segment.append(segments)
            
        return [np.array(input_id, dtype=np.int32), 
                np.array(input_mask, dtype=np.int32), 
                np.array(input_segment, dtype=np.int32)]

    
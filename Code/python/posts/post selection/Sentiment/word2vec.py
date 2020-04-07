import pandas as pd
import os
import nltk
import numpy as np
from tqdm import *
from nltk.corpus import wordnet
import nltk

##Data Preprocess
def get_wordnet_pos(word):
    """Map POS tag to first character lemmatize() accepts"""
    tag = nltk.pos_tag([word])[0][1][0].upper()
    tag_dict = {"J": wordnet.ADJ,
                "N": wordnet.NOUN,
                "V": wordnet.VERB,
                "R": wordnet.ADV}

    return tag_dict.get(tag, wordnet.NOUN)

import string
from nltk.stem import WordNetLemmatizer 
from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize
import re

def tokenize_with_lemmentize(document_list ,lemmentize = True):

    tokenized_post = []
    lemmatizer = WordNetLemmatizer()
    
    removed = stopwords.words('english') + list(string.punctuation)
    for i in tqdm(range(len(document_list["post_name"]))):
        document = document_list["post_name"][i] + " " + document_list["post_message"][i] + " " + document_list["post_description"][i]
        post = re.sub(r'http\S+', '', str(document))
        tokens = word_tokenize(post)
        words = [word.lower() for word in tokens if word.isalpha() and word not in removed]
        if lemmentize:
            words_lemmantized = [lemmatizer.lemmatize(w, get_wordnet_pos(w)) for w in words]
            tokenized_post.append(words_lemmantized)
        else:
            tokenized_post.append(words)
    return tokenized_post

from gensim.models.word2vec import Word2Vec

##Main program
def main():
    data = pd.read_csv("/home3/r05322021/Desktop/FB Data/posts_rawdata/abortion.csv", usecols = ["post_name", "post_message", "post_description"], converters = {"post_name": str, "post_message": str, "post_description": str }, lineterminator = '\n')

    print("Start Preprocessing")
    tokenized_data = tokenize_with_lemmentize(data)

    print("Start Training Model")
    model_d500 = Word2Vec(tokenized_data, size=500, iter=15)

    model_d500.save("pre_trained_word2vec_abortion.model")

if __name__ == "__main__":
    main()





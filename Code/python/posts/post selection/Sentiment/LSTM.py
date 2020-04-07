import pandas as pd
import os
import nltk
import matplotlib.pyplot as plt
import numpy as np
from nltk.corpus import wordnet
import nltk

##Text Preprocess
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
from tqdm import *
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

##Import pre-trained model
import gensim
from gensim.models.word2vec import Word2Vec
w2vModel = Word2Vec.load('/home3/r05322021/Desktop/FB_code/posts/pre_trained_word2vec_abortion.model')

##Read Data
data = pd.read_csv('/home3/r05322021/Desktop/FB Data/posts_category/abortion/abortion.csv', converters = {"post_name": str, "post_message": str, "post_description": str })


from sklearn.model_selection import train_test_split
from sklearn.metrics import confusion_matrix, roc_curve,  roc_auc_score, classification_report
from keras.models import Sequential
from keras.layers.core import Dense, Dropout
from keras.layers.embeddings import Embedding
from keras.preprocessing.sequence import pad_sequences
from keras.preprocessing.text import Tokenizer
from keras.layers import LSTM

##Preprocess X and Y
X = tokenize_with_lemmentize(data)
tokenizer = Tokenizer()
tokenizer.fit_on_texts(X)
X = tokenizer.texts_to_sequences(X)
X = pad_sequences(X)

Y = data["abortion_sentiment"]
from sklearn.preprocessing import LabelEncoder
encoder = LabelEncoder()
encoder.fit(Y)
encoded_Y = encoder.transform(Y)
import numpy as np
from keras.utils import np_utils
Y = np_utils.to_categorical(encoded_Y)


##Model
Embedding_DIM = 500
word_index = tokenizer.word_index
nb_words = len(word_index)

embedding_matrix = np.zeros((nb_words + 1, Embedding_DIM))
for word, i in word_index.items():
    if word in w2vModel.wv.vocab:
        embedding_matrix[i - 1] = w2vModel[word]

embedding_layer = Embedding(input_dim=nb_words + 1, output_dim=Embedding_DIM, weights=[embedding_matrix], trainable = False)

model = Sequential()
model.add(embedding_layer)
model.add(LSTM(128, dropout=0.2, recurrent_dropout=0.2))
model.add(Dense(128, activation='sigmoid'))
model.add(Dropout(0.2))
model.add(Dense(3, activation='softmax'))
model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'])
print(model.summary())


#Training and Validation
batch_size_list = [10, 20, 40, 60, 80, 100]
epochs_list = [10, 50, 100]
model_list = []
for batch in batch_size_list:
    X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size= 0.1, random_state = 24)
    model_list.append(model.fit(X_train, Y_train, epochs=1, batch_size=batch))
    score, acc = model.evaluate(X_test, Y_test, verbose = 2, batch_size=batch_size)
    print("score = " + str(score))
    print("accuracy = " + str(acc))

print(model.predict(X_test))









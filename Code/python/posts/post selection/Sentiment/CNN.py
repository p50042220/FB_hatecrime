import pandas as pd
import re
import numpy as np
from keras.preprocessing import sequence
from keras.regularizers import l2
from keras.models import Model
from keras.layers.merge import concatenate
from keras.callbacks import EarlyStopping, ModelCheckpoint, TensorBoard
from keras.layers import Dense, GlobalMaxPooling1D, Activation, Dropout, GaussianNoise
from keras.layers import Embedding, Input, BatchNormalization, SpatialDropout1D, Conv1D
from keras.optimizers import Adam
from keras.preprocessing.text import Tokenizer
from keras.preprocessing.sequence import pad_sequences
from pandas_summary import DataFrameSummary 
from IPython.display import display
import itertools
from nltk.corpus import words
%matplotlib inline
import matplotlib.pyplot as plt



# Set parameters
embed_size   = 50    # how big is each word vector
max_features = 20000 # how many unique words to use (i.e num rows in embedding vector)
maxlen       = 100   # max number of words in a comment to use 



# Load data
train = pd.read_csv('Users/John/Documents/RaceData/500筆資料/race_201505.csv') # 500筆label過的資料
test = pd.read_csv('Users/John/Documents/RaceData/201505.csv') # bigquery "label_data"裡的資料

##Data Preprocessing
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


list_train = tokenize_with_lemmentize(train)

list_classes = ["Ethnics_related", "Gunshot_Crime_related"]
y = train[list_classes].values

list_test = tokenize_with_lemmentize(test)


# Pad sentences and convert to integers
tokenizer = Tokenizer(num_words = max_features)
tokenizer.fit_on_texts(list(list_train))
list_tokenized_train = tokenizer.texts_to_sequences(list_train)
list_tokenized_test = tokenizer.texts_to_sequences(list_test)

X_train = pad_sequences(list_tokenized_train, maxlen=maxlen, padding = 'post')
X_test = pad_sequences(list_tokenized_test, maxlen=maxlen, padding = 'post')



##Import pre-trained model
import gensim
from gensim.models.word2vec import Word2Vec
w2vModel = Word2Vec.load('/home3/r05322021/Desktop/FB_code/posts/pre_trained_word2vec_abortion.model')




# Create embeddings matrix
Embedding_DIM = 500
word_index = tokenizer.word_index
nb_words = len(word_index)

embedding_matrix = np.zeros((nb_words + 1, Embedding_DIM))
for word, i in word_index.items():
    if word in w2vModel.wv.vocab:
        embedding_matrix[i - 1] = w2vModel[word]





# Initialize parameters
conv_filters = 128 # No. filters to use for each convolution
weight_vec = list(np.max(np.sum(y, axis=0))/np.sum(y, axis=0))
class_weight = {i: weight_vec[i] for i in range(6)}


inp = Input(shape = (X_train.shape[1],), dtype = 'int64')
emb = Embedding(input_dim=nb_words + 1, output_dim=Embedding_DIM, weights=[embedding_matrix], trainable = False)


# Specify each convolution layer and their kernel siz i.e. n-grams 
conv1_1 = Conv1D(filters=conv_filters, kernel_size=3)(emb)
btch1_1 = BatchNormalization()(conv1_1)
drp1_1  = Dropout(0.2)(btch1_1)
actv1_1 = Activation('relu')(drp1_1)
glmp1_1 = GlobalMaxPooling1D()(actv1_1)

conv1_2 = Conv1D(filters=conv_filters, kernel_size=4)(emb)
btch1_2 = BatchNormalization()(conv1_2)
drp1_2  = Dropout(0.2)(btch1_2)
actv1_2 = Activation('relu')(drp1_2)
glmp1_2 = GlobalMaxPooling1D()(actv1_2)

conv1_3 = Conv1D(filters=conv_filters, kernel_size=5)(emb)
btch1_3 = BatchNormalization()(conv1_3)
drp1_3  = Dropout(0.2)(btch1_3)
actv1_3 = Activation('relu')(drp1_3)
glmp1_3 = GlobalMaxPooling1D()(actv1_3)

conv1_4 = Conv1D(filters=conv_filters, kernel_size=6)(emb)
btch1_4 = BatchNormalization()(conv1_4)
drp1_4  = Dropout(0.2)(btch1_4)
actv1_4 = Activation('relu')(drp1_4)
glmp1_4 = GlobalMaxPooling1D()(actv1_4)

# Gather all convolution layers
cnct = concatenate([glmp1_1, glmp1_2, glmp1_3, glmp1_4], axis=1)
drp1 = Dropout(0.2)(cnct)

dns1  = Dense(32, activation='relu')(drp1)
btch1 = BatchNormalization()(dns1)
drp2  = Dropout(0.2)(btch1)

out = Dense(y.shape[1], activation='sigmoid')(drp2)



# Compile
model = Model(inputs=inp, outputs=out)
adam = Adam(lr=0.001, beta_1=0.9, beta_2=0.999, epsilon=1e-08, decay=0.0)
model.compile(optimizer=adam, loss='binary_crossentropy', metrics=['accuracy'])



# Estimate model
model.fit(X_train, y, validation_split=0.1, epochs=2, batch_size=32, shuffle=True, class_weight=class_weight)


# Predict
preds = model.predict(X_test)


# Create submission
submid = pd.DataFrame({'id': test["id"]})
submission = pd.concat([submid, pd.DataFrame(preds, columns = list_classes)], axis=1)
submission.to_csv('race.csv', index=False)

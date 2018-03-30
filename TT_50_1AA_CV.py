
# coding: utf-8

# In[2]:


from keras.models import Sequential
from keras import layers
from keras.optimizers import RMSprop
from keras.optimizers import Adadelta
from keras.optimizers import Adam
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from keras.utils import np_utils
from keras.layers import *
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import sys, os
import pickle
from sklearn.model_selection import KFold
#from IPython.display import clear_output
from sklearn.metrics import confusion_matrix, recall_score, precision_score, f1_score


# In[2]:

files = [f for f in os.listdir('/home/bigfish/Documenti/Daniele/Singa/Backup_windows_20318/Notebooks/Datasets/20_genomes_species_splitted/50_splitted/')]
#files = get_ipython().getoutput('cd /home/bigfish/Documenti/Daniele/Singa/Backup_windows_20318/Notebooks/Datasets/20_genomes_species_splitted/50_splitted && ls *.csv')
files = list(map(lambda x: '/home/bigfish/Documenti/Daniele/Singa/Backup_windows_20318/Notebooks/Datasets/20_genomes_species_splitted/50_splitted/'+x.split(' ')[-1],files))


# In[3]:


d = pd.concat([pd.read_csv(f, index_col=0, header=0) for f in files],ignore_index=True)


# In[4]:


names, occ = np.unique(d['class'].values, return_counts=True)


# In[5]:


#index = np.arange(len(names))
#plt.bar(index, occ)
#plt.xlabel('Species', fontsize=5)
#plt.ylabel('Samples', fontsize=5)
#plt.xticks(index,names, fontsize=5, rotation=30)
#plt.savefig('dist19.png')
#plt.show()


# In[6]:


data = d[['class','seq']]


# In[7]:


data.sample(10)


# In[8]:


current_size = data[data['class']=='Pseudomonas benzenivorans'].shape[0]
print(current_size)


# In[9]:


data_pos = data[data['class']=='Pseudomonas benzenivorans']#.sample(int(current_size*0.8)) #80%


# In[10]:


if (data[data['class']!='Pseudomonas benzenivorans'].shape[0]-int(current_size)*18)/18 >= 0:
    data_neg = data[data['class']!='Pseudomonas benzenivorans'].sample(int(current_size)*18)
else:
    data_neg = data[data['class']!='Pseudomonas benzenivorans'].sample((data.shape[0]-current_size))


# In[11]:


pos_seq = []
lun = 0
for i in range(data_pos.shape[0]):
    if i % 1000 == 0:
        sys.stdout.write('Preproc progress: %f \r' % (i*100/data_pos.shape[0]))
        sys.stdout.flush()
 #       clear_output(wait=True)
    if data_pos.iloc[i,0].strip() == 'Pseudomonas benzenivorans':
        s = list(map(lambda x: int(ord(x)-65), list(data_pos.iloc[i,1].strip()))) + [data_pos.iloc[i,0].strip()]
    else:
        s = list(map(lambda x: int(ord(x)-65), list(data_pos.iloc[i,1].strip()))) + ['other']
    pos_seq.append(s)
pos_seq = np.asarray(pos_seq)


# In[12]:


neg_seq = []
lun = 0
for i in range(data_neg.shape[0]):
    if i % 1000 == 0:
        sys.stdout.write('Preproc progress: %f \r' % (i*100/data_neg.shape[0]))
        sys.stdout.flush()
#        clear_output(wait=True)
    if data_neg.iloc[i,0].strip() == 'Pseudomonas benzenivorans':
        s = list(map(lambda x: int(ord(x)-65), list(data_neg.iloc[i,1].strip()))) + [data_neg.iloc[i,0].strip()]
    else:
        s = list(map(lambda x: int(ord(x)-65), list(data_neg.iloc[i,1].strip()))) + ['other']
    neg_seq.append(s)
neg_seq = np.asarray(neg_seq)


# In[13]:


from sklearn.preprocessing import LabelBinarizer
X_enc = LabelBinarizer()
X_enc.fit(np.concatenate((neg_seq[:,:-1],pos_seq[:,:-1])).flatten().astype('str'))
y_enc = LabelEncoder()
y_enc.fit(np.concatenate((neg_seq[:,-1],pos_seq[:,-1])))


# In[14]:


kfold = KFold(n_splits=5,shuffle=True,random_state=7)


# In[15]:


split_pos = list(kfold.split(pos_seq[:,:-1],pos_seq[:,-1]))


# In[16]:


split_neg = list(kfold.split(neg_seq[:,:-1],neg_seq[:,-1]))


# In[19]:


cvscores = []  
cvcm = []
hloss = []                                                                      
hvalloss = []


# In[20]:


for f in range(5):
    model = Sequential()
    model.add(layers.Conv1D(filters=128,kernel_size=28, strides=1, activation='relu', input_shape=(250, 5)))
    #model.add(layers.MaxPooling1D(2))
    model.add(BatchNormalization())
    model.add(layers.Conv1D(filters=128,kernel_size=5, strides=1, activation='relu'))
    model.add(layers.MaxPooling1D(2))
    model.add(layers.Conv1D(filters=128,kernel_size=3, strides=1, activation='relu'))
    model.add(layers.GlobalMaxPooling1D())
    model.add(layers.Dense(2, activation='softmax'))
    
    opt = Adam(lr=0.0001, beta_1=0.9, beta_2=0.999, decay=0.0)
    model.compile(optimizer=opt, loss='categorical_crossentropy',metrics=['accuracy'])
    
    print("Fold: ("+str(f+1)+") ##########")
    pos_train = split_pos[f][0]
    pos_test = split_pos[f][1]
    neg_train = split_neg[f][0]
    neg_test = split_neg[f][1]
    
    X_train = np.concatenate((neg_seq[neg_train,:-1],pos_seq[pos_train,:-1]))
    y_train = np.concatenate((neg_seq[neg_train,-1],pos_seq[pos_train,-1]))
    X_test = np.concatenate((neg_seq[neg_test,:-1],pos_seq[pos_test,:-1]))
    y_test = np.concatenate((neg_seq[neg_test,-1],pos_seq[pos_test,-1]))
    
    X_train = np.asarray(list(map(lambda x: X_enc.transform(x.astype('str')),X_train)))
    X_test = np.asarray(list(map(lambda x: X_enc.transform(x.astype('str')),X_test)))
    
    y_train = y_enc.transform(y_train)
    y_train = np_utils.to_categorical(y_train)
    y_test = y_enc.transform(y_test)
    y_test = np_utils.to_categorical(y_test)
    
    print(X_train.shape)
    print(X_test.shape)
    
    history = model.fit(X_train, y_train, epochs=21, batch_size=250, verbose=1, validation_data=(X_test,y_test))
    
    hloss.append(history.history['loss'])                                       
    hvalloss.append(history.history['val_loss'])      
    
    pred = model.predict(X_test, batch_size=1, verbose=1)
    # evaluate the model                   
    cvcm.append(confusion_matrix(y_enc.inverse_transform(np.argmax(y_test, axis=1)),y_enc.inverse_transform(np.argmax(pred, axis=1))))
    scores = {}
    scores['precision'] = precision_score(y_enc.inverse_transform(np.argmax(y_test, axis=1)),y_enc.inverse_transform(np.argmax(pred, axis=1)), pos_label='Pseudomonas benzenivorans')
    scores['recall'] = recall_score(y_enc.inverse_transform(np.argmax(y_test, axis=1)),y_enc.inverse_transform(np.argmax(pred, axis=1)), pos_label='Pseudomonas benzenivorans')
    scores['f1'] = f1_score(y_enc.inverse_transform(np.argmax(y_test, axis=1)),y_enc.inverse_transform(np.argmax(pred, axis=1)), pos_label='Pseudomonas benzenivorans')
    cvscores.append(scores) 
    print("########## ##########")
    print("")
hlosss = np.average(hloss,axis=0)                                                
hvallosss = np.average(hvalloss,axis=0)  


# In[3]:


f = open('Pseudomonas_benzenivorans_CV_scores.pkl', 'wb')  
pickle.dump([cvscores,cvcm,hloss,hvalloss,hlosss,hvallosss], f)
f.close()
print("finito")

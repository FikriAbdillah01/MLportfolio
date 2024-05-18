## Machine Learning Operations Experiment

import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
import sklearn
import warnings
warnings.simplefilter('ignore')

df = pd.read_csv('WineQT.csv')

palette1 = sns.color_palette('RdYlBu')
def barplot (dataframe, y_plot):
    i = 0
    n = 1
    fig = plt.figure(figsize = (10,7))
    for i in y_plot:
        plt.subplot(len(y_plot),1,n)
        sns.barplot(data = dataframe, x = df['quality'], y = dataframe[i], palette=palette1).set(title = f'quality based on {[i]}')
        n += 1
    fig.tight_layout()
barplot(df, ['pH','citric acid', 'volatile acidity', 'alcohol'])
plt.savefig('barplot1.jpg', dpi = 100)

barplot(df, ['residual sugar', 'fixed acidity', 'total sulfur dioxide'])
plt.savefig('barplot of quality 2', dpi = 100)

barplot(df, ['citric acid', 'sulphates', 'alcohol', 'volatile acidity'])
plt.savefig('influence features', dpi = 100)

palette2 = sns.color_palette('RdGy')
def densityplot(dataframe, x_plot, y_plot):
    i = 0
    n = 1
    fig = plt.figure(figsize = (9,8))
    for i in x_plot:
        plt.subplot(len(x_plot),1, n)
        sns.kdeplot(data = dataframe, x = dataframe[i], y = y_plot, color='green', palette=palette2, fill = True, log_scale=False)
        n += 1
    fig.tight_layout()
    
densityplot(df, ['pH','citric acid', 'volatile acidity', 'density'], None)
plt.savefig('densityplot.jpg', dpi = 120)

densityplot(df, ['residual sugar', 'fixed acidity', 'total sulfur dioxide', 'quality', 'alcohol'], None)
plt.savefig('densityplot2.jpg', dpi = 120)

densityplot(df, ['alcohol', 'volatile acidity', 'sulphates', 'citric acid'], None)
plt.savefig('densityhighestinfluence.jpg', dpi = 120)

fig = plt.figure(figsize=(9,9))
sns.heatmap(data = df.drop('Id', axis =1).corr(), cmap = 'RdYlBu', annot=True)
fig.tight_layout()
plt.savefig('correlationdata.jpg', dpi = 300)

from sklearn.preprocessing import LabelEncoder

df2 = df.copy()

bins = (2, 6.5, 8)
wine = ['bad', 'good']
df2['quality'] = pd.cut(df2['quality'], bins = bins, labels  = wine)

encode = LabelEncoder()
df2['quality_code'] = encode.fit_transform(df2['quality'])

fig = plt.figure(figsize = (7,7))
sns.countplot(df2, x = df2['quality'])
plt.savefig('countplot.jpg', dpi = 120)


# Seperate Dataset
X = df2.drop(['quality', 'quality_code'], axis = 1)
y = df2['quality_code']

from sklearn.model_selection import train_test_split, GridSearchCV, cross_val_score
X_train, X_test, y_train, y_test = train_test_split(X,y,random_state=42)

from sklearn.metrics import accuracy_score, confusion_matrix, classification_report
def evaluation_score (test_var, prediction = rfc.predict(X_tst_sc)):
    rfc_acc = accuracy_score(test_var, prediction)
    conf_mat = confusion_matrix(test_var, prediction)
    plt.figure(figsize = (4,4))
    sns.heatmap(conf_mat, annot = True)
    print(f'accuracy score of Random Forest Classifier model is {rfc_acc}')
    print(classification_report(test_var, prediction))
    
with open('evaluation.txt','w') as outfile:
    outfile.write(evaluation_score(y_test))
    


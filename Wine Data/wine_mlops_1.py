
## Import Package

import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
import sklearn
import warnings
from sklearn.preprocessing import LabelEncoder, StandardScaler 
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.ensemble import RandomForestClassifier
from sklearn.svm import SVC
from sklearn.metrics import roc_auc_score, accuracy_score, average_precision_score, f1_score

warnings.simplefilter('ignore')

wine_ = 'wine_data/WineQT.csv'

def preprocessing (data):
    winedata = data.copy()
    bin = (2,6.5, 8)
    quality = ['bad', 'good']
    winedata['quality'] = pd.cut(winedata['quality'], bins = bin, labels=quality)
    return winedata
    
def encoding(wine_data):    
    encoder = LabelEncoder()
    wine_data['quality_code'] = encoder.fit_transform(wine_data['quality'])
    return wine_data

def fit_model (X_train, y_train):
    rfc = RandomForestClassifier(n_estimators = 200)
    rfc.fit(X_train, y_train)
    return rfc

def eval(mlmodel, X_test, y_test):
    y_pred = mlmodel.predict(X_test)
    return {
        'Accuracy': accuracy_score(y_test, y_pred), 
        'F1 Score':f1_score(y_test, y_pred)
        }


if __name__=="__main__":
    print('Processing...')
    df = pd.read_csv(wine_)
    
    print('Feature Engineering...')
    df1 = preprocessing(df)
    df2 = encoding(df1)
    
    X = df2.drop(['quality', 'quality_code'], axis = 1)
    y = df2['quality_code']
    
    print('Fitting...')
    X_train, X_test, y_train, y_test = train_test_split(X, y, random_state=42)
    fitting = fit_model(X_train, y_train)

    eval_score = eval(fitting, X_test, y_test)
    print('Evaluation Score: ')
    print(eval_score)





    
    


import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
import argparse
import joblib
import warnings
from sklearn.preprocessing import LabelEncoder, StandardScaler 
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.ensemble import RandomForestClassifier
from sklearn.svm import SVC
from sklearn.tree import DecisionTreeClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import roc_auc_score, accuracy_score, average_precision_score, f1_score, recall_score
from sklearn.model_selection import GridSearchCV
import mlflow.sklearn
import keras
from keras import Sequential

warnings.simplefilter('ignore')

wine_ = 'wine_data/WineQT.csv'
train_loc = 'wine_data/wine_train.csv'
test_loc = 'wine_data/wine_test.csv'
labels = 'quality'

def preprocessing (data):
    winedata = data.copy()
    bin = (2,6.5, 8)
    quality = ['bad', 'good']
    winedata['quality'] = pd.cut(winedata['quality'], bins = bin, labels=quality)
    return winedata
    
def encoding(wine_data):    
    le = LabelEncoder()
    wine_data['quality_code'] = le.fit_transform(wine_data['quality'])
    return wine_data

def wine_columns():
    df = pd.read_csv(wine_)
    return  print(df.columns)

def corr_matrices():
    df = pd.read_csv(wine_)
    fig = plt.figure(figsize=(8,8))
    corr_ = sns.heatmap(df.corr(), annot = True, cmap='YlGnBu')
    fig.tight_layout
    return print(corr_)

def fit_model(feature_train, label_train):
    print('Fit Decision Tree Classifier model....')
    dtc = DecisionTreeClassifier(ccp_alpha=0.0001, max_depth=9, min_samples_split=10)
    dtc.fit(feature_train, label_train)
    print('Fit Random Forest Classifier model...')
    rfc = RandomForestClassifier(n_estimators = 200, bootstrap=False, max_features=10)
    rfc.fit(feature_train, label_train)
    print('Fit Logistic Regression model...')
    lr = LogisticRegression()
    lr.fit(feature_train, label_train)
    return dtc, rfc, lr

def hyperparameter ():
    print('Import data...')
    train_ = pd.read_csv(train_loc)
    test_ = pd.read_csv(test_loc)
    
    #Splitting
    print('Splitting...')
    X_train, X_test = train_.drop(['quality', 'quality_code'], axis = 1), test_.drop(['quality', 'quality_code'], axis = 1)
    y_train, y_test = train_['quality_code'], test_['quality_code']

    #Encode
    print('Encoding...')
    sc = StandardScaler()
    X_train_sc = sc.fit_transform(X_train)
    X_test_sc = sc.fit_transform(X_test)
    
    print('Hyperparameter utilization in process...')
    rfc = RandomForestClassifier()
    dtc = DecisionTreeClassifier()

    classifier_model = [dtc, rfc]
    dtc_param = {'min_samples_split': range(10,500,20), 'max_depth': range(1,10,2), 'ccp_alpha': [0.0001,0.0005]}
    rfc_param = {'n_estimators': [100,200], 'max_features': [1,3,10], 'bootstrap': [False]}

    model_param = [dtc_param, rfc_param]

    cv_result = []
    best_estimators = []
    for i in range(len(model_param)):
        hyper_param = GridSearchCV(estimator=classifier_model[i], param_grid=model_param[i], scoring = 'recall', n_jobs=-1, cv = 2)
        hyper_param.fit(X_train_sc, y_train)
        cv_result.append(hyper_param.best_score_)
        best_estimators.append(hyper_param.best_estimator_)
        print('Recall Score ', cv_result[i])
        print('For Estimator ', best_estimators[i])
    

    return cv_result,best_estimators


def eval(mlmodel, feature_test, label_test):
    y_pred = mlmodel.predict(feature_test)
    return {
        'Accuracy: ': round(accuracy_score(label_test, y_pred), 2), 
        'F1 Score: ': round(f1_score(label_test, y_pred), 2),
        'Recall Score: ': round(recall_score(label_test, y_pred),2)
        }


def split(random_state = 42):
    print('Loading data...')
    df = pd.read_csv(wine_)
    df1 = preprocessing(df)
    df2 = encoding(df1)
    df2.to_csv('wine_data/new_wine_data.csv')
    train_data, test_data = train_test_split(df2, random_state = random_state)
    train_data.to_csv(train_loc)
    test_data.to_csv(test_loc)
    return df2

def fit():
    print('Load data....')
    train_ = pd.read_csv(train_loc)
    test_ = pd.read_csv(test_loc)
    
    #Splitting
    X_train, X_test = train_.drop(['quality', 'quality_code'], axis = 1), test_.drop(['quality', 'quality_code'], axis = 1)
    y_train, y_test = train_['quality_code'], test_['quality_code']

    #Encode data
    sc = StandardScaler()
    X_train_sc = sc.fit_transform(X_train)
    X_test_sc = sc.fit_transform(X_test)

    #Fitting model
    print('Fit model...')
    dtc_fit, rtc_fit, lr_fit = fit_model(X_train_sc,y_train)

    
    #Save trained model
    joblib.dump(dtc_fit, 'DecisionTree.joblib')
    joblib.dump(rtc_fit, 'RandomForest.joblib')
    joblib.dump(lr_fit, 'LogisticReg.joblib')

    #evaluation_model_1
    evaluation_1 = eval(dtc_fit, X_test_sc, y_test)
    print('Evaluation Decision Tree Model Result....')
    print(evaluation_1)

    #evaluation_model_2
    evaluation_2 = eval(rtc_fit, X_test_sc, y_test)
    print('Evaluation Random Forest Model Result...')
    print(evaluation_2)
    
    #evaluation_model_3
    evaluation_3 = eval(lr_fit, X_test_sc, y_test)
    print('Evaluation Logistic Regression Result...')
    print(evaluation_3)


def dl():
    

if __name__  ==  "__main__":
    parser = argparse.ArgumentParser()
    subparser = parser.add_subparsers(title = 'Train test split:',  dest = 'step')
    subparser.required = True
    split_parser = subparser.add_parser('split')
    split_parser.set_defaults(function=split)
    #figure_parser = subparser.add_parser('figure')
    #figure_parser.set_defaults(function=pictures)
    columns_parser = subparser.add_parser('columns')
    columns_parser.set_defaults(function = wine_columns)
    train_parser = subparser.add_parser('fit_model')
    train_parser.set_defaults(function = fit)
    hyperparam_parser = subparser.add_parser('tuning')
    hyperparam_parser.set_defaults(function = hyperparameter)
    corr_heat_parser = subparser.add_parser('corr')
    corr_heat_parser.set_defaults(function = corr_matrices)
    parser.parse_args().function()

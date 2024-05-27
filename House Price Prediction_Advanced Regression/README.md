# House Price Prediction Analysis

## Table of Content

-[Project Overview](#project-overview)

-[Background](#background)

-[Data Source](#data-sources)

-[Data Description](#data-description)

-[Tools](#tools)

-[Data Cleaning/Preprocessing](#result)

-[Exploration Data Analysis](#exploration-data-analysis-eda)

-[Result](#result)

-[Limitation](#limitation)

-[Reference](#references)

-[Appendix A: Feature Explanation](#appendix-a-feature-explanation)

-[Appendix B: Visualization](#appendix-b-visualization)

-[Appendix C: Build a machine learning](#-appendix-c-build-a-machine-learning)

---


### Project overview

The house price prediction data provied in order to give insight to client and real estate business owners. By considering a few of house features, we look for the suitable price of several houses for prospective homeowner, especially in Iowa.

### Background

The problem of this project is:

1. The price of some houses in Iowa real estate had been labeled. However, a few  of them with almost identical features do not yet have fixed price. So, the owners need data scientist's help to determine the tariff.

### Data Sources

This data posted by the Ames Housing Price website. Unfotunately, the web has been shut down without know the reason, hence the publish date still unknown. Luckilly, a kaggel user repost it as a competition in Kaggle web in 2016.

### Data Description

The data has 80 columns and about 1500 indexes. We took 89 features and 1 label to analyze. 

### Tools

The list of tools or libraries I used in this project:

- Scikit Learn

- Seaborn

- Matplotlib

- Pandas

### Data Cleaning/Preprocessing

In this step, we do:

1. Data loading

2. Cleaning
   
3. Handling `NaN` Value

4. Encoding some string datatype features

5. Drop some unrelated features (have numerous 0 value in it)

### Exploration Data Analysis (EDA)

This important step is to find out the anwer of the key questions, such as:

1. How accurate the house price prediction of the rest of the house?

2. What kind of house is the most sold in housing complex?

3. What is the minimum budget needed to purchase a house in Iowa?

### Result

After we analyze the data, the result we get:

1. Based on *Root Mean Square Error*, the score we get is around $0.3$. It means that the machine learning is accurate enough to predict the rest of the house price.

2. From the EDA step ([see Appendix B](#appendix-b-visualization), the majority of the house is built in range of 1800s and 1900s, have 4 rooms (including living room), garage, no pool, and average quality. However, some of the house built in 1900s and 2000s prices is slight expensive. Overall, whenever these houses were built, most of them were sold in fairly good quality.

3. Based on the distribution plot, the range price for most house of Iowa real estate is between $100.000 and $200.000. The homeowner candidate need at least $150.000 to purchase the average house (not including tax or another additional bill).   

### Recommendation

Based on the analysis, we recommend that:

1. The cost of the unlabeled houses is not far from the price-labeled ones, hence the clients do not worry about it and feel free to choose.

2. For the people who wants to live in a simple, comfotable, and affordable home, Iowa real estate provides it. Moreover, most of them are liveable even the home is quite old (referring to the year it was built).

3. Before purchase the house in Iowa, ask yourself and your family what kind of house you need to stay, what is the most important house feature do you need, the number of family do you bring to stay together, and so on. It filters what kind of house do you want to have.   

### Limitation

Unfortunately, the things you need to consider about this project:

1. The provided data is the list of houseprice in Iowa real estate in 2016, so it is unreliable information if you need the houseprice information in the other state or place. Moreover, the price of the house nowadays is rising up due to the inflation.

2. The data still have numerous outliers and zero values even after preprocessing step.

3. A few features with continous value is not well-distributed (skewed), so it affect to the prediction model.

### References

- [Anna Montoya, DataCanary. (2016). House Prices - Advanced Regression Techniques.](https://www.kaggle.com/competitions/house-prices-advanced-regression-techniques)

- [Bureau Labor Statistics: County Employment and Wages in Iowa - Second Quarter 2016](https://www.bls.gov/regions/midwest/news-release/2016/pdf/countyemploymentandwages_iowa_20161230.pdf)

### Appendix A: Feature Explanation

First, we used a correlation to filter what the most influence feature of the house to the Sale Price.

``` python
#Exploratory data analysis (feature selection)
k = 11
plt.figure(figsize = (12,9))
num_cols = df_train.select_dtypes(exclude = ['object'])
cols = num_cols.corr(method = 'pearson').nlargest(k, 'SalePrice')['SalePrice'].index
cm = np.corrcoef(num_cols[cols].values.T)
sns.set(font_scale = 0.87)
hm = sns.heatmap(cm, cbar = True, square = True, annot = True, fmt = '.2f', xticklabels = cols.values, yticklabels = cols.values)
plt.title('Highest Correlation of House Price')
plt.savefig('highest_corr_features.jpg', dpi = 200, bbox_inches = 'tight')

```


![correlation-feature](https://github.com/FikriAbdillah01/MLportfolio/blob/aa1c82cba9ca785139a051932144d7e531799649/House%20Price%20Prediction_Advanced%20Regression/fig/highest_corr_features.jpg)

The table below show a short description of highest correlation feature.

|No|Feature|Description|
|--|--|--|
|1|SalePrice|The Price of the house|
|2|OveralQuall|Overall material and finish quality|
|3|GrLivArea|Above grade (ground) living area square feet|
|4|GarageCars|Size of garage in car capacity|
|5|GarageArea|Size of garage in square feet|
|6|TotalBsmtSF|Total square feet of basement area in square feet|
|7|1stFlrSF|First Floor square feet|
|8|FullBath| Full bathrooms above grade (ground)|
|9|TotRmsAbvGrd|Total rooms above grade (does not include bathrooms)|
|10|YearBuilt|Original construction date in Year|
|11|YearRemodAdd|Remodel date in Year|

### Appendix B: Visualization

```python
#SalePrice vs Yearbuild
fig = plt.figure(figsize = (12,9))
p = sns.jointplot(data = df_train, x = df_train['YearBuilt'], y= df_train['SalePrice'], kind = 'hex')
p.fig.suptitle('House price vs year built')
fig.tight_layout()
plt.savefig('Distribution Plot of YearBuilt-SalePrice.jpg')
```
![Distribution Plot of YearBuilt-SalePrice.jpg](https://github.com/FikriAbdillah01/MLportfolio/blob/e1287440607297da147ae4456c16553dbdd5b2fe/House%20Price%20Prediction_Advanced%20Regression/fig/Distribution%20Plot%20of%20YearBuilt-SalePrice.png)



```python
#Quality of the house and its cost 
plt.figure(figsize = (10,5))
sns.barplot(data = df_train, x = 'OverallQual', y = 'SalePrice')
plt.title('House Price Based on Quality')
plt.savefig('Quality Saleprice Barplot.jpg')
```

![saleprice_quality_barplot](https://github.com/FikriAbdillah01/MLportfolio/blob/e1287440607297da147ae4456c16553dbdd5b2fe/House%20Price%20Prediction_Advanced%20Regression/fig/Quality%20Saleprice%20Barplot.jpg)

```python
#Counting the house based on the quality
sns.countplot(df_train, x = df_train['OverallQual'])
plt.title('Quality of the house (in total)')
plt.savefig('overallquality_house', dpi = 200)
```

![count](https://github.com/FikriAbdillah01/MLportfolio/blob/aa1c82cba9ca785139a051932144d7e531799649/House%20Price%20Prediction_Advanced%20Regression/fig/overallquality_house_total.png)

```python
# House SalePrice Distribution
#Gaussian Distribution of SalePrice
from scipy import stats
from scipy.stats import norm

sns.histplot(df_train['SalePrice'], kde = True, stat = 'density')
plt.savefig('densityplot', dpi=200)
```

![saleprice_yearbuild](https://github.com/FikriAbdillah01/MLportfolio/blob/ccd6b1f119d49d12c2beb47fa51c59582dd1780e/House%20Price%20Prediction_Advanced%20Regression/fig/distribution_plot_saleprice.png)

```python
#Gaussian Distribution of GarageX features
fig, axs = plt.subplots(1,2, figsize = (10,6))

df_train['GarageArea'].plot(kind = 'density', ax = axs[0], xlabel = 'GarageArea', title = 'Distribution of Garage Area', fontsize = 8)
axs[0].set_xlabel('Garage Area (in square feet)')
sns.countplot(data = df_train, x = df_train['GarageCars'], ax = axs[1])
axs[1].set_title('Size of the Garage (in cars)')
fig.tight_layout()
plt.savefig('densitygarage', dpi = 200)
```

![garagearea_denseplot_garagecars_countplot](https://github.com/FikriAbdillah01/MLportfolio/blob/ccd6b1f119d49d12c2beb47fa51c59582dd1780e/House%20Price%20Prediction_Advanced%20Regression/fig/densitygarage.png)

### Appendix C: Build a machine learning


```python

```


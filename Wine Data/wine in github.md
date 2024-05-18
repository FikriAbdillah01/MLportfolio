# Wine Quality Prediction
___
## Content
1. Introduction
2. Data Comprehension and Processing
4. Result
5. Conclusion
6. Reference
___
<p align = 'center'> <strong>Abstract</strong> </p>

The budget-efficiency and time is the important things for wine-maker to create a high-quality wine. The given dataset have several variables of wine and quality become the output. In this analysis, we will use 2 simple model, linear regression, and logistic regression, and utilize hyperparameter to find out the best parameter in terms of accuracy. (`Result and conclusion`)
<p align = 'center'><strong> 1. Introduction </strong></p>

Wine is the fermented juics of the grape and become the luxury symbol for mid-to-high class. Wine is not only drinkable, but also became one of many ingredients for cook. However, there are certain kind of grape that can be fermented. The grape genus Vitis (e.g. *Vitis vinifera* or called European grape) is one of them. This grape have been developed and recently reported that about 5000 wines is made from this grape. 

<img src = 'https://italianwinecentral.com/wp-content/uploads/Top-15-wine-producing-countries-2022.png'
     width = "400"
     height = "400"
     style = "display: block; margin: 0 auto">


According to [Forbes](https://www.forbes.com/sites/lizthach/2023/04/20/wine-exports-break-world-record-in-2022/?sh=258b7709451f), Italy be the most wine exporting countries and U.S. is the most wine consumers in 2022. Althought still in covid pandemic era, Italy shiped about 20 million hectolitre of wine of the beverage, followed by Spain and France. The overall production this year is nearly 260 milllion hectoliters. From this data, we can conclude that there is a lot of big fan of wine around the world and this post-fermented product is one of the daily needs either for cook or drink.

Winemaking is a series of the process to transform something into wine (e.g. grape). This process involves wide range of indicators (such as bacteria) which had significant influence and may cause negative attributes of some wines [2]. Some indicators such as pH and alcohol, volatile acidity, and etc could make wine  the best or the worst. So, as a data scientist, we are requested to analyze *what variable that can be significant influience of high or low of  wine quality*.

<p align = 'center'><strong> 2. Data Comprehension </strong></p>

The Wine Quality dataset is originally from [UC machine learning dataset](https://archive.ics.uci.edu/dataset/186/wine+quality). THis dataset is uploaded by Cortez from University of California Davis  and contain several variables of physicochemical of wine:

| No | Variables |
| :-: | :-: |
| 1 | `fixed acidity` |
| 2 | `volatile acidity` |
| 3 | `citric acid` |
| 4 | `residual sugar` |
| 5 | `chlorides` |
| 6 | `free sulfur dioxide` |
| 7 | `density` |
| 8 | `pH` |
| 9 | `sulphates` |
| 10 | `alcohol` |

We will give a brief explanation of these variables. The steps after get/download the data, we enter the data mining step. In this step, we check:

* Data duplication
* Null data
* 3M (mean, median, mode)
* Minimum and maximum value each feature
* Interval value between feature and label

<img src = 'http://localhost:8888/files/Documents/Machine%20Learning%20for%20Ameteurs/Wine%20Data/ML%20diagram%20dark.jpg?_xsrf=2%7Cd4ba3311%7C353852854771a3a9746ea98b54d06b72%7C1688104232'
     width = "600"
     height = "600"
     style = "display: block; margin: 0 auto"/>

These information are important to data scientist to determine what step should they take. The result shows that there is *_no null data, duplication, and significant difference of feature-feature and feature-label_*. After that, we explore this data  by showing some graph and some statistical method like p-value to test the null hypotesis. In the next step, we import some machine learning models. In this project, we use linear regression and logistic regression as a simple regression and classification model, respectively.

*Linear Regression* is an analytical model that focus on finding linear correlation among variables. This model is one of the supervised machine learning algorithm. In order to use linear regression  model, according to [IBM](https://www.ibm.com/topics/linear-regression#:~:text=Resources-,What%20is%20linear%20regression%3F,is%20called%20the%20independent%20variable) the data must pass through certain requirement:

* The variables must be continous. For example, sales and time.
* Use scatterplot to find out relationship between two variables
* The data have no significant outliers.

Mathematical formula that represent this model is

$$y = x\times b + a + e$$

where in machine learning, $y$ is a label (dependent variables), $x$ represent the features (independent variables) , $a$ is the intercept, $b$ is an estimation slope (coefficient), and $e$ is an error of the estimate. This equation only valid if the data have one feature. Unfortunately, a lot of datas always have more than one feature, hence the equation need to be modified. The math formula that suit with this case is

$$ y = b_0 + (\sum{x_i \times b_i}) + \epsilon$$

<img src = 'https://miro.medium.com/v2/resize:fit:1400/1*a3HFulvxQQM32dHOY_Dtqw.jpeg'
     width = "600"
     height = "600"
     style = "display: block; margin: 0 auto"/>

where $x_i$ is the $i^{th}$ predictors and $b_i$ is the the slope of $i^{th}$ predictors.   

Every model always need to be evaluated due to errors, including linear regression. In this case, evaluation method we use is Mean Absolute Error (MAE), Mean Squared Error (MSE), and $R^2$ or correlated coefficient. MAE is an average value of total errors of the model, whereas MSE is the squared of the total error. These evaluation models seems similar, which is involving sum of the error in their equations:
1. MAE evaluation

$$ MAE =  \frac {1}{n} \sum_{i} {|y_i - \hat{y}|} $$

2. MSE Evaluation

$$ MSE =  \frac {1}{n} \sum_{i} {(y_i - \hat{y})^2} $$

with $n$ represent total number of observation data, $\hat{y}$ is the average value of observation data, and $y$ is actual value for the $i^{th}$ observation.

$R^2$ or correlated coefficient is a statistical measure to inform how goodness of fit of a model. This method is commonly used to evaluate linear regression. If $R^2$ of a model is 0.5, it means that 
> The relationship between two variables (feature/label) explain 50% of the variance.

The math formula that represent $R^2$ is

$$R^2 = 1 - \frac{SSR}{SST}$$
        
$SSR$ (Sum Squared Regression) is sum of differentiation between observed value and predicted one, whereas $SST$ (Total Sum of Squares) is sum of the distance between observed value and mean of those values. The math formula of $SSR$ is

$$SSR = \sum_{i} (y_{i} - \hat{y})^2$$

$y_{i}$ and $\hat{y}$ is observed value and predicted value, respectively. Meanwhile, the equation of $SST$ is

$$SST = \sum_{i} (y_{i} - \bar{y})^2$$

$\bar{y}$ represent mean value of y-axis (target or label) of the data.

<img src="https://vitalflux.com/wp-content/uploads/2022/02/linear-regression-f-statistics-definition.jpg" 
        alt="Picture" 
        width="500" 
        height="600" 
        style="display: block; margin: 0 auto" />

*Logistic Regression* is one of the type of statistical model that oftenly used for classification and estimates the probability of  event occuring, such as getting promoted or not, based on a given dataset of independent variables (e.g. work experience).

<img src = "https://www.natasshaselvaraj.com/content/images/2022/11/Picture2-1.png"
     width = "500"
     height = "600"
     style = "display: block; margin: 0 auto"
/>
<em> Confusion Matrix </em>

Precision, recall, accuracy, and f1-score is an evaluation metrics of all classifier models. Precision means how precise the prediction are, recall represent how many positive samples are retrieved among predicted samples. Accuracy is metric that shows how prediction model gets right, and f1-score is harmonic mean of precision and  recall. These evaluation scores ia an unit called metric score.

Receiver Operator Characteristic (ROC) curve is a graphical plot showing the performance of classification model at all classification treshold. This curve plots two parameters:
1. True Positive Rate (TPR)
2. False Positive Rate (FPR)

True Positive Rate is the synonym of recall and is defined as follows:

$$TPR = \frac{TP}{TP + FN}$$

TP (True Positive),  means that how much predicted "NOT" is truly "NOT", whereas FP (False Negative) is how much you predicted "NOT" but actually "YES".

<img src = "https://static.packt-cdn.com/products/9781838555078/graphics/C13314_06_05.jpg"
     width = "600"
     height = "600"
     style = "display: block; margin: 0 auto"
/>

After we import the machine learning model, we seperate datasets into train and test datasets. If we have binary (classification) output or label dataset, we encode some of the features due to quite large difference of the feature-label value. Then we were fit and predict the separate dataset using linear and logistic regression (since this dataset could be considered as regression and classification dataset). 

Before we use hyperparameter, we evaluate the model by using several evaluation (e.g. confusion matrix, ROC, AUC, $R^2$, accuracy, and etc) in order to know how good the model is. If not, we will use the hyperparameter and input another model and its parameter into it to find the best model and the parameter. 
>__NOTE__: In this case, the label of wine dataset, *quality*, could be encoded into $0$ for low quality (from 0-6) and $1$ for high quality (7 and 8). 

<p align = 'center'> <strong>3. Result</strong> </p>

We have do several steps and utilize two different machine learning models. At exploratory data analysis process, we are using the Pearson Correlation method to know which psychochemical had significant impact to the quality of wine. The result of this method is:

1. `alcohol` (0.48)
2. `volatile acidity` (-0.41)
3. `citric acid`(0.22)
4. `sulphates` (0.26)

Every wine always have `alcohol` in it due to fermentation process. Suprisingly, the level of this physiochemical depends on amount of sugar of the grape at harvest time. The yeast consume the sugar and convert it into alcohol during fermentation.


`citric acid` is added to wines to increase acidity, complement of certain flavor, or give a *fresh* flavor. Unfortunately, this kind of acid make unwanted microbes grow. In the second bar plot, high quality wine (more than 6) contains about 0.4 g/L citric acid in average, makes them the highest compare to the low one (less than or equal to 6).

Volatile (gaseous) acidity is a measure to wine's volatile acids. One of the primary components of this acidity is *acetic acid*. This acid is also owned by a vinegar. Volatile acidity of the high-quality wines are the lowest compared to the low quality ones. It means that low quality wine's odor more like a vinegar

The other features have score below 0.2. If we add more `alcohol`, `citric acid`, and `sulphates`, the better the wine quality is. The Pearson Correlation shows that the `volatile acidity` minus sign. It means that the less of it, the better quality of wine. 

We also make the result of data by using Tableau 


<p align = 'center'> <strong>4. Conclusion</strong> </p>

Alcohol, citric acid, volatile acidity, and sulphates are the most influental aspects in winemaking. 

<p align = 'center'> <strong>5. Reference</strong> </p>

1. Bartowsky, E.J., Henschke, P.A., “The ‘buttery’ attribute of wine-diacetyl-desirability, spoilage and beyond. 2004. Int. J. of Food Microbiology 96: 235-255.

2. [Forbes - Wine exports Break World Record](https://www.forbes.com/sites/lizthach/2023/04/20/wine-exports-break-world-record-in-2022/?sh=258b7709451f) 

2. [Bohme, K. Barros-Velázquez, J. Calo-Mata, P. Red Wine Technology. Academic Press, 2019](https://www.sciencedirect.com/science/article/abs/pii/B9780128143995000086).

3. [Triola, M.F, Elementary Statistic 11th edition. Addison-Wesley, 2019]()

__

Fikri Abdillah @

___

Check my another project 
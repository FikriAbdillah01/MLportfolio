**Competition Description**
--

Ask a home buyer to describe their dream house, and they probably won't begin with the height of the basement ceiling or the proximity to an east-west railroad. But this playground competition's dataset proves that much more influences price negotiations than the number of bedrooms or a white-picket fence.

![House](https://img.freepik.com/free-photo/house-isolated-field_1303-23773.jpg?w=1380&t=st=1701754303~exp=1701754903~hmac=615879ebc6f9b03f827bdfc0608a647c0f0e26fd10c04f4e9e35bb62bfb1e511)

With 79 explanatory variables describing (almost) every aspect of residential homes in Ames, Iowa, this competition challenges you to predict the final price of each home.

Practice Skill
--

- Creative Feature Engineering
- Advanced Regression Technique

Acknowledgement
--

The Ames Housing dataset was compiled by Dean De Cock for use in data science education. It's an incredible alternative for data scientists looking for a modernized and expanded version of the often cited Boston Housing dataset. 

---

Evaluation
--

**Goal**

Predict the sales price for each house. For each ID in the test set, you must predict the value of the SalePrice variable.

**Metric**

Submissions are evaluated on **Root-Mean-Squared-Error (RMSE)** between the logarithm of the predicted value and the logarithm of the observed sales price. (Taking logs means that errors in predicting expensive houses and cheap houses will affect the result equally.)

Citation
--

Anna Montoya, DataCanary. (2016). House Prices - Advanced Regression Techniques. Kaggle. https://kaggle.com/competitions/house-prices-advanced-regression-techniques

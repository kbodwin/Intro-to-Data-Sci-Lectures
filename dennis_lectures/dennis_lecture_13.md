---
author:
- |
  Dennis Sun\
  Stanford University\
  DATASCI 112
date: |
  ![image](../logo){width="25pt"}\
  February 12, 2024
title: |
  Lecture 13\
  Model Selection and Hyperparameter Tuning
---

::: frame
:::

::: frame
:::

# Recap

::: frame
:::

::: frame
Here's a machine learning model.

The right way to evaluate machine learning models is *test error*,

``` {.python bgcolor="gray"}
from sklearn.model_selection import cross_val_score
scores = cross_val_score(
    pipeline,
    X=X_train, y=y_train,
    scoring="neg_mean_squared_error",
    cv=4)
-scores.mean()
```

    375.27166666666665
:::

# Model Selection and Hyperparameter Tuning

::: frame
:::

::: frame
Two Related Problems

**Model Selection** refers to the choice of:

-   which input features to include (e.g., winter rainfall, summer
    temperature)

-   what preprocessing to do (e.g., scaler)

-   what machine learning method to use (e.g., $k$-nearest neighbors)

**Hyperparameter Tuning** refers to the choice of parameters in the
machine learning method.

For $k$-nearest neighbors, hyperparameters include:

-   $k$

-   metric (e.g., Euclidean distance)

The distinction isn't important. We always use cross-validation and pick
the model / hyperparameter with the smallest test error.
:::

::: frame
Example of Model Selection

Which input features should we include?

-   winter rain, summer temp

-   winter rain, summer temp, harvest rain

-   winter rain, summer temp, harvest rain, Sept. temp

``` {.python bgcolor="gray"}
for features in [["win", "summer"],
                 ["win", "summer", "har"],
                 ["win", "summer", "har", "sep"]]:
  scores = cross_val_score(
      pipeline,
      X=df_train[features],
      y=df_train["price"],
      scoring="neg_mean_squared_error",
      cv=4)
  print(features, -scores.mean())
```

    ['win', 'summer'] 375.27166666666665
    ['win', 'summer', 'har'] 363.04047619047617
    ['win', 'summer', 'har', 'sep'] 402.4507142857142

[$\checkmark$]{style="color: blue"}
:::

::: frame
Example of Hyperparameter Tuning

What is the best value of $k$?

``` {.python bgcolor="gray"}
X_train = df_train[["win", "summer", "har"]]
```

``` {.python bgcolor="gray"}
ks, test_mses = range(1, 7), []
for k in ks:
  pipeline = make_pipeline(
      StandardScaler(),
      KNeighborsRegressor(n_neighbors=k, metric="euclidean"))
  scores = cross_val_score(
      pipeline, X_train, y_train,
      scoring="neg_mean_squared_error", cv=4)
  test_mses.append(-scores.mean())
```

``` {.python bgcolor="gray"}
pd.Series(test_mses, index=ks).plot.line()
```

![image](choosing_k){width=".8\\textwidth"}
:::

:::: frame
Training vs. Test Error

Here are the training and test MSEs on the same graph.

::: center
![image](test_vs_train){width=".6\\textwidth"}
:::

Notice that training MSE only goes down as we decrease $k$.

If we optimize for training MSE, then we will pick $k=1$, but this has
worse test MSE.

In other words, the $k=1$ model has **overfit** to the training data.
::::

# Grid Search

::: frame
:::

::: frame
Grid Search

Suppose we want to choose $k$ and the distance metric (Euclidean or
Manhattan).

We need to try all 12 combinations on the following grid:

Scikit-Learn's `GridSearchCV`{.python} automates the creation of a grid
with all combinations.
:::

:::: frame
Grid Search in Scikit-Learn

::: center
Let's try out `GridSearchCV`{.python} in a Colab.

[![image](../colab){width=".5\\textwidth"}](https://colab.research.google.com/drive/103rFB76yLyTthDU7DcBeAU0bfB1XUOIO#scrollTo=Grid_Search)
:::
::::

::: frame
Challenges with Grid Search

**Why can't all machine learning be automated by grid search?**

There were 5 input features in the original data (summer temp, harvest
rainfall, winter rainfall, Sept. temperature, age).

How many combinations of features would we need to try?

Now, combine this with the choice of $k$, distance metric, and scaler.

-   $6$ choices of $k$

-   $2$ choices of distance metric (Euclidean, Manhattan)

-   $2$ choices of scaler (`StandardScaler`{.python},
    `MinMaxScaler`{.python})

And that's not even considering models besides $k$-nearest neighbors!
:::

::: frame
Heuristics for Parameter Tuning

For large data sets, it is impossible to try every combination of models
and parameters.

So instead we use *heuristics*, which do not guarantee the best model
but tend to work well in practice.

-   **randomized search**: try random combinations of parameters,
    implemented in Scikit-Learn as `RandomizedSearchCV`{.python}.

-   **coordinate optimization**:

    -   start with guesses for all parameters,

    -   try all values for *one* parameter (holding the rest constant)
        and find the best value of that parameter,

    -   cycle through the parameters.

You will have the chance to practice this on Lab 4, which is a

![image](kaggle){width="\\textwidth"}

competition to build the best machine learning model. There will be
prizes for the winners!
:::

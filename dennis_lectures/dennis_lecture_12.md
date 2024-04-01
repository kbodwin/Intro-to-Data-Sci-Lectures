---
author:
- |
  Dennis Sun\
  Stanford University\
  DATASCI 112
date: |
  ![image](../logo){width="25pt"}\
  February 7, 2024
title: |
  Lecture 12\
  Evaluating Regression Models
---

::: frame
:::

::: frame
:::

# Recap

::: frame
:::

::: frame
Training and Test Data

The data for which we know the label $y$ is called the **training
data**.

The data for which we don't know $y$ (and want to predict it) is called
the **test data**.

``` {.python bgcolor="gray" fontsize="\\scriptsize"}
import pandas as pd

df = pd.read_csv("https://dlsun.github.io/pods/data/bordeaux.csv",
                 index_col="year")
df_train = df.loc[:1980].copy()
df_test = df.loc[1981:].copy()
```

Let's separate the inputs $X$ from the labels $y$.

``` {.python bgcolor="gray" fontsize="\\scriptsize"}
X_train = df_train[["win", "summer"]]
y_train = df_train["price"]

X_test = df_test[["win", "summer"]]
```
:::

:::: frame
$K$-Nearest Neighbors

We've seen one machine learning model: $k$-nearest neighbors.

``` {.python bgcolor="gray" fontsize="\\scriptsize"}
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.neighbors import KNeighborsRegressor

pipeline = make_pipeline(
          StandardScaler(),
          KNeighborsRegressor(n_neighbors=5))
pipeline.fit(X=X_train, y=y_train)
pipeline.predict(X=X_test)
```

``` {fontsize="\\scriptsize"}
array([35.8, 54. , 52.2, 18.4, 35.6, 13.2, 37. , 51.4, 36.6, 36.6, 40.6])
```

::: center
*Today:* How do we know if this model is any good?
:::
::::

# Measuring Error

::: frame
:::

::: frame
Prediction Error

If the true labels are $y_1, ..., y_n$ and our model predicts
$\hat y_1, ..., \hat y_n$, how do we measure how well our model did?

-   **mean squared error (MSE)**
    $$\text{MSE} = \frac{1}{n} \sum_{i=1}^n (y_i - \hat y_i)^2.$$

-   **mean absolute error (MAE)**
    $$\text{MAE} = \frac{1}{n} \sum_{i=1}^n  |y_i - \hat y_i|.$$

Calculating MSE or MAE requires data where true labels are known. Where
can we find such data?
:::

::: frame
Training Error

On the training data, the true labels $y_1, ..., y_n$ are known.

Let's calculate the **training error** of our model.

``` {.python bgcolor="gray"}
pipeline.fit(X_train, y_train)
y_train_ = pipeline.predict(X_train)
((y_train - y_train_) ** 2).mean()
```

    207.24148148148146

There's also a Scikit-Learn function for that!

``` {.python bgcolor="gray"}
from sklearn.metrics import mean_squared_error
mean_squared_error(y_train, y_train_)
```

    207.24148148148146

How do we interpret this MSE of $207.24$?

The square root is easier to interpret. The model is off by
$\sqrt{207.24} \approx \$14.40$ on average. This is called the **RMSE**.
:::

::: frame
The Problem with Training Error

What's the training error of a $1$-nearest neighbor model?

``` {.python bgcolor="gray" fontsize="\\scriptsize"}
pipeline = make_pipeline(
          StandardScaler(),
          KNeighborsRegressor(n_neighbors=1))
pipeline.fit(X=X_train, y=y_train)
y_train_ = pipeline.predict(X=X_train)
mean_squared_error(y_train, y_train_)
```

    0.0

Why did this happen?

A 1-nearest neighbor model will always be perfect on the training data.
But is it necessarily the best model?
:::

:::: frame
Test Error

We don't need to know how well our model does on *training data*.

We want to know how well it will do on *test data*.

In general, test error $>$ training error.

Analogy: A professor posts a practice exam before an exam.

-   If the actual exam is the same as the practice exam, how many points
    will students miss? That's training error.

-   If the actual exam is different from the practice exam, how many
    points will students miss? That's test error.

It's always easier to answer questions that you've seen before than
questions you haven't seen.

::: center
*Now:* How do we estimate the test error?
:::
::::

# Estimating Test Error

::: frame
:::

::: frame
Validation Set

The training data is the only data we have, where the true labels $y$
are known.

So one way to estimate the test error is to not use all of the training
data to fit the model, leaving the remaining data for estimating the
test error.
:::

:::: frame
Implementing the Validation Set

::: center
Let's implement this idea in a Colab!

[![image](../colab){width=".5\\textwidth"}](https://colab.research.google.com/drive/1FtPbwyaEaxR3eUR_JG773DqmkxKEbfU6#scrollTo=Estimating_Test_Error)
:::
::::

# Cross-Validation

::: frame
:::

::: frame
Cross-Validation

The way we split the data into two halves was arbitrary.
:::

::: frame
Implementing Cross-Validation from Scratch

Previously, we fit the model to the training set and evaluated the
predictions on the validation set.

``` {.python bgcolor="gray"}
pipeline.fit(X_train, y_train)
y_val_ = pipeline.predict(X_val)
mean_squared_error(y_val, y_val_)
```

    195.71428571428572

Now let's do the same thing, but with the roles of the training and
validation sets reversed.

``` {.python bgcolor="gray"}
pipeline.fit(X_val, y_val)
y_train_ = pipeline.predict(X_train)
mean_squared_error(y_train, y_train_)
```

    306.9230769230769

To come up with one overall estimate of the test error, we can average
them.

``` {.python bgcolor="gray"}
(195.71 + 306.92) / 2
```

    251.315
:::

::: frame
$K$-Fold Cross Validation

One problem with splitting the data into two is that we only fit the
model on half of the data.

A model trained on half of the data may be very different from a model
trained on all of the data.

It may be better to split the data into $K$ samples and come up with $K$
validation errors.

This way, we use $1 - 1/K$ of the data for training.
:::

::: frame
Implementing Cross-Validation in Scikit-Learn

You specify the model, data, and $K$. Scikit-Learn will:

-   split the training data into $K$ samples

-   hold out one sample at a time as a validation set

    -   fit the model to remaining $1 - 1/K$ of the data

    -   predict the labels on the validation set

    -   calculate the prediction error

``` {.python bgcolor="gray" fontsize="\\scriptsize"}
from sklearn.model_selection import cross_val_score
scores = cross_val_score(
    pipeline,
    X=df_train[["win", "summer"]],
    y=df_train["price"],         # this is all of the training data!
    scoring="neg_mean_squared_error", # higher is better for a score
    cv=4)
scores
```

``` {fontsize="\\scriptsize"}
array([-547.        , -405.85714286,  -67.        ,  -31.        ])
```

So an overall estimate of test MSE is:

``` {.python bgcolor="gray"}
-scores.mean()
```

    262.7142857142857
:::

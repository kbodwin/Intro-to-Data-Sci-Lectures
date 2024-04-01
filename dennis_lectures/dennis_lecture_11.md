---
author:
- |
  Dennis Sun\
  Stanford University\
  DATASCI 112
date: |
  ![image](../logo){width="25pt"}\
  February 2, 2024
title: |
  Lecture 11\
  $K$-Nearest Neighbors
---

::: frame
:::

::: frame
:::

# Prelude

::: frame
:::

:::: frame
What is Machine Learning?

**Learning**: devising a rule for making a decision based on inputs.

::: center
The decision $y$ is typically called the **target** or the **label**.
:::
::::

:::: frame
Two Types of Machine Learning Problems

Machine learning problems are grouped into two types, based on the type
of $y$:

**Regression:** The label $y$ is quantitative.

**Classification:** The label $y$ is categorical.

::: center
Note that the input features ${\bf x}$ may be categorical, quantitative,
or a mix of the two.
:::

We will initially focus on regression problems.
::::

::: frame
Predicting Wine Quality

![image](ashenfelter){width="\\textwidth"}

Orley Ashenfelter, an economics professor, used summer temperature and
winter rainfall to predict the price of Bordeaux wines.

``` {.python bgcolor="gray" fontsize="\\scriptsize"}
import pandas as pd

df = pd.read_csv("https://dlsun.github.io/pods/data/bordeaux.csv",
                 index_col="year")
df
```

![image](bordeaux_data){width="\\textwidth"}
:::

:::: frame
Visualizing the Data

``` {.python bgcolor="gray" fontsize="\\scriptsize"}
import plotly.express as px
import plotly.graph_objects as go

fig1 = px.scatter(df[~df["price"].isnull()],
                  x="win", y="summer", color="price")
fig2 = px.scatter(df[df["price"].isnull()],
                  x="win", y="summer", symbol_sequence=["circle-open"])

go.Figure(data=fig1.data + fig2.data, layout=fig1.layout)
```

::: center
:::
::::

::::: frame
Visualizing the Data

::: center
![image](bordeaux_scatter_with_neighbors){width=".7\\textwidth"}
:::

::: center
[Insight:]{.underline} The "closest" wines are low quality, so the 1986
vintage is probably low quality as well.

This is the intuition behind **$k$-nearest neighbors** regression.

Today: implementing $k$-nearest neighbors
:::
:::::

# $K$-Nearest Neighbors

::: frame
:::

::: frame
$K$-Nearest Neighbors

The data for which we know the label $y$ is called the **training
data**.

The data for which we don't know $y$ (and want to predict it) is called
the **test data**.

``` {.python bgcolor="gray"}
df_train = df.loc[:1980].copy()
df_test = df.loc[1981:].copy()
```

$K$-Nearest Neighbors

1.  For each observation in the test data, find the $k$ "nearest"
    observations in the training data based on input features ${\bf x}$
    (e.g., summer temperature and winter rainfall).

2.  To predict the label $y$ (e.g., price) for the test observation,
    average the labels of these $k$ "nearest" training observations.
:::

::: frame
$K$-Nearest Neighbors from Scratch

Before computing distances, we should scale the variables.

``` {.python bgcolor="gray" fontsize="\\scriptsize"}
X_train = df_train[["win", "summer"]]
y_train = df_train["price"]

# Standardize the features.
X_train_mean = X_train.mean()
X_train_sd = X_train.std()
X_train_scaled = (X_train - X_train_mean) / X_train_sd
```

We should scale the test data in exactly same way.

``` {.python bgcolor="gray" fontsize="\\scriptsize"}
X_test = df_test[["win", "summer"]]
X_test_scaled = (X_test - X_train_mean) / X_train_sd
X_test_scaled
```

![image](test_data){width=".15\\textwidth"}
:::

::: frame
$K$-Nearest Neighbors from Scratch

Next, we calculate the (Euclidean) distances between a vintage in the
test set and the vintages in the training data.

``` {.python bgcolor="gray" fontsize="\\scriptsize"}
import numpy as np
dists = np.sqrt(
    ((X_test_scaled.loc[1986] - X_train_scaled) ** 2).sum(axis=1))
dists
```

``` {fontsize="\\scriptsize"}
year
1952    1.259860
1953    1.159726
1955    1.314727
1957    1.149883
          ...   
1977    2.269387
1978    1.729248
1979    1.203287
1980    0.474508
Length: 27, dtype: float64
```

``` {.python bgcolor="gray" fontsize="\\scriptsize"}
index_nearest = dists.sort_values().index[:5]
index_nearest
```

``` {fontsize="\\scriptsize"}
Int64Index([1974, 1958, 1969, 1968, 1980], dtype='int64', name='year')
```
:::

::: frame
$K$-Nearest Neighbors from Scratch

Finally, to make a prediction, we average the labels $y$ of these $k=5$
nearest vintages in the training data.

``` {.python bgcolor="gray"}
y_train[index_nearest].mean()
```

    13.2

That's \$13.20 for a bottle of wine. So 1986 is not a good vintage.

How do we do this for every vintage in the test set?
:::

:::: frame
::: center
Let's go into Colab and predict the price for every vintage in the test
set.

[![image](../colab){width=".5\\textwidth"}](https://colab.research.google.com/drive/1cENSigDq7-bRzS-6QKurGONYiATGScvd?usp=sharing)
:::
::::

# $K$-Nearest Neighbors in Scikit-Learn

::: frame
:::

::: frame
$K$-Nearest Neighbors in Scikit-Learn

Scikit-learn provides a built-in model `KNeighborsRegressor`{.python}
that fits $k$-nearest neighbors regression models.

But first, we need to scale the training and test data.

``` {.python bgcolor="gray" fontsize="\\scriptsize"}
from sklearn.preprocessing import StandardScaler

scaler = StandardScaler()
scaler.fit(X_train)
X_train_scaled = scaler.transform(X_train)

# Scale the test data using a scaler that was fit to the training data!
X_test_scaled = scaler.transform(X_test)
```

Now, we fit $k$-nearest neighbors using `KNeighborsRegressor`{.python}.

``` {.python bgcolor="gray" fontsize="\\scriptsize"}
from sklearn.neighbors import KNeighborsRegressor

model = KNeighborsRegressor(n_neighbors=5)
model.fit(X=X_train_scaled, y=y_train)
model.predict(X=X_test_scaled)
```

``` {fontsize="\\scriptsize"}
array([35.8, 54. , 52.2, 18.4, 35.6, 13.2, 37. , 51.4, 36.6, 36.6, 40.6])
```
:::

::: frame
Pipelines in Scikit-Learn

In the code above, we had to be careful to standardize the training and
test data in exactly the same way.

Machine learning models typically involve many more preprocessing steps.

Scikit-Learn's `Pipeline`{.python} allows us to chain steps together.

``` {.python bgcolor="gray"}
from sklearn.pipeline import make_pipeline

pipeline = make_pipeline(
          StandardScaler(),
          KNeighborsRegressor(n_neighbors=5))
```

We can use this `Pipeline`{.python} like any other machine learning
model.

``` {.python bgcolor="gray"}
pipeline.fit(X=X_train, y=y_train)
pipeline.predict(X=X_test)
```

``` {fontsize="\\scriptsize"}
array([35.8, 54. , 52.2, 18.4, 35.6, 13.2, 37. , 51.4, 36.6, 36.6, 40.6])
```
:::

# Postlude

::: frame
:::

:::: frame
Was Ashenfelter Right?

::: center
Here is how the vintages rank today:

![image](bordeaux_vintages){width=".75\\textwidth"}

Ashenfelter was wrong that 1986 would be a disappointing vintage!
:::
::::

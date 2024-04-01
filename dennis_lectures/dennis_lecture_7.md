---
author:
- |
  Dennis Sun\
  Stanford University\
  DATASCI 112
date: |
  ![image](../logo){width="25pt"}\
  January 24, 2024
title: |
  Lecture 7\
  Encoding Categorical Variables as Quantitative
---

::: frame
:::

# Motivation

::: frame
:::

::: frame
Review

``` {.python bgcolor="gray" fontsize="\\scriptsize"}
features = ["Gr Liv Area", "Bedroom AbvGr", "Full Bath", "Half Bath"]
df[features]
```

![image](quant){height=".45\\textheight"}

Last class, we discussed how to measure the distance between two
observations $\varname{x}$ and $\varname{x}'$.

For example, we can calculate the Euclidean ($\ell_2$) distance:
$$d(\varname{x}, \varname{x}') = \sqrt{\sum_{j=1}^m (x_j - x'_j)^2}.$$
:::

::: frame
What if there are categorical variables?

``` {.python bgcolor="gray" fontsize="\\scriptsize"}
features = ["Gr Liv Area", "House Style", "Bedroom AbvGr", 
            "Full Bath", "Half Bath", "Neighborhood"]
df[features]
```

![image](mixed){height=".45\\textheight"}
:::

# Encoding Categorical Variables

::: frame
:::

::: frame
Encoding Categorical Variables as Quantitative

There is a standard way to encode a categorical variable as a
quantitative variable: **dummy encoding** or **one-hot encoding**.

![image](house_style){height=".4\\textheight"}

$\Longrightarrow$

-   Each class gets its own column.

-   Each column consists of $0$s and $1$s. A $1$ indicates that the
    observation was in that class.

1.  How many $1$s are in each row?

2.  How many $1$s are in each column?
:::

:::: frame
Dummy Encoding in Pandas

Let's go into Colab to learn how to do dummy encoding in Pandas.

::: center
[![image](../colab){width=".2\\textwidth"}](https://colab.research.google.com/drive/1giD3dk69A5jtERH2W5ciKNIrrt3ypbJQ#scrollTo=wngbzzaO0D32&line=1&uniqifier=1)
:::
::::

# Column Transformations in Scikit-Learn

::: frame
:::

::: frame
Dummy Encoding in Scikit-Learn

We can do dummy encoding in Scikit-Learn using `OneHotEncoder`{.python}.

``` {.python bgcolor="gray"}
from sklearn.preprocessing import OneHotEncoder

# declare the encoder
enc = OneHotEncoder()

# fit the encoder to data
enc.fit(df[["House Style"]])

# transform the data
enc.transform(df[["House Style"]])
```

    <2930x8 sparse matrix of type '<class 'numpy.float64'>'
        with 2930 stored elements in Compressed Sparse Row format>
:::

::: frame
Dummy Encoding in Scikit-Learn

We can cast a sparse matrix to a "dense" one using
`.todense()`{.python}\...

\...or specify that we don't want a sparse matrix to begin with.

``` {.python bgcolor="gray" escapeinside="||"}
from sklearn.preprocessing import OneHotEncoder

# declare the encoder
enc = OneHotEncoder(|\textcolor{red}{sparse\_output=}|False)

# fit the encoder to data
enc.fit(df[["House Style"]])

# transform the data
enc.transform(df[["House Style"]])
```

``` {fontsize="\\scriptsize"}
array([[0., 0., 1., ..., 0., 0., 0.],
       [0., 0., 1., ..., 0., 0., 0.],
       [0., 0., 1., ..., 0., 0., 0.],
       ...,
       [0., 0., 0., ..., 0., 1., 0.],
       [0., 0., 1., ..., 0., 0., 0.],
       [0., 0., 0., ..., 1., 0., 0.]])
```
:::

::: frame
Mixed Variables in Scikit-Learn

What if we have a mix of quantitative and categorical variables, and we
only want to dummy encode the categorical ones?

We make a `ColumnTransformer`{.python}.

``` {.python bgcolor="gray"}
from sklearn.compose import make_column_transformer

enc = make_column_transformer(
    (OneHotEncoder(), ["House Style", "Neighborhood"]),
    remainder="passthrough")
enc.fit(df[features])
enc.transform(df[features])
```

    <2930x40 sparse matrix of type '<class 'numpy.float64'>'
        with 15717 stored elements in Compressed Sparse Row format>
:::

::: frame
Mixed Variables in Scikit-Learn

What if we have a mix of quantitative and categorical variables, and we
only want to dummy encode the categorical ones?

We make a `ColumnTransformer`{.python}.

``` {.python bgcolor="gray" escapeinside="||"}
from sklearn.compose import make_column_transformer

transformer = make_column_transformer(
    (OneHotEncoder(sparse_output=False), ["House Style",
                                          "Neighborhood"]),
    remainder="passthrough")
transformer.fit(df[features])
transformer.transform(df[features])
```

    array([[0., 0., 1., ..., 3., 1., 0.],
           [0., 0., 1., ..., 2., 1., 0.],
           [0., 0., 1., ..., 3., 1., 1.],
           ...,
           [0., 0., 0., ..., 3., 1., 0.],
           [0., 0., 1., ..., 2., 1., 0.],
           [0., 0., 0., ..., 3., 2., 1.]])
:::

::: frame
Visualizing a `ColumnTransformer`

Scikit-Learn provides a nice visualization of a
`ColumnTransformer`{.python}.

``` {.python bgcolor="gray" escapeinside="||"}
transformer
```

![image](transformer1){width=".5\\textwidth"}
:::

::: frame
Scaling and Encoding in Scikit-Learn

We can mix scalers and encoders with `ColumnTransformer`{.python}!

``` {.python bgcolor="gray"}
from sklearn.preprocessing import StandardScaler

transformer = make_column_transformer(
    (OneHotEncoder(sparse_output=False), ["House Style",
                                          "Neighborhood"]),
    (StandardScaler(), ["Gr Liv Area"]),
    remainder="passthrough")
transformer.fit(df[features])
transformer.transform(df[features])
```

    array([[0., 0., 1., ..., 3., 1., 0.],
           [0., 0., 1., ..., 2., 1., 0.],
           [0., 0., 1., ..., 3., 1., 1.],
           ...,
           [0., 0., 0., ..., 3., 1., 0.],
           [0., 0., 1., ..., 2., 1., 0.],
           [0., 0., 0., ..., 3., 2., 1.]])
:::

::: frame
Scaling and Encoding in Scikit-Learn

Let's visualize this `ColumnTransformer`{.python} as well.

``` {.python bgcolor="gray" escapeinside="||"}
transformer
```

![image](transformer2){width=".75\\textwidth"}
:::

::: frame
A Look Ahead

In section tomorrow, you will put all the pieces from the last two
lectures together.

1.  Convert categorical variables to quantitative variables.

2.  Calculate distances on the transformed data to solve a real problem.
:::

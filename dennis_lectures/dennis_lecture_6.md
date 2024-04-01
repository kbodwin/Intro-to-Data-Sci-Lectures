---
author:
- |
  Dennis Sun\
  Stanford University\
  DATASCI 112
date: |
  ![image](../logo){width="25pt"}\
  January 22, 2024
title: |
  Lecture 6\
  Distances between Observations
---

::: frame
:::

::: frame
Ames House Prices

**Today's Data:** Houses in Ames, IA

``` {.python bgcolor="gray"}
import pandas as pd
df = pd.read_table("https://datasci112.stanford.edu/data/housing.tsv")
df
```

![image](dataframe){width="\\textwidth"}
:::

::: frame
Square Footage and Bedrooms

We've seen how to visualize and summarize the relationship between two
quantitative variables.

``` {.python bgcolor="gray"}
df.plot.scatter(x="Gr Liv Area", y="Bedroom AbvGr", alpha=0.4)
df[["Gr Liv Area", "Bedroom AbvGr"]].corr()
```

![image](correlation){width=".35\\textwidth"}

![image](sqft_vs_bedroom){width=".6\\textwidth"}
:::

# Distances between Observations

::: frame
:::

::: frame
Quantifying Similarity

How do we measure how "similar" two observations are?

For example, how would we quantify how similar the following two houses
are?

![image](sqft_vs_bedroom_points){width=".6\\textwidth"}
:::

::: frame
Calculating Distance

One way is to calculate the distance between the two points.
:::

:::: frame
Calculating Distance in Higher Dimensions

The distance formula generalizes to any number of variables $m$.
$$d({\bf x}, {\bf x}') = \sqrt{\sum_{j=1}^m (x_j - x'_j)^2}$$

Let's calculate the distance between these two houses, based on $m=4$
variables: square footage, bedrooms, full baths, and half baths.

::: center
[![image](../colab){width=".2\\textwidth"}](https://colab.research.google.com/drive/11hzIl5EDzgqG0Sud3jNX_AzEuykqKPns#scrollTo=ByTiJnlaKTt_&line=1&uniqifier=1)
:::
::::

# Variable Scaling

::: frame
:::

::: frame
The Importance of Scale

  ----------------------------------------------------- --
                This plot is misleading.                
   ![image](sqft_vs_bedroom){height=".45\\textheight"}  
  ----------------------------------------------------- --

The variability in square footage is so large that the variation in the
number of bedrooms hardly affects the distance at all.

We should bring all the variables to the same scale before calculating
distance.
:::

::: frame
Standardization

We've seen one way to bring different variables to the same scale:
**standardization**.
$$x_i \leftarrow \frac{x_i - \bar{\varname{x}}}{\text{sd}(\varname{x})}$$

``` {.python bgcolor="gray" fontsize="\\scriptsize"}
features = ["Gr Liv Area", "Bedroom AbvGr", "Full Bath", "Half Bath"]
df_standardized = ((df[features] - df[features].mean(axis="rows")) /
                   df[features].std(axis="rows"))
df_standardized
```

![image](dataframe_std){width=".47\\textwidth"}
:::

::: frame
The Effect of Standardization

What did standardization do?

``` {.python bgcolor="gray"}
df_standardized.plot.scatter(
    x="Gr Liv Area", y="Bedroom AbvGr", alpha=0.4)
```

![image](sqft_vs_bedroom_std){width=".6\\textwidth"}

Standardization ensures that every variable has mean $0$ and standard
deviation $1$ so that every variable is treated equally.
:::

::: frame
Finding the Most Similar Home

Let's find the most similar house by calculating distances on the
*standardized* data.

``` {.python bgcolor="gray" fontsize="\\scriptsize"}
import numpy as np
diffs = df_standardized - df_standardized.loc[1707]
dists = np.sqrt((diffs ** 2).sum(axis="columns"))
dists.sort_values()
```

``` {fontsize="\\scriptsize"}
1707    0.000000
160     0.043521
909     0.249254
2592    0.625113
585     0.625113
          ...   
2880    8.024014
1385    8.050646
2279    8.095655
158     8.225392
2723    8.313887
Length: 2930, dtype: float64
```

Now the most similar house to #1707 is #160, which matches our intuition
when we looked at the data.
:::

# Calculating Distances in Scikit-Learn

::: frame
:::

::: frame
Scaling in Scikit-Learn

The machine learning library Scikit-Learn can be used to scale variables
and calculate distances.

``` {.python bgcolor="gray" fontsize="\\scriptsize"}
from sklearn.preprocessing import StandardScaler

scaler = StandardScaler()

# This calculates the mean and standard deviation of each variable.
scaler.fit(df[features])

# This actually does the standardization.
array_standardized = scaler.transform(df[features])
array_standardized
```

``` {fontsize="\\tiny"}
array([[ 0.30926506,  0.17609421, -1.02479289, -0.75520269],
       [-1.19442705, -1.03223376, -1.02479289, -0.75520269],
       [-0.33771825,  0.17609421, -1.02479289,  1.23467491],
       ...,
       [-1.04801492,  0.17609421, -1.02479289, -0.75520269],
       [-0.21900572, -1.03223376, -1.02479289, -0.75520269],
       [ 0.9898836 ,  0.17609421,  0.7840283 ,  1.23467491]])
```
:::

# Summary

::: frame
:::

::: frame
Summary

To measure the similarity between two observations, we calculate the
distance between them.

We need to be first make sure that all the variables are on the same
scale.

There are actually different choices of scalings and distance metrics,
which you will explore in section tomorrow.

**Scaling Variables**

-   Standardization
    $$x_i \leftarrow \frac{x_i - \bar{\varname{x}}}{\text{sd}(\varname{x})}$$

-   Min-Max Scaling
    $$x_i \leftarrow \frac{x_i - \text{min}(\varname{x})}{\text{max}(\varname{x}) - \text{min}(\varname{x})}$$

**Distance Metrics**

-   Euclidean ($\ell_2$)

    $$\sqrt{\sum_{j=1}^m (x_j - x'_j)^2}$$

-   Manhattan ($\ell_1$)

    $$\sum_{j=1}^m |x_j - x'_j|$$
:::

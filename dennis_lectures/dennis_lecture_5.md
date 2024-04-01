---
author:
- |
  Dennis Sun\
  Stanford University\
  DATASCI 112
date: |
  ![image](../logo){width="25pt"}\
  January 19, 2024
title: Multivariate Data and the Grammar of Graphics
---

::: frame
:::

:::: frame
Palmer Penguins

**Today's Data:** Penguins in the Palmer Archipelago, Antarctica.

::: center
![image](chinstrap){width=".6\\textwidth"}\
![image](adelie){width=".4\\textwidth"}
![image](gentoo){width=".327\\textwidth"}
:::
::::

::: frame
Palmer Penguins

``` {.python bgcolor="gray" fontsize="\\scriptsize"}
import pandas as pd
df = pd.read_csv("https://datasci112.stanford.edu/data/penguins.csv")
df
```

![image](data){width=".8\\textwidth"}

![image](culmen_depth){width=".6\\textwidth"}
:::

::: frame
Review

1.  relationships between two categorical variables

    ::: overprint
    ``` {.python bgcolor="gray"}
    df[["species", "island"]].value_counts()
    ```

    ``` {.python bgcolor="gray" escapeinside="||"}
    df[["species", "island"]].value_counts()|\textcolor{red}{.unstack()}|
    ```

    ``` {.python bgcolor="gray" escapeinside="||"}
    df[["species", "island"]].value_counts().unstack()|\textcolor{red}{.fillna(0)}|
    ```
    :::

    ::: onlyenv
    \<3\|handout:0\>

    ``` {fontsize="\\small"}
    species    island   
    Gentoo     Biscoe       124
    Chinstrap  Dream         68
    Adelie     Dream         56
               Torgersen     52
               Biscoe        44
    dtype: int64
    ```
    :::

2.  relationships between categorical and quantitative variables

    ::: overprint
    ``` {.python bgcolor="gray"}
    df.groupby("species")[["bill_length_mm", "bill_depth_mm"]].mean()
    ```
    :::
:::

# Relationships between Quantitative Variables

::: frame
:::

::: frame
Visualizing the Relationship

The relationship between two quantitative variables can be visualized
using a **scatterplot**.

``` {.python bgcolor="gray"}
df.plot.scatter(x="bill_length_mm", y="bill_depth_mm")
```

![image](scatterplot){width=".7\\textwidth"}
:::

::: frame
Summarizing the Relationship

The relationship between two quantitative variables and can be
summarized using the **correlation coefficient** $r$.
$$r = \frac{\sum_{i=1}^n \frac{x_i - \bar{\varname{x}}}{\textrm{sd}(\varname{x})} \cdot \frac{y_i - \bar{\varname{y}}}{\textrm{sd}(\varname{y})} }{n - 1}$$

``` {.python bgcolor="gray" fontsize="\\scriptsize"}
x = df["bill_length_mm"]
y = df["bill_depth_mm"]
n = (~x.isnull() & ~y.isnull()).sum()

(((x - x.mean()) / x.std()) * ((y - y.mean()) / y.std())).sum() / (n - 1)
```

`-0.2350528703555327`
:::

::: frame
Correlation Coefficient

-   A positive correlation means that as increases, tends to increase
    also.

-   A negative correlation means that as increases, tends to decrease.

-   The correlation coefficient $r$ is always between $-1$ and $1$.

-   The closer the correlation coefficient is to $\pm 1$, the stronger
    the relationship.
:::

:::: frame
Correlation Coefficient

Of course, there's a built-in function for calculating $r$.

``` {.python bgcolor="gray"}
df[["bill_length_mm", "bill_depth_mm"]].corr()
```

::: center
![image](correlation){width=".7\\textwidth"}
:::

This is called the **correlation matrix**.

Why are the correlation coefficients on the diagonal equal to $1.0$?
::::

# Multivariate Data

::: frame
:::

:::: frame
Beyond Two Variables

But wait! There were also different penguin species.

::: center
  ----------------------------------------- ----------------------------------------- --------------------------------------------
   ![image](adelie){width=".3\\textwidth"}   ![image](gentoo){width=".3\\textwidth"}   ![image](chinstrap){width=".3\\textwidth"}
                   Adelie                                    Gentoo                                    Chinstrap
  ----------------------------------------- ----------------------------------------- --------------------------------------------
:::

How do we incorporate another variable into our analysis?
::::

:::: frame
Multivariate Data

> "The world is complex, dynamic, multidimensional; the paper is static,
> flat. How are we to represent the rich visual world of experience and
> measurement on mere flatland?"

> "Escaping this flatland is the essential task of envisioning
> information---for all the interesting worlds (physical, biological,
> imaginary, human) that we seek to understand are inevitably and
> happily multivariate in nature."

-- Edward Tufte, *Envisioning Information*

::: center
![image](tufte){width=".32\\textwidth"}
:::
::::

:::: frame
Map of Napoleon's Russia Campaign

![image](charles_joseph_minard){width="\\textwidth"}

The French civil engineer Charles Joseph Minard (1781--1870) made the
following visualization of Napoleon's Russia campaign of 1812.

::: center
![image](minard){width="\\textwidth"}
:::

Tufte calls this the "best statistical graphic ever drawn."
::::

:::::: frame
Aesthetic Mappings

How do we visualize multivariate data on two-dimensional paper or
screen?

::: center
:::

::: itemize
:::

::: itemize
:::
::::::

::: frame
Aesthetics

![image](size){height=".28\\textheight"}
![image](hue_intensity){height=".28\\textheight"}

Which aesthetics are associated with quantitative variables?

Which are associated with categorical variables?
:::

:::: frame
Facets

::: center
One way to pack more variables without overplotting is to show many
small plots. (Tufte calls this "small multiples.")

![image](gelman){height=".9\\textheight"}
:::
::::

::: frame
Grammar of Graphics

The **grammar of graphics** says that every plot can be described by
just a few components:

-   aesthetic mappings

-   geometric objects (e.g., points, lines, bars)

-   \...and a few other things.

The ideal library generates a plot from a specification of the aesthetic
mappings and the geometric object.

-   x $\longleftarrow$ longitude

-   y $\longleftarrow$ latitude

-   width $\longleftarrow$ size of army

-   color $\longleftarrow$ direction of army
:::

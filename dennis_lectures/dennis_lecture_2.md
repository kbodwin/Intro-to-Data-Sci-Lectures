---
author:
- |
  Dennis Sun\
  Stanford University\
date: |
  ![image](../logo){width="25pt"}\
  January 10, 2024
title: |
  Lecture 2\
  Relationships between Categorical Variables
---

::: frame
:::

::: frame
:::

# Review

::: frame
:::

:::: frame
Types of Data

::: center
  **Type**   **On Disk**   **In Python**
  ---------- ------------- ---------------
  tabular                  
                           
                           
                           
:::
::::

::: frame
Types of Variables

``` {.python bgcolor="gray"}
import pandas as pd
df = pd.read_csv("https://datasci112.stanford.edu/data/titanic.csv")
df
```
:::

::: frame
One Categorical Variable

To *summarize* a categorical variable, we report the **counts** of each
possible category.

``` {.python bgcolor="gray"}
df["pclass"].value_counts().sort_index()
```

``` {fontsize="\\tiny"}
1    323
2    277
3    709
Name: pclass, dtype: int64
```

To *visualize* a categorical variable, we make a **bar plot**.

``` {.python bgcolor="gray"}
df["pclass"].value_counts().sort_index().plot.bar()
```

![image](pclass_barplot_ordered.png){width="\\textwidth"}
:::

# Two (or More) Categorical Variables

::: frame
:::

::: frame
Selecting Columns

Note that we selected a single column by passing the column name as a
key to the `DataFrame`{.python}.

``` {.python bgcolor="gray"}
df["pclass"]
```

``` {fontsize="\\tiny"}
0       1
1       1
2       1
       ..
1306    3
1307    3
1308    3
Name: pclass, Length: 1309, dtype: int64
```

The result is a one-dimensional `pandas` object called a
`Series`{.python}.

``` {.python bgcolor="gray"}
df[["pclass", "survived"]]
```

![image](two_columns){width="\\textwidth"}

The result is two-dimensional, another smaller `DataFrame`{.python}.

How do we make sense of multiple variables at once?
:::

::: frame
Summarizing Multiple Categorical Variables

To summarize multiple categorical variables, we report the **counts** of
every possible combination of categories.

We can use the `.value_counts()`{.python} method of
`DataFrame`{.python}.

``` {.python bgcolor="gray"}
df[["pclass", "survived"]].value_counts()
```

    pclass  survived
    3       0           528
    1       1           200
    3       1           181
    2       0           158
    1       0           123
    2       1           119
    dtype: int64

Note that the result is a `Series`{.python}, with a multi-level index,
one for each variable!
:::

::: frame
Summarizing Multiple Categorical Variables

    pclass  survived
    3       0           528
    1       1           200
    3       1           181
    2       0           158
    1       0           123
    2       1           119
    dtype: int64

Let's make this information easier to read by arranging one variable
along the rows and the other along the columns.

``` {.python bgcolor="gray"}
(df[["pclass", "survived"]].value_counts().
 unstack())
```

![image](crosstab){width="\\textwidth"}

This representation is called a **two-way table** or a **crosstab**
(short for "cross-tabulation").
:::

::: frame
Visualizing Multiple Categorical Variables

![image](crosstab){width="\\textwidth"}

From a crosstab, we can make a bar plot to visualize the data.

``` {.python bgcolor="gray"}
(df[["pclass", "survived"]].value_counts().
 unstack().
 plot.bar())
```

![image](crosstab_bar){width="\\textwidth"}

This is called a **grouped bar plot**.
:::

::: frame
Marginal Counts

How do we recover the counts for each individual variable from a
crosstab?

``` {.python bgcolor="gray"}
crosstab = df[["pclass", "survived"]].value_counts().unstack()
crosstab
```

![image](crosstab){width="\\textwidth"}

We could sum over the columns (across each row) to obtain the counts for
\...

``` {.python bgcolor="gray"}
crosstab.sum(axis="columns")
```

``` {fontsize="\\scriptsize"}
pclass
1    323
2    277
3    709
dtype: int64
```
:::

::: frame
Marginal Counts

How do we recover the counts for each individual variable from a
crosstab?

``` {.python bgcolor="gray"}
crosstab = df[["pclass", "survived"]].value_counts().unstack()
crosstab
```

![image](crosstab){width="\\textwidth"}

\...or sum over the rows (down each column) to obtain the counts for .

``` {.python bgcolor="gray"}
crosstab.sum(axis="rows")
```

``` {fontsize="\\scriptsize"}
survived
0    809
1    500
dtype: int64
```
:::

# Proportions and Probabilities

::: frame
:::

::: frame
Proportions

Instead of counts, it can be useful to report **proportions**, where we
normalize by the total.
$$\onslide<2->{\textrm{proportion} = \frac{\textrm{count}}{\textrm{total}}.}$$

For example, the proportions of the three passenger classes are:

``` {.python bgcolor="gray"}
df["pclass"].value_counts() / len(df)
```

    3    0.541635
    1    0.246753
    2    0.211612
    Name: pclass, dtype: float64
:::

::: frame
Probabilities

What does it mean to say, "The proportion of passengers in 3rd class is
$0.541635$?"

One interpretation is as a **probability**.

"If we were to pick a passenger on the Titanic at random, the
probability that they are in 3rd class is $0.541635$."

We notate this as $$P(\textrm{3rd class}) = 0.541635$$ or, if we want to
be explicit about the variable and the category,
$$P(\varname{pclass} = 3) = 0.541635$$
:::

::: frame
Vectorization

Let's take a closer look at the code for calculating the proportions.

``` {.python bgcolor="gray"}
df["pclass"].value_counts() / len(df)
```

Notice that we divided a `Series`{.python} by a number! Is that even
legal?

In `pandas`, operations are **vectorized**. A `Series`{.python} behaves
like a vector.

Vectors in `pandas` work like vectors in math!
:::

# Joint and Conditional Distributions

::: frame
:::

::: frame
Joint Distributions

We can also calculate the distribution of multiple variables, called a
**joint distribution**.

``` {.python bgcolor="gray"}
df[["pclass", "survived"]].value_counts().unstack() / len(df)
```

![image](joint){width="\\textwidth"}
:::

::: frame
Visualizing Joint Distributions

![image](crosstab_bar.png){width=".48\\textwidth"}

How would this bar plot change if we plotted the joint distribution
instead of the counts?
:::

::: frame
Conditional Distributions

To compare survival across the classes, we should normalize by the total
in each class.

![image](crosstab){width="\\textwidth"}

``` {.python bgcolor="gray"}
crosstab
```

    pclass
    1    323
    2    277
    3    709
    dtype: int64

``` {.python bgcolor="gray"}
crosstab.sum(axis="columns")
```

``` {.python bgcolor="gray"}
pclass_totals = crosstab.sum(axis="columns")
crosstab.divide(pclass_totals, axis="rows")
```

![image](crosstab_conditional){width="\\textwidth"}

These are the **conditional distributions** of given .
:::

::: frame
Visualizing Conditional Distributions

To visualize the conditional distributions, we could make a grouped bar
plot\...

``` {.python bgcolor="gray"}
(crosstab.divide(pclass_totals, axis="rows").
 plot.bar())
```

![image](conditional_bar){width=".5\\textwidth"}
:::

::: frame
Visualizing Conditional Distributions

To visualize a conditional distribution, we could make a grouped bar
plot\...

``` {.python bgcolor="gray" escapeinside="||"}
(crosstab.divide(pclass_totals, axis="rows").
 plot.bar(|\textcolor{red}{stacked=True}|))
```

![image](conditional_stacked_bar){width=".5\\textwidth"}

\...but it is better to make a **stacked bar plot**.
:::

::: frame
Conditional Probabilities

What does it mean to say, "The conditional proportion of survival given
3rd class is $0.255289$"?

One interpretation is as a **conditional probability**.

"If we were to pick a 3rd class passenger on the Titanic at random, the
probability that they survived is $0.255289$."

We notate this as
$$P(\textrm{survived} | \textrm{3rd class}) = 0.255289$$ or, if we want
to be explicit about the variable and the category,
$$P(\varname{survived} = 1 | \varname{pclass} = 3) =  0.255289$$
:::

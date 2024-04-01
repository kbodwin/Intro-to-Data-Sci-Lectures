---
author:
- |
  Dennis Sun\
  Stanford University\
  DATASCI 112
date: |
  ![image](../logo){width="25pt"}\
  January 17, 2024
title: |
  Lecture 4\
  The Split-Apply-Combine Paradigm
---

::: frame
:::

::: frame
Flight Delays

Which airline carriers are most likely to be delayed?

Let's look at a data set of all domestic flights that departed from one
of the New York City airports (JFK, LaGuardia, and Newark) on November
16, 2013.

``` {.python bgcolor="gray"}
import pandas as pd
data_dir = "https://datasci112.stanford.edu/data/"
df = pd.read_csv(data_dir + "flights_nyc_20131116.csv")
df
```

![image](dataframe){width=".32\\textwidth"}
:::

::: frame
Visualizing Delays

We already know how to visualize and summarize a quantitative variable
like .

``` {.python bgcolor="gray"}
df["dep_delay"].plot.hist()
df["dep_delay"].mean()
```

`2.0469565217391303`

![image](delay_hist){width=".6\\textwidth"}

But how do we compare delays across different carriers?
:::

# Boolean Masking

::: frame
:::

::: frame
What do you think the following code will produce?

``` {.python bgcolor="gray"}
df["carrier"] == "UA"
```

``` {fontsize="\\scriptsize"}
0      False
1       True
2      False
3       True
4      False
       ...  
573    False
574    False
575     True
576    False
577    False
Name: carrier, Length: 578, dtype: bool
```

What about the following?

``` {.python bgcolor="gray"}
(df["carrier"] == "UA").sum()
```

    123
:::

::: frame
Boolean Series

How would you interpret the following?

``` {.python bgcolor="gray"}
(df["carrier"] == "UA").mean()
```

    0.21280276816608998

-   Applying a relational operator like `==`{.python}, `<`{.python},
    `>`{.python}, and `!=`{.python} on a `Series`{.python} produces a
    `Series`{.python} of booleans, by vectorization.

-   Arithmetic operations can be performed on booleans in
    `Series`{.python}, treating `True`{.python} as $1$ and
    `False`{.python} as $0$.
:::

::: frame
Boolean Masks

A boolean `Series`{.python} can be passed as a key to a
`DataFrame`{.python} to *mask* the data.

``` {.python bgcolor="gray"}
df[df["carrier"] == "UA"]
```
:::

::: frame
Exercise

How would we summarize the United Airlines delays?

``` {.python bgcolor="gray"}
df[df["carrier"] == "UA"]["dep_delay"].mean()
```

    5.590163934426229

Note that this is a summary of a conditional distribution of :
$$\textrm{mean}(\varname{dep\_delay} | \varname{carrier} = \textrm{UA}).$$
:::

# The Split-Apply-Combine Paradigm

::: frame
:::

::: frame
Another Exercise

To compare carriers, we need to summarize all the conditional
distributions of given :
$$\onslide<2->{\textrm{mean}(\varname{dep\_delay} | \varname{carrier})}.$$

``` {.python bgcolor="gray" escapeinside="||" beameroverlays=""}
for carrier in df["carrier"].unique():
  |\only<4->{\textcolor{red}{print(carrier, }}|df[df["carrier"] == carrier]["dep_delay"].mean()|\only<4->{\textcolor{red}{)}}|
```

    US -2.324324324324324
    UA 5.590163934426229
    AA -1.337837837837838
    DL 3.295238095238095
    B6 1.5378787878787878
    EV 1.2476190476190476

-   It is inconvenient (have to write a `for`{.python} loop over the
    possible values).

-   The values are not stored in a Pandas object for further analysis
    (e.g., visualization).
:::

::: frame
The Split-Apply-Combine Paradigm

This analysis fits into the **split-apply-combine paradigm** ([Wickham,
2011](https://www.jstatsoft.org/article/view/v040i01)).
:::

::: frame
Split-Apply-Combine in Pandas

The split-apply-combine paradigm is implemented in Pandas as the
`.groupby()`{.python} method.

``` {.python bgcolor="gray" escapeinside="||" beameroverlays=""}
df.groupby("carrier")["dep_delay"].mean()
```

``` {fontsize="\\scriptsize"}
carrier
AA   -1.337838
B6    1.537879
DL    3.295238
EV    1.247619
UA    5.590164
US   -2.324324
Name: dep_delay, dtype: float64
```
:::

::: frame
Split-Apply-Combine in Pandas

For example, we could plot the mean delay for each carrier.

``` {.python bgcolor="gray" escapeinside="||" beameroverlays=""}
df.groupby("carrier")["dep_delay"].mean().plot.bar()
```

![image](mean_delay_barplot){width=".5\\textwidth"}

Notice that United Airlines had the longest average delay.
:::

::: frame
Splitting on Multiple Keys

What if we wanted to also split by the origin airport?

``` {.python bgcolor="gray"}
df.groupby(["carrier", "origin"])["dep_delay"].mean()
```

``` {fontsize="\\scriptsize"}
carrier  origin
AA       EWR       -3.375000
         JFK        1.771429
         LGA       -4.322581
B6       EWR       -0.823529
         JFK       -0.836735
         LGA       17.588235
DL       EWR       19.222222
         JFK        4.980000
         LGA       -1.652174
EV       EWR        1.483146
         JFK        0.000000
         LGA       -0.083333
UA       EWR        7.525773
         JFK        1.909091
         LGA       -4.928571
US       EWR       -5.000000
         JFK        5.400000
         LGA       -5.312500
Name: dep_delay, dtype: float64
```

``` {.python bgcolor="gray"}
.unstack("origin")
```

![image](mean_delay_by_airport){width=".8\\textwidth"}

``` {.python bgcolor="gray"}
.plot.bar()
```

![image](mean_delay_by_airport_barplot){width=".9\\textwidth"}
:::

:::: frame
Notice Anything Weird?

+:--------------------------------:+:--------------------------------:+
| ::: overprint                    | ::: overprint                    |
| ``` {.python f                   | ``` {.python f                   |
| ontsize="\\tiny" bgcolor="gray"} | ontsize="\\tiny" bgcolor="gray"} |
| ax = (df.                        | ax = (df.                        |
|       groupby("carrier")         |                                  |
|       ["dep_delay"].mean().      |   groupby(["carrier", "origin"]) |
|       plot.bar())                |       ["dep_delay"].mean().      |
| ```                              |       unstack("origin").         |
|                                  |       plot.bar())                |
| ``` {.python f                   | ```                              |
| ontsize="\\tiny" bgcolor="gray"} |                                  |
| ax = (df.                        | ``` {.python f                   |
|       groupby("carrier")         | ontsize="\\tiny" bgcolor="gray"} |
|       ["dep_delay"].mean().      | ax = (df.                        |
|       plot.bar())                |                                  |
| ax.set_ylim(-6, 20)              |   groupby(["carrier", "origin"]) |
| ```                              |       ["dep_delay"].mean().      |
| :::                              |       unstack("origin").         |
|                                  |       plot.bar())                |
|                                  | ax.set_ylim(-6, 20)              |
|                                  | ```                              |
|                                  | :::                              |
+----------------------------------+----------------------------------+
|                                  |                                  |
+----------------------------------+----------------------------------+

::: center
Let's investigate in a Colab!

[![image](../colab){width=".2\\textwidth"}](https://colab.research.google.com/drive/1sG0uD_FMVvbw7g2uADA6eio32t56PGRM#scrollTo=Lz5fHbclVxnz&line=1&uniqifier=1)
:::
::::

# Visualizing Conditional Distributions

::: frame
:::

::: frame
Comparing Distributions

It is possible to use `.groupby()`{.python} with all kinds of
operations.

``` {.python bgcolor="gray"}
axes = df.groupby("origin")["dep_delay"].plot.hist(legend=True)
axes[0].set_xlabel("Departure Delay")
```

![image](hist){width=".65\\textwidth"}
:::

::: frame
Comparing Distributions

To prevent *overplotting*, we set the opacity parameter `alpha`.

``` {.python bgcolor="gray"}
axes = df.groupby("origin")["dep_delay"].plot.hist(legend=True,
                                                   alpha=0.4)
axes[0].set_xlabel("Departure Delay")
```

![image](hist_alpha){width=".65\\textwidth"}
:::

::: frame
Comparing Distributions

Density histograms visualize the conditional distribution \| directly,
allowing for easy comparison.

``` {.python bgcolor="gray"}
axes = df.groupby("origin")["dep_delay"].plot.hist(legend=True,
                                                   alpha=0.4,
                                                   density=True)
axes[0].set_xlabel("Departure Delay")
```

![image](hist_density){width=".65\\textwidth"}
:::

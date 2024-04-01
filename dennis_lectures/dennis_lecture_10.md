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
  Lecture 10\
  Introduction to Machine Learning
---

::: frame
:::

# What is Machine Learning?

::: frame
:::

::: frame
Classic Artificial Intelligence

Classic AI attempts to codify the rules that a human would use to make
decisions.

If you are trying to build a system that finds all the proper nouns in a
text document, you might hard-code the following rules:

-   If a word is a proper noun, then the first letter of the word is
    capitalized.

-   The first letter of a sentence is always capitalized.

-   $...$

The system can deduce new rules from existing rules, e.g.,

-   It is impossible to tell whether the first word of a sentence is a
    proper noun just from the capitalization.

The model is super interpretable!

For complex tasks, there are too many rules, and we can't anticipate
them all.
:::

::: frame
What is Machine Learning?

*Exercise:* Pair up with the person sitting next to you. One of you will
be an Earthling, the other a Martian.

The Earthling should explain to the Martian what the word "red" means.
The Martian should try to be obtuse.
:::

::: frame
What is Machine Learning?

**Learning** refers to the act of coming up with a rule for making
decisions based on a set of inputs.

The decision $y$ is typically called the **target** or the **label**.
:::

# A Controversy in the Wine World

::: frame
:::

::: frame
![image](parker){width="\\textwidth"}
:::

::: frame
How did Ashenfelter make this prediction?

Ashenfelter collected data on summer temperature and winter rainfall in
Bordeaux from 1952 to 1991.

The quality of wines becomes apparent after 10 years. So for vintages up
to 1980, he also collected their price.

``` {.python bgcolor="gray" fontsize="\\scriptsize"}
import pandas as pd

df = pd.read_csv("https://dlsun.github.io/pods/data/bordeaux.csv",
                 index_col="year")
df
```

![image](bordeaux_data){width="\\textwidth"}
:::

::: frame
Visualizing the Data

``` {.python bgcolor="gray" fontsize="\\scriptsize"}
import plotly.express as px

px.scatter(df[~df["price"].isnull()],
           x="win", y="summer", color="price")
```
:::

:::: frame
Visualizing the Data

``` {.python bgcolor="gray" fontsize="\\scriptsize"}
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
![image](bordeaux_scatter_with_neighbors){width=".8\\textwidth"}
:::

::: center
[Insight:]{.underline} The "closest" wines are low quality, so the 1986
vintage is probably low quality as well.

This is the intuition behind **$k$-nearest neighbors**.
:::
:::::

:::: frame
Types of Machine Learning Problems

Machine learning problems are grouped into two types, based on the type
of $y$:

**Regression:** The label $y$ is quantitative.

**Classification:** The label $y$ is categorical.

Was Ashenfelter's wine problem a regression or a classification problem?

::: center
Note that the input features ${\bf x}$ may be categorical, quantitative,
textual, \..., or any combination of these.
:::
::::

---
author:
- |
  Dennis Sun\
  Stanford University\
  DATASCI 112
date: |
  ![image](../logo){width="25pt"}\
  January 12, 2024
title: |
  Lecture 3\
  Quantitative Variables
---

::: frame
:::

::: frame
Quantitative Variables

We have analyzed a quantitative variable already. Where?

In the Colombia COVID data!

``` {.python bgcolor="gray"}
df_CO = pd.read_csv(url + "colombia_2020-05-28.csv")
df_CO
```

![image](colombia_covid){width=".55\\textwidth"}

This example will motivate our discussion of quantitative variables
today!
:::

::: frame
:::

# Visualizing One Quantitative Variable

::: frame
:::

:::: frame
Visualizing One Quantitative Variable

To visualize the age variable, we did the following:

::: overprint
``` {.python escapeinside="||" bgcolor="gray"}
df_CO["age"] = pd.cut(
    df_CO["Edad"],
    bins=[0, 10, 20, 30, 40, 50, 60, 70, 80, 120],
    labels=["0-9", "10-19", "20-29", "30-39", "40-49", "50-59", "60-69", "70-79", "80+"],
    right=False)
    
```

``` {.python escapeinside="||" bgcolor="gray"}
df_CO["age"] = pd.cut(
    df_CO["Edad"],
    bins=[0, 10, 20, 30, 40, 50, 60, 70, 80, 120],
    labels=["0-9", "10-19", "20-29", "30-39", "40-49", "50-59", "60-69", "70-79", "80+"],
    right=False)
df_CO["age"].value_counts(sort=False).plot.bar()
```
:::
::::

::: frame
Histograms

Pandas provides a built-in method for constructing histograms:
`Series.plot.hist()`{.python}.

``` {.python bgcolor="gray"}
df_CO["Edad"].plot.hist()
```

![image](histogram){width=".38\\textwidth"}

How does this differ from the manual histogram from earlier?

![image](histogram_manual){width="\\textwidth"}

-   
-   
:::

::: frame
Distributions

Recall the distribution of a categorical variable.

The **distribution** of a quantitative variable is similar. The counts
are scaled so that the total *area* is 1.0 (or 100%).

``` {.python bgcolor="gray"}
df_CO["Edad"].plot.hist(density=True)
```

![image](histogram_density){width=".38\\textwidth"}

How does this differ from the (counts) histogram from earlier?

![image](histogram){width="\\textwidth"}
:::

# Summarizing One Quantitative Variable

::: frame
:::

:::: frame
Summarizing a Quantitative Variable

If you had to summarize this data using a single number, what number
would you pick?

::: center
:::
::::

::: frame
Summaries of Center: Mean

One summary of the center of a quantitative variable is the **mean**.

To calculate the mean of a quantitative variable $\varname{x}$ with
values $x_1, x_2, x_3, ..., x_n$, we use the formula:
$$\onslide<4->{\overline{\varname{x}} =} \textrm{mean(\varname{x})} = \frac{\sum_{i=1}^n x_i}{n}$$

You can calculate it manually\...

``` {.python bgcolor="gray"}
df_CO["Edad"].sum() / len(df_CO)
```

    39.04742568792872

\...or using a built-in Python function.

``` {.python bgcolor="gray"}
df_CO["Edad"].mean()
```

    39.04742568792872
:::

:::: frame
Summaries of Center: Mean

Don't be fooled by the humble mean,
$$\overline{\varname{x}} = \textrm{mean(\varname{x})} = \frac{\sum_{i=1}^n x_i}{n}.$$
It is not at all obvious that this formula should give a summary of
center!

Let's investigate one reason in a Colab.

::: center
[](https://colab.research.google.com/drive/1u8TygFSo6ly3oZogcrO3tk0_h6kfKKrF#scrollTo=oABWjnIQnU7n)
:::

![image](newton_giants){width="\\textwidth"}

> If I have seen further \[than others\], it is by standing on the
> shoulders of giants.
>
> -- Isaac Newton
::::

::: frame
Summaries of Center: Median

Another summary of center is the **median**, which is the "middle" of
the *sorted* values.

To calculate the median of a quantitative variable $\varname{x}$ with
values $x_1, x_2, x_3, ..., x_n$, we do the following steps:

1.  Sort the values from smallest to largest:
    $$x_{(1)}, x_{(2)}, x_{(3)}, ..., x_{(n)}.$$

2.  The "middle" value depends on whether we have an odd or an even
    number of observations.

    -   If $n$ is odd, then the middle value is $x_{(\frac{n+1}{2})}$.

    -   If $n$ is even, then there are two middle values,
        $x_{(\frac{n}{2})}$ and $x_{(\frac{n}{2} + 1)}$. It is
        conventional to report the mean of the two values (but you can
        actually pick any value between them).
:::

:::: frame
Summaries of Center: Median

We can implement these steps in Python code manually. I asked ChatGPT,
and it generated this code:

::: center
:::

But it's easier to use the built-in Python function.

``` {.python bgcolor="gray"}
df_CO["Edad"].median()
```

    37.0
::::

:::: frame
Summaries of Center: Mean vs. Median

We now have two summaries of center. How do they compare?

::: center
:::

How would we summarize spread now?
::::

::: frame
Summaries of Spread: Variance

One measure of spread is the **variance**.

The variance of a variable whose values are $x_1, x_2, x_3, ..., x_n$ is
calculated using the formula
$$\textrm{var(\varname{x})} = \frac{\sum_{i=1}^n (x_i - \overline{\varname{x}})^2}{n - 1}$$

You can implement this formula manually\...

``` {.python bgcolor="gray"}
(((df_CO["Edad"] - df_CO["Edad"].mean()) ** 2).sum() /
 (len(df_CO) - 1))
```

    348.0870469898451

\...or using a built-in Python function.

``` {.python bgcolor="gray"}
df_CO["Edad"].var()
```

    348.0870469898451
:::

:::: frame
Summaries of Spread: Standard Deviation

To fix the units, we take the square root to get the **standard
deviation**: $$\begin{aligned}
\textrm{sd(\varname{x})} = &\sqrt{\textrm{var(\varname{x})}} \\[-0.6em]
\onslide<3->{\handwriting{\textcolor{orange}{\small years }}} \hspace{.3in} &\hspace{.3in} \onslide<2->{\handwriting{\textcolor{orange}{\small years${}^2$ }}}
\end{aligned}$$

We can calculate it using the built-in Pandas method
`Series.std`{.python}:

``` {.python bgcolor="gray"}
df_CO["Edad"].std()
```

    18.65709106452142

::: center
:::
::::

# Recap

::: frame
:::

::: frame
What We Learned Today

-   visualizing a quantitative variable

    -   We've now seen two plots that can be made within Pandas:
        `.plot.bar()`{.python}, `.plot.hist()`{.python}, and
        `.plot.line()`{.python}.

-   summarizing a quantitative variable

    -   summarizing the center

    -   summarizing the spread

-   some new Python tricks
:::

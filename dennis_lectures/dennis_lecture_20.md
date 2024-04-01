---
author:
- |
  Dennis Sun\
  Stanford University\
  DATASCI 112
date: |
  ![image](../logo){width="25pt"}\
  March 6, 2024
title: |
  Lecture 21\
  Types of Joins
---

::: frame
:::

# Review

::: frame
:::

::: frame
Joins

Sometimes data is spread across multiple datasets.

For example, suppose we have baby names in 1920 and 2020:

``` {.python bgcolor="gray"}
import pandas as pd
data_dir = "http://dlsun.github.io/pods/data/names/"

df_1920 = pd.read_csv(data_dir + "yob1920.txt", header=None,
                      names=["Name", "Sex", "Count"])
df_2020 = pd.read_csv(data_dir + "yob2020.txt", header=None,
                      names=["Name", "Sex", "Count"])
```
:::

:::: frame
Joins

::: center
:::

We can *join* two datasets on a *key*.

We focused on the case where we join on a **primary key**.

In this case, we are joining the primary keys of two tables together.
(We could also join the primary key to a **foreign key**.)
::::

::: frame
Joins

``` {.python bgcolor="gray"}
df_joined = df_1920.merge(df_2020, on=["Name", "Sex"])
df_joined
```

![image](df_joined){width=".5\\textwidth"}
:::

::: frame
Missing Keys?

``` {.python bgcolor="gray"}
df_joined[df_joined["Name"] == "Maya"]
```

![image](df_joined_maya){width=".4\\textwidth"}

Why isn't Maya in the joined data? How does Pandas determine which keys
show up?

It is there in the 2020 data\...

``` {.python bgcolor="gray"}
df_2020[df_2020["Name"] == "Maya"]
```

![image](df_2020_maya){width=".3\\textwidth"}

\...but not in the 1920 data.

``` {.python bgcolor="gray"}
df_1920[df_1920["Name"] == "Maya"]
```

![image](df_1920_maya){width=".25\\textwidth"}

In order to appear in the joined data, a key must be present in *both*
tables.
:::

# Types of Joins

::: frame
:::

::: frame
Types of Joins

How can we customize the behavior of joins for missing keys?

This brings us to the first of today's topics: *types of joins*.

-   By default, Pandas does an **inner join**, which only keeps keys
    that are present in *both* tables.

-   An **outer join** keeps any key that is present in either table.

-   A **left join** keeps all keys in the left table, even if they are
    not in the right table. But any keys that are only in the right
    table are dropped.

-   A **right join** keeps all keys in the right table, even if they are
    not in the left table. But any keys that are only in the left table
    are dropped.
:::

::: frame
Join Examples

We can customize the type of join using the `how=`{.python} parameter of
`.merge()`{.python}. By default, `how="inner"`{.python}.

``` {.python bgcolor="gray"}
df_joined_outer = df_1920.merge(df_2020, on=["Name", "Sex"],
                                how="outer")
df_joined_outer[df_joined_outer["Name"] == "Maya"]
```

![image](df_joined_outer_maya){width=".45\\textwidth"}

Note the missing values for other columns, like Count, for 1920!

What other type of join would have produced this output?

``` {.python bgcolor="gray"}
df_joined_right = df_1920.merge(df_2020, on=["Name", "Sex"],
                                how="right")
df_joined_right[df_joined_right["Name"] == "Maya"]
```

![image](df_joined_right_maya){width=".45\\textwidth"}
:::

::: frame
Summary of Types of Joins
:::

::: frame
Exercises

Which type of join would be best suited for each case?

1.  We want to determine the names that have increased in popularity the
    most between 1920 and 2020.

    ``` {.python bgcolor="gray"}
    df_1920.merge(df_2020, on=["Name", "Sex"], how=...)
    ```

    `how="right"`{.python}

2.  We want to graph the popularity of names over time.

    ``` {.python bgcolor="gray"}
    df = pd.read_csv(data_dir + "yob1981.txt",
                     header=None,
                     names=["Name", "Sex", 1981])

    for year in range(1982, 2021):
      df_year = pd.read_csv(data_dir + f"yob{year}.txt",
                            header=None,
                            names=["Name", "Sex", year])
      df = df.merge(df_year, on=["Name", "Sex"], how=...)
    ```

    `how="outer"`{.python}
:::

# Many-to-Many Joins

::: frame
:::

::: frame
Many-to-Many Relationships

So far, the keys we've joined on have been the primary key of (at least)
one table.

-   If we join to the primary key of another table, then the
    relationship is **one-to-one** (since primary keys uniquely identify
    rows).

-   If we join to the foreign key of another table, then the
    relationship is **one-to-many**.

What if we join on a key that is not a primary key?

That is, what if the key does not uniquely identify rows in either table
so that each value of the key might appear multiple times?

This relaionship is called **many-to-many**.
:::

::: frame
Many-to-Many Example

What if we only joined on the name?

``` {.python bgcolor="gray"}
df_1920.merge(df_2020, on="Name")
```
:::

:::: frame
Illustration of a Many-to-Many Join

::: center
There are 4 matches, only 2 of which are desirable.
:::
::::

::: frame
Preventing Bugs

Most of the time, many-to-many joins are a bug, caused by a
misunderstanding about the primary key.

Pandas allows us to specify the relationship we are expecting. It will
fail with an error if the relationship is a different kind.

For example, suppose we thought that "name" was the primary key of the
baby name tables.

``` {.python bgcolor="gray"}
df_1920.merge(df_2020, on="Name",
              validate="one_to_one")
```

``` {fontsize="\\scriptsize"}
MergeError: Merge keys are not unique in either left or right dataset;
            not a one-to-one merge
```

Errors are (sometimes) your friend. They can prevent you from making
even bigger mistakes!
:::

# Recap

::: frame
:::

::: frame
What We've Learned Today

We've discussed two kinds of complications with joins:

-   when a key doesn't appear in one table (outer, left, right join)

-   when a key appears multiple times in both tables (many-to-many
    joins)
:::

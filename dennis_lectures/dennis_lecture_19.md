---
author:
- |
  Dennis Sun\
  Stanford University\
  DATASCI 112
date: |
  ![image](../logo){width="25pt"}\
  March 4, 2024
title: |
  Lecture 20\
  Combining Data Sets
---

::: frame
:::

::: frame
Why Combine Data?

Sometimes, information is spread across multiple data sets.

For example, suppose we want to know which manufacturer's planes made
the most flights in November 2013.

One data set contains information about flights in Nov. 2013\...

``` {.python bgcolor="gray"}
import pandas as pd
data_dir = "https://datasci112.stanford.edu/data/nycflights13/"
df_flights = pd.read_csv(f"{data_dir}/flights11.csv")
df_flights
```

![image](df_flights){width=".75\\textwidth"}
:::

::: frame
Why Combine Data?

\...while another contains information about planes.

``` {.python bgcolor="gray"}
df_planes = pd.read_csv(f"{data_dir}/planes.csv")
df_planes
```

![image](df_planes){width=".75\\textwidth"}

In order to answer the question of which manufacturer made the most
flights, we have to join these two data sets together.
:::

::: frame
:::

# Joining on a Key

::: frame
:::

::: frame
Keys

Planes are uniquely identified by their *tail number*
(`tailnum`{.python}).

A **primary key** is a column (or a set of columns) that uniquely
identifies observations in a data frame.

A **foreign key** is a column (or a set of columns) that points to the
primary key of another data frame.
:::

::: frame
Joining on a Key

The Pandas function `.merge()`{.python} can be used to join two
`DataFrame`s on a key.

``` {.python bgcolor="gray"}
df_joined = df_flights.merge(df_planes, on="tailnum")
df_joined   
```

-   [Joining two data frames results in a *wider* data frame, with more
    columns.]{style="color: red"}

-   
:::

::: frame
Overlapping Column Names

By default, Pandas adds the suffixes `_x`{.python} and `_y`{.python} to
overlapping column names, but this can be customized.

``` {.python bgcolor="gray"}
df_joined = df_flights.merge(df_planes, on="tailnum",
                             suffixes=("_flight", "_plane"))
df_joined.columns
```

``` {fontsize="\\scriptsize"}
Index(['year_flight', 'month', 'day', 'dep_time', 'sched_dep_time',
       'dep_delay', 'arr_time', 'sched_arr_time', 'arr_delay', 'carrier',
       'flight', 'origin', 'dest', 'air_time', 'distance', 'hour', 'minute',
       'tailnum', 'year_plane', 'type', 'manufacturer', 'model', 'engines',
       'seats', 'speed', 'engine'],
      dtype='object')
```
:::

::: frame
Analyzing the Joined Data

Now that we have joined the two data sets, we can answer the question:
which manufacturer's planes made the most flights?

``` {.python bgcolor="gray"}
df_joined["manufacturer"].value_counts()
```

``` {fontsize="\\scriptsize"}
BOEING                6557
EMBRAER               5175
AIRBUS                3954
AIRBUS INDUSTRIE      3456
BOMBARDIER INC        2632
                      ... 
MARZ BARRY               1
AVIAT AIRCRAFT INC       1
PAIR MIKE E              1
LEBLANC GLENN T          1
STEWART MACO             1
Name: manufacturer, Length: 29, dtype: int64
```
:::

# Joining on Multiple Keys

::: frame
:::

::: frame
Joining to Weather Data

What weather factors cause flight delays?

To answer this question, we need to join the flights data to weather
data. Here is a data set containing hourly weather data at each airport
in 2013.

``` {.python bgcolor="gray"}
df_weather = pd.read_csv(f"{data_dir}/weather.csv")
df_weather
```

![image](df_weather){width=".7\\textwidth"}

What is the primary key of this data set?
:::

::: frame
A Key with Multiple Columns

Let's start by looking at flights out of JFK. We need to join to the
weather data on year, month, day, and hour.

``` {.python bgcolor="gray"}
df_jfk = df_flights[df_flights["origin"] == "JFK"].merge(
    df_weather[df_weather["airport"] == "JFK"],
    on=("year", "month", "day", "hour"))
df_jfk
```

![image](df_jfk){width=".8\\textwidth"}
:::

::: frame
Let's see how visibility affects departure delays.

``` {.python bgcolor="gray"}
df_jfk.plot.scatter(x="visib", y="dep_delay", alpha=0.2)
```

![image](visib_delay_scatter){width=".4\\textwidth"}

``` {.python bgcolor="gray"}
df_jfk.groupby("visib")["dep_delay"].mean().plot.line()
```

![image](visib_delay_line){width=".4\\textwidth"}
:::

::: frame
Joining on Keys with Different Names

Sometimes, the join keys have different names in the two data sets. This
happens if the data sets come from different sources.

For example, if we want to join the (entire) flights data to the weather
data, we would need to include the airport in the key.

But the airport is called `"origin"`{.python} in `df_flights`{.python}
and `"airport"`{.python} in `df_weather`{.python}.

The `.merge()`{.python} function provides `left_on=`{.python} and
`right_on=`{.python} arguments for specifying different column names in
the **left** and **right** data frames.

``` {.python bgcolor="gray"}
df_flights_weather = df_flights.merge(
    df_weather,
    left_on=("origin", "year", "month", "day", "hour"),
    right_on=("airport", "year", "month", "day", "hour"))
```
:::

:::: frame
Joining on Keys with Different Names

::: center
Let's complete this analysis in a Colab.

[![image](../colab){width=".5\\textwidth"}](https://colab.research.google.com/drive/1-0YjOMP0SuKBSs91p7iRypaFzCiycAvZ?usp=sharing)
:::
::::

# Recap

::: frame
:::

::: frame
What We Have Learned Today

In Pandas, `df_left.merge(df_right, ...)`{.python} can be used to join
two `DataFrame`{.python}s, giving you access to variables from both data
sets.

-   Usually, we join the *foreign key* of one data set to the *primary
    key* of another.

-   If the keys have the same names, we use
    `df_left.merge(df_right, on=...)`{.python}. Note that `on=`{.python}
    may be a single column name or a list of column names.

-   If the keys have different names, we use
    `df_left.merge(df_right, left_on=..., right_on=...)`{.python}.

-   Overlapping columns that are not keys will have a suffix appended,
    which can be customized using
    `df_left.merge(df_right, ..., suffixes=...)`{.python}.
:::

::: frame
What We Haven't Learned Today

-   what happens when a key is missing from the left or right data set

-   what happens when you join using a column (or columns) that is not a
    primary key

We'll address these issues in the next lecture.
:::

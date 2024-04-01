---
author:
- |
  Dennis Sun\
  Stanford University\
  DATASCI 112
date: |
  ![image](../logo){width="25pt"}\
  February 23, 2024
title: |
  Lecture 17\
  Hierarchical Data
---

::: frame
:::

# What is Hierarchical Data?

::: frame
:::

:::: frame
Hierarchical Data

::: center
Consider a data set of TV shows.
:::

Each show has\...

-   a name

-   a network

-   \...

-   multiple seasons,\
    each of which has\...

    -   a number

    -   a premiere date

    -   an end date

    -   \...

    -   multiple episodes,\
        each of which has\...

        -   a name

        -   an airdate

        -   \...

-   a cast of multiple actors.

We can think of this data as a *tree*.

![image](hierarchical_data){width="\\textwidth"}

But how would we represent this data as a file on disk?
::::

# JSON

::: frame
:::

::: frame
JavaScript Object Notation (JSON)

JSON is one way to represent hierarchical data. In Python, JSON is
represented as a `dict`{.python}.

``` {.js fontsize="\\scriptsize"}
[{'name': 'Girls',
  'network': {'name': 'NBC', ...},
  ...,
  'cast': [{'person': {'name': 'Lena Dunham', ...},
            'character': {'name': 'Hannah Horvath', ...},
            'voice': False},
            ...
           ],
  'seasons': [{'premiereDate': '2012-04-15',
               ...,
               'episodes': [{'name': 'Pilot',
                             'number': 1,
                         'runtime': 30,
                         ...},
                            ...
                            ]
               }],
 },
 ...
]
```
:::

:::: frame
Working with JSON

::: center
Let's work with this JSON data in a Colab.

[![image](../colab){width=".5\\textwidth"}](https://colab.research.google.com/drive/1_URLdLNIwNc64ZrbK2o8G-VYARgMDH-9?usp=sharing#scrollTo=JSON)
:::
::::

# XML

::: frame
:::

::: frame
eXtensible Markup Language (XML)

XML is another way to represent hierarchical data.

-   Fields are represented by named *tags*.

-   Each tag has an open `<tag>`{.xml} and a close `</tag>`{.xml}.

-   Children are represented by nested tags.

-   Repeated fields are represented by repeated tags.

Technical details:

-   XML documents must begin with the declaration `<?xml ... ?>`{.xml}.

-   XML documents must have a `<root>`{.xml} tag.

``` {.xml fontsize="\\scriptsize"}
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <show>
    <name>Girls</name>
    <network>
      <name>NBC</name>
      ...
    </network>
    <cast>
      <person>...</person>
      <character>....</character>
      <voice>...</voice>
    </cast>
    <cast>
      ...
    </cast>
    <season>
      <episode>...</episode>
      <episode>...</episode>
      ...
    </season>
    <season>
      ...
    </season>
  </show>
</root>
```
:::

:::: frame
Working with XML

::: center
Let's work with the same data, as an XML, in a Colab.

[![image](../colab){width=".5\\textwidth"}](https://colab.research.google.com/drive/1_URLdLNIwNc64ZrbK2o8G-VYARgMDH-9?usp=sharing#scrollTo=XML)
:::
::::

# Recap

::: frame
:::

::: frame
JSON vs. XML

Which is better?

-   JSON has largely won over XML.

-   You can occasionally still find hierarchical data as XML, but it
    usually is JSON.

-   XML is still relevant in data science for one reason: it is a
    generalization of HTML, the language used to specify webpages.

We'll leverage our knowledge of XML next time to scrape webpages.
:::

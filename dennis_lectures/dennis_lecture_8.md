---
author:
- |
  Dennis Sun\
  Stanford University\
  DATASCI 112
date: |
  ![image](../logo){width="25pt"}\
  January 26, 2024
title: |
  Lecture 8\
  Textual Data: Bag-of-Words and N-Grams
---

::: frame
:::

::: frame
Roadmap for Today

Many data science techniques assume that all the variables are
quantitative.

-   *Example:* measuring similarity / calculating distances between
    observations

Last time, we learned how to convert categorical variables to
quantitative variables.

Today, we will learn how to convert a completely new type of data to
quantitative variables.
:::

# Textual Data

::: frame
:::

::: frame
:::

:::: frame
Textual Data

A textual data set consists of multiple texts. Each text is called a
**document**. The collection of texts is called a **corpus**.

Example Corpus:

0.  `"I am Sam\n\nI am Sam\nSam I..."`{.python}

1.  `"The sun did not shine.\nIt was..."`{.python}

2.  `"Fox\nSocks\nBox\nKnox\n\nKnox..."`{.python}

3.  `"Every Who\nDown in Whoville\n..."`{.python}

4.  `"UP PUP Pup is up.\nCUP PUP..."`{.python}

5.  `"On the fifteenth of May, in the..."`{.python}

6.  `"Congratulations!\nToday is your..."`{.python}

7.  `"One fish, two fish, red fish..."`{.python}

::: center
:::
::::

::: frame
Reading in Textual Data

Documents are usually stored in different files.

``` {.python bgcolor="gray"}
seuss_dir = "http://dlsun.github.io/pods/data/drseuss/"
seuss_files = [
    "green_eggs_and_ham.txt", "cat_in_the_hat.txt",
    "fox_in_socks.txt", "how_the_grinch_stole_christmas.txt",
    "hop_on_pop.txt", "horton_hears_a_who.txt",
    "oh_the_places_youll_go.txt", "one_fish_two_fish.txt"]
```

We have to read them in one by one.

``` {.python bgcolor="gray"}
import requests

docs = {}
for filename in seuss_files:
    response = requests.get(seuss_dir + filename, "r")
    docs[filename] = response.text
```
:::

:::: frame
Textual Data

A textual data set consists of several texts. Each text is called a
**document**. The collection of texts is called a **corpus**.

Example Corpus:

0.  `"I am Sam\n\nI am Sam\nSam I..."`{.python}

1.  `"The sun did not shine.\nIt was..."`{.python}

2.  `"Fox\nSocks\nBox\nKnox\n\nKnox..."`{.python}

3.  `"Every Who\nDown in Whoville\n..."`{.python}

4.  `"UP PUP Pup is up.\nCUP PUP..."`{.python}

5.  `"On the fifteenth of May, in the..."`{.python}

6.  `"Congratulations!\nToday is your..."`{.python}

7.  `"One fish, two fish, red fish..."`{.python}

::: center
:::
::::

# Bag-of-Words Model

::: frame
:::

::: frame
Bag-of-Words Model

In the **bag-of-words model**, each column represents a word, and the
values in the column are the word counts.

First, we need to count the words in each document.

``` {.python bgcolor="gray"}
from collections import Counter
Counter(docs["hop_on_pop.txt"].split())
```

    Counter({'UP': 1, 'PUP': 3, 'Pup': 4, 'is': 10, 'up.': 2, ...})

We put these counts into a `Series`{.python} and stack them into a
`DataFrame`{.python}.

``` {.python bgcolor="gray"}
import pandas as pd
pd.DataFrame(
    [pd.Series(Counter(doc.split())) for doc in docs.values()],
    index=docs.keys())
```

![image](document-term){width="\\textwidth"}

This is called the **term-frequency matrix**.
:::

::: frame
Bag-of-Words in Scikit-Learn

Alternatively, we can use `CountVectorizer`{.python} in scikit-learn to
produce a term-frequency matrix.

``` {.python bgcolor="gray"}
from sklearn.feature_extraction.text import CountVectorizer
vec = CountVectorizer()
vec.fit(docs.values())
vec.transform(docs.values())
```

    <8x1344 sparse matrix of type '<class 'numpy.int64'>'
        with 2308 stored elements in Compressed Sparse Row format>

The set of words across a corpus is called the **vocabulary**. We can
view the vocabulary in a fitted `CountVectorizer`{.python} as follows:

``` {.python bgcolor="gray"}
vec.vocabulary_
```

    {'am': 23, 'sam': 935, 'that': 1138, 'do': 287, 'not': 767, ...}
:::

:::: frame
Text Normalization

What's wrong with the way we counted words originally?

    Counter({'UP': 1, 'PUP': 3, 'Pup': 4, 'is': 10, 'up.': 2, ...})

It's usually good to **normalize** for punctuation and capitalization.

Normalization options are specified when you initialize the
`CountVectorizer`{.python}. By default, Scikit-Learn strips punctuation
and converts all characters to lowercase.

But if you don't want Scikit-Learn to normalize for punctuation and
capitalization, you can do the following:

``` {.python bgcolor="gray"}
vec = CountVectorizer(lowercase=False, token_pattern=r"[\S]+")
vec.fit(docs.values())
vec.transform(docs.values())
```

    <8x2562 sparse matrix of type '<class 'numpy.int64'>'
        with 3679 stored elements in Compressed Sparse Row format>

::: center
:::
::::

# N-Grams

::: frame
:::

::: frame
The Shortcomings of Bag-of-Words

Bag-of-words is easy to understand and easy to implement.

What are its disadvantages?

Consider the following documents:

1.  "The dog bit her owner."

2.  "Her dog bit the owner."

Both documents have the same exact bag-of-words representation:
$$\begin{array}{l|ccccc}
& \text{the} & \text{her} & \text{dog} & \text{owner} & \text{bit} \\
\hline
\text{1} & 1 & 1 & 1 & 1 & 1 \\
\text{2} & 1 & 1 & 1 & 1 & 1 \\
\end{array}$$ But they mean something quite different!
:::

:::: frame
N-grams

An **n-gram** is a sequence of $n$ words.

::: center
[![image](google-ngram){width=".5\\textwidth"}](https://books.google.com/ngrams/)
:::

N-grams allow us to capture more of the meaning.

For example, if we count **bigrams** (2-grams) instead of words, we can
distinguish the two documents from before:

1.  "The dog bit her owner."

2.  "Her dog bit the owner."

$$\begin{array}{l|ccccccc}
& \text{the,dog} & \text{her,dog} & \text{dog,bit} & \text{bit,the} & \text{bit,her} & \text{the,owner} & \text{her,owner} \\
\hline
\text{1} & 1 & 0 & 1 & 0 & 1 & 0 & 1 \\
\text{2} & 0 & 1 & 1 & 1 & 0 & 1 & 0 \\
\end{array}$$
::::

::: frame
N-grams in Scikit-Learn

Scikit-Learn can create n-grams.

Just pass in `ngram_range=`{.python} to the `CountVectorizer`{.python}.
To get bigrams, we set the range to `(2, 2)`{.python}:

``` {.python bgcolor="gray"}
vec = CountVectorizer(ngram_range=(2, 2))
vec.fit(docs.values())
vec.transform(docs.values())
```

    <8x5846 sparse matrix of type '<class 'numpy.int64'>'
        with 6459 stored elements in Compressed Sparse Row format>

We can also get individual words (unigrams) alongside the bigrams:

``` {.python bgcolor="gray"}
vec = CountVectorizer(ngram_range=(1, 2))
vec.fit(docs.values())
vec.transform(docs.values())
```

    <8x7190 sparse matrix of type '<class 'numpy.int64'>'
        with 8767 stored elements in Compressed Sparse Row format>
:::

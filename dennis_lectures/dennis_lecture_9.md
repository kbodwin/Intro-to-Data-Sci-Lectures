---
author:
- |
  Dennis Sun\
  Stanford University\
  DATASCI 112
date: |
  ![image](../logo){width="25pt"}\
  January 29, 2024
title: |
  Lecture 9\
  Textual Data: Vector Space Model and TF-IDF
---

::: frame
:::

::: frame
:::

# Review

::: frame
:::

::: frame
Textual Data

0.  "Whoever has hate for his brother is in the darkness and walks in
    the darkness."

1.  "Hello darkness, my old friend."

2.  "Returning hate for hate multiplies hate, adding deeper darkness to
    a night already devoid of stars. Darkness cannot drive out darkness;
    only light can do that."
:::

# Vector Space Model

::: frame
:::

:::: frame
Vector Space Model

::: center
:::
::::

::: frame
Implementing the Vector Space Model

``` {.python bgcolor="gray" fontsize="\\scriptsize"}
documents = [
    "whoever has hate for his brother is in the darkness and walks in the darkness",
    "hello darkness my old friend",
    "returning hate for hate multiplies hate adding deeper darkness to a night already devoid of stars darkness cannot drive out darkness only light can do that"
]
```

First, we use Pandas to get the term-frequency matrix.

``` {.python bgcolor="gray"}
import pandas as pd
from collections import Counter

tf = pd.DataFrame(
    [Counter(doc.split()) for doc in documents],
).fillna(0)
tf
```

![image](tf_mat){width=".5\\textwidth"}

Now we just have to implement the formula for cosine distance.
:::

::: frame
Implementing the Vector Space Model

`tf = `{.python}

![image](tf_mat){width=".5\\textwidth"}

Now we just have to implement the formula for cosine distance.
$$d({\bf x}, {\bf x}') = 1 - \frac{\sum_{j=1}^{|V|} x_j x'_j}{|| {\bf x}|| \  || {\bf x}' ||}.$$

``` {.python bgcolor="gray"}
import numpy as np

def length(v):
  return np.sqrt((v ** 2).sum())

def cos_dist(v, w):
  return 1 - (v * w).sum() / (length(v) * length(w))

cos_dist(tf.loc[0], tf.loc[1]), cos_dist(tf.loc[0], tf.loc[2])
```

    (0.8048199854102933, 0.6460038372976056)
:::

::: frame
Vector Space Model in Scikit-Learn

It's always easier to do it in Scikit-Learn.

``` {.python bgcolor="gray"}
from sklearn.feature_extraction.text import CountVectorizer

vec = CountVectorizer(token_pattern=r"\w+")
vec.fit(documents)
tf_matrix = vec.transform(documents)
tf_matrix.todense()
```

``` {fontsize="\\scriptsize"}
matrix([[0, 0, 0, 1, 1, 0, 0, 2, 0, 0, 0, 0, 1, 0, 1, 1, 0, 1, 2, 1, 0,
         0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 1, 1],
        [0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0,
         0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [1, 1, 1, 0, 0, 1, 1, 3, 1, 1, 1, 1, 1, 0, 0, 3, 0, 0, 0, 0, 1,
         1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 0]])
```

``` {.python bgcolor="gray"}
from sklearn.metrics import pairwise_distances
pairwise_distances(tf_matrix[0, :], tf_matrix,
                   metric="cosine")
```

    array([[0.        , 0.80481999, 0.64600384]])
:::

# tf-idf

::: frame
:::

::: frame
tf-idf

So far, we've simply counted the **term frequency** $\textrm{tf}(d, t)$:
how many times each term $t$ appears in each document $d$.

[Problem:]{.underline} Common words like "is" or "the" tend to dominate
because they have high counts.

We need to adjust for how common each word is:

1.  Count the fraction of documents the term appears in:
    $$\textrm{df}(t, D) = \frac{\textrm{\# documents containing term $t$}}{\textrm{\# documents}} = \frac{| \{ d \in D: t \in d \} |}{|D|}$$

2.  Invert and take a log to obtain **inverse document frequency**:
    $$\textrm{idf}(t, D) = 1 + \log \frac{1}{\textrm{df}(t, D)}.$$

3.  Multiply tf by idf to get tf-idf:
    $$\textrm{tf-idf}(d, t, D) = \textrm{tf}(d, t) \cdot \textrm{idf}(t, D).$$
:::

::: frame
tf-idf by Hand

The term-frequency matrix for this corpus is:

0.  "Whoever has hate for his brother is in the darkness and walks in
    the darkness."

1.  "Hello darkness, my old friend."

2.  "Returning hate for hate multiplies hate, adding deeper darkness to
    a night already devoid of stars. Darkness cannot drive out darkness;
    only light can do that."

$\Rightarrow$

$$\begin{array}{l|ccc}
& {\scriptsize \textbf{darkness}} & {\scriptsize \textbf{hate}} & ... \\
\hline
\text{0} & 2 & 1 & ... \\
\text{1} & 1 & 0 & ... \\
\text{2} & 3 & 3 & ... \\
\end{array}$$

Now let's calculate the tf-idf matrix!

1.  Calculate the document frequencies: $$\begin{aligned}
    \onslide<5->{\textrm{df}(\textrm{``darkness''}, D) &= \frac{3}{3} = 1} & \onslide<6->{\textrm{df}(\textrm{``hate''}, D) &= \frac{2}{3}}
    \end{aligned}$$

2.  Calculate the inverse document frequencies: $$\begin{aligned}
    \onslide<8->{\textrm{idf}(\textrm{``darkness''}, D) &= 1 + \log 1 = 1} & \onslide<9->{\textrm{idf}(\textrm{``hate''}, D) &= 1 + \log \frac{3}{2} \approx 1.176}
    \end{aligned}$$

3.  Multiply [tf]{.roman} by [idf]{.roman} to get [tf-idf]{.roman}:
:::

::: frame
tf-idf in Scikit-Learn

``` {.python bgcolor="gray"}
from sklearn.feature_extraction.text import TfidfVectorizer

# The options ensure that the numbers match our example above.
vec = TfidfVectorizer(smooth_idf=False, norm=None)
vec.fit(documents)
tfidf_matrix = vec.transform(documents)
```

Now we can use this tf-idf matrix just as we used the term frequency
matrix!

``` {.python bgcolor="gray"}
pairwise_distances(tfidf_matrix[0, :], tfidf_matrix,
                   metric="cosine")
```

    array([[0.        , 0.94612045, 0.84453506]])
:::

:::: frame
Dr. Seuss Example

::: center
Let's go into Colab and find the Dr. Seuss book that is most similar to
*One Fish, Two Fish, Red Fish, Blue Fish*.

[![image](../colab){width=".5\\textwidth"}](https://colab.research.google.com/drive/12gUdJjEGCjvR49mm1l9901grhfCpFv-0#scrollTo=Dr_Seuss_Example)
:::
::::

---
author:
- |
  Dennis Sun\
  Stanford University\
  DATASCI 112
date: |
  ![image](../logo){width="25pt"}\
  February 21, 2024
title: |
  Lecture 16\
  Unsupervised Learning
---

::: frame
:::

::: frame
:::

# Supervised vs. Unsupervised Learning

::: frame
:::

:::: frame
Supervised Learning

So far, in all the machine learning problems we've looked at, we had
training data where the label $y$ was known.

This is called **supervised learning**. Think of a child learning their
shapes under the *supervision* of an adult.

::: center
:::
::::

:::: frame
Unsupervised Learning

What if we have training data without labels $y$?

This is called **unsupervised learning**. It is like a child who has
been left to learn about shapes on their own without an adult to guide
them.

::: center
:::
::::

# Clustering

::: frame
:::

::: frame
Clustering

**Clustering** is one type of unsupervised learning.

The goal is to find groups of similar observations.

For example, consider the Palmer penguins data set.
:::

:::: frame
$K$-Means Clustering

::: center
We will explore a specific clustering model, called $k$-means
clustering, in a Colab.

[![image](../colab){width=".5\\textwidth"}](https://colab.research.google.com/drive/1FBklVXovCJZeP2spIqOVwzyVYFBn3Rf2?usp=sharing)
:::
::::

::: frame
Applications of Clustering

-   **Ecology:** An ecologist wants to group organisms into types.

-   **Market Segmentation:** A business wants to group their customers
    into types.

-   **Language:** A linguist might want to identify different uses of
    ambiguous words like "set" or "run".

In section tomorrow, you will explore applications to document
clustering and image compression.
:::

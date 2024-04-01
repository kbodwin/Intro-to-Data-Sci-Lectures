---
author:
- |
  Dennis Sun\
  Stanford University\
  DATASCI 112
date: |
  ![image](../logo){width="25pt"}\
  February 16, 2024
title: |
  Lecture 15\
  Evaluating Classification Models
---

::: frame
:::

::: frame
Case Study: Credit Card Fraud

Data set of credit card transactions from Vesta.

``` {.python bgcolor="gray" fontsize="\\scriptsize"}
import pandas as pd

df_fraud = pd.read_csv("https://datasci112.stanford.edu/data/fraud.csv")
df_fraud
```

![image](dataframe){width="\\textwidth"}

Goal: Predict `isFraud`{.python}, where 1 indicates a fraudulent
transaction.
:::

# Recap

::: frame
:::

::: frame
Classification Model

We can use $k$-nearest neighbors for classification:

``` {.python bgcolor="gray" fontsize="\\scriptsize"}
from sklearn.preprocessing import OneHotEncoder, StandardScaler
from sklearn.neighbors import KNeighborsClassifier
from sklearn.pipeline import make_pipeline
from sklearn.compose import make_column_transformer

pipeline = make_pipeline(
    make_column_transformer(
        (OneHotEncoder(handle_unknown="ignore", sparse_output=False),
         ["card4", "card6", "P_emaildomain"]),
        remainder="passthrough"),
    StandardScaler(),
    KNeighborsClassifier(n_neighbors=5))
```
:::

::: frame
Training a Classifier

``` {.python bgcolor="gray" fontsize="\\scriptsize"}
X_train = df_fraud.drop("isFraud", axis="columns")
y_train = df_fraud["isFraud"]
```

``` {.python bgcolor="gray" fontsize="\\scriptsize"}
from sklearn.model_selection import cross_val_score

cross_val_score(
    pipeline,
    X=X_train, y=y_train,
    scoring="accuracy",
    cv=10
).mean()
```

``` {fontsize="\\scriptsize"}
0.9681647131621484
```

How is the accuracy so high?
:::

::: frame
A Closer Look

Let's take a closer look at the labels.

``` {.python bgcolor="gray"}
y_train.value_counts()
```

``` {fontsize="\\scriptsize"}
0    56935
1     2119
Name: isFraud, dtype: int64
```

The vast majority of transactions are normal!

If we just predicted that every transaction is normal, the accuracy
would be $1 - \frac{2119}{59054} = .964$.

Even though such predictions would be accurate *overall*, it is
inaccurate for fraudulent transactions. A good model is "accurate for
every class".
:::

# Precision and Recall

::: frame
:::

::: frame
Precision and Recall

We need a score that measures "accuracy for class $c$".

There are at least two reasonable definitions:

-   **precision**: $P(\textrm{correct} | \textrm{predicted class $c$})$

    Among the observations that were predicted to be in class $c$, what
    proportion actually were?

-   **recall**: $P(\textrm{correct} | \textrm{actual class $c$})$.

    Among the observations that were actually in class $c$, what
    proportion were predicted to be?
:::

:::: frame
A Geometric Look at Precision and Recall

::: center
$$\begin{aligned}
\text{{\bf precision}} &= \frac{\onslide<8->{\text{TP}}}{\onslide<7->{\text{TP} + \text{FP}}} & \onslide<9->{\text{{\bf recall}} &= \frac{\onslide<11->{\text{TP}}}{\onslide<10->{\text{TP} + \text{FN}}}}
\end{aligned}$$
:::
::::

::: frame
Precision and Recall by Hand

To check our understanding of these definitions, let's calculate a few
precisions and recalls by hand.

First, summarize the results by the **confusion matrix**.

``` {.python bgcolor="gray"}
from sklearn.metrics import confusion_matrix
pipeline.fit(X_train, y_train)
y_train_ = pipeline.predict(X_train)
confusion_matrix(y_train, y_train_)
```

    array([[56817,   118],
           [ 1524,   595]])

-   What is the (training) accuracy?

-   What's the precision for normal transactions?

-   What's the recall for normal transactions?

-   What's the precision for fraudulent transactions?

-   What's the recall for fraudulent transactions?
:::

::: frame
Tradeoff between Precision and Recall

Can you imagine a classifier that always has 100% recall for class $c$,
no matter the data?

In general, if the model classifies more observations as $c$,

-   recall (for class $c$) $\uparrow$

-   precision (for class $c$) $\downarrow$

How do we compare two classifiers, if one has higher precision and the
other has higher recall?

The **F1 score** combines precision and recall into a single score:
$$\begin{aligned}
\text{F1 score} &= \text{harmonic mean of precision and recall} \\
\onslide<6->{&= 1 \Big/ \frac{1}{2} \big( \frac{1}{\text{precision}} + \frac{1}{\text{recall}}\big)}
\end{aligned}$$

To achieve a high F1 score, both precision and recall have to be high.
If either is low, then the harmonic mean will be low.
:::

::: frame
Estimating Test Precision, Recall, and F1

Remember that each class has its own precision, recall, and F1.

But Scikit-Learn requires that the `scoring=`{.python} parameter be a
single number.

For this, we can use

-   `"precision_macro"`{.python}

-   `"recall_macro"`{.python}

-   `"f1_macro"`{.python}

which average the score over the classes.

``` {.python bgcolor="gray"}
cross_val_score(
    pipeline,
    X=X_train, y=y_train,
    scoring="f1_macro",
    cv=10
).mean()
```

    0.6475574801118277
:::

::: frame
Precision-Recall Curve

Another way to illustrate the tradeoff between precision and recall is
to graph the **precision-recall curve**.

First, we need the predicted probabilities.

``` {.python bgcolor="gray"}
y_train_probs_ = pipeline.predict_proba(X_train)
y_train_probs_
```

``` {fontsize="\\scriptsize"}
array([[1. , 0. ],
       [1. , 0. ],
       [0.6, 0.4],
       ...,
       [1. , 0. ],
       [0.8, 0.2],
       [1. , 0. ]])
```

By default, Scikit-Learn classifies a transaction as fraud if this
probability is $> 0.5$.

What if we instead used a threshold $t$ other than $0.5$?

Depending on which $t$ we pick, we'll get a different precision and
recall. We can graph this tradeoff.
:::

:::: frame
Precision-Recall Curve

::: center
Let's graph the precision-recall curve in a Colab.

[![image](../colab){width=".5\\textwidth"}](https://colab.research.google.com/drive/1_PE-a1mitBjgOLsG3P4p9DXURXAjAzMF?usp=sharing)
:::
::::

---
author:
- |
  Dennis Sun\
  Stanford University\
  DATASCI 112
date: |
  ![image](../logo){width="25pt"}\
  February 14, 2024
title: |
  Lecture 14\
  Classification and $K$-Nearest Neighbors
---

::: frame
:::

::: frame
:::

# Recap

::: frame
:::

::: frame
Recap

So far, we've been looking at **regression** problems, where the label
$y$ we are trying to predict is quantitative (e.g., price of wine).

Today, we switch to **classification** problems, where the label $y$ is
categorical.

We will focus on the differences between regression and classification.
:::

# Case Study: Breast Tissue Classification

::: frame
:::

:::: frame
Breast Tissue Classification

Electrical signals can be used to detect whether tissue is cancerous.

::: center
![image](breast_diagram){width=".4\\textwidth"}
:::

The goal is to determine whether a sample of breast tissue is:

1\. connective tissue\
2. adipose tissue\
3. glandular tissue

4\. carcinoma\
5. fibro-adenoma\
6. mastopathy
::::

::: frame
Reading in the Data

``` {.python bgcolor="gray" fontsize="\\scriptsize"}
import pandas as pd
df = pd.read_csv("https://datasci112.stanford.edu/data/BreastTissue.csv")
df
```

![image](dataframe){width="\\textwidth"}

We will focus on two features:

-   $I_0$: impedivity at 0 kHz,

-   $PA_{500}$: phase angle at 500 kHz.
:::

:::: frame
Visualizing the Data

::: center
:::
::::

:::: frame
Visualizing the Data

::: center
![image](scatter_with_neighbors){width=".7\\textwidth"}
:::

Of its 5 nearest neighbors in the training data:

so our best guess is that it is a carcinoma.
::::

# $K$-Nearest Neighbors Classification

::: frame
:::

::: frame
$K$-Nearest Neighbors

``` {.python bgcolor="gray"}
X_train = df[["I0", "PA500"]]
y_train = df["Class"]

x_test = pd.Series({"I0": 400, "PA500": .18})
X_test = x_test.to_frame().T
X_test
```

![image](X_test){width=".15\\textwidth"}

Here is code we used for $k$-nearest neighbor [regression]{.underline}.
:::

::: frame
$K$-Nearest Neighbors

``` {.python bgcolor="gray"}
from sklearn.preprocessing import StandardScaler
from sklearn.neighbors import KNeighborsClassifier
from sklearn.pipeline import make_pipeline

pipeline = make_pipeline(
    StandardScaler(),
    KNeighborsClassifier(n_neighbors=5, metric="euclidean"))

pipeline.fit(X_train, y_train)
pipeline.predict(X_test)
```

    array(['car'], dtype=object)

Instead of returning a single predicted class, we can ask it to return
the predicted probabilities for each class.

``` {.python bgcolor="gray"}
pipeline.predict_proba(X_test)
```

    array([[0. , 0.6, 0. , 0.2, 0. , 0.2]])

``` {.python bgcolor="gray"}
pipeline.classes_
```

    array(['adi', 'car', 'con', 'fad', 'gla', 'mas'], dtype=object)

How did Scikit-Learn calculate these predicted probabilities?
:::

::: frame
Cross-Validation for Classification

Here is code we used to cross-validate a [regression]{.underline} model.

We need a different scoring method for classification. A simple one is
**accuracy**:
$$\text{accuracy} = \frac{\text{\# correct predictions}}{\text{\# predictions}}.$$
:::

::: frame
Cross-Validation for Classification

``` {.python bgcolor="gray"}
from sklearn.model_selection import cross_val_score

scores = cross_val_score(
    pipeline, X_train, y_train,
    scoring="accuracy",
    cv=10)
scores
```

    array([0.63636364, 0.81818182, 0.45454545, 0.54545455, 0.63636364,
           0.54545455, 0.5       , 0.6       , 0.4       , 0.7       ])

As before, we can get an overall estimate of test accuracy by averaging
the cross-validation accuracies:

``` {.python bgcolor="gray"}
scores.mean()
```

    0.5836363636363637

Accuracy is not always the best measure of a classification model.

We'll talk about some better measures next time.
:::

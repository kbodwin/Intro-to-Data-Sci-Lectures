---
author:
- |
  Dennis Sun\
  Stanford University\
date: |
  ![image](../logo){width="25pt"}\
  January 8, 2024
title: |
  Lecture 1\
  Introduction to Data Science
---

::: frame
:::

::: frame
:::

# Background

::: frame
:::

::: frame
About Me

-   I joined Stanford as a statistics professor in January 2023.

-   I was a Ph.D. student at Stanford from 2010-2015.

-   From 2016-2022, I was a statistics and computer science professor at Cal Poly, San Luis Obispo.

-   I am also concurrently a Data Scientist at Google.
:::

::: frame
About this Course

-   is a new course that I developed, based on a course I taught at Cal Poly.

-   This is only the second offering of the course at Stanford.

-   It is now the gateway course for the B.A. and the B.S. in Data Science.

-   This course is designed for freshmen and sophomores who are exploring Data Science as a major, but everyone is welcome!

-   If you can't take the course this quarter, it will be offered again next quarter.
:::

::: frame
How is this Course Different?

-   Unlike most data science or machine learning classes on campus, has no math or statistics prereqs.

-   To begin doing data science, you need to know how to program (a bit). So is a prereq.

-   But you don't need a lot of math. We will rely on geometric intuition in this class.

-   But there are many mathematics connections, which I will hint at and which I hope will encourage you to take classes like (linear algebra) and (probability).

::: center
:::
:::

# Course Logistics

::: frame
:::

::: frame
Course Website

::: center
![image](../logo){width="35pt"}

Your one-stop shop for everything related to this course:

<https://datasci112.stanford.edu/>

Please bookmark this page.

(P.S. There is no Canvas for this course!)
:::
:::

::: frame
Course Requirements

-   Lectures on MWF will *introduce* the concepts.

-   Sections on TuTh will *reinforce* the concepts.

    -   Before each section, exercises will be posted on the [course website](https://datasci112.stanford.edu/schedule.html).

    -   In section, [you]{.underline} will present and discuss solutions to these exercises.

    -   Participation is required and counts ${\bf 10\%}$ toward your grade.

-   Occasionally, there will be a guest lecturer. You are required to attend at least two guest lectures, and write a short reflection. This counts ${\bf 5\%}$ toward your grade.
:::

::: frame
Course Requirements

-   There will be 5 labs, each consisting of two parts, counting ${\bf 15\%}$ toward your grade.

    -   One part will be assigned every two lectures and due one week later at 8 AM.

    -   No extensions will be granted under any circumstances, so please plan ahead.

    -   There will be an optional Lab 6 due during Week 10 that will replace your lowest lab part.

-   There will be two 80-minute midterms, counting ${\bf 35\%}$ toward your grade.

-   Instead of a final exam, there will be a final project, counting ${\bf 35\%}$ toward your grade.

    -   This is an opportunity for you to explore a data set that is meaningful to you and start a portfolio.

    -   There will be a poster session during the scheduled final exam time.

::: center
More information about grading on the [course website](https://datasci112.stanford.edu/).
:::
:::

# Introduction to Data

::: frame
:::

::: frame
What Does Data Look Like?

::: center
:::
:::

::: frame
How is Tabular Data Represented on Disk?

::: center
![image](titanic_small){width=".9\\textwidth"}

$\Downarrow$

``` {fontsize="\\tiny"}
name,pclass,survived,sex,age,sibsp,parch,ticket,fare,cabin,embarked,boat,body,home.dest
"Allen, Miss. Elisabeth Walton",1,1,female,29,0,0,24160,211.3375,B5,S,2,,"St Louis, MO"
"Allison, Master. Hudson Trevor",1,1,male,0.9167,1,2,113781,151.5500,C22 C26,S,11,,"Montreal, PQ / Chesterville, ON"
"Allison, Miss. Helen Loraine",1,0,female,2,1,2,113781,151.5500,C22 C26,S,,,"Montreal, PQ / Chesterville, ON"
"Allison, Mr. Hudson Joshua Creighton",1,0,male,30,1,2,113781,151.5500,C22 C26,S,,135,"Montreal, PQ / Chesterville, ON"
"Allison, Mrs. Hudson J C (Bessie Waldo Daniels)",1,0,female,25,1,2,113781,151.5500,C22 C26,S,,,"Montreal, PQ / Chesterville, ON"
"Anderson, Mr. Harry",1,1,male,48,0,0,19952,26.5500,E12,S,3,,"New York, NY"
"Andrews, Miss. Kornelia Theodosia",1,1,female,63,1,0,13502,77.9583,D7,S,10,,"Hudson, NY"
"Andrews, Mr. Thomas Jr",1,0,male,39,0,0,112050,0.0000,A36,S,,,"Belfast, NI"
"Appleton, Mrs. Edward Dale (Charlotte Lamson)",1,1,female,53,2,0,11769,51.4792,C101,S,D,,"Bayside, Queens, NY"
"Artagaveytia, Mr. Ramon",1,0,male,71,0,0,PC 17609,49.5042,,C,,22,"Montevideo, Uruguay"
"Astor, Col. John Jacob",1,0,male,47,1,0,PC 17757,227.5250,C62 C64,C,,124,"New York, NY"
```

Comma-Separated Values (CSV) format
:::
:::

::: frame
How is Tabular Data Represented in Python?

::: center
![image](titanic_small){width=".9\\textwidth"}

$\Downarrow$

`DataFrame`{.python}

Let's interact with this data using Python in a **notebook**.

[![image](../colab){width=".2\\textwidth"}](https://colab.research.google.com/drive/1uQu19Wv-AYy40MVLVlFQc-12DXd3WY9t?usp=sharing)

All of our code will be written in Colab notebooks like this one.
:::
:::

::: frame
Review: Categorical Variables

To *summarize* a categorical variable, we report the **counts** of each possible category.

``` {.python bgcolor="gray"}
df["pclass"].value_counts()
```

``` {fontsize="\\tiny"}
3    709
1    323
2    277
Name: pclass, dtype: int64
```

To *visualize* a categorical variable, we make a **bar plot**.

``` {.python bgcolor="gray"}
df["pclass"].value_counts().plot.bar()
```
:::

::: frame
Review: Categorical Variables

To *summarize* a categorical variable, we report the **counts** of each possible category.

``` {.python bgcolor="gray"}
df["pclass"].value_counts()
```

``` {fontsize="\\tiny"}
3    709
1    323
2    277
Name: pclass, dtype: int64
```

To *visualize* a categorical variable, we make a **bar plot**.

``` {.python bgcolor="gray" escapeinside="||"}
df["pclass"].value_counts()|\textcolor{red}{.sort\_index()}|.plot.bar()
```
:::

# A Look Ahead

::: frame
:::

::: frame
The Three Parts of

To paraphrase [a famous historical figure](https://classics.mit.edu/Caesar/gallic.1.1.html),

" est omnis divisa in partes tres..."

1.  summarizing and visualizing tabular data

2.  other shapes of data: textual, hierarchical, geospatial

3.  machine learning
:::

::: frame
Sections This Week

You should already been enrolled in one of 6 sections.

-   Check your enrollment for the room and time.

-   Your TA is listed on the [course website](https://datasci112.stanford.edu/).

-   Tomorrow's section is *optional*. Take a look at the Colab, and see if you would benefit from a walkthrough.

-   Starting Thursday, you are expected to attend the section you are enrolled in. (If you have a conflict, please e-mail your TA and CA.)

-   Bring your laptops to section so that you can follow along!
:::

::: frame
-   Office hours start tomorrow.

-   The course website will be updated with the times and locations.

-   Come see me after class if you have any questions about enrolling in this course.

::: center
I am excited about this class, and I hope you are too!

[**See you on Wednesday!**]{style="color: stanfordred"}
:::
:::

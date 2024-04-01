---
author:
- |
  Dennis Sun\
  Stanford University\
  DATASCI 112
date: |
  ![image](../logo){width="25pt"}\
  February 26, 2024
title: |
  Lecture 18\
  Web Scraping
---

::: frame
:::

# Recap

::: frame
:::

:::: frame
Hierarchical Data

::: center
![image](hierarchical_data){width=".5\\textwidth"}
:::

-   Hierarchical data can be represented using JSON or XML.

-   JSON is just like a Python dictionary.

    -   You can use basic Python to extract the information you want.

    -   There are built-in functions like `pd.json_normalize`{.python}
        to "flatten" JSON to tabular data.

-   XML is a different beast.
::::

::: frame
XML

-   Fields are represented by named *tags*.

-   Each tag has an open `<tag>`{.xml} and a close `</tag>`{.xml}.

-   Children are represented by nested tags.

-   Repeated fields are represented by repeated tags.

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

# HTML Crash Course

::: frame
:::

::: frame
HyperText Markup Language (HTML)

-   HTML is the standard language for describing the layout of webpages.

-   It is like XML, with special tags for hyperlinks, tables, images,
    etc.

-   You don't need to be an HTML expert to scrape webpages, but you do
    need to know a few basics.
:::

:::: frame
Hyperlinks

The `<a>`{.xml} tag indicates a (hyper)link.

-   The `href=`{.xml} attribute contains the URL.

-   The displayed text is within the `<a>`{.xml} tag.

[Example:]{style="color: stanfordred"}

``` xml
Web Scraping<br/>
  <a href="lectures/lecture18.pdf">
    slides
  </a> |
  <a href="https://colab.research.google.com/drive/1neQvH5uqoX1j74rgCbperbi-HV3uLd8N?usp=sharing">
    colab
  </a>
```

::: center
$\displaystyle\Downarrow$

![image](link){width="30%"}
:::
::::

::: frame
Tables

The `<table>`{.xml} tag indicates a table.

-   The `<tr>`{.xml} tag indicates a row.

-   The `<th>`{.xml} and `<td>`{.xml} tags indicate a cell within a row.

``` {.xml fontsize="\\scriptsize"}
<table>
  <tr>
    <th>Rank</th>
    <th>Player</th>
    <th>Saves</th>
  </tr>
  <tr>
    <td>1</td>
    <td>Mariano Rivera</td>
    <td>652</td>
  </tr>
  <tr>
    <td>2</td>
    <td>Trevor Hoffman</td>
    <td>601</td>
  </tr>
</table>
```

$\Longrightarrow$

![image](table){width="\\textwidth"}
:::

# Web Scraping

::: frame
:::

:::: frame
Web Scraping

::: center
Let's use what we've just learned to scrape some data!

[![image](../colab){width=".5\\textwidth"}](https://colab.research.google.com/drive/1neQvH5uqoX1j74rgCbperbi-HV3uLd8N?usp=sharing)
:::
::::

# Ethics of Web Scraping

::: frame
:::

::: frame
Ethical Considerations

-   Website owners have to pay a small amount each time you visit a
    webpage.

-   This is usually offset by advertising.

-   But when you do web scraping:

    -   it is easy to rack up many webpage visits,

    -   and you don't see any ads to offset this cost.
:::

::: frame
`robots.txt`

-   Most websites have a `robots.txt` file in the home directory that
    indicate which bots are allowed to scrape and which pages they can
    scrape.

-   Here are a few examples:

    -   <http://www.espn.com/robots.txt>

    -   <http://www.nytimes.com/robots.txt>

-   However, `robots.txt` is informational only. It doesn't *prevent*
    bots from scraping a webpage.
:::

::: frame
Preventing Web Scraping

Some websites take more drastic measures to prevent web scraping\...

![image](scraping){width="\\textwidth"}
:::

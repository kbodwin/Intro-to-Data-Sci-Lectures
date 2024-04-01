---
author:
- |
  Dennis Sun\
  Stanford University\
  DATASCI 112
date: |
  ![image](../logo){width="25pt"}\
  March 8, 2024
title: |
  Lecture 22\
  Map Projections and Dot Maps
---

::: frame
:::

::: frame
:::

# The Power of Maps

::: frame
:::

:::: frame
Who is John Snow?

::: center
:::
::::

::: frame
1854 Broad Street Cholera Outbreak

-   In 1854, London was hit by a severe cholera outbreak.

-   At the time, the cause of cholera was not known. There were two
    theories: the germ theory and the miasma theory.

-   John Snow decided to investigate the cause, and he started by making
    a **dot map**.
:::

:::: frame
John Snow's Dot Map

::: center
![image](cholera){height="\\textheight"}
:::
::::

:::: frame
::: center
![image](cholera_zoom2){width="\\textwidth"}

Each "dot" (thin black box) represents a cholera case.
:::
::::

:::: frame
::: center
![image](cholera_zoom){width="\\textwidth"}

Snow observed that cholera cases centered around the Broad Street water
pump.
:::
::::

::: frame
Snow's Analysis

Snow followed up on the insight with careful, on-the-ground detective
work.

![image](snow_book){width="\\textwidth"}

> There were only ten deaths in houses situated decidedly nearer to
> another street-pump. In five of these cases the families of the
> deceased persons informed me that they always sent to the pump in
> Broad Street, as they preferred the water to that of the pumps which
> were nearer. In three other cases, the deceased were children who went
> to school near the pump in Broad Street\....
:::

::: frame
The End of the Story

In the end, Snow was able to build a strong case that the Broad Street
pump was the source of the cholera outbreak.
:::

# Map Projections

::: frame
:::

:::: frame
Geographical Center of North America

In 1930, a USGS employee took a cutout of the map of North America and
balanced it on the top of a pin.

::: center
![image](geographical-center-balancing-act){width="\\textwidth"}
:::

They found that the center was a town called Rugby, ND.

![image](rugby){width="\\textwidth"}
::::

:::: frame
Dispute with Robinson, ND

Meanwhile, Bill Bender of Robinson, ND (100 miles to the south of Rugby)
claimed that the center of North America was under his bar, Hanson's
Bar.

::: center
![image](robinson){width=".7\\textwidth"}
:::

They trademarked the phrase "Geographical Center of North America".
::::

::: frame
A Third Contender

Peter Rogerson, a professor of Geography and Biostatistics, got wind
about this debate.

![image](rogerson){width="\\textwidth"}

He took latitudes and longitudes from all around North America, and used
those coordinates to find the center.

"You have to take into account that the Earth's surface is curved."

He found that the geographical center was in a town called\... Center,
ND (no joke!).
:::

:::: frame
The Geographical Center

::: center
![image](map-north-america){width=".7\\textwidth"}
:::

The controversy started because of the way the Earth's surface was
flattened. Depending on which way you flatten, you'll get a different
center.
::::

:::: frame
Map Projection

**Map projection** refers to the way the curved surface of the Earth is
represented as a flat surface.

One of the earliest projections was proposed by Gerardus Mercator in
1569.

![image](gerardus_mercator){width=".8\\textwidth"}

::: center
![image](mercator_projection){width=".7\\textwidth"}
:::
::::

::: frame
*The West Wing* on Map Projections

(Click on the image to watch the clip.)

[![image](westwing){width="\\textwidth"}](https://youtube.com/watch?v=vVX-PrBRtTY)
:::

:::: frame
::: center
  -------------------------------------------- -----------------------------------------------
     [Mercator]{style="color: stanfordred"}       [Gall-Peters]{style="color: stanfordred"}
               (angle-preserving)                    (equal-area, but distorted shapes)
   ![image](mercator){width=".35\\textwidth"}   ![image](gall-peters){width=".45\\textwidth"}
                                               
                                               
                                               
  -------------------------------------------- -----------------------------------------------
:::
::::

:::: frame
::: center
[![image](favorite-map-projection-1){height=".95\\textheight"}](https://xkcd.com/977/)
![image](favorite-map-projection-2){height=".95\\textheight"}
:::
::::

# Making Dot Maps

::: frame
:::

:::: frame
::: center
Let's recreate John Snow's cholera map in Colab, using our knowledge of
map projections.

[![image](../colab){width=".5\\textwidth"}](https://colab.research.google.com/drive/1GW28oHlLGHP9SB0f9QHJ19WtwZhIo7Dp?usp=sharing)
:::
::::

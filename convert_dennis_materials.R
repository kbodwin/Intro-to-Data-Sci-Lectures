library(tidyverse)

folders <- paste0("../lectures/lecture", 1:23)

source_slides <- map(folders, 
                     ~list.files(.x, pattern = "*.tex$", full.names = TRUE)) |> unlist()

pandoc_calls <- map2_chr(source_slides, 1:23,
                        ~glue::glue("pandoc -s {.x} -o dennis_lecture_{.y}.md"))

walk(pandoc_calls, ~system(.x))


source_images <- map(folders, 
                     ~list.files(.x, pattern = "*.(png)|(jpg)", full.names = TRUE))

images_names <- map(folders, 
                     ~list.files(.x, pattern = "*.(png)|(jpg)"))

walk2(source_images, images_names,
      ~file.copy(from=.x, to=paste0("images/", .y)))
      
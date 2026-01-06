library(tidyverse)

# ============================================================
# Lists in R
# ============================================================
# A list is like a vector, but with one huge superpower:
# each element can be a DIFFERENT type/shape.
# A list element can be: text, numeric, logical, vector, data frame,
# function, model object, or even another list (nested lists).

df <- data.frame(colA = 1:10, colB = rep("A", 10))

# ------------------------------------------------------------
# Create a list
# ------------------------------------------------------------
a.list <- list(
  "Blue",                # character scalar
  10,                    # numeric scalar
  c(21, 32, 11),         # numeric vector
  TRUE,                  # logical scalar
  df                     # data.frame
)
a.list

# Quick look at structure (great for teaching!)
str(a.list)

# ------------------------------------------------------------
# Indexing: [ ] vs [[ ]] vs $
# ------------------------------------------------------------
# [ ] returns a SUBLIST (still a list)
a.list[1]
a.list[c(1, 4)]

# [[ ]] returns the ELEMENT itself (drops the list container)
# This is analogous to vector indexing x[1] giving you the element.
a.list[[1]]

# $ is a convenient way to access NAMED elements (only works for named lists)
# a.list$color  # won't work because a.list isn't named

# ------------------------------------------------------------
# Named lists
# ------------------------------------------------------------
b.list <- list(
  color   = "Blue",
  id      = 10,
  summary = c(21, 32, 11),
  afib    = TRUE,
  data    = df
)
b.list
str(b.list)

# Single [ ] with a name returns a sublist
b.list["color"]

# Double [[ ]] with a name returns the element itself
b.list[["color"]]

# You can also use $ for named elements (very common)
b.list$color

# Retrieve list element names
names(b.list)

# ------------------------------------------------------------
# Add / modify elements
# ------------------------------------------------------------
# $ is easy for new named elements
b.list$age <- 40

# [[ ]] also works (useful when the name is stored in a variable)
b.list[["sex"]] <- "F"

names(b.list)

# ------------------------------------------------------------
# unlist(): convert list to a vector (with caveats!)
# ------------------------------------------------------------
# unlist will try to coerce everything into a single atomic vector.
# This works nicely only when everything is "simple" and compatible.
# Here, b.list includes a data.frame -> coercion will get weird/noisy.
unlist(b.list)

# TIP for teaching:
# unlist is great for lists that are *all* numeric or *all* character:
simple_num_list <- list(a = 1, b = 2, c = 3)
unlist(simple_num_list)

# ============================================================
# Looping over lists
# ============================================================

d.list <- list("purple", "green", "red")

# A for-loop works, but hard-coding lengths is fragile
for (i in 1:3) {
  print(d.list[[i]])
}

# Better: loop over length(d.list)
for (i in seq_along(d.list)) {  # seq_along is safer than 1:length
  print(d.list[[i]])
}

# Saving results with a for-loop: pre-allocate or grow carefully
newlist <- vector("list", length(d.list))
for (i in seq_along(d.list)) {
  # NOTE: print() returns its input invisibly, so this "works",
  # but it's a bit of a teaching gotcha.
  newlist[[i]] <- d.list[[i]]
  print(d.list[[i]])
}
newlist

# ------------------------------------------------------------
# "R way": lapply() returns a list
# ------------------------------------------------------------
# lapply applies a function to each element and returns a list
newlist <- lapply(d.list, print)
newlist

# ------------------------------------------------------------
# tidyverse way: purrr::map()
# ------------------------------------------------------------
newlist <- map(d.list, print)
newlist

# map_* variants return typed vectors (super useful!)
map_chr(d.list, toupper)   # returns a character vector
map_int(list(1.2, 2.8), round)  # returns an integer vector

# ============================================================
# Lists with numeric vectors
# ============================================================

# Your code: list of numeric vectors
c.list <- list(
  runif(10, min = 1, max = 25),
  runif(10, min = 1, max = 25),
  runif(10, min = 1, max = 25)
)
c.list

# Base R
lapply(c.list, mean)

# purrr
map(c.list, mean)

# If you want a numeric VECTOR back, use map_dbl()
map_dbl(c.list, mean)

# ============================================================
# Additional useful list examples
# ============================================================

# ------------------------------------------------------------
# 1) Nested lists (lists inside lists)
# ------------------------------------------------------------
nested <- list(
  meta = list(project = "Peds", n = 10),
  colors = list(primary = "blue", secondary = "orange"),
  table = df
)

# Access nested elements
nested$meta$project
nested[["colors"]][["secondary"]]

# ------------------------------------------------------------
# 2) Safe extraction with defaults (prevent errors)
# ------------------------------------------------------------
# Sometimes an element may not exist; purrr gives safer helpers:
x <- list(a = 1)

# This would error:
# x$b

# This returns default instead of error:
pluck(x, "b", .default = NA)

# ------------------------------------------------------------
# 3) map over a list of data frames
# ------------------------------------------------------------
df_list <- list(
  d1 = tibble(id = 1:3, val = c(10, 20, 30)),
  d2 = tibble(id = 4:6, val = c(5,  15, 25))
)

# Apply the same transformation to each data frame
df_list2 <- map(df_list, ~ mutate(.x, z = scale(val)[,1]))
df_list2

# Combine them into one data frame afterwards
bind_rows(df_list2, .id = "source")

# ------------------------------------------------------------
# 4) List-columns (very tidyverse-y, very powerful)
# ------------------------------------------------------------
# A tibble column can itself contain lists (each row holds a mini-object)
tbl <- tibble(
  group = c("A", "B"),
  values = list(c(1, 2, 3), c(10, 20))
)

tbl

# Summarize list-column with map_* into normal columns
tbl %>%
  mutate(
    n = map_int(values, length),
    mean = map_dbl(values, mean)
  )

# If list-column holds data frames, you can unnest them
tbl_df <- tibble(
  group = c("A", "B"),
  data = list(
    tibble(x = 1:2, y = c("a", "b")),
    tibble(x = 3:4, y = c("c", "d"))
  )
)

tbl_df %>%
  unnest(data)

# ------------------------------------------------------------
# 5) split() creates lists (common pattern)
# ------------------------------------------------------------
# split a data frame into a list by a grouping variable
split_by_colB <- split(df, df$colB)
split_by_colB

# Then analyze each piece
map(split_by_colB, ~ summarise(.x, meanA = mean(colA)))

# ------------------------------------------------------------
# 6) Functional programming pattern: map + set_names
# ------------------------------------------------------------
# Make three random vectors and name them cleanly
named_rand <- map(1:3, ~ runif(5)) %>% set_names(paste0("rep", 1:3))
named_rand
map_dbl(named_rand, mean)

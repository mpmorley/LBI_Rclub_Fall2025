# =============================================================================
# Introduction to purrr: From Base R to Functional Programming
# =============================================================================
# This script walks through iteration in R across three "eras":
#   1. Base R control structures (for, while)
#   2. Base R apply family (lapply, sapply, vapply)
#   3. purrr::map and friends
#
# The goal is to show the same operations written progressively, so you can
# see exactly what purrr replaces and why it's worth the switch.
# =============================================================================

library(purrr)

# We'll use this simple list and numeric vector throughout
numbers <- list(a = 1:5, b = 6:10, c = 11:15)
words   <- c("hello", "world", "foo", "bar")


# =============================================================================
# PART 1: Base R Control Structures
# =============================================================================

# --- for loop ----------------------------------------------------------------
# Classic approach: pre-allocate a results container, then fill it in a loop.
# Verbose and error-prone (easy to forget pre-allocation → slow for large data).

means_for <- vector("numeric", length(numbers))  # pre-allocate!
for (i in seq_along(numbers)) {
  means_for[i] <- mean(numbers[[i]])
}
names(means_for) <- names(numbers)
print(means_for)
# a    b    c
# 3    8   13


# --- while loop --------------------------------------------------------------
# while is useful when you don't know iteration count in advance.
# Here: keep squaring a number until it exceeds 1000.

x <- 2
steps <- 0
while (x < 1000) {
  x <- x^2
  steps <- steps + 1
}
cat("Exceeded 1000 after", steps, "steps. Final value:", x, "\n")


# --- nested for loop ---------------------------------------------------------
# Things get messy fast. Here we compute the range (max - min) for each
# element of `numbers` by hand, just to illustrate the verbosity.

ranges_for <- vector("numeric", length(numbers))
for (i in seq_along(numbers)) {
  vec <- numbers[[i]]
  rng <- vec[1]  # placeholder
  for (j in seq_along(vec)) {
    if (j == 1) {
      lo <- vec[j]; hi <- vec[j]
    } else {
      if (vec[j] < lo) lo <- vec[j]
      if (vec[j] > hi) hi <- vec[j]
    }
  }
  ranges_for[i] <- hi - lo
}
# Of course diff(range(x)) does this in one line — the point is showing loops.


# =============================================================================
# PART 2: Base R Apply Family
# =============================================================================
# apply functions eliminate the loop boilerplate and are generally faster,
# but the family is inconsistent: lapply, sapply, vapply, tapply, mapply...
# each has slightly different rules for inputs and outputs.

# --- lapply ------------------------------------------------------------------
# Always returns a LIST. Safe but sometimes you have to unlist manually.

means_lapply <- lapply(numbers, mean)
print(means_lapply)
# $a [1] 3   $b [1] 8   $c [1] 13


# --- sapply ------------------------------------------------------------------
# "Simplify apply" — tries to return a vector or matrix. Convenient but
# dangerous: the return type depends on the result shape at runtime.

means_sapply <- sapply(numbers, mean)
print(means_sapply)       # numeric vector — great
print(class(means_sapply))  # "numeric"

# The danger: if results have unequal lengths, sapply silently returns a list.
# This makes downstream code fragile. vapply fixes that:

# --- vapply ------------------------------------------------------------------
# Like sapply but you declare the expected output type. Fails loudly if wrong.

means_vapply <- vapply(numbers, mean, FUN.VALUE = numeric(1))
print(means_vapply)  # Same result as sapply, but type-safe


# --- anonymous functions in apply --------------------------------------------
# You can pass inline functions but the syntax is noisy.

sq_means_lapply <- lapply(numbers, function(x) mean(x^2))
print(sq_means_lapply)


# =============================================================================
# PART 3: purrr
# =============================================================================
# purrr provides a consistent, type-stable, pipe-friendly API for iteration.
# Key advantages over base apply:
#   - Consistent naming: map() always returns a list; map_dbl(), map_chr(),
#     map_lgl(), map_int() return typed atomic vectors (like vapply, but cleaner)
#   - Modern lambda syntax with \(x) or the ~.x shorthand
#   - Easy multi-input mapping with map2() and pmap()
#   - Powerful helpers: walk(), reduce(), accumulate(), keep(), discard()...

# --- map() -------------------------------------------------------------------
# Always returns a list. The purrr equivalent of lapply().

means_map <- map(numbers, mean)
print(means_map)


# --- map_dbl() ---------------------------------------------------------------
# Returns a named numeric (double) vector. Equivalent of vapply(..., numeric(1))
# but much less typing.

means_map_dbl <- map_dbl(numbers, mean)
print(means_map_dbl)
print(class(means_map_dbl))  # "numeric"


# --- map_chr() ---------------------------------------------------------------
# Returns a character vector.

upper_words <- map_chr(words, toupper)
print(upper_words)  # "HELLO" "WORLD" "FOO" "BAR"


# --- map_lgl() ---------------------------------------------------------------
# Returns a logical vector.

has_even <- map_lgl(numbers, ~ any(.x %% 2 == 0))
print(has_even)  # all TRUE since each vector spans 5 consecutive integers


# --- Lambda shorthand --------------------------------------------------------
# purrr supports two lambda styles:
#   \(x) ...      — base R lambda (R 4.1+), recommended for clarity
#   ~ .x          — purrr's formula shorthand, still widely used

# These are equivalent:
map_dbl(numbers, \(x) mean(x^2))
map_dbl(numbers, ~ mean(.x^2))


# --- map2() ------------------------------------------------------------------
# Iterate over TWO lists/vectors in parallel.

weights <- list(a = c(1,1,1,1,2), b = c(2,1,1,1,1), c = rep(1,5))

weighted_means <- map2_dbl(numbers, weights, \(vals, wts) weighted.mean(vals, wts))
print(weighted_means)


# --- pmap() ------------------------------------------------------------------
# Iterate over ANY number of inputs simultaneously by passing a named list.

params <- list(
  x    = list(1:5, 1:10, 1:20),
  trim = c(0, 0.1, 0.2)
)

trimmed_means <- pmap_dbl(params, \(x, trim) mean(x, trim = trim))
print(trimmed_means)


# --- walk() ------------------------------------------------------------------
# Like map() but used for SIDE EFFECTS (printing, writing files, plotting).
# Returns the input invisibly — keeps pipelines clean.

walk(numbers, \(x) cat("Sum:", sum(x), "\n"))


# --- keep() and discard() ----------------------------------------------------
# Filter list elements based on a predicate. Much cleaner than subsetting.

big_means  <- keep(numbers,    \(x) mean(x) > 5)   # keep where mean > 5
small_means <- discard(numbers, \(x) mean(x) > 5)  # drop where mean > 5

print(names(big_means))    # "b" "c"
print(names(small_means))  # "a"


# --- reduce() ----------------------------------------------------------------
# Fold a list down to a single value by repeatedly applying a 2-argument function.

total_sum <- reduce(numbers, \(acc, x) acc + sum(x), .init = 0)
cat("Total sum across all vectors:", total_sum, "\n")  # 120

# accumulate() is like reduce() but keeps all intermediate results
running_sums <- accumulate(1:5, `+`)
print(running_sums)  # 1 3 6 10 15


# =============================================================================
# PART 4: Piping it all together
# =============================================================================
# Where purrr really shines is inside pipes. Here's a small pipeline that:
#   1. Creates 5 random samples of different sizes
#   2. Computes the mean of each
#   3. Keeps only means above 0
#   4. Rounds to 2 decimal places

set.seed(42)
results <- list(
    s1 = rnorm(10),
    s2 = rnorm(50),
    s3 = rnorm(100, mean = -1),
    s4 = rnorm(20,  mean =  2),
    s5 = rnorm(30)
  ) |>
  map_dbl(mean) |>         # compute means  → named numeric vector
  keep(\(x) x > 0)   |>   # only positives → filtered named numeric vector
  round(2)                  # round results

print(results)


# =============================================================================
# Summary: When to use what
# =============================================================================
#
#  Goal                        | Base R           | purrr
#  ----------------------------|------------------|---------------------------
#  Iterate, return list        | lapply()         | map()
#  Iterate, return dbl vector  | vapply(,numeric) | map_dbl()
#  Iterate, return chr vector  | vapply(,character)| map_chr()
#  Iterate, side effects only  | for loop         | walk()
#  Two inputs                  | mapply()         | map2() / walk2()
#  N inputs                    | mapply()         | pmap()
#  Filter list                 | Filter()         | keep() / discard()
#  Fold to single value        | Reduce()         | reduce()
#  Cumulative fold             | Reduce(accum=T)  | accumulate()
#
# Rule of thumb:
#   - Use map_*() variants whenever you know the output type (almost always).
#   - Use walk() for side effects to keep pipelines tidy.
#   - Use map2() / pmap() when vectorizing over multiple inputs.
#   - Prefer \(x) lambda syntax over ~.x for readability in new code.

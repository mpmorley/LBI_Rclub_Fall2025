# Assignment operators

# Assign the value 10 to a variable named my_variable_name_1 using the standard R assignment operator "<-"
# This is the most common and recommended way to assign values in R.
my_variable_name_1 <- 10

# The same assignment can be done in reverse using the rightward assignment operator "->"
# Here, the value 10 is assigned to my_variable_name_2.
# While this works exactly the same, it’s less readable and rarely used in practice.
10 -> my_variable_name_2

# You can also assign values using the "=" operator, similar to other programming languages (like Python or C).
# Although it works, it’s generally discouraged for assignments in scripts because "=" is also used for function arguments.
# Using "<-" helps distinguish between assignment and argument passing, improving clarity.
my_variable_name_3 = 20



# ------------------------------------------------------------
# Basic Data Types in R
# ------------------------------------------------------------

# 1. NUMERIC (default for numbers with decimals)
# These are floating-point numbers, i.e., numbers that can have decimal places.
# R treats any number with a decimal point as a numeric (double precision) value.
numeric_example <- c(10.5, 55.4, 787)  # Create a numeric vector using the c() combine function
numeric_example
class(numeric_example)  # Check the data type ("numeric")

# ------------------------------------------------------------

# 2. INTEGER
# Integers are whole numbers without decimals.
# To explicitly declare an integer, you must append the letter "L" after the number.
integer_example <- c(1L, 55L, 100L)
integer_example
class(integer_example)  # Should return "integer"

# Note: If you omit the "L", R assumes numeric (double) by default.
typeof(55)    # "double"
typeof(55L)   # "integer"

# ------------------------------------------------------------

# 3. COMPLEX
# Complex numbers have a real part and an imaginary part.
# The imaginary part is represented by "i".
complex_example <- c(9 + 3i, 2 - 4i)
complex_example
class(complex_example)  # Should return "complex"

# You can perform arithmetic on complex numbers as well.
complex_example * (1 + 1i)

# ------------------------------------------------------------

# 4. CHARACTER (also known as STRING)
# Character data represents text, enclosed in quotation marks.
# This can include letters, words, or even numbers written as text.
character_example <- c("k", "R is exciting", "FALSE", "11.5")
character_example
class(character_example)  # Should return "character"

# Note that "FALSE" and "11.5" here are characters, not logical or numeric values.
# You can convert between types if needed:
as.numeric("11.5")   # Converts to numeric 11.5
as.logical("FALSE")  # Converts to FALSE

# ------------------------------------------------------------

# 5. LOGICAL (also known as BOOLEAN)
# Logical values represent TRUE or FALSE.
logical_example <- c(TRUE, FALSE, TRUE)
logical_example
class(logical_example)  # Should return "logical"

# Logical values are often used in conditional statements and indexing.
# You can also perform arithmetic with them (TRUE = 1, FALSE = 0):
sum(logical_example)  # Counts how many TRUE values
mean(logical_example) # Proportion of TRUE values

# ============================================================
# 📘 VECTORS IN R
# ------------------------------------------------------------
# A vector is the most basic data structure in R.
# It is a sequence of elements that are all of the SAME type
# (numeric, integer, character, logical, or complex).
# ============================================================

# ------------------------------------------------------------
# 1. Creating a numeric vector
# ------------------------------------------------------------

# Use the c() function ("combine" or "concatenate") to create a vector.
numeric_vector <- c(10.5, 55, 787)

# Print the vector to see its contents.
numeric_vector

# Check the class/type of the vector.
class(numeric_vector)  # "numeric"
typeof(numeric_vector) # "double" (R internally represents most numbers as double precision)

# You can access elements by index using square brackets.
numeric_vector[1]  # First element (10.5)
numeric_vector[2:3]  # Elements 2 through 3

# ------------------------------------------------------------
# 2. Creating an integer vector
# ------------------------------------------------------------

# Add "L" after numbers to explicitly declare integers.
integer_vector <- c(1L, 55L, 100L)
integer_vector
class(integer_vector)  # "integer"

# Confirm the type (low-level representation)
typeof(integer_vector)  # "integer"

# R will automatically convert integers to numeric if mixed together.
mixed_num <- c(1L, 2.5)
mixed_num
class(mixed_num)  # "numeric" (type coercion occurs)

# ------------------------------------------------------------
# 3. Creating a character (string) vector
# ------------------------------------------------------------

# Character vectors contain text values in quotes.
char_vector <- c("R", "is", "exciting", "and", "powerful")
char_vector
class(char_vector)  # "character"

# Concatenate characters into a single string using paste() or paste0().
sentence <- paste(char_vector, collapse = " ")
sentence  # "R is exciting and powerful"

# ------------------------------------------------------------
# 4. Creating a logical (boolean) vector
# ------------------------------------------------------------

logical_vector <- c(TRUE, FALSE, TRUE, TRUE)
logical_vector
class(logical_vector)  # "logical"

# Logical vectors are useful for filtering and conditions.
# Example: Create a numeric vector and use a logical condition to subset it.
numbers <- c(5, 12, 7, 20)
numbers[numbers > 10]  # Returns values greater than 10 → 12 and 20

# Logical vectors behave like 1 (TRUE) and 0 (FALSE) in numeric operations.
sum(logical_vector)   # Counts TRUE values (3)
mean(logical_vector)  # Proportion of TRUE values (0.75)

# ----------

# ============================================================
# 🧮 FUNCTIONS AND OPERATIONS FOR VECTORS
# ============================================================

# Let's assume r50 is a numeric vector.
# For example:
r50 <- sample(1:50, 20, replace = TRUE)  # A random numeric vector with 20 elements
r50

# ------------------------------------------------------------
# 1. Basic numeric vector functions
# ------------------------------------------------------------

# Get the number of elements in the vector
length(r50)     # Counts how many values are in r50

# Sort the vector in ascending order (smallest → largest)
sort(r50)

# You can also sort in descending order:
sort(r50, decreasing = TRUE)

# ------------------------------------------------------------
# 2. Summary statistics
# ------------------------------------------------------------

# The summary() function gives a quick overview depending on type:
# For numeric vectors: Min, 1st Qu., Median, Mean, 3rd Qu., Max
summary(r50)

# Calculate the mean (average value)
mean(r50)

# Minimum and maximum values
min(r50)
max(r50)

# Standard deviation — measure of spread around the mean
sd(r50)

# Median (the middle value)
median(r50)

# Range (max - min)
range(r50)

# Variance (square of standard deviation)
var(r50)

# ------------------------------------------------------------
# 3. Vectors can store multiple data types
# ------------------------------------------------------------

# Character (string) vectors
c1 <- c('DCM', 'DCM')
c2 <- c('HCM', 'HCM', 'HCM')

# Combine (concatenate) two character vectors into one
c3 <- c(c1, c2)
c3   # Displays: "DCM" "DCM" "HCM" "HCM" "HCM"

# You can check how many elements of each type you have using table()
table(c3)

# ------------------------------------------------------------
# 4. Using rep() to repeat elements
# ------------------------------------------------------------

# Here we create a vector of group labels with repeated values.
# The rep() function repeats its first argument a given number of times.
groups <- c(rep('DCM', 10),
            rep('HCM', 15),
            rep('NF', 20),
            rep('nonfail', 5))
groups

# Quickly summarize how many times each label appears.
table(groups)

# ------------------------------------------------------------
# 5. Creating random categorical (character) vectors
# ------------------------------------------------------------

# sample() randomly picks elements from a specified set.
# 'replace = TRUE' allows the same value to appear multiple times.
groups.a <- sample(c('DCM', 'HCM', 'NF'), 50, replace = TRUE)
groups.a

# Example with a smaller sample
groups.a <- sample(c('DCM', 'HCM', 'NF'), 4, replace = TRUE)
groups.a

# Use table() to count each category.
table(groups.a)

# You can control the probability (weight) of sampling each category.
# Example: 20% DCM, 30% HCM, 50% NF
groups.b <- sample(c('DCM', 'HCM', 'NF'), 50, replace = TRUE, prob = c(0.2, 0.3, 0.5))
groups.b

# Convert to a factor for better summary display.
summary(factor(groups.b))

# ------------------------------------------------------------
# 6. Logical (Boolean) vectors
# ------------------------------------------------------------

# Create a logical vector with TRUE/FALSE (or T/F) values.
logical <- c(TRUE, FALSE, FALSE, TRUE, TRUE)
logical

# Logical vectors are very useful for subsetting and counting.
# TRUE is treated as 1, FALSE as 0 in numeric operations.
sum(logical)   # Counts how many TRUE values (3)
mean(logical)  # Proportion of TRUE values (3/5 = 0.6)

# ------------------------------------------------------------
# 7. Summing and comparing different types
# ------------------------------------------------------------

# Attempting to sum a character vector gives an error (not numeric!).
sum(groups)  # Will produce an error because characters can’t be summed.

# Logical vectors *can* be summed, since TRUE = 1 and FALSE = 0.
sum(logical)  # Works fine.

# ------------------------------------------------------------
# 8. Logical comparisons on numeric vectors
# ------------------------------------------------------------

# Comparison operators return a logical vector.
r50 > 5     # TRUE for values greater than 5
r50 >= 5    # TRUE for values greater than or equal to 5
r50 == 5    # TRUE for values equal to 5

# You can use sum() to count how many values meet a condition.
sum(r50 > 10)  # N



#Selecting elements from a char vector. 

groups[2:5]
groups[groups=='HCM' | groups=='NF']

groups=='HCM'


#Using the 'or' and 'and' operator. 
groups[groups=='HCM' | groups=='DCM']
groups[groups=='HCM' & groups=='DCM']

#The 'in' operator 

groups[!groups %in% c('HCM','DCM')]
#### DANGER DO NOT EVER I MNEAN EVER DO THIS!!!!!!!!!!!!!!!!!!
groups[groups == c('HCM','DCM')]

#The not/negation operator 
groups[groups != 'NF']

#Let's use a comparisons to fix the nonfail label

groups[groups=='nonfail']

groups[groups=='nonfail'] <- 'NF'

sum(groups=='nonfail')



#What can't we do,Cannot mix data types, everyting will be cast to char.  
c(1,2,'DCM',F)


# ============================================================
# ️ FACTORS — Categorical Variables in R
# ============================================================

# Factors are used to represent categorical data — i.e., values that belong
# to a limited set of distinct groups, such as "HCM", "DCM", "NF", etc.
# Internally, factors are stored as integers with associated "levels" (labels).

# Convert the character vector 'groups' into a factor
groups.factor <- factor(groups)

# Print the factor
groups.factor
# Notice how R displays the distinct categories as "Levels:"
# This is R’s way of showing the possible categories in that variable.

# ------------------------------------------------------------
# 1. Comparing character vs factor numeric conversion
# ------------------------------------------------------------

# Converting a character vector directly to numeric produces NA values,
# because R can’t turn "DCM" or "HCM" into numbers.
as.numeric(groups)

# But converting a *factor* to numeric produces the *underlying integer codes*,
# corresponding to the factor levels (alphabetically by default).
as.numeric(groups.factor)
# For example, if levels(groups.factor) are c("DCM", "HCM", "NF", "nonfail"),
# then "DCM" = 1, "HCM" = 2, "NF" = 3, "nonfail" = 4.

# ------------------------------------------------------------
# 2. Plotting a numeric variable by a factor
# ------------------------------------------------------------

# When you plot a numeric vector against a factor,
# R automatically creates a boxplot for each group.
plot(groups.factor, r50,
     main = "r50 by Group",
     xlab = "Group (Factor Levels)",
     ylab = "r50 Values",
     col = "lightblue")

# This is a simple way to visualize numeric data by group without needing ggplot2.

# ------------------------------------------------------------
# 3. Reordering factor levels
# ------------------------------------------------------------

# By default, R orders factor levels alphabetically (A–Z).
# However, in analysis or visualization, you often want a custom order.
# Use the 'levels' argument to specify the order manually.

groups.factor <- factor(groups, levels = c('NF', 'HCM', 'DCM'))
groups.factor
levels(groups.factor)  # Confirm the new order

# Replot to see the new ordering on the x-axis.
plot(groups.factor, r50,
     main = "r50 by Group (Custom Order)",
     xlab = "Group (Ordered Levels)",
     ylab = "r50 Values",
     col = c("lightgreen", "lightblue", "salmon"))

# ------------------------------------------------------------
# 4. Inspecting and manipulating factor levels
# ------------------------------------------------------------

# View the levels directly
levels(groups.factor)

# Count occurrences of each category
table(groups.factor)

# Drop unused levels (e.g., after subsetting)
groups.sub <- groups.factor[groups.factor != "DCM"]
droplevels(groups.sub)

# Convert a factor back to character (undo the factor encoding)
as.character(groups.factor)



# ============================================================
#  NAs vs NaN vs NULL — Understanding Missing Values
# ============================================================

# R has several ways to represent missing or undefined data.
# Understanding their differences is critical for data cleaning.

# NA   : Represents missing data ("Not Available")
# NaN  : Represents invalid numeric operations (e.g., 0/0)
# NULL : Represents an empty object (no content at all)

# Let's explore each one step-by-step.

# ------------------------------------------------------------
# 1. Create a vector with NA (missing) values
# ------------------------------------------------------------

r50.na <- r50
r50.na[c(3, 8, 10, 12)] <- NA   # Replace specific positions with NA
r50.na

# Use summary() to inspect — NAs will appear in the output
summary(r50.na)

# ------------------------------------------------------------
# 2. Arithmetic operations with NA
# ------------------------------------------------------------

# When you perform arithmetic with NAs, the result is NA.
mean(r50.na)  # Returns NA because missing values block the calculation.

# To ignore missing values, use 'na.rm = TRUE'
mean(r50.na, na.rm = TRUE)   # Correct mean ignoring NAs

# You can also remove NAs entirely using na.omit()
r50.nona <- na.omit(r50.na)
r50.nona

# Confirm the mean matches the above result
mean(r50.nona)


# ------------------------------------------------------------
# 3. Checking for missing values
# ------------------------------------------------------------

# Use is.na() to identify which elements are NA (returns TRUE/FALSE)
is.na(r50.na)

# Count how many missing values
sum(is.na(r50.na))

# Which indices are missing?
which(is.na(r50.na))



# ------------------------------------------------------------
# 4. Difference between NA, NaN, and NULL
# ------------------------------------------------------------

# Example of NaN — invalid numeric result
0 / 0        # NaN
Inf - Inf    # NaN

# Example of NA — missing or undefined
NA + 5       # Still NA

# Example of NULL — empty object (not even a missing value)
x <- NULL
x             # NULL
length(x)     # 0 (no elements at all)

# Notice: functions treat these differently
mean(c(1, 2, NA))   # NA unless na.rm=TRUE
mean(c(1, 2, NaN))  # NaN unless na.rm=TRUE
mean(c(1, 2, NULL)) # 1.5 — NULL values are just ignored!

# ------------------------------------------------------------
# 5. Replacing missing values
# ------------------------------------------------------------

# Replace NA values with a specific value (e.g., mean)
r50.filled <- ifelse(is.na(r50.na), mean(r50.na, na.rm = TRUE), r50.na)
r50.filled

# ------------------------------------------------------------
# 6. Detecting all three types in a dataset
# ------------------------------------------------------------

test_vector <- c(1, NA, 3, NaN, NULL, 5)
test_vector   # Note: NULL disappears when stored in a vector
is.na(test_vector)  # TRUE for both NA and NaN
is.nan(test_vector) # TRUE only for NaN




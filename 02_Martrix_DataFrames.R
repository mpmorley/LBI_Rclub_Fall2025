#############################################################
#   R Club Tutorial: Matrix & Data Frame Basics + Reading Data
#   Author: MPM
#   Date: 2025-12-10
#############################################################

#############################################################
#   Matrix Basics
#############################################################

# Create a simple matrix
m1 <- matrix(1:10, nrow = 5)
m1

# Matrix indexing uses [row, column]
m1[1, ]      # first row
m1[, 1]      # first column
m1[5, 2]     # single element: row 5, col 2

# Add row and column names
colnames(m1) <- c("GeneA", "GeneB")
rownames(m1) <- paste("sample", 1:5, sep = "")
m1

# Access values by name
m1["sample1", ]
m1[, "GeneA"]

# Vectorized arithmetic applies element-wise
m1 + 10
m1 * 2

m2 <- m1 * 2
m1 * m2      # element-wise multiplication

# Matrix dimensions
dim(m1)

# Summaries by row/column
rowSums(m1)
colSums(m1)

# Comparisons return logical matrices
m1 > 5

# Count TRUE values
sum(m1 > 5)

# Percent of samples greater than 4 for each column
colSums(m1 > 4) / dim(m1)[1] * 100

# Summary statistics for each column
summary(m1)


#############################################################
#   Data Frames
#############################################################

# Data frames allow different types per column
id       <- paste("PENNID", 1:50, sep = "")
sex      <- sample(c("F", "M"), 50, replace = TRUE)
smoker   <- sample(c(TRUE, FALSE), 50, replace = TRUE)
etiology <- c(rep("BOS", 10), rep("COPD", 15), rep("NF", 25))
SFTPC    <- runif(50, min = 2, max = 10)
PDGFRA   <- runif(50, min = 5, max = 20)

df <- data.frame(
  sex      = sex,
  smoker   = smoker,
  etiology = etiology,
  SFTPC    = SFTPC,
  PDGFRA   = PDGFRA,
  row.names = id
)

df
summary(df)

# Convert character columns to factors (very common in analysis)
df$sex      <- factor(df$sex)
df$etiology <- factor(df$etiology)

summary(df)

# Tabulating categorical variables
table(df$etiology)
table(df$etiology, df$smoker)
table(df$etiology, df$smoker, df$sex)   # 3-way table

# Numeric variable tabulation (bins values)
table(df$etiology, df$SFTPC)

#############################################################
#   Accessing Data Frame Rows & Columns
#############################################################

# By position
df[, 1]
df[, 2:3]

# By name
df$SFTPC
df[, "SFTPC"]

# Multiple columns by name
df[, c("SFTPC", "PDGFRA")]

# Row access by row names
df[c("PENNID39", "PENNID39"), ]
df[c("PENNID39", "PENNID39"), "SFTPC"]

# Mistakes that beginners often make
df[c("SFTPC", "PDGFRA")]      # Interpreted as column names
df[c("SFTPC", "PDGFRA"), ]    # Now interpreted as *row* names → weird output

#############################################################
#   Subsetting with Logical Conditions
#############################################################

# Comparisons return logical vectors
df$smoker == FALSE

# Filter rows by logical condition
df[df$smoker == FALSE, ]

# Multiple conditions (AND)
df[df$etiology == "COPD" & df$sex == "F", ]

# Match multiple values using %in%
df[df$etiology %in% c("COPD", "BOS") & df$sex == "F", ]


#############################################################
#   Checking Data Structures
#############################################################

is.data.frame(df)
is.data.frame(df$SFTPC)
is.vector(df$SFTPC)


#############################################################
#   Reading Data (Base R vs Tidyverse)
#############################################################

# Base R
d.base <- read.csv("testDataUnTidy.csv")
d.base
summary(d.base)

# Tidyverse
library(tidyverse)
library(lubridate)

d.tidy <- read_csv("testDataUnTidy.csv")
d.tidy

# Fix date column with lubridate
d.tidy$DOB <- parse_date_time(
  d.tidy$DOB,
  orders = c("mdy", "dmy")
)


#############################################################
#   Writing Data
#############################################################

# Base R
write.csv(df, file = "TestDf_base.csv")

# Tidyverse
write_csv(df, file = "TestDf_tidy.csv")


#############################################################
#   Tidyverse Preview (select & filter)
#############################################################

# Base R column selection
df[, c("SFTPC", "PDGFRA")]

# dplyr equivalent
select(df, SFTPC, PDGFRA)

# Base R filtering
df[df$etiology == "COPD" & df$sex == "F", ]

# dplyr equivalent
filter(df, etiology == "COPD" & sex == "F")

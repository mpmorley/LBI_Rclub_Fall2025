# ============================================================================
# Gene Expression Data: Wide to Long Format Transformation
# ============================================================================
# This script demonstrates converting messy (wide) gene expression data 
# into tidy (long) format suitable for analysis.
#
# Experimental Design:
# - 3 genes: GAPDH, TP53, MYC
# - 2 treatments: WT (wildtype) vs Control
# - 2 sexes: Male (M) vs Female (F)
# - 3 replicates per condition
# - Total: 24 samples (3 genes × 2 treatments × 2 sexes × 3 replicates)
# ============================================================================

library(tidyverse)
library(tibble)

# ============================================================================
# PART 1: CREATE MESSY DATA (WIDE FORMAT)
# ============================================================================
# In real scenarios, you'd read this from a CSV, but we'll create it for
# demonstration purposes.

set.seed(42)

# Create the wide format data (genes as columns)
gene_data_wide <- tibble(
  sample_id = c(
    "WT_M_1", "WT_M_2", "WT_M_3",
    "WT_F_1", "WT_F_2", "WT_F_3",
    "Ctrl_M_1", "Ctrl_M_2", "Ctrl_M_3",
    "Ctrl_F_1", "Ctrl_F_2", "Ctrl_F_3"
  ),
  GAPDH = c(15243, 15891, 15156, 14023, 14567, 14891, 12156, 12489, 12734, 11234, 11678, 11901),
  TP53 = c(542, 598, 512, 623, 678, 634, 234, 267, 245, 289, 312, 298),
  MYC = c(3821, 3956, 3654, 4156, 4523, 4234, 5234, 5678, 5412, 6123, 6456, 6234)
)

cat("\n=== WIDE FORMAT DATA (MESSY) ===\n")
cat("This is the 'messy' format where each gene is a separate column.\n")
cat("Problem: Not tidy because each gene is a variable, not an observation.\n\n")
print(gene_data_wide)

# ============================================================================
# PART 2: CONVERT FROM WIDE TO LONG FORMAT
# ============================================================================
# Step 1: Pivot columns into rows
# This transforms genes from columns into values in a "gene" column
# and their counts into a "counts" column.

gene_data_long <- gene_data_wide %>%
  pivot_longer(
    cols = c(GAPDH, TP53, MYC),      # Columns to pivot
    names_to = "gene",                # New column for gene names
    values_to = "counts"              # New column for expression values
  )

cat("\n=== LONG FORMAT DATA (PARTIALLY TIDY) ===\n")
cat("After pivot_longer(): Genes are now rows instead of columns.\n")
cat("Each observation = one sample × one gene combination\n\n")
print(gene_data_long)

# ============================================================================
# PART 3: SEPARATE COMPOSITE IDs INTO INDIVIDUAL VARIABLES
# ============================================================================
# Step 2: Extract treatment, sex, and replicate from sample_id
# The sample_id has format: TREATMENT_SEX_REPLICATE (e.g., WT_M_1)

gene_data_tidy <- gene_data_long %>%
  separate(
    col = sample_id,
    into = c("treatment", "sex", "replicate"),
    sep = "_",
    remove = FALSE  # Keep original sample_id for reference
  ) %>%
  mutate(
    replicate = as.integer(replicate),
    treatment = factor(treatment, levels = c("Ctrl", "WT")),
    sex = factor(sex, levels = c("F", "M")),
    gene = factor(gene, levels = c("GAPDH", "TP53", "MYC"))
  )

cat("\n=== FULLY TIDY DATA (LONG FORMAT) ===\n")
cat("After separate(): Now we have individual columns for treatment, sex, and replicate.\n")
cat("This is tidy! One observation per row.\n\n")
print(gene_data_tidy)

# ============================================================================
# PART 4: VERIFY TIDY STRUCTURE
# ============================================================================

cat("\n=== VERIFYING TIDY STRUCTURE ===\n")
cat("Dimensions: ", nrow(gene_data_tidy), " rows × ", ncol(gene_data_tidy), " columns\n\n")

cat("Column names:\n")
print(colnames(gene_data_tidy))

cat("\nColumn classes:\n")
print(sapply(gene_data_tidy, class))

cat("\nUnique values:\n")
cat("- Genes: ", paste(unique(gene_data_tidy$gene), collapse = ", "), "\n")
cat("- Treatments: ", paste(unique(gene_data_tidy$treatment), collapse = ", "), "\n")
cat("- Sexes: ", paste(unique(gene_data_tidy$sex), collapse = ", "), "\n")
cat("- Replicates: ", paste(unique(gene_data_tidy$replicate), collapse = ", "), "\n")
cat("- Expected rows: 3 genes × 2 treatments × 2 sexes × 3 replicates = 36 rows\n")
cat("- Actual rows: ", nrow(gene_data_tidy), "\n")

# ============================================================================
# PART 5: DEMONSTRATE DOWNSTREAM ANALYSIS BENEFITS
# ============================================================================

cat("\n=== EXAMPLE ANALYSES (ONLY POSSIBLE WITH TIDY DATA) ===\n")

# Analysis 1: Summary statistics by gene and treatment
cat("\n1. Mean expression by gene and treatment:\n")
summary_stats <- gene_data_tidy %>%
  group_by(gene, treatment) %>%
  summarise(
    mean_counts = mean(counts),
    sd_counts = sd(counts),
    n = n(),
    .groups = "drop"
  )
print(summary_stats)

# Analysis 2: Treatment effect controlling for sex
cat("\n2. Linear model: Expression ~ Treatment + Sex + Gene\n")
model <- lm(counts ~ treatment + sex + gene, data = gene_data_tidy)
cat("Model summary:\n")
print(summary(model))

# Analysis 3: Interaction between treatment and sex
cat("\n3. Model with interaction: Expression ~ Treatment × Sex\n")
model_interaction <- lm(counts ~ treatment * sex, data = gene_data_tidy %>% filter(gene == "MYC"))
cat("For MYC gene only:\n")
print(summary(model_interaction))

# ============================================================================
# PART 6: CREATING PUBLICATION-READY PLOTS (ONLY POSSIBLE WITH TIDY DATA)
# ============================================================================

cat("\n=== GENERATING PLOTS (requires tidy data) ===\n")

# Plot 1: Box plot of expression by treatment, faceted by gene
plot1 <- ggplot(gene_data_tidy, aes(x = treatment, y = counts, fill = sex)) +
  geom_boxplot(alpha = 0.7) +
  facet_wrap(~gene, scales = "free_y") +
  theme_minimal() +
  theme(
    panel.grid.major = element_blank(),
    panel.border = element_rect(colour = "grey50", fill = NA),
    plot.title = element_text(face = "bold", size = 14)
  ) +
  labs(
    title = "Gene Expression by Treatment and Sex",
    x = "Treatment",
    y = "Expression Level (counts)",
    fill = "Sex"
  )

ggsave("/mnt/user-data/outputs/gene_expression_boxplot.png", plot1, width = 10, height = 5)
cat("\nSaved: gene_expression_boxplot.png\n")

# Plot 2: Interaction plot
plot2 <- ggplot(gene_data_tidy, aes(x = treatment, y = counts, color = sex, group = sex)) +
  stat_summary(fun = mean, geom = "point", size = 3) +
  stat_summary(fun = mean, geom = "line") +
  facet_wrap(~gene, scales = "free_y") +
  theme_minimal() +
  theme(
    panel.grid.major = element_blank(),
    panel.border = element_rect(colour = "grey50", fill = NA),
    plot.title = element_text(face = "bold", size = 14)
  ) +
  labs(
    title = "Treatment × Sex Interaction Effects",
    x = "Treatment",
    y = "Mean Expression (counts)",
    color = "Sex"
  )

ggsave("/mnt/user-data/outputs/gene_expression_interaction.png", plot2, width = 10, height = 5)
cat("Saved: gene_expression_interaction.png\n")

# ============================================================================
# PART 7: REVERSE TRANSFORMATION (LONG BACK TO WIDE)
# ============================================================================

cat("\n=== CONVERTING BACK TO WIDE FORMAT (if needed) ===\n")
cat("Sometimes you might need to go back to wide format for specific purposes.\n\n")

gene_data_wide_recovered <- gene_data_tidy %>%
  select(sample_id, gene, counts) %>%
  pivot_wider(
    names_from = gene,
    values_from = counts
  )

cat("Recovered wide format:\n")
print(gene_data_wide_recovered)

# ============================================================================
# PART 8: BEST PRACTICES CHECKLIST
# ============================================================================

cat("\n=== TIDY DATA CHECKLIST ===\n")
cat("✓ Each variable is a column\n")
cat("✓ Each observation is a row\n")
cat("✓ Each value is in its own cell\n")
cat("✓ No redundant information\n")
cat("✓ Can easily group by any variable\n")
cat("✓ Ready for plotting with ggplot2\n")
cat("✓ Suitable for statistical modeling\n")
cat("✓ Easy to filter, arrange, and summarize\n")

cat("\n=== END OF SCRIPT ===\n")

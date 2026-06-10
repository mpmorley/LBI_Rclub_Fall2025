# ============================================================
# dplyr intro (with your MetaData.RDS)
# Topics: select(), filter(), mutate(), rename(), group_by() + summarize()
# Dataset: single-cell metadata tibble/data.frame called `meta`
# ============================================================


library(tidyverse)


# ------------------------------------------------------------
# 0) Read data + quick look
# ------------------------------------------------------------
meta <- readRDS("MetaData.RDS")

glimpse(meta)  # shows column types + a peek at values

# Your columns (from glimpse):
# library_id (chr), donor_id (fct), nCount_RNA (dbl), nFeature_RNA (dbl),
# hybrid_call (lgl), percent.mito (dbl), Phase (fct), sex (fct),
# age (dbl), age_unit (chr), developmental_stage (fct),
# library_platform (chr), lineage (fct), celltype (fct)

# ------------------------------------------------------------
# 1) select(): keep only the columns you want (or reorder them)
# ------------------------------------------------------------

# Example A: keep a small set of columns for a "QC table"
meta_qc <- meta |>
  select(
    library_id, donor_id,
    nCount_RNA, nFeature_RNA, percent.mito,
    Phase, sex, developmental_stage,
    lineage, celltype
  )

glimpse(meta_qc)

# Example B: select() helpers (starts_with / ends_with / contains)
# Keep all columns related to "age" plus a few IDs
meta_age <- meta |>
  select(library_id, donor_id, starts_with("age"), developmental_stage)

glimpse(meta_age)

# Example C: drop columns by negative selection
meta_no_platform <- meta |>
  select(-library_platform)

# ------------------------------------------------------------
# 2) filter(): keep only rows meeting conditions
# ------------------------------------------------------------

# Example A: basic QC-style filtering
# - remove "hybrid_call == TRUE"
# - keep cells with percent.mito <= 10
# - keep cells with at least 500 detected genes (nFeature_RNA)
meta_filt <- meta |>
  filter(
    !hybrid_call,
    percent.mito <= 10,
    nFeature_RNA >= 500
  )

nrow(meta)      # original rows
nrow(meta_filt) # filtered rows

# Example B: filter by a category (use %in% for multiple values)
meta_epi <- meta |>
  filter(lineage %in% c("epithelium"))

# Example C: filter by multiple categories
meta_at2_g1 <- meta |>
  filter(celltype == "AT2", Phase == "G1")

# Tip: is.na() is common in real data (if you have missing values)
# meta |> filter(!is.na(percent.mito))

# ------------------------------------------------------------
# 3) mutate(): create (or transform) columns
# ------------------------------------------------------------

# Example A: simple derived columns
# - nCount_RNA log10 for easier plotting
# - a QC flag based on percent.mito
# - coerce donor_id to character if you want to treat it as an ID string
meta_mut <- meta |>
  mutate(
    log10_nCount_RNA = log10(nCount_RNA + 1),
    mito_high = percent.mito > 10,
    donor_id_chr = as.character(donor_id)
  )

glimpse(meta_mut)

# Example B: mutate with case_when() for a categorical label
# Here we create a simple mito category
meta_mito_cat <- meta |>
  mutate(
    mito_bin = case_when(
      percent.mito < 5  ~ "<5%",
      percent.mito < 10 ~ "5–10%",
      TRUE              ~ ">=10%"
    )
  )

# Example C: mutate across multiple numeric columns
# (Handy when you have many QC metrics to transform)
meta_scaled <- meta |>
  mutate(
    across(
      .cols = c(nCount_RNA, nFeature_RNA, percent.mito, age),
      .fns  = ~ as.numeric(.x)  # example transformation; replace with what you need
    )
  )

# ------------------------------------------------------------
# 4) rename(): change column names (without changing the data)
# ------------------------------------------------------------

# rename(new_name = old_name)
meta_renamed <- meta |>
  rename(
    n_umi = nCount_RNA,
    n_gene = nFeature_RNA,
    mito_pct = percent.mito
  )

glimpse(meta_renamed)

# Tip: rename_with() is useful for systematic renaming
# Example: replace "." with "_" in all column names
meta_clean_names <- meta |>
  rename_with(~ gsub("\\.", "_", .x))

names(meta_clean_names)

# ------------------------------------------------------------
# 5) group_by(): split into groups for summaries
#    Usually paired with summarize() (and often arrange())
# ------------------------------------------------------------

# Example A: cell counts by lineage + celltype
counts_by_ct <- meta |>
  group_by(lineage, celltype) |>
  summarize(
    n_cells = n(),
    .groups = "drop"
  ) |>
  arrange(desc(n_cells))

counts_by_ct

# Example B: QC summaries by celltype
qc_by_celltype <- meta |>
  group_by(celltype) |>
  summarize(
    n_cells = n(),
    median_nCount = median(nCount_RNA, na.rm = TRUE),
    median_nFeature = median(nFeature_RNA, na.rm = TRUE),
    median_mito = median(percent.mito, na.rm = TRUE),
    frac_hybrid = mean(hybrid_call, na.rm = TRUE),  # TRUE treated as 1, FALSE as 0
    .groups = "drop"
  ) |>
  arrange(desc(n_cells))

qc_by_celltype

# Example C: multi-level grouping (stage x sex x lineage)
stage_sex_lineage <- meta |>
  group_by(developmental_stage, sex, lineage) |>
  summarize(
    n_cells = n(),
    mean_mito = mean(percent.mito, na.rm = TRUE),
    .groups = "drop"
  ) |>
  arrange(developmental_stage, sex, desc(n_cells))

stage_sex_lineage

# ------------------------------------------------------------
# 6) A small "pipeline example" combining everything
# ------------------------------------------------------------

# Goal: make a clean QC table for plotting/reporting
# - keep key columns
# - rename a few
# - add a mito category
# - filter out hybrid calls
# - produce a summary by celltype

qc_summary <- meta |>
  select(
    library_id, donor_id, celltype, lineage, developmental_stage,
    nCount_RNA, nFeature_RNA, percent.mito, hybrid_call
  ) |>
  rename(
    n_umi = nCount_RNA,
    n_gene = nFeature_RNA,
    mito_pct = percent.mito
  ) |>
  mutate(
    mito_bin = case_when(
      mito_pct < 5  ~ "<5%",
      mito_pct < 10 ~ "5–10%",
      TRUE          ~ ">=10%"
    )
  ) |>
  filter(!hybrid_call) |>
  group_by(celltype) |>
  summarize(
    n_cells = n(),
    median_umi = median(n_umi, na.rm = TRUE),
    median_gene = median(n_gene, na.rm = TRUE),
    median_mito = median(mito_pct, na.rm = TRUE),
    pct_mito_ge_10 = mean(mito_bin == ">=10%", na.rm = TRUE) * 100,
    .groups = "drop"
  ) |>
  arrange(desc(n_cells))

qc_summary

# ------------------------------------------------------------
# End of script
# ------------------------------------------------------------

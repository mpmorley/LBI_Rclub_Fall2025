###############################################################################
# Patchwork Intro (Seurat metadata example)
# Dataset: meta (data frame / tibble)
# Purpose:
#   - Make a few ggplot2 plots from Seurat metadata
#   - Combine them into layouts using patchwork
###############################################################################

# ------------------------------------------------------------
# Libraries
# ------------------------------------------------------------
library(tidyverse)
library(patchwork)

meta <- readRDS('MetaData.RDS')


# ------------------------------------------------------------
# 1) Make a few individual plots
# ------------------------------------------------------------

# A. QC scatter: nCount_RNA vs percent.mito
p_qc1 <- ggplot(meta, aes(x = nCount_RNA, y = percent.mito)) +
  geom_point(alpha = 0.3, size = 1) +
  labs(
    title = "QC: percent.mito vs nCount_RNA",
    x = "nCount_RNA",
    y = "percent.mito"
  ) +
  theme_minimal()

# B. QC scatter: nCount_RNA vs nFeature_RNA
p_qc2 <- ggplot(meta, aes(x = nCount_RNA, y = nFeature_RNA)) +
  geom_point(alpha = 0.3, size = 1) +
  labs(
    title = "QC: nFeature_RNA vs nCount_RNA",
    x = "nCount_RNA",
    y = "nFeature_RNA"
  ) +
  theme_minimal()

# C. Percent mito by lineage (boxplot)
p_mito_lineage <- ggplot(meta, aes(x = lineage, y = percent.mito)) +
  geom_boxplot(outlier.alpha = 0.2) +
  coord_flip() +
  labs(
    title = "percent.mito by lineage",
    x = "lineage",
    y = "percent.mito"
  ) +
  theme_minimal()


#Rember we can view the plot by just providing the variable name 

p_mito_lineage


# D. Cell cycle phase composition by lineage (stacked bar)
##New plot the Bar plot! 2 ways to make bar plots in ggplot2, geom_bar and geom_col. 

#This will perform the counting of which variable we choose, lineage in this case. 

ggplot(meta, aes(x=lineage)) + 
  geom_bar()

#We can flip the plot as by just setting y to the variable. 

ggplot(meta, aes(y=lineage)) + geom_bar()

#We can use fill to make a stacked bar graph, we'll use cell cycle Phase. 

ggplot(meta, aes(x=lineage,fill=Phase)) + geom_bar()

#We can do celltype. 

ggplot(meta, aes(x=lineage,fill=celltype)) + geom_bar()

#We can make this plot by %.. We just need to use the position argument. 

ggplot(meta, aes(x=lineage,fill=Phase)) + geom_bar(position = "fill")


#We if we already had the counts or the values. We can use geom_col. 
# We'll sneak in some basic dplyr. This function gives us counts of lineage,Phase.  

meta |>
  count(lineage, Phase)


#We save this as a variable 
tmp.data <- meta |>
  count(lineage, Phase)

ggplot(tmp.data, aes(x=lineage,y=n,fill=Phase)) + geom_col()

#geom_col really is geom_bar(stat='identity") you may see this in search and/or AI

ggplot(tmp.data, aes(x=lineage,y=n,fill=Phase)) + geom_bar(stat="identity")

#To do % 
ggplot(tmp.data, aes(x=lineage,y=n,fill=Phase)) + geom_bar(stat="identity", position = 'fill')



#Let's make this plot pretty. 

p_phase_lineage <- ggplot(meta, aes(x=lineage,fill=Phase)) + 
  geom_bar(position = "fill") +
scale_y_continuous(labels = scales::percent_format()) +
  labs(
    title = "Cell cycle phase composition by lineage",
    x = "lineage",
    y = "fraction of cells",
    fill = "Phase"
  ) +
  theme_minimal()





# ------------------------------------------------------------
# 2) Combine plots with patchwork operators
#    +  = side-by-side
#    /  = stacked
#    () = grouping/precedence
# ------------------------------------------------------------

# Side-by-side
p_qc1 + p_qc2

# Stacked
p_mito_lineage / p_phase_lineage

# A simple multi-panel figure
(p_qc1 + p_qc2) / (p_mito_lineage + p_phase_lineage)

# ------------------------------------------------------------
# 3) Control layout with plot_layout()
# ------------------------------------------------------------

# Put 4 plots into a 2-column layout
(p_qc1 + p_qc2 + p_mito_lineage + p_phase_lineage) +
  plot_layout(ncol = 2)

# Adjust relative widths (e.g., give boxplot more room)
(p_qc1 + p_mito_lineage) +
  plot_layout(widths = c(2, 3))

#The widths param is a ratio, 
(p_qc1 + p_mito_lineage) +
  plot_layout(widths = c(1, 10))


#If we had more plots we just expand the widths vector. 

(p_qc1 + p_qc2 + p_mito_lineage) +
  plot_layout(widths = c(1,2,10))

#Works for heights as well. 
(p_qc1 / p_mito_lineage) +
  plot_layout(heights = c(2,3 ))

# ------------------------------------------------------------
# 4) Add a shared title/subtitle/caption with plot_annotation()
# ------------------------------------------------------------

combined <- (p_qc1 + p_qc2) / (p_mito_lineage + p_phase_lineage) +
  plot_annotation(
    title = "Seurat Metadata QC + Composition Overview",
    subtitle = "Example multi-panel figure using patchwork",
    caption = "Input: meta (Seurat object metadata)"
  )

combined

# ------------------------------------------------------------
# 5) Collect legends (avoid duplicates)
# ------------------------------------------------------------

# Add a plot where color generates a legend (e.g., sex or developmental stage)
p_qc1_sex <- ggplot(meta, aes(x = nCount_RNA, y = percent.mito, color = sex)) +
  geom_point(alpha = 0.3, size = 1) +
  labs(
    title = "QC colored by sex",
    x = "nCount_RNA",
    y = "percent.mito",
    color = "sex"
  ) +
  theme_minimal()

p_qc2_sex <- ggplot(meta, aes(x = nCount_RNA, y = nFeature_RNA, color = sex)) +
  geom_point(alpha = 0.3, size = 1) +
  labs(
    title = "Features vs counts colored by sex",
    x = "nCount_RNA",
    y = "nFeature_RNA",
    color = "sex"
  ) +
  theme_minimal()

# Collect legend into one shared legend
(p_qc1_sex + p_qc2_sex) +
  plot_layout(guides = "collect") &
  theme(legend.position = "bottom")


# ------------------------------------------------------------
# 6) Tagging
# ------------------------------------------------------------


p_qc1_sex + p_qc2_sex +
  plot_annotation(tag_levels = 'A')

p_qc1_sex + p_qc2_sex +
plot_annotation(tag_levels = c('A', '1'), tag_prefix = 'Fig. ',
                tag_sep = '.', tag_suffix = ':')



# ------------------------------------------------------------
# 7) Save a patchwork figure
# ------------------------------------------------------------

ggsave(
  filename = "meta_patchwork_overview.png",
  plot = combined,
  width = 12,
  height = 9,
  dpi = 300
)

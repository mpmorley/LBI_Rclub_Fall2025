# ggplot2 intro script ---------------------------------------------------
# Dataset: single-cell metadata (meta.rds)
library(tidyverse)


meta <- readRDS('MetaData.RDS')


# Quick sanity check: verify we have what we need
glimpse(meta)

#--------------------------------------------------
# A first ggplot ----------------------------------------------------------
# ggplot() takes:
#   - data frame
#   - aesthetics mapping (aes): which columns map to x/y/color/etc.
# Then you add layers (geoms) with +.

ggplot(meta, aes(x = donor_id, y = percent.mito)) +
  geom_point()

# When many points overlap, use transparency and smaller points
ggplot(meta, aes(x = donor_id, y = percent.mito)) +
  geom_point(alpha = 0.3, size = 0.6, na.rm = TRUE)

#--------------------------------------------------
# Jittering points --------------------------------------------------------
# When x is discrete, points stack on top of each other.
# geom_jitter spreads points randomly (within a width) so you can see density.

ggplot(meta, aes(x = donor_id, y = percent.mito)) +
  geom_jitter(width = 0.2, height = 0, alpha = 0.3, size = 0.8, na.rm = TRUE)

#--------------------------------------------------
# Violin plots ------------------------------------------------------------
# Violin = distribution shape. Great for comparing groups.
# You can layer geoms (e.g., violin + points).

ggplot(meta, aes(x = donor_id, y = percent.mito)) +
  geom_violin(na.rm = TRUE)

# Layer: violin + points (points will overplot heavily without alpha/jitter)
ggplot(meta, aes(x = donor_id, y = percent.mito)) +
  geom_violin(na.rm = TRUE) +
  geom_jitter(width = 0.15, height = 0, alpha = 0.25, size = 0.6, na.rm = TRUE)

#--------------------------------------------------
# Color vs fill, and *mapping* vs *setting* --------------------------------
# Two common gotchas:
#  1) color = outline color; fill = interior color (for geoms that have a fill)
#  2) Put aesthetics inside aes() to MAP to data; put outside aes() to SET a constant

# SET constants (same color for all violins)
ggplot(meta, aes(x = donor_id, y = percent.mito)) +
  geom_violin(fill = "red", color = "blue", na.rm = TRUE)

# Points typically use color (outline). 'fill' often does nothing for geom_point()
ggplot(meta, aes(x = donor_id, y = percent.mito)) +
  geom_point(color = "blue", size = 2, alpha = 0.4, na.rm = TRUE)

# MAP fill to a variable: must be inside aes()
ggplot(meta, aes(x = donor_id, y = percent.mito, fill = donor_id)) +
  geom_violin(na.rm = TRUE)

# Equivalent: mapping inside the geom (useful when layers map differently)
ggplot(meta, aes(x = donor_id, y = percent.mito)) +
  geom_violin(aes(fill = donor_id), na.rm = TRUE)

# If you add another geom, you may want a different mapping per layer
ggplot(meta, aes(x = donor_id, y = percent.mito)) +
  geom_violin(aes(fill = donor_id), na.rm = TRUE) +
  geom_jitter(aes(color = sex), width = 0.15, height = 0, alpha = 0.25, size = 0.6, na.rm = TRUE)

# Global mapping affects all layers (handy, but easy to overdo)
ggplot(meta, aes(x = donor_id, y = percent.mito, color = sex)) +
  geom_violin(na.rm = TRUE) +
  geom_jitter(width = 0.15, height = 0, alpha = 0.25, size = 0.6, na.rm = TRUE)

#--------------------------------------------------
# Ordering discrete axes --------------------------------------------------
# ggplot orders characters alphabetically. Factors keep the order you set.


ggplot(meta, aes(x = developmental_stage, y = nFeature_RNA)) +
  geom_violin(na.rm = TRUE)

# Only do this if those levels exist in your data (otherwise you’ll get NAs)
stage_levels <- c("Day0", "Neonate", "Infant", "Toddler")

meta$developmental_stage <- factor(meta$developmental_stage, levels = stage_levels)

meta <- meta |>
  mutate(developmental_stage = factor(developmental_stage, levels = stage_levels) |> fct_drop())

ggplot(meta, aes(x = developmental_stage, y = nFeature_RNA)) +
  geom_violin(na.rm = TRUE)

#--------------------------------------------------
# Boxplots ----------------------------------------------------------------
# Boxplot summarizes a distribution:
#   - box = Q1 to Q3
#   - line = median
#   - whiskers typically extend to 1.5 * IQR
# Adding points helps show the underlying data.

# Boxplot only
ggplot(meta, aes(x = developmental_stage, y = percent.mito)) +
  geom_boxplot(na.rm = TRUE)

# Boxplot + jittered points
# outlier.shape = NA prevents duplicate “outlier points” since we plot points ourselves
ggplot(meta, aes(x = donor_id, y = percent.mito)) +
  geom_boxplot(outlier.shape = NA, na.rm = TRUE) +
  geom_jitter(width = 0.2, height = 0, alpha = 0.3, size = 0.8, na.rm = TRUE)

# Color by group (sex)
ggplot(meta, aes(x = donor_id, y = percent.mito, color = sex)) +
  geom_boxplot(outlier.shape = NA, na.rm = TRUE) +
  geom_jitter(width = 0.2, height = 0, alpha = 0.25, size = 0.7, na.rm = TRUE)



#So far the variable we color by is 100% the same as the x axis. What if we colored by another, say doublet call. 


ggplot(meta, aes(x = donor_id, y = percent.mito, color = hybrid_call)) +
  geom_boxplot(outlier.shape = NA, na.rm = TRUE)

#Let's add the points back..   

ggplot(meta, aes(x = donor_id, y = percent.mito, color = hybrid_call)) +
  geom_boxplot(outlier.shape = NA, na.rm = TRUE) +
  geom_jitter(width = 0.2, height = 0, alpha = 0.25, size = 0.7, na.rm = TRUE) 

#Well that's ugly. 
#We need to dodge the the points now. 
ggplot(meta, aes(x = donor_id, y = percent.mito, color = hybrid_call, fill = hybrid_call)) +
  geom_boxplot(
    outlier.shape = NA,
    na.rm = TRUE
  ) +
  geom_point(
    position = position_jitterdodge(jitter.width = 0.2, dodge.width = 0.75),
    alpha = 0.3, size = 0.8, na.rm = TRUE
  )





#We can do the same for a violin plot as well. 
ggplot(meta, aes(x = donor_id, y = percent.mito, color = hybrid_call, fill = hybrid_call)) +
  geom_violin(
    na.rm = TRUE
  ) +
  geom_point(
    position = position_jitterdodge(jitter.width = 0.2, dodge.width = 0.75),
    alpha = 0.3, size = 0.8, na.rm = TRUE
  )

#Order of layers matter.. Let's change the color of the points to black. 

ggplot(meta, aes(x = donor_id, y = percent.mito, color = hybrid_call, fill = hybrid_call)) +
  geom_violin(
    na.rm = TRUE
  ) +
  geom_point(
    position = position_jitterdodge(jitter.width = 0.2, dodge.width = 0.75),
    color = 'black',
    alpha = 0.3, size = 0.8, na.rm = TRUE
  )

#Now the violin is on top. 
ggplot(meta, aes(x = donor_id, y = percent.mito, color = hybrid_call, fill = hybrid_call)) +
  geom_point(
    position = position_jitterdodge(jitter.width = 0.2, dodge.width = 0.75),
    color = 'black',
    alpha = 0.3, size = 0.8, na.rm = TRUE
  ) +
  geom_violin(
    na.rm = TRUE
  ) 

#Now we can change the alpha to see the points. 
ggplot(meta, aes(x = donor_id, y = percent.mito, color = hybrid_call, fill = hybrid_call)) +
  geom_point(
    position = position_jitterdodge(jitter.width = 0.2, dodge.width = 0.75),
    color = 'black',
    alpha = 0.3, size = 0.8, na.rm = TRUE
  ) +
  geom_violin(
    na.rm = TRUE,
    alpha = 0.3
  ) 

#Very last bit, notice that the points and the violin plot do not align? We can now dodge the violin plot to match the points. 


ggplot(meta, aes(x = donor_id, y = percent.mito, color = hybrid_call, fill = hybrid_call)) +
  geom_point(
    position = position_jitterdodge(jitter.width = 0.2, dodge.width = 0.75),
    color = 'black',
    alpha = 0.3, size = 0.8, na.rm = TRUE
  ) +
  geom_violin(
    position = position_dodge(width = 0.75),
    na.rm = TRUE,
    alpha = 0.3
  ) 


#We can now store are plot as a variable, this is a ggplot2 objext. 

plot <- ggplot(meta, aes(x = donor_id, y = percent.mito, color = hybrid_call, fill = hybrid_call)) +
  geom_point(
    position = position_jitterdodge(jitter.width = 0.2, dodge.width = 0.75),
    color = 'black',
    alpha = 0.3, size = 0.8, na.rm = TRUE
  ) +
  geom_violin(
    position = position_dodge(width = 0.75),
    na.rm = TRUE,
    alpha = 0.3
  ) 

str(plot)

#just calling the variable will make the plot display. We can add layers, etc to this object.
plot


#Let's change the text now of the X and Y since the names we use in data frame don't make good labels, we'll also add a title. 

plot+xlab('Donor Name') +
  ylab('% Mitochondrial Reads') +
  ggtitle("A Plot")

# We can save this again to an object. 

plot <- plot+xlab('Donor Name') +
  ylab('% Mitochondrial Reads') +
  ggtitle("A Plot")


#--------------------------------------------------
# Themes and labels -------------------------------------------------------
# Themes control non-data ink: fonts, grids, legend position, etc.
# Make a reusable theme object for the lesson.

#Let's make this a little nicer.. ggplot has some built in themes.. 

plot + theme_bw()

plot + theme_classic()

plot + theme_dark()

plot + theme_void()




#We can create our own theme. as well.. We can start with them_bw(). ggplot2 doc has all this params listed. Also there are R packages with addtional


theme_lesson <- theme_bw() +
  theme(
    legend.position  = "bottom",
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border     = element_blank(),
    axis.line        = element_line(colour = "black"),
    axis.text.x      = element_text(angle = 45, hjust = 1)
  )

plot + theme_lesson

#There plenty of R packages with additional themes as well. One I like to use is from the cowplot package. 

library(cowplot)
plot + theme_cowplot()

#Or instead of loading the entire cowplot library I can call just one fuction using the :: notation. 

plot + cowplot::theme_cowplot()

#Cowplot has an even more basic verion of void as well. 
plot + cowplot::theme_nothing()

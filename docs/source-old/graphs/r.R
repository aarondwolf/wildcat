library(ggplot2)
library(haven)
# Load data
df <- read_dta("source/graphs/auto.dta")
# Define custom RGB colors
wcprimary <- rgb(78/255, 42/255, 132/255)

# Plot mpg against weight, with marker color wcprimary
plot <- ggplot(df, aes(x = weight, y = mpg)) +
  geom_point(color = wcprimary) +
  labs(x = "Weight", y = "MPG")

# Save the plot to a file with a specific size
ggsave("source/graphs/plot-R.pdf", plot, width = 8, height = 5)
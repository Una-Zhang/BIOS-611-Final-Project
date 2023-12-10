# Execution time tracking
start_time <- Sys.time()
library(tidyverse)
library(ggplot2)
## Data Visualization
output_directory <- "output/"

cat("Data Visualization ... \n")
dat <- read_csv("stipends_cleaned.csv")
category_counts <- table(dat$dept)
top_dept <- names(category_counts[category_counts > 100])
print("We only focus on departments with at least 100 self-reported stipends.")
p1 <- dat %>%
  filter(dept %in% top_dept) %>%
  group_by(dept) %>%
  summarise(mean_Overall_Pay = mean(`Overall Pay`)) %>%
  mutate(dept = fct_reorder(dept , mean_Overall_Pay)) %>%
  ggplot() +
  aes(x = dept, y = mean_Overall_Pay, fill = location) +
  coord_flip() +
  geom_bar(stat = "identity", fill = "#56B4E9")+
  labs(title = "Overall Pay by Department", 
       y = "Average Overall Pay ($)", x = "Department") +
  theme_classic()
ggsave(paste0(output_directory, "Overall_Pay_by_Department.png"), 
       p1, width = 5, height = 6)

dat <- dat %>%
  mutate(time_mid = as.numeric(substr(`Academic Year`, 1, 4)) + 0.5)

p2 <- dat %>%
  drop_na(`Overall Pay`) %>%
  group_by(time_mid) %>%
  summarise(mean_Overall_Pay = mean(`Overall Pay`)) %>%
  ggplot(aes(x = time_mid, y = mean_Overall_Pay)) +
  geom_line(size = 1, color = "#56B4E9") +
  labs(title = "Average Overall Pay by Year", y = "Average Overall Pay ($)", x = "Year") +
  scale_y_continuous(breaks = seq(23000, 30000, by = 1000)) +
  scale_x_continuous(breaks = seq(2014, 2023, by = 1)) +
  theme_classic()
ggsave(paste0(output_directory,"Overall_Pay_across_Years.png"),
       p2, width = 8, height = 5)

school_counts <- table(dat$University)
top_school <- names(school_counts[school_counts > 10])
p3 <- dat %>%
  filter(University %in% top_school) %>%
  group_by(University) %>%
  summarise(mean_Overall_Pay = mean(`Overall Pay`)) %>%
  slice_max(mean_Overall_Pay, n = 10) %>%
  mutate(School = fct_reorder(University , mean_Overall_Pay)) %>%
  ggplot() +
  aes(x = School, y = mean_Overall_Pay, fill = location) +
  coord_flip() +
  geom_bar(stat = "identity", fill = "gold")+
  labs(title = "Top 10 Universities by Average PhD Stipend", 
       y = "Average Overall Pay ($)", x = "University") +
  theme_classic()
ggsave(paste0(output_directory, "top_10_stipend_University.png"), 
       p3, width = 10, height = 6)

p4 <- dat %>%
  filter(University %in% top_school) %>%
  group_by(University) %>%
  summarise(mean_Overall_Pay = mean(`Overall Pay`, na.rm = TRUE)) %>%
  slice_min(mean_Overall_Pay, n = 10) %>%  # Selects the bottom 10 universities
  ungroup() %>%  # Remove the grouping to avoid affecting the mutate operation
  mutate(School = fct_reorder(University, -mean_Overall_Pay)) %>%
  ggplot(aes(x = School, y = mean_Overall_Pay)) +
  geom_bar(stat = "identity", position = "dodge", fill = "gold") +
  coord_flip() +
  labs(title = "Top 10 Universities with the Lowest Average PhD Stipends", 
       x = "University", y = "Average Overall Pay ($)") +
  theme_classic()
ggsave(paste0(output_directory, "bottom_10_stipend_University.png"), 
       p4, width = 10, height = 6)

colnames(dat)
cat("Done. \n")

end_time <- Sys.time()
cat("#------------------------#")
cat("\n")
cat("Execution time")
cat("\n")
cat(end_time - start_time)
cat("\n")
cat("#------------------------#")
cat("\n")
cat(" Session Info")
print(sessionInfo())
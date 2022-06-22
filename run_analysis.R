library(tidyverse)
library(reshape2)

path <- "Y:\\R\\Coursera\\Cleaning Data\\UCI HAR Dataset"

# Train Data

x_train <- read.table(
  paste0(path,"\\","train","\\","X_train.txt")
  )
  
y_train <- read.table(
  paste0(path,"\\","train","\\","Y_train.txt")
)

s_train <- read.table(
  paste0(path,"\\","train","\\","subject_train.txt")
)
  
# Test Data

x_test <- read.table(
  paste0(path,"\\","test","\\","X_test.txt")
)

y_test <- read.table(
  paste0(path,"\\","test","\\","Y_test.txt")
)

s_test <- read.table(
  paste0(path,"\\","test","\\","subject_test.txt")
)

# Merge Data

x_data <- rbind(x_train, x_test)

y_data <- rbind(y_train, y_test)

s_data <- rbind(s_train, s_test)

# Label Data

labels <- read.table(
  paste0(path, "\\","activity_labels.txt")
) %>% 
  mutate(
    V2 = as.character(V2)
  )

# Feature Data

feature <- read.table(
  paste0(path, "\\","features.txt")
) %>%
  mutate(
    V2 = as.character(V2)
  )

# Filter Feature Data

feature_adj <- feature %>%
  filter(
    .,
    grepl('mean|std', V2)
  ) %>%
  mutate(
    V2 = ifelse(
      grepl('mean',V2) == TRUE,
      "Mean",
      "Std"
    )
  )

# Filter, Combine Data, and add descriptions

x_data_adj <- x_data[feature_adj$V1]

combined_data <- cbind(s_data, y_data, x_data_adj)

colnames(combined_data) <- c("Subject", "Activity", feature_adj$V2)

# Add fields 

all_data <- combined_data %>%
  melt(
    id = c("Subject", "Activity")
  ) %>%
  mutate(
    Activity = factor(Activity, levels = labels$V1, labels = labels$V2),
    Subject = factor(Subject)
  )

write.table(all_data, paste0(path, "//","tidy_data.txt"))



library(tidyverse)

# load data
df_trainX <- read_table("UCI\ HAR\ Dataset/train/X_train.txt", col_names = FALSE)
df_trainY <- read_table("UCI\ HAR\ Dataset/train/Y_train.txt", col_names = FALSE)
subject_train <- read_table("UCI\ HAR\ Dataset/train/subject_train.txt", col_names = FALSE)



df_testX <- read_table("UCI\ HAR\ Dataset/test/X_test.txt", col_names = FALSE)
df_testY <- read_table("UCI\ HAR\ Dataset/test/Y_test.txt", col_names = FALSE)
subject_test <- read_table("UCI\ HAR\ Dataset/test/subject_test.txt", col_names = FALSE)


# combine train and test sets
df_Xfull <- bind_rows(df_trainX, df_testX)
df_Yfull <- bind_rows(df_trainY, df_testY)
subject_full <- bind_rows(subject_train, subject_test)

# clean
rm(df_testX); rm(df_trainX); rm(df_testY); rm(df_trainY); rm(subject_train); rm(subject_test)

# load column names (for X)
features <- read_table("UCI\ HAR\ Dataset/features.txt", col_names = FALSE)
column_names <- unlist(features$X2)

# add column name subject
names(subject_full) <- "subject"

# add column names to X data
names(df_Xfull) <- column_names


# find cols with mean or std with logical vector
has_mean_std <- str_detect(column_names, "mean\\(\\)") | str_detect(column_names, "std\\(\\)")
# filter df_Xfull for columns with mean or std
df_X <- df_Xfull[, has_mean_std]

# clean X column names
## remove parentheses
names(df_X) <- str_remove_all(names(df_X), "\\(\\)")
## capitalize mean and std
names(df_X) <- str_replace_all(names(df_X), "mean", "Mean")
names(df_X) <- str_replace_all(names(df_X), "std", "Std")
## remove underscores
names(df_X) <- str_remove_all(names(df_X), "-")
## replace t and f at beginning with time and frequency
names(df_X) <- str_replace(names(df_X), "^t", "time")
names(df_X) <- str_replace(names(df_X), "^f", "frequency")
## replace Acc with Acceleration
names(df_X) <- str_replace(names(df_X), "Acc", "Acceleration")



# read activity labels and make dictionary
activity_labels <- read_table("UCI\ HAR\ Dataset/activity_labels.txt", col_names = FALSE)
activity_dict <- unlist(activity_labels$X2) # position matches number code so names not necessary
rm(activity_labels)

# replace numbers with description and name activity column
df_Y <- df_Yfull %>% 
  transmute(activity = activity_dict[X1])

# join Y,  X, and subject data frames
df_wide <- bind_cols(subject_full, df_Y, df_X)

# clean
rm(df_X); rm(df_Xfull); rm(df_Y); rm(df_Yfull)


# summarize
df_summary <- df_wide %>% 
  group_by(subject, activity) %>% 
  summarize(across(1:66, mean))

# Write summary to file
write.table(df_summary, "summary_data.txt", row.names = FALSE)




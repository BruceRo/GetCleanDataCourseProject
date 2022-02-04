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
mean_std <- str_detect(column_names, "mean") | str_detect(column_names, "std")
# filter df_Xfull for columns with mean or std
df_X <- df_Xfull[, mean_std]

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

# add Y  X and subject data frame
df_wide <- bind_cols(subject_full, df_Y, df_X)

# clean
rm(df_X); rm(df_Xfull); rm(df_Y); rm(df_Yfull)


# make long tidy data frame
df <- df_wide %>% 
  pivot_longer(-(subject:activity), names_to = "timeFreqVar", values_to = "measurement") 

# summarize
df_summary <- df %>% 
  group_by(subject, activity, timeFreqVar) %>% 
  summarize(mean_measurement = mean(measurement))

df_summary2 <- df_wide %>% 
  group_by(subject, activity) %>% 
  summarize(across(1:79, mean))






# rm(df_mean_walking);rm(df_mean_walking_downstairs);rm(df_mean_walking_upstairs)
# 
# rm(df_std_walking);rm(df_std_walking_downstairs);rm(df_std_walking_upstairs)



### separate mean and std to different columns


df_mean <- df_wide %>% 
  select(activity, contains("Mean"))
# remove Mean from name
names(df_mean) <- str_remove(names(df_mean), "Mean")
# pivot to long
df_mean <- df_mean %>% 
  pivot_longer(-activity, names_to = "timeFreqVar", values_to = "mean")

df_std <- df_wide %>% 
  select(activity, contains("Std"))
# remove Mean from name
names(df_std) <- str_remove(names(df_std), "Std")
# pivot to long
df_std <- df_std %>% 
  pivot_longer(-activity, names_to = "timeFreqVar", values_to = "std")


# break up for memory problems on join
df_mean_walking <- filter(df_mean, activity == "WALKING")
df_std_walking <- filter(df_std, activity == "WALKING")

df_mean_walking_upstairs <- filter(df_mean, activity == "WALKING_UPSTAIRS")
df_std_walking_upstairs <- filter(df_std, activity == "WALKING_UPSTAIRS")

df_mean_walking_downstairs <- filter(df_mean, activity == "WALKING_DOWNSTAIRS")
df_std_walking_downstairs <- filter(df_std, activity == "WALKING_DOWNSTAIRS")

df_mean_sitting <- filter(df_mean, activity == "SITTING")
df_std_sitting <- filter(df_std, activity == "SITTING")

df_mean_standing <- filter(df_mean, activity == "STANDING")
df_std_standing <- filter(df_std, activity == "STANDING")

df_mean_laying <- filter(df_mean, activity == "LAYING")
df_std_laying <- filter(df_std, activity == "LAYING")




# combine the two data frames
df_walking <- full_join(df_mean_walking, df_std_walking)
df_walking_upstairs <- full_join(df_mean_walking_upstairs, df_std_walking_upstairs)
df_walking_downstairs <- full_join(df_mean_walking_downstairs, df_std_walking_downstairs)
df_sitting <- full_join(df_mean_sitting, df_std_sitting)
df_standing <- full_join(df_mean_standing, df_std_standing)
df_laying <- full_join(df_mean_laying, df_std_laying)






df2 <- left_join(df_mean, df_std)


# calculate mean and standard deviations across columns
# df_X <- df_Xfull %>% 
#   rowwise() %>% 
#   transmute(mean = mean(c_across(1:561)),
#             sd = sd(c_across(1:561)))
# rm(df_Xfull)
# 
# rm(df_Yfull)
#   
# 
# 
# rm(df_X); rm(df_Y)
# 
# df_summary <- df %>% 
#   group_by(activity) %>% 
#   summarize(mean_mean = mean(mean),
#             mean_sd = mean(sd))


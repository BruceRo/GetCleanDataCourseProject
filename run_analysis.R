library(tidyverse)

# load data
df_trainX <- read_table("UCI\ HAR\ Dataset/train/X_train.txt", col_names = FALSE)
df_trainY <- read_table("UCI\ HAR\ Dataset/train/Y_train.txt", col_names = FALSE)

df_testX <- read_table("UCI\ HAR\ Dataset/test/X_test.txt", col_names = FALSE)
df_testY <- read_table("UCI\ HAR\ Dataset/test/Y_test.txt", col_names = FALSE)

# combine train and test sets
df_Xfull <- bind_rows(df_trainX, df_testX)
df_Yfull <- bind_rows(df_trainY, df_testY)

rm(df_testX); rm(df_trainX); rm(df_testY); rm(df_trainY)

# calculate mean and standard deviations across columns
df_X <- df_Xfull %>% 
  rowwise() %>% 
  transmute(mean = mean(c_across(1:561)),
            sd = sd(c_across(1:561)))
rm(df_Xfull)

# read activity labels and make dictionary
activity_labels <- read_table("UCI\ HAR\ Dataset/activity_labels.txt", col_names = FALSE)
activity_dict <- unlist(activity_labels$X2) # position matches number code so names not necessary
rm(activity_labels)

df_Y <- df_Yfull %>% 
  transmute(activity = activity_dict[X1])
rm(df_Yfull)
  
df <- bind_cols(df_X, df_Y)

rm(df_X); rm(df_Y)

df_summary <- df %>% 
  group_by(activity) %>% 
  summarize(mean_mean = mean(mean),
            mean_sd = mean(sd))


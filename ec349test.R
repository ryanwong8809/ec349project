load("C:/Users/ryanw/OneDrive/Desktop/EC349 Data Science/datasets/yelp_review_small.Rda")
load("C:/Users/ryanw/OneDrive/Desktop/EC349 Data Science/datasets/yelp_user_small.Rda")

##SENTIMENT SCORES FOR REVIEW DATA
#install tidy text and dplyr
install.packages(c("tidytext", "dplyr", "textdata"))
library(tidytext)
library(dplyr)
library("textdata")

# Load sentiment lexicon (AFINN as an example)
afinn_scores <- get_sentiments("afinn")

# Add a unique identifier to each row so that after tokenization, I can join the tokenized data back to the original data frame based on this identifier.
review_data_small <- review_data_small %>%
  mutate(review_id = row_number())

# Tokenize the text data
review_data_small_tokens <- review_data_small %>%
  unnest_tokens(word, text)

# Perform sentiment analysis and score each word using AFINN lexicon
review_data_small_sentiment <- review_data_small_tokens %>%
  inner_join(afinn_scores, by = "word") %>%
  group_by(review_id) %>%
  summarise(sentiment_score = sum(value))

# Join the sentiment scores back to the original data frame based on the unique identifier (review_id)
review_data_small <- review_data_small %>%
  left_join(review_data_small_sentiment, by = "review_id")

## COMBINING USER DATA AND REVIEW DATA
combined_data <- inner_join (user_data_small, review_data_small, by = "user_id")

#remove non-numeric,irrelevant and NA data from combined_data
combined_data_clean <- select(combined_data, -user_id, -name, -yelping_since, -elite, -friends, -review_id, -business_id, -text, -date)
combined_data_clean <- na.omit(combined_data_clean)

#renaming variables for clarity
combined_data_clean <- combined_data_clean %>%
  rename(stars_review = stars)
combined_data_clean <- combined_data_clean %>%
  rename(average_stars_given_by_user = average_stars)

# Remove rows with missing values
combined_data_clean <- na.omit(combined_data_clean)

#changing stars to being categorical
combined_data_clean$stars_review <- factor(combined_data_clean$stars_review)

## SPLITTING DATASETS INTO TRAINING AND TEST DATA
# Install caret to split datasets.
install.packages("caret")
library(caret)
set.seed(1)

#p determines the proporttion of the training set
train_indices <- createDataPartition(combined_data$stars, p = 0.8, list = FALSE)
# Create the training set
combined_data_training_set <- combined_data_clean[train_indices, ]
# Create the test set
combined_data_test_set <- combined_data_clean[-train_indices, ]

##RANDOM FOREST MODELLING
#install reqiured packages
install.packages(c("randomForest", "caTools"))
library(randomForest)
library(caTools)

#randomForest model with stars_review as the dependant variable
rf_model <- randomForest(stars_review ~., data=combined_data_training_set, ntree = 1000)
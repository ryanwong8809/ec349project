load("C:/Users/ryanw/OneDrive/Desktop/EC349 Data Science/datasets/yelp_review_small.Rda")

# Install caret to split datasets.
install.packages("caret")
library(caret)
set.seed(1)

# Assuming your dataset is stored in a data frame called 'your_data'
# The 'p' parameter determines the proportion of the data to be used for training
# The result is a list of indices for the training set
train_indices <- createDataPartition(review_data_small$stars, p = 0.8, list = FALSE)
# Create the training set
review_data_training_set <- review_data_small[train_indices, ]
# Create the test set
review_data_test_set <- review_data_small[-train_indices, ]

#install tidy text and dplyr
install.packages(c("tidytext", "dplyr"))
install.packages("textdata")
library(tidytext)
library(dplyr)
library("textdata")

# Load sentiment lexicon (AFINN as an example)
afinn_scores <- get_sentiments("afinn")

# Preprocess the text data
review_data_small_tokens <- review_data_small %>%
  unnest_tokens(word, text)

# Join tokenized data with sentiment scores
review_data_small_sentiment <- review_data_small_tokens %>%
  left_join(afinn_scores) %>%
  group_by(text) %>%
  summarise(sentiment_score = sum(score, na.rm = TRUE))
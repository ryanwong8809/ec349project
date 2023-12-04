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
install.packages(c("tidytext", "dplyr", "textdata"))
library(tidytext)
library(dplyr)
library("textdata")

# Load sentiment lexicon (AFINN as an example)
afinn_scores <- get_sentiments("afinn")

# Add a unique identifier to each row so that after tokenization, I can join the tokenized data back to the original data frame based on this identifier.
review_data_training_set <- review_data_training_set %>%
  mutate(review_id = row_number())

# Tokenize the text data
review_data_training_set_tokens <- review_data_training_set %>%
  unnest_tokens(word, text)

# Perform sentiment analysis and score each word using AFINN lexicon
review_data_training_set_sentiment <- review_data_training_set_tokens %>%
  inner_join(afinn_scores, by = "word") %>%
  group_by(review_id) %>%
  summarise(sentiment_score = sum(value))

# Join the sentiment scores back to the original data frame based on the unique identifier (review_id)
review_data_training_set <- review_data_training_set %>%
  left_join(review_data_training_set_sentiment, by = "review_id")

print("This file was created within RStudio")

print("And now it lives on GitHub")

install.packages("caret")
library(caret)
set.seed(1)
# Assuming your dataset is stored in a data frame called 'your_data'
# The 'p' parameter determines the proportion of the data to be used for training
# The result is a list of indices for the training set
train_indices <- createDataPartition(review_data_small$stars, p = 0.8, list = FALSE)
# Create the training set
training_set <- review_data_small[train_indices, ]
# Create the test set
test_set <- review_data_small[-train_indices, ]
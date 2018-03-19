# TODO:
# - Develop ML model for classification
# - Write report
library(caTools)
set.seed(1234)
dataset <- read.table("spotify_dataset_spring18.csv", sep=",", header=TRUE)

### Data Preprocessing ###

# Some tracks don't have audio features, so remove them.
dataset <- read.table("spotify_dataset_spring18.csv", sep=",", header=TRUE)
spotify_dataset <- spotify_dataset[!(spotify_dataset$tempo==0),]

# Remove fields that won't be used
spotify_dataset$mode <- NULL
spotify_dataset$type <- NULL
spotify_dataset$audio_features <- NULL
spotify_dataset$track_href <- NULL
spotify_dataset$analysis_url <- NULL
spotify_dataset$X <- NULL
spotify_dataset$key <- NULL
spotify_dataset$uri <- NULL

# Shuffle dataset
spotify_dataset <- spotify_dataset[sample(nrow(spotify_dataset)),]

# Encode categorial data
# spotify_dataset$time_signature <- factor(spotify_dataset$time_signature,
#                                         levels=c(1,3,4,5),
#                                         labels=c(1,3,4,5))
spotify_dataset$time_signature <- NULL
spotify_dataset$saved          <- factor(spotify_dataset$saved,
                                         levels=c(0,1),
                                         labels=c(0,1))

#spotify_dataset = spotify_dataset[, 1:10]

## Split dataset

split        <- sample.split(spotify_dataset$saved, SplitRatio = 0.75)
training_set <- subset(spotify_dataset, split == TRUE)
test_set     <- subset(spotify_dataset, split == FALSE)

## Feature Scaling 
training_set[, 1:10] = scale(training_set[, 1:10])
test_set[, 1:10] = scale(test_set[, 1:10])



#########   1. Logistic Regression   ############

# Create classifier and fit logistic regression to training_set
classifier = glm(formula = saved ~ .,
                 family = binomial,
                 data = training_set)

# predict the test_set results
prob_pred = predict(classifier, type = 'response', newdata = test_set[-11])
y_pred = ifelse(prob_pred > 0.5, 1, 0) # change probabilities to binary

# Build the confusion matrix & determine accuracy
lr_cm = table(test_set[,11], y_pred)
lr_accuracy = (sum(diag(cm))/sum(cm))
lr_cm
paste("Accuracy:",round(lr_accuracy*100,digits=2),"%") # ~61% for 0.75 split



# TODO:
# - Write report

library(caTools)
library(e1071)
library(class)
library(rpart)
library(ROCR)
set.seed(1)
dataset <- read.table("spotify_dataset_spring18.csv", sep=",", header=TRUE)

### Data Preprocessing ###

# Shuffle dataset
spotify_dataset <- dataset[sample(nrow(dataset)),]
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
lr_accuracy = (sum(diag(lr_cm))/sum(lr_cm))
lr_cm
paste("Accuracy:",round(lr_accuracy*100,digits=2),"%") # ~75% for 0.8 split and this seed

# Performance Evaluation
pred <- prediction(y_pred, test_set[,11])
lr_roc <- performance(pred, "tpr","fpr")


#########   2. K-Nearest Neighbours   ############

# train test split 
split        <- sample.split(spotify_dataset$saved, SplitRatio = 0.75)
training_set <- subset(spotify_dataset, split == TRUE)
test_set     <- subset(spotify_dataset, split == FALSE)

# feature scaling
training_set[, 1:10] = scale(training_set[, 1:10])
test_set[, 1:10] = scale(test_set[, 1:10])

# fit K-NN to training set and predict test set results
 # Rule of thumb: k = sqrt(nrow(training_set)) in this case, 32
y_pred = knn(train = training_set[, -11],
             test  = test_set[, -11],
             cl    = training_set[, 11],
             k     = 32)

knn_cm = table(test_set[, 11], y_pred)
knn_accuracy = (sum(diag(knn_cm))/sum(knn_cm))
knn_accuracy # ~62% accuracy with k=32

# Performance Evaluation
y_pred <- as.numeric(y_pred)-1 # converting from factor type
pred <- prediction(y_pred, test_set[,11])
knn_roc <- performance(pred, "tpr","fpr")


#########   3. Support Vector Machine - Linear Kernel  #########

split        <- sample.split(spotify_dataset$saved, SplitRatio = 0.8)
training_set <- subset(spotify_dataset, split == TRUE)
test_set     <- subset(spotify_dataset, split == FALSE)

## Feature Scaling 
training_set[, 1:10] = scale(training_set[, 1:10])
test_set[, 1:10] = scale(test_set[, 1:10])

# SVM Classifier 
classifier = svm(formula = saved ~ .,
                 data = training_set,
                 type = 'C-classification',
                 kernel = 'linear')

# Test on unseen data
y_pred = predict(classifier, newdata = test_set[-11])

# Evaluate using Confusion Matrix
svm_cm = table(test_set[, 11], y_pred)
svm_accuracy = (sum(diag(svm_cm))/sum(svm_cm))
paste("Accuracy:",round(svm_accuracy*100,digits=2),"%") # ~60% accuracy with 0.8 split

# Performance Evaluation
y_pred <- as.numeric(y_pred)-1 # converting from factor type
pred <- prediction(y_pred, test_set[,11])
svm_roc <- performance(pred, "tpr","fpr")

#########   4. Kernel SVM  #########
# data is not linearly seperable, so increase dimensionality 

split        <- sample.split(spotify_dataset$saved, SplitRatio = 0.75)
training_set <- subset(spotify_dataset, split == TRUE)
test_set     <- subset(spotify_dataset, split == FALSE)

## Feature Scaling 
training_set[, 1:10] = scale(training_set[, 1:10])
test_set[, 1:10] = scale(test_set[, 1:10])

# Fit Kernel SVM to the training set

classifier = svm(formula = saved ~ .,
                 data = training_set,
                 type = 'C-classification',
                 kernel = 'radial')

y_pred = predict(classifier, newdata = test_set[-11])

ksvm_cm = table(test_set[, 11], y_pred)
ksvm_accuracy = (sum(diag(ksvm_cm))/sum(ksvm_cm))
paste("Accuracy:",round(ksvm_accuracy*100,digits=2),"%") # ~63% accuracy with 0.8 split

# Performance Evaluation
y_pred <- as.numeric(y_pred)-1 # converting from factor type
pred <- prediction(y_pred, test_set[,11])
ksvm_roc <- performance(pred, "tpr","fpr")


#########   5. Decision Tree  #########

split        <- sample.split(spotify_dataset$saved, SplitRatio = 0.7)
training_set <- subset(spotify_dataset, split == TRUE)
test_set     <- subset(spotify_dataset, split == FALSE)

## Feature Scaling - not enabled to plot the decision tree 
# training_set[, 1:10] = scale(training_set[, 1:10])
# test_set[, 1:10] = scale(test_set[, 1:10])

# Fit classifier to Training Set
classifier = rpart(formula = saved ~ .,
                   data = training_set)

y_pred = predict(classifier, newdata = test_set[-11], type='class')


dt_cm = table(test_set[, 11], y_pred)
dt_accuracy = (sum(diag(dt_cm))/sum(dt_cm))
paste("Accuracy:",round(dt_accuracy*100,digits=2),"%") # ~60% accuracy with 0.8 split

#plot(classifier)
#text(classifier)

# Performance Evaluation
y_pred <- as.numeric(y_pred)-1 # converting from factor type
pred <- prediction(y_pred, test_set[,11])
dt_roc <- performance(pred, "tpr","fpr")

######### Performance Evaluation ########

plot(lr_roc,
     main = "ROC Curve - Performance Evaluation",
     ylab = "Sensitivity",
     xlab = "1-Specificity",
     col=rgb(1,0,0,0.8),
     lwd=2,
     lty=5)
plot(knn_roc,
     add=T,
     col=rgb(0,1,0,0.8),
     lwd=2,
     lty=5)
plot(svm_roc,
     add=T,
     col=rgb(0,0,1,0.8),
     lwd=2,
     lty=5)
plot(ksvm_roc,
     add=T,
     col=rgb(1,0,1,0.8),
     lwd=2,
     lty=5)
plot(dt_roc,
     add=T,
     col=rgb(0.2,0.2,0.2,0.8),
     lwd=2,
     lty=5)
abline(a=0, b=1)
legend(0.4,0.3,
       legend=c("Logistical Regression",
                "k-NN",
                "SVM",
                "Gaussian Kernel SVM",
                "Decision Tree"),
       col=c("red", "blue", "green","purple","grey"), 
       pch=15, 
       cex=0.7)


# Import Keras
# A library needed for model training
library(keras)

# Set Working Directory
getwd()
setwd("C:/Users/yahya/RProjects/IntroToDSProject")

# Load data
mnist <- dataset_mnist()
View(mnist)
# Split the data into training and testing
c(c(train_images, train_labels), c(test_images, test_labels)) %<-% mnist

# Load Model
# Make sure to have the correct path
new_model <- load_model_tf("C:/Users/yahya/RProjects/IntroToDSProject/Model")
summary(new_model)

# Array for plotting
plottingImages <- array_reshape(test_images, c(10000, 28 * 28))


# Change index to get different sample
index = 123

# Reshaoe for plotting
e <- plottingImages[index, ]
x <- array_reshape(e, c(28, 28))

# Plot the digit
plot(as.raster(x, max=255))

# Reshape for prediction
digit <- array_reshape(e, c(1, 28, 28))

# Run the prediction
predictions <- new_model %>% predict(digit)

# Print the prediction
print(which.max(predictions) - 1)

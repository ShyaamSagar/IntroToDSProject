library(keras)
devtools::install_github("andrie/deepviz")

# install_keras(tensorflow="gpu")

mnist <- dataset_mnist()

# View(mnist)
# c(c(train_images, train_labels), c(test_images, test_labels)) %<-% mnist

# digit <- train_images[2, ,]
# plot(as.raster(digit, max=255))

# train_images <- array_reshape(train_images, c(60000, 28*28))
# 
# train_images[5,]
# digit1 <- array_reshape(train_images[1,], c(28, 28))
# plot(as.raster(digit1, max=255))

mnist$train$x <- mnist$train$x/255
mnist$test$x <- mnist$test$x/255

model <- keras_model_sequential() %>% 
  layer_flatten(input_shape = c(28, 28)) %>% 
  layer_dense(units = 64, activation = "relu") %>% 
  layer_dense(units = 128, activation = "relu") %>%
  layer_dropout(0.2) %>% 
  layer_dense(10, activation = "softmax")


summary(model)
model %>% compile(loss = "sparse_categorical_crossentropy",
                  optimizer = "adam",
                  metrics = "accuracy")

summary(model)

history <- model %>% 
  fit(
    x = mnist$train$x, y = mnist$train$y,
    epochs = 5,
    validation_split = 0.3,
    verbose = 2
  )


model %>% evaluate(x = mnist$test$x, y = mnist$test$y)

save_model_hdf5(model, "C:/Users/yahya/RProjects/IntroToDSProject/Model/model.h5")

# Recreate the exact same model purely from the file
new_model <- load_model_hdf5("model.h5")
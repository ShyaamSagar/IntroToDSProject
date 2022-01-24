library(shiny)
library(imager)
library(keras)
library(shinythemes)


new_model <- load_model_hdf5("C:/Users/yahya/RProjects/IntroToDSProject/Model/model.h5")

ui <- fluidPage(
  # Hide Warnings
  tags$style(type="text/css",
             
             ".shiny-output-error { visibility: hidden; }",
             
             ".shiny-output-error:before { visibility: hidden; }"
             
  ),
  # Change Theme
  theme = shinytheme("superhero"),
  # Navigation Bar
  navbarPage(
    # Title
    "Handwritten Digit Recognition",
    # Digit Recognizer Tab
    tabPanel("Digit Recognizer",
             sidebarLayout(
               sidebarPanel(
                 fileInput("file1", "Choose File", accept = NULL)
               ),
               mainPanel(
                 
                 tabsetPanel(type = "tabs",
                             # First plot
                             tabPanel("Image", plotOutput("plot")),
                             # Second plot
                             tabPanel("Resized Image", plotOutput("plotresize")),
                             # Main Classification
                             tabPanel("Classification", verbatimTextOutput("pred"))
                 )
                 
               )
             )
             
    ),
    # Documentation Tab
    tabPanel("Documentation", 
             navlistPanel(
               # Header
               "How to use the app",
               # Subheader
               tabPanel("The different tabs",
                        
                        "You are currently in the", strong("documentations tab,"), "this tab contains 
                        information on how to use the app. The other two tabs are the", 
                        strong("\"Digit Recognizer\""), 
                        "tab and the", strong("\"About the Project\""), "tab. If you would like to know more about our project
                        and why we made it, you can head to the", strong("\"About the Project\""), "tab, otherwise you can get 
                        right away into the fun and start using the digit recognizer."
            
                        ),
               # Header
               "The Digit Recognizer",
               # Subheader
               tabPanel("Uploading an Image",
                        "To upload an image click on the browse button in the digit recognizer tab, 
                        this will open up your file explorer and from there you can upload your image.
                        The image has to be", strong("on a black background with the drawn digit being white"),
                        "or otherwise the prediction will be inaccurate."),
               # Subheader
               tabPanel("The plots",
                        "The two plots shown are different, one is for the regular image inputted by you, the user,
                        and the other one is for the resized image. The model only takes images of size 28x28 pixels,
                        so the image is resized automatically."),
               # Subheader
               tabPanel("The result",
                        "The result will be a single digit which corresponds to what the model thinks your image input is,
                        sometimes it may not be accurate, and that is due to the simple architecture of this model.
                        Inaccuracy can also be caused by the distortion of the image when resized, so as a suggestion
                        you can use a website called", a("kleki.com", href="kleki.com"), "this may or may not help
                        increase the accuracy of the model. For more info, check the Increase accuracy tab."),
               # Header
               "Increase Accuracy",
               # Subheader
               tabPanel("Using Kleki",
                        "To help the model make better classification, you can upload a 28x28 image. This can be done
                        using", a("kleki.com", href="kleki.com"), ". Head to the site, and press the new image button
                        in the top right corner, after that choose the black background, and choose the size to be 28 by 28
                        pixels. Finally choose the white paint brush and set it to a size of 2. Download the image using the
                        save image button in the top right corner, and now you are ready to upload that image to our model.")
             
             )
    ),
    # About the Project tab
    tabPanel("About Our Project",
             "Creating this program wasn't easy, all our group members had to collaborate to succesfuly finish this
             project. We tried executing multiple approaches, eventually we would settle with the best approach.
             There are two parts this program: the ML model and the shiny app.",
             "The Machine Learning technology used to recognize and classify handwritten digits, allows
             this project to be put under the broad ICR (Intelligent Character Recognition) umbrella. ICR has
             many applications and usages, making this project very beneficial to the right people.",
             "Applications of this program include, processing bank checks, identify signatures, or reading handwritten
             documents. With a bit more enhancment this program can be help multiple companies in accomplishing
             different goals, it all depends on their case.",
             "For the Shiny part of the app, we worked together to create the template, get the user input, and
             do the operations required to produce the output. We faced multiple problems, but we were able to work
             around all the bugs and errors.",
             "I think that the experience gained in this work will aid us in our endeavours going further. The skillsets
             developed, like communication and self-learning, will be essential in the working industry.")
    
  
)
)

convertToIM <- function(i) {
  path <- i[4]
  pathx <- gsub("\\\\", "/", path)
  im <- load.image(pathx)
  im <- resize(im, size_x = 28, size_y = 28, size_z = 1, size_c = 1)
  return(im)
}
plotIm <- function(i) {
  path <- i[4]
  pathx <- gsub("\\\\", "/", path)
  im <- load.image(pathx)
  
  plot(im)
}
plotResize <- function(i) {
  path <- i[4]
  pathx <- gsub("\\\\", "/", path)
  im <- load.image(pathx)
  
  im <- resize(im, size_x = 28, size_y = 28, size_z = 1, size_c = 1)
  plot(im)
}
pred <- function(arr) {
  arr <- convertToIM(arr)
  arr <- array_reshape(arr, c(28, 28))
  arr <- t(arr)
  digit <- array_reshape(arr, c(1, 28, 28))
  
  predictions <- new_model %>% predict(digit)
  
  print(which.max(predictions)-1)
}


server <- function(input, output) {
  output$plot <- renderPlot({
    plotIm(input$file1)
  })
  output$plotresize <- renderPlot({
    plotResize(input$file1)
  })
  output$pred <- renderPrint({
    pred(input$file1)
  })
  
  
}

shinyApp(ui, server)
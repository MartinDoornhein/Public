
library(shiny)

# Defining server logic required to draw the models
shinyServer(function(input, output) {
  
  output$plot1 <- renderPlot({
    
    data <- kc_house_data %>%
      filter(price <= input$price_input)
    
    #Creating 3 different models for predicting price
    lin <- lm(price ~ sqft_living + waterfront + grade + yr_renovated + long, data = data)
    pol_2 <- lm(price ~ poly(sqft_living, 2) + waterfront + grade + poly(yr_renovated, 2) + poly(long, 2), data = data)
    pol_3 <- lm(price ~ poly(sqft_living, 3) + waterfront + grade + poly(yr_renovated, 3) + poly(long,3), data = data)
    
    #Making a dataframe for the best variables chosen by cross-validation
    x_values <- data.frame(sqft_living = data$sqft_living,
                           waterfront = data$waterfront,
                           grade = data$grade, 
                           yr_renovated = data$yr_renovated,
                           long = data$long)
    
    # 
    y_pred_lin <- predict(lin, x_values)
    y_pred_pol_2 <- predict(pol_2, x_values)
    y_pred_pol_3 <- predict(pol_3, x_values)
    
    
    #Making the first plot which displays the different statistical methods.
    
    #But first, for changing the text lay-out of the graph (title & axes) the following code is necessary:
    black.bold.text <- element_text(face = "bold", color = "black") 
    
    ggplot(data = data, aes(x = y_pred_lin, y = data$price, color = sqft_living))+
      scale_colour_gradient(name = "Living space in sqft", low = "blue", high = "black")+
      ggtitle("\nPredictions for the house prices\n")+
      xlab("\nPredicted values for p")+
      ylab("Observed values for p\n")+
      geom_jitter(alpha = .2)+
      geom_smooth(aes(x = y_pred_lin, y = data$price), size = input$regInput, color = 'blue', se = F, method = 'lm')+
      geom_smooth(aes(x = y_pred_pol_2, y = data$price), size = input$poly_2_Input, color = 'red', se = F, method= 'loess')+
      geom_smooth(aes(x =  y_pred_pol_3, y = data$price), size = input$poly_3_Input, color = 'green', se = F, method = 'loess')+
      theme_classic()+
      theme(title = black.bold.text)
  })
  
  #Creating a table that displays information about the models
  output$modelres <- renderTable({
    data <- kc_house_data %>%
      filter(price <= input$price_input)
    
    #Linear, polynomial order 2 en polynomial order 3
    model.lin <- lm(price ~ sqft_living + waterfront + grade + yr_renovated + long, data = data)
    model.pol_2 <- lm(price ~ poly(sqft_living, 2) + waterfront + grade + poly(yr_renovated, 2) + poly(long, 2), data = data)
    model.pol_3 <- lm(price ~ poly(sqft_living, 3) + waterfront + grade + poly(yr_renovated, 3) + poly(long, 3), data = data)
    
    #
    model.lin.sum <- summary(model.lin)
    model.pol_2.sum <- summary(model.pol_2)
    model.pol_3.sum <- summary(model.pol_3)
    
    tablemodelres <- matrix(c("Linear Regression", "Polynomial 2 Regression", "Polynomial 3 Regression",
                              round(model.lin.sum$r.squared, 3), round(model.pol_2.sum$r.squared, 3), 
                              round(model.pol_3.sum$r.squared, 3), round(model.lin.sum$adj.r.squared, 3), 
                              round(model.pol_2.sum$adj.r.squared, 3), round(model.pol_3.sum$adj.r.squared, 3),
                              model.lin.sum$df[2], model.pol_2.sum$df[2], model.pol_3.sum$df[2]), ncol = 4)
    colnames(tablemodelres) <- c(" ", "R-squared", "Adj R-squared", "df")
    
    tablemodelres
  })
  
  top_data <- reactive({
    kc_house_data %>%
      arrange(desc(!!!input$varInput)) %>%
      slice(1:input$numberInput)
    #filter()
  })
  
  houseIcon <- makeIcon(
    iconUrl = "https://image.flaticon.com/icons/png/512/69/69524.png",
    iconWidth = 18, iconHeight = 18,
    iconAnchorX = 22, iconAnchorY = 50)
  
  output$mymap <- renderLeaflet({
    leaflet(top_data()) %>%
      setView(lng = mean(top_data()$long), lat = mean(top_data()$lat), zoom = 10) %>%
      addTiles() %>%
      addMarkers(data = top_data(), lat = ~lat, lng = ~long, icon = houseIcon,
                 popup = ~ paste("<B>Price:</B>", dollar(price), "<br>", 
                                "<B>Surface living (ft):</B>", sqft_living, "<br>",
                                "<B>Total surface (ft):</B>", sqft_living + sqft_above + sqft_basement, "<br>", 
                                "<B>Number of bedrooms:</B>", bedrooms))
    
  })
})





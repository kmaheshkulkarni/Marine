function(input, output, session) {


  observeEvent(input$vessel_type,{
    # updateSelectizeInput(session = session, inputId = "vessel_names",label = "Vessel Names",
    #                      choices = as.character(unique(ships$SHIPNAME[ships$ship_type == input$vessel_type])))

    update_dropdown_input(session = session, input_id = "vessel_name",
                          choices = as.character(unique(ships$SHIPNAME[ships$ship_type == input$vessel_type])))
  })

  observeEvent(input$insights,{
    if(is.null(input$insights)||input$insights==0)
    {
      returnValue()
    }
    else
    {

      print(input$vessel_name)
      print(input$vessel_type)
      ships1 <- ships_reduced %>% filter(SHIPNAME==input$vessel_name & ship_type==input$vessel_type)

      if(nrow(ships1)==0)
      {
        returnValue()
        shinyalert::shinyalert("Error","No Records Found",type = "error")
      }
      else
      {

        print(nrow(ships1))
        DFships <- as.data.frame(ships1)
        DFships$lag_LON <- lag(DFships$LON)
        DFships$lag_LAT <- lag(DFships$LAT)
        for (i in 1:nrow(DFships)){
          distance <- distm(c(DFships$lag_LON[i], DFships$lag_LAT[i]), c(DFships$LON[i], DFships$LAT[i]), fun = distHaversine)
          distance <- distance[1]
          DFships$distance[i] <- distance
        }

        DFships$lag_time <- lag(DFships$DATETIME)
        DFships$time_diff <- DFships$DATETIME - DFships$lag_time
        DFships$distance <- ifelse(DFships$time_diff<0, 0, DFships$distance)
        DFships <- DFships[!is.na(DFships$distance),]
        DFships <- DFships %>% filter(distance == max(distance))
        if(nrow(DFships)>1){
          DFships <- DFships %>% slice(which.max(DATETIME))
        }
        DFships$distance <- round(DFships$distance, 0)
        Departure <- c(DFships$lag_LAT, DFships$lag_LON, "Departure")
        Arrival <- c(DFships$LAT, DFships$LON, "Arrival")
        Travel <- rbind(Departure, Arrival)
        Travel <- as.data.frame(Travel)
        names(Travel) <- c("lat", "long", "labels")
        Travel$lat <- as.numeric(as.character(Travel$lat))
        Travel$long <- as.numeric(as.character(Travel$long))
        list(Travel=Travel, distance=DFships$distance[1])

        print(Travel)
        output$map <- renderLeaflet({
          leaflet(data=Travel) %>%
            addTiles() %>%
            addMarkers(lng = ~long, lat = ~lat, popup = ~as.character(labels),
                       label = ~as.character(labels),labelOptions = labelOptions(noHide = T)) %>%
            setView(lng =  Travel$long[1], lat = Travel$lat[1], zoom = 8) %>%
            addLegend("bottomleft",
                      colors =c(""),
                      labels= c(""),
                      title= paste0("Distance in metres: ",round(distance, 2)),
                      opacity = 1)
        })

        output$table <- DT::renderDataTable(
          semantic_DT(Travel)
        )

      }

    }
    })

}

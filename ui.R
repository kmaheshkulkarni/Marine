
# router <<- make_router(
#   route("#", info_page)
# )

semanticPage(

  shinyalert::useShinyalert(),


  header(title = tagList(img(src = "logom.png", width= '120')), description = "Maine Data Insights"),


  tags$head(
    tags$link(rel="stylesheet", href="style.css", type="text/css" )
  ),


    tabset(tabs =
             list(
               list(menu = "Maine Data Insights", id = "first_tab",
                    content =  div(
                      segment(
                        div(class = "ui three column stackable grid container",
                            div(class = "column",
                                dropdown_input("vessel_type", choices = unique(vessel_types),default_text = "Select Vessel Type")
                            ),

                            div(class = "column",
                                dropdown_input("vessel_name", choices = unique(vessel_names), default_text = "Select Vessel Names")
                            ),

                            div(class = "column",
                                action_button("insights", "Get Insights", class = "ui yellow button")
                            )
                            #
                            #                           div(class = "column",
                            #                               date_input("date_from", value = Sys.Date(), style = "width: 10%;", icon_name = "calendar")
                            #                           ),
                            #
                            #                       div(class = "column",
                            #                           date_input("date_to", value = Sys.Date()+7, style = "width: 10%;", icon_name = "calendar")
                            #                     )


                        )
                      ),

                      div(class = "ten wide column",
                          segment(
                            div(class="ui yellow ribbon label", "Marine Map"),
                            leafletOutput("map", width = "100%", height = "700") %>% withSpinner(color="#ffc107")
                          )
                      )

                    )),
               list(menu = "Table Insights", content = semantic_DTOutput("table"), id = "second_tab")
             ),
           active = "first_tab",
           id = "tabset"

  )

  # horizontal_menu(
  #   list(
  #     list(name = "Maine Data Insights", link = "#", icon = "world"),
  #     list(name = "Player's details", icon = "running"),
  #     list(name = "By country", icon = "globe europe"),
  #     list(name = "By league", icon = "futbol outline")
  #   ), logo = "logom.png"
  # ),

  # router_ui()
  # pickerInput(
  #   inputId = "vessel_type",
  #   label = "Select Vessel Type",
  #   choices = vessel_types,
  #   options = list(
  #     `live-search` = TRUE)
  # )
)


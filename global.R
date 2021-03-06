source("packages.R")
ships <- as.data.frame(vroom("./ships_data/ships.csv", delim = ","))
ships_reduced <- ships %>% select(LAT, LON, SHIPNAME, ship_type,DATETIME, date, week_nb, PORT)
# write.csv(ships_reduced, "ships_reduced.csv")
# ships <- as.data.frame(vroom("ships_reduced.csv", delim = ","))
vessel_types <- unique(ships$ship_type)
vessel_types <- sort(vessel_types)
vessel_names <- unique(ships$SHIPNAME)

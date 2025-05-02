
################### Disclaimer ################

## This software is provided "as-is," without any express or implied warranty. In no event shall the author(s) be held liable for any damages arising from the use of this software.

## **Non-Commercial Use Only**: This code and associated Reask data "LiveCyc_al142024_2024100806_ft_gust_exProba_Cat1.tiff" is licensed for personal and educational use only. You may not use, distribute, or modify this software or data for any commercial purposes, whether for-profit or non-profit, without explicit permission from the author(s).

## **No Liability**: The author(s) make no representations or warranties regarding the accuracy or functionality of this software. The use of this code is at your own risk, and the author(s) disclaim any responsibility for any direct, indirect, incidental, or consequential damages arising from its use.

## By using this software, you agree to the terms of this disclaimer.

##############################################


rm(list=ls())

## load libraries 
library(data.table)
library(raster)
library(leaflet)
library(sf)
library(htmlwidgets)
library(htmltools)

## Read locations. In this example at Risk Locations taken from the City of Tampa GeoHub including Fire Stations, Hospitals and Police Stations
## https://city-tampa.opendata.arcgis.com/search?tags=Location

DataBase=fread('Database.csv')

## Read Reask forecast cat 1 wind probability - as at 06:00 UTC 8th October 2024 
ProbabiltyFootprint=raster('LiveCyc_al142024_2024100806_ft_gust_exProba_Cat1.tiff')

## map database coords to Reask map coords
X <- DataBase$X
Y <- DataBase$Y
coords <- data.frame(X = X, Y = Y)
points_sf <- st_as_sf(coords, coords = c("X", "Y"), crs = 3857)
points_latlon <- st_transform(points_sf, crs =st_crs(ProbabiltyFootprint))

DataBase$longitude <- st_coordinates(points_latlon)[,1]
DataBase$latitude <- st_coordinates(points_latlon)[,2]

## extract Reask wind probabilities at the locations 
DataBase$wind=extract(ProbabiltyFootprint,SpatialPoints(cbind(DataBase$longitude,DataBase$latitude)))

## prepare data to plot
data.to.plot<-DataBase
StormData<-ProbabiltyFootprint

## location plot settings
zcol="wind"
q=quantile(data.to.plot$wind)
az<-data.to.plot$wind
maxsize = 8
pt.cex <- 5 + as.vector(maxsize * az / max(az, q))

# Create a color palettes
mybins=q  
mypalette = colorBin( palette="Reds", domain=data.to.plot$wind, na.color="transparent", bins=mybins) ## locations 
pal =  colorBin( palette="Blues", values(StormData), na.color="transparent") ## storm prob footrprint

# Text for pop up at location 
mytext=paste("Reask Cat 1 Wind Speed Probability: ", round(data.to.plot$wind),'%', "<br/>", "Name: ", data.to.plot$Name,"<br/>", "DataSet: ", data.to.plot$DataSet, sep="") %>%
  lapply(htmltools::HTML)


### HTML plot###

tag.map.title <- tags$style(HTML("
  .leaflet-control.map-title { 
    transform: translate(-50%,20%);
    position: fixed !important;
    left: 50%;
    text-align: center;
    padding-left: 10px; 
    padding-right: 10px; 
    background: rgba(255,255,255,0.75);
    font-weight: bold;
    font-size: 22px;
  }
"))

title <- tags$div(
  tag.map.title, HTML("Reask wind-at-site Probabilities")
)  

p = leaflet(data.to.plot) %>%
  addTiles()  %>%
  setView(lat=data.to.plot$latitude[1], lng=data.to.plot$longitude[1], zoom=10) %>%
  addProviderTiles("Esri.WorldImagery")  %>%
  addRasterImage(StormData,colors = pal,opacity = 0.7) %>% addLegend(pal = pal, values = values(StormData),
                                                       title = "Reask Probability of Cat 1 Winds or Above",position='bottomleft') %>%
  addCircleMarkers(~longitude, ~latitude,
                   fillColor = ~mypalette(wind), fillOpacity = 0.7, color="white", radius=pt.cex, stroke=FALSE,label = mytext,
                   labelOptions = labelOptions( style = list("font-weight" = "normal", padding = "3px 8px"), textsize = "13px", direction = "auto")) %>%
  addLegend( pal=mypalette, values=~wind, opacity=0.9, title = "Reask Cat 1 or Above Probability at Site", position = "bottomright" ) %>%
  addControl(title, position = "topleft", className="map-title")

## plot in R
p


## write HTML ##
#saveWidget(p, file="ReaskPlot.html")



################### Disclaimer ################

## This demo code is provided "as-is," without any express or implied warranty. In no event shall the author(s) be held liable for any damages arising from the use of this code.

## **Non-Commercial Use Only**: This code and associated Reask data "LiveCyc_al142024_2024100806_ft_gust_exProba_Cat1.tiff" is licensed for personal and educational use only. You may not use, distribute, or modify this software or Reask data for any commercial purposes, whether for-profit or non-profit, without explicit permission from the author(s).

## **No Liability**: The author(s) make no representations or warranties regarding the accuracy or functionality of this software. The use of this code is at your own risk, and the author(s) disclaim any responsibility for any direct, indirect, incidental, or consequential damages arising from its use.

## By using this software, you agree to the terms of this disclaimer.

##############################################

This R demo code takes at risk asset locations from https://city-tampa.opendata.arcgis.com/search?tags=Location and maps them against Reask's (1km) forecast estimates for category 1 equivalent winds at each site.

Input:

Databse.csv = a database including police station, hospitals and fire station locations in Tampa Florida. Source: https://city-tampa.opendata.arcgis.com/search?tags=Location.

LiveCyc_al142024_2024100806_ft_gust_exProba_Cat1.tiff = Reask cat 1 equivalent wind speeds probabilities (1km resolution) at 06:00 UTC on 8th October 2024.

Output:

ReaskPlot.html = an interactive map where location level wind speeds can be viewed at each input location. 


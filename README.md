# collision-data-analysis
This is an analysis repository for Hong Kong Collision Data.

## Objective

To explore analysis and visualisation approaches for Hong Kong collision data.  

## Data

There are three main datasets:

1. Accident data (2014 - 2019)
1. Casualty data (2014 - 2019)
1. Vehicle data (2014 - 2019) 

The data file is saved in the Excel file in `data/19codee.xls`.

## Analysis

The analysis is implemented in R. 

## Repo Structure


|   .gitattributes
|   .gitignore
|   .Rhistory
|   collision-data-analysis.Rproj
|   README.md
|   
+---data
|       19codee.xls
|       Accident 2014-2019.xlsx
|       Casualty 2014-2019.xlsx
|       Vehicle 2014-2019.xlsx
|       
+---output
|       number-of-vehicles-by-dc.svg
|       
\---script
    |   main analysis script template.R
    |   read in data.R
    |   
    \---individual-analysis
            collision-number-of-vehicles-by-dc.R
            initital exploration.R
            leaflet exploration.R


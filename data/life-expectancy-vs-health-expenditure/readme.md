# Life expectancy vs. health expenditure - Data package

This data package contains the data that powers the chart ["Life expectancy vs. health expenditure"](https://ourworldindata.org/grapher/life-expectancy-vs-health-expenditure?v=1&csvType=full&useColumnShortNames=false) on the Our World in Data website.

## CSV Structure

The high level structure of the CSV file is that each row is an observation for an entity (usually a country or region) and a timepoint (usually a year).

The first two columns in the CSV file are "Entity" and "Code". "Entity" is the name of the entity (e.g. "United States"). "Code" is the OWID internal entity code that we use if the entity is a country or region. For normal countries, this is the same as the [iso alpha-3](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3) code of the entity (e.g. "USA") - for non-standard countries like historical countries these are custom codes.

The third column is either "Year" or "Day". If the data is annual, this is "Year" and contains only the year as an integer. If the column is "Day", the column contains a date string in the form "YYYY-MM-DD".

The remaining columns are the data columns, each of which is a time series. If the CSV data is downloaded using the "full data" option, then each column corresponds to one time series below. If the CSV data is downloaded using the "only selected data visible in the chart" option then the data columns are transformed depending on the chart type and thus the association with the time series might not be as straightforward.

## Metadata.json structure

The .metadata.json file contains metadata about the data package. The "charts" key contains information to recreate the chart, like the title, subtitle etc.. The "columns" key contains information about each of the columns in the csv, like the unit, timespan covered, citation for the data etc..

## About the data

Our World in Data is almost never the original producer of the data - almost all of the data we use has been compiled by others. If you want to re-use data, it is your responsibility to ensure that you adhere to the sources' license and to credit them correctly. Please note that a single time series may have more than one source - e.g. when we stich together data from different time periods by different producers or when we calculate per capita metrics using population data from a second source.

## Detailed information about each time series


## Life Expectancy,age 0 – UN WPP
Period life expectancy for individuals who have reached age 0. Estimates are expressed as the expected age at death, not as years left to live.
Last updated: July 12, 2024  
Date range: 1950–2023  
Unit: years  


### How to cite this data

#### In-line citation
If you have limited space (e.g. in data visualizations), you can use this abbreviated in-line citation:  
UN, World Population Prospects (2024) – processed by Our World in Data

#### Full citation
UN, World Population Prospects (2024) – processed by Our World in Data. “Life Expectancy,age 0 – UN WPP” [dataset]. United Nations, “World Population Prospects” [original data].
Source: UN, World Population Prospects (2024) – processed by Our World In Data

### What you should know about this data

### Source

#### United Nations – World Population Prospects
Retrieved on: 2024-07-11  
Retrieved from: https://population.un.org/wpp/Download/  

### How we process data at Our World In Data

All data and visualizations on Our World in Data rely on data sourced from one or several original data providers. Preparing this original data involves several processing steps. Depending on the data, this can include standardizing country names and world region definitions, converting units, calculating derived indicators such as per capita measures, as well as adding or adapting metadata such as the name or the description given to an indicator.
At the link below you can find a detailed description of the structure of our data pipeline, including links to all the code used to prepare data across Our World in Data.
[Read about our data pipeline](https://docs.owid.io/projects/etl/)


## Health expenditure per capita - Total
Health expenditure in total divided by population. Includes all health care financing schemes: government, compulsory contributory insurance, voluntary insurance, household out-of-pocket payments, and rest of the world financing schemes.
Last updated: February 23, 2024  
Next update: February 2025  
Date range: 1970–2022  
Unit: international-$ in 2015 prices  


### How to cite this data

#### In-line citation
If you have limited space (e.g. in data visualizations), you can use this abbreviated in-line citation:  
OECD Health Expenditure and Financing Database (2023) – with minor processing by Our World in Data

#### Full citation
OECD Health Expenditure and Financing Database (2023) – with minor processing by Our World in Data. “Health expenditure per capita - Total” [dataset]. OECD Health Expenditure and Financing Database, “OECD Health Expenditure and Financing Database” [original data].
Source: OECD Health Expenditure and Financing Database (2023) – with minor processing by Our World In Data

### What you should know about this data
* The data is measured in international-$ at 2015 prices – this adjusts for inflation and for differences in the cost of living between countries.

### Source

#### OECD Health Expenditure and Financing Database
Retrieved on: 2024-02-23  
Retrieved from: https://data-explorer.oecd.org/  

### How we process data at Our World In Data

All data and visualizations on Our World in Data rely on data sourced from one or several original data providers. Preparing this original data involves several processing steps. Depending on the data, this can include standardizing country names and world region definitions, converting units, calculating derived indicators such as per capita measures, as well as adding or adapting metadata such as the name or the description given to an indicator.
At the link below you can find a detailed description of the structure of our data pipeline, including links to all the code used to prepare data across Our World in Data.
[Read about our data pipeline](https://docs.owid.io/projects/etl/)


## Population (historical)
Population by country, available from 10,000 BCE to 2023, based on data and estimates from different sources.
Last updated: July 15, 2024  
Next update: July 2026  
Date range: 10000 BCE – 2023 CE  
Unit: people  


### How to cite this data

#### In-line citation
If you have limited space (e.g. in data visualizations), you can use this abbreviated in-line citation:  
HYDE (2023); Gapminder (2022); UN WPP (2024) – with major processing by Our World in Data

#### Full citation
HYDE (2023); Gapminder (2022); UN WPP (2024) – with major processing by Our World in Data. “Population (historical)” [dataset]. PBL Netherlands Environmental Assessment Agency, “History Database of the Global Environment 3.3”; Gapminder, “Population v7”; United Nations, “World Population Prospects”; Gapminder, “Systema Globalis” [original data].
Source: HYDE (2023); Gapminder (2022); UN WPP (2024) – with major processing by Our World In Data

### What you should know about this data

### Sources

#### PBL Netherlands Environmental Assessment Agency – History Database of the Global Environment
Retrieved on: 2024-01-02  
Retrieved from: https://doi.org/10.24416/UU01-AEZZIT  

#### Gapminder – Population
Retrieved on: 2023-03-31  
Retrieved from: http://gapm.io/dpop  

#### United Nations – World Population Prospects
Retrieved on: 2024-07-11  
Retrieved from: https://population.un.org/wpp/Download/  

#### Gapminder – Systema Globalis
Retrieved on: 2023-03-31  
Retrieved from: https://github.com/open-numbers/ddf--gapminder--systema_globalis  

### How we process data at Our World In Data

All data and visualizations on Our World in Data rely on data sourced from one or several original data providers. Preparing this original data involves several processing steps. Depending on the data, this can include standardizing country names and world region definitions, converting units, calculating derived indicators such as per capita measures, as well as adding or adapting metadata such as the name or the description given to an indicator.
At the link below you can find a detailed description of the structure of our data pipeline, including links to all the code used to prepare data across Our World in Data.
[Read about our data pipeline](https://docs.owid.io/projects/etl/)

#### Notes on our processing step for this indicator
The population data is constructed by combining data from multiple sources:

- 10,000 BCE - 1799: Historical estimates by HYDE (v3.3).

- 1800 - 1949: Historical estimates by Gapminder (v7).

- 1950-2023: Population records by the UN World Population Prospects (2024 revision).


## Continent
Countries and their associated continents.


### How to cite this data

#### In-line citation
If you have limited space (e.g. in data visualizations), you can use this abbreviated in-line citation:  
Our World In Data – processed by Our World in Data

#### Full citation
Our World In Data – processed by Our World in Data. “Continent” [dataset]. Our World In Data [original data].
Source: Our World In Data

### How we process data at Our World In Data

All data and visualizations on Our World in Data rely on data sourced from one or several original data providers. Preparing this original data involves several processing steps. Depending on the data, this can include standardizing country names and world region definitions, converting units, calculating derived indicators such as per capita measures, as well as adding or adapting metadata such as the name or the description given to an indicator.
At the link below you can find a detailed description of the structure of our data pipeline, including links to all the code used to prepare data across Our World in Data.
[Read about our data pipeline](https://docs.owid.io/projects/etl/)


    
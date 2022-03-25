# Explorating and Visualizing COVID-19 data
Project to explore and visualize COVID-19 data

# Introduction
The objetive of this project is to explore COVID-19 cases, deaths and vaccination rates using SQL and the visualize the results using Tableau.

# Skills used
## SQL
- Basic SQL commands (SELECT, FROM, WHERE, GROUP BY, etc.)
- Aggregate Functions( AVG(), MIN(), MAX(), COUNT(), SUM())
- Joins (INNER JOIN, LEFT JOIN, RIGHT JOIN)
- Nested quries using sub quries, temp tables and CTE's
- Creating views and stored procedures
- Converting data types

## Tableau
- Create dashboard 
- Visualize data using a world map
- Summerize data using charts and graphs

The Tableau dashboard for this project can be viewed at this [link](https://public.tableau.com/app/profile/musab.naik/viz/CovidDashboard_16482448758450/Dashboard1).

# Data 
The COVID-19 dataset used in this project is maintained by [Our World in Data](https://ourworldindata.org/coronavirus), and includes the following data:

| Metrics                     | Source                                                    | Updated | Countries |
|-----------------------------|-----------------------------------------------------------|---------|-----------|
| Vaccinations                | Official data collated by the Our World in Data team      | Daily   | 218       |
| Tests & positivity          | Official data collated by the Our World in Data team      | Weekly  | 173       |
| Hospital & ICU              | Official data collated by the Our World in Data team      | Daily   | 47        |
| Confirmed cases             | JHU CSSE COVID-19 Data                                    | Daily   | 216        |
| Confirmed deaths            | JHU CSSE COVID-19 Data                                    | Daily   | 216       |
| Reproduction rate           | Arroyo-Marioli F, Bullano F, Kucinskas S, Rondón-Moreno C | Daily   | 190        |
| Policy responses            | Oxford COVID-19 Government Response Tracker               | Daily   | 186        |
| Other variables of interest | International organizations (UN, World Bank, OECD, IHME…) | Fixed   | 241       |

The data, as downloaded on 03/24/2022, is a single CSV file, and has 67 columns and 170654 rows. To demonstrate joins in SQL, the data has been manually seprated into two CSV files, [CovidDeaths.csv](https://github.com/MusabNaik/COVID-19-data---Exploration-and-Visualizing/blob/main/CovidDeaths.csv.zip) and [CovidVaccinations.csv](https://github.com/MusabNaik/COVID-19-data---Exploration-and-Visualizing/blob/main/CovidVaccinations.csv.zip).

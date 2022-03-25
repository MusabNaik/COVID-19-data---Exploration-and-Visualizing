/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

SELECT *
FROM COVID19..CovidDeaths
WHERE continent NOT LIKE ''
ORDER BY 3,4



-- Select Data that we are going to be starting with

SELECT location, CAST(date AS DATE) AS date, total_cases, new_cases, total_deaths, population
FROM COVID19..CovidDeaths
WHERE continent NOT LIKE '' 
ORDER BY 1,2



-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

SELECT location, CAST(date AS DATE) AS date, total_cases,total_deaths, 
	(CAST(total_deaths AS FLOAT)/CAST(total_cases AS FLOAT))*100 AS DeathPercentage
FROM COVID19..CovidDeaths
WHERE location LIKE '%states%'
AND continent NOT LIKE '' 
ORDER BY 1,2



-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

SELECT location, CAST(date AS DATE) AS date, population, total_cases, 
	(CAST(total_cases AS FLOAT)/NULLIF (CAST(population AS FLOAT),0))*100 AS PercentPopulationInfected
FROM COVID19..CovidDeaths
--Where location like '%states%'
ORDER BY 1,2



-- Countries with Highest Infection Rate compared to Population

SELECT location, population, 
--	CAST(date as DATE)AS date,
	MAX(CAST(total_cases AS INT)) AS HighestInfectionCount, 
	Max((CAST(total_cases AS FLOAT)/NULLIF (CAST(population AS FLOAT),0)))*100 AS PercentPopulationInfected
FROM COVID19..CovidDeaths
GROUP BY location, population--, date
ORDER BY PercentPopulationInfected DESC



-- Countries with Highest Death Count per Population

SELECT location, MAX(cast(total_deaths AS INT)) AS TotalDeathCount
FROM COVID19..CovidDeaths
WHERE continent NOT LIKE ''
GROUP BY location
ORDER BY TotalDeathCount DESC



-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

SELECT continent, MAX(cast(total_deaths AS INT)) AS TotalDeathCount
FROM COVID19..CovidDeaths
WHERE continent NOT LIKE ''
GROUP BY continent
ORDER BY TotalDeathCount DESC



-- GLOBAL NUMBERS

SELECT SUM(CAST(new_cases AS INT)) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, 
	SUM(CAST(new_deaths AS FLOAT))/SUM( CAST(New_Cases AS FLOAT))*100 AS DeathPercentage
FROM COVID19..CovidDeaths
WHERE continent NOT LIKE ''
--Group By date
order by 1,2



-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

SELECT dea.continent, dea.location, CAST(dea.date AS DATE) AS date, dea.population, vac.new_vaccinations,
	SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, CAST(dea.Date AS DATE)) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From COVID19..CovidDeaths dea
JOIN COVID19..CovidVaccinations vac
	On dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent NOT LIKE ''
ORDER BY 2,3



-- Using CTE to perform Calculation on Partition By in previous query

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, CAST(dea.date AS DATE), dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.Location Order by dea.location, CAST(dea.Date AS DATE)) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM COVID19..CovidDeaths dea
JOIN COVID19..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent NOT LIKE '' 
--ORDER by 2,3
)
SELECT *, (RollingPeopleVaccinated/NULLIF(Population,0))*100
FROM PopvsVac



-- Using Temp Table to perform Calculation on Partition By in previous query

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent NVARCHAR(255),
Location NVARCHAR(255),
Date DATETIME,
Population BIGINT,
New_vaccinations BIGINT,
RollingPeopleVaccinated BIGINT
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, CAST(dea.date AS DATE), CAST(dea.population AS BIGINT), CAST(vac.new_vaccinations AS BIGINT)
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, CAST(dea.Date AS DATE)) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM COVID19..CovidDeaths dea
JOIN COVID19..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
--WHERE dea.continent NOT LIKE ''
ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated/NULLIF(Population,0))*100
FROM #PercentPopulationVaccinated



-- Creating View to store data for later visualizations

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, CAST(dea.date AS DATE) AS date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, CAST(dea.Date AS DATE)) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM COVID19..CovidDeaths dea
JOIN COVID19..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent NOT LIKE ''

SELECT * FROM PercentPopulationVaccinated

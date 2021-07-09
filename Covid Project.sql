--Select *
--From [Portfolio Project].dbo.Covid_Deaths


--Select *
--From [Portfolio Project].dbo.Covid_Vaccinations


--Select data that we will be using
Select continent, Location, date, total_cases, new_cases, total_deaths, population
From [Portfolio Project].dbo.Covid_Deaths
Order by 1

--Looking at Total Cases vs Total Deaths in Singapore
Select continent, Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as [Death Rate (as %)]
From [Portfolio Project].dbo.Covid_Deaths
Where location = 'Singapore'
Order by 1,2

--Looking at Total Cases vs Population in Singapore
--Infection Rate in Singapore
Select continent, Location, date, total_cases, population, (total_cases/population)*100 as [Infection Rate (as %)]
From [Portfolio Project].dbo.Covid_Deaths
Where location = 'Singapore'
Order by 1,2

--Countries with high Infection Rate
Select continent, Location, population, MAX(total_cases) as total_cases, MAX((total_cases/population))*100 as [Infection Rate (as %)]
From [Portfolio Project].dbo.Covid_Deaths
--Where location = 'Singapore'
Where continent is not null
Group By continent, Location, population
Order by 5 desc

--Countries with the Highest Death Count
Select continent, Location, MAX(cast(total_deaths as int)) as total_deaths
From [Portfolio Project].dbo.Covid_Deaths
--Where location = 'Singapore'
Where continent is not null
Group By continent, Location
Order by 3 desc

----Continents with the Highest Death Count
--Select continent, MAX(cast(total_deaths as int)) as total_deaths
--From [Portfolio Project].dbo.Covid_Deaths
----Where location = 'Singapore'
--Where continent is not null
--Group By continent
--Order by 2 desc

--Continents with the Highest Death Count
Select location, MAX(cast(total_deaths as int)) as total_deaths
From [Portfolio Project].dbo.Covid_Deaths
--Where location = 'Singapore'
Where continent is null
Group By location
Order by 2 desc

--Global Numbers by days
Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as [Death Rate (as %)]
From [Portfolio Project].dbo.Covid_Deaths
--Where location = 'Singapore'
Where continent is not null
Group By date
Order by 1,2

--Total Global Numbers
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as [Death Rate (as %)]
From [Portfolio Project].dbo.Covid_Deaths
--Where location = 'Singapore'
Where continent is not null

--Total Population Vaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(Cast(vac.new_vaccinations as int)) Over (Partition by dea.location Order by dea.location, dea.date) as [Total Vaccination Count]
--,([Total Vacination Count]/population) * 100
From [Portfolio Project].dbo.Covid_Deaths as dea
Join [Portfolio Project].dbo.Covid_Vaccinations as vac
On dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
order by 2, 3 

--CTE
--Calculate Vaccination Rate
With PopvsVac (Continent, location, date, population, new_vaccinations, [Total Vaccination Count])
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,Sum(Cast(vac.new_vaccinations as int)) Over (Partition by dea.location Order by dea.location, dea.date) as [Total Vaccination Count]
--,([Total Vacination Count]/population) * 100
From [Portfolio Project].dbo.Covid_Deaths as dea
Join [Portfolio Project].dbo.Covid_Vaccinations as vac
On dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
--order by 2, 3
)
Select *, ([Total Vaccination Count]/population) * 100 as [Vaccination Rate (in %)]
From PopvsVac
order by 2, 3

--Create View to store data for visualization later
Create View Vaccination_Rate as
With PopvsVac (Continent, location, date, population, new_vaccinations, [Total Vaccination Count])
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,Sum(Cast(vac.new_vaccinations as int)) Over (Partition by dea.location Order by dea.location, dea.date) as [Total Vaccination Count]
--,([Total Vacination Count]/population) * 100
From [Portfolio Project].dbo.Covid_Deaths as dea
Join [Portfolio Project].dbo.Covid_Vaccinations as vac
On dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
--order by 2, 3
)
Select *, ([Total Vaccination Count]/population) * 100 as [Vaccination Rate (in %)]
From PopvsVac

Create View vaccination_numbers as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,Sum(Cast(vac.new_vaccinations as int)) Over (Partition by dea.location Order by dea.location, dea.date) as [Total Vaccination Count]
--,([Total Vacination Count]/population) * 100
From [Portfolio Project].dbo.Covid_Deaths as dea
Join [Portfolio Project].dbo.Covid_Vaccinations as vac
On dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
--order by 2, 3

Select *
From Vaccination_Rate

Select *
From vaccination_numbers
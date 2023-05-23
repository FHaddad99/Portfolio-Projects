Select *
From PortfolioProject..[Updated Covid-19 deaths]
where continent is not null
Order by 3,4

Select *
From PortfolioProject..[covid vaccinations]
Order by 3,4

Select continent, Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..[Updated Covid-19 deaths]
where continent is not null
order by 1,2

--Looking at Total Cases vs Total Deaths 
--Showcases likelihood of dying if you contract covid in your country

Select continent, Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..[Updated Covid-19 deaths]
where continent is not null
order by 1,2

--Looking at Total Cases vs Population
--Showcases what percentage of population got Covid

Select continent, Location, date, total_cases, population, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..[Updated Covid-19 deaths]
order by 1,2

--Looking at countries with highest Infection Rate compared to population

Select continent, Location, Population, MAX(total_cases) as HighestInfectionCount, Max(total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..[Updated Covid-19 deaths]
Group by Location, Population
order by PercentPopulationInfected desc

--Showing Countries with Highest Death Count per Population
Select continent, Location, MAX(Total_deaths) as TotalDeathCount
From PortfolioProject..[Updated Covid-19 deaths]
where continent is not null
Group by Location
order by TotalDeathCount desc

-- Highest Death Count by Continent per poulation
Select continent, MAX(Total_deaths) as TotalDeathCount
From PortfolioProject..[Updated Covid-19 deaths]
where continent is not null
Group by continent
order by TotalDeathCount desc

Select location, MAX(Total_deaths) as TotalDeathCount
From PortfolioProject..[Updated Covid-19 deaths]
where continent is null
Group by location
order by TotalDeathCount desc

--Global Numbers

Select date, SUM(new_cases), SUM(new_deaths) -- (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..[Updated Covid-19 deaths]
where continent is not null
group by date
order by 1,2

SELECT date, 
       SUM(new_cases) as total_cases, 
       SUM(new_deaths) as total_deaths, 
       SUM(new_deaths) / NULLIF(SUM(new_cases), 0) * 100 AS DeathPercentage
FROM PortfolioProject..[Updated Covid-19 deaths]
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date, SUM(new_cases)

SELECT SUM(new_cases) as total_cases, 
       SUM(new_deaths) as total_deaths, 
       SUM(new_deaths) / NULLIF(SUM(new_cases), 0) * 100 AS DeathPercentage
FROM PortfolioProject..[Updated Covid-19 deaths]
WHERE continent IS NOT NULL
order by 1,2

Select *
From PortfolioProject..[covid vaccinations]


--Looking at Total Population vs Vaccinations

Select *
From PortfolioProject..[Updated Covid-19 deaths] dea
Join PortfolioProject..[covid vaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject..[Updated Covid-19 deaths] dea
Join PortfolioProject..[covid vaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
Order by 2,3


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location,
	dea.Date) as RollingPeopleVaccinated
From PortfolioProject..[Updated Covid-19 deaths] dea
Join PortfolioProject..[covid vaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
Order by 2,3

-- Use CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location,
	dea.Date) as RollingPeopleVaccinated
From PortfolioProject..[Updated Covid-19 deaths] dea
Join PortfolioProject..[covid vaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
Select *
From PopvsVac

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location,
	dea.Date) as RollingPeopleVaccinated
From PortfolioProject..[Updated Covid-19 deaths] dea
Join PortfolioProject..[covid vaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location,
	dea.Date) as RollingPeopleVaccinated
From PortfolioProject..[Updated Covid-19 deaths] dea
Join PortfolioProject..[covid vaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
Order by 2,3


-- Temp Table

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(50),
Location nvarchar(50),
Date datetime,
Population varchar(max),
New_Vaccinations bigint,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location,
	dea.Date) as RollingPeopleVaccinated
From PortfolioProject..[Updated Covid-19 deaths] dea
Join PortfolioProject..[covid vaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

-- Creating View to store data for later vizualizations

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location,
	dea.Date) as RollingPeopleVaccinated
From PortfolioProject..[Updated Covid-19 deaths] dea
Join PortfolioProject..[covid vaccinations] vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL

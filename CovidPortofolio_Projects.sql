use portofolioproject;

select * from coviddeath
order by 3,4;

select * from vaccination
order by 3,4;

-- selecting data that we are going to be use

select location, date, total_cases, new_cases, total_deaths ,population
from coviddeath
order by 2,3;

-- Looking for Total_cases vs Total_deaths

select location, date, total_cases, total_deaths,
(total_deaths/total_cases)*100 as DeathPercentage
from coviddeath
where location like '%Afghanistan%'
order by 1,2;

-- Looking at total_cases vs population

select location, date, population, total_cases, 
(total_cases/population)*100 as CasesPercentage
from coviddeath
-- where location like '%Afghanistan%'
order by 1,2;

-- looking for countries with the highest infection

select location,  population, MAX(total_cases), 
MAX(total_cases/population)*100 as PopulationPercentageInfected
from coviddeath
-- where location like '%Afghanistan%'
group by location,  population
order by  PopulationPercentageInfected desc;

-- countries with highest death counts per population 

select location, MAX(total_deaths) as TotalCovidDeath
from coviddeath
-- where location like '%Afghanistan%'
where  continent is not null
group by location
order by  TotalCovidDeath desc;


-- breaking  down things by continent

select location,continent, MAX(total_deaths) as TotalCovidDeath
from coviddeath
-- where location like '%Afghanistan%'
where  continent is not null
group by location, continent
order by  TotalCovidDeath desc; 


-- showing the continents with the highest death count per population


select location,continent, MAX(total_deaths) as TotalCovidDeath
from coviddeath
-- where location like '%Afghanistan%'
where  continent is not null
group by location, continent
order by  TotalCovidDeath desc;  


-- global numbers

select  date,  sum(new_cases) as cases, sum(new_deaths) as deaths , sum(new_deaths)/sum(new_cases)*100 as DeathPercentage
from coviddeath
where continent is not null
group by date,new_deaths
order by 1,2;

--  joining two tables

select dea.location,dea.continent, dea.date, dea.population, vac.new_vaccinations
,sum(vac.new_vaccinations) over (partition by dea.location) as RollingPeopleVaccinated
from portofolioproject.coviddeath dea
join portofolioproject.vaccination vac
on dea.date= vac.date
and dea.location= vac.location
where dea.continent is not null
order by 2,3;

-- use CTE

with PopuVsVacc (date, location, continent, population , new_vaccinations, RollingPeopleVaccinated) 
as( select dea.location,dea.continent, dea.date, dea.population, vac.new_vaccinations
,sum(vac.new_vaccinations) over (partition by dea.location) as RollingPeopleVaccinated
from portofolioproject.coviddeath dea
join portofolioproject.vaccination vac
on dea.date= vac.date
and dea.location= vac.location
where dea.continent is not null
-- order by 2,3
) 

select*,(RollingPeopleVaccinated/population)*100
from PopuVsVacc;


-- TEMP TABLE 
drop table PercentPopVaccinated;
drop table PercentPopulationVaccinated;
create temporary table PercentPopulationVaccinated
(
Continent varchar(255),
Location varchar(255),
Date char(20) NOT NULL ,
Population numeric,
New_vaccination numeric,
RollingPeopleVaccinated numeric
);

insert into PercentPopulationVaccinated
select dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations
,sum(vac.new_vaccinations) over (partition by dea.location) as RollingPeopleVaccinated
from portofolioproject.coviddeath dea
join portofolioproject.vaccination vac
on dea.date= vac.date
and dea.location= vac.location;
-- where dea.continent is not null;
-- order by 2,3

select*, (RollingPeopleVaccinated/population)*100
from PercentPopulationVaccinated;

-- creating view to store data for later visualization
drop view PercentPopvaccinated;
create view PercentPopvaccinated as 
select dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations
,sum(vac.new_vaccinations) over (partition by dea.location) as RollingPeopleVaccinated
from portofolioproject.coviddeath dea
join portofolioproject.vaccination vac
on dea.date= vac.date
and dea.location= vac.location
where dea.continent is not null;


select * from PercentPopvaccinated;


 
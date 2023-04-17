/****** Script dos comandos SQL ******/
SELECT *  FROM [Projeto_SQL_Covid].[dbo].[Covid_Mortes] -- Total de 301.251 linhas

-- ALTER TABLE [Covid_Mortes]
-- ALTER COLUMN [data] date; 

-- ALTER TABLE [Covid_Mortes]
-- ALTER COLUMN [total_casos] float; 

-- ALTER TABLE [Covid_Mortes]
-- ALTER COLUMN [mortes_totais] float; 


-- ChatGPT: 1.	Quantos casos confirmados de COVID-19 foram relatados em uma determinada regi�o ou pa�s?

-- SELECT DISTINCT([continente]) FROM [Projeto_SQL_Covid].[dbo].[Covid_Mortes] -- 6 Continentes

SELECT [continente], count([total_casos]) as 'casos confirmados' FROM [Projeto_SQL_Covid].[dbo].[Covid_Mortes]
WHERE [continente] IS NOT NULL 
GROUP BY [continente]
ORDER BY [continente]

-- ChatGPT: 2.	Qual � a taxa atual de mortalidade por COVID-19 em uma determinada regi�o ou pa�s?

SELECT [data], [total_casos],[mortes_totais], ROUND(([mortes_totais]/[total_casos])*100,4) as Porcentagem_mortes
FROM [Projeto_SQL_Covid].[dbo].[Covid_Mortes]
WHERE [localizacao] like '%Brazil%' and [continente] is not null 
ORDER BY [data] DESC 

-- ChatGPT: 3.	Qual � a tend�ncia de novos casos de COVID-19 ao longo do tempo em uma determinada regi�o ou pa�s?
-- ChatGPT: 4.	Qual � a distribui��o et�ria dos casos confirmados de COVID-19 em uma determinada regi�o ou pa�s? Esse banco de dados n�o possui informa��o dos contaminados 
-- ChatGPT: 5.	Qual � a distribui��o de g�nero dos casos confirmados de COVID-19 em uma determinada regi�o ou pa�s? Esse banco de dados n�o possui informa��o dos contaminados
-- ChatGPT: 6.	Qual � a rela��o entre os casos de COVID-19 e a densidade populacional em uma determinada regi�o ou pa�s? 

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
order by 1,2

-- ChatGPT: 7.	Qual � a taxa de hospitaliza��o e interna��es em UTI devido ao COVID-19 em uma determinada regi�o ou pa�s?
-- ChatGPT: 8.	Quantas pessoas foram vacinadas contra a COVID-19 em uma determinada regi�o ou pa�s?
-- ChatGPT: 9.	Qual � a efic�cia das diferentes vacinas COVID-19 na preven��o de infec��es ou doen�as graves?
-- ChatGPT: 10.	Quais s�o as comorbidades comuns ou condi��es de sa�de subjacentes em pessoas que morreram de COVID-19?

-- Pa�ses com maior taxa de infec��o em compara��o com a popula��o

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- Pa�ses com maior n�mero de mortes por popula��o

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc

-- Mostrando continentes com a maior contagem de mortes por popula��o

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc



-- N�MEROS GLOBAIS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2



-- Popula��o Total vs Vacina��es
-- Mostra a porcentagem da popula��o que recebeu pelo menos uma vacina contra a Covid

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- Usando CTE para executar o c�lculo na parti��o por na consulta anterior

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



-- Usando a tabela tempor�ria para executar o c�lculo na parti��o por na consulta anterior

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




-- Criando View para armazenar dados para visualiza��es posteriores

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
/****** Script dos comandos SQL ******/
SELECT *  FROM [Projeto_SQL_Covid].[dbo].[Covid_Mortes] -- Total de 301.251 linhas

-- ALTER TABLE [Covid_Mortes]
-- ALTER COLUMN [data] date; 

-- ALTER TABLE [Covid_Mortes]
-- ALTER COLUMN [total_casos] float; 

-- ALTER TABLE [Covid_Mortes]
-- ALTER COLUMN [mortes_totais] float; 


-- ChatGPT: 1.	Quantos casos confirmados de COVID-19 foram relatados em uma determinada região ou país?

-- SELECT DISTINCT([continente]) FROM [Projeto_SQL_Covid].[dbo].[Covid_Mortes] -- 6 Continentes

SELECT [continente], count([total_casos]) as 'casos confirmados' FROM [Projeto_SQL_Covid].[dbo].[Covid_Mortes]
WHERE [continente] IS NOT NULL 
GROUP BY [continente]
ORDER BY [continente]

-- ChatGPT: 2.	Qual é a taxa atual de mortalidade por COVID-19 em uma determinada região ou país?

SELECT [data], [total_casos],[mortes_totais], ROUND(([mortes_totais]/[total_casos])*100,4) as Porcentagem_mortes
FROM [Projeto_SQL_Covid].[dbo].[Covid_Mortes]
WHERE [localizacao] like '%Brazil%' and [continente] is not null 
ORDER BY [data] DESC 

-- ChatGPT: 3.	Qual é a tendência de novos casos de COVID-19 ao longo do tempo em uma determinada região ou país?
-- ChatGPT: 4.	Qual é a distribuição etária dos casos confirmados de COVID-19 em uma determinada região ou país? Esse banco de dados não possui informação dos contaminados 
-- ChatGPT: 5.	Qual é a distribuição de gênero dos casos confirmados de COVID-19 em uma determinada região ou país? Esse banco de dados não possui informação dos contaminados
-- ChatGPT: 6.	Qual é a relação entre os casos de COVID-19 e a densidade populacional em uma determinada região ou país? 

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
order by 1,2

-- ChatGPT: 7.	Qual é a taxa de hospitalização e internações em UTI devido ao COVID-19 em uma determinada região ou país?
-- ChatGPT: 8.	Quantas pessoas foram vacinadas contra a COVID-19 em uma determinada região ou país?
-- ChatGPT: 9.	Qual é a eficácia das diferentes vacinas COVID-19 na prevenção de infecções ou doenças graves?
-- ChatGPT: 10.	Quais são as comorbidades comuns ou condições de saúde subjacentes em pessoas que morreram de COVID-19?

-- Países com maior taxa de infecção em comparação com a população

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- Países com maior número de mortes por população

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc

-- Mostrando continentes com a maior contagem de mortes por população

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc



-- NÚMEROS GLOBAIS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2



-- População Total vs Vacinações
-- Mostra a porcentagem da população que recebeu pelo menos uma vacina contra a Covid

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- Usando CTE para executar o cálculo na partição por na consulta anterior

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



-- Usando a tabela temporária para executar o cálculo na partição por na consulta anterior

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




-- Criando View para armazenar dados para visualizações posteriores

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
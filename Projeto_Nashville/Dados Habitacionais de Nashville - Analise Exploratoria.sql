-- Realização de análise exploratória de dados

SELECT COUNT([ID_unico]) as NumTotalPropriedades FROM [Projeto_SQL_Nashville].[dbo].[Nashville] -- Resultado: 56373 propriedades 

SELECT 
	[Divisao_endereco_da_cidade] as Cidade, 
	CAST(COUNT([Divisao_endereco_da_cidade]) AS FLOAT) as Imoveis,
	ROUND(((CAST(COUNT([Divisao_endereco_da_cidade]) AS FLOAT) / 56373) * 100), 4) as Porcentagem
FROM [Projeto_SQL_Nashville].[dbo].[Nashville]
GROUP BY ([Divisao_endereco_da_cidade])
ORDER BY COUNT([Divisao_endereco_da_cidade]) desc 

-- Resultado: 13 cidades distintas
-- Sendo as 5 primeiras: 
-- 1) Nashville com 71,3391% 
-- 2) Antioch com 11,1507%
-- 3) Hermitage com 5,5452%
-- 4) Madison com 3,75%
-- 5) Brentwood com 3,0085%

SELECT 
	[Uso_da_terra],
	ROUND(AVG([Preco_de_venda]),2) as Preco_medio, 
	COUNT([ID_unico]) as Unidades,
	ROUND(ROUND(AVG([Preco_de_venda]),2) / COUNT([ID_unico]),2) as Preco_unidade
FROM [Projeto_SQL_Nashville].[dbo].[Nashville]
GROUP BY [Uso_da_terra]
ORDER BY Preco_medio DESC
-- Agrupamentos por [Uso_da_terra] 

SELECT ROUND(AVG([Preco_de_venda]),2) as Preco_medio FROM [Projeto_SQL_Nashville].[dbo].[Nashville] -- Preço médio: 327.523,01, sendo mínimo R$ 12.000 e máximo R$ 3.235.294,12

SELECT [Distrito_fiscal],count([Distrito_fiscal]) as 'Contagem'
FROM [Projeto_SQL_Nashville].[dbo].[Nashville]
WHERE [Distrito_fiscal] IS NOT NULL
GROUP BY [Distrito_fiscal]
ORDER BY 'Contagem' DESC -- Resultado: 56.373 - 25.969 = 30.404 linhas em branco. (53,9336% dos dados nulos). Não é uma variável boa para se analisar

SELECT SUM([Preco_de_venda]) as 'Valor da propriedade'
FROM [Projeto_SQL_Nashville].[dbo].[Nashville]
-- Uau! Total Valor da propriedade chegando a mais de 18 bilhões

select a.[UniqueID ] ,b.[UniqueID ],a.address,b.address from NashvilleHousing a
join NashvilleHousing b
on a.[UniqueID ]=b.[UniqueID ]
where a.[UniqueID ]<>b.[UniqueID ]
and a.address=b.address
-- ok então as propriedades são vendidas apenas uma vez . nenhum foi vendido várias vezes


select TaxDistrict,sum(SalePrice) as PropertyValue,COUNT(uniqueid) as NumberOfProperties
from NashvilleHousing
group by TaxDistrict
order by PropertyValue desc

select TaxDistrict,sum(SalePrice)/COUNT(uniqueid) as AveragePropertyValue
from NashvilleHousing
group by TaxDistrict
order by  AveragePropertyValue desc

drop table if exists #DuplicateWatch
create table #DuplicateWatch
(address varchar(255),uniqueid int,SalePrice int,SaleDateConverted date,LegalReference nvarchar(255),row_num int)

insert into #DuplicateWatch
Select address,[UniqueID ], saleprice,saledateconverted,legalreference,
	ROW_NUMBER() OVER (
	PARTITION BY Address,
				 SalePrice,
				 SaleDateconverted,
				 LegalReference,
				 ParcelID
				 ORDER BY
					UniqueID
					) row_num
From NashvilleHousing

select count(*) from #DuplicateWatch as duplicates
where row_num>1

delete  from #DuplicateWatch
where row_num>1

-- procurou por edifícios duplicados e certificou-se de que eles são os mesmos que têm as mesmas colunas diferentes
--56373 total de 888 duplicatas encontradas e excluídas


select *,
case 
when saledateconverted like '%2013%' then 2013
end as Yearly_Sales 
from NashvilleHousing
order by saledateconverted
-- não há necessidade de pensar em uma maneira melhor

select saledateconverted,LEFT(saledateconverted,4)as saleyear
from NashvilleHousing
group by saledateconverted 
order by saleyear desc

alter table nashvillehousing
add SaleYear int

update NashvilleHousing
set saleyear = LEFT(saledateconverted,4)

select * from NashvilleHousing
-- ok mudança efetuada agora podemos agrupar por ano


select distinct (YearBuilt),COUNT(yearbuilt) Buildings_Built
from NashvilleHousing
group by YearBuilt
order by Buildings_Built desc
-- a maioria dos edifícios construídos em 1930-1960 com 1950 o pico com 1153

with Timeperiods as (
select distinct (YearBuilt),COUNT(yearbuilt) Buildings_Built ,
CASE 
when YearBuilt between 1799 and 1899 then '19th_century' 
when YearBuilt between 1900 and 1999 then '20th_century'
else '21st_century'
end as Timeperiods
from NashvilleHousing
group by YearBuilt
--order by YearBuilt desc
)
select Timeperiods, sum(buildings_built) as Buildings_Built
from Timeperiods 
group by Timeperiods
order by Timeperiods
-- Tempo de pico do século 20 para erguer edifícios de longe

create view BuildingEra as
select distinct (YearBuilt),COUNT(yearbuilt) Buildings_Built ,
CASE 
when YearBuilt between 1799 and 1899 then '19th_century' 
when YearBuilt between 1900 and 1999 then '20th_century'
else '21st_century'
end as Timeperiods
from NashvilleHousing
group by YearBuilt
--order by YearBuilt desc
select * from BuildingEra

select BuildingEra ,COUNT(BuildingEra) as count
from BuildingEra
group by BuildingEra
-- tendo testado na tabela temporária aplicada ao conjunto de dados principal
select * from nashvillehousing
  Buildingera


 update nashvillehousing
 set buildingera =
case 
when YearBuilt between 1799 and 1899 then '19th_century' 
when YearBuilt between 1900 and 1999 then '20th_century'
else '21st_century'
end

select BuildingAge,COUNT(buildingage) as Count
from nashvillehousing
group by BuildingAge

select *
from nashvillehousing

select  BuildingAge,sum(SalePrice) as Total,count(BuildingAge) as Count_Of_Buildings
from NashvilleHousing
group by buildingAge
-- prédios antigos custam mais, mas são os mais distorcidos

select  BuildingAge, avg(SalePrice) as Average_Price,count(BuildingAge) as Count_Of_Buildings
from NashvilleHousing
group by buildingAge
order by Average_Price desc
-- old buildings way way more than new and so avg price distorted

select distinct(ownername),count(ownername) over (partition by ownername) NumberOfPropertiesOwned
from NashvilleHousing
where OwnerName is not null
order by  NumberOfPropertiesOwned desc
-- Proprietários com a maioria das propriedades

select address,bedrooms,SalePrice
from NashvilleHousing
order by SalePrice

select min(saleprice)
from nashvillehousing
-- erro de algum tipo provavelmente todos esses realmente baixos

select distinct(LandUse),COUNT(landuse) over (partition by Landuse) as Count,avg(saleprice) over (partition by Landuse) as Avg_Price
from nashvillehousing
order by Avg_Price desc
-- diferentes tipos de terrenos e seus preços médios
-- bedrooms null value need to sort select distinct(LandUse),COUNT(landuse) over (partition by Landuse) as No_of_Buildings,avg(saleprice) over (partition by Landuse) as Avg_Price,Bedrooms from nashvillehousing order by Avg_Price
-- quartos valor nulo precisa classificar distinto(LandUse),COUNT(landuse) over (partition by Landuse) as No_of_Buildings,avg(saleprice) over (partition by Landuse) as Avg_Price,Bedrooms from nashvillehousing order by Avg_Price  

select ownername,COUNT(ownername),sum(Acreage) as Properties_size
 from NashvilleHousing 
 group by  OwnerName 
order by Properties_size desc
--maiores proprietários

select OwnerName,count(OwnerName) as Properties_owned,sum(Acreage) as Properties_size
from NashvilleHousing
group by  OwnerName 
order by Properties_owned desc

-- aqueles que possuem a maioria das propriedades principalmente corporações, alguns indivíduos também.

with Apartment_type as( 
Select distinct(Bedrooms),case
when Bedrooms=1 then '1 bedroom'
when Bedrooms=2 then '2 bedroom '
when Bedrooms=3 then '3 bedroom '
when Bedrooms=4 then '4 bedroom '
when Bedrooms=5 then '5 bedroom '
when Bedrooms=6 then '6 bedroom '
when Bedrooms=7 then '7	bedroom '
when Bedrooms=8 then '8 bedroom '
when Bedrooms=9 then '9 bedroom '
when Bedrooms=10 then '10 bedroom '
when Bedrooms=11 then '11 bedroom '
end as type,
count(Bedrooms) as spread from NashvilleHousing 
group by  Bedrooms )
select * from Apartment_type
order by Bedrooms asc
-- então 12 tipos de quarto

create view Apartment_type as 
select CONCAT(bedrooms, ' bedroom') as Apartment_type from NashvilleHousing
-- depois de todas aquelas declarações de caso percebi que eu poderia fazer isso
select * from [Apartment_type]

select city, CONCAT(bedrooms, ' bedroom') as Apartment_type, avg(SalePrice)as AvgPrices
from NashvilleHousing
group by city
order by avgPrices


create view PropertyValuations as
select count(*) as Property_Count ,
case when SalePrice > TotalValue then 'Overpaid'
when SalePrice < TotalValue then 'Bargain'
else 'Fair'
end as 'Valuations'
from NashvilleHousing
group by case when SalePrice > TotalValue then 'Overpaid'
when SalePrice < TotalValue then 'Bargain'
else 'Fair' end 
select * from PropertyValuations

select count(uniqueid)as Sales,SaleYear from NashvilleHousing
group by SaleYear
order by sales desc
-- provavelmente dados capturados no início de 2019, pois há apenas 2 vendas


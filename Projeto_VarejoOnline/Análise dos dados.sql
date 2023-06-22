-- Top 20 produtos mais vendidos 
SELECT TOP 20 
	[Description] AS 'Descrição dos produtos',
	ROUND(SUM([Quantity] * [UnitPrice]),2) AS 'Total Vendido' 
FROM [Projeto_SQL_VarejoOnline].[dbo].[Online Retail]
GROUP BY [Description] 
ORDER BY 'Total Vendido' DESC

-- Top 5 produtos mais vendidos em cada país 
SELECT TOP 5 
	[Country] AS 'País',
	ROUND(SUM([Quantity] * [UnitPrice]),2) AS 'Total Vendido'	 
FROM [Projeto_SQL_VarejoOnline].[dbo].[Online Retail]
GROUP BY [Country] 
ORDER BY 'Total Vendido' DESC

--Quantidade média de produtos vendidos para cada país
SELECT 
	[Country] AS 'País', 
	ROUND(AVG([UnitPrice]),2) AS 'Média de produtos vendidos'
FROM [Projeto_SQL_VarejoOnline].[dbo].[Online Retail] 
GROUP BY [Country]
ORDER BY 'Média de produtos vendidos' DESC

-- Quantidade de venda total por mês dos produtos que foram emitidos invoice
SELECT 
	MONTH(CONVERT(DATE, InvoiceDate)) AS 'Mês',
	COUNT(DISTINCT([InvoiceNo])) AS 'Quantidade vendida'	 
FROM [Projeto_SQL_VarejoOnline].[dbo].[Online Retail]
GROUP BY MONTH(CONVERT(DATE, InvoiceDate)) 
ORDER BY 'Mês'
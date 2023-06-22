-- Top 20 produtos mais vendidos 
SELECT TOP 20 
	[Description] AS 'Descri��o dos produtos',
	ROUND(SUM([Quantity] * [UnitPrice]),2) AS 'Total Vendido' 
FROM [Projeto_SQL_VarejoOnline].[dbo].[Online Retail]
GROUP BY [Description] 
ORDER BY 'Total Vendido' DESC

-- Top 5 produtos mais vendidos em cada pa�s 
SELECT TOP 5 
	[Country] AS 'Pa�s',
	ROUND(SUM([Quantity] * [UnitPrice]),2) AS 'Total Vendido'	 
FROM [Projeto_SQL_VarejoOnline].[dbo].[Online Retail]
GROUP BY [Country] 
ORDER BY 'Total Vendido' DESC

--Quantidade m�dia de produtos vendidos para cada pa�s
SELECT 
	[Country] AS 'Pa�s', 
	ROUND(AVG([UnitPrice]),2) AS 'M�dia de produtos vendidos'
FROM [Projeto_SQL_VarejoOnline].[dbo].[Online Retail] 
GROUP BY [Country]
ORDER BY 'M�dia de produtos vendidos' DESC

-- Quantidade de venda total por m�s dos produtos que foram emitidos invoice
SELECT 
	MONTH(CONVERT(DATE, InvoiceDate)) AS 'M�s',
	COUNT(DISTINCT([InvoiceNo])) AS 'Quantidade vendida'	 
FROM [Projeto_SQL_VarejoOnline].[dbo].[Online Retail]
GROUP BY MONTH(CONVERT(DATE, InvoiceDate)) 
ORDER BY 'M�s'
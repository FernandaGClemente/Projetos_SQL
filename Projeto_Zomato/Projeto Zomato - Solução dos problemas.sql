/****** Script dos comandos em SQL ******/

-- 1) Qual é o valor total que cada cliente gastou no Zomato?
SELECT 
	V.[ID_Usuario],
	SUM(P.[Preco]) as Valor_Total
FROM tb_Produto P
INNER JOIN tb_Vendas V
ON P.[ID_Produto] = V.[ID_Produto]
GROUP BY V.[ID_Usuario];

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 2) Quantos dias cada cliente visitou a Zomato?
SELECT 
	[ID_Usuario], 
	COUNT( DISTINCT([Data_Criacao])) Dias 
FROM tb_Vendas
GROUP BY [ID_Usuario];

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 3) Qual foi o primeiro produto comprado por cada cliente?
SELECT [ID_Usuario], [Nome_Produto]	
FROM (SELECT V.[ID_Usuario],V.[ID_Produto], P.[Nome_Produto],
			RANK() OVER (PARTITION BY V.[ID_Usuario] ORDER BY V.[Data_Criacao]) Classificacao 
		FROM tb_Vendas V
		INNER JOIN tb_Produto P
		ON V.ID_Produto = P.ID_Produto) tb 
WHERE Classificacao = 1;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 4) Qual é o item mais comprado do cardápio e quantas vezes ele foi comprado por todos os clientes?

/** SELECT TOP 1 
	[ID_Produto],
	COUNT([ID_Produto]) as Total 
FROM tb_Vendas
GROUP BY [ID_Produto]
ORDER BY Total DESC; **/

SELECT [ID_Usuario], COUNT([ID_Produto]) as Total
FROM tb_Vendas 
WHERE [ID_Produto] = 
	(SELECT TOP 1 [ID_Produto] FROM tb_Vendas GROUP BY [ID_Produto] ORDER BY COUNT([ID_Produto]) DESC)
GROUP BY [ID_Usuario];

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 5) Qual item foi o mais popular para cada cliente?

/** SELECT [ID_Usuario], [ID_Produto], COUNT([ID_Produto]) as TotalPorProduto 
FROM tb_Vendas GROUP BY [ID_Usuario], [ID_Produto]**/

/** SELECT *, 
	RANK() OVER(PARTITION BY [ID_Usuario] ORDER BY TotalPorProduto DESC) Classificacao 
FROM (SELECT [ID_Usuario], [ID_Produto], COUNT([ID_Produto]) TotalPorProduto 
	FROM tb_Vendas GROUP BY [ID_Usuario], [ID_Produto]) tb **/

SELECT [ID_Usuario], [ID_Produto], [TotalPorProduto] FROM
(SELECT *, RANK() OVER(PARTITION BY [ID_Usuario] ORDER BY TotalPorProduto DESC) Classificacao 
FROM (SELECT [ID_Usuario], [ID_Produto], COUNT([ID_Produto]) AS TotalPorProduto FROM tb_Vendas GROUP BY [ID_Usuario], [ID_Produto]) tb_1) tb_2 WHERE Classificacao = 1

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 6) Qual item foi comprado primeiro pelo cliente depois que ele se tornou um membro?

/**SELECT V.[ID_Usuario], V.[Data_Criacao], V.[ID_Produto], UO.[Data_CadastroOuro] FROM tb_Vendas V
INNER JOIN tb_CadastroUsuarioOuro UO
ON V.[ID_Usuario] = UO.[ID_Usuario]
WHERE V.[Data_Criacao] >= UO.[Data_CadastroOuro]**/

/**SELECT tb_1.*, RANK() OVER(PARTITION BY [ID_Usuario] ORDER BY [Data_Criacao]) as Classificacao 
FROM (SELECT V.[ID_Usuario], V.[Data_Criacao], V.[ID_Produto], UO.[Data_CadastroOuro] FROM tb_Vendas V
INNER JOIN tb_CadastroUsuarioOuro UO
ON V.[ID_Usuario] = UO.[ID_Usuario]
WHERE V.[Data_Criacao] >= UO.[Data_CadastroOuro]) tb_1**/  

SELECT [ID_Usuario], [Data_Criacao], [ID_Produto], [Data_CadastroOuro] FROM
(SELECT tb_1.*, RANK() OVER(PARTITION BY [ID_Usuario] ORDER BY [Data_Criacao]) as Classificacao 
FROM (SELECT V.[ID_Usuario], V.[Data_Criacao], V.[ID_Produto], UO.[Data_CadastroOuro] FROM tb_Vendas V
INNER JOIN tb_CadastroUsuarioOuro UO
ON V.[ID_Usuario] = UO.[ID_Usuario]
WHERE V.[Data_Criacao] >= UO.[Data_CadastroOuro]) tb_1) tb_2 
WHERE Classificacao = 1

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 7) Qual item foi comprado pouco antes de o cliente se tornar um membro?
-- Diferença do código anterior: DESC e <=
SELECT [ID_Usuario], [Data_Criacao], [ID_Produto], [Data_CadastroOuro] FROM
(SELECT tb_1.*, RANK() OVER(PARTITION BY [ID_Usuario] ORDER BY [Data_Criacao] DESC) as Classificacao 
FROM (SELECT V.[ID_Usuario], V.[Data_Criacao], V.[ID_Produto], UO.[Data_CadastroOuro] FROM tb_Vendas V
INNER JOIN tb_CadastroUsuarioOuro UO
ON V.[ID_Usuario] = UO.[ID_Usuario]
WHERE V.[Data_Criacao] <= UO.[Data_CadastroOuro]) tb_1) tb_2 
WHERE Classificacao = 1

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 8) Qual o total de pedidos e valor gasto para cada cliente antes de se tornarem um membro Ouro?

/**(SELECT tb_1.*, P.[Preco]
FROM (SELECT V.[ID_Usuario], V.[Data_Criacao], V.[ID_Produto], UO.[Data_CadastroOuro] FROM tb_Vendas V
INNER JOIN tb_CadastroUsuarioOuro UO
ON V.[ID_Usuario] = UO.[ID_Usuario]
WHERE V.[Data_Criacao] <= UO.[Data_CadastroOuro]) tb_1
INNER JOIN tb_Produto P
ON tb_1.ID_Produto = P.ID_Produto)**/  

SELECT [ID_Usuario], COUNT([Data_Criacao]) AS Total_Pedidos, SUM([Preco]) AS Valor_Gasto FROM
(SELECT tb_1.*, P.[Preco]
FROM (SELECT V.[ID_Usuario], V.[Data_Criacao], V.[ID_Produto], UO.[Data_CadastroOuro] FROM tb_Vendas V
INNER JOIN tb_CadastroUsuarioOuro UO
ON V.[ID_Usuario] = UO.[ID_Usuario]
WHERE V.[Data_Criacao] <= UO.[Data_CadastroOuro]) tb_1
INNER JOIN tb_Produto P
ON tb_1.ID_Produto = P.ID_Produto) tb_2
GROUP BY [ID_Usuario];

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 9) Se a compra de cada produto gera-se pontos (cashback) para, por exemplo, R$ 5,00 = 2 pontos (ou seja, R$ 1 = 2,5 pontos) e cada produto tivesse diferentes pontos de compra conforme abaixo: 
-- p1 - R$ 5,00 = 1 ponto, ou seja, R$ 1 = 5 pontos   
-- p2 - R$ 10,00 = 5 pontos, ou seja, R$ 1 = 2 pontos   
-- p3 - R$ 5,00 = 1 ponto, ou seja, R$ 1 = 5 pontos 
-- Calcule os pontos coletados por cada cliente e para qual produto a maioria dos pontos foi dada até agora.

-- a) Calcule os pontos coletados por cada cliente

/**SELECT V.*, P.[Preco]
FROM tb_Vendas V
INNER JOIN tb_Produto P
ON V.[ID_Produto] = P.[ID_Produto]**/  

/**SELECT [ID_Usuario], [ID_Produto], SUM([Preco]) Preco_Acumulado FROM
(SELECT V.*, P.[Preco]
FROM tb_Vendas V
INNER JOIN tb_Produto P
ON V.[ID_Produto] = P.[ID_Produto]) tb_1
GROUP BY [ID_Usuario], [ID_Produto];**/

/**SELECT 
	tb_2.*, 
	(CASE
		WHEN [ID_Produto] = 1 THEN 5
		WHEN [ID_Produto] = 2 THEN 2
		WHEN [ID_Produto] = 3 THEN 5
		ELSE 0
	END) AS Pontos
FROM
(SELECT [ID_Usuario], [ID_Produto], SUM([Preco]) Preco_Acumulado FROM
(SELECT V.*, P.[Preco]
FROM tb_Vendas V
INNER JOIN tb_Produto P
ON V.[ID_Produto] = P.[ID_Produto]) tb_1
GROUP BY [ID_Usuario], [ID_Produto]) tb_2;**/

/**SELECT tb_3.*, Preco_Acumulado/Pontos As Pontos_Acumulados FROM
(SELECT 
	tb_2.*, 
	(CASE
		WHEN [ID_Produto] = 1 THEN 5
		WHEN [ID_Produto] = 2 THEN 2
		WHEN [ID_Produto] = 3 THEN 5
		ELSE 0
	END) AS Pontos
FROM
(SELECT [ID_Usuario], [ID_Produto], SUM([Preco]) Preco_Acumulado FROM
(SELECT V.*, P.[Preco]
FROM tb_Vendas V
INNER JOIN tb_Produto P
ON V.[ID_Produto] = P.[ID_Produto]) tb_1
GROUP BY [ID_Usuario], [ID_Produto]) tb_2) tb_3;**/

SELECT [ID_Usuario], SUM([Pontos_Acumulados])*2.5 AS Total_Pontos_Ganhos_PorCliente FROM
(SELECT tb_3.*, Preco_Acumulado/Pontos As Pontos_Acumulados FROM
(SELECT 
	tb_2.*, 
	(CASE
		WHEN [ID_Produto] = 1 THEN 5
		WHEN [ID_Produto] = 2 THEN 2
		WHEN [ID_Produto] = 3 THEN 5
		ELSE 0
	END) AS Pontos
FROM
(SELECT [ID_Usuario], [ID_Produto], SUM([Preco]) Preco_Acumulado FROM
(SELECT V.*, P.[Preco]
FROM tb_Vendas V
INNER JOIN tb_Produto P
ON V.[ID_Produto] = P.[ID_Produto]) tb_1
GROUP BY [ID_Usuario], [ID_Produto]) tb_2) tb_3) tb_4
GROUP BY [ID_Usuario];

-- b) Qual produto a maioria dos pontos foi dada

/**SELECT *, RANK() OVER(ORDER BY Total_Pontos_Ganhos_PorProduto DESC) AS Classificacao FROM
(SELECT [ID_Produto], SUM([Pontos_Acumulados]) AS Total_Pontos_Ganhos_PorProduto FROM -- Alterado para ID Produto e retirado a multiplicação por 2,5
(SELECT tb_3.*, Preco_Acumulado/Pontos As Pontos_Acumulados FROM
(SELECT 
	tb_2.*, 
	(CASE
		WHEN [ID_Produto] = 1 THEN 5
		WHEN [ID_Produto] = 2 THEN 2
		WHEN [ID_Produto] = 3 THEN 5
		ELSE 0
	END) AS Pontos
FROM
(SELECT [ID_Usuario], [ID_Produto], SUM([Preco]) Preco_Acumulado FROM
(SELECT V.*, P.[Preco]
FROM tb_Vendas V
INNER JOIN tb_Produto P
ON V.[ID_Produto] = P.[ID_Produto]) tb_1
GROUP BY [ID_Usuario], [ID_Produto]) tb_2) tb_3) tb_4
GROUP BY [ID_Produto]) tb_5; -- Alterado para ID produto**/

SELECT [ID_Produto], [Total_Pontos_Ganhos_PorProduto] FROM
(SELECT *, RANK() OVER(ORDER BY Total_Pontos_Ganhos_PorProduto DESC) AS Classificacao FROM
(SELECT [ID_Produto], SUM([Pontos_Acumulados]) AS Total_Pontos_Ganhos_PorProduto FROM -- Alterado para ID Produto e retirado a multiplicação por 2,5
(SELECT tb_3.*, Preco_Acumulado/Pontos As Pontos_Acumulados FROM
(SELECT 
	tb_2.*, 
	(CASE
		WHEN [ID_Produto] = 1 THEN 5
		WHEN [ID_Produto] = 2 THEN 2
		WHEN [ID_Produto] = 3 THEN 5
		ELSE 0
	END) AS Pontos
FROM
(SELECT [ID_Usuario], [ID_Produto], SUM([Preco]) Preco_Acumulado FROM
(SELECT V.*, P.[Preco]
FROM tb_Vendas V
INNER JOIN tb_Produto P
ON V.[ID_Produto] = P.[ID_Produto]) tb_1
GROUP BY [ID_Usuario], [ID_Produto]) tb_2) tb_3) tb_4
GROUP BY [ID_Produto]) tb_5) tb_6 -- Alterado para ID produto
WHERE Classificacao = 1; 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 10) No primeiro ano após o cliente ingressar no programa ouro (incluindo a data de adesão), independentemente do que o cliente comprou, ele ganha 5 pontos de cashback para cada R$ 10 gastos (Ou seja, R$1,00 = 2 pontos) quem ganhou mais 1 ou 3 e qual foi o ganho de pontos em seu primeiro ano?

/**SELECT V.[ID_Usuario], V.[Data_Criacao], V.[ID_Produto], UO.[Data_CadastroOuro] FROM tb_Vendas V
INNER JOIN tb_CadastroUsuarioOuro UO
ON V.[ID_Usuario] = UO.[ID_Usuario]
WHERE V.[Data_Criacao] >= UO.[Data_CadastroOuro] AND V.[Data_Criacao] <= DATEADD(YEAR, 1, UO.[Data_CadastroOuro]); -- Acrescentando mais 1 ano**/

SELECT tb_1.*,P.[Preco], P.[Preco]/2. AS Total_Pontos_Ganhos FROM 
(SELECT V.[ID_Usuario], V.[Data_Criacao], V.[ID_Produto], UO.[Data_CadastroOuro] FROM tb_Vendas V
INNER JOIN tb_CadastroUsuarioOuro UO
ON V.[ID_Usuario] = UO.[ID_Usuario]
WHERE V.[Data_Criacao] >= UO.[Data_CadastroOuro] AND V.[Data_Criacao] <= DATEADD(YEAR, 1, UO.[Data_CadastroOuro]))tb_1 -- Acrescentando mais 1 ano
INNER JOIN tb_Produto P
ON tb_1.[ID_Produto] = P.[ID_Produto];

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 11) Classificar todas as transações dos clientes
SELECT *, RANK() OVER(PARTITION BY [ID_Usuario] ORDER BY [Data_Criacao]) Classificacao FROM tb_Vendas;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 12) Classifique todas as transações para cada membro sempre que eles forem um membro ouro do Zomato e para cada marca de transação não membro ouro como n/a

/**SELECT V.[ID_Usuario], V.[Data_Criacao], V.[ID_Produto], UO.[Data_CadastroOuro] FROM tb_Vendas V
LEFT JOIN tb_CadastroUsuarioOuro UO -- Alterado para LEFT pois queremos a informação de todos os membros
ON V.[ID_Usuario] = UO.[ID_Usuario] AND V.[Data_Criacao] >= UO.[Data_CadastroOuro]; -- Retirado WHERE e incluido AND**/

/**SELECT tb_1.*, RANK() OVER(PARTITION BY [ID_Usuario] ORDER BY [Data_Criacao] DESC) Classificacao 
FROM (SELECT V.[ID_Usuario], V.[Data_Criacao], V.[ID_Produto], UO.[Data_CadastroOuro] FROM tb_Vendas V
LEFT JOIN tb_CadastroUsuarioOuro UO 
ON V.[ID_Usuario] = UO.[ID_Usuario] AND V.[Data_Criacao] >= UO.[Data_CadastroOuro]) tb_1;**/

/**SELECT 
	tb_1.*, 
	(CASE
		WHEN [Data_CadastroOuro] IS NULL THEN 0
		ELSE RANK() OVER(PARTITION BY [ID_Usuario] ORDER BY [Data_Criacao] DESC)
	END) AS Classificacao 
	--RANK() OVER(PARTITION BY [ID_Usuario] ORDER BY [Data_Criacao] DESC) Classificacao 
FROM (SELECT V.[ID_Usuario], V.[Data_Criacao], V.[ID_Produto], UO.[Data_CadastroOuro] FROM tb_Vendas V
LEFT JOIN tb_CadastroUsuarioOuro UO 
ON V.[ID_Usuario] = UO.[ID_Usuario] AND V.[Data_Criacao] >= UO.[Data_CadastroOuro]) tb_1;**/

SELECT tb_2.[ID_Usuario], 
	(CASE WHEN Classificacao=0 THEN 'N/A' ELSE Classificacao END) AS Reclassificacao 
FROM
(SELECT tb_1.*, 
	CAST((CASE WHEN [Data_CadastroOuro] IS NULL THEN 0 ELSE RANK() OVER(PARTITION BY [ID_Usuario] ORDER BY [Data_Criacao] DESC) END) AS VARCHAR) AS Classificacao 
FROM (SELECT V.[ID_Usuario], V.[Data_Criacao], V.[ID_Produto], UO.[Data_CadastroOuro] FROM tb_Vendas V
LEFT JOIN tb_CadastroUsuarioOuro UO 
ON V.[ID_Usuario] = UO.[ID_Usuario] AND V.[Data_Criacao] >= UO.[Data_CadastroOuro]) tb_1) tb_2;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/****** Script dos comandos em SQL  ******/

SELECT [IdIngrediantes],[NomeDoIngredientes] FROM [tb_Ingredientes]
SELECT [IdMotorista],[DataDeRegistro] FROM [tb_Motorista]
SELECT [IdPedido],[IdMotorista],[HorarioDaColeta],[Distancia],[Duracao],[Cancelamento] FROM tb_OrdemDoMotorista
SELECT [IdPedido],[IdCliente],[IdRolls],[ItensExtrasNaoIncluidos],[ItensExtrasIncluidos],[DataDoPedido] FROM tb_PedidosDoClientes
SELECT [IdRolls],[Ingredientes] FROM [tb_ReceitaDeRolls]
SELECT [IdRolls],[NomeRolls] FROM [tb_Rolls]

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 1) Quantos Rolls foram pedidos? >> Resultado: 14 

SELECT 
	COUNT([IdRolls]) AS 'Quantidade de Pedidos' 
FROM tb_PedidosDoClientes; 

-- 2) Quantos pedidos únicos de clientes foram feitos? >> Resultado: 5

SELECT 
	COUNT(DISTINCT [IdCliente]) AS 'Quantidade de Pedidos Únicos' 
FROM tb_PedidosDoClientes; 

-- 3) Quantos pedidos bem-sucedidos foram entregues por cada motorista?

SELECT 
	[IdMotorista], 
	COUNT(DISTINCT[IdPedido]) AS 'Pedidos entregues'
FROM tb_OrdemDoMotorista 
WHERE [Cancelamento] NOT IN ('Cancellation','Customer Cancellation')
GROUP BY [IdMotorista];

-- 4) Quantos Rolls de cada tipo foram entregues? 
-- a) Criação de uma coluna do StatusDoCancelamento

SELECT 
	[IdRolls], 
	COUNT([IdRolls]) AS 'Rolls entregues' 
FROM tb_PedidosDoClientes 
WHERE [IdPedido] IN ( 
					SELECT 
						[IdPedido] 
					FROM( 
						SELECT  
							*, 
							( 
							CASE 
								WHEN [Cancelamento] IN ('Cancellation','Customer Cancellation') THEN 'Cancelado' 
								ELSE 'Não cancelado' 
							END
							) AS StatusDoCancelamento 
						FROM tb_OrdemDoMotorista
						) tb_1
					WHERE StatusDoCancelamento = 'Não cancelado'
					)
GROUP BY [IdRolls];

-- 5) Quantos Rolls vegetais e não vegetais foram pedidos por cada cliente?

SELECT 
	tb_1.[IdCliente], 
	R.[NomeRolls], 
	Total
FROM(
	 SELECT 
		[IdCliente], 
		[IdRolls], 
		COUNT([IdRolls]) AS Total 
	FROM tb_PedidosDoClientes
	GROUP BY [IdCliente], [IdRolls]
	) tb_1
INNER JOIN tb_Rolls R
ON tb_1.[IdRolls] = R.[IdRolls];

-- 6) Qual foi o número máximo de Rolls entregues em um único pedido?

/**SELECT *, (CASE WHEN [Cancelamento] IN ('Cancellation','Customer Cancellation') THEN 'Cancelado' ELSE 'Não cancelado' END) AS StatusDoCancelamento FROM tb_OrdemDoMotorista**/

/**SELECT [IdPedido] 
FROM (SELECT *, (CASE WHEN [Cancelamento] IN ('Cancellation','Customer Cancellation') THEN 'Cancelado' ELSE 'Não cancelado' END) AS StatusDoCancelamento FROM tb_OrdemDoMotorista) tb_1
WHERE StatusDoCancelamento = 'Não cancelado';**/

/**SELECT [IdPedido], COUNT([IdRolls]) AS Total
FROM (SELECT * FROM tb_PedidosDoClientes WHERE [IdPedido] IN (SELECT [IdPedido] 
FROM (SELECT *, (CASE WHEN [Cancelamento] IN ('Cancellation','Customer Cancellation') THEN 'Cancelado' ELSE 'Não cancelado' END) AS StatusDoCancelamento FROM tb_OrdemDoMotorista) tb_1
WHERE StatusDoCancelamento = 'Não cancelado')) tb_2 
GROUP BY [IdPedido];**/

/**SELECT *, 
	RANK() OVER (ORDER BY Total DESC) Classificacao
FROM
	(SELECT [IdPedido], COUNT([IdRolls]) AS Total
	FROM (SELECT * FROM tb_PedidosDoClientes 
	WHERE [IdPedido] IN (SELECT [IdPedido] 
	FROM (SELECT *, (CASE WHEN [Cancelamento] IN ('Cancellation','Customer Cancellation') THEN 'Cancelado' ELSE 'Não cancelado' END) AS StatusDoCancelamento FROM tb_OrdemDoMotorista) tb_1
	WHERE StatusDoCancelamento = 'Não cancelado')) tb_2 
	GROUP BY [IdPedido]) tb_3;**/

SELECT *
FROM
	(SELECT 
		*, 
		RANK() OVER (ORDER BY Total DESC) Classificacao
	FROM(SELECT 
			[IdPedido], 
			COUNT([IdRolls]) AS Total
		FROM(SELECT * FROM tb_PedidosDoClientes 
			  WHERE [IdPedido] IN (SELECT 
									  [IdPedido] 
								   FROM 
									  (SELECT 
										  *, 
										  (CASE WHEN [Cancelamento] IN ('Cancellation','Customer Cancellation') THEN 'Cancelado' ELSE 'Não cancelado' END) AS StatusDoCancelamento 
									  FROM tb_OrdemDoMotorista
									  ) tb_1
								   WHERE StatusDoCancelamento = 'Não cancelado'
								   )
			) tb_2 
		GROUP BY [IdPedido]
		) tb_3
	) tb_4
WHERE Classificacao = 1;

-- 7 - Para cada cliente, quantos Rolls entregues tiveram pelo menos 1 troca e quantos não tiveram troca?

-- a) Criando uma tabela temporaria dos pedidos dos clientes para incluir 0 nas celulas vazias e nulas
WITH tb_PedidosDoClientesTemporaria ([IdPedido],[IdCliente],[IdRolls],[ItensExtrasNaoIncluidos],[ItensExtrasIncluidos],[DataDoPedido]) AS
	(SELECT 
		[IdPedido],
		[IdCliente],
		[IdRolls],
		(CASE WHEN [ItensExtrasNaoIncluidos] IS NULL OR [ItensExtrasNaoIncluidos]=' ' THEN '0' ELSE [ItensExtrasNaoIncluidos] END) AS NovosItensExtrasNaoIncluidos,
		(CASE WHEN [ItensExtrasIncluidos] IS NULL OR [ItensExtrasIncluidos]= ' ' OR [ItensExtrasIncluidos] = 'NaN' OR [ItensExtrasIncluidos] = 'NULL' THEN '0' ELSE [ItensExtrasIncluidos] END) AS NovoItensExtrasIncluidos,
		[DataDoPedido]
	FROM tb_PedidosDoClientes
	)

SELECT * FROM tb_PedidosDoClientesTemporaria;

-- b) Criando uma tabela temporaria da ordem dos motoristas para incluir 0 nas celulas vazias e nulas
WITH tb_OrdemDoMotoristaTemporaria ([IdPedido],[IdMotorista],[HorarioDaColeta],[Distancia],[Duracao],NovoCancelamento) AS 
	(SELECT 
		[IdPedido],
		[IdMotorista],
		[HorarioDaColeta],
		[Distancia],
		[Duracao],
		(CASE WHEN [Cancelamento] IN ('Cancellation','Customer Cancellation') THEN 0 ELSE 1 END) AS NovoCancelamento
	FROM tb_OrdemDoMotorista
	)

SELECT * FROM tb_OrdemDoMotoristaTemporaria
WHERE NovoCancelamento != 0;

-- c) Juntando as duas tabelas temporarias
WITH tb_PedidosDoClientesTemporaria ([IdPedido],[IdCliente],[IdRolls],[ItensExtrasNaoIncluidos],[ItensExtrasIncluidos],[DataDoPedido]) AS
	(SELECT 
		[IdPedido],
		[IdCliente],
		[IdRolls],
		(CASE WHEN [ItensExtrasNaoIncluidos] IS NULL OR [ItensExtrasNaoIncluidos]=' ' THEN '0' ELSE [ItensExtrasNaoIncluidos] END) AS NovosItensExtrasNaoIncluidos,
		(CASE WHEN [ItensExtrasIncluidos] IS NULL OR [ItensExtrasIncluidos]= ' ' OR [ItensExtrasIncluidos] = 'NaN' OR [ItensExtrasIncluidos] = 'NULL' THEN '0' ELSE [ItensExtrasIncluidos] END) AS NovoItensExtrasIncluidos,
		[DataDoPedido]
	FROM tb_PedidosDoClientes
	),
tb_OrdemDoMotoristaTemporaria ([IdPedido],[IdMotorista],[HorarioDaColeta],[Distancia],[Duracao],NovoCancelamento) AS 
	(SELECT 
		[IdPedido],
		[IdMotorista],
		[HorarioDaColeta],
		[Distancia],
		[Duracao],
		(CASE WHEN [Cancelamento] IN ('Cancellation','Customer Cancellation') THEN 0 ELSE 1 END) AS NovoCancelamento
	FROM tb_OrdemDoMotorista)

SELECT [IdCliente], AlteraçãoDoPedido, COUNT([IdPedido]) AS Total
FROM(SELECT 
		*,
		(CASE WHEN [ItensExtrasNaoIncluidos] = '0' AND [ItensExtrasIncluidos] = '0' THEN 'Não houve alteração' ELSE 'Houve alteração' END) AS AlteraçãoDoPedido
	FROM tb_PedidosDoClientesTemporaria
	WHERE [IdPedido] IN (SELECT 
							[IdPedido] 
						 FROM tb_OrdemDoMotoristaTemporaria
						 WHERE NovoCancelamento != '0')) tb_1
GROUP BY [IdCliente], AlteraçãoDoPedido;

-- 8) Quantos Rolls foram entregues com exclusões (Não tiveram os itens extras incluídos) e extras?
WITH tb_PedidosDoClientesTemporaria ([IdPedido],[IdCliente],[IdRolls],[ItensExtrasNaoIncluidos],[ItensExtrasIncluidos],[DataDoPedido]) AS
	(SELECT 
		[IdPedido],
		[IdCliente],
		[IdRolls],
		(CASE WHEN [ItensExtrasNaoIncluidos] IS NULL OR [ItensExtrasNaoIncluidos]=' ' THEN '0' ELSE [ItensExtrasNaoIncluidos] END) AS NovosItensExtrasNaoIncluidos,
		(CASE WHEN [ItensExtrasIncluidos] IS NULL OR [ItensExtrasIncluidos]= ' ' OR [ItensExtrasIncluidos] = 'NaN' OR [ItensExtrasIncluidos] = 'NULL' THEN '0' ELSE [ItensExtrasIncluidos] END) AS NovoItensExtrasIncluidos,
		[DataDoPedido]
	FROM tb_PedidosDoClientes
	),
tb_OrdemDoMotoristaTemporaria ([IdPedido],[IdMotorista],[HorarioDaColeta],[Distancia],[Duracao],NovoCancelamento) AS 
	(SELECT 
		[IdPedido],
		[IdMotorista],
		[HorarioDaColeta],
		[Distancia],
		[Duracao],
		(CASE WHEN [Cancelamento] IN ('Cancellation','Customer Cancellation') THEN 0 ELSE 1 END) AS NovoCancelamento
	FROM tb_OrdemDoMotorista)

SELECT AlteraçãoDoPedido, COUNT(AlteraçãoDoPedido) AS Total
FROM
	(SELECT 
		*,
		(CASE WHEN [ItensExtrasNaoIncluidos] != '0' AND [ItensExtrasIncluidos] != '0' THEN 'Em ambos' ELSE 'Em apenas um' END) AS AlteraçãoDoPedido -- Inclusão do sinal de diferença e nas atribuições
	FROM tb_PedidosDoClientesTemporaria
	WHERE [IdPedido] IN (SELECT 
							[IdPedido] 
						 FROM tb_OrdemDoMotoristaTemporaria
						 WHERE NovoCancelamento != '0')) tb_1
GROUP BY AlteraçãoDoPedido;

-- 9) Qual foi o número total de Rolls encomendados para cada hora do dia?

/**SELECT 
	*, 
	DATEPART(HOUR,[DataDoPedido]) AS Inicial,
	DATEPART(HOUR,[DataDoPedido])+1 AS Final
FROM tb_PedidosDoClientes;**/

/**SELECT 
	*, 
	CONCAT(CAST(DATEPART(HOUR,[DataDoPedido]) AS VARCHAR),'-',CAST(DATEPART(HOUR,[DataDoPedido])+1 AS VARCHAR)) AS Intervalo
FROM tb_PedidosDoClientes;**/

SELECT Intervalo, COUNT(Intervalo) AS Total
FROM
	(SELECT 
		*, 
		CONCAT(CAST(DATEPART(HOUR,[DataDoPedido]) AS VARCHAR),'-',CAST(DATEPART(HOUR,[DataDoPedido])+1 AS VARCHAR)) AS Intervalo
	FROM tb_PedidosDoClientes) tb_1
GROUP BY Intervalo;

-- 10) Qual foi o número de pedidos para cada dia da semana?

/**SELECT *, DATENAME(DW, [DataDoPedido]) DiaDaSemana FROM tb_PedidosDoClientes;**/

SELECT 
	DiaDaSemana, 
	COUNT(DISTINCT([IdPedido])) AS Total
FROM (SELECT *, DATENAME(DW, [DataDoPedido]) DiaDaSemana 
	  FROM tb_PedidosDoClientes) tb_1
GROUP BY DiaDaSemana;

-- 11) Qual foi o tempo médio em minutos que cada motorista levou para chegar ao QG da fasoos para retirar o pedido?

/**SELECT 
	*, 
	DATEDIFF(MINUTE, [DataDoPedido], [HorarioDaColeta]) AS Diferença
FROM tb_PedidosDoClientes PC
INNER JOIN tb_OrdemDoMotorista OM
ON PC.[IdPedido] = OM.[IdPedido]
WHERE [HorarioDaColeta] IS NOT NULL**/

/**SELECT *, ROW_NUMBER() OVER(PARTITION BY [IdPedido] ORDER BY Diferenca) Classificacao 
FROM(
	SELECT 
		PC.[IdPedido], 
		PC.[IdCliente], 
		PC.[DataDoPedido], 
		OM.[IdMotorista], 
		OM.[HorarioDaColeta], 
		DATEDIFF(MINUTE,PC.[DataDoPedido], OM.[HorarioDaColeta]) AS Diferenca
	FROM tb_PedidosDoClientes PC
	INNER JOIN tb_OrdemDoMotorista OM
	ON PC.[IdPedido] = OM.[IdPedido]
	WHERE [HorarioDaColeta] IS NOT NULL) tb_1;**/

/**SELECT 
	* 
FROM(SELECT *, ROW_NUMBER() OVER(PARTITION BY [IdPedido] ORDER BY Diferenca) Classificacao 
	FROM(SELECT PC.[IdPedido], PC.[IdCliente], PC.[DataDoPedido], OM.[IdMotorista], OM.[HorarioDaColeta], DATEDIFF(MINUTE,PC.[DataDoPedido], OM.[HorarioDaColeta]) AS Diferenca
		FROM tb_PedidosDoClientes PC
		INNER JOIN tb_OrdemDoMotorista OM
		ON PC.[IdPedido] = OM.[IdPedido]
		WHERE [HorarioDaColeta] IS NOT NULL) tb_1) tb_2
WHERE Classificacao = 1;**/

SELECT [IdMotorista], SUM(Diferenca)/COUNT([IdPedido]) AS Média
FROM(SELECT * 
	FROM(SELECT *, ROW_NUMBER() OVER(PARTITION BY [IdPedido] ORDER BY Diferenca) Classificacao 
		FROM(SELECT PC.[IdPedido], PC.[IdCliente], PC.[DataDoPedido], OM.[IdMotorista], OM.[HorarioDaColeta], DATEDIFF(MINUTE,PC.[DataDoPedido], OM.[HorarioDaColeta]) AS Diferenca
			FROM tb_PedidosDoClientes PC
			INNER JOIN tb_OrdemDoMotorista OM
			ON PC.[IdPedido] = OM.[IdPedido]
			WHERE [HorarioDaColeta] IS NOT NULL) tb_1) tb_2
	WHERE Classificacao = 1) tb_3
GROUP BY [IdMotorista]; 

-- 12) Existe alguma relação entre o número de Rolls e quanto tempo leva para preparar o pedido?

SELECT [IdPedido], COUNT([IdRolls]) AS Total, SUM([Diferenca])/COUNT([IdRolls]) AS Média
FROM
	(SELECT 
		PC.[IdPedido], 
		PC.[IdCliente], 
		PC.[DataDoPedido], 
		PC.[IdRolls],
		OM.[IdMotorista], 
		OM.[HorarioDaColeta], 
		DATEDIFF(MINUTE,PC.[DataDoPedido], OM.[HorarioDaColeta]) AS Diferenca
	FROM tb_PedidosDoClientes PC
	INNER JOIN tb_OrdemDoMotorista OM
	ON PC.[IdPedido] = OM.[IdPedido]
	WHERE [HorarioDaColeta] IS NOT NULL) tb_1
GROUP BY [IdPedido];

-- 13) Qual foi a distância média percorrida por cada cliente?

/**SELECT *, ROW_NUMBER() OVER(PARTITION BY [IdPedido] ORDER BY Diferenca) Classificacao
FROM(SELECT 
		PC.[IdPedido], 
		PC.[IdCliente], 
		PC.[DataDoPedido], 
		PC.[IdRolls],
		OM.[IdMotorista], 
		OM.[Distancia],
		OM.[HorarioDaColeta], 
		DATEDIFF(MINUTE,PC.[DataDoPedido], OM.[HorarioDaColeta]) AS Diferenca
	FROM tb_PedidosDoClientes PC
	INNER JOIN tb_OrdemDoMotorista OM
	ON PC.[IdPedido] = OM.[IdPedido]
	WHERE [HorarioDaColeta] IS NOT NULL) tb_1**/ 

SELECT [IdCliente], SUM([Distancia])/COUNT([IdPedido]) AS Média
FROM(SELECT * 
	FROM
		(SELECT *, ROW_NUMBER() OVER(PARTITION BY [IdPedido] ORDER BY Diferenca) Classificacao
		FROM(SELECT 
				PC.[IdPedido], 
				PC.[IdCliente], 
				PC.[DataDoPedido], 
				PC.[IdRolls],
				OM.[IdMotorista], 
				CAST(TRIM(REPLACE(LOWER(OM.[Distancia]),'km','')) AS DECIMAL(4,2)) AS Distancia,
				OM.[HorarioDaColeta], 
				DATEDIFF(MINUTE,PC.[DataDoPedido], OM.[HorarioDaColeta]) AS Diferenca
			FROM tb_PedidosDoClientes PC
			INNER JOIN tb_OrdemDoMotorista OM
			ON PC.[IdPedido] = OM.[IdPedido]
			WHERE [HorarioDaColeta] IS NOT NULL) tb_1) tb_2
	WHERE Classificacao = 1) tb_3
GROUP BY [IdCliente];

-- 14) Qual foi a diferença entre os prazos de entrega mais longos e mais curtos para todos os pedidos?

/**SELECT * FROM [tb_OrdemDoMotorista]
WHERE [Duracao] IS NOT NULL**/  

/**SELECT 
	(CASE
		WHEN [Duracao] LIKE '%min%' THEN LEFT([Duracao], CHARINDEX('m', [Duracao])-1)
		ELSE [Duracao]
	END
	) AS Duracao
FROM [tb_OrdemDoMotorista]
WHERE [Duracao] IS NOT NULL**/ 

SELECT MAX([Duracao])-MIN([Duracao]) AS Diferença
FROM(SELECT 
		CAST((CASE
			WHEN [Duracao] LIKE '%min%' THEN LEFT([Duracao], CHARINDEX('m', [Duracao])-1)
			ELSE [Duracao]
		END  
		) AS INTEGER) AS Duracao
	FROM [tb_OrdemDoMotorista]
	WHERE [Duracao] IS NOT NULL) tb_1

-- 15) Qual foi a velocidade média de cada motorista para cada entrega e você percebe alguma tendência nesses valores?


SELECT 
	tb_1.[IdPedido], 
	tb_1.[IdMotorista], 
	tb_1.[Distancia]/tb_1.[Duracao] AS Velocidade, 
	tb_2.Total_Pedido
FROM(SELECT 
		[IdPedido],
		[IdMotorista],
		CAST(TRIM(REPLACE(LOWER([Distancia]), 'km', ''))AS DECIMAL(4,2)) AS Distancia,
		CAST((CASE
			WHEN [Duracao] LIKE '%min%' THEN LEFT([Duracao], CHARINDEX('m', [Duracao])-1)
			ELSE [Duracao]
		END  
		) AS INTEGER) AS Duracao
	FROM [tb_OrdemDoMotorista]
	WHERE Distancia IS NOT NULL
	) tb_1
	INNER JOIN (
				SELECT [IdPedido], COUNT([IdRolls]) AS Total_Pedido FROM tb_PedidosDoClientes 
				GROUP BY [IdPedido]
				) tb_2
	ON tb_1.[IdPedido] = tb_2.[IdPedido]
	
-- 16) Qual é a porcentagem de entrega bem-sucedida para cada motorista?

/**SELECT 
	[IdMotorista],
	(CASE
		WHEN LOWER([Cancelamento]) LIKE '%cancel%' THEN 0
		ELSE 1
	END) AS Cancelado 
FROM tb_OrdemDoMotorista**/ 

SELECT 
	[IdMotorista], 
	(Total_Cancelado * 1.0 / Total_Pedido) * 100 AS PercentualDeCancelamento
FROM(SELECT [IdMotorista], SUM([Cancelado]) AS Total_Cancelado, COUNT([IdMotorista]) AS Total_Pedido
	FROM(SELECT 
			[IdMotorista],
			(CASE
				WHEN LOWER([Cancelamento]) LIKE '%cancel%' THEN 0
				ELSE 1
			END) AS Cancelado 
		FROM tb_OrdemDoMotorista) tb_1
	GROUP BY [IdMotorista]) tb_2
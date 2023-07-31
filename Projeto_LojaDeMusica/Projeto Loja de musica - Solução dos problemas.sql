/****** Script dos comandos em SQL  ******/

/* Q1: Quem é o funcionário mais sênior com base no cargo? */

SELECT
	[title] AS 'Título do cargo', 
	[first_name] AS 'Nome do Funcionário', 
	[last_name] AS 'Sobrenome do Funcnionário',
	[levels] AS 'Nivel Hierarquico'
FROM employee 
WHERE [reports_to] = 0; 


/* Q2: Quais países têm mais faturas? */

SELECT 
	COUNT(*) AS 'Quantidade de Faturas', 
	[billing_country] AS 'País da cobrança' 
FROM invoice
GROUP BY [billing_country]
ORDER BY COUNT(*) DESC;


/* Q3: Quais são os 3 principais valores da fatura total? */

SELECT TOP(3)
	ROUND([Total],2) AS 'Principais valores'
FROM [invoice]
GROUP BY [Total]
ORDER BY [Total] DESC;


/* Q4: Qual cidade tem os melhores clientes? 
Gostaríamos de lançar um Festival de Música promocional na cidade que mais ganhamos dinheiro.*/

SELECT TOP(1)
	[billing_country] AS 'País',
	[billing_city] AS 'Cidade',
	ROUND(SUM([total]),2) AS 'Total Acumulado'
FROM invoice
GROUP BY [billing_country], [billing_city]
ORDER BY 'Total Acumulado' DESC;


/* Q5: Quem é o melhor cliente? O cliente que gastou mais dinheiro será declarado o melhor cliente.*/

SELECT TOP(1)
	C.[customer_id] AS 'Id do Cliente', 
	C.[first_name] AS 'Nome do Cliente', 
	C.[last_name] AS 'Sobrenome do Cliente', 
	ROUND(SUM(F.[total]),2) AS 'Gasto total'
FROM customer AS C
INNER JOIN invoice AS F
ON C.[customer_id] = F.[customer_id]
GROUP BY C.[customer_id], C.[first_name], C.[last_name]
ORDER BY 'Gasto total' DESC;

/* Q6: Escreva a consulta para retornar o e-mail, nome, sobrenome e gênero de todos os ouvintes de música rock. */

SELECT 
	DISTINCT Cliente.[email] AS 'E-mail',
	CONCAT(Cliente.[first_name],' ', Cliente.[last_name])AS 'Nome Completo do Ouvinte'
FROM customer Cliente
JOIN invoice Fatura 
ON Cliente.[customer_id] = Fatura.[customer_id]
	JOIN [invoice_line] ItensDaFatura 
	ON Fatura.[invoice_id] = ItensDaFatura.[invoice_id]
	WHERE ItensDaFatura.[track_id] IN(
					 SELECT -- 1297 faixas com o gênero Rock
						Faixa.[track_id] 
					 FROM track Faixa
					 JOIN genre Genero
					 ON Faixa.[genre_id] = Genero.[genre_id]
					 WHERE Genero.[name] LIKE 'Rock'
					 )
ORDER BY Cliente.[email];

/* Q7: Vamos convidar os artistas que escreveram mais música do gênero Rock em nosso conjunto de dados. Por isso, precisamos saber:
O nome do artista e a contagem total de faixas das 10 principais bandas de rock. */

SELECT TOP(10)
	AR.[artist_id] AS 'ID do Artista', 
	AR.[name] AS 'Nome do Artista',
	COUNT(*) AS 'Contagem Total'
FROM artist AR
INNER JOIN album AL 
ON AL.[artist_id] = AR.[artist_id]    
	INNER JOIN track F
	ON F.[album_id] = AL.[album_id]
	INNER JOIN genre G
	ON G.[genre_id] = F.[genre_id]
	WHERE G.[name] LIKE 'Rock'
GROUP BY AR.[artist_id], AR.[name]
ORDER BY 'Contagem Total' DESC

/* Q8: Exiba todos os nomes e seus milissegundos de cada faixa que tenham uma duração de música maior do que a duração média da música.*/

SELECT 
	[name] AS 'Nome da Faixa',
	[milliseconds] AS 'Duração de cada faixa acima da média'
FROM track
WHERE [milliseconds] > (SELECT  -- Resposta: Duração média das faixas é 392104
							AVG([milliseconds]) AS 'Duração Média'
						FROM track)
ORDER BY [milliseconds] DESC;

/* Q9: Descobrir quanto foi gasto por cada cliente em artistas?*/

SELECT 
	C.[customer_id],
	C.[first_name],
	C.[last_name],
	SUM(I.[unit_price]*I.[quantity]) total
FROM customer C
INNER JOIN invoice F
ON C.[customer_id] = F.[customer_id]
	INNER JOIN invoice_line I
	ON F.[invoice_id] = I.[invoice_id]
		INNER JOIN track FX
		ON I.[track_id] = FX.[track_id]
			INNER JOIN album A
			ON FX.[album_id] = A.[album_id]
			WHERE [artist_id] IN (SELECT [artist_id] FROM
									(SELECT 
										AR.[artist_id], 
										AR.[name], 
										SUM(I.[unit_price]*I.[quantity]) total
									FROM artist AR
									INNER JOIN album A
									ON AR.[artist_id] = A.[artist_id]
										INNER JOIN track FX
										ON A.[album_id] = FX.[album_id]
											INNER JOIN invoice_line I
											ON FX.[track_id] = I.[track_id]
									GROUP BY AR.[artist_id], AR.[name]
									) 
								 tb_1)
GROUP BY C.[customer_id], C.[first_name], C.[last_name]
ORDER BY total ASC;

/* Q10: Queremos descobrir o gênero musical mais popular (gênero com a maior quantidade de compras) para cada país. */

SELECT [País], [Nome do Gênero], [Quantidade]
FROM(SELECT
		C.[country] AS 'País',
		G.[name] AS 'Nome do Gênero',
		COUNT(I.[quantity]) AS 'Quantidade',
		ROW_NUMBER() OVER(PARTITION BY C.[country] ORDER BY COUNT(I.[quantity]) DESC) AS 'Classificação'
	FROM genre G
	INNER JOIN track FX
	ON G.[genre_id] = FX.[genre_id]
		INNER JOIN invoice_line I
		ON FX.[track_id] = I.[track_id]
			INNER JOIN invoice F
			ON I.[invoice_id] = F.[invoice_id]
			 INNER JOIN customer C
			 ON F.[customer_id] = C.[customer_id]
	GROUP BY C.[country], G.[name]) tb_1
WHERE Classificação = 1

/* Q11: Escreva uma consulta que determine o cliente que mais gastou em música para cada país. */

SELECT [Id do Cliente], [Nome Completo], [País], [Soma] FROM
	(SELECT 
		C.[customer_id] AS 'Id do Cliente',
		CONCAT(C.[first_name],' ', C.[last_name]) AS 'Nome Completo',
		C.[country] AS 'País',
		ROUND(SUM(F.[total]),2) AS 'Soma',
		ROW_NUMBER() OVER(PARTITION BY C.[country] ORDER BY ROUND(SUM(F.[total]),2) DESC) AS 'Classificação'
	FROM customer C
	INNER JOIN invoice F 
	ON C.[customer_id] = F.[customer_id]
	GROUP BY C.[customer_id], CONCAT(C.[first_name],' ', C.[last_name]), C.[country]
	) tb_1
WHERE Classificação = 1
ORDER BY Soma DESC;

/** Q12 - Para melhorar o gerenciamento de inventário: Identifique títulos populares e garantir que estejam sempre em estoque. **/
SELECT [Titulo do Album], [Nome da Música], [Total vendido] FROM
(SELECT 
  A.[title] AS 'Titulo do Album', 
  FX.[name] AS 'Nome da Música',
  SUM(I.[unit_price]*I.[quantity]) AS 'Total vendido',
  DENSE_RANK() OVER(PARTITION BY A.[title] ORDER BY SUM(I.[unit_price]*I.[quantity]) DESC) AS 'Classificação'
FROM album A
JOIN track FX
ON A.[album_id] = FX.[album_id]
  JOIN invoice_line I
  ON FX.[track_id] = I.[track_id]
GROUP BY A.[title], FX.[name]) tb_1
WHERE [Classificação] = 1 AND [Total vendido] > 1
ORDER BY [Total vendido] DESC;

/** Q13 - Para otimizar as estratégias de marketing: Analise o histórico de compras dos clientes para identificar suas preferências e enviar-lhes promoções de álbuns e artistas de que provavelmente gostem. **/

-- Script para descobrir o cliente que mais gastou na loja: Resultou no cliente ID = 5
SELECT TOP(1) C.[customer_id], SUM(F.[total]) Soma FROM customer C
INNER JOIN invoice F ON C.[customer_id] = F.[customer_id]
GROUP BY C.[customer_id]
ORDER BY Soma DESC;  

-- Script para descobrir quais são os artistas que o cliente ID = 5 comprou: Resultou em 52 artistas diferentes
SELECT COUNT(DISTINCT ART.[artist_id]) 'Total' FROM customer C
JOIN invoice F ON C.[customer_id] = F.[customer_id]
	JOIN invoice_line I ON F.[invoice_id] = I.[invoice_id]
		JOIN track FX ON I.[track_id] = FX.[track_id]
			JOIN album A ON FX.[album_id] = A.[album_id]
				JOIN artist ART ON A.[artist_id] = ART.[artist_id]
WHERE C.[customer_id] = 5


-- Script para descobrir quais são os artistas e seus respectivos albuns que o cliente ID = 5 ainda não comprou: Resultou em 115 albuns que ainda não foram comprados pelo cliente ID = 5
SELECT 
	ART.[artist_id] AS 'ID ',
	ART.[name] AS 'Artista recomendado',
	A.[title] AS 'Álbum recomendado'
FROM customer C
JOIN invoice F
ON C.[customer_id] = F.[customer_id]
	JOIN invoice_line I
	ON F.[invoice_id] = I.[invoice_id]
		JOIN track FX
		ON I.[track_id] = FX.[track_id]
			JOIN album A
			ON FX.[album_id] = A.[album_id]
				JOIN artist ART
				ON A.[artist_id] = ART.[artist_id]
WHERE ART.[artist_id] NOT IN(
							SELECT ART.[artist_id] 
							FROM customer C
							JOIN invoice F ON C.[customer_id] = F.[customer_id]
								JOIN invoice_line I ON F.[invoice_id] = I.[invoice_id]
									JOIN track FX ON I.[track_id] = FX.[track_id]
										JOIN album A ON FX.[album_id] = A.[album_id]
											JOIN artist ART ON A.[artist_id] = ART.[artist_id]
							WHERE C.[customer_id] = 5
							)
GROUP BY ART.[artist_id], ART.[Name], A.[title]
ORDER BY ART.[artist_id];

/** Q14 - Aprimorando a experiência do cliente: a loja de música pode querer melhorar a experiência do cliente fornecendo recomendações personalizadas, 
sugerindo listas de reprodução com base no histórico de audição e nas preferências de um cliente. **/

-- Script para descobrir quais são as playlists que o cliente ID = 5 comprou: Resultou em 6 playlists diferentes
SELECT COUNT(DISTINCT(P.[playlist_id])) Total FROM playlist P
JOIN playlist_track PFX ON P.[playlist_id] = PFX.[playlist_id]
JOIN track FX ON PFX.[track_id] = FX.[track_id]
JOIN invoice_line I ON FX.[track_id] = I.[track_id]
JOIN invoice F ON I.[invoice_id] = F.[invoice_id]
JOIN customer C ON F.[customer_id] = C.[customer_id]
WHERE C.[customer_id] = 5

-- Script para descobrir quais são as playlists que o cliente ID = 5 ainda não comprou: Resultou em 7 playlists diferentes
SELECT 
  P.[playlist_id] AS 'Id', 
  P.[name] AS 'Lista de reprodução recomendada'
FROM playlist P
JOIN playlist_track PFX ON P.[playlist_id] = PFX.[playlist_id]
  JOIN track FX ON PFX.[track_id] = FX.[track_id]
	JOIN invoice_line I ON FX.[track_id] = I.[track_id]
		JOIN invoice F ON I.[invoice_id] = F.[invoice_id]
			JOIN customer C ON F.[customer_id] = C.[customer_id]
WHERE P.[playlist_id] NOT IN (
								SELECT P.[playlist_id] FROM playlist P
								JOIN playlist_track PFX ON P.[playlist_id] = PFX.[playlist_id]
									JOIN track FX ON PFX.[track_id] = FX.[track_id]
										JOIN invoice_line I ON FX.[track_id] = I.[track_id]
											JOIN invoice F ON I.[invoice_id] = F.[invoice_id]
												JOIN customer C ON F.[customer_id] = C.[customer_id]
								WHERE C.[customer_id] = 5
							 )
GROUP BY P.[playlist_id], P.[name]

/** Q15 - Simplificação do agendamento de funcionários: a loja de música pode ter dificuldades para agendar funcionários de maneira eficiente. 
Identifique os dias mais movimentados para designar mais funcionários de acordo.**/

SELECT 
  DAY(F.[invoice_date]) AS 'Dias movimentados', 
  COUNT(*) AS 'Total da Fatura',
  COUNT(DISTINCT F.[customer_id]) AS 'Total de Clientes'
FROM invoice F
GROUP BY DAY(F.[invoice_date])
ORDER BY 'Total de Clientes' DESC, 'Total da Fatura' DESC;

/** Q16 - Identificando gêneros de baixo desempenho: a loja de música pode ter problemas para vender certos gêneros de música. 
Identifique quais gêneros estão vendendo mal e ajustar seu inventário de acordo.**/

SELECT 
  G.[name] AS 'Gêneros',
  COUNT(F.[invoice_id]) AS 'Total faturado'  
FROM genre G
  JOIN track FX ON G.[genre_id] = FX.[genre_id]
  JOIN invoice_line I ON FX.[track_id] = I.[track_id]
  JOIN invoice F ON I.[invoice_id] = F.[invoice_id]
GROUP BY G.[name]
HAVING COUNT(F.[invoice_id]) < 100
ORDER BY 'Total faturado';

/** Q17 - Melhorar o rastreamento de faturas: a loja de música pode querer rastrear seus dados de vendas com mais eficiência. 
Identifique os itens mais vendidos, tendências de receita e outras métricas importantes.**/

SELECT 
  FX.[name] AS 'Faixa',
  ART.[name] AS 'Artista',
  A.[title] AS 'Album',
  G.[name] AS 'Gênero',
  SUM(I.[quantity]) AS 'Quantidade vendida',
  SUM(I.[unit_price] * I.[quantity]) AS 'Receita total'
FROM invoice_line I
JOIN track FX ON I.[track_id] = FX.[track_id]
  JOIN album A ON FX.[album_id] = A.[album_id]
	JOIN artist ART ON A.[artist_id] = ART.[artist_id]
		JOIN genre G ON FX.[genre_id] = G.[genre_id]
GROUP BY FX.[track_id], FX.[name], ART.[name], A.[title], G.[name]
ORDER BY 'Receita total' DESC;

/** Q18 - Avaliação das preferências de tipo de mídia: A loja de música pode querer entender quais tipos de mídia são mais populares entre os clientes. 
Identifique tendências nas preferências de tipo de mídia.**/

SELECT 
  TM.[name] AS 'Tipo de Mídia',
  COUNT(*) AS 'Quantidade vendida'
FROM media_type TM
JOIN track FX ON TM.[media_type_id] = FX.[media_type_id]
  JOIN invoice_line I ON FX.[track_id] = I.[track_id]
	JOIN invoice F ON I.[invoice_id] = F.[invoice_id]
GROUP BY TM.[name]
ORDER BY 'Quantidade vendida' DESC;

/** Q19 - Melhorando o atendimento de pedidos: a loja de música pode querer simplificar seu processo de atendimento de pedidos. 
Eles poderiam usar os dados da fatura e das tabelas de linha da fatura para rastrear o status dos pedidos e identificar gargalos no processo de atendimento. **/

SELECT 
  F.[invoice_date] AS 'Data do pedido',
  F.[billing_country] AS 'País',
  COUNT(DISTINCT F.[customer_id]) AS 'Total de Clientes',
  COUNT(DISTINCT F.[invoice_id]) AS 'Total de pedidos',
  COUNT(I.[invoice_line_id]) AS 'Total de Itens',
  SUM(I.[unit_price] * I.[quantity]) AS 'Receita total',
  (CASE 
    WHEN F.[invoice_date] > '31/12/2020' THEN 'Novo'
    WHEN F.[invoice_date] > '01/01/2020' AND F.[invoice_date] < '31/12/2020' THEN 'Em andamento'
    ELSE 'Realizado'
  END) AS 'Status do pedido'
FROM invoice F
JOIN invoice_line I 
ON F.[invoice_id] = I.[invoice_id]
GROUP BY F.[invoice_date], F.[billing_country]
ORDER BY 'Status do pedido' ASC;

/** Q20 - Analisando a popularidade do artista: a loja de música pode querer identificar quais artistas são mais populares entre seus clientes. 
Identifique os artistas de melhor desempenho. **/

SELECT TOP(100)
  ART.[name] AS 'Nome do artista',
  A.[title] AS 'Tituo do album',
  COUNT(DISTINCT F.[customer_id]) AS 'Total de Clientes',
  COUNT(DISTINCT F.[invoice_id]) AS 'Total de pedidos',
  COUNT(I.[invoice_line_id]) AS 'Total de Itens',
  SUM(I.[unit_price] * I.[quantity]) AS 'Receita total'
FROM artist ART
JOIN album A ON ART.[artist_id] = A.[artist_id]
  JOIN track FX ON A.[album_id] = FX.[album_id]
	JOIN invoice_line I ON FX.[track_id] = I.[track_id]
		JOIN invoice F ON I.[invoice_id] = F.[invoice_id]
GROUP BY  ART.[name], A.[title]
ORDER BY 'Receita total' DESC;
/****** Script dos comandos em SQL  ******/

/* Q1: Quem � o funcion�rio mais s�nior com base no cargo? */

SELECT
	[title] AS 'T�tulo do cargo', 
	[first_name] AS 'Nome do Funcion�rio', 
	[last_name] AS 'Sobrenome do Funcnion�rio',
	[levels] AS 'Nivel Hierarquico'
FROM employee 
WHERE [reports_to] = 0; 


/* Q2: Quais pa�ses t�m mais faturas? */

SELECT 
	COUNT(*) AS 'Quantidade de Faturas', 
	[billing_country] AS 'Pa�s da cobran�a' 
FROM invoice
GROUP BY [billing_country]
ORDER BY COUNT(*) DESC;


/* Q3: Quais s�o os 3 principais valores da fatura total? */

SELECT TOP(3)
	ROUND([Total],2) AS 'Principais valores'
FROM [invoice]
GROUP BY [Total]
ORDER BY [Total] DESC;


/* Q4: Qual cidade tem os melhores clientes? 
Gostar�amos de lan�ar um Festival de M�sica promocional na cidade que mais ganhamos dinheiro.*/

SELECT TOP(1)
	[billing_country] AS 'Pa�s',
	[billing_city] AS 'Cidade',
	ROUND(SUM([total]),2) AS 'Total Acumulado'
FROM invoice
GROUP BY [billing_country], [billing_city]
ORDER BY 'Total Acumulado' DESC;


/* Q5: Quem � o melhor cliente? O cliente que gastou mais dinheiro ser� declarado o melhor cliente.*/

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

/* Q6: Escreva a consulta para retornar o e-mail, nome, sobrenome e g�nero de todos os ouvintes de m�sica rock. */

SELECT 
	DISTINCT Cliente.[email] AS 'E-mail',
	CONCAT(Cliente.[first_name],' ', Cliente.[last_name])AS 'Nome Completo do Ouvinte'
FROM customer Cliente
JOIN invoice Fatura 
ON Cliente.[customer_id] = Fatura.[customer_id]
	JOIN [invoice_line] ItensDaFatura 
	ON Fatura.[invoice_id] = ItensDaFatura.[invoice_id]
	WHERE ItensDaFatura.[track_id] IN(
					 SELECT -- 1297 faixas com o g�nero Rock
						Faixa.[track_id] 
					 FROM track Faixa
					 JOIN genre Genero
					 ON Faixa.[genre_id] = Genero.[genre_id]
					 WHERE Genero.[name] LIKE 'Rock'
					 )
ORDER BY Cliente.[email];

/* Q7: Vamos convidar os artistas que escreveram mais m�sica do g�nero Rock em nosso conjunto de dados. Por isso, precisamos saber:
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

/* Q8: Exiba todos os nomes e seus milissegundos de cada faixa que tenham uma dura��o de m�sica maior do que a dura��o m�dia da m�sica.*/

SELECT 
	[name] AS 'Nome da Faixa',
	[milliseconds] AS 'Dura��o de cada faixa acima da m�dia'
FROM track
WHERE [milliseconds] > (SELECT  -- Resposta: Dura��o m�dia das faixas � 392104
							AVG([milliseconds]) AS 'Dura��o M�dia'
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

/* Q10: Queremos descobrir o g�nero musical mais popular (g�nero com a maior quantidade de compras) para cada pa�s. */

SELECT [Pa�s], [Nome do G�nero], [Quantidade]
FROM(SELECT
		C.[country] AS 'Pa�s',
		G.[name] AS 'Nome do G�nero',
		COUNT(I.[quantity]) AS 'Quantidade',
		ROW_NUMBER() OVER(PARTITION BY C.[country] ORDER BY COUNT(I.[quantity]) DESC) AS 'Classifica��o'
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
WHERE Classifica��o = 1

/* Q11: Escreva uma consulta que determine o cliente que mais gastou em m�sica para cada pa�s. */

SELECT [Id do Cliente], [Nome Completo], [Pa�s], [Soma] FROM
	(SELECT 
		C.[customer_id] AS 'Id do Cliente',
		CONCAT(C.[first_name],' ', C.[last_name]) AS 'Nome Completo',
		C.[country] AS 'Pa�s',
		ROUND(SUM(F.[total]),2) AS 'Soma',
		ROW_NUMBER() OVER(PARTITION BY C.[country] ORDER BY ROUND(SUM(F.[total]),2) DESC) AS 'Classifica��o'
	FROM customer C
	INNER JOIN invoice F 
	ON C.[customer_id] = F.[customer_id]
	GROUP BY C.[customer_id], CONCAT(C.[first_name],' ', C.[last_name]), C.[country]
	) tb_1
WHERE Classifica��o = 1
ORDER BY Soma DESC;

/** Q12 - Para melhorar o gerenciamento de invent�rio: Identifique t�tulos populares e garantir que estejam sempre em estoque. **/
SELECT [Titulo do Album], [Nome da M�sica], [Total vendido] FROM
(SELECT 
  A.[title] AS 'Titulo do Album', 
  FX.[name] AS 'Nome da M�sica',
  SUM(I.[unit_price]*I.[quantity]) AS 'Total vendido',
  DENSE_RANK() OVER(PARTITION BY A.[title] ORDER BY SUM(I.[unit_price]*I.[quantity]) DESC) AS 'Classifica��o'
FROM album A
JOIN track FX
ON A.[album_id] = FX.[album_id]
  JOIN invoice_line I
  ON FX.[track_id] = I.[track_id]
GROUP BY A.[title], FX.[name]) tb_1
WHERE [Classifica��o] = 1 AND [Total vendido] > 1
ORDER BY [Total vendido] DESC;

/** Q13 - Para otimizar as estrat�gias de marketing: Analise o hist�rico de compras dos clientes para identificar suas prefer�ncias e enviar-lhes promo��es de �lbuns e artistas de que provavelmente gostem. **/

-- Script para descobrir o cliente que mais gastou na loja: Resultou no cliente ID = 5
SELECT TOP(1) C.[customer_id], SUM(F.[total]) Soma FROM customer C
INNER JOIN invoice F ON C.[customer_id] = F.[customer_id]
GROUP BY C.[customer_id]
ORDER BY Soma DESC;  

-- Script para descobrir quais s�o os artistas que o cliente ID = 5 comprou: Resultou em 52 artistas diferentes
SELECT COUNT(DISTINCT ART.[artist_id]) 'Total' FROM customer C
JOIN invoice F ON C.[customer_id] = F.[customer_id]
	JOIN invoice_line I ON F.[invoice_id] = I.[invoice_id]
		JOIN track FX ON I.[track_id] = FX.[track_id]
			JOIN album A ON FX.[album_id] = A.[album_id]
				JOIN artist ART ON A.[artist_id] = ART.[artist_id]
WHERE C.[customer_id] = 5


-- Script para descobrir quais s�o os artistas e seus respectivos albuns que o cliente ID = 5 ainda n�o comprou: Resultou em 115 albuns que ainda n�o foram comprados pelo cliente ID = 5
SELECT 
	ART.[artist_id] AS 'ID ',
	ART.[name] AS 'Artista recomendado',
	A.[title] AS '�lbum recomendado'
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

/** Q14 - Aprimorando a experi�ncia do cliente: a loja de m�sica pode querer melhorar a experi�ncia do cliente fornecendo recomenda��es personalizadas, 
sugerindo listas de reprodu��o com base no hist�rico de audi��o e nas prefer�ncias de um cliente. **/

-- Script para descobrir quais s�o as playlists que o cliente ID = 5 comprou: Resultou em 6 playlists diferentes
SELECT COUNT(DISTINCT(P.[playlist_id])) Total FROM playlist P
JOIN playlist_track PFX ON P.[playlist_id] = PFX.[playlist_id]
JOIN track FX ON PFX.[track_id] = FX.[track_id]
JOIN invoice_line I ON FX.[track_id] = I.[track_id]
JOIN invoice F ON I.[invoice_id] = F.[invoice_id]
JOIN customer C ON F.[customer_id] = C.[customer_id]
WHERE C.[customer_id] = 5

-- Script para descobrir quais s�o as playlists que o cliente ID = 5 ainda n�o comprou: Resultou em 7 playlists diferentes
SELECT 
  P.[playlist_id] AS 'Id', 
  P.[name] AS 'Lista de reprodu��o recomendada'
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

/** Q15 - Simplifica��o do agendamento de funcion�rios: a loja de m�sica pode ter dificuldades para agendar funcion�rios de maneira eficiente. 
Identifique os dias mais movimentados para designar mais funcion�rios de acordo.**/

SELECT 
  DAY(F.[invoice_date]) AS 'Dias movimentados', 
  COUNT(*) AS 'Total da Fatura',
  COUNT(DISTINCT F.[customer_id]) AS 'Total de Clientes'
FROM invoice F
GROUP BY DAY(F.[invoice_date])
ORDER BY 'Total de Clientes' DESC, 'Total da Fatura' DESC;

/** Q16 - Identificando g�neros de baixo desempenho: a loja de m�sica pode ter problemas para vender certos g�neros de m�sica. 
Identifique quais g�neros est�o vendendo mal e ajustar seu invent�rio de acordo.**/

SELECT 
  G.[name] AS 'G�neros',
  COUNT(F.[invoice_id]) AS 'Total faturado'  
FROM genre G
  JOIN track FX ON G.[genre_id] = FX.[genre_id]
  JOIN invoice_line I ON FX.[track_id] = I.[track_id]
  JOIN invoice F ON I.[invoice_id] = F.[invoice_id]
GROUP BY G.[name]
HAVING COUNT(F.[invoice_id]) < 100
ORDER BY 'Total faturado';

/** Q17 - Melhorar o rastreamento de faturas: a loja de m�sica pode querer rastrear seus dados de vendas com mais efici�ncia. 
Identifique os itens mais vendidos, tend�ncias de receita e outras m�tricas importantes.**/

SELECT 
  FX.[name] AS 'Faixa',
  ART.[name] AS 'Artista',
  A.[title] AS 'Album',
  G.[name] AS 'G�nero',
  SUM(I.[quantity]) AS 'Quantidade vendida',
  SUM(I.[unit_price] * I.[quantity]) AS 'Receita total'
FROM invoice_line I
JOIN track FX ON I.[track_id] = FX.[track_id]
  JOIN album A ON FX.[album_id] = A.[album_id]
	JOIN artist ART ON A.[artist_id] = ART.[artist_id]
		JOIN genre G ON FX.[genre_id] = G.[genre_id]
GROUP BY FX.[track_id], FX.[name], ART.[name], A.[title], G.[name]
ORDER BY 'Receita total' DESC;

/** Q18 - Avalia��o das prefer�ncias de tipo de m�dia: A loja de m�sica pode querer entender quais tipos de m�dia s�o mais populares entre os clientes. 
Identifique tend�ncias nas prefer�ncias de tipo de m�dia.**/

SELECT 
  TM.[name] AS 'Tipo de M�dia',
  COUNT(*) AS 'Quantidade vendida'
FROM media_type TM
JOIN track FX ON TM.[media_type_id] = FX.[media_type_id]
  JOIN invoice_line I ON FX.[track_id] = I.[track_id]
	JOIN invoice F ON I.[invoice_id] = F.[invoice_id]
GROUP BY TM.[name]
ORDER BY 'Quantidade vendida' DESC;

/** Q19 - Melhorando o atendimento de pedidos: a loja de m�sica pode querer simplificar seu processo de atendimento de pedidos. 
Eles poderiam usar os dados da fatura e das tabelas de linha da fatura para rastrear o status dos pedidos e identificar gargalos no processo de atendimento. **/

SELECT 
  F.[invoice_date] AS 'Data do pedido',
  F.[billing_country] AS 'Pa�s',
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

/** Q20 - Analisando a popularidade do artista: a loja de m�sica pode querer identificar quais artistas s�o mais populares entre seus clientes. 
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
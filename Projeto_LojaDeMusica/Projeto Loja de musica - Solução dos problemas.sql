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
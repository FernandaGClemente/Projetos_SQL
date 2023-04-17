/****** Script dos comandos SQL dos exercicios do site https://sqlbolt.com/ ******/
USE  master;

-- Exercício 1 — Tarefas
-- Encontre o title de cada filme
SELECT [Title] FROM movies;

-- Encontre o director de cada filme
SELECT [Director] FROM movies;

-- Encontre o title e director de cada filme
SELECT [Title], [Director] FROM movies;

-- Encontre o title e year de cada filme
SELECT [Year], [Title] FROM movies;

-- Encontre all as informações sobre cada filme
SELECT * FROM movies;

-- Exercício 2 — Tarefas
-- Encontre o filme com uma linha id de 6
SELECT [Title] FROM movies
WHERE [Id] == 6;

-- Encontre os filmes lançados nos year anos de 2000 a 2010
SELECT [Title] FROM movies
WHERE [Year] between 2000 AND 2010;

-- Encontre os filmes não lançados nos year anos entre 2000 e 2010
SELECT [Title] FROM movies
WHERE NOT [Year] between 2000 AND 2010;

-- Encontre os 5 primeiros filmes da Pixar e seus lançamentos year
SELECT [Title] FROM movies
WHERE [Id] < 6
ORDER BY [Year];

-- Exercício 3 — Tarefas
-- Encontre todos os filmes Toy Story
SELECT [Title] FROM movies
WHERE [Title] LIKE '%Toy%';

-- Encontre todos os filmes dirigidos por John Lasseter
SELECT [Title] FROM movies
WHERE [Director] LIKE '%Lasseter%';

-- Encontre todos os filmes (e diretores) não dirigidos por John Lasseter
SELECT [Title] FROM movies
WHERE NOT [Director] LIKE '%Lasseter%';

-- Encontre todos os filmes WALL-*
SELECT [Title] FROM movies
WHERE [Title] LIKE '%WALL%';

-- Exercício 4 — Tarefas
-- Liste todos os diretores de filmes da Pixar (em ordem alfabética), sem duplicatas
SELECT DISTINCT([Director]) FROM movies
ORDER BY [Director] ASC;

-- Liste os últimos quatro filmes da Pixar lançados (ordenados do mais recente ao menos)
SELECT [Title] FROM movies
ORDER BY [Year] DESC
LIMIT 4;

-- Liste os cinco primeiros filmes da Pixar em ordem alfabética
SELECT * FROM movies
ORDER BY [Title] ASC
LIMIT 5;

-- Liste os próximos cinco filmes da Pixar em ordem alfabética
SELECT * FROM movies
ORDER BY [Title] ASC
LIMIT 5 OFFSET 5;

-- Revisão 1 - Tarefas
-- Liste todas as cidades canadenses e suas populações
SELECT [City], [Population] FROM north_american_cities
WHERE [Country] == 'Canada';

-- Ordene todas as cidades dos Estados Unidos por sua latitude de norte a sul
SELECT [City] FROM north_american_cities
WHERE [Country] == 'United States'
ORDER BY [Latitude] DESC;

-- Liste todas as cidades a oeste de Chicago, ordenadas de oeste para leste
SELECT * FROM north_american_cities
--WHERE [Longitude] < -87.629798
WHERE [Longitude] < (SELECT [Longitude] FROM north_american_cities WHERE [City] == 'Chicago')
ORDER BY [Longitude];

-- Liste as duas maiores cidades do México (por população)
SELECT * FROM north_american_cities
WHERE [Country] == 'Mexico'
ORDER BY [Population] DESC
LIMIT 2;

-- Liste a terceira e quarta maiores cidades (por população) nos Estados Unidos e sua população
SELECT * FROM north_american_cities
WHERE [Country] == 'United States'
ORDER BY [Population] DESC
LIMIT 2 OFFSET 2;

-- Exercício 6 — Tarefas
-- Encontre as vendas nacionais e internacionais de cada filme
SELECT [Title], [Domestic_sales], [International_sales]
FROM Movies 
INNER JOIN Boxoffice  
ON Movies.Id = Boxoffice.Movie_id

-- Mostre os números de vendas de cada filme que teve melhor desempenho internacional em vez de doméstico
SELECT [Title], [International_sales], [Domestic_sales]
FROM Movies 
INNER JOIN Boxoffice  
ON Movies.Id = Boxoffice.Movie_id
WHERE [International_sales] > [Domestic_sales]
ORDER BY [International_sales] DESC

-- Liste todos os filmes por suas classificações em ordem decrescente
SELECT [Title]
FROM Movies 
INNER JOIN Boxoffice  
ON Movies.Id = Boxoffice.Movie_id
ORDER BY [Rating] DESC

-- Exercício 7 — Tarefas
-- Encontre a lista de todos os prédios que possuem funcionários
SELECT 
    DISTINCT(Buildings.[Building_name])
FROM Employees 
LEFT JOIN Buildings  
ON Employees.[Building] = Buildings.[Building_name]

-- Encontre a lista de todos os edifícios e sua capacidade
SELECT * FROM Buildings;

-- Liste todos os prédios e as funções distintas dos funcionários em cada prédio (incluindo prédios vazios)
SELECT DISTINCT [Building_name], [Role] 
FROM Buildings 
LEFT JOIN Employees
ON Buildings.[Building_name] = Employees.[Building];

-- Exercício 8 — Tarefas
-- Encontre o nome e a função de todos os funcionários que não foram atribuídos a um edifício
SELECT [Name], [Role] 
FROM Employees 
WHERE [Building] IS NULL;

-- Encontre os nomes dos prédios que não possuem funcionários
SELECT [Building_name], [Building] 
FROM Buildings 
LEFT JOIN Employees
ON Buildings.[Building_name] = Employees.[Building]
WHERE [Building] IS NULL;

-- Exercício 9 — Tarefas
-- Liste todos os filmes e suas vendas combinadas em milhões de dólares
SELECT 
    [Title], 
    [Domestic_sales] + [International_sales] / 1000000 as sales 
FROM Movies
INNER JOIN Boxoffice 
  ON Movies.Id = Boxoffice.Movie_id;

-- Liste todos os filmes e suas classificações em porcentagem
SELECT [Title], [Rating] * 10 AS 'in percent'
FROM movies
INNER JOIN Boxoffice 
  ON Movies.Id = Boxoffice.Movie_id;

-- Liste todos os filmes que foram lançados em anos pares
SELECT [Title]
FROM movies
INNER JOIN Boxoffice 
  ON Movies.Id = Boxoffice.Movie_id
WHERE [Year] % 2 = 0;

--Exercício 10 — Tarefas
--Encontre o tempo mais longo que um funcionário esteve no estúdio
SELECT MAX([Years_employed]) AS max
FROM Employees

--Para cada função, encontre o número médio de anos empregados pelos funcionários nessa função
SELECT [Role], AVG([Years_employed]) AS Média
FROM Employees
GROUP BY [Role]

--Encontre o número total de anos de funcionários trabalhados em cada edifício
SELECT [Building], SUM([Years_employed]) AS TOTAL 
FROM Employees
GROUP BY [Building];

-- Exercício 11 — Tarefas
-- Encontre o número de Artistas no estúdio (sem a cláusula HAVING )
SELECT 
    COUNT([Role]) AS Total 
FROM employees
WHERE [Role] = 'Artist';

-- Encontre o número de funcionários de cada função no estúdio
SELECT [Role], COUNT(*) AS Total FROM employees
GROUP BY [Role];

-- Encontre o número total de anos empregados por todos os engenheiros
SELECT [Role], SUM([Years_employed]) as Total FROM employees
GROUP BY [Role]
HAVING [Role] = 'Engineer';

--Exercício 12 — Tarefas
--Encontre o número de filmes que cada diretor dirigiu
SELECT [Director], COUNT([Title]) AS Total FROM movies
GROUP BY [Director];

--Encontre o total de vendas domésticas e internacionais que podem ser atribuídas a cada diretor
SELECT 
    [Director],  
    SUM([Domestic_sales]+[International_sales]) AS Total  
FROM Movies
JOIN Boxoffice 
ON Movies.Id = Boxoffice.Movie_id
GROUP BY [Director];

-- Exercício 13 — Tarefas
-- Adicione a nova produção do estúdio, Toy Story 4 à lista de filmes (você pode usar qualquer diretor)
INSERT INTO Movies
VALUES(4,'Toy Story 4', 'John Lasseter', 2019, 100)

-- Toy Story 4 foi lançado com aclamação da crítica! Teve uma classificação de 8,7 , e fez 340 milhões no mercado interno e 270 milhões internacionalmente . Adicione o registro à BoxOfficetabela.
INSERT INTO Boxoffice 
VALUES(4,8.7, 340000000, 270000000)

-- Exercício 14 — Tarefas
-- O diretor de Vida de Inseto está incorreto, na verdade foi dirigido por John Lasseter
UPDATE Movies
SET [Director] = 'John Lasseter' 
WHERE [Title] = "A Bug's Life";

-- O ano em que Toy Story 2 foi lançado está incorreto, na verdade foi lançado em 1999
UPDATE Movies
SET [Year] = 1999
WHERE [Title] = 'Toy Story 2';

-- Tanto o título quanto o diretor de Toy Story 8 estão incorretos! O título deveria ser "Toy Story 3" e foi dirigido por Lee Unkrich
UPDATE Movies
SET 
    [Title] = 'Toy Story 3',
    [Director] = 'Lee Unkrich'
WHERE [Title] = 'Toy Story 8';

-- Exercício 15 — Tarefas
-- Este banco de dados está ficando muito grande, vamos remover todos os filmes lançados antes de 2005.
DELETE FROM Movies
WHERE [Year] < 2005;

-- Andrew Stanton também deixou o estúdio, então remova todos os filmes dirigidos por ele.
DELETE FROM Movies
WHERE [Director] = 'Andrew Stanton';

-- Exercício 16 — Tarefas
-- Crie uma nova tabela nomeada Database com as seguintes colunas:
-- – Name Uma string (texto) descrevendo o nome do banco de dados
-- – Version Um número (ponto flutuante) da última versão deste banco de dados
-- – Download_count Uma contagem inteira do número de vezes que este banco de dados foi baixado
-- Esta tabela não tem restrições.
CREATE TABLE IF NOT EXISTS Database(
    Name TEXT,
    Version FLOAT,
    Download_count INTEGER
);

-- Exercício 17 — Tarefas
-- Adicione uma coluna chamada Aspect_ratio com um tipo de dados FLOAT para armazenar a proporção em que cada filme foi lançado.
ALTER TABLE Movies
ADD Aspect_ratio FLOAT;

-- Adicione outra coluna chamada Language com um tipo de dados TEXT para armazenar o idioma no qual o filme foi lançado. Certifique-se de que o padrão para esse idioma seja o inglês .
ALTER TABLE Movies
  ADD COLUMN Language TEXT DEFAULT "English";

-- Exercício 18 — Tarefas
-- Infelizmente, chegamos ao fim de nossas aulas, vamos limpar removendo a tabela de filmes
DROP TABLE IF EXISTS Movies;

-- E solte a tabela BoxOffice também
DROP TABLE IF EXISTS Boxoffice;
/****** Script dos comandos SQL dos exercicios do site https://sqlbolt.com/ ******/
USE  master;

-- Exerc�cio 1 � Tarefas
-- Encontre o title de cada filme
SELECT [Title] FROM movies;

-- Encontre o director de cada filme
SELECT [Director] FROM movies;

-- Encontre o title e director de cada filme
SELECT [Title], [Director] FROM movies;

-- Encontre o title e year de cada filme
SELECT [Year], [Title] FROM movies;

-- Encontre all as informa��es sobre cada filme
SELECT * FROM movies;

-- Exerc�cio 2 � Tarefas
-- Encontre o filme com uma linha id de 6
SELECT [Title] FROM movies
WHERE [Id] == 6;

-- Encontre os filmes lan�ados nos year anos de 2000 a 2010
SELECT [Title] FROM movies
WHERE [Year] between 2000 AND 2010;

-- Encontre os filmes n�o lan�ados nos year anos entre 2000 e 2010
SELECT [Title] FROM movies
WHERE NOT [Year] between 2000 AND 2010;

-- Encontre os 5 primeiros filmes da Pixar e seus lan�amentos year
SELECT [Title] FROM movies
WHERE [Id] < 6
ORDER BY [Year];

-- Exerc�cio 3 � Tarefas
-- Encontre todos os filmes Toy Story
SELECT [Title] FROM movies
WHERE [Title] LIKE '%Toy%';

-- Encontre todos os filmes dirigidos por John Lasseter
SELECT [Title] FROM movies
WHERE [Director] LIKE '%Lasseter%';

-- Encontre todos os filmes (e diretores) n�o dirigidos por John Lasseter
SELECT [Title] FROM movies
WHERE NOT [Director] LIKE '%Lasseter%';

-- Encontre todos os filmes WALL-*
SELECT [Title] FROM movies
WHERE [Title] LIKE '%WALL%';

-- Exerc�cio 4 � Tarefas
-- Liste todos os diretores de filmes da Pixar (em ordem alfab�tica), sem duplicatas
SELECT DISTINCT([Director]) FROM movies
ORDER BY [Director] ASC;

-- Liste os �ltimos quatro filmes da Pixar lan�ados (ordenados do mais recente ao menos)
SELECT [Title] FROM movies
ORDER BY [Year] DESC
LIMIT 4;

-- Liste os cinco primeiros filmes da Pixar em ordem alfab�tica
SELECT * FROM movies
ORDER BY [Title] ASC
LIMIT 5;

-- Liste os pr�ximos cinco filmes da Pixar em ordem alfab�tica
SELECT * FROM movies
ORDER BY [Title] ASC
LIMIT 5 OFFSET 5;

-- Revis�o 1 - Tarefas
-- Liste todas as cidades canadenses e suas popula��es
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

-- Liste as duas maiores cidades do M�xico (por popula��o)
SELECT * FROM north_american_cities
WHERE [Country] == 'Mexico'
ORDER BY [Population] DESC
LIMIT 2;

-- Liste a terceira e quarta maiores cidades (por popula��o) nos Estados Unidos e sua popula��o
SELECT * FROM north_american_cities
WHERE [Country] == 'United States'
ORDER BY [Population] DESC
LIMIT 2 OFFSET 2;

-- Exerc�cio 6 � Tarefas
-- Encontre as vendas nacionais e internacionais de cada filme
SELECT [Title], [Domestic_sales], [International_sales]
FROM Movies 
INNER JOIN Boxoffice  
ON Movies.Id = Boxoffice.Movie_id

-- Mostre os n�meros de vendas de cada filme que teve melhor desempenho internacional em vez de dom�stico
SELECT [Title], [International_sales], [Domestic_sales]
FROM Movies 
INNER JOIN Boxoffice  
ON Movies.Id = Boxoffice.Movie_id
WHERE [International_sales] > [Domestic_sales]
ORDER BY [International_sales] DESC

-- Liste todos os filmes por suas classifica��es em ordem decrescente
SELECT [Title]
FROM Movies 
INNER JOIN Boxoffice  
ON Movies.Id = Boxoffice.Movie_id
ORDER BY [Rating] DESC

-- Exerc�cio 7 � Tarefas
-- Encontre a lista de todos os pr�dios que possuem funcion�rios
SELECT 
    DISTINCT(Buildings.[Building_name])
FROM Employees 
LEFT JOIN Buildings  
ON Employees.[Building] = Buildings.[Building_name]

-- Encontre a lista de todos os edif�cios e sua capacidade
SELECT * FROM Buildings;

-- Liste todos os pr�dios e as fun��es distintas dos funcion�rios em cada pr�dio (incluindo pr�dios vazios)
SELECT DISTINCT [Building_name], [Role] 
FROM Buildings 
LEFT JOIN Employees
ON Buildings.[Building_name] = Employees.[Building];

-- Exerc�cio 8 � Tarefas
-- Encontre o nome e a fun��o de todos os funcion�rios que n�o foram atribu�dos a um edif�cio
SELECT [Name], [Role] 
FROM Employees 
WHERE [Building] IS NULL;

-- Encontre os nomes dos pr�dios que n�o possuem funcion�rios
SELECT [Building_name], [Building] 
FROM Buildings 
LEFT JOIN Employees
ON Buildings.[Building_name] = Employees.[Building]
WHERE [Building] IS NULL;

-- Exerc�cio 9 � Tarefas
-- Liste todos os filmes e suas vendas combinadas em milh�es de d�lares
SELECT 
    [Title], 
    [Domestic_sales] + [International_sales] / 1000000 as sales 
FROM Movies
INNER JOIN Boxoffice 
  ON Movies.Id = Boxoffice.Movie_id;

-- Liste todos os filmes e suas classifica��es em porcentagem
SELECT [Title], [Rating] * 10 AS 'in percent'
FROM movies
INNER JOIN Boxoffice 
  ON Movies.Id = Boxoffice.Movie_id;

-- Liste todos os filmes que foram lan�ados em anos pares
SELECT [Title]
FROM movies
INNER JOIN Boxoffice 
  ON Movies.Id = Boxoffice.Movie_id
WHERE [Year] % 2 = 0;

--Exerc�cio 10 � Tarefas
--Encontre o tempo mais longo que um funcion�rio esteve no est�dio
SELECT MAX([Years_employed]) AS max
FROM Employees

--Para cada fun��o, encontre o n�mero m�dio de anos empregados pelos funcion�rios nessa fun��o
SELECT [Role], AVG([Years_employed]) AS M�dia
FROM Employees
GROUP BY [Role]

--Encontre o n�mero total de anos de funcion�rios trabalhados em cada edif�cio
SELECT [Building], SUM([Years_employed]) AS TOTAL 
FROM Employees
GROUP BY [Building];

-- Exerc�cio 11 � Tarefas
-- Encontre o n�mero de Artistas no est�dio (sem a cl�usula HAVING )
SELECT 
    COUNT([Role]) AS Total 
FROM employees
WHERE [Role] = 'Artist';

-- Encontre o n�mero de funcion�rios de cada fun��o no est�dio
SELECT [Role], COUNT(*) AS Total FROM employees
GROUP BY [Role];

-- Encontre o n�mero total de anos empregados por todos os engenheiros
SELECT [Role], SUM([Years_employed]) as Total FROM employees
GROUP BY [Role]
HAVING [Role] = 'Engineer';

--Exerc�cio 12 � Tarefas
--Encontre o n�mero de filmes que cada diretor dirigiu
SELECT [Director], COUNT([Title]) AS Total FROM movies
GROUP BY [Director];

--Encontre o total de vendas dom�sticas e internacionais que podem ser atribu�das a cada diretor
SELECT 
    [Director],  
    SUM([Domestic_sales]+[International_sales]) AS Total  
FROM Movies
JOIN Boxoffice 
ON Movies.Id = Boxoffice.Movie_id
GROUP BY [Director];

-- Exerc�cio 13 � Tarefas
-- Adicione a nova produ��o do est�dio, Toy Story 4 � lista de filmes (voc� pode usar qualquer diretor)
INSERT INTO Movies
VALUES(4,'Toy Story 4', 'John Lasseter', 2019, 100)

-- Toy Story 4 foi lan�ado com aclama��o da cr�tica! Teve uma classifica��o de 8,7 , e fez 340 milh�es no mercado interno e 270 milh�es internacionalmente . Adicione o registro � BoxOfficetabela.
INSERT INTO Boxoffice 
VALUES(4,8.7, 340000000, 270000000)

-- Exerc�cio 14 � Tarefas
-- O diretor de Vida de Inseto est� incorreto, na verdade foi dirigido por John Lasseter
UPDATE Movies
SET [Director] = 'John Lasseter' 
WHERE [Title] = "A Bug's Life";

-- O ano em que Toy Story 2 foi lan�ado est� incorreto, na verdade foi lan�ado em 1999
UPDATE Movies
SET [Year] = 1999
WHERE [Title] = 'Toy Story 2';

-- Tanto o t�tulo quanto o diretor de Toy Story 8 est�o incorretos! O t�tulo deveria ser "Toy Story 3" e foi dirigido por Lee Unkrich
UPDATE Movies
SET 
    [Title] = 'Toy Story 3',
    [Director] = 'Lee Unkrich'
WHERE [Title] = 'Toy Story 8';

-- Exerc�cio 15 � Tarefas
-- Este banco de dados est� ficando muito grande, vamos remover todos os filmes lan�ados antes de 2005.
DELETE FROM Movies
WHERE [Year] < 2005;

-- Andrew Stanton tamb�m deixou o est�dio, ent�o remova todos os filmes dirigidos por ele.
DELETE FROM Movies
WHERE [Director] = 'Andrew Stanton';

-- Exerc�cio 16 � Tarefas
-- Crie uma nova tabela nomeada Database com as seguintes colunas:
-- � Name Uma string (texto) descrevendo o nome do banco de dados
-- � Version Um n�mero (ponto flutuante) da �ltima vers�o deste banco de dados
-- � Download_count Uma contagem inteira do n�mero de vezes que este banco de dados foi baixado
-- Esta tabela n�o tem restri��es.
CREATE TABLE IF NOT EXISTS Database(
    Name TEXT,
    Version FLOAT,
    Download_count INTEGER
);

-- Exerc�cio 17 � Tarefas
-- Adicione uma coluna chamada Aspect_ratio com um tipo de dados FLOAT para armazenar a propor��o em que cada filme foi lan�ado.
ALTER TABLE Movies
ADD Aspect_ratio FLOAT;

-- Adicione outra coluna chamada Language com um tipo de dados TEXT para armazenar o idioma no qual o filme foi lan�ado. Certifique-se de que o padr�o para esse idioma seja o ingl�s .
ALTER TABLE Movies
  ADD COLUMN Language TEXT DEFAULT "English";

-- Exerc�cio 18 � Tarefas
-- Infelizmente, chegamos ao fim de nossas aulas, vamos limpar removendo a tabela de filmes
DROP TABLE IF EXISTS Movies;

-- E solte a tabela BoxOffice tamb�m
DROP TABLE IF EXISTS Boxoffice;
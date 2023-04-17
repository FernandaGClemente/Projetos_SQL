/****** Script dos comandos SQL dos exercicios do site https://www.hackerrank.com/domains/sql ******/

-- 1) Consulte todas as colunas de todas as cidades americanas na tabela CITY com populações maiores que 100000. O CountryCode para a América é USA.
SELECT * FROM city
WHERE [CountryCode] = 'USA' AND [Population] > 100000;

-- 2) Consulte o campo NAME para todas as cidades americanas na tabela CITY com populações maiores que 120000. O CountryCode para a América é USA.
SELECT [Name] FROM city
WHERE [CountryCode] = 'USA' AND [Population] > 120000;

-- 3) Consulte todas as colunas (atributos) para cada linha na tabela CITY .
SELECT * FROM city;

-- 4) Consulte todas as colunas de uma cidade em CITY com o ID 1661 .
SELECT * FROM city
WHERE [ID] = 1661;

-- 5) Consulte todos os atributos de cada cidade japonesa na tabela CITY . O COUNTRYCODE para o Japão é JPN.
SELECT * FROM city
WHERE [CountryCode] = 'JPN'

-- 6) Consulte os nomes de todas as cidades japonesas na tabela CITY . O COUNTRYCODE para o Japão é JPN.
SELECT [Name] FROM city
WHERE [CountryCode] = 'JPN'

-- 7) Consulte uma lista de CITY e STATE da tabela STATION .
SELECT [city], [state] FROM station;

-- 8) Consultar uma lista de nomes de CITY de STATION para cidades que tenham um número de ID par . Imprima os resultados em qualquer ordem, mas exclua as duplicatas da resposta.
SELECT DISTINCT([City]) FROM station
WHERE [ID] % 2 = 0;

-- 9) Encontre a diferença entre o número total de entradas CITY na tabela e o número de entradas CITY distintas na tabela.
SELECT (COUNT([city]) - COUNT(DISTINCT([city]))) as Total
FROM station

-- 10) Consultar as duas cidades em STATION com os nomes de CITY mais curtos e mais longos , bem como seus respectivos comprimentos (ou seja: número de caracteres no nome). 
-- Se houver mais de uma cidade menor ou maior, escolha a que vem primeiro quando ordenada alfabeticamente.

Falta 49
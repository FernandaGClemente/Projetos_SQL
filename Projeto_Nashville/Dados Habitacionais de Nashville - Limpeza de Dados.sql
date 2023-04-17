/****** Script dos comandos SQL - Limpeza de dados da Tabela Nashville ******/

SELECT * FROM [Projeto_SQL_Nashville].[dbo].[Nashville] -- Total de Linhas 56.477

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

-- 1 - Padronizar formato de data
SELECT [Data_de_venda], CONVERT(Date,[Data_de_venda])
FROM [Projeto_SQL_Nashville].[dbo].[Nashville]

Update [Nashville]
SET [Data_de_venda] = CONVERT(Date,[Data_de_venda])

-- Se n�o atualizar corretamente a tabela
	ALTER TABLE [Nashville]
	Add [Data_de_venda_formatada] Date;

	Update [Nashville]
	SET [Data_de_venda_formatada] = CONVERT(Date,[Data_de_venda])

	SELECT [Data_de_venda_formatada], CONVERT(Date,[Data_de_venda]) as Data_de_venda
	FROM [Projeto_SQL_Nashville].[dbo].[Nashville]

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

-- 2 - Preencher dados de endere�o de propriedade 

SELECT DISTINCT([ID_da_encomenda]) FROM [Projeto_SQL_Nashville].[dbo].[Nashville] -- Resultou em 48.559 linhas (ID iguais = 56.477 - 48.559 = 7.918)
SELECT * FROM [Projeto_SQL_Nashville].[dbo].[Nashville] WHERE [Endereco_da_propriedade] is null -- Resultou em 29 linhas em vazia. 

-- a) Procura identificar quais s�o os endere�os das propriedade que tem o [ID_da_encomenda] iguais e quais est�o vazios, substituindo o vazio pelo o endere�o igual 
SELECT 
	tb_1.[ID_da_encomenda], 
	tb_1.[Endereco_da_propriedade], 
	tb_2.[ID_da_encomenda], 
	tb_2.[Endereco_da_propriedade], 
	-- ISNULL: Permite retornar um valor alternativo quando uma express�o � NULL, ou seja, se o valor da coluna [Endereco_da_propriedade] da tb_1 for igual a NULL, retorne o [Endereco_da_propriedade] da tb_2
	ISNULL(tb_1.[Endereco_da_propriedade],tb_2.[Endereco_da_propriedade])    
FROM [Projeto_SQL_Nashville].[dbo].[Nashville] tb_1
JOIN [Projeto_SQL_Nashville].[dbo].[Nashville] tb_2 -- Auto relacionamento - SELF JOIN
ON tb_1.[ID_da_encomenda] = tb_2.[ID_da_encomenda] AND tb_1.[ID_unico] <> tb_2.[ID_unico] -- Existe 7.918 de [ID_da_encomenda] iguais, mas ser�o utilizados apenas nas 29 linhas que tem [Endereco_da_propriedade] igual a NULL
WHERE tb_1.[Endereco_da_propriedade] is null

-- b) Atualiza a tabela tb_1 com o valor dos endere�os da propriedade da tabela tb_2 que est�o vazios e que tem [ID_da_encomenda] iguais
Update tb_1
SET [Endereco_da_propriedade] = ISNULL(tb_1.[Endereco_da_propriedade],tb_2.[Endereco_da_propriedade]) 
FROM [Projeto_SQL_Nashville].[dbo].[Nashville] tb_1
JOIN [Projeto_SQL_Nashville].[dbo].[Nashville] tb_2 -- Auto relacionamento - SELF JOIN
ON tb_1.[ID_da_encomenda] = tb_2.[ID_da_encomenda] AND tb_1.[ID_unico] <> tb_2.[ID_unico] -- Existe 7.918 de [ID_da_encomenda] iguais, mas ser�o utilizados apenas nas 29 linhas que tem [Endereco_da_propriedade] igual a NULL
WHERE tb_1.[Endereco_da_propriedade] is null; -- Resultou em 29 linhas afetadas

SELECT * FROM [Projeto_SQL_Nashville].[dbo].[Nashville] WHERE [Endereco_da_propriedade] is null -- N�o existe mais nenhuma linha da coluna [Endereco_da_propriedade] com valores NULL

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

-- 3 - Dividindo o endere�o em colunas individuais (endere�o, cidade, estado)

-- a) Divis�o da coluna de endere�o da propriedade
SELECT 
	[Endereco_da_propriedade], -- Endere�o completo
	SUBSTRING([Endereco_da_propriedade], 1, CHARINDEX(',', [Endereco_da_propriedade]) -1 ) as [EnderecoAntesDaVirgula], -- Extrai o texto antes da virgula
	SUBSTRING([Endereco_da_propriedade], CHARINDEX(',', [Endereco_da_propriedade]) + 1 , LEN([Endereco_da_propriedade])) as [EnderecoDepoisDaVirgula] -- Extrai o texto depois da virgula
	-- SUBSTRING: Extrai alguns caracteres de dentro de um texto ("Texto" , N�daPosi��oInicial, N�daQtdeDeCaracteres)
	-- CHARINDEX: Descobre a posi��o de um determinado caractere dentro de um texto ("Busca" , "Texto")
FROM [Projeto_SQL_Nashville].[dbo].[Nashville]

-- b) Cria��o da coluna "Divisao_endereco_da_propriedade"
ALTER TABLE [Nashville]
ADD [Divisao_endereco_da_propriedade] Nvarchar(255);

-- c) Atualizando a coluna "Divisao_endereco_da_propriedade" com o texto antes da virgula
UPDATE [Nashville]
SET [Divisao_endereco_da_propriedade] = SUBSTRING([Endereco_da_propriedade], 1, CHARINDEX(',', [Endereco_da_propriedade]) -1 ) 

-- d) Cria��o da coluna "Divisao_endereco_da_cidade" 
ALTER TABLE [Nashville]
ADD [Divisao_endereco_da_cidade] Nvarchar(255);

-- e) Atualizando a coluna "Divisao_endereco_da_cidade" com o texto antes da virgula
UPDATE [Nashville]
SET [Divisao_endereco_da_cidade] = SUBSTRING([Endereco_da_propriedade], CHARINDEX(',', [Endereco_da_propriedade]) + 1 , LEN([Endereco_da_propriedade]))

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

-- a) Divis�o da coluna de endere�o do propriet�rio
SELECT
	[Endere�o_do_Proprietario],
	PARSENAME(REPLACE([Endere�o_do_Proprietario], ',', '.') , 3) as [EnderecoAntesDo1�ponto],
	PARSENAME(REPLACE([Endere�o_do_Proprietario], ',', '.') , 2) as [EnderecoAntesDo2�ponto],
	PARSENAME(REPLACE([Endere�o_do_Proprietario], ',', '.') , 1) as [EnderecoAntesDo3�ponto]
	-- PARSENAME: Retorna a parte especificada de um nome de objeto ('NomeDoObjeto' , parte_objeto)
	-- REPLACE: Substitui um determinado texto por outro texto ("Texto" ou [NomeDaColuna], "TextoSubstitu�do", "TextoSubstituto")
FROM [Projeto_SQL_Nashville].[dbo].[Nashville]

-- b) Cria��o da coluna "Divisao_endereco_do_proprietario"
ALTER TABLE [Nashville]
ADD [Divisao_endereco_do_proprietario] Nvarchar(255);

-- c) Atualizando a coluna "Divisao_endereco_do_proprietario" com o texto antes do primeiro ponto
UPDATE [Nashville]
SET [Divisao_endereco_do_proprietario] = PARSENAME(REPLACE([Endere�o_do_Proprietario], ',', '.'),3)

-- d) Cria��o da coluna "Divisao_endereco_da_cidade"
ALTER TABLE [Nashville]
ADD [Divisao_endereco_do_proprietario_cidade] Nvarchar(255);

-- e) Atualizando a coluna "Divisao_endereco_do_proprietario_cidade" com o texto antes do segundo ponto
UPDATE [Nashville]
SET [Divisao_endereco_do_proprietario_cidade] = PARSENAME(REPLACE([Endere�o_do_Proprietario], ',', '.'),2)

-- f) Cria��o da coluna "Divisao_endereco_do_proprietario_estado"
ALTER TABLE [Nashville]
ADD [Divisao_endereco_do_proprietario_estado] Nvarchar(255);

-- g) Atualizando a coluna "Divisao_endereco_do_proprietario_estado" com o texto antes do terceiro ponto
UPDATE [Nashville]
SET [Divisao_endereco_do_proprietario_estado] = PARSENAME(REPLACE([Endere�o_do_Proprietario], ',', '.'),1)

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

-- 4 - Altere S e N para Sim e N�o da coluna "Vendido como Vago"

-- a) Realizar um agrupando e uma contagem dos valores distintos da coluna "Vendido como Vago" 
SELECT 
	DISTINCT([Vendido_como_vago]), 
	COUNT([Vendido_como_vago])
FROM [Projeto_SQL_Nashville].[dbo].[Nashville]
GROUP BY [Vendido_como_vago]
ORDER BY 2 -- Retorna: Y 52 vezes, N 399 vezes, Yes 4623 vezes e No 51403 vezes

-- b) Consulta para verificar a substitui��o dos valores Y para Yes e N para No
SELECT 
	[Vendido_como_vago],
	CASE 
		WHEN [Vendido_como_vago] = 'Y' THEN 'Yes' -- Quando a coluna for igual a 'Y' retorne 'Yes'
		WHEN [Vendido_como_vago] = 'N' THEN 'No' -- Quando a coluna for igual a 'N' retorne 'No'
		ELSE [Vendido_como_vago]
	END 
FROM [Projeto_SQL_Nashville].[dbo].[Nashville]

-- c) Atualizando a coluna "Vendido_como_vago" usando a condi��o CASE 
UPDATE [Nashville]
SET [Vendido_como_vago] =	
	CASE 
		WHEN [Vendido_como_vago] = 'Y' THEN 'Yes' -- Quando a coluna for igual a 'Y' retorne 'Yes'
		WHEN [Vendido_como_vago] = 'N' THEN 'No' -- Quando a coluna for igual a 'N' retorne 'No'
		ELSE [Vendido_como_vago]
	END 

-- Verificando se altera��o foi feita com sucesso
SELECT 
	DISTINCT([Vendido_como_vago]), 
	COUNT([Vendido_como_vago])
FROM [Projeto_SQL_Nashville].[dbo].[Nashville]
GROUP BY [Vendido_como_vago]
ORDER BY 2 -- Retorna: Yes 4675 vezes e No 51802 vezes

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

-- 5 - Remover Duplicadas

-- a) Criando um CTE: � uma tabela tempor�ria que podemos criar e reaproveitar ao longo do c�digo.

WITH NumeroDeLinhas_cte AS(
	SELECT 
		*,
		-- ROW_NUMEBER(): Atribui um n�mero �nico e sequencial a cada linha em um conjunto de dados. Garante que n�o haja duas linhas com o mesmo n�mero, mesmo se houver duplicatas.
		ROW_NUMBER() OVER (PARTITION BY [ID_da_encomenda], [Endereco_da_propriedade], [Preco_de_venda], [Data_de_venda], [Referencia_Legal] ORDER BY [ID_unico]) as Classificacao
	FROM [Projeto_SQL_Nashville].[dbo].[Nashville])

SELECT * From NumeroDeLinhas_cte
--WHERE Classificacao = 1
WHERE Classificacao = 2 -- Resulta em uma tabela temporaria com 104 linhas duplicadas

-- Conclus�o: O conjunto de dados ser� classificado com base na coluna Classificacao sendo dividida em 2 partes: 
-- O 1� grupo ter�o os dados distintos nas colunas [ID_da_encomenda], [Endereco_da_propriedade], [Preco_de_venda], [Data_de_venda], [Referencia_Legal]
-- O 2� grupo ter�o os dados duplicados nas colunas [ID_da_encomenda], [Endereco_da_propriedade], [Preco_de_venda], [Data_de_venda], [Referencia_Legal]

-- b) Exclus�o das linhas duplicadas 

WITH NumeroDeLinhas_cte AS(
	SELECT 
		*,
		-- ROW_NUMEBER(): Atribui um n�mero �nico e sequencial a cada linha em um conjunto de dados. Garante que n�o haja duas linhas com o mesmo n�mero, mesmo se houver duplicatas.
		ROW_NUMBER() OVER (PARTITION BY [ID_da_encomenda], [Endereco_da_propriedade], [Preco_de_venda], [Data_de_venda], [Referencia_Legal] ORDER BY [ID_unico]) as Classificacao
	FROM [Projeto_SQL_Nashville].[dbo].[Nashville])

-- Comando DELETE: Excluir os dados da tabela (Exclus�o dos valores das linhas) >> DELETE FROM <NomeDaCTE> WHERE [NomeDaColunaQueTer�LinhaExcluida] = "Valor/Linha de Identifica��o"
DELETE FROM NumeroDeLinhas_cte
WHERE Classificacao = 2

-- c) Verificando se exclus�o foi feita com sucesso 

SELECT * FROM [Projeto_SQL_Nashville].[dbo].[Nashville] -- Total de Linhas 56.373

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

-- 6 - Excluir colunas n�o ser�o mais utilizadas 

ALTER TABLE [Projeto_SQL_Nashville].[dbo].[Nashville]
DROP COLUMN [Endere�o_do_Proprietario], [Endereco_da_propriedade], [Data_de_venda]

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------



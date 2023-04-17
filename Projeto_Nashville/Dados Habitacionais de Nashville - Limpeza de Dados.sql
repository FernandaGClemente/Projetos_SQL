/****** Script dos comandos SQL - Limpeza de dados da Tabela Nashville ******/

SELECT * FROM [Projeto_SQL_Nashville].[dbo].[Nashville] -- Total de Linhas 56.477

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

-- 1 - Padronizar formato de data
SELECT [Data_de_venda], CONVERT(Date,[Data_de_venda])
FROM [Projeto_SQL_Nashville].[dbo].[Nashville]

Update [Nashville]
SET [Data_de_venda] = CONVERT(Date,[Data_de_venda])

-- Se não atualizar corretamente a tabela
	ALTER TABLE [Nashville]
	Add [Data_de_venda_formatada] Date;

	Update [Nashville]
	SET [Data_de_venda_formatada] = CONVERT(Date,[Data_de_venda])

	SELECT [Data_de_venda_formatada], CONVERT(Date,[Data_de_venda]) as Data_de_venda
	FROM [Projeto_SQL_Nashville].[dbo].[Nashville]

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

-- 2 - Preencher dados de endereço de propriedade 

SELECT DISTINCT([ID_da_encomenda]) FROM [Projeto_SQL_Nashville].[dbo].[Nashville] -- Resultou em 48.559 linhas (ID iguais = 56.477 - 48.559 = 7.918)
SELECT * FROM [Projeto_SQL_Nashville].[dbo].[Nashville] WHERE [Endereco_da_propriedade] is null -- Resultou em 29 linhas em vazia. 

-- a) Procura identificar quais são os endereços das propriedade que tem o [ID_da_encomenda] iguais e quais estão vazios, substituindo o vazio pelo o endereço igual 
SELECT 
	tb_1.[ID_da_encomenda], 
	tb_1.[Endereco_da_propriedade], 
	tb_2.[ID_da_encomenda], 
	tb_2.[Endereco_da_propriedade], 
	-- ISNULL: Permite retornar um valor alternativo quando uma expressão é NULL, ou seja, se o valor da coluna [Endereco_da_propriedade] da tb_1 for igual a NULL, retorne o [Endereco_da_propriedade] da tb_2
	ISNULL(tb_1.[Endereco_da_propriedade],tb_2.[Endereco_da_propriedade])    
FROM [Projeto_SQL_Nashville].[dbo].[Nashville] tb_1
JOIN [Projeto_SQL_Nashville].[dbo].[Nashville] tb_2 -- Auto relacionamento - SELF JOIN
ON tb_1.[ID_da_encomenda] = tb_2.[ID_da_encomenda] AND tb_1.[ID_unico] <> tb_2.[ID_unico] -- Existe 7.918 de [ID_da_encomenda] iguais, mas serão utilizados apenas nas 29 linhas que tem [Endereco_da_propriedade] igual a NULL
WHERE tb_1.[Endereco_da_propriedade] is null

-- b) Atualiza a tabela tb_1 com o valor dos endereços da propriedade da tabela tb_2 que estão vazios e que tem [ID_da_encomenda] iguais
Update tb_1
SET [Endereco_da_propriedade] = ISNULL(tb_1.[Endereco_da_propriedade],tb_2.[Endereco_da_propriedade]) 
FROM [Projeto_SQL_Nashville].[dbo].[Nashville] tb_1
JOIN [Projeto_SQL_Nashville].[dbo].[Nashville] tb_2 -- Auto relacionamento - SELF JOIN
ON tb_1.[ID_da_encomenda] = tb_2.[ID_da_encomenda] AND tb_1.[ID_unico] <> tb_2.[ID_unico] -- Existe 7.918 de [ID_da_encomenda] iguais, mas serão utilizados apenas nas 29 linhas que tem [Endereco_da_propriedade] igual a NULL
WHERE tb_1.[Endereco_da_propriedade] is null; -- Resultou em 29 linhas afetadas

SELECT * FROM [Projeto_SQL_Nashville].[dbo].[Nashville] WHERE [Endereco_da_propriedade] is null -- Não existe mais nenhuma linha da coluna [Endereco_da_propriedade] com valores NULL

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

-- 3 - Dividindo o endereço em colunas individuais (endereço, cidade, estado)

-- a) Divisão da coluna de endereço da propriedade
SELECT 
	[Endereco_da_propriedade], -- Endereço completo
	SUBSTRING([Endereco_da_propriedade], 1, CHARINDEX(',', [Endereco_da_propriedade]) -1 ) as [EnderecoAntesDaVirgula], -- Extrai o texto antes da virgula
	SUBSTRING([Endereco_da_propriedade], CHARINDEX(',', [Endereco_da_propriedade]) + 1 , LEN([Endereco_da_propriedade])) as [EnderecoDepoisDaVirgula] -- Extrai o texto depois da virgula
	-- SUBSTRING: Extrai alguns caracteres de dentro de um texto ("Texto" , N°daPosiçãoInicial, N°daQtdeDeCaracteres)
	-- CHARINDEX: Descobre a posição de um determinado caractere dentro de um texto ("Busca" , "Texto")
FROM [Projeto_SQL_Nashville].[dbo].[Nashville]

-- b) Criação da coluna "Divisao_endereco_da_propriedade"
ALTER TABLE [Nashville]
ADD [Divisao_endereco_da_propriedade] Nvarchar(255);

-- c) Atualizando a coluna "Divisao_endereco_da_propriedade" com o texto antes da virgula
UPDATE [Nashville]
SET [Divisao_endereco_da_propriedade] = SUBSTRING([Endereco_da_propriedade], 1, CHARINDEX(',', [Endereco_da_propriedade]) -1 ) 

-- d) Criação da coluna "Divisao_endereco_da_cidade" 
ALTER TABLE [Nashville]
ADD [Divisao_endereco_da_cidade] Nvarchar(255);

-- e) Atualizando a coluna "Divisao_endereco_da_cidade" com o texto antes da virgula
UPDATE [Nashville]
SET [Divisao_endereco_da_cidade] = SUBSTRING([Endereco_da_propriedade], CHARINDEX(',', [Endereco_da_propriedade]) + 1 , LEN([Endereco_da_propriedade]))

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

-- a) Divisão da coluna de endereço do proprietário
SELECT
	[Endereço_do_Proprietario],
	PARSENAME(REPLACE([Endereço_do_Proprietario], ',', '.') , 3) as [EnderecoAntesDo1°ponto],
	PARSENAME(REPLACE([Endereço_do_Proprietario], ',', '.') , 2) as [EnderecoAntesDo2°ponto],
	PARSENAME(REPLACE([Endereço_do_Proprietario], ',', '.') , 1) as [EnderecoAntesDo3°ponto]
	-- PARSENAME: Retorna a parte especificada de um nome de objeto ('NomeDoObjeto' , parte_objeto)
	-- REPLACE: Substitui um determinado texto por outro texto ("Texto" ou [NomeDaColuna], "TextoSubstituído", "TextoSubstituto")
FROM [Projeto_SQL_Nashville].[dbo].[Nashville]

-- b) Criação da coluna "Divisao_endereco_do_proprietario"
ALTER TABLE [Nashville]
ADD [Divisao_endereco_do_proprietario] Nvarchar(255);

-- c) Atualizando a coluna "Divisao_endereco_do_proprietario" com o texto antes do primeiro ponto
UPDATE [Nashville]
SET [Divisao_endereco_do_proprietario] = PARSENAME(REPLACE([Endereço_do_Proprietario], ',', '.'),3)

-- d) Criação da coluna "Divisao_endereco_da_cidade"
ALTER TABLE [Nashville]
ADD [Divisao_endereco_do_proprietario_cidade] Nvarchar(255);

-- e) Atualizando a coluna "Divisao_endereco_do_proprietario_cidade" com o texto antes do segundo ponto
UPDATE [Nashville]
SET [Divisao_endereco_do_proprietario_cidade] = PARSENAME(REPLACE([Endereço_do_Proprietario], ',', '.'),2)

-- f) Criação da coluna "Divisao_endereco_do_proprietario_estado"
ALTER TABLE [Nashville]
ADD [Divisao_endereco_do_proprietario_estado] Nvarchar(255);

-- g) Atualizando a coluna "Divisao_endereco_do_proprietario_estado" com o texto antes do terceiro ponto
UPDATE [Nashville]
SET [Divisao_endereco_do_proprietario_estado] = PARSENAME(REPLACE([Endereço_do_Proprietario], ',', '.'),1)

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

-- 4 - Altere S e N para Sim e Não da coluna "Vendido como Vago"

-- a) Realizar um agrupando e uma contagem dos valores distintos da coluna "Vendido como Vago" 
SELECT 
	DISTINCT([Vendido_como_vago]), 
	COUNT([Vendido_como_vago])
FROM [Projeto_SQL_Nashville].[dbo].[Nashville]
GROUP BY [Vendido_como_vago]
ORDER BY 2 -- Retorna: Y 52 vezes, N 399 vezes, Yes 4623 vezes e No 51403 vezes

-- b) Consulta para verificar a substituição dos valores Y para Yes e N para No
SELECT 
	[Vendido_como_vago],
	CASE 
		WHEN [Vendido_como_vago] = 'Y' THEN 'Yes' -- Quando a coluna for igual a 'Y' retorne 'Yes'
		WHEN [Vendido_como_vago] = 'N' THEN 'No' -- Quando a coluna for igual a 'N' retorne 'No'
		ELSE [Vendido_como_vago]
	END 
FROM [Projeto_SQL_Nashville].[dbo].[Nashville]

-- c) Atualizando a coluna "Vendido_como_vago" usando a condição CASE 
UPDATE [Nashville]
SET [Vendido_como_vago] =	
	CASE 
		WHEN [Vendido_como_vago] = 'Y' THEN 'Yes' -- Quando a coluna for igual a 'Y' retorne 'Yes'
		WHEN [Vendido_como_vago] = 'N' THEN 'No' -- Quando a coluna for igual a 'N' retorne 'No'
		ELSE [Vendido_como_vago]
	END 

-- Verificando se alteração foi feita com sucesso
SELECT 
	DISTINCT([Vendido_como_vago]), 
	COUNT([Vendido_como_vago])
FROM [Projeto_SQL_Nashville].[dbo].[Nashville]
GROUP BY [Vendido_como_vago]
ORDER BY 2 -- Retorna: Yes 4675 vezes e No 51802 vezes

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

-- 5 - Remover Duplicadas

-- a) Criando um CTE: É uma tabela temporária que podemos criar e reaproveitar ao longo do código.

WITH NumeroDeLinhas_cte AS(
	SELECT 
		*,
		-- ROW_NUMEBER(): Atribui um número único e sequencial a cada linha em um conjunto de dados. Garante que não haja duas linhas com o mesmo número, mesmo se houver duplicatas.
		ROW_NUMBER() OVER (PARTITION BY [ID_da_encomenda], [Endereco_da_propriedade], [Preco_de_venda], [Data_de_venda], [Referencia_Legal] ORDER BY [ID_unico]) as Classificacao
	FROM [Projeto_SQL_Nashville].[dbo].[Nashville])

SELECT * From NumeroDeLinhas_cte
--WHERE Classificacao = 1
WHERE Classificacao = 2 -- Resulta em uma tabela temporaria com 104 linhas duplicadas

-- Conclusão: O conjunto de dados será classificado com base na coluna Classificacao sendo dividida em 2 partes: 
-- O 1° grupo terão os dados distintos nas colunas [ID_da_encomenda], [Endereco_da_propriedade], [Preco_de_venda], [Data_de_venda], [Referencia_Legal]
-- O 2° grupo terão os dados duplicados nas colunas [ID_da_encomenda], [Endereco_da_propriedade], [Preco_de_venda], [Data_de_venda], [Referencia_Legal]

-- b) Exclusão das linhas duplicadas 

WITH NumeroDeLinhas_cte AS(
	SELECT 
		*,
		-- ROW_NUMEBER(): Atribui um número único e sequencial a cada linha em um conjunto de dados. Garante que não haja duas linhas com o mesmo número, mesmo se houver duplicatas.
		ROW_NUMBER() OVER (PARTITION BY [ID_da_encomenda], [Endereco_da_propriedade], [Preco_de_venda], [Data_de_venda], [Referencia_Legal] ORDER BY [ID_unico]) as Classificacao
	FROM [Projeto_SQL_Nashville].[dbo].[Nashville])

-- Comando DELETE: Excluir os dados da tabela (Exclusão dos valores das linhas) >> DELETE FROM <NomeDaCTE> WHERE [NomeDaColunaQueTeráLinhaExcluida] = "Valor/Linha de Identificação"
DELETE FROM NumeroDeLinhas_cte
WHERE Classificacao = 2

-- c) Verificando se exclusão foi feita com sucesso 

SELECT * FROM [Projeto_SQL_Nashville].[dbo].[Nashville] -- Total de Linhas 56.373

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

-- 6 - Excluir colunas não serão mais utilizadas 

ALTER TABLE [Projeto_SQL_Nashville].[dbo].[Nashville]
DROP COLUMN [Endereço_do_Proprietario], [Endereco_da_propriedade], [Data_de_venda]

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------



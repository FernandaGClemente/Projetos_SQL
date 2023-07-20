/****** Script dos comandos em SQL ******/

-- Total de contratação, Demissão, Funcionários ativos, Salario total e Média salarial
SELECT 
	COUNT([Data de Contratacao]) AS 'Total de Contratação', 
	COUNT([Data de Demissao]) AS 'Total de Demissão',
	COUNT([Data de Contratacao])-COUNT([Data de Demissao]) AS 'Total de funcionários ativos',
	ROUND((((CAST((COUNT([Data de Contratacao])+COUNT([Data de Demissao]))/2 AS FLOAT)) / CAST(COUNT([Data de Contratacao])-COUNT([Data de Demissao]) AS FLOAT)) * 100),2) as '% Turnover',
	ROUND(SUM([Salario Base]+[Beneficios]+[VT]+[VR]+[Impostos]),2) as 'Salário total',
	ROUND(AVG([Salario Base]+[Beneficios]+[VT]+[VR]+[Impostos]),2) as 'Média salarial'
FROM [Projeto_RH].[dbo].[BaseFuncionario];

-- Total de contratações e de demissões por ano
SELECT
    Ano,
    SUM(Admissao) as 'Total de Admissão',
    SUM(Demissao) as 'Total de Demissão'
FROM
   (SELECT 
		YEAR([Data de Contratacao]) as Ano,
        COUNT([Data de Contratacao]) as Admissao,
        0 as Demissao
    FROM [Projeto_RH].[dbo].[BaseFuncionario]
    GROUP BY YEAR([Data de Contratacao])
	UNION ALL
	SELECT 
		YEAR([Data de Demissao]) as Ano,
        0 as Admissao,
        COUNT([Data de Demissao]) as Demissao
	FROM [Projeto_RH].[dbo].[BaseFuncionario]
    GROUP BY YEAR([Data de Demissao])) as TabelaAuxiliar
GROUP BY Ano
HAVING Ano IS NOT NULL
ORDER BY Ano;

-- Total de funcionarios ativos por cidade
SELECT 
	[Cidade/Estado],
	COUNT([Data de Contratacao])-COUNT([Data de Demissao]) as 'Total de funcionários ativos'
FROM(SELECT 
		*,
		PARSENAME(REPLACE(REPLACE([Endereço],'.',''),',','.'),4) as 'Rua',
		PARSENAME(REPLACE(REPLACE([Endereço],'.',''),',','.'),3) as 'Complemento',
		PARSENAME(REPLACE(REPLACE([Endereço],'.',''),',','.'),2) as 'Cidade/Estado',
		PARSENAME(REPLACE(REPLACE([Endereço],'.',''),',','.'),1) as 'CEP'
	FROM [Projeto_RH].[dbo].[BaseFuncionario]) as TabelaAuxiliar
GROUP BY [Cidade/Estado]
ORDER BY 'Total de funcionários ativos' DESC;

-- Total de funcionarios ativos por faixa de tempo de empresa
SELECT 
	FaixaDeTempoDeEmpresa,
	COUNT([Data de Contratacao])-COUNT([Data de Demissao]) as TotalDeFuncionáriosAtivos
FROM(SELECT
		[Data de Contratacao],
		[Data de Demissao],
		(CASE 
		WHEN AnosDeEmpresa <= 5 THEN '0-5 anos' 
		WHEN AnosDeEmpresa <= 10 THEN '5-10 anos'
		WHEN AnosDeEmpresa <= 15 THEN '10-15 anos'
		WHEN AnosDeEmpresa <= 20 THEN '15-20 anos'
		ELSE 'Acima de 20 anos' END) as FaixaDeTempoDeEmpresa
	FROM(SELECT
			[Data de Contratacao],
			[Data de Demissao],
			(CASE WHEN [Data de Demissao] IS NOT NULL THEN YEAR([Data de Demissao])-YEAR([Data de Contratacao])
			ELSE YEAR(GETDATE())-YEAR([Data de Contratacao]) END) as AnosDeEmpresa
		FROM [Projeto_RH].[dbo].[BaseFuncionario]) as TabelaAuxiliar) as Tabela
GROUP BY FaixaDeTempoDeEmpresa
ORDER BY TotalDeFuncionáriosAtivos DESC;

-- Total de contratações por área 
SELECT [Área], COUNT([Data de Contratacao]) as 'Total' FROM [Projeto_RH].[dbo].[BaseFuncionario] GROUP BY [Área] ORDER BY 'Total' DESC;

-- Total de demissões por área 
SELECT [Área], COUNT([Data de Demissao]) as 'Total' FROM [Projeto_RH].[dbo].[BaseFuncionario] GROUP BY [Área] ORDER BY 'Total' DESC;

-- Total de contratações por nível
SELECT [Nível], COUNT([Data de Contratacao]) as 'Total' FROM [Projeto_RH].[dbo].[BaseFuncionario] GROUP BY [Nível] ORDER BY 'Total' DESC;

-- Total de demissões por nível
SELECT [Nível], COUNT([Data de Demissao]) as 'Total' FROM [Projeto_RH].[dbo].[BaseFuncionario] GROUP BY [Nível] ORDER BY 'Total' DESC;

-- Total de contratações por anos de empresa
SELECT 
	FaixaDeTempoDeEmpresa,
	COUNT([Data de Contratacao]) as 'Total'
FROM(SELECT
		[Data de Contratacao],
		[Data de Demissao],
		(CASE 
		WHEN AnosDeEmpresa <= 5 THEN '0-5 anos' 
		WHEN AnosDeEmpresa <= 10 THEN '5-10 anos'
		WHEN AnosDeEmpresa <= 15 THEN '10-15 anos'
		WHEN AnosDeEmpresa <= 20 THEN '15-20 anos'
		ELSE 'Acima de 20 anos' END) as FaixaDeTempoDeEmpresa
	FROM(SELECT
			[Data de Contratacao],
			[Data de Demissao],
			(CASE WHEN [Data de Demissao] IS NOT NULL THEN YEAR([Data de Demissao])-YEAR([Data de Contratacao])
			ELSE YEAR(GETDATE())-YEAR([Data de Contratacao]) END) as AnosDeEmpresa
		FROM [Projeto_RH].[dbo].[BaseFuncionario]) as TabelaAuxiliar) as Tabela
GROUP BY FaixaDeTempoDeEmpresa
ORDER BY 'Total' DESC;

-- Total de demissões por anos de empresa
SELECT 
	FaixaDeTempoDeEmpresa,
	COUNT([Data de Demissao]) as 'Total'
FROM(SELECT
		[Data de Contratacao],
		[Data de Demissao],
		(CASE 
		WHEN AnosDeEmpresa <= 5 THEN '0-5 anos' 
		WHEN AnosDeEmpresa <= 10 THEN '5-10 anos'
		WHEN AnosDeEmpresa <= 15 THEN '10-15 anos'
		WHEN AnosDeEmpresa <= 20 THEN '15-20 anos'
		ELSE 'Acima de 20 anos' END) as FaixaDeTempoDeEmpresa
	FROM(SELECT
			[Data de Contratacao],
			[Data de Demissao],
			(CASE WHEN [Data de Demissao] IS NOT NULL THEN YEAR([Data de Demissao])-YEAR([Data de Contratacao])
			ELSE YEAR(GETDATE())-YEAR([Data de Contratacao]) END) as AnosDeEmpresa
		FROM [Projeto_RH].[dbo].[BaseFuncionario]) as TabelaAuxiliar) as Tabela
GROUP BY FaixaDeTempoDeEmpresa
ORDER BY 'Total' DESC;

-- Total de contratações por faixa etária
SELECT
	FaixaEtaria,
	COUNT([Data de Contratacao]) as TotalDeContratações
FROM(SELECT
		[Data de Contratacao],
		[Data de Demissao],
		(CASE 
		WHEN Idade <= 30 THEN '18-30 anos' 
		WHEN Idade <= 40 THEN '31-40 anos'
		WHEN Idade <= 60 THEN '41-60 anos'
		ELSE 'Acima de 60 anos' 
		END) as FaixaEtaria	
	FROM(SELECT *, YEAR(GETDATE())-YEAR([Data de Nascimento]) as 'Idade' 
	FROM [Projeto_RH].[dbo].[BaseFuncionario]) as TabelaIdade) as Tabela
GROUP BY FaixaEtaria
ORDER BY TotalDeContratações DESC;

-- Total de demissões por faixa etária
SELECT
	FaixaEtaria,
	COUNT([Data de Demissao]) as TotalDeDemissões
FROM(SELECT
		[Data de Contratacao],
		[Data de Demissao],
		(CASE 
		WHEN Idade <= 30 THEN '18-30 anos' 
		WHEN Idade <= 40 THEN '31-40 anos'
		WHEN Idade <= 60 THEN '41-60 anos'
		ELSE 'Acima de 60 anos' 
		END) as FaixaEtaria	
	FROM(SELECT *, YEAR(GETDATE())-YEAR([Data de Nascimento]) as 'Idade' 
	FROM [Projeto_RH].[dbo].[BaseFuncionario]) as TabelaIdade) as Tabela
GROUP BY FaixaEtaria
ORDER BY TotalDeDemissões DESC;

-- Total de contratações por estado e cidade
SELECT 
	Estado,
	SUM([Total]) as 'Total'
FROM(SELECT
		PARSENAME(REPLACE([Cidade/Estado],'-','.'),2) as Cidade,
		PARSENAME(REPLACE([Cidade/Estado],'-','.'),1) as Estado,
		[Total]
	FROM(SELECT 
			[Cidade/Estado],
			COUNT([Data de Contratacao]) as 'Total'
		FROM(SELECT 
				*,
				PARSENAME(REPLACE(REPLACE([Endereço],'.',''),',','.'),4) as 'Rua',
				PARSENAME(REPLACE(REPLACE([Endereço],'.',''),',','.'),3) as 'Complemento',
				PARSENAME(REPLACE(REPLACE([Endereço],'.',''),',','.'),2) as 'Cidade/Estado',
				PARSENAME(REPLACE(REPLACE([Endereço],'.',''),',','.'),1) as 'CEP'
			FROM [Projeto_RH].[dbo].[BaseFuncionario]) as TabelaAuxiliar
		GROUP BY [Cidade/Estado]) as TabelaAuxiliar2) as Tabela
GROUP BY Estado
ORDER BY 'Total' DESC;

-- Total de demissões por estado e cidade
SELECT 
	Estado,
	SUM([Total]) as 'Total'
FROM(SELECT
		PARSENAME(REPLACE([Cidade/Estado],'-','.'),2) as Cidade,
		PARSENAME(REPLACE([Cidade/Estado],'-','.'),1) as Estado,
		[Total]
	FROM(SELECT 
			[Cidade/Estado],
			COUNT([Data de Demissao]) as 'Total'
		FROM(SELECT 
				*,
				PARSENAME(REPLACE(REPLACE([Endereço],'.',''),',','.'),4) as 'Rua',
				PARSENAME(REPLACE(REPLACE([Endereço],'.',''),',','.'),3) as 'Complemento',
				PARSENAME(REPLACE(REPLACE([Endereço],'.',''),',','.'),2) as 'Cidade/Estado',
				PARSENAME(REPLACE(REPLACE([Endereço],'.',''),',','.'),1) as 'CEP'
			FROM [Projeto_RH].[dbo].[BaseFuncionario]) as TabelaAuxiliar
		GROUP BY [Cidade/Estado]) as TabelaAuxiliar2) as Tabela
GROUP BY Estado
ORDER BY 'Total' DESC;

-- Total de funcionarios ativos por genero
SELECT
	(CASE WHEN [Sexo] = 'F' THEN 'Feminino' ELSE 'Masculino' END) as [Sexo],
	COUNT([Data de Contratacao])-COUNT([Data de Demissao]) as 'Total de funcionários ativos'
FROM [Projeto_RH].[dbo].[BaseFuncionario]
GROUP BY [Sexo]

-- Salario total por gênero
SELECT
	(CASE WHEN [Sexo] = 'F' THEN 'Feminino' ELSE 'Masculino' END) as [Sexo],
	ROUND(SUM(([Salario Base]+[Beneficios]+[VT]+[VR]+[Impostos])/1000000),2) as 'Salario total'
FROM [Projeto_RH].[dbo].[BaseFuncionario]
GROUP BY [Sexo]

-- Média salarial por gênero
SELECT
	(CASE WHEN [Sexo] = 'F' THEN 'Feminino' ELSE 'Masculino' END) as [Sexo],
	ROUND(AVG(([Salario Base]+[Beneficios]+[VT]+[VR]+[Impostos])/1000),2) as 'Média salarial'
FROM [Projeto_RH].[dbo].[BaseFuncionario]
GROUP BY [Sexo]

-- Total de funcionario ativos por nível e gênero
SELECT
	[Nível],
	(CASE WHEN [Sexo] = 'F' THEN 'Feminino' ELSE 'Masculino' END) as [Sexo],
	COUNT([Data de Contratacao])-COUNT([Data de Demissao]) as 'Total de funcionários ativos'
FROM [Projeto_RH].[dbo].[BaseFuncionario]
GROUP BY [Sexo], [Nível]

-- Salario total por nível e gênero
SELECT
	[Nível],
	(CASE WHEN [Sexo] = 'F' THEN 'Feminino' ELSE 'Masculino' END) as [Sexo],
	ROUND(SUM(([Salario Base]+[Beneficios]+[VT]+[VR]+[Impostos])/1000000),2) as 'Salario total'
FROM [Projeto_RH].[dbo].[BaseFuncionario]
GROUP BY [Sexo], [Nível]

-- Média salarial por nível e gênero
SELECT
	[Nível],
	(CASE WHEN [Sexo] = 'F' THEN 'Feminino' ELSE 'Masculino' END) as [Sexo],
	ROUND(AVG(([Salario Base]+[Beneficios]+[VT]+[VR]+[Impostos])/1000),2) as 'Média salarial'
FROM [Projeto_RH].[dbo].[BaseFuncionario]
GROUP BY [Sexo], [Nível]

-- Média das notas das competências dos funcionarios
SELECT ROUND(AVG(Notas),2) AS 'Média das notas das competências dos funcionário' FROM
(SELECT [ID RH], Competencia, Notas
FROM [Projeto_RH].[dbo].[BaseFuncionario]
UNPIVOT (
  Notas FOR Competencia IN ([Trabalho em Equipe],[Liderança],[Comunicação],[Iniciativa],[Organização])
) AS tabela_pivot) AS Tabela_avaliação;

-- As 10 maiores médias de notas das competencias dos funcionarios
SELECT TOP (10) [ID RH], ROUND(AVG(Notas),2) AS 'Média das notas' FROM
(SELECT [ID RH], 'Trabalho em Equipe' AS Competencia, [Trabalho em Equipe] AS Notas FROM [Projeto_RH].[dbo].[BaseFuncionario]
UNION ALL
SELECT [ID RH], 'Liderança' AS Competencia, [Liderança] AS Notas FROM [Projeto_RH].[dbo].[BaseFuncionario]
UNION ALL
SELECT [ID RH], 'Comunicação' AS Competencia, [Comunicação] AS Notas FROM [Projeto_RH].[dbo].[BaseFuncionario]
UNION ALL
SELECT [ID RH], 'Iniciativa' AS Competencia, [Iniciativa] AS Notas FROM [Projeto_RH].[dbo].[BaseFuncionario]
UNION ALL
SELECT [ID RH], 'Organização' AS Competencia, [Organização] AS Notas FROM [Projeto_RH].[dbo].[BaseFuncionario]) AS Tabela_avaliação
GROUP BY [ID RH]
ORDER BY 'Média das notas' DESC;

-- Nota individual e geral por competência
SELECT 
	Competencia,
	SUM(Notas) as 'Nota individual',
	ROUND(AVG(Notas),2) as 'Nota geral'
FROM(SELECT [ID RH], Competencia, Notas
	FROM [Projeto_RH].[dbo].[BaseFuncionario]
	UNPIVOT (
	  Notas FOR Competencia IN ([Trabalho em Equipe],[Liderança],[Comunicação],[Iniciativa],[Organização])
	) AS tabela_pivot) as T
GROUP BY Competencia

-- Notas Individuais por competencia
SELECT 
	Competencia,
	SUM(Notas)/1000 as 'Nota individual em milhares'
FROM(SELECT [ID RH], Competencia, Notas
	FROM [Projeto_RH].[dbo].[BaseFuncionario]
	UNPIVOT (
	  Notas FOR Competencia IN ([Trabalho em Equipe],[Liderança],[Comunicação],[Iniciativa],[Organização])
	) AS tabela_pivot) as T
GROUP BY Competencia

-- Informações pessoais
SELECT
	[Nome Completo],
	CAST([Data de Nascimento] as DATE) as 'Data de Nascimento',
	CAST([Data de Contratacao] as DATE) as 'Data de Contratacao',
	[Cidade],
	[Estado],
	(CASE WHEN [Estado Civil] = 'C' THEN 'Casado(a)' ELSE 'Solteiro(a)' END) as 'Estado Civil',  
	YEAR(GETDATE())-YEAR([Data de Nascimento]) as 'Idade',
	(CASE WHEN [Data de Demissao] IS NOT NULL THEN YEAR([Data de Demissao])-YEAR([Data de Contratacao]) ELSE YEAR(GETDATE())-YEAR([Data de Contratacao]) END) as AnosDeEmpresa,
	[Salario Base]+[Impostos]+[Beneficios]+[VT]+[VR] as 'Salario',
	[Ferias Acumuladas],
	[Horas Extras]		
FROM(SELECT 
	*, 
	PARSENAME(REPLACE([Cidade/Estado],'-','.'),2) as Cidade,
	PARSENAME(REPLACE([Cidade/Estado],'-','.'),1) as Estado
	FROM(SELECT *,
		PARSENAME(REPLACE(REPLACE([Endereço],'.',''),',','.'),4) as 'Rua',
		PARSENAME(REPLACE(REPLACE([Endereço],'.',''),',','.'),3) as 'Complemento',
		PARSENAME(REPLACE(REPLACE([Endereço],'.',''),',','.'),2) as 'Cidade/Estado',
		PARSENAME(REPLACE(REPLACE([Endereço],'.',''),',','.'),1) as 'CEP'
		FROM [Projeto_RH].[dbo].[BaseFuncionario]) as TabelaAuxiliar) as TabelaAuxiliar2
-- WHERE [Nome Completo] = 'Adelino Araujo'

-- Taxa de rotatividade de funcionários (Turnover)
SELECT 
	ROUND((((CAST((COUNT([Data de Contratacao])+COUNT([Data de Demissao]))/2 AS FLOAT)) / CAST(COUNT([Data de Contratacao])-COUNT([Data de Demissao]) AS FLOAT)) * 100),2) as '% Turnover'
FROM [Projeto_RH].[dbo].[BaseFuncionario];

-- Custo total por contratação
-- Cálculo: Total de Custos de Contratação ÷ Número Total de Contratações
SELECT 
	ROUND(AVG([Salario Base]+[Beneficios]+[VT]+[VR]+[Impostos]),2) as 'Custo total por contratação'
FROM [Projeto_RH].[dbo].[BaseFuncionario];

-- Remuneração média por trabalhador: Indica o nível de salários praticados pela empresa. 
-- Corresponde à remuneração média que cada trabalhador aufere por um ano de trabalho na empresa. 
-- Acaba por ser um indicador extremamente importante, na medida em que identifica um dos custos principais da empresa e permite compará-lo com a média do sector. 
-- Um valor baixo tanto pode indicar competitividade nos gastos com pessoal, mas também pode indicar que a empresa tem colaboradores menos qualificados e com baixa motivação. 
-- Importa analisar este valor relativamente à média do sector e enquadrado na estratégia da empresa.
-- Cálculo: Remunerações anuais dos colaboradores / de colaboradores (Real)
SELECT 
	ROUND(AVG([Salario Base]+[Beneficios]+[VT]+[VR]+[Impostos]),2) as 'Remuneração média por trabalhador'
FROM [Projeto_RH].[dbo].[BaseFuncionario];

-- Antiguidade média: Indica o número médio de anos que os colaboradores estão ao serviço da empresa. 
-- Não existindo alterações no quadro de colaboradores, o resultado deste indicador incrementa todos os anos um ano.
-- Cálculo: Σ das antiguidades/ de pessoas ao serviço (anos)
SELECT
	ROUND(AVG(CAST((CASE WHEN [Data de Demissao] IS NOT NULL THEN YEAR([Data de Demissao])-YEAR([Data de Contratacao]) ELSE YEAR(GETDATE())-YEAR([Data de Contratacao]) END) AS FLOAT)),2) as 'Antiguidade média'
FROM [Projeto_RH].[dbo].[BaseFuncionario];

-- Idade média: Indica a idade média dos colaboradores da empresa. 
-- Este indicador pode ser calculado por categorias, por género, por habilitações, por departamentos, etc. 
-- Permite perceber o nível de envelhecimento dos colaboradores da empresa.
-- Cálculo: Σ das idades/ de pessoas ao serviço (anos)
SELECT 
	SUM(YEAR(GETDATE())-YEAR([Data de Nascimento]))/(COUNT([Data de Contratacao])-COUNT([Data de Demissao])) AS 'Idade média'
FROM [Projeto_RH].[dbo].[BaseFuncionario];

-- Índice de tecnicidade: Identifica o peso dos colaboradores que são considerados técnicos superiores. 
-- Em algumas empresas é crítico ter um índice de tecnicidade elevado, já que pode ser sinónimo de uma empresa que aposta/investe forte na contratação de quadros qualificados. 
-- Existem empresas onde este índice é muito baixo devido à forte componente de colaboradores operacionais (ex.: empresas de construção civil, empresas agrícolas, etc.). 
-- Existem outras empresas em que o peso de técnicos superiores deve ser muito elevado (ex.: empresas de consultoria, de informática, de investigação, farmacêuticas, etc.)
-- Cálculo: Número de técnicos superiores/Total de colaboradores (%)
SELECT ROUND((CAST(COUNT([Nível]) AS FLOAT)/432)*100,2) as 'Índice de tecnicidade' FROM [Projeto_RH].[dbo].[BaseFuncionario]
WHERE [Nível] IN ('Coordenador','Diretor','Gerente');

-- Leque salarial ilíquido: O índice do leque salarial indica o de vezes que a remuneração mais elevada cobre a remuneração mais baixa. 
-- Quanto maior for este valor, maior será a distância entre a remuneração mais elevada e a remuneração mais baixa. 
-- Um aumento do leque salarial pode indicar a existência de desequilíbrio salarial na empresa. 
-- Importa analisar este índice, tendo em conta o género e por categorias. 
-- É importante também perceber o posicionamento da remuneração base ilíquida média da empresa. 
-- O valor óptimo deste indicador depende da estratégia da empresa.
-- Cálculo: Maior remuneração base ilíquida/Menor remuneração base ilíquida (índice)
SELECT ROUND(MAX([Salario Base]) / MIN([Salario Base]),2) as 'Leque salarial ilíquido' FROM [Projeto_RH].[dbo].[BaseFuncionario];
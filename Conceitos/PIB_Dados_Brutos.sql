-- Passo 1: Criar a tabela

IF  OBJECT_ID('PIB_Dados_Brutos') IS NOT NULL  DROP  TABLE  PIB_Dados_Brutos

CREATE  TABLE PIB_Dados_Brutos(
_DEMO_IND NVARCHAR(200),
_INDICADOR NVARCHAR(200),
_LOCALIZACAO NVARCHAR(200),
_PAIS NVARCHAR(200),
_TIME NVARCHAR(200),
_VALOR FLOAT,
_COD_SINALIZADOR NVARCHAR(200),
_SINALIZADOR NVARCHAR(200)
);

-- Etapa 2: importar os dados

BULK INSERT PIB_Dados_Brutos
FROM 'C:\Users\fmga8\Documents\Portfolio\Estudos\Projetos_SQL\Conceitos\PIB_Dados_Brutos.csv'
WITH (FORMAT = 'CSV');

SELECT * FROM PIB_Dados_Brutos

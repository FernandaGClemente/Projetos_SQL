/****** Script do comando SelectTopNRows de SSMS  ******/
SELECT TOP (1000) [index]
      ,[_DEMO_IND]
      ,[_INDICADOR]
      ,[_LOCALIZACAO]
      ,[_PAIS]
      ,[_TIME]
      ,[_VALOR]
      ,[_COD_SINALIZADOR]
      ,[_SINALIZADOR]
      ,[_METODO_ML]
      ,[_PREVISAO_VALOR]
  FROM [Projeto_SQL_Python].[dbo].[Resultado_Previsao_PIB]

SELECT 
	[_INDICADOR], 
	[_PAIS], 
	[_TIME],
	[_METODO_ML], 
	[_PREVISAO_VALOR] 
FROM [dbo].[Resultado_Previsao_PIB] 
WHERE [_PREVISAO_VALOR] <> 0
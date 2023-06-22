/****** Script dos comandos do SQL para a Cria��o da Tabela Tipo de M�dia  ******/

-- Cria��o da Tabela
CREATE TABLE [media_type]
(
    [media_type_id] INTEGER PRIMARY KEY NOT NULL,
    [name] NVARCHAR(120)
)

-- Consulta de todas as colunas da tabela
SELECT * FROM [Projeto_SQL_LojaDeMusica].[dbo].[media_type]

-- Inclus�o dos dados
--INSERT INTO [media_type] ([media_type_id],[name]) VALUES
INSERT INTO [media_type] VALUES
(1,'MPEG audio file'),
(2,'Protected AAC audio file'),
(3,'Protected MPEG-4 video file'),
(4,'Purchased AAC audio file'),
(5,'AAC audio file')

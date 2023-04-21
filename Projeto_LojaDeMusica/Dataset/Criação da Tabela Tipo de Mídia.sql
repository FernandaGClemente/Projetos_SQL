/****** Script do comando SelectTopNRows de SSMS  ******/
CREATE TABLE [media_type]
(
    [media_type_id] INTEGER PRIMARY KEY NOT NULL,
    [name] NVARCHAR(120)
)

SELECT * FROM [Projeto_SQL_LojaDeMusica].[dbo].[media_type]

--INSERT INTO [media_type] ([media_type_id],[name]) VALUES
INSERT INTO [media_type] VALUES
(1,'MPEG audio file'),
(2,'Protected AAC audio file'),
(3,'Protected MPEG-4 video file'),
(4,'Purchased AAC audio file'),
(5,'AAC audio file')

/****** Script do comando SelectTopNRows de SSMS  ******/
CREATE TABLE [playlist]
(
    [playlist_id] INTEGER PRIMARY KEY NOT NULL,
    [name] NVARCHAR(120)
)

SELECT * FROM [Projeto_SQL_LojaDeMusica].[dbo].[playlist]

--INSERT INTO [playlist] ([playlist_id],[name]) VALUES
INSERT INTO [playlist] VALUES
(1,'Music'),
(2,'Movies'),
(3,'TV Shows'),
(4,'Audiobooks'),
(5,'90’s Music'),
(6,'Audiobooks'),
(7,'Movies'),
(8,'Music'),
(9,'Music Videos'),
(10,'TV Shows'),
(11,'Brazilian Music'),
(12,'Classical'),
(13,'Classical 101 - Deep Cuts'),
(14,'Classical 101 - Next Steps'),
(15,'Classical 101 - The Basics'),
(16,'Grunge'),
(17,'Heavy Metal Classic'),
(18,'On-The-Go 1')

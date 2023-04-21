/****** Script do comando SelectTopNRows de SSMS  ******/
CREATE TABLE [employee]
(
    [employee_id] INTEGER PRIMARY KEY NOT NULL,
    [last_name] NVARCHAR(20)  NOT NULL,
    [first_name] NVARCHAR(20)  NOT NULL,
    [title] NVARCHAR(30),
    [reports_to] INTEGER,
	[levels] NVARCHAR(20),
    [birthdate] DATETIME,
    [hire_date] DATETIME,
    [address] NVARCHAR(70),
    [city] NVARCHAR(40),
    [state] NVARCHAR(40),
    [country] NVARCHAR(40),
    [postal_code] NVARCHAR(10),
    [phone] NVARCHAR(24),
    [fax] NVARCHAR(24),
    [email] NVARCHAR(60),
)

SELECT * FROM [Projeto_SQL_LojaDeMusica].[dbo].[employee]

--INSERT INTO [employee] ([employee_id],[last_name],[first_name],[title],[reports_to],[levels],[birthdate],[hire_date],[address],[city],[state],[country],[postal_code],[phone],[fax],[email]) VALUES
INSERT INTO [employee] VALUES
(1,'Adams','Andrew','General Manager',9,'L6',1962-02-18 ,2016-08-14 ,'11120 Jasper Ave NW','Edmonton','AB','Canada','T5K 2N1','+1 (780) 428-9482','+1 (780) 428-3457','andrew@chinookcorp.com'),
(2,'Edwards','Nancy','Sales Manager',1,'L4',1958-12-08 ,2016-05-01 ,'825 8 Ave SW','Calgary','AB','Canada','T2P 2T3','+1 (403) 262-3443','+1 (403) 262-3322','nancy@chinookcorp.com'),
(3,'Peacock','Jane','Sales Support Agent',2,'L1',1973-08-29 ,2017-04-01 ,'1111 6 Ave SW','Calgary','AB','Canada','T2P 5M5','+1 (403) 262-3443','+1 (403) 262-6712','jane@chinookcorp.com'),
(4,'Park','Margaret','Sales Support Agent',2,'L1',1947-09-19 ,2017-05-03 ,'683 10 Street SW','Calgary','AB','Canada','T2P 5G3','+1 (403) 263-4423','+1 (403) 263-4289','margaret@chinookcorp.com'),
(5,'Johnson','Steve','Sales Support Agent',2,'L1',1965-03-03 ,2017-10-17 ,'7727B 41 Ave','Calgary','AB','Canada','T3B 1Y7','1 (780) 836-9987','1 (780) 836-9543','steve@chinookcorp.com'),
(6,'Mitchell','Michael','IT Manager',1,'L3',1973-07-01 ,2016-10-17 ,'5827 Bowness Road NW','Calgary','AB','Canada','T3B 0C5','+1 (403) 246-9887','+1 (403) 246-9899','michael@chinookcorp.com'),
(7,'King','Robert','IT Staff',6,'L2',1970-05-29 ,2017-01-02 ,'590 Columbia Boulevard West','Lethbridge','AB','Canada','T1K 5N8','+1 (403) 456-9986','+1 (403) 456-8485','robert@chinookcorp.com'),
(8,'Callahan','Laura','IT Staff',6,'L2',1968-01-09 ,2017-03-04 ,'923 7 ST NW','Lethbridge','AB','Canada','T1H 1Y8','+1 (403) 467-3351','+1 (403) 467-8772','laura@chinookcorp.com'),
(9,'Madan','Mohan','Senior General Manager',0,'L7',1961-01-26 ,2016-01-14 ,'1008 Vrinda Ave MT','Edmonton','AB','Canada','T5K 2N1','+1 (780) 428-9482','+1 (780) 428-3457','madan.mohan@chinookcorp.com')




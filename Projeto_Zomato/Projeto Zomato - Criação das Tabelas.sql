DROP TABLE IF EXISTS tb_CadastroUsuarioOuro; -- goldusers_signup 
CREATE TABLE tb_CadastroUsuarioOuro(ID_Usuario INTEGER,Data_CadastroOuro DATE); -- userid e gold_signup_date

INSERT INTO tb_CadastroUsuarioOuro(ID_Usuario, Data_CadastroOuro) -- DATE: AAAA-MM-DD
VALUES (1,'2017-09-22'),
(3,'2017-04-21');

DROP TABLE IF EXISTS tb_Usuario; -- users
CREATE TABLE tb_Usuario(ID_Usuario INTEGER,Data_Cadastro DATE); -- userid e signup_date

INSERT INTO tb_Usuario(ID_Usuario,Data_Cadastro) VALUES 
	(1,'2014-09-02'),
	(2,'2014-01-15'),
	(3,'2014-04-11');

DROP TABLE IF EXISTS tb_Vendas; -- sales
CREATE TABLE tb_Vendas(ID_Usuario INTEGER,Data_Criacao DATE,ID_Produto INTEGER); -- userid, created_date e product_id 

INSERT INTO tb_Vendas(ID_Usuario,Data_Criacao,ID_Produto) VALUES 
	(1,'2017-04-19',2),
	(3,'2019-12-18',1),
	(2,'2020-07-20',3),
	(1,'2019-10-23',2),
	(1,'2018-03-19',3),
	(3,'2016-12-20',2),
	(1,'2016-11-09',1),
	(1,'2016-05-20',3),
	(2,'2017-09-24',1),
	(1,'2017-03-11',2),
	(1,'2016-03-11',1),
	(3,'2016-11-10',1),
	(3,'2017-12-07',2),
	(3,'2016-12-15',2),
	(2,'2017-11-08',2),
	(2,'2018-09-10',3);

DROP TABLE IF EXISTS tb_Produto; -- product
CREATE TABLE tb_Produto(ID_Produto INTEGER,Nome_Produto text,Preco INTEGER); -- product_id, product_name e price

INSERT INTO tb_Produto(ID_Produto,Nome_Produto,Preco) VALUES
	(1,'p1',980),
	(2,'p2',870),
	(3,'p3',330);

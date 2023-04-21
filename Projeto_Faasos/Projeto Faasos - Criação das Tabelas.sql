/****** Script dos comandos SQL - Criação do Banco de Dados  ******/

-- Faasos é um serviço indiano de "comida sob demanda" que foi incorporado em 2004. É uma das marcas de propriedade da empresa de restaurantes online Rebel Foods. 

-- Criação da tabela Motorista
DROP TABLE IF EXISTS tb_Motorista;
CREATE TABLE tb_Motorista(IdMotorista INTEGER,DataDeRegistro DATE); 

INSERT INTO tb_Motorista(IdMotorista, DataDeRegistro) 
 VALUES (1,'2021-01-01'),
(2,'2021-01-03'),
(3,'2021-01-08'),
(4,'2021-01-15');

-- Criação da tabela Ingredientes
DROP TABLE IF EXISTS tb_Ingredientes;
CREATE TABLE tb_Ingredientes(IdIngrediantes INTEGER,NomeDoIngredientes VARCHAR(60)); 

INSERT INTO tb_Ingredientes(IdIngrediantes, NomeDoIngredientes) 
 VALUES (1,'BBQ Chicken'),
(2,'Chilli Sauce'),
(3,'Chicken'),
(4,'Cheese'),
(5,'Kebab'),
(6,'Mushrooms'),
(7,'Onions'),
(8,'Egg'),
(9,'Peppers'),
(10,'schezwan sauce'),
(11,'Tomatoes'),
(12,'Tomato Sauce');

-- Criação da tabela Rolls (Comida indiana)
DROP TABLE IF EXISTS tb_Rolls;
CREATE TABLE tb_Rolls(IdRolls INTEGER, NomeRolls VARCHAR(30)); 

INSERT INTO tb_Rolls(IdRolls, NomeRolls) 
 VALUES (1	,'Roll Não Vegetariano'),
(2	,'Roll Vegetariano');

-- Criação da tabela Receita dos Rolls (Comida indiana)
DROP TABLE IF EXISTS tb_ReceitaDeRolls;
CREATE TABLE tb_ReceitaDeRolls(IdRolls INTEGER, Ingredientes VARCHAR(24)); 

INSERT INTO tb_ReceitaDeRolls(IdRolls, Ingredientes) 
 VALUES (1,'1,2,3,4,5,6,8,10'),
(2,'4,6,7,9,11,12');

-- Criação da tabela Entrega dos pedidos dos motoristas
DROP TABLE IF EXISTS tb_OrdemDoMotorista;
CREATE TABLE tb_OrdemDoMotorista(IdPedido INTEGER,IdMotorista INTEGER, HorarioDaColeta DATETIME, Distancia VARCHAR(7), Duracao VARCHAR(10), Cancelamento VARCHAR(23));

INSERT INTO tb_OrdemDoMotorista(IdPedido,IdMotorista,HorarioDaColeta,Distancia,Duracao,Cancelamento) 
 VALUES(1,1,'2021-01-01 18:15:34','20km','32 minutes',''),
(2,1,'2021-01-01 19:10:54','20km','27 minutes',''),
(3,1,'2021-03-01 00:12:37','13.4km','20 mins','NaN'),
(4,2,'2021-04-01 13:53:03','23.4','40','NaN'),
(5,3,'2021-08-01 21:10:57','10','15','NaN'),
(6,3,null,null,null,'Cancellation'),
(7,2,'2021-08-01 21:30:45','25km','25mins',null),
(8,2,'2021-10-01 00:15:02','23.4 km','15 minute',null),
(9,2,null,null,null,'Customer Cancellation'),
(10,1,'2021-11-01 18:50:20','10km','10minutes',null);

-- Criação da tabela do Pedido dos clientes
DROP TABLE IF EXISTS tb_PedidosDoClientes;
CREATE TABLE tb_PedidosDoClientes(IdPedido INTEGER,IdCliente INTEGER,IdRolls INTEGER,ItensExtrasNaoIncluidos VARCHAR(4),ItensExtrasIncluidos VARCHAR(4), DataDoPedido DATETIME);

INSERT INTO tb_PedidosDoClientes(IdPedido,IdCliente,IdRolls,ItensExtrasNaoIncluidos,ItensExtrasIncluidos,DataDoPedido)
VALUES (1,101,1,'','','2021-01-01 18:05:02'),
(2,101,1,'','','2021-01-01 19:00:52'),
(3,102,1,'','','2021-02-01 23:51:23'),
(3,102,2,'','NaN','2021-02-01 23:51:23'),
(4,103,1,'4','','2021-04-01 13:23:46'),
(4,103,1,'4','','2021-04-01 13:23:46'),
(4,103,2,'4','','2021-04-01 13:23:46'),
(5,104,1,null,'1','2021-08-01 21:00:29'),
(6,101,2,null,null,'2021-08-01 21:03:13'),
(7,105,2,null,'1','2021-08-01 21:20:29'),
(8,102,1,null,null,'2021-09-01 23:54:33'),
(9,103,1,'4','1,5','2021-10-01 11:22:59'),
(10,104,1,null,null,'2021-11-01 18:34:49'),
(10,104,1,'2,6','1,4','2021-11-01 18:34:49');

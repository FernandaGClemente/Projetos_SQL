/****** Script dos comandos em SQL  ******/

-- Verificando os dados das 5 tabelas
SELECT * FROM [Projeto_SQL_Hotel].[dbo].[2018] -- 21.996 linhas e 32 colunas
SELECT * FROM [Projeto_SQL_Hotel].[dbo].[2019] -- 79.264 linhas e 32 colunas 
SELECT * FROM [Projeto_SQL_Hotel].[dbo].[2020] -- 40.687 linhas e 32 colunas
SELECT * FROM [Projeto_SQL_Hotel].[dbo].[market_segment] -- 8 linhas e 2 colunas
SELECT * FROM [Projeto_SQL_Hotel].[dbo].[meal_cost] -- 5 linhas e 2 colunas

-- Alterando o nome das colunas da tabela de 2018: De Inglês para Português
USE [Projeto_SQL_Hotel];
  GO
  EXEC sp_rename '[2018].is_canceled', 'esta_cancelado', 'COLUMN'
  EXEC sp_rename '[2018].lead_time', 'tempo_de_espera', 'COLUMN';
  EXEC sp_rename '[2018].arrival_date_year', 'data_chegada_ano', 'COLUMN'
  EXEC sp_rename '[2018].arrival_date_month', 'data_chegada_mes', 'COLUMN'
  EXEC sp_rename '[2018].arrival_date_week_number', 'chegada_data_semana_numero', 'COLUMN'
  EXEC sp_rename '[2018].arrival_date_day_of_month', 'data_da_chegada_dia_do_mes', 'COLUMN'
  EXEC sp_rename '[2018].stays_in_weekend_nights', 'estadias_em_semana_noites', 'COLUMN'
  EXEC sp_rename '[2018].stays_in_week_nights', 'estadias_na_semana_noites', 'COLUMN'
  EXEC sp_rename '[2018].adults', 'adultos', 'COLUMN'
  EXEC sp_rename '[2018].children', 'criancas', 'COLUMN'
  EXEC sp_rename '[2018].babies', 'bebes', 'COLUMN'
  EXEC sp_rename '[2018].meal', 'refeicao', 'COLUMN'
  EXEC sp_rename '[2018].country', 'país', 'COLUMN'
  EXEC sp_rename '[2018].market_segment', 'segmento_de_mercado', 'COLUMN'
  EXEC sp_rename '[2018].distribution_channel', 'canal_de_distribuicao', 'COLUMN'
  EXEC sp_rename '[2018].is_repeated_guest', 'repetido_convidado', 'COLUMN'
  EXEC sp_rename '[2018].previous_cancellations', 'cancelamentos_anteriores', 'COLUMN'
  EXEC sp_rename '[2018].previous_bookings_not_canceled', 'reservas_anteriores_nao_canceladas', 'COLUMN'
  EXEC sp_rename '[2018].reserved_room_type', 'reservado_quarto_tipo', 'COLUMN'
  EXEC sp_rename '[2018].assigned_room_type', 'tipo_de_quarto_atribuido', 'COLUMN'
  EXEC sp_rename '[2018].booking_changes', 'reserva_alteracoes', 'COLUMN'
  EXEC sp_rename '[2018].deposit_type', 'tipo_de_deposito', 'COLUMN'
  EXEC sp_rename '[2018].agent', 'agente', 'COLUMN'
  EXEC sp_rename '[2018].company', 'empresa', 'COLUMN'
  EXEC sp_rename '[2018].days_in_waiting_list', 'dias_na_lista_de_espera', 'COLUMN'
  EXEC sp_rename '[2018].customer_type', 'tipo_de_cliente', 'COLUMN'
  EXEC sp_rename '[2018].adr', 'taxa_diaria', 'COLUMN'
  EXEC sp_rename '[2018].required_car_parking_spaces', 'vagas_necessarias_de_estacionamento', 'COLUMN'
  EXEC sp_rename '[2018].total_of_special_requests', 'total_de_pedidos_especiais', 'COLUMN'
  EXEC sp_rename '[2018].reservation_status', 'status_da_reserva', 'COLUMN'
  EXEC sp_rename '[2018].reservation_status_date', 'data_status_reserva', 'COLUMN';
  GO

  -- Alterando o nome das colunas da tabela de 2019: De Inglês para Português
USE [Projeto_SQL_Hotel];
  GO
  EXEC sp_rename '[2019].is_canceled', 'esta_cancelado', 'COLUMN'
  EXEC sp_rename '[2019].lead_time', 'tempo_de_espera', 'COLUMN'
  EXEC sp_rename '[2019].arrival_date_year', 'data_chegada_ano', 'COLUMN'
  EXEC sp_rename '[2019].arrival_date_month', 'data_chegada_mes', 'COLUMN'
  EXEC sp_rename '[2019].arrival_date_week_number', 'chegada_data_semana_numero', 'COLUMN'
  EXEC sp_rename '[2019].arrival_date_day_of_month', 'data_da_chegada_dia_do_mes', 'COLUMN'
  EXEC sp_rename '[2019].stays_in_weekend_nights', 'estadias_em_semana_noites', 'COLUMN'
  EXEC sp_rename '[2019].stays_in_week_nights', 'estadias_na_semana_noites', 'COLUMN'
  EXEC sp_rename '[2019].adults', 'adultos', 'COLUMN'
  EXEC sp_rename '[2019].children', 'criancas', 'COLUMN'
  EXEC sp_rename '[2019].babies', 'bebes', 'COLUMN'
  EXEC sp_rename '[2019].meal', 'refeicao', 'COLUMN'
  EXEC sp_rename '[2019].country', 'país', 'COLUMN'
  EXEC sp_rename '[2019].market_segment', 'segmento_de_mercado', 'COLUMN'
  EXEC sp_rename '[2019].distribution_channel', 'canal_de_distribuicao', 'COLUMN'
  EXEC sp_rename '[2019].is_repeated_guest', 'repetido_convidado', 'COLUMN'
  EXEC sp_rename '[2019].previous_cancellations', 'cancelamentos_anteriores', 'COLUMN'
  EXEC sp_rename '[2019].previous_bookings_not_canceled', 'reservas_anteriores_nao_canceladas', 'COLUMN'
  EXEC sp_rename '[2019].reserved_room_type', 'reservado_quarto_tipo', 'COLUMN'
  EXEC sp_rename '[2019].assigned_room_type', 'tipo_de_quarto_atribuido', 'COLUMN'
  EXEC sp_rename '[2019].booking_changes', 'reserva_alteracoes', 'COLUMN'
  EXEC sp_rename '[2019].deposit_type', 'tipo_de_deposito', 'COLUMN'
  EXEC sp_rename '[2019].agent', 'agente', 'COLUMN'
  EXEC sp_rename '[2019].company', 'empresa', 'COLUMN'
  EXEC sp_rename '[2019].days_in_waiting_list', 'dias_na_lista_de_espera', 'COLUMN'
  EXEC sp_rename '[2019].customer_type', 'tipo_de_cliente', 'COLUMN'
  EXEC sp_rename '[2019].adr', 'taxa_diaria', 'COLUMN'
  EXEC sp_rename '[2019].required_car_parking_spaces', 'vagas_necessarias_de_estacionamento', 'COLUMN'
  EXEC sp_rename '[2019].total_of_special_requests', 'total_de_pedidos_especiais', 'COLUMN'
  EXEC sp_rename '[2019].reservation_status', 'status_da_reserva', 'COLUMN'
  EXEC sp_rename '[2019].reservation_status_date', 'data_status_reserva', 'COLUMN';
  GO

-- Alterando o nome das colunas da tabela de 2020: De Inglês para Português
USE [Projeto_SQL_Hotel];
  GO
  EXEC sp_rename '[2020].is_canceled', 'esta_cancelado', 'COLUMN'
  EXEC sp_rename '[2020].lead_time', 'tempo_de_espera', 'COLUMN'
  EXEC sp_rename '[2020].arrival_date_year', 'data_chegada_ano', 'COLUMN'
  EXEC sp_rename '[2020].arrival_date_month', 'data_chegada_mes', 'COLUMN'
  EXEC sp_rename '[2020].arrival_date_week_number', 'chegada_data_semana_numero', 'COLUMN'
  EXEC sp_rename '[2020].arrival_date_day_of_month', 'data_da_chegada_dia_do_mes', 'COLUMN'
  EXEC sp_rename '[2020].stays_in_weekend_nights', 'estadias_em_semana_noites', 'COLUMN'
  EXEC sp_rename '[2020].stays_in_week_nights', 'estadias_na_semana_noites', 'COLUMN'
  EXEC sp_rename '[2020].adults', 'adultos', 'COLUMN'
  EXEC sp_rename '[2020].children', 'criancas', 'COLUMN'
  EXEC sp_rename '[2020].babies', 'bebes', 'COLUMN'
  EXEC sp_rename '[2020].meal', 'refeicao', 'COLUMN'
  EXEC sp_rename '[2020].country', 'país', 'COLUMN'
  EXEC sp_rename '[2020].market_segment', 'segmento_de_mercado', 'COLUMN'
  EXEC sp_rename '[2020].distribution_channel', 'canal_de_distribuicao', 'COLUMN'
  EXEC sp_rename '[2020].is_repeated_guest', 'repetido_convidado', 'COLUMN'
  EXEC sp_rename '[2020].previous_cancellations', 'cancelamentos_anteriores', 'COLUMN'
  EXEC sp_rename '[2020].previous_bookings_not_canceled', 'reservas_anteriores_nao_canceladas', 'COLUMN'
  EXEC sp_rename '[2020].reserved_room_type', 'reservado_quarto_tipo', 'COLUMN'
  EXEC sp_rename '[2020].assigned_room_type', 'tipo_de_quarto_atribuido', 'COLUMN'
  EXEC sp_rename '[2020].booking_changes', 'reserva_alteracoes', 'COLUMN'
  EXEC sp_rename '[2020].deposit_type', 'tipo_de_deposito', 'COLUMN'
  EXEC sp_rename '[2020].agent', 'agente', 'COLUMN'
  EXEC sp_rename '[2020].company', 'empresa', 'COLUMN'
  EXEC sp_rename '[2020].days_in_waiting_list', 'dias_na_lista_de_espera', 'COLUMN'
  EXEC sp_rename '[2020].customer_type', 'tipo_de_cliente', 'COLUMN'
  EXEC sp_rename '[2020].adr', 'taxa_diaria', 'COLUMN'
  EXEC sp_rename '[2020].required_car_parking_spaces', 'vagas_necessarias_de_estacionamento', 'COLUMN'
  EXEC sp_rename '[2020].total_of_special_requests', 'total_de_pedidos_especiais', 'COLUMN'
  EXEC sp_rename '[2020].reservation_status', 'status_da_reserva', 'COLUMN'
  EXEC sp_rename '[2020].reservation_status_date', 'data_status_reserva', 'COLUMN';
  GO

-- Alterando o nome das colunas da tabela de segmento de mercado: De Inglês para Português
USE [Projeto_SQL_Hotel];
  GO
  EXEC sp_rename '[market_segment].Discount', 'desconto', 'COLUMN'
  EXEC sp_rename '[market_segment].market_segment', 'segmento_de_mercado', 'COLUMN';
  GO

-- Alterando o nome das colunas da tabela de custo das refeiçções: De Inglês para Português
USE [Projeto_SQL_Hotel];
  GO
  EXEC sp_rename '[meal_cost].Cost', 'custo', 'COLUMN'
  EXEC sp_rename '[meal_cost].meal', 'refeicao', 'COLUMN';
  GO

-- Criando uma CTE (Tabela Temporaria) Unindo as 5 tabelas  
WITH cte_Hotel AS ( 
SELECT * FROM [Projeto_SQL_Hotel].[dbo].[2018] 
UNION 
SELECT * FROM [Projeto_SQL_Hotel].[dbo].[2019] 
UNION 	
SELECT * FROM [Projeto_SQL_Hotel].[dbo].[2020]) 

-- SELECT [data_chegada_ano], [hotel], round(sum(([estadias_em_semana_noites]+[estadias_na_semana_noites])*[taxa_diaria]),2) as Receita FROM cte_Hotel GROUP BY [data_chegada_ano], [hotel] ORDER BY [data_chegada_ano]
-- SELECT [data_chegada_ano] AS 'Ano', count(*) AS 'Quantidade' FROM cte_Hotel GROUP BY [data_chegada_ano]; -- Total 100.756, sendo 2018: 13313, 2019: 55751 e 2020: 31692
-- SELECT [segmento_de_mercado], COUNT(*) FROM cte_Hotel GROUP BY [segmento_de_mercado]; 
-- SELECT [refeicao], COUNT(*) FROM cte_Hotel GROUP BY [refeicao]; 
/**SELECT [data_chegada_ano] as 'Data', [hotel] as 'Hotel', round(sum(([estadias_em_semana_noites]+[estadias_na_semana_noites])*([taxa_diaria]*(1-[desconto]))),2) as 'Receita' FROM cte_Hotel
INNER JOIN [Projeto_SQL_Hotel].[dbo].[market_segment]
ON cte_Hotel.[segmento_de_mercado] = [market_segment].[segmento_de_mercado]
	INNER JOIN [Projeto_SQL_Hotel].[dbo].[meal_cost]
	ON [meal_cost].refeicao = cte_Hotel.refeicao
GROUP BY [data_chegada_ano], [hotel] ORDER BY [data_chegada_ano]**/

SELECT * FROM cte_Hotel
INNER JOIN [Projeto_SQL_Hotel].[dbo].[market_segment]
ON cte_Hotel.[segmento_de_mercado] = [market_segment].[segmento_de_mercado]
	INNER JOIN [Projeto_SQL_Hotel].[dbo].[meal_cost]
	ON [meal_cost].refeicao = cte_Hotel.refeicao
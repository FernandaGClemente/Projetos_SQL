/****** Script dos comandos SQL dos exercicios do site https://datalemur.com/ ******/

-- 1) Suponha que voc� receba as tabelas abaixo sobre a p�gina do Facebook e as curtidas da p�gina (como em "Curtir uma p�gina do Facebook").
-- Escreva uma consulta para retornar os IDs das p�ginas do Facebook que n�o possuem curtidas. A sa�da deve ser classificada em ordem crescente.
SELECT 
  p.page_id
FROM pages p
LEFT JOIN page_likes pl
ON p.page_id = pl.page_id
WHERE pl.page_id IS NULL;

--2) A Tesla est� investigando gargalos de produ��o e precisa da sua ajuda para extrair os dados relevantes. 
-- Escreva uma consulta que determine quais pe�as com as etapas de montagem iniciaram o processo de montagem, mas permanecem inacabadas.
-- Premissas:
-- a) tabela parts_assembly cont�m todas as pe�as atualmente em produ��o, cada uma em v�rios est�gios do processo de montagem.
-- b) Uma parte inacabada � aquela que n�o possui um arquivo finish_date.
SELECT part, assembly_step FROM parts_assembly
WHERE finish_date IS NULL;

--3) Suponha que voc� tenha uma tabela de dados de tweets do Twitter, escreva uma consulta para obter um histograma de tweets postados por usu�rio em 2022. 
-- Emita a contagem de tweets por usu�rio como o intervalo e o n�mero de usu�rios do Twitter que se enquadram nesse intervalo.
-- Em outras palavras, agrupe os usu�rios pelo n�mero de tweets que postaram em 2022 e conte o n�mero de usu�rios em cada grupo.
SELECT tweet_bucket, COUNT(tweet_bucket) users_num FROM 
  (SELECT user_id, COUNT(tweet_id) AS tweet_bucket FROM tweets
  WHERE tweet_date BETWEEN '2022-01-01' AND '2022-12-31'
  GROUP BY user_id) AS tweet_set_per_user
GROUP BY tweet_bucket;

--4) Suponha que voc� receba a tabela de visualiza��o do usu�rio categorizada por tipo de dispositivo, onde os tr�s tipos s�o laptop, tablet e telefone.
-- Escreva uma consulta que calcule a visualiza��o total de laptops e dispositivos m�veis em que o celular � definido como a soma das visualiza��es de tablet e telefone. 
-- Gere a visualiza��o total para laptops como laptop_reviewse a visualiza��o total para dispositivos m�veis como mobile_views.
SELECT
  COUNT(*) AS laptop_views,
  (SELECT COUNT(*) FROM viewership
  WHERE device_type = 'tablet' OR device_type = 'phone') AS mobile_views
FROM viewership 
WHERE device_type = 'laptop';

--5) Dada uma tabela de candidatos e suas habilidades, voc� tem a tarefa de encontrar os candidatos mais adequados para um trabalho aberto de ci�ncia de dados. 
-- Voc� deseja encontrar candidatos que sejam proficientes em Python, Tableau e PostgreSQL.
-- Escreva uma consulta para listar os candidatos que possuem todas as habilidades necess�rias para o trabalho. 
-- Classifique a sa�da por ID de candidato em ordem crescente.
SELECT candidate_id FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(*) = 3;

--6) Dada uma tabela de postagens do Facebook, para cada usu�rio que postou pelo menos duas vezes em 2021, 
-- escreva uma consulta para encontrar o n�mero de dias entre a primeira postagem do ano de cada usu�rio e a �ltima postagem do ano no ano de 2021. 
-- Sa�da do usu�rio e n�mero de dias entre a primeira e a �ltima postagem de cada usu�rio.
SELECT 
  user_id,
  DATE(MAX(post_date))-DATE(MIN(post_date)) AS number_of_days
FROM posts 
WHERE DATE_PART('year',DATE(post_date)) = 2021
GROUP BY user_id 
HAVING count(post_id) > 1;

--7) Escreva uma consulta para identificar os 2 principais usu�rios avan�ados que enviaram o maior n�mero de mensagens no Microsoft Teams em agosto de 2022. 
-- Exiba as IDs desses 2 usu�rios junto com o n�mero total de mensagens enviadas. Emita os resultados em ordem decrescente com base na contagem das mensagens.
SELECT sender_id, COUNT(message_id) AS message_count FROM messages
WHERE (date_part('month', sent_date)) = 08 AND (date_part('year', sent_date)) = 2022
GROUP BY sender_id
ORDER BY message_count DESC
LIMIT 2;

--8) Suponha que voc� receba a tabela abaixo que mostra as ofertas de emprego para todas as empresas na plataforma do LinkedIn. 
-- Escreva uma consulta para obter o n�mero de empresas que publicaram listas de empregos duplicadas.
-- Listas de empregos duplicadas referem-se a dois empregos na mesma empresa com o mesmo t�tulo e descri��o.
SELECT COUNT(company_id) AS co_w_duplicate_jobs FROM (
SELECT company_id, title, description, COUNT(job_id) FROM job_listings
GROUP BY company_id, title, description
HAVING COUNT(job_id) > 1) AS duplicate;

--9) Suponha que voc� receba as tabelas contendo ordens de negocia��o conclu�das e detalhes do usu�rio em um sistema de negocia��o Robinhood.
--Escreva uma consulta para recuperar as tr�s principais cidades com o maior n�mero de ordens comerciais conclu�das listadas em ordem decrescente. 
--Imprima o nome da cidade e o n�mero correspondente de ordens comerciais conclu�das.
SELECT city, COUNT(order_id) AS total_orders FROM trades T
JOIN users U
ON T.user_id = U.user_id
WHERE status = 'Completed'
GROUP BY city
order by total_orders DESC
LIMIT 3;

--10) Dada a tabela de avalia��es, escreva uma consulta para recuperar a classifica��o m�dia por estrelas de cada produto, agrupada por m�s. 
-- A sa�da deve exibir o m�s como um valor num�rico, a ID do produto e a classifica��o m�dia por estrelas arredondada para duas casas decimais. 
-- Classifique a sa�da primeiro por m�s e depois por ID do produto.
SELECT 
  DATE_PART('month',DATE(submit_date)) AS mth, 
  product_id AS product, 
  ROUND(AVG(stars),2) AS avg_stars 
FROM reviews
GROUP BY mth, product
ORDER BY mth, product;

--11) Suponha que voc� tenha uma tabela de eventos na an�lise de aplicativos do Facebook. 
--Escreva uma consulta para calcular a taxa de cliques (CTR) do aplicativo em 2022 e arredonde os resultados para duas casas decimais.
--Defini��o e observa��o:
--Porcentagem da taxa de cliques (CTR) = 100,0 * N�mero de cliques / N�mero de impress�es
--Para evitar a divis�o inteira, multiplique o CTR por 100,0, n�o por 100.
SELECT
  app_id,
  ROUND(100.0 *
    SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) /
    SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END), 2)  AS ctr_rate
FROM events
WHERE DATE_PART('year',DATE(timestamp))=2022
GROUP BY app_id;

--12) Suponha que voc� receba tabelas com informa��es sobre inscri��es e confirma��es de usu�rios do TikTok por e-mail e texto. 
-- Novos usu�rios no TikTok se inscrevem usando seus endere�os de e-mail e, ap�s a inscri��o, cada usu�rio recebe uma confirma��o por mensagem de texto para ativar sua conta.
--Escreva uma consulta para exibir os IDs de usu�rio daqueles que n�o confirmaram sua inscri��o no primeiro dia, mas confirmaram no segundo dia.
--Defini��o:
--action_date refere-se � data em que os usu�rios ativaram suas contas e confirmaram sua inscri��o por meio de mensagens de texto.
SELECT user_id FROM emails E
JOIN texts T
ON E.email_id = T.email_id
WHERE signup_action='Confirmed' AND DATE(signup_date)+1 = action_date

--13) Sua equipe no JPMorgan Chase lan�ar� em breve um novo cart�o de cr�dito e, para obter algum contexto, 
-- voc� est� analisando quantos cart�es de cr�dito foram emitidos a cada m�s.
-- Escreva uma consulta que gere o nome de cada cart�o de cr�dito e a diferen�a no valor emitido entre o m�s com mais cart�es emitidos e o m�s com menos cart�es emitidos. 
-- Ordene os resultados de acordo com a maior diferen�a.
SELECT 
  card_name, 
  MAX(issued_amount)-MIN(issued_amount) AS difference 
FROM monthly_cards_issued 
GROUP BY card_name
ORDER BY difference DESC;

--14) Voc� est� tentando encontrar o n�mero m�dio de itens por pedido no Alibaba, 
-- arredondado para 1 casa decimal usando tabelas que incluem informa��es sobre a contagem de itens em cada pedido (tabela) item_counte o n�mero correspondente de pedidos para cada contagem de item ( order_occurrencestabela) .
SELECT 
  ROUND(round(sum(item_count*order_occurrences),1)/round(sum(order_occurrences),1),1) as mean
FROM items_per_order;

--15) A CVS Health est� tentando entender melhor as vendas de suas farm�cias e como os diferentes produtos est�o vendendo. 
-- Cada medicamento s� pode ser produzido por um fabricante.
-- Escreva uma consulta para encontrar os 3 medicamentos mais lucrativos vendidos e quanto lucro eles obtiveram. 
-- Suponha que n�o haja empates nos lucros. Exiba o resultado do maior para o menor lucro total.
-- Defini��o:
-- cogs significa custo de mercadorias vendidas, que � o custo direto associado � produ��o do medicamento.
-- Lucro Total = Total de Vendas - Custo das Mercadorias Vendidas
SELECT drug, sum(total_sales-cogs) AS total_profit FROM pharmacy_sales
GROUP BY drug
ORDER BY total_profit DESC
LIMIT 3;

--16) A CVS Health est� analisando seus dados de vendas de farm�cias e como diferentes produtos est�o sendo vendidos no mercado. 
-- Cada medicamento � fabricado exclusivamente por um �nico fabricante.
-- Escreva uma consulta para identificar os fabricantes associados aos medicamentos que resultaram em perdas para a CVS Health e 
-- calcule o valor total das perdas incorridas.
-- Gere o nome do fabricante, o n�mero de medicamentos associados �s perdas e as perdas totais em valor absoluto. 
-- Exiba os resultados classificados em ordem decrescente com as maiores perdas exibidas na parte superior.
SELECT
  manufacturer,
  COUNT(drug) AS drug_count, 
  SUM(cogs - total_sales) AS total_loss
FROM pharmacy_sales
WHERE cogs > total_sales
GROUP BY manufacturer
ORDER BY total_loss DESC

--17) A CVS Health est� tentando entender melhor as vendas de suas farm�cias e como os diferentes produtos est�o vendendo.
-- Escreva uma consulta para encontrar o total de vendas de medicamentos para cada fabricante. 
-- Arredonde sua resposta para o milh�o mais pr�ximo e relate seus resultados em ordem decrescente do total de vendas.
-- Como esses dados est�o sendo alimentados diretamente em um painel que est� sendo visto pelas partes interessadas nos neg�cios, 
-- formate seu resultado assim: "US$ 36 milh�es".

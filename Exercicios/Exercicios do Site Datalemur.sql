/****** Script dos comandos SQL dos exercicios do site https://datalemur.com/ ******/

-- 1) Suponha que você receba as tabelas abaixo sobre a página do Facebook e as curtidas da página (como em "Curtir uma página do Facebook").
-- Escreva uma consulta para retornar os IDs das páginas do Facebook que não possuem curtidas. A saída deve ser classificada em ordem crescente.
SELECT 
  p.page_id
FROM pages p
LEFT JOIN page_likes pl
ON p.page_id = pl.page_id
WHERE pl.page_id IS NULL;

--2) A Tesla está investigando gargalos de produção e precisa da sua ajuda para extrair os dados relevantes. 
-- Escreva uma consulta que determine quais peças com as etapas de montagem iniciaram o processo de montagem, mas permanecem inacabadas.
-- Premissas:
-- a) tabela parts_assembly contém todas as peças atualmente em produção, cada uma em vários estágios do processo de montagem.
-- b) Uma parte inacabada é aquela que não possui um arquivo finish_date.
SELECT part, assembly_step FROM parts_assembly
WHERE finish_date IS NULL;

--3) Suponha que você tenha uma tabela de dados de tweets do Twitter, escreva uma consulta para obter um histograma de tweets postados por usuário em 2022. 
-- Emita a contagem de tweets por usuário como o intervalo e o número de usuários do Twitter que se enquadram nesse intervalo.
-- Em outras palavras, agrupe os usuários pelo número de tweets que postaram em 2022 e conte o número de usuários em cada grupo.
SELECT tweet_bucket, COUNT(tweet_bucket) users_num FROM 
  (SELECT user_id, COUNT(tweet_id) AS tweet_bucket FROM tweets
  WHERE tweet_date BETWEEN '2022-01-01' AND '2022-12-31'
  GROUP BY user_id) AS tweet_set_per_user
GROUP BY tweet_bucket;

--4) Suponha que você receba a tabela de visualização do usuário categorizada por tipo de dispositivo, onde os três tipos são laptop, tablet e telefone.
-- Escreva uma consulta que calcule a visualização total de laptops e dispositivos móveis em que o celular é definido como a soma das visualizações de tablet e telefone. 
-- Gere a visualização total para laptops como laptop_reviewse a visualização total para dispositivos móveis como mobile_views.
SELECT
  COUNT(*) AS laptop_views,
  (SELECT COUNT(*) FROM viewership
  WHERE device_type = 'tablet' OR device_type = 'phone') AS mobile_views
FROM viewership 
WHERE device_type = 'laptop';

--5) Dada uma tabela de candidatos e suas habilidades, você tem a tarefa de encontrar os candidatos mais adequados para um trabalho aberto de ciência de dados. 
-- Você deseja encontrar candidatos que sejam proficientes em Python, Tableau e PostgreSQL.
-- Escreva uma consulta para listar os candidatos que possuem todas as habilidades necessárias para o trabalho. 
-- Classifique a saída por ID de candidato em ordem crescente.
SELECT candidate_id FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(*) = 3;

--6) Dada uma tabela de postagens do Facebook, para cada usuário que postou pelo menos duas vezes em 2021, 
-- escreva uma consulta para encontrar o número de dias entre a primeira postagem do ano de cada usuário e a última postagem do ano no ano de 2021. 
-- Saída do usuário e número de dias entre a primeira e a última postagem de cada usuário.
SELECT 
  user_id,
  DATE(MAX(post_date))-DATE(MIN(post_date)) AS number_of_days
FROM posts 
WHERE DATE_PART('year',DATE(post_date)) = 2021
GROUP BY user_id 
HAVING count(post_id) > 1;

--7) Escreva uma consulta para identificar os 2 principais usuários avançados que enviaram o maior número de mensagens no Microsoft Teams em agosto de 2022. 
-- Exiba as IDs desses 2 usuários junto com o número total de mensagens enviadas. Emita os resultados em ordem decrescente com base na contagem das mensagens.
SELECT sender_id, COUNT(message_id) AS message_count FROM messages
WHERE (date_part('month', sent_date)) = 08 AND (date_part('year', sent_date)) = 2022
GROUP BY sender_id
ORDER BY message_count DESC
LIMIT 2;

--8) Suponha que você receba a tabela abaixo que mostra as ofertas de emprego para todas as empresas na plataforma do LinkedIn. 
-- Escreva uma consulta para obter o número de empresas que publicaram listas de empregos duplicadas.
-- Listas de empregos duplicadas referem-se a dois empregos na mesma empresa com o mesmo título e descrição.
SELECT COUNT(company_id) AS co_w_duplicate_jobs FROM (
SELECT company_id, title, description, COUNT(job_id) FROM job_listings
GROUP BY company_id, title, description
HAVING COUNT(job_id) > 1) AS duplicate;

--9) Suponha que você receba as tabelas contendo ordens de negociação concluídas e detalhes do usuário em um sistema de negociação Robinhood.
--Escreva uma consulta para recuperar as três principais cidades com o maior número de ordens comerciais concluídas listadas em ordem decrescente. 
--Imprima o nome da cidade e o número correspondente de ordens comerciais concluídas.
SELECT city, COUNT(order_id) AS total_orders FROM trades T
JOIN users U
ON T.user_id = U.user_id
WHERE status = 'Completed'
GROUP BY city
order by total_orders DESC
LIMIT 3;

--10) Dada a tabela de avaliações, escreva uma consulta para recuperar a classificação média por estrelas de cada produto, agrupada por mês. 
-- A saída deve exibir o mês como um valor numérico, a ID do produto e a classificação média por estrelas arredondada para duas casas decimais. 
-- Classifique a saída primeiro por mês e depois por ID do produto.
SELECT 
  DATE_PART('month',DATE(submit_date)) AS mth, 
  product_id AS product, 
  ROUND(AVG(stars),2) AS avg_stars 
FROM reviews
GROUP BY mth, product
ORDER BY mth, product;

--11) Suponha que você tenha uma tabela de eventos na análise de aplicativos do Facebook. 
--Escreva uma consulta para calcular a taxa de cliques (CTR) do aplicativo em 2022 e arredonde os resultados para duas casas decimais.
--Definição e observação:
--Porcentagem da taxa de cliques (CTR) = 100,0 * Número de cliques / Número de impressões
--Para evitar a divisão inteira, multiplique o CTR por 100,0, não por 100.
SELECT
  app_id,
  ROUND(100.0 *
    SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) /
    SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END), 2)  AS ctr_rate
FROM events
WHERE DATE_PART('year',DATE(timestamp))=2022
GROUP BY app_id;

--12) Suponha que você receba tabelas com informações sobre inscrições e confirmações de usuários do TikTok por e-mail e texto. 
-- Novos usuários no TikTok se inscrevem usando seus endereços de e-mail e, após a inscrição, cada usuário recebe uma confirmação por mensagem de texto para ativar sua conta.
--Escreva uma consulta para exibir os IDs de usuário daqueles que não confirmaram sua inscrição no primeiro dia, mas confirmaram no segundo dia.
--Definição:
--action_date refere-se à data em que os usuários ativaram suas contas e confirmaram sua inscrição por meio de mensagens de texto.
SELECT user_id FROM emails E
JOIN texts T
ON E.email_id = T.email_id
WHERE signup_action='Confirmed' AND DATE(signup_date)+1 = action_date

--13) Sua equipe no JPMorgan Chase lançará em breve um novo cartão de crédito e, para obter algum contexto, 
-- você está analisando quantos cartões de crédito foram emitidos a cada mês.
-- Escreva uma consulta que gere o nome de cada cartão de crédito e a diferença no valor emitido entre o mês com mais cartões emitidos e o mês com menos cartões emitidos. 
-- Ordene os resultados de acordo com a maior diferença.
SELECT 
  card_name, 
  MAX(issued_amount)-MIN(issued_amount) AS difference 
FROM monthly_cards_issued 
GROUP BY card_name
ORDER BY difference DESC;

--14) Você está tentando encontrar o número médio de itens por pedido no Alibaba, 
-- arredondado para 1 casa decimal usando tabelas que incluem informações sobre a contagem de itens em cada pedido (tabela) item_counte o número correspondente de pedidos para cada contagem de item ( order_occurrencestabela) .
SELECT 
  ROUND(round(sum(item_count*order_occurrences),1)/round(sum(order_occurrences),1),1) as mean
FROM items_per_order;

--15) A CVS Health está tentando entender melhor as vendas de suas farmácias e como os diferentes produtos estão vendendo. 
-- Cada medicamento só pode ser produzido por um fabricante.
-- Escreva uma consulta para encontrar os 3 medicamentos mais lucrativos vendidos e quanto lucro eles obtiveram. 
-- Suponha que não haja empates nos lucros. Exiba o resultado do maior para o menor lucro total.
-- Definição:
-- cogs significa custo de mercadorias vendidas, que é o custo direto associado à produção do medicamento.
-- Lucro Total = Total de Vendas - Custo das Mercadorias Vendidas
SELECT drug, sum(total_sales-cogs) AS total_profit FROM pharmacy_sales
GROUP BY drug
ORDER BY total_profit DESC
LIMIT 3;

--16) A CVS Health está analisando seus dados de vendas de farmácias e como diferentes produtos estão sendo vendidos no mercado. 
-- Cada medicamento é fabricado exclusivamente por um único fabricante.
-- Escreva uma consulta para identificar os fabricantes associados aos medicamentos que resultaram em perdas para a CVS Health e 
-- calcule o valor total das perdas incorridas.
-- Gere o nome do fabricante, o número de medicamentos associados às perdas e as perdas totais em valor absoluto. 
-- Exiba os resultados classificados em ordem decrescente com as maiores perdas exibidas na parte superior.
SELECT
  manufacturer,
  COUNT(drug) AS drug_count, 
  SUM(cogs - total_sales) AS total_loss
FROM pharmacy_sales
WHERE cogs > total_sales
GROUP BY manufacturer
ORDER BY total_loss DESC

--17) A CVS Health está tentando entender melhor as vendas de suas farmácias e como os diferentes produtos estão vendendo.
-- Escreva uma consulta para encontrar o total de vendas de medicamentos para cada fabricante. 
-- Arredonde sua resposta para o milhão mais próximo e relate seus resultados em ordem decrescente do total de vendas.
-- Como esses dados estão sendo alimentados diretamente em um painel que está sendo visto pelas partes interessadas nos negócios, 
-- formate seu resultado assim: "US$ 36 milhões".

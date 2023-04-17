/****** Script dos comandos SQL dos exercicios do site https://www.sql-practice.com/ ******/
-- 1) Mostrar nome, sobrenome e g�nero de pacientes cujo g�nero � 'M'
SELECT [first_name], [last_name], [gender] FROM patients
WHERE [gender] = 'M';

-- 2) Mostrar nome e sobrenome de pacientes que n�o t�m alergias. (nulo)
SELECT [first_name], [last_name] FROM patients
WHERE [allergies] IS NULL;

-- 3) Mostrar o primeiro nome dos pacientes que come�am com a letra 'C'
SELECT [first_name] FROM patients
WHERE [first_name] LIKE 'C%';

-- 4) Mostrar nome e sobrenome de pacientes com peso entre 100 e 120 (inclusive)
SELECT [first_name], [last_name] FROM patients
WHERE [weight] between 100 AND 120;

-- 5) Atualize a tabela de pacientes para a coluna de alergias. Se a alergia do paciente for nula, substitua-a por 'NKA'
UPDATE patients
SET [allergies] = 'NKA'
WHERE [allergies] IS NULL;

-- 6) Mostre o nome e o sobrenome concatenados em uma coluna para mostrar o nome completo.
SELECT CONCAT([first_name], CONCAT(' ', [last_name])) AS 'full name' FROM patients;

-- 7) Mostrar nome, sobrenome e o nome completo da prov�ncia de cada paciente.
SELECT [first_name], [last_name], [province_name]
FROM patients
INNER join province_names
ON patients.[province_id] = province_names.[province_id]

-- 8) Mostre quantos pacientes t�m birth_date com 2010 como ano de nascimento.
SELECT COUNT(*) AS TotalDePacientes FROM patients
WHERE [birth_date] LIKE '2010%'; ou WHERE YEAR([birth_date]) = 2010;

-- 9) Mostre o first_name, last_name e a altura do paciente com a maior altura.
SELECT [first_name], [last_name], MAX([height]) AS MaiorAltura FROM patients;

-- 10) Mostrar todas as colunas para pacientes com um dos seguintes IDs de paciente: 1,45,534,879 e 1000
SELECT * FROM patients
WHERE [patient_id] IN (1,45,534,879,1000);

-- 11) Mostrar o n�mero total de admiss�es
SELECT COUNT(admissions.[patient_id]) As TotalAdminissao
FROM patients
INNER JOIN admissions
ON patients.[patient_id] = admissions.[patient_id]

-- 12) Mostre todas as colunas de interna��es em que o paciente foi internado e teve alta no mesmo dia.
SELECT * FROM admissions
WHERE [admission_date] = [discharge_date];

-- 13) Mostra o ID do paciente e o n�mero total de admiss�es para o Patient_id 579.
SELECT [patient_id], COUNT([patient_id]) AS TotalAdmissao
FROM admissions
WHERE [patient_id] = 579

-- 14) Com base nas cidades em que nossos pacientes moram, mostre cidades �nicas que est�o em provincia_id 'NS'?
SELECT DISTINCT[city] AS CidadeUnicasNS FROM patients
WHERE [province_id] = 'NS';

-- 15) Escreva uma consulta para encontrar o primeiro_nome, sobrenome e data de nascimento de pacientes com altura maior que 160 e peso maior que 70
SELECT [first_name], [last_name], [birth_date] FROM patients
WHERE [height] > 160 AND [weight] > 70;

-- 16) Escreva uma consulta para localizar a lista de pacientes first_name, last_name e alergias de Hamilton onde as alergias n�o s�o nulas
SELECT [first_name], [last_name], [allergies] FROM patients
WHERE [city] = 'Hamilton' AND [allergies] IS NOT null;

-- 17) Com base nas cidades onde nosso paciente mora, escreva uma consulta para exibir a lista de cidades �nicas come�ando com uma vogal (a, e, i, o, u). Mostra a ordem do resultado em ordem crescente por cidade.
SELECT DISTINCT([city]) FROM patients
WHERE [city] LIKE 'A%' OR [city] LIKE 'E%' OR [city] LIKE 'I%' OR [city] LIKE 'O%' OR [city] LIKE 'U%'
ORDER BY [city] ASC;

-- 18) Mostre anos de nascimento �nicos de pacientes e ordene-os em ordem crescente.
SELECT DISTINCT(YEAR([birth_date])) FROM patients
ORDER BY [birth_date];

-- 19) Mostra nomes �nicos da tabela de pacientes que ocorrem apenas uma vez na lista.
-- Por exemplo, se duas ou mais pessoas tiverem o nome 'John' na coluna first_name, n�o inclua seus nomes na lista de sa�da. Se apenas 1 pessoa for chamada de 'Leo', inclua-a na sa�da.
SELECT [first_name] FROM patients
GROUP BY [first_name]
HAVING COUNT(*) = 1

-- 20) Mostra o Patient_id e o first_name dos pacientes onde o first_name come�a e termina com 's' e tem pelo menos 6 caracteres.
SELECT [Patient_id], [first_name] FROM patients
WHERE [first_name] LIKE 'S%s' AND LEN([first_name]) > 5; ou WHERE [first_name] LIKE 's____%s';

-- 21) Mostra o Patient_id, first_name, last_name de pacientes cujo diagn�stico � 'Dementia'.
-- O diagn�stico prim�rio � armazenado na tabela de admiss�es.
SELECT admissions.[Patient_id], [first_name], [last_name] 
FROM patients
INNER join admissions
ON patients.[Patient_id] = admissions.[Patient_id]
WHERE [diagnosis] = 'Dementia';

-- 22) Exibe o nome de cada paciente.
-- Ordene a lista pelo comprimento de cada nome e depois por ordem alfab�tica
SELECT [first_name] FROM patients
ORDER BY LEN([first_name]) ASC, [first_name] ASC;

-- 23) Mostre a quantidade total de pacientes do sexo masculino e a quantidade total de pacientes do sexo feminino na tabela de pacientes.
-- Exiba os dois resultados na mesma linha.
SELECT 
	(SELECT COUNT([gender]) FROM patients WHERE [gender] = 'M') AS Masculino,
	COUNT([gender]) AS Feminino
FROM patients
WHERE [gender] = 'F'

-- 24) Mostrar nome e sobrenome, alergias de pacientes que t�m alergia a 'Penicilina' ou 'Morfina'. Mostrar resultados ordenados por alergias, depois por first_name e por last_name.
SELECT [first_name], [last_name], [allergies] FROM patients
WHERE [allergies] IN ('Penicillin', 'Morphine')
ORDER BY [allergies], [first_name], [last_name];

-- 25) Mostra o ID do paciente, diagn�stico das admiss�es. Encontre pacientes admitidos v�rias vezes para o mesmo diagn�stico.
SELECT [patient_id], [diagnosis] FROM admissions
GROUP BY [patient_id], [diagnosis]
HAVING COUNT(*) > 1;

-- 26) Mostra a cidade e o n�mero total de pacientes na cidade.
-- Ordene de mais para menos pacientes e, em seguida, pelo nome da cidade em ordem crescente.
SELECT [city], COUNT(patient_id) AS Total FROM patients
GROUP BY [city]
ORDER BY Total DESC, [city] ASC;

-- 27) Mostre o nome, o sobrenome e a fun��o de cada pessoa que � paciente ou m�dico.
-- As fun��es s�o "Paciente" ou "M�dico"
SELECT [first_name] as Nome, [last_name] As Sobrenome, 'Patient' As funcao  FROM patients
UNION ALL
SELECT [first_name] as Nome, [last_name] As Sobrenome, 'Doctor' As funcao  FROM doctors

-- 28) Mostrar todas as alergias ordenadas por popularidade. Remova os valores NULL da consulta.
SELECT [allergies], COUNT([allergies]) as Total FROM patients
WHERE [allergies] IS NOT NULL
GROUP BY [allergies]
ORDER BY Total DESC;

-- 29) Mostre o nome, sobrenome e data de nascimento de todos os pacientes que nasceram na d�cada de 1970. Classifique a lista a partir da data de nascimento mais antiga.
SELECT [first_name], [last_name], [birth_date] FROM patients
WHERE YEAR([birth_date]) between 1970 AND 1979
ORDER BY birth_date ASC;

-- 30) Queremos exibir o nome completo de cada paciente em uma �nica coluna. 
-- Seu sobrenome em letras mai�sculas deve aparecer primeiro, depois o primeiro nome em letras min�sculas. Separe o last_name e o first_name com uma v�rgula. 
-- Ordene a lista pelo first_name em ordem decrescente - EX: SMITH,jane
SELECT 
    CONCAT(UPPER([last_name]), CONCAT(',', LOWER([first_name]))) AS 'full name' ou CONCAT(UPPER([last_name]), ',', LOWER([first_name])) AS 'full name'
FROM patients
ORDER BY [first_name] DESC;

-- 31) Mostrar o(s) provincial_id(s), soma da altura; onde a soma total da altura de seu paciente � maior ou igual a 7.000.
SELECT [province_id], SUM([height]) AS Soma FROM patients
GROUP BY [province_id]
HAVING SUM([height]) >= 7000;

-- 32) Mostrar a diferen�a entre o maior peso e o menor peso para pacientes com o sobrenome 'Maroni'
SELECT MAX([weight]) - MIN([weight]) AS Diferen�aPeso FROM patients
WHERE [last_name] = 'Maroni'

-- 33) Mostra todos os dias do m�s (1-31) e quantas datas de admiss�o ocorreram naquele dia. Classifique pelo dia com mais admiss�es para menos admiss�es.
SELECT DAY([admission_date]) AS Dias, COUNT(*) AS Total FROM admissions
GROUP BY DAY([admission_date])
ORDER BY Total DESC

-- 34) Mostra todas as colunas para a data de admiss�o mais recente do Patient_id 542.
SELECT * FROM admissions
WHERE [patient_id] = 542
ORDER BY [admission_date] DESC
LIMIT 1;
ou
SELECT * FROM admissions
WHERE [patient_id] = 542
GROUP BY patient_id
HAVING admission_date = MAX(admission_date);

-- 35) Mostre o Patient_id, Attend_doctor_id e o diagn�stico para admiss�es que correspondam a um dos dois crit�rios:
-- 1. Patient_id � um n�mero �mpar e Attend_doctor_id � 1, 5 ou 19.
-- 2. Attend_doctor_id cont�m um 2 e o comprimento de Patient_id � 3 caracteres.
SELECT [patient_id], [attending_doctor_id], [diagnosis] FROM admissions
WHERE 
	(([patient_id] % 2 != 0) AND ([attending_doctor_id] IN (1,5,19))) 
	OR 
    ([attending_doctor_id] LIKE '%2%') AND (LEN([patient_id])=3)

-- 36) Mostra first_name, last_name e o n�mero total de interna��es atendidas por cada m�dico.
-- Cada interna��o foi acompanhada por um m�dico.
SELECT doctors.[first_name], doctors.[last_name], COUNT([patient_id]) AS TotaldeInternacao FROM admissions
INNER JOIN doctors
ON admissions.[attending_doctor_id] = doctors.[doctor_id]
GROUP BY doctors.[first_name], doctors.[last_name]

-- 37) Para cada m�dico, exiba sua identifica��o, nome completo e a primeira e a �ltima data de interna��o em que compareceram.
SELECT 
	D.[doctor_id], 
    CONCAT(D.[first_name], CONCAT(' ', D.[last_name])) AS 'Full name',
    MIN(A.[admission_date]) As PrimeiraInternacao, 
    MAX(A.[admission_date]) AS UltimaInternacao
FROM admissions A
INNER JOIN doctors D
ON A.[attending_doctor_id] = D.[doctor_id]
group by D.[doctor_id]

-- 38) Exiba a quantidade total de pacientes para cada prov�ncia. Ordem decrescente.
SELECT 
	PN.[province_name], 
	COUNT(*) AS Total
FROM patients P
INNER JOIN province_names PN
ON P.[province_id] = PN.[province_id]
group by PN.[province_name]
ORDER BY Total DESC

-- 39) Para cada admiss�o, exiba o nome completo do paciente, o diagn�stico de admiss�o e o nome completo do m�dico que diagnosticou o problema.
SELECT 
	CONCAT(P.[first_name], CONCAT(' ', P.[last_name])) AS 'Full name do Paciente',
    A.[diagnosis],
    CONCAT(D.[first_name], CONCAT(' ', D.[last_name])) AS 'Full name do M�dico'
FROM patients P
INNER JOIN admissions A
ON P.[patient_id] = A.[patient_id]
	INNER JOIN doctors D
    ON A.[attending_doctor_id] = D.[doctor_id]

-- 40) exibir o n�mero de pacientes duplicados com base em seu nome e sobrenome.
select [first_name], [last_name], COUNT(*) AS Duplicados FROM patients
group by [first_name], [last_name]
having COUNT(*) > 1

-- 41) Exibe o nome completo do paciente, altura em p�s arredondados para 1 decimal, peso em libras arredondado para 0 decimal, data_nascimento, g�nero n�o abreviado.
-- Converta CM para p�s dividindo por 30,48.
-- Converta KG para libras multiplicando por 2,205.
select 
	CONCAT([first_name], CONCAT(' ', [last_name])) AS 'Paciente',
    ROUND(([height]/30.48),1) AS 'Altura em p�s',
    ROUND(([weight]*2.205),0) AS 'Peso em libras',
    [birth_date] AS 'Data',
    REPLACE(REPLACE([gender],'M','MALE'),'F','FEMALE') AS 'Genero'
FROM patients
group by [patient_id]

-- 42) Mostre todos os pacientes agrupados em grupos de peso. 
-- Mostre a quantidade total de pacientes em cada grupo de peso.
-- Ordene a lista pelo grupo de peso decrescente.
-- Por exemplo, se eles pesam de 100 a 109, eles s�o colocados no grupo de peso 100, 110-119 = grupo de peso 110, etc.
select 
	COUNT(*) AS Total,
    floor([weight]/10) * 10 As Peso ou TRUNCATE([weight], -1) AS Peso ou [weight] - [weight] % 10 AS Peso
FRom patients
group by Peso
order by Peso DESC;

-- 43) Mostre o ID_do_paciente, peso, altura, "� Obeso?" da tabela de pacientes.
-- Exibe "� Obeso?" como booleano 0 ou 1.
-- Obeso � definido como peso(kg)/(altura(m)�) >= 30.
-- o peso est� em unidades kg.
-- a altura est� em unidades cm.
SELECT [patient_id], [weight], [height], 
	(case
     WHEN [weight]/(POWER([height]/100.0, 2)) >= 30 THEN 1
     ELSE 0
     END) AS Obseo
FROm patients

-- 44) Mostra o Patient_id, first_name, last_name e a especialidade do m�dico assistente.
-- Mostrar apenas os pacientes com diagn�stico de 'Epilepsia' e o primeiro nome do m�dico � 'Lisa'
-- Verifique as tabelas de pacientes, interna��es e m�dicos para obter as informa��es necess�rias.
SELECT 
	P.[patient_id], 
    P.[first_name], 
    P.[last_name], 
    D.[specialty] 
FROM patients P
INNER JOIN admissions A
ON P.[patient_id] = A.[patient_id]
	INNER JOIN doctors D
    ON A.[attending_doctor_id] = D.[doctor_id]
WHERE A.[diagnosis] = 'Epilepsy' AND D.[first_name] = 'Lisa'   

-- 45) Todos os pacientes que passaram por interna��es, podem consultar seus documentos m�dicos em nosso site. Esses pacientes recebem uma senha tempor�ria ap�s sua primeira admiss�o. Mostre o Patient_id e temp_password.
-- A senha deve ser a seguinte, em ordem:
-- 1. ID_do_paciente
-- 2. Comprimento num�rico do sobrenome do paciente
-- 3. Ano da data_de_nascimento do paciente
SELECT 
	A.[patient_id], 
    CONCAT(P.[patient_id], len(P.[last_name]), YEAR(P.[birth_date])) As temp_password
FROM patients P
INNER JOIN admissions A
ON P.[patient_id] = A.[patient_id]
group by A.[patient_id]

-- 46) Cada admiss�o custa $ 50 para pacientes sem seguro e $ 10 para pacientes com seguro. Todos os pacientes com um ID de paciente par t�m seguro.
-- D� a cada paciente um 'Sim' se tiver seguro e um 'N�o' se n�o tiver seguro. Some o custo admiss�o_total para cada grupo has_insurance.

-- [patient_id] % 2 = 0 com seguro - 10 - SIM
-- [patient_id] % 2 != 0 sem seguro - 50 - N�O
-- has_insurance
-- admiss�o_total = soma dos custos
SELECT 
	(CASE 
     	WHEN [patient_id] % 2 = 0 THEN 'Yes'
     	ELSE 'No'
     END) AS has_insurance,
     (CASE 
     	WHEN [patient_id] % 2 = 0 THEN SUM([patient_id] % 2 = 0) * 10
     	ELSE SUM([patient_id] % 2 != 0) * 50
     END) As admiss�o_total
FROM admissions 
group by has_insurance

-- 47) Mostre as prov�ncias que t�m mais pacientes identificados como 'M' do que como 'F'. Deve mostrar apenas o nome_prov�ncia completo
SELECT 
	PN.[province_name]
FROm patients P
INNER JOIn province_names PN
ON P.[province_id] = PN.[province_id]
group by PN.[province_name]
having COUNT(CASE WHEN [gender] = 'M' THEN 1 END) > count(CASE WHEN [gender] = 'F' THEN 1 END);

-- 48) Estamos procurando um paciente espec�fico. Puxe todas as colunas para o paciente que corresponde aos seguintes crit�rios:
-- - First_name cont�m um 'r' ap�s as duas primeiras letras.
-- - Identifica o sexo como 'F'
-- - Nasceu em fevereiro, maio ou dezembro
-- - Seu peso seria entre 60kg e 80kg
-- - O ID do paciente � um n�mero �mpar
-- - Eles s�o da cidade 'Kingston'
SELECT * FROm patients
WHERE 
	([first_name] LIKE '__r%') 
	AND ([gender] = 'F')
    AND (month([birth_date]) IN (2,5,12))
    AND ([weight] between 60 AND 80)
    AND ([patient_id] % 2 != 0)
    AND ([city] = 'Kingston');

-- 49) Mostre a porcentagem de pacientes que t�m 'M' como g�nero. Arredonde a resposta para o cent�simo mais pr�ximo e na forma de porcentagem.
SELECT 
	CONCAT(ROUND((SELECT COUNT(*) FROm patients WHERE [gender] = 'M') * 100.0 / COUNT(*), 2),'%') As Porcetagem 
FROm patients

-- 50) Para cada dia, exiba a quantidade total de admiss�es naquele dia. Exibe o valor alterado desde a data anterior.
SELECT 
	[admission_date], 
    COUNT(DAY([admission_date])) AS admissions_day,  
    count([admission_date]) - LAG(count([admission_date])) OVER(ORDER BY [admission_date]) AS P
FROM admissions
group by [admission_date]

-- 51) Classifique os nomes das prov�ncias em ordem crescente de forma que a prov�ncia 'Ont�rio' esteja sempre no topo.
SELECT 
	[province_name]
FROm province_names
ORDER BY (CASE 
     WHEN [province_name] = 'Ontario' THEN 0
     ELSE 1
     END), [province_name];

-- 52) Mostre o primeiro_nome e o sobrenome do funcion�rio, uma coluna "num_pedidos" com uma contagem dos pedidos recebidos e uma coluna chamada "Enviado" que exibe "Na hora" se o pedido foi enviado no prazo e "Atrasado" se o pedido foi enviado com atraso. Ordene por sobrenome do funcion�rio, depois por primeiro_nome e, em seguida, decrescente por n�mero de pedidos.
SELECT 
	E.[first_name],
    E.[last_name],
    count(O.[order_id]) AS num_orders,
    (CASE
    	WHEN O.[shipped_date] > O.[required_date] THEN 'Late'
    	ELSE 'On Time' 
    END) AS 'shipped'
FROM employees E 
INNER JOIN orders O
ON E.[employee_id] = O.[employee_id]
group by E.[first_name], E.[last_name], shipped
ORDER BY E.[last_name], E.[first_name], num_orders DESC;

-- 53) Mostre o category_name e a descri��o da tabela de categorias classificadas por category_name.
SELECT [category_name], [description] FROm categories
ORDER By [category_name];

-- 54) Mostrar todos os contact_name, endere�o, cidade de todos os clientes que n�o s�o da 'Alemanha', 'M�xico', 'Espanha'
SELECT [contact_name], [address], [city] FROm customers
WHERE [country] NOT In ('Germany','Mexico','Spain');

-- 55) Mostrar order_date, shipping_date, customer_id, Frete de todos os pedidos feitos em 26 de fevereiro de 2018
SELECT [order_date], [shipped_date], [customer_id], [freight] FROm orders
WHERE [order_date] = '2018-02-26';

-- 56) Mostre o employee_id, order_id, customer_id, required_date, shipping_date de todos os pedidos enviados ap�s a data exigida
SELECT [employee_id], [order_id], [customer_id], [required_date], [shipped_date] FROm orders
WHERE [shipped_date] > [required_date];

-- 57) Mostrar todos os Order_id de n�mero par da tabela de pedidos
SELECT [order_id] FROm orders
WHERE [order_id] % 2 = 0; ou WHERE MOD([order_id],2)=0

-- 58) Mostrar a cidade, company_name, contact_name de todos os clientes de cidades que contenham a letra 'L' no nome da cidade, classificados por contact_name
SELECT [city], [company_name], [contact_name] FROm customers
WHERE [city] LIKE '%L%'
ORDER By [contact_name];

-- 59) Mostre o nome_da_empresa, nome_do_contato e n�mero de fax de todos os clientes que possuem um n�mero de fax. (n�o nulo)
SELECT [company_name], [contact_name], [fax] FROm customers
WHERE [fax] IS NOT NULL;

-- 60) Mostre o first_name, last_name do funcion�rio contratado mais recentemente.
SELECT [first_name], [last_name], [hire_date] FROm employees
ORDER BY [hire_date] DESC
LIMIT 1;

-- 61) Mostrar o pre�o unit�rio m�dio arredondado para 2 casas decimais, o total de unidades em estoque, o total de produtos descontinuados da tabela de produtos.
SELECT 
	ROUND(AVG([unit_price]),2) AS 'pre�o unit�rio m�dio', 
    SUM([units_in_stock]) AS 'total de unidades em estoque', 
    SUM([discontinued]) As 'total de produtos descontinuados'
FROm products;

-- 62) Mostre o ProductName, CompanyName, CategoryName da tabela de produtos, fornecedores e categorias
SELECT 
	PP.[product_name],
    SS.[company_name],
	CC.[category_name]    
FROm categories CC
INNER JOIN products PP
ON CC.[category_id] = PP.[category_id]
	INNER JOIN suppliers SS
    ON PP.[supplier_id] = SS.[supplier_id]

-- 63) Mostre o category_name e o pre�o unit�rio m�dio do produto para cada categoria arredondado para 2 casas decimais.
SELECT 
	CC.[category_name], 
  	ROUND(AVG(PP.[unit_price]),2) as 'pre�o unit�rio m�dio'
FROm categories CC
INNER JOIN products PP
ON CC.[category_id] = PP.[category_id]
group by CC.[category_name]

-- 64) Mostra a cidade, nome_da_empresa, nome_do_contato das tabelas clientes e fornecedores mescladas.
-- Crie uma coluna que contenha 'clientes' ou 'fornecedores' dependendo da tabela de onde veio.
SELECT 
	[city], 
    [company_name], 
    [contact_name],
    'customers' As relacao
FROm customers 
union 
SELECT 
	[city], 
    [company_name], 
    [contact_name],
    'suppliers' As relacao
FROm suppliers 






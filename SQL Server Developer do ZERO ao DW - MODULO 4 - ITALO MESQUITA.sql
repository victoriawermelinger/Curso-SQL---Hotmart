----------------------------------------
-------------- MODULO 4 ----------------
----------------------------------------

-- NULL -> TOTALMENTE AUSENTE DE INFORM��O 
-- NULL <> '' (vazio)

select CIDADE, ESTADO, MUNICIPIO, COMPLEMENTO
from enderecos
where MUNICIPIO <> 1832

select CIDADE, ESTADO, MUNICIPIO, COMPLEMENTO
from enderecos
where COMPLEMENTO <> 'cnpj: 00.029.372/0007-36'

SELECT CIDADE, ESTADO, MUNICIPIO, MUNICIPIO +10 
FROM ENDERECOS

---------------------------FUNçõES------------------------
-- ISNULL() -> FUN��O PARA TRATAR VALORES NULOS (NULL)
-- COALESCE() -> FUN��O PAD�O ANSI PARA TRATAR VALOR NULOS (NULL)

select CIDADE
, ESTADO
, MUNICIPIO
, COMPLEMENTO
, ISNULL (COMPLEMENTO, 'SEM COMPLEMENTO') AS FUNCAO_ISNULL
, COALESCE (COMPLEMENTO, 'SEM COMPLEMENTO') AS FUNCAO_COALESCE
from enderecos

SELECT COALESCE (VENDEDOR, -1) AS VENDEDOR 
, PRODUTO
, QUANTIDADE 
FROM VENDAS_ANALITICAS

SELECT COALESCE (VENDEDOR, -1) AS VENDEDOR 
, PRODUTO
, QUANTIDADE 
FROM VENDAS_ANALITICAS

select CIDADE
, ESTADO
, MUNICIPIO
, COALESCE (MUNICIPIO, -1)
from enderecos
where COALESCE (MUNICIPIO, -1) = -1 

SELECT CIDADE
, ESTADO
, ISNULL (MUNICIPIO, -1)
FROM ENDERECOS

---------------------OPERADORES------------------
/*
IS NULL 
IS NOT NULL 
*/
-- RECUPERANDO APENAS VALORES NULOS 
SELECT CIDADE
, ESTADO 
, MUNICIPIO
, COALESCE (MUNICIPIO , -1)
FROM ENDERECOS 
WHERE COALESCE(MUNICIPIO , -1)= -1

SELECT CIDADE
, ESTADO 
, MUNICIPIO
, COALESCE (MUNICIPIO , -1)
FROM ENDERECOS 
WHERE MUNICIPIO IS NULL

-- RECUPERANDO APENAS VALORES NAO NULOS 
SELECT CIDADE
, ESTADO 
, MUNICIPIO
, COALESCE (MUNICIPIO , -1)
FROM ENDERECOS 
WHERE COALESCE(MUNICIPIO , -1)<> -1

SELECT CIDADE
, ESTADO 
, MUNICIPIO
, COALESCE (MUNICIPIO , -1)
FROM ENDERECOS 
WHERE MUNICIPIO IS NOT NULL

/*
-- NULLIF = A fun��o NULLIF � usada para retornar NULL se dois valores forem iguais,
	caso contr�rio, retorna o�primeiro�valor.
*/

SELECT CIDADE
, ESTADO 
, COMPLEMENTO
, NULLIF (NULLIF( COMPLEMENTO, '') , 'CNPJ: 00.029.372/0007-36')AS FUNCAO_NULLIF
FROM ENDERECOS

SELECT CIDADE
, ESTADO 
, COMPLEMENTO
, NULLIF (NULLIF( COMPLEMENTO, '') , 'CNPJ: 00.029.372/0007-36')AS FUNCAO_NULLIF
FROM ENDERECOS
WHERE NULLIF (NULLIF (COMPLEMENTO, ''), 'CNPJ: 00.029.372/0007-36') IS  NOT NULL

/*
CEILING() = ARRENDONDA VALORES PARA BAIXO 
FLOOR() = ARRENDONDA VALORES PARA CIMA 
ROUND() = ARRENDONDA VALORES DE ACORDO COM CRITERIOS MATMEMATICOS
ABS() = RETORNA VALORES ABSOLUTOS 
*/

SELECT TOP 1000
  PRODUTO
, QUANTIDADE
, VENDA_BRUTA
, CEILING(VENDA_BRUTA) AS FUNCAO_CEILING
, FLOOR(VENDA_BRUTA) AS FUNCAO_FLOOR
, ROUND(VENDA_BRUTA,0) AS FUNCAO_ROUND_0
, ROUND(VENDA_BRUTA,1) AS FUNCAO_ROUD_1
, ABS(VENDA_BRUTA) AS FUNCAO_ABS
FROM VENDAS_ANALITICAS

SELECT TOP 1000
  PRODUTO
, QUANTIDADE
, VENDA_BRUTA
, CEILING(VENDA_BRUTA) AS FUNCAO_CEILING
, FLOOR(VENDA_BRUTA) AS FUNCAO_FLOOR
, ROUND(VENDA_BRUTA,0) AS FUNCAO_ROUND_0
, ROUND(VENDA_BRUTA,1) AS FUNCAO_ROUD_1
, ABS(VENDA_BRUTA) AS FUNCAO_ABS
FROM VENDAS_ANALITICAS
WHERE ABS(CEILING(VENDA_BRUTA)) = 360

----------------------------
----------DESAFIO-----------
----------------------------

-- DESAFIO 01

SELECT TOP 100
  COALESCE (VENDEDOR,0) AS VENDEDOR 
, PRODUTO
, QUANTIDADE
, ROUND (VENDA_BRUTA / QUANTIDADE,02)AS VALOR_UNITARIO 
, VENDA_BRUTA 
FROM VENDAS_ANALITICAS
WHERE VENDEDOR IS NULL 
ORDER BY VALOR_UNITARIO DESC

SELECT TOP 100
  VENDEDOR 
, PRODUTO
, QUANTIDADE
, ROUND (VENDA_BRUTA / QUANTIDADE,02)AS VALOR_UNITARIO 
, VENDA_BRUTA 
FROM VENDAS_ANALITICAS
WHERE VENDEDOR IS NOT NULL 
ORDER BY VALOR_UNITARIO DESC

/*
GETDATE = retorna a data e a hora atuais do sistema. 

YEAR = ANO
MONTH = M�S
DAY = DIA 
*/

SELECT GETDATE() AS DATA_HORA_ATUAL
, YEAR(GETDATE())AS AN0
, MONTH(GETDATE())AS MES
, DAY(GETDATE())AS DIA

SELECT NOME
, DATA_CADASTRO
, YEAR (DATA_CADASTRO)AS ANO_CADASTRO
, MONTH (DATA_CADASTRO) AS MES_CADASTRO
, DAY (DATA_CADASTRO) AS DIA_CADASTRO
FROM ENTIDADES
ORDER BY ANO_CADASTRO

/*
--DATEPART � uma fun��o usada em SQL para extrair uma parte espec�fica de uma 
		data ou hora, como ano, m�s,�dia,�hora,�etc.

YEAR = ANO 
MONTH = M�S
DAY = DIA
QUARTER = QUADRIMESTRE
DAYOFYEAR = DIA E ANO 
WEEK = SEMANA
WEEKDAY = DIA DA SEMANA
HOUR = HORA 
MINUTE = MINUTO
SECOND = SEGUNDO
*/

SELECT GETDATE() AS DATA_HORA_ATUAL
, YEAR(GETDATE())AS AN0
, MONTH(GETDATE())AS MES
, DAY(GETDATE())AS DIA
, DATEPART(HOUR, GETDATE()) AS HORAS
, DATEPART(MINUTE, GETDATE()) AS MINUTO
, DATEPART(QUARTER, GETDATE()) 
, DATEPART(WEEK, GETDATE()) AS SEMANA 
, DATEPART(WEEKDAY, GETDATE()) AS DIA_SEMANA

SELECT NOME
, DATA_CADASTRO
, YEAR (DATA_CADASTRO)AS ANO_CADASTRO
, MONTH (DATA_CADASTRO) AS MES_CADASTRO
, DAY (DATA_CADASTRO) AS DIA_CADASTRO
, DATEPART(WEEK, DATA_CADASTRO) AS SEMANA_CADASTRO
, DATEPART (WEEKDAY, DATA_CADASTRO) AS DIA_SEMANA_CADASTRO
, DATEPART (DAYOFYEAR, DATA_CADASTRO) AS DIA_ANO_CADASTRO
FROM ENTIDADES
WHERE DATEPART(WEEK, DATA_CADASTRO) = 6
ORDER BY ANO_CADASTRO


/* 
DATEADD =   � uma fun��o utilizada em linguagens de programa��o e bancos de dados para adicionar uma quantidade espec�fica de tempo a uma data.
Ela permite adicionar anos, meses, dias, horas, minutos ou segundos a uma�data�existente.
*/

SELECT GETDATE() AS DATA_HORA_ATUAL
, YEAR(GETDATE())AS AN0
, MONTH(GETDATE())AS MES
, DAY(GETDATE())AS DIA
, DATEPART(HOUR, GETDATE()) AS HORAS
, DATEPART(MINUTE, GETDATE()) AS MINUTO
, DATEPART(QUARTER, GETDATE()) AS N
, DATEPART(WEEK, GETDATE()) AS SEMANA 
, DATEPART(WEEKDAY, GETDATE()) AS DIA_SEMANA 
, DATEADD(YEAR,1 ,GETDATE())


SELECT TITULO
, VENCIMENTO
, DATEADD(DAY, 10, VENCIMENTO) AS VENCIMENTO_PARA_PROTESTO
 FROM TITULOS_RECEBER

 /*
DATEDIFF = � uma fun��o utilizada em linguagens de programa��o e bancos de dados para calcular a diferen�a entre duas datas. 
Ela retorna o n�mero de unidades de tempo (anos, meses, dias, horas, minutos, segundos) entre as duas datas�especificadas.
EOMONTH = � uma fun��o utilizada em linguagens de programa��o e bancos de dados para retornar a data do �ltimo dia do m�s de uma data especificada. 
Ela pode ser �til para c�lculos relacionados a datas, como encontrar o �ltimo dia do m�s para fins de faturamento ou�planejamento.
*/

SELECT GETDATE() AS DATA_HORA_ATUAL
, YEAR(GETDATE())AS AN0
, MONTH(GETDATE())AS MES
, DAY(GETDATE())AS DIA
, DATEPART(HOUR, GETDATE()) AS HORAS
, DATEPART(MINUTE, GETDATE()) AS MINUTO
, DATEPART(QUARTER, GETDATE()) AS N 
, DATEPART(WEEK, GETDATE()) AS SEMANA 
, DATEPART(WEEKDAY, GETDATE()) AS DIA_SEMANA 
, DATEADD(YEAR,1 ,GETDATE())


SELECT NOME
, DATA_CADASTRO
, YEAR (DATA_CADASTRO)AS ANO_CADASTRO
, MONTH (DATA_CADASTRO) AS MES_CADASTRO
, DAY (DATA_CADASTRO) AS DIA_CADASTRO
, DATEPART(WEEK, DATA_CADASTRO) AS SEMANA_CADASTRO
, DATEPART (WEEKDAY, DATA_CADASTRO) AS DIA_SEMANA_CADASTRO
, DATEPART (DAYOFYEAR, DATA_CADASTRO) AS DIA_ANO_CADASTRO
, DATEDIFF(YEAR, DATA_CADASTRO, GETDATE())AS DIFERENCAS_EM_ANOS
, CONCAT(DATEDIFF(YEAR, DATA_CADASTRO, GETDATE()), 'ANOS')AS DIFERENCAS_EM_ANOS
, CONCAT(DATEDIFF(MONTH, DATA_CADASTRO, GETDATE()), 'MESES')AS DIFERENCAS_EM_MESES
, CONCAT(DATEDIFF(DAY, DATA_CADASTRO, GETDATE()), 'DIAS')AS DIFERENCAS_EM_DIAS 
FROM ENTIDADES
WHERE DATEPART(WEEK, DATA_CADASTRO) = 6
ORDER BY ANO_CADASTRO

SELECT TITULO
, MOVIMENTO
, VENCIMENTO
, DATEDIFF( DAY, MOVIMENTO, VENCIMENTO) AS PRAZO
, CONCAT (DATEDIFF(DAY ,MOVIMENTO, VENCIMENTO),' DIAS DE PRAZO') AS PRAZO
, EOMONTH(MOVIMENTO) AS ULTIMO_DIA_MES
, DAY(EOMONTH(MOVIMENTO)) AS ULTIMO_DIA_MES
 FROM TITULOS_RECEBER
 
 /*
 UPPER = � utilizada para converter uma string para letras mai�sculas. Por exemplo, "hello" se tornaria�"HELLO".
 LOWER = � utilizada para converter uma string para letras min�sculas. Por exemplo, "WORLD" se tornaria�"world".
 REPLACE = �  utilizada para substituir uma substring por outra em uma string.
	Por exemplo, replace("Hello, world!", "world", "universe") resultaria em "Hello,�universe!".
 LEN = � utilizada para obter o comprimento de uma string, ou seja, o n�mero de caracteres presentes na string. 
	Por exemplo, len("hello")�retornaria�5.
 */
 
 SELECT NOME
, UPPER(NOME) AS LETRAS_MAIUSCULAS
, LOWER(NOME_FANTASIA) AS LETRAS_MINISCULAS 
, REPLACE(NOME, 'CLIENTE',' ') AS FUNCAO_REPLACE
, REPLACE(NOME, 'ENTE','__') AS FUNCAO_REPLACE2
, LEN (NOME)AS QUANTIDADE_CARACCTERES 
 FROM ENTIDADES

 /*
 LEFT = retorn9a os primeiros caracteres de uma string. Ela � usada para extrair uma parte inicial da string com base na quantidade de caracteres desejada.
	Por exemplo, LEFT("Hello", 3) retornaria�"Hel".
 RIGTH = retorna os �ltimos caracteres de uma string. Ela � usada para extrair uma parte final da string com base na quantidade de caracteres desejada.
	Por exemplo, RIGHT("Hello", 3) retornaria�"llo".
 SUBSTRING =  usada para extrair uma parte espec�fica de uma string. Ela requer tr�s argumentos: a string original, a posi��o inicial e a quantidade de caracteres a serem extra�dos. 
	Por exemplo, SUBSTRING("Hello", 2, 3) retornaria "ell". 
	Isso significa que a extra��o come�aria na posi��o 2 da string original e pegaria os pr�ximos�3�caracteres.
 */

 SELECT NOME
, LEFT(NOME, 7)
, RIGHT(NOME,4)
, SUBSTRING(NOME, 4, 3)
 FROM ENTIDADES 

 /*
CHARINDEX = � usada para encontrar a posi��o de uma substring dentro�de�uma�string.
TRIM = remove os espa�os em branco tanto no in�cio quanto no final da string.
RTRIM = remove os espa�os em branco do final da string.
LTRIM = remove os espa�os em branco do in�cio�da�string.
 */

 SELECT LTRIM (' ITALO MESQUITA ')
 SELECT RTRIM (' ITALO MESQUITA ')
 SELECT TRIM (' ITALO MESQUITA ')

SELECT CIDADE
, CHARINDEX(' ', CIDADE) AS POSICAO_DO_ESPACO
 FROM ENDERECOS
 WHERE CIDADE LIKE 'S_O PAULO'

 SELECT NOME 
, CHARINDEX (' ', NOME) AS POSICAO_DO_ESPACO
, LEN(NOME) AS QUANTIDADE_CARACTERES
, SUBSTRING (NOME, 1, CHARINDEX (' ', NOME) -1) AS NOME 
, SUBSTRING(NOME, CHARINDEX (' ', NOME) +1, LEN(NOME) - CHARINDEX (' ', NOME)) AS SOBRENOME 
 FROM ENTIDADES

 -------DESAFIO-------
 /* RECUPERE DA TABELA TITULOS_RECEBER AS COLUNAS 

 DOCUMEN ENTIDADE
 TITULO
TO
 PARCELA
 PRAZO

 APENAS DA ENTIDADE DE C�DIGO 1824, SEGUINDO AS SEGUINTES REGRAS 
 1. DOCUMENTO � O VALOR CONTIDO NO CAMPO T�TULO ANTES DA "/"
 2. A PARCELA � O VALOR CONTIDO NO CAMPO T�TULO AP�S A "/"
 3. O PRAZO � A DIFEREN�A EM DIAS ENTRE O MOVIMENTO E O VENCIMENTO 
 4.ORDENE AS INFOMA��ES PELO PRAZO EM ORDEM DECRESCENTE 
 */

 SELECT ENTIDADE
 ,  TITULO
 , CHARINDEX ('/', TITULO) AS POSSICAO_BARRA 
 , SUBSTRING(TITULO, 1, CHARINDEX ('/', TITULO) -1) AS DOCUMENTO
 , SUBSTRING(TITULO, CHARINDEX ('/', TITULO) +1, LEN(TITULO) - CHARINDEX ('/', TITULO)) AS PARCELA
 , DATEDIFF(DAY, MOVIMENTO, VENCIMENTO) AS PRAZO
  FROM TITULOS_RECEBER
  where ENTIDADE = 1824
  ORDER BY PRAZO DESC

  -- FUNÇÕES DE AGREGAÇÃO 
  /*
  SUM --  SOMA VALORES DE UMA COLUNA 
  MIN --  MENOR VALOR DE UMA COLUNA 
  MAX --  MAIOR VALOR DE UMA COLUNA
  AVG --  MÉDIA DA COLUNA 
COUNT --  CONTA VALORES RESULTANTES DE UMA QUERY
  */

SELECT SUM(QUANTIDADE) AS SOMA_QUANTIDADE_TOTAL 
, MIN(QUANTIDADE) AS MENOR_QUANTIDADE
, MAX(QUANTIDADE) AS MAIOR_QUANTIDADE
, AVG(QUANTIDADE) AS MEDIA_QUANTIDADE
, COUNT(QUANTIDADE) AS VALORES_RESULTANTES 
   FROM VENDAS_ANALITICAS

select PRODUTO
, CLIENTE
, sum(QUANTIDADE) as total_vendido
, avg(quantidade) as media 
, count(*) as quantidade_compras 
   from VENDAS_ANALITICAS
  where produto = 34902
  group by produto, cliente

select cliente
, count(distinct produto)
from VENDAS_ANALITICAS
group by cliente 

select distinct produto
 from VENDAS_ANALITICAS
where cliente = 1983

-- Filtrando valores agregados através da cláusula HAVING

SELECT PRODUTO
, CLIENTE
, SUM(QUANTIDADE) AS QUANTIDADE
, SUM(VENDA_BRUTA) AS VENDA_BRUTA
   FROM VENDAS_ANALITICAS
   where produto = 34902
group by produto , cliente 
having SUM(QUANTIDADE) >10
	and sum(VENDA_BRUTA)<>65.000
order by QUANTIDADE


/* Ordem lógica de execução 
-- from 
-- where
-- group by 
-- having
-- select
-- order by 
*/
----------------------------------------------
---DESAFIO---
/* RECUPERE AS INFOMAÇÕES DE:
1. CLIENTE 
2. QUANTIDADE_TOTAL (SOMA DA COLUNA QUANTIDADE)
3. VENDAS_LIQUIDAS_TOTAL (SOMA DA COLUNA VENDA LIQUIDA)
4. ITENS_COMPRADOS (CONTAGEM DESTITA DOS PRODUTOS ADIQUIRIDOS PELO CLIENTE)

* AS VENDAS DEVEM SER APENAS DO VENDEDOR DE CODIGO 
* A CONSULTA DEVERA TRAZER APENAS OS CLIENTES QUE TEVERAM ITENS_COMPRADOS SUPERIOR A 50
* ORDENE A CONSULTA PELOS ITENS_COMPRADOS SENDO DO MAIOR PARA O MENOR
-> TEBELA: VENDAS_ANALITICAS
*/

select * from VENDAS_ANALITICAS

select CLIENTE as cliente
, sum (QUANTIDADE) as quantidade_total
, sum (VENDA_LIQUIDA) as venda_liquida_total
, count (distinct PRODUTO) as intens_comprados 
from VENDAS_ANALITICAS
where VENDEDOR = 1 
group by CLIENTE
having count (distinct PRODUTO) > 50
order by quantidade_total desc

-- CASE WHER
/*
MENOR OU IGUAL A 0 -> SEM COMISSAO
ENTRE 1 A 500	   -> 1% DE COMISSAO
ENTRE 500 E 10K	   -> 2% DE COMISSAO
ACIMA DE 10K	   -> 3% DE COMISSAO 
*/
-- pra vendas nulas 
select VENDEDOR
, VENDA_LIQUIDA
, case when coalesce( VENDA_LIQUIDA, 0)  <= 0
then 'sem comissão'
	when VENDA_LIQUIDA between 1 and 500
	then '1%'
	when VENDA_LIQUIDA >= 501 and VENDA_LIQUIDA <= 10000 --between 501 and 10000
	then '2%'
	else '3%'
 end
from VENDAS_ANALITICAS
where VENDEDOR is not null

select VENDEDOR
, VENDA_LIQUIDA
, case when VENDA_LIQUIDA <= 0
	then 'sem comissão'
	when VENDA_LIQUIDA between 1 and 500
	then '1%'
	when VENDA_LIQUIDA >= 501 and VENDA_LIQUIDA <= 10000 --between 501 and 10000
	then '2%'
	else '3%'
 end as comissao_aplicada 
from VENDAS_ANALITICAS
where VENDEDOR is not null

--Com a Comissao ja calculada 
select VENDEDOR
, VENDA_LIQUIDA
, case when VENDA_LIQUIDA <= 0
	then 'sem comissão'
	when VENDA_LIQUIDA between 1 and 500
	then '1%'
	when VENDA_LIQUIDA >= 501 and VENDA_LIQUIDA <= 10000 --between 501 and 10000
	then '2%'
	else '3%'
 end as comissao_aplicada 
  , case when VENDA_LIQUIDA <= 0
	then 0.00
	when VENDA_LIQUIDA between 1 and 500
	then VENDA_LIQUIDA * 1/100
	when VENDA_LIQUIDA >= 501 and VENDA_LIQUIDA <= 10000
	then VENDA_LIQUIDA * 2/100
	else VENDA_LIQUIDA * 3/100
 end as valor_comissao
from VENDAS_ANALITICAS
where VENDEDOR is not null

-- comisao por tempo 
select VENDEDOR
, sum(venda_liquida) as vendas_liquidas
, case when sum (VENDA_LIQUIDA) <= 0
	then 'sem comissão'
	when sum(VENDA_LIQUIDA) between 1 and 500
	then '1%'
	when sum (VENDA_LIQUIDA) >= 501 and sum(VENDA_LIQUIDA) <= 10000 
	then '2%'
	else '3%'
 end as comissao_aplicada 
from VENDAS_ANALITICAS
where VENDEDOR is not null
	 and MOVIMENTO between '01/01/2020' and '31/01/2020'
group by VENDEDOR


-- tempo e o valor acumulado 
select VENDEDOR
, sum(venda_liquida) as vendas_liquidas
, case when sum (VENDA_LIQUIDA) <= 0
	then 'sem comissão'
	when sum(VENDA_LIQUIDA) between 1 and 500
	then '1%'
	when sum (VENDA_LIQUIDA) >= 501 and sum(VENDA_LIQUIDA) <= 10000 
	then '2%'
	else '3%'
end as comissao_aplicada
, case when sum (VENDA_LIQUIDA) <= 0
	then 0.00
	when sum (VENDA_LIQUIDA) between 1 and 500
	then sum (VENDA_LIQUIDA) * 1/100
	when sum (VENDA_LIQUIDA) >= 501 and sum (VENDA_LIQUIDA) <= 10000
	then sum (VENDA_LIQUIDA) * 2/100
	else sum (VENDA_LIQUIDA) * 3/100
end as valor_comissao
from VENDAS_ANALITICAS
where VENDEDOR is not null
	 and MOVIMENTO between '01/01/2020' and '31/01/2020'
group by VENDEDOR

--IIF 
SELECT VENDEDOR
, QUANTIDADE
, case when QUANTIDADE > 0 then 'venda' else 'devolucao' end as tipo 
, iif (quantidade > 0, 'venda' , 'devolução') as tipo_02
FROM VENDAS_ANALITICAS
WHERE VENDEDOR IS NOT NULL

-- CAST 
-- CONVERT 
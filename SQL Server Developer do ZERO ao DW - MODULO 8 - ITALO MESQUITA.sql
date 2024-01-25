USE PBS_PROCFIT_DADOS
-- MODULO 8 --
-- Entendendo a diferen�a entre tempor�rias locais e tempor�rias globais
-- TABELAS TEMPORARIAS (#)- S�o vis�veis apenas para a sess�o de conex�o em que foram criadas, o que significa que outros usu�rios ou sess�es de conex�o n�o podem acess�-las. Al�m disso, elas s�o descartadas automaticamente quando a sess�o � encerrada.
-- TABELAS TEMPORARIAS GLOBAIS (##) - S�o vis�veis para todas as sess�es de conex�o no banco de dados, o que significa que outras sess�es de usu�rios podem acess�-las. Al�m disso, elas persistem mesmo ap�s a desconex�o do usu�rio que as criou e existem at� que sejam explicitamente descartadas ou at� que a conex�o com o banco de dados seja encerrada.

--> CRIANDO UMA TABELA TEMPORARIA 
CREATE TABLE #TBLTEMPORARIA
(
  COD_CLIENTE INT
, NOME_CLIENTE VARCHAR(80)
, TOTAL_VENDIDO MONEY
)
SELECT * FROM #TBLTEMPORARIA

--> CRIANDO UMA TABELA TEMPORARIA GLOBAL 
CREATE TABLE ##TBLTEMPORARIA
(
  COD_CLIENTE INT
, NOME_CLIENTE VARCHAR(80)
, TOTAL_VENDIDO MONEY
)
SELECT * FROM ##TBLTEMPORARIA

SELECT B.ENTIDADE		as entidade
, B.NOME				as nome_cliente
, SUM(A.VENDA_LIQUIDA)	as total_vendido
 INTO #TBLclientesVenda
FROM VENDAS_ANALITICAS A
JOIN ENTIDADES B ON A.CLIENTE = B.ENTIDADE
GROUP BY B.ENTIDADE, B.NOME

select*from #TBLclientesVenda

SELECT B.ENTIDADE		as entidade
, B.NOME				as nome_cliente
, SUM(A.VENDA_LIQUIDA)	as total_vendido
 INTO ##TBLclientesVendag
FROM VENDAS_ANALITICAS A
JOIN ENTIDADES B ON A.CLIENTE = B.ENTIDADE
GROUP BY B.ENTIDADE, B.NOME

select*from ##TBLclientesVendag


-- RECUPERAR O TOTAL A PAGAR E O VALOR PAGO POR ANO E MES DE CADA ENTIDADE 
-- RECUPERAR O TOTAL A RECEBER E O VALOR RECEBIDO POR ANO E MES DE CADA ENTIDADE
-- RECUPERAR TODAS AS VENDAS POR ANO E MES DE CADA ENTIDADE 

-- TOTAL A PAGAR PARA CLIENTE 
SELECT A.ENTIDADE			AS CLIENTE
,	   YEAR(A.MOVIMENTO)	AS ANO
,	   MONTH(A.MOVIMENTO)	AS MES
, CASE WHEN SUM(A.VALOR) < SUM(B.SALDO)
	   THEN SUM(B.SALDO)
	   ELSE SUM(A.VALOR)
  END AS TOTAL_PAGAR 
,	   SUM(B.SALDO)  AS SALDO_DEVEDOR
,CASE WHEN SUM(A.VALOR) < SUM(B.SALDO)
	   THEN SUM(B.SALDO)
	   ELSE SUM(A.VALOR) end - SUM(B.SALDO) AS TOTAL_PAGO
into #total_pagar_cliente
FROM TITULOS_PAGAR A
JOIN TITULOS_PAGAR_SALDO B ON A.TITULO_PAGAR = B.TITULO_PAGAR
GROUP BY A.ENTIDADE, YEAR(A.MOVIMENTO)  , MONTH(A.MOVIMENTO)


-- TOTAL A RECEBIDO DO CLIENTE 

SELECT A.ENTIDADE AS CLIENTE
,	   YEAR(A.MOVIMENTO) AS ANO
,	   MONTH(A.MOVIMENTO) AS MES
,	   SUM(A.VALOR) AS TOTAL_RECEBER
,	   SUM(B.SALDO)  AS SALDO_RECEBER
,	   SUM(A.VALOR) - SUM(B.SALDO) AS TOTAL_RECEBIDO
into #total_cliente_receber
FROM TITULOS_RECEBER A 
JOIN TITULOS_RECEBER_SALDO B ON A.TITULO_RECEBER = B.TITULO_RECEBER
GROUP BY A.ENTIDADE, YEAR(A.MOVIMENTO)  , MONTH(A.MOVIMENTO)


-- TOTAL VENDIDO POR CLIENTE 

SELECT A.CLIENTE		 AS CLIENTE
,	   YEAR(A.MOVIMENTO) AS ANO
,	   MONTH(A.MOVIMENTO) AS MES
,	   SUM(A.VENDA_LIQUIDA) AS TOTAL_VENDIDO
into #tbltotal_vendido_cliente
FROM VENDAS_ANALITICAS A
GROUP BY A.CLIENTE, YEAR(A.MOVIMENTO), MONTH(A.MOVIMENTO)

-- RESULTADO FINAL POR CLIENTE 
SELECT A.*
, B.TOTAL_RECEBER
, B.TOTAL_RECEBIDO
, ISNULL(C.TOTAL_PAGAR, 0) AS TOTAL_PAGAR
, ISNULL (C.SALDO_DEVEDOR, 0) AS SALDO_DEVEDOR 
FROM #tbltotal_vendido_cliente A
JOIN #total_cliente_receber B ON A.CLIENTE = B.CLIENTE 
							AND A.ANO = B.ANO 
							AND A.MES = B.MES
JOIN #total_pagar_cliente C ON A.CLIENTE = C.CLIENTE
							AND A.ANO = C.ANO
							AND A.MES = C.MES
WHERE A.ANO = 2020
AND A.MES = 8


SELECT A.CLIENTE
, D.NOME
, B.TOTAL_RECEBER
, B.TOTAL_RECEBIDO
, ISNULL(C.TOTAL_PAGAR, 0) AS TOTAL_PAGAR
, ISNULL (C.SALDO_DEVEDOR, 0) AS SALDO_DEVEDOR 
FROM #tbltotal_vendido_cliente A
JOIN #total_cliente_receber B ON A.CLIENTE = B.CLIENTE 
							AND A.ANO = B.ANO 
							AND A.MES = B.MES
JOIN #total_pagar_cliente C ON A.CLIENTE = C.CLIENTE
							AND A.ANO = C.ANO
							AND A.MES = C.MES
JOIN ENTIDADES D ON A.CLIENTE = D.ENTIDADE
WHERE A.ANO = 2020
AND A.MES = 8

-- DESAFIO -- 
/* RECUPERE O TOTAL DE VENDAS E O TOTAL NO ESTOQUE DE CADA PRODUTO
 -> VENDAS ESTA NA TABELA VENDAS ANALITICAS 
 -> ESTOQUE ESTA NA TABELA DE ESTOQUE_LACAMENTO
 -> DESCRI��O DO PRODUTO EST� NA TABELA DE PRODUTOS 
 -> CRIE UMA COLUNA VIRTUAL ONDE DIVIDA O ESTOQUE EM 3 CATEGORIAS 
   -- ABAIXO DE 50 UNIDADES 
   -- ENTRE 50 E 1000 UNIDADES
   -- ACIMA DE 1000 UNIDADES 
-> A CONSULTA DEVER� RETORNAR OS SEGUINTES CAMPOS 
	-- PRODUTO 
	-- DESCRI��O 
	-- UNIDADES VENDIDAS
	-- UNIDADES EM ESTOQUE 
	-- SITUA��O DO ESTOQUE (COLUNA VIRTUAL SOLICITADA)
-> REALIZE A CONSULTA UTILIZANDO SUBQUERY E DEPOIS REALIZE A MESMA CONSULTA UTILIZANDO TABELAS TEMPORARIAS.
*//*
select ESTOQUE
, sum(ESTOQUE_ENTRADA) as total_entradas
, sum(ESTOQUE_SAIDA) as total_saida
, sum(ESTOQUE_ENTRADA) - sum(ESTOQUE_SAIDA) as saldo_estoque 
from ESTOQUE_LANCAMENTOS
group by ESTOQUE
*/
-- TOTAL DO ESTOQUE 
select PRODUTO
, sum(ESTOQUE_ENTRADA) - sum(ESTOQUE_SAIDA) as saldo_estoque 
from ESTOQUE_LANCAMENTOS
group by PRODUTO

-- TOTAL VENDIDO 
select PRODUTO
, sum(QUANTIDADE) as QUANTIDADE_VENDIDA
from VENDAS_ANALITICAS
group by PRODUTO

-- SUBQUEREY
select A.PRODUTO AS COD_PRODUTO 
, A.DESCRICAO AS DESCRICAO_PRODUTO
, ISNULL(B.QUANTIDADE_VENDIDA, 0) AS UNIDADES_VENDIDAS
, C.SALDO_ESTOQUE
, ISNULL( C.SALDO_ESTOQUE, 0) AS UNIDADES_ESTOQUE 
, CASE WHEN ISNULL( C.SALDO_ESTOQUE, 0)  < 50
		THEN 'ABAIXO DE 50 UNIDADES'
		WHEN ISNULL( C.SALDO_ESTOQUE, 0) BETWEEN 50 AND 1000
		--WHEN C.SALDO_ESTOQUE >= 50 C.SALDO_ESTOQUE <=1000
		THEN 'ENTRE 50 E 1.000 UNIDADES'
		WHEN ISNULL( C.SALDO_ESTOQUE, 0) > 1000
		THEN 'ACIMA DE 1.000 UNIDADES'
	END AS SITUACAO_ESTOQUE 
from PRODUTOS A
LEFT JOIN ( select PRODUTO
			, sum(QUANTIDADE) as quantidade_vendida
			from VENDAS_ANALITICAS
			group by PRODUTO
		)B ON A.PRODUTO = B.PRODUTO
LEFT JOIN (select PRODUTO
            , sum(ESTOQUE_ENTRADA) - sum(ESTOQUE_SAIDA) as saldo_estoque 
			from ESTOQUE_LANCAMENTOS
            group by PRODUTO
		)C ON A.PRODUTO = C.PRODUTO

-- OUTRA POSSIBILIDADE 
select A.PRODUTO AS COD_PRODUTO 
, A.DESCRICAO AS DESCRICAO_PRODUTO
, ISNULL(B.QUANTIDADE_VENDIDA, 0) AS UNIDADES_VENDIDAS
, C.SALDO_ESTOQUE
, CASE WHEN C.SALDO_ESTOQUE < 50
		THEN 'ABAIXO DE 50 UNIDADES'
		WHEN C.SALDO_ESTOQUE BETWEEN 50 AND 1000
		--WHEN C.SALDO_ESTOQUE >= 50 C.SALDO_ESTOQUE <=1000
		THEN 'ENTRE 50 E 1.000 UNIDADES'
		WHEN C.SALDO_ESTOQUE > 1000
		THEN 'ACIMA DE 1.000 UNIDADES'
		--WHEN C.SALDO_ESTOQUE IS NULL
		--THEN 'SEM ENTRADA NA EMPRESA'
		ELSE 'SEM ENTRADA NA EMPRESSA'
	END AS SITUACAO_ESTOQUE 
from PRODUTOS A
LEFT JOIN ( select PRODUTO
			, sum(QUANTIDADE) as quantidade_vendida
			from VENDAS_ANALITICAS
			group by PRODUTO
		)B ON A.PRODUTO = B.PRODUTO
LEFT JOIN (select PRODUTO
            , sum(ESTOQUE_ENTRADA) - sum(ESTOQUE_SAIDA) as saldo_estoque 
			from ESTOQUE_LANCAMENTOS
            group by PRODUTO
		)C ON A.PRODUTO = C.PRODUTO
------------------------------------------------------------------------------
-- TABELAS TEMPORARIAS
-- TOTAL DO ESTOQUE 
select PRODUTO
, sum(ESTOQUE_ENTRADA) - sum(ESTOQUE_SAIDA) as SALDO_ESTOQUE
into #PRODUTOS_ESTOQUE
from ESTOQUE_LANCAMENTOS
group by PRODUTO

-- TOTAL VENDIDO 
select PRODUTO
, sum(QUANTIDADE) as QUANTIDADE_VENDIDA
INTO #PRODUTOS_VENDIDOS
from VENDAS_ANALITICAS
group by PRODUTO

-- TABELAS TEMPOTARIAS 
SELECT A.PRODUTO AS COD_PRODUTO
, A.DESCRICAO AS DESCRICAO_PRODUTO
, B.QUANTIDADE_VENDIDA AS UNIDADES_VENDIDAS
, C.SALDO_ESTOQUE AS UNIDADES_ESTOQUE 
FROM PRODUTOS A
LEFT JOIN #PRODUTOS_VENDIDOS B ON A.PRODUTO = B. PRODUTO
LEFT JOIN #PRODUTOS_ESTOQUE C ON A.PRODUTO = C.PRODUTO


SELECT A.PRODUTO AS COD_PRODUTO
, A.DESCRICAO AS DESCRICAO_PRODUTO
, B.QUANTIDADE_VENDIDA AS UNIDADES_VENDIDAS
, C.SALDO_ESTOQUE AS UNIDADES_ESTOQUE
, CASE WHEN C.SALDO_ESTOQUE < 50
		THEN 'ABAIXO DE 50 UNIDADES'
		WHEN C.SALDO_ESTOQUE BETWEEN 50 AND 1000
		THEN 'ENTRE 50 E 1.000 UNIDADES'
		WHEN C.SALDO_ESTOQUE > 1000
		THEN 'ACIMA DE 1.000 UNIDADES'
				ELSE 'SEM ENTRADA NA EMPRESSA'
	END AS SITUACAO_ESTOQUE 
FROM PRODUTOS A
LEFT JOIN #PRODUTOS_VENDIDOS B ON A.PRODUTO = B.PRODUTO
LEFT JOIN #PRODUTOS_ESTOQUE C ON A.PRODUTO = C.PRODUTO

DROP TABLE #PRODUTOS_ESTOQUE
DROP TABLE #PRODUTOS_VENDIDOS

-- APAGANDO TABELAS DE FORMA INTELIGENTE --> IF OBJECT_ID('TEMPDB..#') IS NOT NULL DROP TABLE #
IF OBJECT_ID('TEMPDB..#TEMP_01') IS NOT NULL DROP TABLE #TEMP_01

CREATE TABLE #TEMP_01(ID INT, NOME VARCHAR(80))

INSERT INTO #TEMP_01(ID , NOME)

SELECT ENTIDADE, NOME_FANTASIA FROM ENTIDADES

SELECT * FROM #TEMP_01
----------------------------------------------------
IF OBJECT_ID('TEMPDB..#TEMP_02') IS NOT NULL DROP TABLE #TEMP_02

SELECT ENTIDADE, NOME_FANTASIA 
INTO #TEMP_02
FROM ENTIDADES
SELECT*FROM #TEMP_02

--Criando uma CTE (FAZER EM UMA CONSULTA SEPARADA)
/*
WITH CTE_PRODUTOS_ESTOQUE AS ( select PRODUTO
, sum(ESTOQUE_ENTRADA) - sum(ESTOQUE_SAIDA) as SALDO_ESTOQUE
from ESTOQUE_LANCAMENTOS
group by PRODUTO
) , CTE_PRODUTOS_VENDIDOS AS (select PRODUTO
, sum(QUANTIDADE) as QUANTIDADE_VENDIDA
from VENDAS_ANALITICAS
group by PRODUTO)

SELECT A.PRODUTO AS COD_PRODUTO
,	   A.DESCRICAO AS DESCRICAO_PRODUTO
,	   B.QUANTIDADE_VENDIDA AS UNIDADES_VENDIDAS
,	   C.SALDO_ESTOQUE AS UNIDADES_ESTOQUE
	, CASE WHEN C.SALDO_ESTOQUE < 50
		THEN 'ABAIXO DE 50 UNIDADES'
		WHEN C.SALDO_ESTOQUE BETWEEN 50 AND 1000
		THEN 'ENTRE 50 E 1.000 UNIDADES'
		WHEN C.SALDO_ESTOQUE > 1000
		THEN 'ACIMA DE 1.000 UNIDADES'
		ELSE 'SEM ENTRADA NA EMPRESSA'
	END AS SITUACAO_ESTOQUE 
FROM PRODUTOS A
LEFT JOIN CTE_PRODUTOS_VENDIDOS B ON A.PRODUTO = B.PRODUTO
LEFT JOIN CTE_PRODUTOS_ESTOQUE C ON A.PRODUTO = C.PRODUTO

-------------------------------------------------------------------
WITH CTE_PRODUTOS_ESTOQUE (CODPRODUTO,SALDOESTOQUE)AS 
( select PRODUTO
, sum(ESTOQUE_ENTRADA) - sum(ESTOQUE_SAIDA) as SALDO_ESTOQUE
from ESTOQUE_LANCAMENTOS
group by PRODUTO
) , CTE_PRODUTOS_VENDA (CODPRODUTO, QTVENDIDA) AS (select PRODUTO
, sum(QUANTIDADE) as QUANTIDADE_VENDIDA
from VENDAS_ANALITICAS
group by PRODUTO)

SELECT*FROM CTE_PRODUTOS_ESTOQUE
*/

-- Principais diferen�as entre CTE's e tempor�rias:
/*As CTEs (Common Table Expressions) e as tabelas tempor�rias s�o duas formas diferentes de armazenar dados temporariamente em consultas SQL. Aqui est�o algumas das principais diferen�as entre elas:

Escopo de Utiliza��o:

CTEs: O escopo de uma CTE � apenas a consulta em que ela � definida. A CTE � usada apenas na consulta imediatamente ap�s sua defini��o.
Tabelas Tempor�rias: Elas t�m um escopo mais amplo e podem ser utilizadas em v�rias consultas na mesma sess�o do banco de dados.
Tempo de Vida dos Dados:

CTEs: Existem apenas durante a execu��o da consulta � qual est�o associadas. Ap�s o t�rmino da consulta, a CTE deixa de existir.
Tabelas Tempor�rias: Existem at� o final da sess�o do banco de dados ou at� serem explicitamente removidas. Elas podem ser utilizadas por v�rias consultas dentro da mesma sess�o.
Sintaxe:

CTEs: S�o definidas usando a cl�usula WITH no in�cio de uma consulta. Podem ser referenciadas dentro da pr�pria consulta usando o nome atribu�do a elas.
Tabelas Tempor�rias: S�o criadas explicitamente usando a instru��o CREATE TABLE #NomeDaTabela. Elas t�m um nome e podem ser referenciadas em v�rias consultas at� serem eliminadas.
Recursividade:

CTEs: Podem ser recursivas, o que permite referenciar a CTE dentro de sua pr�pria defini��o, �til para opera��es hier�rquicas.
Tabelas Tempor�rias: N�o possuem suporte direto para opera��es recursivas.
�ndices e Estat�sticas:

CTEs: N�o podem ter �ndices ou estat�sticas diretamente associados a elas.
Tabelas Tempor�rias: Podem ter �ndices e estat�sticas, o que pode melhorar o desempenho em consultas complexas.
Simplicidade e Legibilidade:

CTEs: S�o mais adequadas para consultas simples e leg�veis, especialmente quando se trata de consultas recursivas ou opera��es mais l�gicas.
Tabelas Tempor�rias: S�o mais adequadas quando voc� precisa armazenar uma grande quantidade de dados tempor�rios ou quando precisa realizar v�rias opera��es complexas em v�rias etapas.
A escolha entre CTEs e tabelas tempor�rias depender� da complexidade da sua consulta, do escopo desejado e da necessidade de armazenar dados tempor�rios em diferentes consultas. Ambas t�m seus usos espec�ficos e podem ser ferramentas poderosas em diferentes contextos.
*/



















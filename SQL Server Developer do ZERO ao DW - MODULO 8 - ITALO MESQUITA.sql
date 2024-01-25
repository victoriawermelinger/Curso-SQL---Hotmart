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
LEFT JOIN #PRODUTOS_VENDIDOS B ON A.PRODUTO = B. PRODUTO
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
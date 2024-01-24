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

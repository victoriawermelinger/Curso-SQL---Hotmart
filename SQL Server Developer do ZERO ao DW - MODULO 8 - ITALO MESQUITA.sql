USE PBS_PROCFIT_DADOS
-- MODULO 8 --
-- Entendendo a diferença entre temporárias locais e temporárias globais
-- TABELAS TEMPORARIAS (#)- São visíveis apenas para a sessão de conexão em que foram criadas, o que significa que outros usuários ou sessões de conexão não podem acessá-las. Além disso, elas são descartadas automaticamente quando a sessão é encerrada.
-- TABELAS TEMPORARIAS GLOBAIS (##) - São visíveis para todas as sessões de conexão no banco de dados, o que significa que outras sessões de usuários podem acessá-las. Além disso, elas persistem mesmo após a desconexão do usuário que as criou e existem até que sejam explicitamente descartadas ou até que a conexão com o banco de dados seja encerrada.

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

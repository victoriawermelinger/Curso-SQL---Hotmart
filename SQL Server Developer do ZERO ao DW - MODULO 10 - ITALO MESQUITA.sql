use PBS_PROCFIT_DADOS
---MODULO 10---
-- INSERT POSICIONAL 

SELECT * FROM VENDEDORES

/* Faz uma pesquisa dentro da tabela usando alt + f1, onde voc� irar indentificar as colunas. 
que nao aceita valores nulos, ap�s isso fa�a um selec dentro da sua tabela.
para saber quais tem valores e voce poderar usar 

VENDEDOR - OBRIGATORIO
NOME - OBRIGATORIO
ENTIDADE - OBRIGATORIO
EMPRESA_USUARIA
DESCONTO_MAXIMO_PMC
CASATROS_ATIVO
*/

SELECT VENDEDOR ,NOME ,ENTIDADE ,EMPRESA_USUARIA ,DESCONTO_MAXIMO_PMC FROM VENDEDORES
----------------------------------------------------------------------------------------
INSERT INTO VENDEDORES ( VENDEDOR 
,NOME 
,ENTIDADE 
,EMPRESA_USUARIA 
,DESCONTO_MAXIMO_PMC
) VALUES (
'ITALO MESQUITA', 1, 1, 0.00
)
-- ESSE INSERT N�O E HABITUAL USAR, POR QUE SE PRECISAR COLOCARA MAIS DADOS TEM QUE FAZER TODO CODICO NOVAMENTE.
-------------------------------------------------------------------------------------------

--INSERT com Instru��o SELECT

INSERT INTO VENDEDORES 
(NOME, ENTIDADE, EMPRESA_USUARIA, DESCONTO_MAXIMO_PMC)

SELECT NOME
, ENTIDADE
, 1 AS EMPRESA_USUARIA 
, CASE WHEN YEAR (DATA_CADASTRO) <= 2014
	THEN 10.00
	WHEN YEAR (DATA_CADASTRO) = 2015
	THEN 5.00
	ELSE 0.00
 END AS DESCONTO_MAXIMO_PMC
 FROM ENTIDADES
WHERE ENTIDADE BETWEEN 1004 AND 1050

-- 2014 PARA TR�S 10% 
-- 2015 5% DE DESCONTO 
-- DEPOIS DE 2015 0.00

--BEGIN TRANSACTION (BEGIN TRAN) representa um ponto no qual os dados referenciados por uma conex�o s�o l�gica e fisicamente consistentes. Se forem encontrados erros, todas as modifica��es de dados feitas depois do BEGIN TRANSACTION poder�o ser revertidas para voltar os dados ao estado conhecido de consist�ncia
--SELECT * FROM VENDEDORES WITH(NOLOCK)  Se o seu SGBD permitir, utilize NOLOCK quando deseja visualizar dados n�o confirmados e n�o quando deseja trabalhar somente com os dados que est�o confirmados de fato
--ROLLBACK remove todas as altera��es feitas desde a �ltima opera��o de confirma��o ou rollback. O sistema tamb�m libera todos os bloqueios relacionados � transa��o. 
--COMMIT s�o as unidades estruturais de um cronograma de projeto Git.

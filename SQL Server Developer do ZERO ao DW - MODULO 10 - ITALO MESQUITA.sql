use PBS_PROCFIT_DADOS
---MODULO 10---
-- INSERT POSICIONAL 

SELECT * FROM VENDEDORES

/* Faz uma pesquisa dentro da tabela usando alt + f1, onde você irar indentificar as colunas. 
que nao aceita valores nulos, após isso faça um selec dentro da sua tabela.
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
-- ESSE INSERT NÃO E HABITUAL USAR, POR QUE SE PRECISAR COLOCARA MAIS DADOS TEM QUE FAZER TODO CODICO NOVAMENTE.
-------------------------------------------------------------------------------------------

--INSERT com Instrução SELECT

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

-- 2014 PARA TRAS 10% 
-- 2015 5% DE DESCONTO 
-- DEPOIS DE 2015 0.00

--BEGIN TRANSACTION (BEGIN TRAN) representa um ponto no qual os dados referenciados por uma conexao sao logica e fisicamente consistentes. Se forem encontrados erros, todas as modificaçoes de dados feitas depois do BEGIN TRANSACTION poderao ser revertidas para voltar os dados ao estado conhecido de consistencia
--SELECT * FROM VENDEDORES WITH(NOLOCK)  Se o seu SGBD permitir, utilize NOLOCK quando deseja visualizar dados nao confirmados e nao quando deseja trabalhar somente com os dados que estao confirmados de fato
--ROLLBACK remove todas as alteraçoes feitas desde a ultima operaçao de confirmaçao ou rollback. O sistema tambem libera todos os bloqueios relacionados a transaçao. 
--COMMIT sao as unidades estruturais de um cronograma de projeto Git.

-- UPDATE 

SELECT DESCONTO_MAXIMO_PMC, * 
FROM VENDEDORES 
WHERE VENDEDOR IN (1,2)

BEGIN TRAN
UPDATE VENDEDORES
SET DESCONTO_MAXIMO_PMC = 100
WHERE VENDEDOR IN (1,2)

BEGIN TRAN 
UPDATE VENDEDORES
SET DESCONTO_MAXIMO_PMC = 0
FROM VENDEDORES 
WHERE VENDEDOR IN (1,2)

-- COMMIT 
-- ROLLBACK

--UPDATE - Atualizando registros com instrução SELECT

SELECT A.CEP
, B.CEP
, A.ENDERECO AS ENDERECO_ANTIGO 
, B. ENDERECO AS ENDERECO_NOVO
, A. CIDADE AS CIDADE_ANTIGA 
, A. CIDADE AS CIDADE_NOVA
FROM ENDERECOS A
JOIN CEP B ON A.CEP = B.CEP
WHERE B.ENDERECO<> ''
AND B.ENDERECO <> A.ENDERECO

BEGIN TRAN
UPDATE ENDERECOS
SET ENDERECO = B. ENDERECO 
, CIDADE = B.CIDADE
FROM ENDERECOS A
JOIN CEP B ON A.CEP = B.CEP
WHERE B.ENDERECO<> ''

-- COMMIT (REVERTE A OPERAÇÃO)
-- ROLLBACK (CONFIRMA A OPERAÇÃO)

----------------------------------------------------------------------------
--DELETE - Apagando registros

SELECT * FROM VENDEDORES
WHERE VENDEDOR = 23
AND DESCONTO_MAXIMO_PMC = 0

BEGIN TRAN
DELETE VENDEDORES 
 WHERE VENDEDOR = 23
  AND DESCONTO_MAXIMO_PMC = 0

--COMMIT 
--DELETE - Apagando registros com instruções SELECT

select * from PRODUTOS
select * from MARCAS

select a.MARCA
, b.PRODUTO
from MARCAS a 
left join produtos b on a.MARCA = b.MARCA
where b.PRODUTO is null 

begin tran 
delete 
from MARCAS
from MARCAS a  left join produtos b on a.MARCA = b.MARCA
where b.PRODUTO is null 

begin tran 
delete MARCAS
from MARCAS a  left join produtos b on a.MARCA = b.MARCA
where b.PRODUTO is null 
 
begin tran
delete from MARCAS 
where MARCA in (select a.MARCA
, b.PRODUTO
from MARCAS a 
left join produtos b on a.MARCA = b.MARCA
where b.PRODUTO is null)

begin tran
delete  MARCAS 
where MARCA in (select a.MARCA
, b.PRODUTO
from MARCAS a 
left join produtos b on a.MARCA = b.MARCA
where b.PRODUTO is null)

begin tran
delete  MARCAS 
where MARCA not in (select a.MARCA
, b.PRODUTO
from MARCAS a 
left join produtos b on a.MARCA = b.MARCA
where b.PRODUTO is null)

--rollback 
-----------------------------------------------------------------
-- O comando MERGE
/*  - SICRONIZAR TODAS AS ENTIDADES PF COM A TABELA DE PESSOAS FÍSICAS
	- SICRONIZAR TODAS AS ENTIDADES PJ COM A TABELA DE PESSOAS JURITICAS 

-- INSERT --> INSERIR UM NO REGISTRO
-- UPDATE --> ATUALIZAR UM REGISTO
-- DELETE --> APAGA UM REGISTO 
*/

MERGE TABELA_DESTINO D
USING FONTE_DADOS	 O ON D.CAMPO_PRODUTO = O.CAMPO_PRODUTO 

WHEN MATCHED THEN
				UPDATE SET CAMPO_A = CAMPO_B

WHEN NOT MATCHED BY TARGET THEN 
			INSERT (CAMPO_A) 
			VALUES (CAMPO_B)

WHEN NOT MATCHED BY SOURCE DELETE; 
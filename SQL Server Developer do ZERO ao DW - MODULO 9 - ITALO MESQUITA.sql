-- O QUE S�O VARIAVEIS
/*as vari�veis s�o objetos que podem armazenar valores tempor�rios. Elas s�o frequentemente utilizadas para simplificar consultas, armazenar resultados intermedi�rios ou par�metros, e s�o bastante �teis em procedimentos armazenados, fun��es ou blocos an�nimos de c�digo.

Aqui est� uma breve explica��o sobre vari�veis em SQL:

Declara��o de Vari�veis:

As vari�veis s�o declaradas usando a palavra-chave DECLARE. Por exemplo:
sql
Copy code
DECLARE @nomeVariavel TIPO_DE_DADO;
Atribui��o de Valores:

Os valores podem ser atribu�dos �s vari�veis usando a palavra-chave SET ou diretamente na declara��o. Por exemplo:
sql
Copy code
DECLARE @idade INT;
SET @idade = 25;
Tipos de Dados:

As vari�veis podem ter v�rios tipos de dados, como INT, VARCHAR, DATETIME, etc. O tipo de dado deve ser especificado ao declarar a vari�vel.
sql
Copy code
DECLARE @nome VARCHAR(50);
SET @nome = 'John';
Uso em Consultas:

Vari�veis podem ser utilizadas em consultas para armazenar resultados ou par�metros. Por exemplo:
sql
Copy code
DECLARE @totalVendas DECIMAL(10,2);
SET @totalVendas = (SELECT SUM(Valor) FROM Vendas WHERE Ano = 2023);
Escopo:

O escopo de uma vari�vel � o bloco, procedimento armazenado ou fun��o no qual ela foi declarada. Vari�veis locais t�m escopo limitado ao bloco em que s�o definidas.
Exemplo em um Procedimento Armazenado:

Aqui est� um exemplo b�sico de um procedimento armazenado usando vari�veis:
sql
Copy code
CREATE PROCEDURE ExemploProcedimento
AS
BEGIN
    DECLARE @nomeCliente VARCHAR(50);
    SET @nomeCliente = 'Jo�o';
    
    SELECT * FROM Clientes WHERE Nome = @nomeCliente;
END;
As vari�veis no SQL ajudam a tornar os scripts mais din�micos e flex�veis, permitindo o armazenamento tempor�rio de valores que podem ser usados em v�rias partes de um bloco de c�digo ou procedimento.
*/
-- ULTILIZANDO VARIAVEIS NO SQL 

DECLARE @MOVIMENTO DATE 

SET @MOVIMENTO = '01/01/2021'

SELECT @MOVIMENTO

SET @MOVIMENTO = CAST(GETDATE()AS DATE)

SELECT @MOVIMENTO
------------------------------------------------
DECLARE @MOVIMENTO_INI   DATE 
, @MOVIMENTO_FIM		 DATE 
, @PERCENTUAL_ACRECIMO   NUMERIC 

SET @MOVIMENTO_INI = '01/01/2019'
SET @MOVIMENTO_FIM = '31/12/2020'
SET @PERCENTUAL_ACRECIMO = 15.00

SELECT @MOVIMENTO_INI AS MOVIMENTO_INI
, @MOVIMENTO_FIM AS MOVIMENTO_FIM
, TITULO_RECEBER
, TITULO
, ENTIDADE
, VALOR
, @PERCENTUAL_ACRECIMO AS PERCENTUAL_JUROS
, VALOR * (1 + ( @PERCENTUAL_ACRECIMO/100)) AS VALOR_COM_JUROS 
FROM TITULOS_RECEBER A 
WHERE A.MOVIMENTO >= @MOVIMENTO_INI
 AND A.MOVIMENTO <= @MOVIMENTO_FIM

 -- OUTRA FORMA 

DECLARE @MOVIMENTO_INI   DATE = '01/01/2019'
, @MOVIMENTO_FIM		 DATE = '31/12/2020'
, @PERCENTUAL_ACRECIMO   NUMERIC (15,2) = 15.00

SELECT @MOVIMENTO_INI AS MOVIMENTO_INI
, @MOVIMENTO_FIM AS MOVIMENTO_FIM
, TITULO_RECEBER
, TITULO
, ENTIDADE
, VALOR
, @PERCENTUAL_ACRECIMO AS PERCENTUAL_JUROS
, VALOR * (1 + ( @PERCENTUAL_ACRECIMO/100)) AS VALOR_COM_JUROS 
FROM TITULOS_RECEBER A 
WHERE A.MOVIMENTO >= @MOVIMENTO_INI
 AND A.MOVIMENTO <= @MOVIMENTO_FIM

--Atribuindo valores din�micos a vari�veis
--1 FORMA 
DECLARE @DATA_ATUAL DATE
SET @DATA_ATUAL = '02/11/2021'
SELECT @DATA_ATUAL

--2 FORMA 
DECLARE @DATA_ATUAL_01 DATE = GETDATE()
SELECT @DATA_ATUAL_01

-- 3 FORMA (BASEADA EM RESULTADOS DE UM COMANDO SELECT)

DECLARE @UF_MENOR_VENDA CHAR(2)

SET @UF_MENOR_VENDA = (
	SELECT TOP 1 B.ESTADO
	--, SUM(A.VENDA_LIQUIDA) AS VENDAS_LIQUIDAS
	FROM VENDAS_ANALITICAS A
	JOIN ENDERECOS B ON A.CLIENTE = B.ENTIDADE
	GROUP BY B.ESTADO
	ORDER BY SUM (A.VENDA_LIQUIDA)ASC )

SELECT A.ENTIDADE
, A.NOME
FROM ENTIDADES A
JOIN ENDERECOS B ON A.ENTIDADE = B.ENTIDADE
WHERE B.ESTADO = @UF_MENOR_VENDA
---------------------------------------------------
-- 4 FORMA (BASEADA NO RESULTADO DE UM COMANDO SELECT)
DECLARE @UF_MAIOR_VENDA CHAR(2)
DECLARE @VALOR_TOTAL_VENDA NUMERIC(15,2)

SELECT TOP 1 @UF_MAIOR_VENDA = B.ESTADO
, @VALOR_TOTAL_VENDA = SUM(A.VENDA_LIQUIDA)
FROM VENDAS_ANALITICAS A
JOIN ENDERECOS B ON A.CLIENTE = B.ENTIDADE
GROUP BY B.ESTADO
ORDER BY SUM(A.VENDA_LIQUIDA) DESC

SELECT A.ENTIDADE
, A.NOME
FROM ENTIDADES A
JOIN ENDERECOS B ON A.ENTIDADE = B.ENTIDADE
WHERE B.ESTADO = @UF_MAIOR_VENDA
---------------------------------------------------

-- CRIANDO E UTILIZANDO VARIAVEIS DO TIPO TABLE 
DECLARE @ENTIDADE_PADR�O NUMERIC(15) = 1993
DECLARE @CLIENTES_ATIVOS TABLE(
COD_CLIENTE NUMERIC(15)
, NOME_CLIENTE VARCHAR(20)
, TOTAL_VENDIDO MONEY
)
INSERT INTO @CLIENTES_ATIVOS (
COD_CLIENTE, NOME_CLIENTE, TOTAL_VENDIDO)

SELECT A.ENTIDADE, A.NOME, SUM(B.VENDA_LIQUIDA) AS TOTAL_VENDIDO
FROM ENTIDADES A
JOIN VENDAS_ANALITICAS B ON A.ENTIDADE = B.CLIENTE
WHERE ATIVO = 'S'
GROUP BY A.ENTIDADE, A.NOME

SELECT A.*, B.CIDADE, B.ESTADO
FROM @CLIENTES_ATIVOS A 
JOIN ENDERECOS B ON A.COD_CLIENTE = B.ENTIDADE

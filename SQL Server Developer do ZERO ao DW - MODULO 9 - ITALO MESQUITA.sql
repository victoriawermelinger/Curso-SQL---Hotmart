-- O QUE SÃO VARIAVEIS
/*as variáveis são objetos que podem armazenar valores temporários. Elas são frequentemente utilizadas para simplificar consultas, armazenar resultados intermediários ou parâmetros, e são bastante úteis em procedimentos armazenados, funções ou blocos anônimos de código.

Aqui está uma breve explicação sobre variáveis em SQL:

Declaração de Variáveis:

As variáveis são declaradas usando a palavra-chave DECLARE. Por exemplo:
sql
Copy code
DECLARE @nomeVariavel TIPO_DE_DADO;
Atribuição de Valores:

Os valores podem ser atribuídos às variáveis usando a palavra-chave SET ou diretamente na declaração. Por exemplo:
sql
Copy code
DECLARE @idade INT;
SET @idade = 25;
Tipos de Dados:

As variáveis podem ter vários tipos de dados, como INT, VARCHAR, DATETIME, etc. O tipo de dado deve ser especificado ao declarar a variável.
sql
Copy code
DECLARE @nome VARCHAR(50);
SET @nome = 'John';
Uso em Consultas:

Variáveis podem ser utilizadas em consultas para armazenar resultados ou parâmetros. Por exemplo:
sql
Copy code
DECLARE @totalVendas DECIMAL(10,2);
SET @totalVendas = (SELECT SUM(Valor) FROM Vendas WHERE Ano = 2023);
Escopo:

O escopo de uma variável é o bloco, procedimento armazenado ou função no qual ela foi declarada. Variáveis locais têm escopo limitado ao bloco em que são definidas.
Exemplo em um Procedimento Armazenado:

Aqui está um exemplo básico de um procedimento armazenado usando variáveis:
sql
Copy code
CREATE PROCEDURE ExemploProcedimento
AS
BEGIN
    DECLARE @nomeCliente VARCHAR(50);
    SET @nomeCliente = 'João';
    
    SELECT * FROM Clientes WHERE Nome = @nomeCliente;
END;
As variáveis no SQL ajudam a tornar os scripts mais dinâmicos e flexíveis, permitindo o armazenamento temporário de valores que podem ser usados em várias partes de um bloco de código ou procedimento.
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

--Atribuindo valores dinâmicos a variáveis
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
DECLARE @ENTIDADE_PADRÃO NUMERIC(15) = 1993
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

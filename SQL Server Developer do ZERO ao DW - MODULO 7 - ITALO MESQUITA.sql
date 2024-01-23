use PBS_PROCFIT_DADOS
-- MODULO 07 -- 
-- Utilizando Subqueries
SELECT A.ENTIDADE
, B.NOME
, SUM(A.VALOR_RECEBER) AS VALOR_RECEBER
, SUM(A.VALOR_PAGAR) AS VALOR_PAGAR 
, SUM(A.VALOR_RECEBER) - SUM(A.VALOR_PAGAR) AS SALDO
FROM(	SELECT ENTIDADE, SUM(VALOR) AS VALOR_RECEBER, 0.00 AS VALOR_PAGAR
		FROM TITULOS_RECEBER
		GROUP BY ENTIDADE

		UNION ALL

		SELECT ENTIDADE, 0.00 AS VALOR_RECEBER, SUM(VALOR) AS VALOR_PAGAR
		FROM TITULOS_PAGAR
		GROUP BY ENTIDADE
) A
JOIN ENTIDADES B ON A.ENTIDADE = B.ENTIDADE

GROUP BY A.ENTIDADE, B.NOME
ORDER BY ENTIDADE

-- Utilizando multiplas subqueries no mesmo comando SELECT

SELECT A.ENTIDADE
, A.NOME
, ISNULL (B.VALOR_RECEBER,0) AS VALOR_RECEBER
, ISNULL (C.VALOR_PAGAR,0) AS VALOR_RECEBER
, ISNULL (B.VALOR_RECEBER,0) - ISNULL (C.VALOR_PAGAR,0) AS SALDO 
FROM ENTIDADES A
LEFT JOIN (SELECT ENTIDADE, SUM(VALOR) AS VALOR_RECEBER, 0.00 AS VALOR_PAGAR
			FROM TITULOS_RECEBER
			GROUP BY ENTIDADE) B ON A.ENTIDADE = B.ENTIDADE
LEFT JOIN (SELECT ENTIDADE, 0.00 AS VALOR_RECEBER, SUM(VALOR) AS VALOR_PAGAR
		    FROM TITULOS_PAGAR
			GROUP BY ENTIDADE) C ON A.ENTIDADE = C.ENTIDADE
WHERE B.VALOR_RECEBER IS NOT NULL
  OR C.VALOR_PAGAR IS NOT NULL

ORDER BY ENTIDADE

-- Utilizando subqueries com os operadores IN e NOT IN
--IN
SELECT A.ENTIDADE
, A.NOME
, B.ESTADO
FROM ENTIDADES A
JOIN ENDERECOS B ON A.ENTIDADE = B.ENTIDADE
WHERE A.ENTIDADE IN(SELECT CLIENTE
					FROM VENDAS_ANALITICAS
					WHERE YEAR(MOVIMENTO) = 2019
					)

-- NOT IN 
SELECT A.ENTIDADE
, A.NOME
, B.ESTADO
FROM ENTIDADES A
JOIN ENDERECOS B ON A.ENTIDADE = B.ENTIDADE
WHERE A.ENTIDADE NOT IN(SELECT CLIENTE
						FROM VENDAS_ANALITICAS
						WHERE YEAR(MOVIMENTO) = 2019
						)

--Utilizando subqueries com os operadores de comparação

SELECT A.ENTIDADE
, A.NOME
, B.ESTADO
FROM ENTIDADES A
JOIN ENDERECOS B ON A.ENTIDADE = B.ENTIDADE
WHERE A.ENTIDADE = (SELECT TOP 1 CLIENTE
					FROM VENDAS_ANALITICAS
					GROUP BY CLIENTE
					ORDER BY SUM(VENDA_LIQUIDA) DESC
					)



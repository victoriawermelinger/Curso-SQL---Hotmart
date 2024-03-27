DECLARE @D_INI DATE = '2018-01-01';
DECLARE @D_FIM DATE = '2022-12-31';
DECLARE @ANO_FECHADO BIT = 1;
DECLARE @INICIO_ANO_FISCAL INT = 7;

DECLARE @HOJE DATE = CAST(GETDATE() AS DATE);

DECLARE @ANO_INI INT = YEAR(@D_INI);
DECLARE @ANO_FIM INT = YEAR(@D_FIM);

DECLARE @DATA_INI DATE;
DECLARE @DATA_FIM DATE;

SET @DATA_INI = CAST(CONCAT(@ANO_INI, '-01-01') AS DATE);
SET @DATA_FIM = CASE @ANO_FECHADO WHEN 1 THEN CAST(CONCAT(@ANO_FIM, '-12-31') AS DATE) ELSE @D_FIM END;

;WITH DATAS AS (
    SELECT DATEADD(DAY, a.SEQUENCIA - 1, @D_INI) AS [DATA]
    FROM VEZES a WITH (NOLOCK)
    WHERE a.SEQUENCIA <= DATEDIFF(DAY, @DATA_INI, @DATA_FIM) + 1
)
SELECT 
    A.[DATA] AS [date],
    DATEPART(YY, A.[DATA]) AS [year],
    DATEFROMPARTS(YEAR(A.[DATA]), 1, 1) AS [start_of_year],
    DATEFROMPARTS(YEAR(A.[DATA]), 12, 31) AS [end_of_year],
    DATEPART(MM, A.[DATA]) AS [month],
    DATEFROMPARTS(YEAR(A.[DATA]), MONTH(A.[DATA]), 1) AS [start_of_month],
    EOMONTH(A.[DATA]) AS [end_of_month],
    DATEPART(DD, EOMONTH(A.[DATA])) AS [day_in_month],
    CONCAT(YEAR(A.[DATA]), CONCAT(REPLICATE('0', 2 - LEN(MONTH(A.[DATA]))), MONTH(A.[DATA]))) AS [year_month_number],
    CONCAT(DATEPART(YY, A.[DATA]), '-', LOWER(LEFT(DATENAME(MM, A.[DATA]), 3))) AS [year_month_name],
    DATEPART(DD, A.[DATA]) AS [day],
    LOWER(DATENAME(DW, A.[DATA])) AS [day_name],
    LOWER(LEFT(DATENAME(DW, A.[DATA]), 3)) AS [day_name_short],
    DATEPART(WEEKDAY, A.[DATA]) AS [day_of_week],
    DATEPART(DY, A.[DATA]) AS [day_of_year],
    LOWER(DATENAME(MM, A.[DATA])) AS [month_name],
    LOWER(LEFT(DATENAME(MM, A.[DATA]), 3)) AS [month_name_short],
    DATEPART(QQ, A.[DATA]) AS [quarter],
    CONCAT('Q', DATEPART(QQ, A.[DATA])) AS [quarter_name],
    CONCAT(DATEPART(YY, A.[DATA]), DATEPART(QQ, A.[DATA])) AS [year_quarter_number],
    CONCAT(DATEPART(YY, A.[DATA]), 'Q', DATEPART(QQ, A.[DATA])) AS [year_quarter_name],
    DATEFROMPARTS(YEAR(A.[DATA]), (DATEPART(QQ, A.[DATA]) * 3) - 2, 1) AS [start_of_quarter],
    EOMONTH(DATEFROMPARTS(YEAR(A.[DATA]), (DATEPART(QQ, A.[DATA]) * 3), 1), 0) AS [end_of_quarter],
    DATEPART(WW, A.[DATA]) AS [week_of_year],
    DATEADD(DAY, (DATEPART(WEEKDAY, A.[DATA]) * 1), A.[DATA]) AS [start_of_week],
    DATEADD(DAY, 7 - DATEPART(WEEKDAY, A.[DATA]), A.[DATA]) AS [end_of_week],
    CASE @INICIO_ANO_FISCAL
        WHEN 1 THEN
            CASE
                WHEN MONTH(A.[DATA]) < @INICIO_ANO_FISCAL THEN YEAR(A.[DATA])
                ELSE YEAR(A.[DATA]) + 1
            END
        ELSE YEAR(A.[DATA])
    END AS [fiscal_year],
    DATEPART(QQ, DATEFROMPARTS(YEAR(A.[DATA]), ((MONTH(A.[DATA]) + (13 - @INICIO_ANO_FISCAL) - 1) % 12) + 1, 1)) AS [fiscal_quarter],
    ((MONTH(A.[DATA]) + (13 - @INICIO_ANO_FISCAL) - 1) % 12) + 1 AS [fiscal_month],
    DATEDIFF(DAY, @HOJE, A.[DATA]) AS [day_offset],
    DATEDIFF(MONTH, @HOJE, A.[DATA]) AS [month_offset],
    DATEDIFF(QUARTER, @HOJE, A.[DATA]) AS [quarter_offset],
    DATEDIFF(YEAR, @HOJE, A.[DATA]) AS [year_offset]
FROM 
    DATAS A WITH (NOLOCK)
ORDER BY 
    A.[DATA];


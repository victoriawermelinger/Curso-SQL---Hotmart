CREATE FUNCTION FN_MONTAR_D_CALENDARIO(
    @D_INI DATE,
    @D_FIM DATE,
    @ANO_FECHADO BIT,
    @INICIO_ANO_FISCAL INT
)
RETURNS @D_CALENDARIO TABLE (
    [date] DATE PRIMARY KEY,
    [year] INT,
    [start of year] DATE,
    [end of year] DATE,
    [month] TINYINT,
    [start of month] DATE,
    [end of month] DATE,
    [day_in_month] TINYINT,
    [year_month_number] INT,
    [year_month_name] VARCHAR(8),
    [day] TINYINT,
    [day_name] VARCHAR(15),
    [day_name_short] CHAR(3),
    [day_of_week] TINYINT,
    [day_of_year] SMALLINT,
    [month_name] VARCHAR(15),
    [month_name_short] CHAR(3),
    [quarter] TINYINT,
    [quarter_name] CHAR(2),
    [year_quarter_number] INT,
    [year_quarter_name] VARCHAR(7),
    [start_of_quarter] DATE,
    [end_of_quarter] DATE,
    [week_of_year] TINYINT,
    [start_of_week] DATE,
    [end_of_week] DATE,
    [fiscal_year] INT,
    [fiscal_quarter] TINYINT,
    [fiscal_month] TINYINT,
    [day_offset] INT,
    [month_offset] INT,
    [quarter_offset] INT,
    [year_offset] INT
)
AS 
BEGIN
    DECLARE @HOJE DATE = CAST(GETDATE() AS DATE);
    DECLARE @ANO_INI INT = YEAR(@D_INI);
    DECLARE @ANO_FIM INT = YEAR(@D_FIM);
    DECLARE @DATA_INI DATE;
    DECLARE @DATA_FIM DATE;
    
    SET @DATA_INI = CAST(CONCAT(@ANO_INI, '-01-01') AS DATE);
    SET @DATA_FIM = CASE @ANO_FECHADO WHEN 1 THEN CAST(CONCAT(@ANO_FIM, '-12-31') AS DATE) ELSE @D_FIM END;

    ;WITH DATAS AS (
        SELECT DATEADD(DAY, a.SEQUENCIA - 1, @D_INI) AS [DATA]
        FROM VEZES a
        WHERE a.SEQUENCIA <= DATEDIFF(DAY, @DATA_INI, @DATA_FIM) + 1
    )
    INSERT INTO @D_CALENDARIO (
        [date],
        [year],
        [start of year],
        [end of year],
        [month],
        [start of month],
        [end of month],
        [day_in_month],
        [year_month_number],
        [year_month_name],
        [day],
        [day_name],
        [day_name_short],
        [day_of_week],
        [day_of_year],
        [month_name],
        [month_name_short],
        [quarter],
        [quarter_name],
        [year_quarter_number],
        [year_quarter_name],
        [start_of_quarter],
        [end_of_quarter],
        [week_of_year],
        [start_of_week],
        [end_of_week],
        [fiscal_year],
        [fiscal_quarter],
        [fiscal_month],
        [day_offset],
        [month_offset],
        [quarter_offset],
        [year_offset]
    )
    SELECT 
        A.[DATA] AS [date],
        DATEPART(YY, A.[DATA]) AS [year],
        DATEFROMPARTS(YEAR(A.[DATA]), 1, 1) AS [start of year],
        DATEFROMPARTS(YEAR(A.[DATA]), 12, 31) AS [end of year],
        DATEPART(MM, A.[DATA]) AS [month],
        DATEFROMPARTS(YEAR(A.[DATA]), MONTH(A.[DATA]), 1) AS [start of month],
        EOMONTH(A.[DATA]) AS [end of month],
        DATEPART(DD, EOMONTH(A.[DATA])) AS [day_in_month],
        CONCAT(YEAR(A.[DATA]), RIGHT('00' + CAST(MONTH(A.[DATA]) AS VARCHAR(2)), 2)) AS [year_month_number],
        CONCAT(DATEPART(YY, A.[DATA]), '-', LEFT(DATENAME(MM, A.[DATA]), 3)) AS [year_month_name],
        DATEPART(DD, A.[DATA]) AS [day],
        LEFT(DATENAME(DW, A.[DATA]), 3) AS [day_name],
        LEFT(DATENAME(DW, A.[DATA]), 3) AS [day_name_short],
        DATEPART(WEEKDAY, A.[DATA]) AS [day_of_week],
        DATEPART(DY, A.[DATA]) AS [day_of_year],
        LEFT(DATENAME(MM, A.[DATA]), 3) AS [month_name],
        LEFT(DATENAME(MM, A.[DATA]), 3) AS [month_name_short],
        DATEPART(QQ, A.[DATA]) AS [quarter],
        CONCAT('Q', DATEPART(QQ, A.[DATA])) AS [quarter_name],
        CONCAT(YEAR(A.[DATA]), DATEPART(QQ, A.[DATA])) AS [year_quarter_number],
        CONCAT(YEAR(A.[DATA]), 'Q', DATEPART(QQ, A.[DATA])) AS [year_quarter_name],
        DATEFROMPARTS(YEAR(A.[DATA]), ((DATEPART(QQ, A.[DATA]) - 1) * 3) + 1, 1) AS [start_of_quarter],
        DATEADD(DAY, -1, DATEADD(MONTH, (DATEPART(QQ, A.[DATA]) * 3), DATEFROMPARTS(YEAR(A.[DATA]), 1, 1))) AS [end_of_quarter],
        DATEPART(WW, A.[DATA]) AS [week_of_year],
        DATEADD(DAY, 1 - DATEPART(WEEKDAY, A.[DATA]), A.[DATA]) AS [start_of_week],
        DATEADD(DAY, 7 - DATEPART(WEEKDAY, A.[DATA]), A.[DATA]) AS [end_of_week],
        CASE WHEN MONTH(A.[DATA]) < @INICIO_ANO_FISCAL THEN YEAR(A.[DATA]) ELSE YEAR(A.[DATA]) + 1 END AS [fiscal_year],
        ((MONTH(A.[DATA]) + (13 - @INICIO_ANO_FISCAL) - 1) % 12) + 1 AS [fiscal_quarter],
        ((MONTH(A.[DATA]) + (13 - @INICIO_ANO_FISCAL) - 1) % 12) + 1 AS [fiscal_month],
        DATEDIFF(DAY, @HOJE, A.[DATA]) AS [day_offset],
        DATEDIFF(MONTH, @HOJE, A.[DATA]) AS [month_offset],
        DATEDIFF(QUARTER,  @HOJE, A.[DATA]) AS [quarter_offset],
        DATEDIFF(YEAR, @HOJE, A.[DATA]) AS [year_offset]
FROM DATAS A WITH(NOLOCK)
ORDER BY 1

RETURN
END
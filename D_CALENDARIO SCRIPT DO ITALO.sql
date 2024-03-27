DECLARE
	@D_INI				DATE ='2018-01-01'
  , @D_FIM				DATE ='2022-12-31'
  , @ANO_FECHADO        BIT  = 1
  , @INICIO_ANO_FISCAL  INT  = 7

DECLARE @HOJE			DATE = CAST(GETDATE()AS DATE)

DECLARE @ANO_INI   INT = YEAR(@_INI)
DECLARE @ANO_FIM   INT = YEAR(@_FIM)

DECLARE @DATA_INI    DATE
DECLARE @DATA_FIM    DATE

SET @DATA_INI  = CAST( CONCAT(@ANO_INI, '-01-01') AS DATE)
SET @DATA_FIM  = CASE @ANO_FECHADO WHEN 1 THEN CAST( CONCAT (@ANO_FIM, '-12-31') AS DATE)ELSE @D_FIM END 

;WITH DATAS AS (
SELECT DATEADD (DAY, a.SEQUENCIA - 1, @D_INI) AS [DATA]
FROM VEZES a WITH (NOLOCK)
WHERE a.SEQUENCIA <= DATEDIFF(DAY, @DATA_INI ,@DATA_FIM)) + 1
)

SELECT A. [DATA]																			AS [date]
, DATEPART (YY, A. [DATA] )																	AS[year]
, DATEFROMPARTS ( YEAR A. [DATA] ) , 1, 1 )													AS[start_of_year]
, DATEFROMPARIS YEAR A. [DATA] ), 12 , 31 )													AS [end_of_year]
, DATEPART (mm , A.[DATA] )																	AS[month]
, DATEFROMPARTS YEAR A.[DATA]) , MONTH A. [DATA] ) , 1 )									AS[star_of_month]
, EOMONTH (A. [DATA] )																		AS[end_of_month] 
, DATEPART (dd, FOMONTH( A. [DATA] ) )														AS [day_in_month]
, CONCAT (
	YEAR (A. [DATA] ) ,
	 CONCAT ( REPLICATE('0', 2 - LEN( MONTH ( A.[DATA]))), MONTH(A.[DATA] )))				AS	[year_month_number]
, CONCAT( DATEPART (YY, A. [DATA]) , '-', LOWER( LEFT (DATENAME( mm, A.[DATA] ) , 3 )))		AS	[year_month_name ]

, DATEPART ( dd, A. [DATA] )																AS	[day]
, LOWER( DATENAME (dW, A.[DATA] ) )															AS	[day_namel]
, LOWER (LEFT( DATENAME (dw, A.[DATA] ) , 3 ) )												AS	[day_name_short]
, DATEPART ( [weekday] , A.[DATA] )															AS	[day_of_week]
, DATEPART (dy, A. [DATA] )																	AS	[day_of_year]
, LOWER (DATENAME ( mm, A. [DATA] ) )														AS	[month_name]
, LOWER LEFT DATENAME ( mm, A.[DATA]) ), 3) )												As	[month_name, _short]
, DATEPART (qq, A.[DATA])																	AS	[quarter]
, CONCAT('Q', DATEPART( qq, A.[DATA] ))														AS	[quarter_name]
, CONCAT ( DATEPART(yy, A.[DATA]) , DATEPART(qq, A.[DATA]) )								AS	[year_quarter_number]
, CONCAT( DATEPART (yy, A.[DATA]) , 'Q', DATEPART (qq, A.[DATA] ) )							AS	[year_quarter_name]
, DATEFROMPARTS ( YEAR( A.[DATA] ), (DATEPART (qq, A. [DATA] ) *3) -2, 1)					AS	[start_of_quarter]
, EOMONTH( DATEFROMPARTS ( YEAR ( A.[DATA] ), (DATEPART (qq, A.[DATA] ))*3, 1),0)			AS	[end_of_quarter]
, DATEPARt(wk, A.[DATA] )																	AS	[week_of_year]
, DATEADD( DAY, ( DATEPART( [weekday], A.[DATA] ) 1) , A.[DATA] )							As	[star_of_week]
, DATEADD( DAY, / DATEPART ( [weckday], A.[DATA] ) , A.[DATA] )								AS	[end_of_week]
, CASE INICIO_ANO_FISCAL
	WHEN 1
	WHEN YEAR A. [DATA] )
	ELSE YEAR A. [DATA]) + CAST ( MONTH A.[DATA]) + (13 - @INICTO_ANO_FICAL))/13 AS INT)	AS [fical_year]
END
, DATEPART( qq, DATEFROMPARTS(
	YEAR A.[DATA] ), ((MONTH( A.[DATA]) + (13 - @INICIO_ANO_FISCAL) - 1) % 12 ) + 1 , 1))  AS [fiscal_quarter]
, ( ( MONTH( A.[DATA] ) + (13 @INICIO_ANO_FISCAL) -1) %12)+1  AS [fiscal_month]
, DATEDIFF( DAY , @HOTE , A.[DATA])														   AS [day_offset]
, DATEDIFF( MONTH , @HOTE , A.[DATA])													   AS [month_offset]
, DATEDIFF( QUARTER, @HOTE, A. [DATA])													   AS [quarter_offset]
, DATEDIFF( YEAR, , @HOTE , A.[DATA])													   AS Lyear_offset]
 FROM DATAS A WITH(NOLOCK)
ORDER BY 1























use PBS_PROCFIT_DADOS

-- CRIANDO A PRIMEIRA FUNÇÃO 
/*
declare @V1 varchar(10) = 'Italo'
declare @V2 varchar(10) = 'Maria'

select isnull (@v1, @v2)

select case when @V1 is null then @V2 else @V1 end 

create table tblnomes (
  Nome  varchar(50)
, Apelido varchar (30)


select * from tblnomes

insert into tblnomes (Nome, Apelido)
values  ('Victoria', ' Vicky')
,		('Matheus', 'Teteus')
,		('Ricardo', ' ')
,		('Samara', 'Samy')

update tblnomes
set Apelido = null
where nome = 'Samara'
*/

select * 
	, isnull (Apelido, Nome)
	, case when nullif( trim (apelido), '') is null then Nome else Apelido end 
from  tblnomes

declare @v1 varchar(50) = 'Victoria'
declare @v2 varchar(50) = ' Samara'

set @v1 = nullif(trim (@v1), '')
set @v2 = nullif(trim (@v2), '')

select @v1 , @v2

select case when @v1 is null then @v2 else @v1 end 

--- criando função 
/*
create function Fn_isnull(@v1 varchar(50), @v2 varchar(50))
returns varchar(50) 
as begin 
-- texto da função ou a ação que ela vai fazer 
end 
*/
/*
create function Fn_isnull(@v1 varchar(50), @v2 varchar(50))
returns varchar(50) 
as begin 
declare @retorno varchar(50)

set @v1 = nullif(trim (@v1), '')
set @v2 = nullif(trim (@v2), '')
-- set @retorno = case when @v1 is null then @v2 else @v1 end
select @retorno = case when @v1 is null then @v2 else @v1 end
--return (select case when @v1 is null then @v2 else @v1 end) 
end
*/
----------
create function Fn_isnull(@v1 varchar(50), @v2 varchar(50))
returns varchar(50) 
as begin 
declare @retorno varchar(50)

set @v1 = nullif(trim (@v1), '')
set @v2 = nullif(trim (@v2), '')
return (select case when @v1 is null then @v2 else @v1 end) 
end 

select * 
	, isnull (Apelido, Nome)
	, case when nullif( trim (apelido), '') is null then Nome else Apelido end 
	, dbo.fn_isnull (apelido, nome)
from  tblnomes

--Fixando a sintexe das funções 
	
select ENTIDADE
, INSCRICAO_FEDERAL
, replace(replace( replace ( INSCRICAO_FEDERAL, '.' , ''), '-', ''),'/' ,'')
, len (replace(replace( replace ( INSCRICAO_FEDERAL, '.' , ''), '-', ''),'/' ,''))
, case when len (replace(replace( replace ( INSCRICAO_FEDERAL, '.' , ''), '-', ''),'/' ,'')) = 14
	then 'PJ'
	when len (replace(replace( replace ( INSCRICAO_FEDERAL, '.' , ''), '-', ''),'/' ,'')) = 12
	then 'PF'
	else 'ND'
 end 
							-- duas formas de usar o case when. 
, case len (replace(replace( replace ( INSCRICAO_FEDERAL, '.' , ''), '-', ''),'/' ,''))
	when 14 then 'PJ'
	when 11 then 'PF'
	else 'ND' 
 end 
 , dbo.FN_TIPO_INSCRIÇÃO(inscricao_federal)
 from ENTIDADES
--where INSCRICAO_FEDERAL is not null 

	-- função tipo de inscrição
create function FN_TIPO_INSCRIÇÃO(@INSCRICAO_FEDERAL VARCHAR(50))
RETURNS CHAR(2)
as begin
	declare @tipo_inscricao char(2)
set @INSCRICAO_FEDERAL = replace(replace( replace ( @INSCRICAO_FEDERAL, '.' , ''), '-', ''),'/' ,'')
set @tipo_inscricao = case len(@INSCRICAO_FEDERAL)
								when 14 then 'PJ'
								when 11 then 'PF'
								else 'ND' 
							 end 
return @tipo_inscricao 

end

	-- função tipo de inscrição

create function FN_TIPO_INSCRIÇÃOII (@Cliente numeric(15))
RETURNS CHAR(2)
as begin
	declare @tipo_inscricao char(2)
	declare @inscricao_federal varchar(50)

	select @inscricao_federal = INSCRICAO_FEDERAL
	from ENTIDADES
	where ENTIDADE = @Cliente

set @INSCRICAO_FEDERAL = replace(replace( replace ( @INSCRICAO_FEDERAL, '.' , ''), '-', ''),'/' ,'')
set @tipo_inscricao = case len(@INSCRICAO_FEDERAL)
								when 14 then 'PJ'
								when 11 then 'PF'
								else 'ND' 
							 end 
return @tipo_inscricao 

end

select [dbo].[FN_MASCARA_CPF] (123456789) 

-- procedures são frequentemente usados para se referir a blocos de código que realizam uma tarefa específica. Eles podem ser chamados em diferentes partes de um programa para executar a mesma operação.
-- Criando procedures com retorno
	--> Armazene um dim_clientes 

create procedure USP_retorna_clientes
as begin 
select a.ENTIDADE				as entidade
	 , a.NOME					as nome 
	 , a.NOME_FANTASIA			as nome_fantasia
	 , a.INSCRICAO_FEDERAL		as inscricao_federal
	 , b.DESCRICAO				as classif_cliente
	 , c.CIDADE					as cidade
	 , d.NOME					as estado 
	 , c.ESTADO					as UF
from ENTIDADES a 
left join CLASSIFICACOES_CLIENTES b on a.CLASSIFICACAO_CLIENTE = b.CLASSIFICACAO_CLIENTE
left join ENDERECOS	c				on a.ENTIDADE = c.ENTIDADE
left join ESTADOS d					on c.ESTADO = d.ESTADO
end

/*
ctrt + N -- nova consulta 
execute usp_retorna_clientes
exec usp_retorna_clientes
*/

alter procedure USP_retorna_clientes_parametros(@uf char(2))
as begin 
select a.ENTIDADE				as entidade
	 , a.NOME					as nome 
	 , a.NOME_FANTASIA			as nome_fantasia
	 , a.INSCRICAO_FEDERAL		as inscricao_federal
	 , b.DESCRICAO				as classif_cliente
	 , c.CIDADE					as cidade
	 , d.NOME					as estado 
	 , c.ESTADO					as UF
from ENTIDADES a 
left join CLASSIFICACOES_CLIENTES b on a.CLASSIFICACAO_CLIENTE = b.CLASSIFICACAO_CLIENTE
left join ENDERECOS	c				on a.ENTIDADE = c.ENTIDADE
left join ESTADOS d					on c.ESTADO = d.ESTADO
 where (c.ESTADO = @uf or @uf is null)
end
--drop procedure  USP_retorna_clientes_parametros

--Criando procedures sem retorno
if OBJECT_ID('tbl_clientes') is null
begin
-- criando tabela de clintes consolidado
-- APENAS SER ELA NÃO EXIXTIR 
create table tbl_clientes(
  ENTIDADE			NUMERIC(15)
, NOME				VARCHAR(80)
, NOME_FANTASIA		VARCHAR(60)
, INSCRICAO_FEDERAL VARCHAR(19)
, CLASSIFIVACAO		VARCHAR(80)
, CIDADE			VARCHAR(80)
, ESTADO			VARCHAR(80)
, UF				CHAR(2)
)

end 

-- populando tabela de clientes consolidado
insert into tbl_clientes(
  ENTIDADE			
, NOME				
, NOME_FANTASIA		
, INSCRICAO_FEDERAL 
, CLASSIFIVACAO		
, CIDADE			
, ESTADO			
, UF				
)

select a.ENTIDADE				as entidade
	 , a.NOME					as nome 
	 , a.NOME_FANTASIA			as nome_fantasia
	 , a.INSCRICAO_FEDERAL		as inscricao_federal
	 , b.DESCRICAO				as classif_cliente
	 , c.CIDADE					as cidade
	 , d.NOME					as estado 
	 , c.ESTADO					as UF
from ENTIDADES					  a 
left join CLASSIFICACOES_CLIENTES b on a.CLASSIFICACAO_CLIENTE = b.CLASSIFICACAO_CLIENTE
left join ENDERECOS				  c	on a.ENTIDADE = c.ENTIDADE
left join ESTADOS				  d	on c.ESTADO = d.ESTADO


-- ESSA FORMA APRESENTADA ELA ESTA SEM CHAVE PRIMARIA E A CADA SELECT VAI DUPLICAR A INFORMACAO 

-- NOVA FORMA DE FAZER E CRINDO UMA PROCEDURE 
--CREATE
alter PROCEDURE USP_ATUALIZA_CLIENTES_CONSOLIDADO
AS
IF OBJECT_ID('tbl_clientes') IS NULL
BEGIN
   -- Criando tabela de clientes consolidado APENAS SE ELA NÃO EXISTIR
   CREATE TABLE tbl_clientes (
      ENTIDADE           NUMERIC(15) PRIMARY KEY,
      NOME               VARCHAR(80),
      NOME_FANTASIA      VARCHAR(60),
      INSCRICAO_FEDERAL  VARCHAR(19),
      CLASSIFICACAO      VARCHAR(80),
      CIDADE             VARCHAR(80),
      ESTADO             VARCHAR(80),
      UF                 CHAR(2)
   )
END

IF OBJECT_ID('TEMPDB..#DADOS_INTEGRACAO') IS NOT NULL DROP TABLE #DADOS_INTEGRACAO

SELECT
   a.ENTIDADE AS entidade,
   a.NOME,
   a.NOME_FANTASIA,
   a.INSCRICAO_FEDERAL,
   b.DESCRICAO AS classif_cliente,
   c.CIDADE,
   d.NOME AS estado,
   c.ESTADO AS UF
INTO #DADOS_INTEGRACAO
FROM
   ENTIDADES a
   LEFT JOIN CLASSIFICACOES_CLIENTES b ON a.CLASSIFICACAO_CLIENTE = b.CLASSIFICACAO_CLIENTE
   LEFT JOIN ENDERECOS c ON a.ENTIDADE = c.ENTIDADE
   LEFT JOIN ESTADOS d ON c.ESTADO = d.ESTADO

-- Populando tabela de clientes consolidado
MERGE TBL_CLIENTES D 
USING #DADOS_INTEGRACAO O ON D.ENTIDADE = O.ENTIDADE
WHEN MATCHED THEN UPDATE
   SET  
      NOME               = O.nome,
      NOME_FANTASIA      = O.nome_fantasia,
      INSCRICAO_FEDERAL  = O.inscricao_federal,
      CLASSIFICACAO      = O.classif_cliente,
      CIDADE             = O.cidade,
      ESTADO             = O.estado,
      UF                 = O.UF

WHEN NOT MATCHED BY TARGET THEN INSERT (
   ENTIDADE,
   NOME,
   NOME_FANTASIA,
   INSCRICAO_FEDERAL,
   CLASSIFICACAO, 
   CIDADE,
   ESTADO,
   UF
)
VALUES (
   O.ENTIDADE,
   O.NOME,
   O.NOME_FANTASIA,
   O.INSCRICAO_FEDERAL,
   O.classif_cliente,
   O.CIDADE,
   O.estado,
   O.UF
);
SELECT 'Tabela atualizada com sucesso'

--ABRIR UMA NOVA CONSULTA E TESTAR 
EXEC USP_ATUALIZA_CLIENTES_CONSOLIDADO

-- criando views ( é um objeto de banco de dados que representa uma consulta armazenada. Ele permite que você armazene uma consulta SQL comum no banco de dados, de modo que você possa reutilizá-la facilmente. As views podem conter joins, funções e cláusulas where, facilitando o acesso aos dados de maneira organizada e segura. Elas são úteis para simplificar consultas complexas e garantir a segurança dos dados, controlando quais informações estão disponíveis para quais usuários.)
create view VW_CLIENTES_CONSOLIDADO
AS
select a.ENTIDADE				as entidade
	 , a.NOME					as nome 
	 , a.NOME_FANTASIA			as nome_fantasia
	 , a.INSCRICAO_FEDERAL		as inscricao_federal
	 , b.DESCRICAO				as classif_cliente
	 , c.CIDADE					as cidade
	 , d.NOME					as estado 
	 , c.ESTADO					as UF
from ENTIDADES					  a 
left join CLASSIFICACOES_CLIENTES b on a.CLASSIFICACAO_CLIENTE = b.CLASSIFICACAO_CLIENTE
left join ENDERECOS				  c	on a.ENTIDADE = c.ENTIDADE
left join ESTADOS				  d	on c.ESTADO = d.ESTADO
-------------------------------------------
SELECT * FROM VW_CLIENTES_CONSOLIDADO
WHERE UF IS NOT NULL
 ORDER BY ENTIDADE

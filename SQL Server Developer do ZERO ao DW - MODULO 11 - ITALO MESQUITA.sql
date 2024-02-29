use PBS_PROCFIT_DADOS

-- CRIANDO A PRIMEIRA FUN��O 
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

--- criando fun��o 
/*
create function Fn_isnull(@v1 varchar(50), @v2 varchar(50))
returns varchar(50) 
as begin 
-- texto da fun��o ou a a��o que ela vai fazer 
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

--Fixando a sintexe das fun��es 

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
 , dbo.FN_TIPO_INSCRI��O(inscricao_federal)
 from ENTIDADES
--where INSCRICAO_FEDERAL is not null 


create function FN_TIPO_INSCRI��O(@INSCRICAO_FEDERAL VARCHAR(50))
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


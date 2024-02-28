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














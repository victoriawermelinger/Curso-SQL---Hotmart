use PBS_PROCFIT_DADOS
/*
  Data Mart x Data Warehouse
Data Mart e Data Warehouse s�o ambos reposit�rios centrais para armazenar e gerenciar dados, mas t�m prop�sitos ligeiramente diferentes dentro do dom�nio da gest�o e an�lise de dados.

Data Warehouse:

Um Data Warehouse � um reposit�rio centralizado para todos os dados estruturados, semi-estruturados e n�o estruturados de uma ou mais fontes. � projetado para fins anal�ticos, 
permitindo que organiza��es analisem grandes volumes de dados hist�ricos para tomar decis�es informadas. Os Data Warehouses geralmente passam por um processo chamado 
ETL (Extra��o, Transforma��o, Carga) para coletar, limpar e organizar dados de v�rias fontes antes de armazen�-los em um formato estruturado otimizado para consultas e an�lises.

Os Data Warehouses s�o normalmente sistemas de grande escala que suportam consultas complexas e necessidades de relat�rios em toda a organiza��o. Eles geralmente exigem um
investimento significativo inicial em termos de infraestrutura, design e manuten��o.

Data Mart:

Um Data Mart � um subconjunto de um Data Warehouse, focado em uma fun��o de neg�cios ou departamento espec�fico dentro de uma organiza��o. Ao contr�rio dos Data Warehouses, 
que s�o reposit�rios em toda a empresa, os Data Marts s�o menores em escala e atendem �s necessidades de um grupo ou departamento espec�fico. Eles s�o projetados para fornecer 
acesso r�pido a dados relevantes para grupos de usu�rios espec�ficos, o que ajuda a acelerar an�lises e processos de tomada de decis�o dentro desses departamentos.

Os Data Marts podem ser independentes ou dependentes. Data Marts independentes s�o bancos de dados independentes que s�o populados diretamente a partir de sistemas de origem, 
enquanto Data Marts dependentes s�o derivados do Data Warehouse da empresa e s�o criados para atender a grupos de usu�rios espec�ficos.

Principais Diferen�as:

1. Escopo: Data Warehouses abrangem todos os dados da organiza��o, enquanto Data Marts se concentram em departamentos ou grupos de usu�rios espec�ficos.

2. Prop�sito: Data Warehouses s�o projetados para an�lises e relat�rios em toda a empresa, enquanto Data Marts atendem �s necessidades espec�ficas de departamentos ou unidades 
de neg�cios.

3. Tamanho e Complexidade: Data Warehouses s�o geralmente sistemas maiores e mais complexos devido ao seu escopo em toda a empresa, enquanto Data Marts s�o menores e mais simples 
em compara��o.

4. Integra��o de Dados: Data Warehouses exigem esfor�os extensivos de integra��o de dados por meio de processos ETL, enquanto Data Marts podem ter requisitos de integra��o mais 
simples, j� que se concentram nas necessidades espec�ficas de dados.

Em resumo, enquanto os Data Warehouses servem como reposit�rios abrangentes de dados empresariais, os Data Marts oferecem uma abordagem mais focada e personalizada para a gest�o e
an�lise de dados, atendendo �s necessidades espec�ficas de departamentos ou grupos de usu�rios dentro de uma organiza��o.
*/

-- Dimens�es x Fatos 
select b.NOME		as NOME_CLIENTE
, C.NOME_FANTASIA	as EMPRESA
, sum(QUANTIDADE)	as QTD_VENDIDO
from VENDAS_ANALITICAS a
join ENTIDADES					b on a.CAIXA = b.ENTIDADE
join EMPRESAS_USUARIAS			c on a.EMPRESA = c. EMPRESA_USUARIA
group by b.NOME , c.NOME_FANTASIA

/* DIMENSOES = Sao infomacoes que completa o fato */

/* FATOS - fato e a infomacao de fato que acontece 
VENDENDOR 
PRODUTO
CLIENTE
TIPO DE PEDIDO */



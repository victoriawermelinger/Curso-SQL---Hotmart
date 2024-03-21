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

/* Entendento a �rea Stage 
Na �rea de dados, o termo "Stage" geralmente se refere a uma �rea de prepara��o ou transi��o onde os dados s�o temporariamente armazenados e
processados antes de serem carregados em seu destino final, como um Data Warehouse ou um Data Mart. 

Data Staging:

- �rea de Prepara��o: Nessa etapa, os dados brutos provenientes de diversas fontes s�o coletados e armazenados temporariamente em uma estrutura de dados adequada para
processamento adicional.

-Transforma��o de Dados: Durante essa fase, os dados podem passar por transforma��es necess�rias, como limpeza, formata��o, agrega��o ou enriquecimento, 
para garantir que estejam prontos para an�lise ou carregamento nos sistemas de destino.

-Valida��o e Controle de Qualidade: A �rea de Stage tamb�m pode ser usada para realizar verifica��es de integridade, valida��o e controle de qualidade nos dados
antes que sejam movidos para o pr�ximo est�gio do processo de ETL (Extra��o, Transforma��o e Carga).

Benef�cios da �rea de Stage:

1.Isolamento de Processamento: Separar a �rea de Stage dos sistemas de produ��o ajuda a minimizar o impacto nas opera��es em tempo real, 
permitindo processamento e manipula��o intensivos de dados sem prejudicar o desempenho dos sistemas principais.

2.Facilita a Manuten��o: Ter uma �rea dedicada para a prepara��o e transforma��o de dados facilita a manuten��o e o gerenciamento do fluxo de dados,
permitindo ajustes e corre��es conforme necess�rio sem afetar diretamente os sistemas de produ��o.

3.Maior Flexibilidade: A �rea de Stage oferece flexibilidade para experimenta��o e teste de diferentes abordagens de transforma��o e
prepara��o de dados antes de serem integrados aos sistemas de an�lise ou relat�rios.

4.Melhora a Qualidade dos Dados: Ao permitir a limpeza, valida��o e enriquecimento dos dados antes de serem carregados nos sistemas de destino, 
a �rea de Stage ajuda a garantir a qualidade e integridade dos dados utilizados para an�lise e tomada de decis�o.

Em resumo, a �rea de Stage desempenha um papel fundamental no processo de prepara��o e transforma��o de dados, 
fornecendo um ambiente controlado e isolado para processamento intermedi�rio antes que os dados sejam carregados em seus destinos finais para an�lise e uso operacional.
*/

-- Criando database STAGE
CREATE DATABASE PBS_PROCFIT_ST
--Mapeando campos para dados do cliente ainda na database PBS_PROCFIT_DADOS

SELECT a.ENTIDADE
, a.NOME
, a.NOME_FANTASIA
, b.DESCRICAO AS NOME_CLASSIFICACAO
, c.CIDADE
, c.ESTADO AS UF
, d.NOME AS ESTADO
FROM ENTIDADES					  a
LEFT JOIN CLASSIFICACOES_CLIENTES b on a.CLASSIFICACAO_CLIENTE = b.CLASSIFICACAO_CLIENTE
LEFT JOIN ENDERECOS				  c	on a.ENTIDADE			   = c.ENTIDADE
LEFT JOIN ESTADOS				  d	on c.ESTADO				   = d.ESTADO

/* TABELA DE ENTIDADE NO ST 
ENTIDADE
NOME
NOME_FANTASIA
CLASSIFICACAO_CLIENTE
*/
/* TABELA DE CLASSIFICACAO_CLIENTES NO ST
CLASSIFICACAO_CLIENTE
DESCRICAO
*/
/* TABELA DE ENDERECO NO ST 
ENTIDADE
CIDADE
UF
*/
/* TABELA DE ESTADOS NO ST
UF
ESTADO (DESCRI��O DA UF)
*/
-- VER ARQUIVOS SEPARADOS. 
/* 
ST_CLIENTES
ST_CLASSIFICACAO_CLIENTE
ST_CLIENTES_ENDERECO
ST_CLIENTES_ESTADO
USP_ST_CARGA_CLIENTE
*/

--Esquema Estelar x Floco de Neve: A principal diferen�a entre esses dois � que um esquema em floco de neve cont�m dimens�es normalizadas, enquanto um esquema em estrela cont�m dimens�es desnormalizadas.

--DIMESAO EMPRESA (ST-ok)
--DIMESAO CALENDARIO 
--DIMESAO PRODUTO (ST-ok)
--DIMESAO VENDEDOR (ST-OK)
--DIMESAO CLIENTE(ST-ok)
--FATO VENDAS 

-- FAZER AS OUTRAS ST

--DIMESAO VENDEDOR (QUERY BASE)

SELECT VENDEDOR
, NOME
FROM VENDEDORES 
--PASTA ST_VENDEDORES

--DIMESAO EMPRESA 
SELECT EMPRESA_USUARIA
,NOME
,NOME_FANTASIA
FROM EMPRESAS_USUARIAS
--- PASTA ST_EMPRESAS

--DIMESAO PRODUTO 
SELECT a.PRODUTO
,	   a.DESCRICAO
,	   a.DESCRICAO_REDUZIDA
,      b.DESCRICAO AS FAMILIA
,	   c.DESCRICAO AS SECAO
,      d.DESCRICAO AS GRUPO
,	   e.DESCRICAO AS SUB_GRUPO
,	   f.DESCRICAO AS MARCA
FROM PRODUTOS				 a
LEFT JOIN FAMILIAS_PRODUTOS  b ON a.FAMILIA_PRODUTO  = b.FAMILIA_PRODUTO
	 JOIN SECOES_PRODUTOS	 c ON a.SECAO_PRODUTO	 = c.SECAO_PRODUTO
	 JOIN GRUPOS_PRODUTOS    d ON a.GRUPO_PRODUTO	 = d.GRUPO_PRODUTO
	 JOIN SUBGRUPOS_PRODUTOS e ON a.SUBGRUPO_PRODUTO = e.SUBGRUPO_PRODUTO
LEFT JOIN MARCAS			 f ON a.MARCA			 = f.MARCA
--PASTA ST_PRODUTO

--FATO VENDAS 
SELECT 
  DOCUMENTO_NUMERO
, EMPRESA
, CLIENTE
, VENDEDOR
, MOVIMENTO 
, PRODUTO
, QUANTIDADE
, VENDA_BRUTA
, DESCONTO + DESCONTO_NEGOCIADO AS DESCONTO
, VENDA_LIQUIDA
FROM VENDAS_ANALITICAS
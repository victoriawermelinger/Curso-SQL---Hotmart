use PBS_PROCFIT_DADOS
/*
  Data Mart x Data Warehouse
Data Mart e Data Warehouse são ambos repositórios centrais para armazenar e gerenciar dados, mas têm propósitos ligeiramente diferentes dentro do domínio da gestão e análise de dados.

Data Warehouse:

Um Data Warehouse é um repositório centralizado para todos os dados estruturados, semi-estruturados e não estruturados de uma ou mais fontes. É projetado para fins analíticos, 
permitindo que organizações analisem grandes volumes de dados históricos para tomar decisões informadas. Os Data Warehouses geralmente passam por um processo chamado 
ETL (Extração, Transformação, Carga) para coletar, limpar e organizar dados de várias fontes antes de armazená-los em um formato estruturado otimizado para consultas e análises.

Os Data Warehouses são normalmente sistemas de grande escala que suportam consultas complexas e necessidades de relatórios em toda a organização. Eles geralmente exigem um
investimento significativo inicial em termos de infraestrutura, design e manutenção.

Data Mart:

Um Data Mart é um subconjunto de um Data Warehouse, focado em uma função de negócios ou departamento específico dentro de uma organização. Ao contrário dos Data Warehouses, 
que são repositórios em toda a empresa, os Data Marts são menores em escala e atendem às necessidades de um grupo ou departamento específico. Eles são projetados para fornecer 
acesso rápido a dados relevantes para grupos de usuários específicos, o que ajuda a acelerar análises e processos de tomada de decisão dentro desses departamentos.

Os Data Marts podem ser independentes ou dependentes. Data Marts independentes são bancos de dados independentes que são populados diretamente a partir de sistemas de origem, 
enquanto Data Marts dependentes são derivados do Data Warehouse da empresa e são criados para atender a grupos de usuários específicos.

Principais Diferenças:

1. Escopo: Data Warehouses abrangem todos os dados da organização, enquanto Data Marts se concentram em departamentos ou grupos de usuários específicos.

2. Propósito: Data Warehouses são projetados para análises e relatórios em toda a empresa, enquanto Data Marts atendem às necessidades específicas de departamentos ou unidades 
de negócios.

3. Tamanho e Complexidade: Data Warehouses são geralmente sistemas maiores e mais complexos devido ao seu escopo em toda a empresa, enquanto Data Marts são menores e mais simples 
em comparação.

4. Integração de Dados: Data Warehouses exigem esforços extensivos de integração de dados por meio de processos ETL, enquanto Data Marts podem ter requisitos de integração mais 
simples, já que se concentram nas necessidades específicas de dados.

Em resumo, enquanto os Data Warehouses servem como repositórios abrangentes de dados empresariais, os Data Marts oferecem uma abordagem mais focada e personalizada para a gestão e
análise de dados, atendendo às necessidades específicas de departamentos ou grupos de usuários dentro de uma organização.
*/

-- Dimensões x Fatos 
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



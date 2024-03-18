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

/* Entendento a área Stage 
Na área de dados, o termo "Stage" geralmente se refere a uma área de preparação ou transição onde os dados são temporariamente armazenados e
processados antes de serem carregados em seu destino final, como um Data Warehouse ou um Data Mart. 

Data Staging:

- Área de Preparação: Nessa etapa, os dados brutos provenientes de diversas fontes são coletados e armazenados temporariamente em uma estrutura de dados adequada para
processamento adicional.

-Transformação de Dados: Durante essa fase, os dados podem passar por transformações necessárias, como limpeza, formatação, agregação ou enriquecimento, 
para garantir que estejam prontos para análise ou carregamento nos sistemas de destino.

-Validação e Controle de Qualidade: A área de Stage também pode ser usada para realizar verificações de integridade, validação e controle de qualidade nos dados
antes que sejam movidos para o próximo estágio do processo de ETL (Extração, Transformação e Carga).

Benefícios da Área de Stage:

1.Isolamento de Processamento: Separar a área de Stage dos sistemas de produção ajuda a minimizar o impacto nas operações em tempo real, 
permitindo processamento e manipulação intensivos de dados sem prejudicar o desempenho dos sistemas principais.

2.Facilita a Manutenção: Ter uma área dedicada para a preparação e transformação de dados facilita a manutenção e o gerenciamento do fluxo de dados,
permitindo ajustes e correções conforme necessário sem afetar diretamente os sistemas de produção.

3.Maior Flexibilidade: A área de Stage oferece flexibilidade para experimentação e teste de diferentes abordagens de transformação e
preparação de dados antes de serem integrados aos sistemas de análise ou relatórios.

4.Melhora a Qualidade dos Dados: Ao permitir a limpeza, validação e enriquecimento dos dados antes de serem carregados nos sistemas de destino, 
a área de Stage ajuda a garantir a qualidade e integridade dos dados utilizados para análise e tomada de decisão.

Em resumo, a área de Stage desempenha um papel fundamental no processo de preparação e transformação de dados, 
fornecendo um ambiente controlado e isolado para processamento intermediário antes que os dados sejam carregados em seus destinos finais para análise e uso operacional.
*/



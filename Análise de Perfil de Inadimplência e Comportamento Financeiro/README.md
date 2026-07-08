# 📊 Análise de Perfil de Inadimplência e Comportamento Financeiro

Projeto desenvolvido com SQL Server e Power BI utilizando o Credit Risk Dataset do Kaggle.

O objetivo foi identificar padrões de inadimplência e compreender quais características dos clientes estão mais associadas ao risco de crédito.

---

## Tecnologias

- SQL Server
- Power BI
- DAX
- Excel (Arquivo CSV)
- Kaggle Dataset

---

## Objetivos

- Limpeza e tratamento dos dados
- Construção de indicadores de negócio
- Criação de dashboard executivo
- Identificação de perfis com maior risco
- Geração de insights para tomada de decisão

---

## Processo do Projeto

1. Importação da base
2. Tratamento dos dados em SQL
3. Criação de métricas
4. Modelagem no Power BI
5. Desenvolvimento do dashboard
6. Extração de insights

---

## Dashboard

### Tela Inicial
![Tela Inicial](Imagens\Captura de tela 2026-07-07 093135.png)

### Panorama da Carteira
![Panorama da Carteira](Imagens\Captura de tela 2026-07-08 085616.png)

### Perfil dos Clientes
![Perfil dos clientes](Imagens\Captura de tela 2026-07-08 085625.png)

## Principais Insights

- Clientes com moradia alugada apresentam inadimplência aproximadamente 7 vezes maior do que clientes com imóvel próprio.

- Empréstimos para consolidação de dívidas registram a maior taxa de inadimplência (33,1%), indicando um perfil de maior risco. 

- Clientes com renda até R$ 3.000 apresentam taxa de inadimplência de 48,3%, quase quatro vezes superior à dos clientes com renda acima de R$ 15.000 (11,6%).

## Recomendações

- Reavaliar critérios para clientes com imóvel alugado.

- Priorizar campanhas para clientes de baixo risco.

- Fazer um acompanhamento para entender as dificuldades dos clientes que precisam quitar dívidas e assim poder oferecer a melhor solução

## Estrutura do Projeto

SQL/
    Tratamento da Base de Dados.sql

Power BI/
    Análise de perfil de inadimplência e comportamento financeiro.pbix

Imagens/
    README.md

## Dataset

Credit Risk Dataset
(Kaggle)

## Desafios encontrados

- Identificação e tratamento de valores inconsistentes (como clientes com mais de 100 anos de emprego).
- Criação de faixas de renda e idade para facilitar a análise.
- Ordenação personalizada das categorias no Power BI.
- Desenvolvimento de métricas DAX para cálculo da taxa de inadimplência.
- Definição de uma paleta de cores baseada no nível de risco para tornar a interpretação mais intuitiva.


## Autor

Tiago Bassoli

Analista de Dados em formação, com conhecimentos em SQL, Power BI, Python e tratamento de dados.

LinkedIn: www.linkedin.com/in/tiago-gabriel-bassoli
GitHub: https://github.com/TiagoBassoli
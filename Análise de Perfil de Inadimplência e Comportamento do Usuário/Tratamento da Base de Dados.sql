-- 1° Passo) Importei nesse banco de dados o arquivo csv, pelo 'Import flat file', agora vou criar uma tabela pra armazenzar cada valor
-- Já vou tratando valores nulos, eles correspondem a 10% da base e traduzindo a base pro português
SELECT 
    person_age as idade,
    person_income as renda_anual,
    person_home_ownership as tipo_moradia,
    -- Preenche o tempo de emprego com a média geral caso seja nulo
    COALESCE(
    CASE
        WHEN person_emp_length > (person_age - 14) THEN NULL
        WHEN person_emp_length < 0 THEN NULL
        ELSE person_emp_length
    END,
    6
) AS tempo_trabalho, 
    loan_intent as motivo_emprestimo,
    loan_grade as pontuacao_credito,
    loan_amnt as valor_emprestimo,
    -- Preenche a taxa usando uma média condicional por categoria
    COALESCE(
        loan_int_rate, 
        CASE 
            WHEN loan_grade = 'A' THEN 7.3
            WHEN loan_grade = 'B' THEN 11.0
            WHEN loan_grade = 'C' THEN 13.5
            ELSE 15.0 -- Valores aproximados padrão do dataset
        END
    ) as taxa_juros,
    loan_status as Inadimplente, -- 0 = Em dia, 1 = Inadimplente
    loan_percent_income as percentual_renda_parcela,
    cb_person_default_on_file as historico_inadimplencia,
    cb_person_cred_hist_length as tempo_historico_credito
into cooperados_credito
FROM cooperados_credito_import;

-- 2° Passo) Limpeza de Dados
-- Existem clientes com mais de 120 anos, provavelmente erros na própria base de dados, vamos definir um limite realista
delete from cooperados_credito
where idade > 90
-- Traduzindo motivos de empréstimo e tipos de moradia
UPDATE cooperados_credito
SET motivo_emprestimo = CASE 
    WHEN motivo_emprestimo = 'EDUCATION' THEN 'Educação'
    WHEN motivo_emprestimo = 'MEDICAL' THEN 'Médico'
    WHEN motivo_emprestimo = 'VENTURE' THEN 'Empreendimento'
    WHEN motivo_emprestimo = 'HOMEIMPROVEMENT' THEN 'Reforma de Casa'
    WHEN motivo_emprestimo = 'DEBTCONSOLIDATION' THEN 'Consolidação de Dívidas'
    WHEN motivo_emprestimo = 'PERSONAL' THEN 'Pessoal'
    ELSE motivo_emprestimo 
END,
tipo_moradia = CASE 
    WHEN tipo_moradia = 'RENT' THEN 'Alugada'
    WHEN tipo_moradia = 'MORTGAGE' THEN 'Financiada'
    WHEN tipo_moradia = 'OWN' THEN 'Própria'
    WHEN tipo_moradia = 'OTHER' then 'Outro'
    ELSE tipo_moradia
END;

-- Por fim, a tabela está tratada (Sem nulos, sem idades absurdas e em português), agora vamos criar uma view para 
-- deixar ela pronta para o Power BI
go
CREATE VIEW vw_dashboard_risco_credito AS
SELECT 
    idade,
    
    -- Criação de Faixas Etárias para facilitar filtros no Power BI
    CASE 
        WHEN idade < 25 THEN '18-24 anos'
        WHEN idade BETWEEN 25 AND 35 THEN '25-35 anos'
        WHEN idade BETWEEN 36 AND 50 THEN '36-50 anos'
        ELSE 'Mais de 50 anos'
    END AS faixa_etaria,

    renda_anual,
    (renda_anual / 12) AS renda_mensal_estimada,

    -- Criação de Faixas de Renda Mensal (Exemplo baseado no mercado brasileiro)
    CASE 
        WHEN (renda_anual / 12) <= 3000 THEN 'Até R$ 3.000'
        WHEN (renda_anual / 12) BETWEEN 3001 AND 7000 THEN 'R$ 3.001 a R$ 7.000'
        WHEN (renda_anual / 12) BETWEEN 7001 AND 15000 THEN 'R$ 7.001 a R$ 15.000'
        ELSE 'Acima de R$ 15.000'
    END AS faixa_renda_mensal,
    CASE
        WHEN (renda_anual / 12) <= 3000 THEN 1
        WHEN (renda_anual / 12) <= 7000 THEN 2
        WHEN (renda_anual / 12) <= 15000 THEN 3
        ELSE 4
    END AS ordem_faixa_renda,
    tipo_moradia,
    tempo_trabalho,
    motivo_emprestimo,
    pontuacao_credito,
    valor_emprestimo,
    taxa_juros,
    
    -- Transformando o binário 0 e 1 em texto claro para legenda de gráficos
    inadimplente AS codigo_inadimplente, -- Mantém o número para cálculos de taxa (Sum/Count)
    CASE 
        WHEN inadimplente = 1 THEN 'Inadimplente'
        ELSE 'Em Dia'
    END AS status_pagamento,

    percentual_renda_parcela,
    
    CASE 
        WHEN historico_inadimplencia = 1 THEN 'Possui Histórico Negativo'
        ELSE 'Histórico Limpo'
    END AS historico_restricao,
    
    tempo_historico_credito

FROM cooperados_credito;
go



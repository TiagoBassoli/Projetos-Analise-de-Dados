-- (Primeiro selecionei toda a tabela, para ver o que cada coluna possui, depois fui responder perguntas de negócio)
select * from netflix_user_behavior_dataset

-- 1) Taxa média de churn por tipo de assinatura
SELECT
subscription_type,
  CAST(100.0 * SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END) 
  / COUNT(user_id) as decimal(5,2)) AS taxa_churn_pct
FROM netflix_user_behavior_dataset
GROUP BY subscription_type;

-- 2) Quais faixas de idade têm maior churn e quais têm menor?
--(Antes, vamos ver a distribuição das idades e a taxa por elas)
select 
	age, -- [Coluna de idade]
	count(*) as total, -- [Total de usuários com essa idade]
	cast(100.0 * sum(case when churned = 'Yes' then 1 else 0 end) 
	/ count(*) as decimal(5,2)) as taxa_churn_pct
from netflix_user_behavior_dataset
group by age 
order by age

-- Agora sim, vamos responder a pergunta de negócio:
select 
	CASE	
		WHEN age BETWEEN 18 AND 24 THEN '18-24'
		WHEN age BETWEEN 25 AND 29 THEN '25-29'
		WHEN age BETWEEN 30 AND 34 THEN '30-34'
		WHEN age BETWEEN 35 AND 39 THEN '35-39'
		WHEN age BETWEEN 40 AND 44 THEN '40-44'
		WHEN age BETWEEN 45 AND 49 THEN '45-49'
		ELSE '50+'
	END as faixa_etaria,
	count(*) as total_usuarios,
	SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END) as Total_churn,
	CAST(100.0 * sum(case when churned = 'Yes' then 1 else 0 end)
  / COUNT(user_id) as decimal(5,2)) AS taxa_churn_pct
FROM netflix_user_behavior_dataset
group by 
	CASE	
		WHEN age BETWEEN 18 AND 24 THEN '18-24'
		WHEN age BETWEEN 25 AND 29 THEN '25-29'
		WHEN age BETWEEN 30 AND 34 THEN '30-34'
		WHEN age BETWEEN 35 AND 39 THEN '35-39'
		WHEN age BETWEEN 40 AND 44 THEN '40-44'
		WHEN age BETWEEN 45 AND 49 THEN '45-49'
		ELSE '50+'
	END
order by taxa_churn_pct desc;

-- 3) Como o tempo médio de exibição varia por gênero favorito e país?
select country,
favorite_genre,
round(avg(cast(avg_watch_time_minutes as float)),2) as media_tempo_minutos  -- Estava formatado em texto, converti para número
from netflix_user_behavior_dataset
group by country, favorite_genre
order by country, favorite_genre

-- 4) Assinantes de plano Premium ou “maior custo” assistem mais? 
select subscription_type,
	round(avg(cast(avg_watch_time_minutes as float)),2) as media_tempo_total 
from netflix_user_behavior_dataset
group by subscription_type
order by media_tempo_total desc

-- 5) Existe relação entre dias desde o último login e churn/nível de uso? 
select churned, round(avg(cast(days_since_last_login as float)),2) as media_dias_sem_login,
round(avg(cast(watch_sessions_per_week as float)),2) as media_sessoes_semanais,
count(*) as total_usuarios
from netflix_user_behavior_dataset
group by churned

-- 6) Como o tempo total de assinatura e o tipo de plano influenciam a taxa de churn? 
-- Usuários mais antigos com planos mais caros têm menor propensão a cancelar?
select 
	subscription_type, churned, count(*) as total_usuarios, round(avg(cast(account_age_months as float)),2) as media_tempo_assinatura
from netflix_user_behavior_dataset
group by subscription_type, churned
order by subscription_type, churned

-- 7) Quais dispositivos têm mais usuários e qual dispositivo mostra maior engajamento médio (watch time)?
select primary_device,
	count(*) as Total_usuarios, 
	round(avg(cast(avg_watch_time_minutes as float)),2) as Engajamento_medio_minutos
from netflix_user_behavior_dataset
group by primary_device
order by Total_usuarios desc

-- 8) Existe diferença de engajamento por método de pagamento (payment_method) e por tipo de assinatura?
select payment_method,
	subscription_type, 
	round(avg(cast(avg_watch_time_minutes as float)),2) as Tempo_medio_minutos 
from netflix_user_behavior_dataset
group by subscription_type, payment_method
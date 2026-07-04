create view dTipo_de_Inscricao as 
select distinct(subscription_type) from netflix_user_behavior_dataset

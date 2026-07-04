select
	case 
		when age between 18 and 24 then '18-24'
		when age between 25 and 29 then '25-29'
		when age between 30 and 34 then '30-34'
		when age between 35 and 39 then '35-39'
		when age between 40 and 44 then '40-44'
		when age between 45 and 49 then '45-49'
		else '+50'
	end as Faixa_Etaria
into dbo.faixa_etaria --criei uma tabela pra ficar armazenada no servidor e importar pro Power BI
from netflix_user_behavior_dataset
group by
	case 
		when age between 18 and 24 then '18-24'
		when age between 25 and 29 then '25-29'
		when age between 30 and 34 then '30-34'
		when age between 35 and 39 then '35-39'
		when age between 40 and 44 then '40-44'
		when age between 45 and 49 then '45-49'
		else '+50'
	end
order by min(age)
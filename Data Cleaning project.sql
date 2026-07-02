select * 
from layoffs ; 

-- 1. Remove Duplicates 
-- 2. Standardized the data 
-- 3. Null values or Blank values 
-- 4. Remove any columns 

create table layoff_staging 
like layoffs ;

select * 
from layoff_staging ;

insert layoff_staging 
select * from layoffs ;

select * from layoff_staging ;

-- REMOVING DUPLICATES 

SELECT * ,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoff_staging ;

with duplicate_cte as 
(
SELECT * ,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoff_staging 
)
select * 
from duplicate_cte 
where row_num > 1 ;


CREATE TABLE `layoff_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into layoff_staging2 
SELECT * ,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoff_staging ;

select * 
from layoff_staging2 ;

select * from layoff_staging2 
where row_num > 1;

delete
from layoff_staging2
where row_num > 1;

-- STANDARDIZING DATA 
-- standardizing your data means finding issues in your data and then fixing it 

select company 
from layoff_staging2 ; 

select distinct (trim(company))
from layoff_staging2 ;

select company , (trim(company)) 
from layoff_staging2;

update layoff_staging2
set company = trim(company) ;

select distinct industry
from layoff_staging2
order by 1;                   

select * from layoff_staging2
where industry LIKE '%Crypto%';

update layoff_staging2 
set industry = 'Crypto'
where industry like '%Crypto%';

select distinct location 
from layoff_staging2
order by 1 ;

select distinct country 
from layoff_staging2
order by 1 ;
select * from layoff_staging2 
where country like '%United States%';

update layoff_staging2
set country = 'United States'
where country like '%United States%' ;
-- or--
select distinct country ,trim(trailing '.' from country )
from layoff_staging2 
order by 1 ; 
update layoff_staging2
set country =trim(trailing '.' from country )
where country like '%United States%' ;

select `date`,
str_to_date (`date`, '%m/%d/%Y')
from layoff_staging2 ;
update layoff_staging2
set `date` = str_to_date (`date`, '%m/%d/%Y');

select `date` from layoff_staging2 ;

alter table layoff_staging2
modify column `date` DATE ;

select * 
from layoff_staging2 ;

-- WORKING WITH NULL OR BLANK VALUES 

select * from layoff_staging2
where total_laid_off is NULL
and percentage_laid_off is null;

select * from layoff_staging2
where industry is null
or industry = '' ;
select * from layoff_staging2
where company ='Airbnb' ;

update layoff_staging2
set industry = null 
where industry = '';

select *
from layoff_staging2 t1
join layoff_staging2 t2
		on t1.company = t2.company 
where (t1.industry is null or t1.industry = '')
and t2.industry is not null ;

select t1.industry , t2.industry 
from layoff_staging2 t1
join layoff_staging2 t2
		on t1.company = t2.company 
where (t1.industry is null or t1.industry = '')
and t2.industry is not null ;

update layoff_staging2 t1
join layoff_staging2 t2
		on t1.company = t2.company 
set t1.industry = t2.industry 
where t1.industry is null 
and t2.industry is not null;

select * from layoff_staging2
where total_laid_off is NULL
and percentage_laid_off is null;


CREATE TABLE `layoff_staging3` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` date DEFAULT NULL,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into layoff_staging3
select * from layoff_staging2 ;

select * from layoff_staging3 ;

select * from layoff_staging3
where total_laid_off is NULL
and percentage_laid_off is null;

delete 
from layoff_staging3
where total_laid_off is NULL
and percentage_laid_off is null;

alter table layoff_staging3 
drop column row_num;
select * from layoff_staging3 ;
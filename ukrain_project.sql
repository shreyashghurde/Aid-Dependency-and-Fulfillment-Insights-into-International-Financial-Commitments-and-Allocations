

select *
from [project ].dbo.['Financial Commitments$']

select *
from [project ].dbo.['Financial Allocations$']


--CHANGE THE VALUES THOSE ARE NULL
UPDATE [project ].dbo.['Financial Allocations$']
SET [Financial allocations($ billion)] = 0
WHERE [Financial allocations($ billion)] IS NULL;

SELECT 
    Country,
    SUM([Financial allocations($ billion)]) AS Total_Financial_Allocations,
	 SUM([Humanitarian allocations($ billion)]) AS Total_humanatarian_Allocations,
	  SUM([Military allocations($ billion)]) AS Total_military_Allocations
FROM 
    [project ].dbo.['Financial Allocations$']
GROUP BY 
    Country
ORDER BY 
    Country;
--UNION

SELECT 
    Country,
    SUM([Financial commitments($ billion)]) AS Total_Financial_Allocations,
	 SUM([Humanitarian commitments($ billion)]) AS Total_humanatarian_Allocations,
	  SUM([Military commitments($ billion)]) AS Total_military_Allocations
FROM 
   [project ].dbo.['Financial Commitments$']
GROUP BY 
    Country
ORDER BY 
    Country;

--difference  top 5 countries which commited highest VS top 5 countries which allocate highest
--1> military aid
select  TOP 5 al.Country, al.[Military allocations($ billion)],co.Country, co.[Military commitments($ billion)]
from [project ].dbo.['Financial Commitments$'] as co
join [project ].dbo.['Financial Allocations$'] as al
on co.Country=al.Country
order by al.[Military allocations($ billion)] desc

--2>financial aid
select  TOP 5 al.Country, al.[Financial allocations($ billion)],co.Country, co.[Financial commitments($ billion)]
from [project ].dbo.['Financial Commitments$'] as co
join [project ].dbo.['Financial Allocations$'] as al
on co.Country=al.Country
order by co.[Financial commitments($ billion)] desc 

--3>humanatirian aid
select  TOP 5 al.Country, al.[Humanitarian allocations($ billion)],co.Country, co.[Humanitarian commitments($ billion)]
from [project ].dbo.['Financial Commitments$'] as co
join [project ].dbo.['Financial Allocations$'] as al
on co.Country=al.Country
order by co.[Humanitarian commitments($ billion)] desc 
 
--  EU vs. Non-EU Contributions

select  co.[EU member],avg(co.[Financial commitments($ billion)]),avg(al.[Financial allocations($ billion)])
from [project ].dbo.['Financial Commitments$'] as co
join [project ].dbo.['Financial Allocations$'] as al
on co.Country=al.Country
group by co.[EU member]


--REGIONAL ANALYSIS

-- CREATE the CountryRegions table 
CREATE TABLE CountryRegions (
    Country VARCHAR(255),
    Region VARCHAR(255)
);

-- Insert data into CountryRegions table
INSERT INTO CountryRegions (Country, Region) VALUES
-- Europe (EU members)
('Austria', 'Europe'),
('Belgium', 'Europe'),
('Bulgaria', 'Europe'),
('Croatia', 'Europe'),
('Cyprus', 'Europe'),
('Czech Republic', 'Europe'),
('Denmark', 'Europe'),
('Estonia', 'Europe'),
('Finland', 'Europe'),
('France', 'Europe'),
('Germany', 'Europe'),
('Greece', 'Europe'),
('Hungary', 'Europe'),
('Ireland', 'Europe'),
('Italy', 'Europe'),
('Latvia', 'Europe'),
('Lithuania', 'Europe'),
('Luxembourg', 'Europe'),
('Malta', 'Europe'),
('Netherlands', 'Europe'),
('Poland', 'Europe'),
('Portugal', 'Europe'),
('Romania', 'Europe'),
('Slovakia', 'Europe'),
('Slovenia', 'Europe'),
('Spain', 'Europe'),
('Sweden', 'Europe'),
('United Kingdom', 'Europe'),
-- Europe (Non-EU)
('Iceland', 'Europe (Non-EU)'),
('Norway', 'Europe (Non-EU)'),
('Switzerland', 'Europe (Non-EU)'),
-- North America
('Canada', 'North America'),
('United States', 'North America'),
-- Asia
('China', 'Asia'),
('India', 'Asia'),
('Japan', 'Asia'),
('South Korea', 'Asia'),
('Taiwan', 'Asia'),
('Turkey', 'Asia'),
-- Oceania
('Australia', 'Oceania'),
('New Zealand', 'Oceania');



SELECT 
    cr.Region,
    SUM(co.[Financial commitments($ billion)]) AS Total_Financial_Commitments,
    SUM(al.[Financial allocations($ billion)]) AS Total_Financial_Allocations,
    SUM(co.[Humanitarian commitments($ billion)]) AS Total_Humanitarian_Commitments,
    SUM(al.[Humanitarian allocations($ billion)]) AS Total_Humanitarian_Allocations,
    SUM(co.[Military commitments($ billion)]) AS Total_Military_Commitments,
    SUM(al.[Military allocations($ billion)]) AS Total_Military_Allocations
FROM 
    [project ].dbo.['Financial Commitments$'] AS co
JOIN 
    [project ].dbo.['Financial Allocations$'] AS al
ON 
    co.Country = al.Country
JOIN 
    CountryRegions AS cr
ON 
    co.Country = cr.Country
GROUP BY 
    cr.Region
ORDER BY 
    cr.Region;


--total bilateral comiitment according to region vs total bilateral allocation according to region

SELECT 
    cr.Region, 
    SUM(fc.[Total bilateral commitments($ billion)]) AS Total_Bilateral_Commitments,
    SUM(fa.[Total bilateral allocations($ billion)]) AS Total_Bilateral_Allocations
FROM 
    [project ].dbo.['Financial Commitments$'] AS fc
JOIN 
    CountryRegions AS cr
ON 
    fc.Country = cr.Country
JOIN 
    [project ].dbo.['Financial Allocations$'] AS fa
ON 
    fc.Country = fa.Country
GROUP BY 
    cr.Region
ORDER BY 
    Total_Bilateral_Commitments DESC,
    Total_Bilateral_Allocations DESC;

--Determine Which Sector Receives the Most Funding Overall(COMMITED VS ALLOCATED)

	SELECT 
    'Financial' AS Sector,
    SUM(fc.[Financial commitments($ billion)]) AS Total_Commitments,
    SUM(fa.[Financial allocations($ billion)]) AS Total_Allocations
FROM 
 [project ].dbo.['Financial Commitments$'] AS fc
JOIN 
   [project ].dbo.['Financial Allocations$'] AS fa
ON 
    fc.Country = fa.Country

UNION ALL

SELECT 
    'Humanitarian' AS Sector,
    SUM(fc.[Humanitarian commitments($ billion)]) AS Total_Commitments,
    SUM(fa.[Humanitarian allocations($ billion)]) AS Total_Allocations
FROM 
[project ].dbo.['Financial Commitments$'] AS fc
JOIN 
    [project ].dbo.['Financial Allocations$'] AS fa
ON 
    fc.Country = fa.Country

UNION ALL

SELECT 
    'Military' AS Sector,
    SUM(fc.[Military commitments($ billion)]) AS Total_Commitments,
    SUM(fa.[Military allocations($ billion)]) AS Total_Allocations
FROM 
  [project ].dbo.['Financial Commitments$'] AS fc
JOIN 
    [project ].dbo.['Financial Allocations$'] AS fa
ON 
    fc.Country = fa.Country

ORDER BY 
    Total_Commitments DESC;


--FULFILLMENT RATE OF COUNTRIES (IT GIVES HOW MUCH THEY COMMITED AND HOW MUCH THEY ALLOTD)


	SELECT 
    COALESCE(fc.Country, fa.Country) AS Country,
    COALESCE(fc.Total_Commitments, 0) AS Total_Commitments,
    COALESCE(fa.Total_Allocations, 0) AS Total_Allocations,
    CASE
        WHEN COALESCE(fc.Total_Commitments, 0) > 0 THEN (COALESCE(fa.Total_Allocations, 0) / COALESCE(fc.Total_Commitments, 0)) * 100
        ELSE 0
    END AS Fulfillment_Rate
FROM 
    (SELECT 
         Country,
         SUM([Financial commitments($ billion)]) AS Total_Commitments
     FROM 
           [project ].dbo.['Financial Commitments$']
     GROUP BY 
         Country) AS fc
FULL OUTER JOIN 
    (SELECT 
         Country,
         SUM([Financial allocations($ billion)]) + SUM([Humanitarian allocations($ billion)]) + SUM([Military allocations($ billion)]) AS Total_Allocations
     FROM 
           [project ].dbo.['Financial Allocations$']
     GROUP BY 
         Country) AS fa
ON 
    fc.Country = fa.Country
ORDER BY 
    Fulfillment_Rate DESC;





























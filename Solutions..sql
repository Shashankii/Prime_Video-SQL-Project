-- CFREATING TABLE PrimeVideo
CREATE TABLE PrimeVideo(

  show_id VARCHAR(5),
  type  VARCHAR(10),
  title  VARCHAR (150),
  director  VARCHAR(208),
  casts  VARCHAR(1000),
  country VARCHAR(150),
  date_added VARCHAR (50),
  release_year INT,
  rating VARCHAR(10),
  duration VARCHAR(15),
  listed_in VARCHAR(100),
  description VARCHAR(250)
);


SELECT * FROM PrimeVideo;

-- 15 Business Problems

-- 1. Count the number of movies vs TV shows


SELECT type, 
COUNT(*) as total_content
FROM PrimeVideo
GROUP BY type;

-- 2. Find the most common rating for movies and TV shows
SELECT * FROM 
(
  SELECT 'Movie' AS type, rating, COUNT(*) AS total
  FROM PrimeVideo
  WHERE type = 'Movie'
  GROUP BY rating
  ORDER BY total DESC
  LIMIT 1
) 
AS movie_result

UNION ALL

SELECT * FROM 
(
  SELECT 'TV Show' AS type, rating, COUNT(*) AS total
  FROM PrimeVideo
  WHERE type = 'TV Show'
  GROUP BY rating
  ORDER BY total DESC
  LIMIT 1
) 
AS tv_result;


-- 3. List all the movies released in a specific year (eg 2020)

SELECT * FROM PrimeVideo
WHERE type = 'Movie' and release_year = '2020';

-- 4. Find the top 5 countries with the most content on Prime Video

SELECT  
     UNNEST (STRING_TO_ARRAY(country, ',')) as new_country,
	 
             COUNT(show_id) as total_content
             FROM PrimeVideo
             GROUP BY 1
			 ORDER BY 2 DESC
			 LIMIT 5;
			 
-- 5. Identify the longest movie

SELECT * FROM PrimeVideo

WHERE type = 'Movie' 
and 
duration = (SELECT MAX(duration) FROM PrimeVideo)

-- 6 Find all the content added in the last 5 years

SELECT * FROM PrimeVideo
WHERE 
    TO_DATE(date_added, 'Month DD,YYYY') >= CURRENT_DATE - INTERVAL '5 years'  

--7.How many movies have been directed by "Rajiv Chilaka"? 

SELECT * FROM PrimeVideo
WHERE director ILIKE   '%Rajiv Chilaka%'

--8. List all tv shows with more than 5 seasons
SELECT *
FROM PrimeVideo
WHERE type = 'TV Show'
  AND CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) > 5;

  -- 9. Count the number of content items in each genre
  
SELECT show_id, listed_in

UNNEST(STRING_TO_ARRAY(listed_in, ',' ))
-- CFREATING TABLE PrimeVideo
CREATE TABLE PrimeVideo(

  show_id VARCHAR(5),
  type  VARCHAR(10),
  title  VARCHAR (150),
  director  VARCHAR(208),
  casts  VARCHAR(1000),
  country VARCHAR(150),
  date_added VARCHAR (50),
  release_year INT,
  rating VARCHAR(10),
  duration VARCHAR(15),
  listed_in VARCHAR(100),
  description VARCHAR(250)
);


SELECT * FROM PrimeVideo;

-- 15 Business Problems

-- 1. Count the number of movies vs TV shows


SELECT type, 
COUNT(*) as total_content
FROM PrimeVideo
GROUP BY type;

-- 2. Find the most common rating for movies and TV shows

SELECT type,
       rating, 
	   
	 FROM
     (
	   
	   SELECT type, 
	   rating, 
	   COUNT(*), 
       RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
	   FROM PrimeVideo
	   GROUP BY type , rating
	   )  as t1

	   WHERE ranking = 1

 -- 3. List all the movies released in a specific year (eg 2020)

SELECT * FROM PrimeVideo
WHERE type = 'Movie' and release_year = '2020';

-- 4. Find the top 5 countries with the most content on Prime Video

SELECT  
     UNNEST (STRING_TO_ARRAY(country, ',')) as new_country,
	 
             COUNT(show_id) as total_content
             FROM PrimeVideo
             GROUP BY 1
			 ORDER BY 2 DESC
			 LIMIT 5;
			 
-- 5. Identify the longest movie

SELECT * FROM PrimeVideo

WHERE type = 'Movie' 
and 
duration = (SELECT MAX(duration) FROM PrimeVideo)

-- 6 Find all the content added in the last 5 years

SELECT * FROM PrimeVideo
WHERE 
    TO_DATE(date_added, 'Month DD,YYYY') >= CURRENT_DATE - INTERVAL '5 years'  

--7.How many movies have been directed by "Rajiv Chilaka"? 

SELECT * FROM PrimeVideo
WHERE director ILIKE   '%Rajiv Chilaka%'

--8. List all tv shows with more than 5 seasons
SELECT *
FROM PrimeVideo
WHERE type = 'TV Show'
  AND CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) > 5;

  -- 9. Count the number of content items in each genre
  
SELECT   
      UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	  COUNT(show_id) AS total_content
      FROM PrimeVideo  
	  GROUP BY genre

--10 Find each year and the average numbers of content release in India on Prime
-- return top 5 year with highest average content release

--total content 333/972

SELECT 
      EXTRACT(YEAR FROM TO_DATE(date_added, 'Month, DD, YYYY')) as year,
      COUNT(*)as yearly_report,
	  ROUND(
      COUNT(*)::numeric/(SELECT COUNT(*) FROM PrimeVideo WHERE country = 'India')::numeric * 100
	  ,2)as avg_content_per_year
      FROM PrimeVideo
      WHERE country = 'India'
      GROUP BY 1
	  
-- 11. List all the movies that are documentaries

SELECT * FROM PrimeVideo
WHERE
listed_in LIKE 'Documentaries%'

-- 12 Find all content without a Director

SELECT * FROM PrimeVideo
WHERE director IS NULL

-- 13 Find how many movies actor 'Salman Khan'appeared in the last 10 years

SELECT * FROM PrimeVideo
WHERE 
casts LIKE '%Salman Khan%'
AND 
release_year >= 2015

-- 14 Find top 10 actors who have appeared in the highest number of movies produced in India
SELECT 
UNNEST(STRING_TO_ARRAY(casts, ',')) as actors,
COUNT(*) as total_content
FROM PrimeVideo
WHERE country ILIKE '%India'
GROUP BY actors
ORDER BY total_content DESC
LIMIT 10

--15 Categorize the content based on the presence of the keywords 'kill' and 'violence' 
--in the description field. Label content containing these keywords as 'Bad' 
--and all other content as 'Good'. Count how many items fall into each category.


SELECT
	  CASE
	  WHEN 
	       description ILIKE '%kill%' 
	       OR
	       description ILIKE '%violence%' THEN 'Bad_content'
	       ELSE 'Good_content'
	       END AS category,
		   
COUNT(*) AS total_items
FROM PrimeVideo
GROUP BY category;
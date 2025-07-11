# 📊 SQL Analysis on PrimeVideo Dataset

![Prime Video Logo](https://github.com/Shashankii/Prime_Video-SQL-Project/blob/main/logo..jpeg)

📘 ## Overview

This project analyzes PrimeVideo content data using SQL to uncover trends in content type, ratings, genres, countries, and actors. It answers real-world business questions through structured queries using PostgreSQL.

🎯 Objectives
1. Analyze the distribution of content types (Movies vs TV Shows).
2. Identify the most common ratings for Movies and TV Shows.
3. List and analyze content based on release years, countries, and durations.
4. Explore and categorize content based on specific criteria and keywords.

📁 Dataset

The data for this project is sourced from Kaggle dataset:
Dataset Link: [Movies Dataset](https://github.com/Shashankii/Prime_Video-SQL-Project/blob/main/Prime%20Video%20titles.csv)

Columns include:

show_id
type
title
director
cast
country
date_added
release_year
rating
duration
listed_in
description

🎯 Key SQL Concepts Used

GROUP BY, ORDER BY, LIMIT
UNION ALL
CASE WHEN for conditional logic
ILIKE, TRIM(), SPLIT_PART(), UNNEST() for string and array manipulation
Subqueries and Derived Tables

📌## 🧾 Schema

```sql
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


📚 Business Problems and SQL Solutions

1. Count the Number of Movies vs TV Shows

SELECT type, 
       COUNT(*) AS total_content
FROM PrimeVideo
GROUP BY type;

2. Find the Most Common Rating for Movies and TV Shows

SELECT * FROM 
(
  SELECT 'Movie' AS type, rating, COUNT(*) AS total
  FROM PrimeVideo
  WHERE type = 'Movie'
  GROUP BY rating
  ORDER BY total DESC
  LIMIT 1
) AS movie_result

UNION ALL

SELECT * FROM 
(
  SELECT 'TV Show' AS type, rating, COUNT(*) AS total
  FROM PrimeVideo
  WHERE type = 'TV Show'
  GROUP BY rating
  ORDER BY total DESC
  LIMIT 1
) AS tv_result;


3. List all Movies Released in a Specific Year (e.g., 2020)

SELECT * FROM PrimeVideo
WHERE type = 'Movie' AND release_year = 2020;

4. Find the Top 5 Countries with the Most Content

SELECT UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country,
       COUNT(show_id) AS total_content
FROM PrimeVideo
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

5. Identify the Longest Movie

SELECT * FROM PrimeVideo
WHERE type = 'Movie'
  AND duration = (SELECT MAX(duration) FROM PrimeVideo);

6. Find All Content Added in the Last 5 Years

SELECT * FROM PrimeVideo
WHERE TO_DATE(date_added, 'Month DD,YYYY') >= CURRENT_DATE 

7. How Many Movies Have Been Directed by "Rajiv Chilaka"?

SELECT * FROM PrimeVideo
WHERE director ILIKE '%Rajiv Chilaka%';

8. List All TV Shows with More Than 5 Seasons

SELECT *
FROM PrimeVideo
WHERE type = 'TV Show'
  AND CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) > 5;

9. Count the Number of Content Items in Each Genre

SELECT UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
       COUNT(show_id) AS total_content
FROM PrimeVideo
GROUP BY genre;

10. Top 5 Years with Highest Average Content Release in India

SELECT EXTRACT(YEAR FROM TO_DATE(date_added, 'Month, DD, YYYY')) AS year,
       COUNT(*) AS yearly_report,
       ROUND(
         COUNT(*)::numeric / (SELECT COUNT(*) FROM PrimeVideo WHERE country = 'India')::numeric * 100, 2
       ) AS avg_content_per_year
FROM PrimeVideo
WHERE country = 'India'
GROUP BY 1
ORDER BY avg_content_per_year DESC
LIMIT 5;

11. List All Movies That Are Documentaries

SELECT * FROM PrimeVideo
WHERE listed_in LIKE 'Documentaries%';

12. Find All Content Without a Director

SELECT * FROM PrimeVideo
WHERE director IS NULL;

13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

SELECT * FROM PrimeVideo
WHERE casts ILIKE '%Salman Khan%'
  AND release_year >= 2015;

14. Top 10 Actors in Movies Produced in India

SELECT UNNEST(STRING_TO_ARRAY(casts, ',')) AS actors,
       COUNT(*) AS total_content
FROM PrimeVideo
WHERE country ILIKE '%India%'
GROUP BY actors
ORDER BY total_content DESC
LIMIT 10;

15. Categorize Content as 'Good' or 'Bad' Based on Keywords

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


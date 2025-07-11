# 📊 SQL Analysis on PrimeVideo Dataset

![Prime Video Logo](https://github.com/Shashankii/Prime_Video-SQL-Project/blob/main/logo..jpeg)

📘 Overview
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


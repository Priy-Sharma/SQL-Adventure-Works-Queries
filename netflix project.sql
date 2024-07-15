 create database netflix;
 use netflix;

 select * from best_shows;
 --  SQL statement to find the show name that has maximum number of seasons from 'best_show' table using subquery
 
select title, NUMBER_OF_SEASONS, main_genre 
from best_shows 
where NUMBER_OF_SEASONS = (select max(NUMBER_OF_SEASONS) from best_shows);


/* selects counts of the movies from the best_movies table where movies release year and score 
 is same as the best_movies_du's release year and score  */
 
select best_movies.TITLE as matched_movies from best_movies
 inner join best_movies_du on best_movies.RELEASE_YEAR = best_movies_du.RELEASE_YEAR 
 and best_movies.SCORE = best_movies_du.SCORE;

 
 /* Below code retrives the record count from the three tables namely best_movies, best_movies_du, and matched_movies
  1.  first query retrives the count for the distinct tiles from best_movies
  2. second query retrives the count for the distinct tiles from best_movies_du
  3. matched_movie is the insection of the tables best_movies and best_movies_du on  certain conditions */
  
 SELECT 'best_movies' AS table_name, COUNT(distinct title) AS row_count
FROM best_movies
UNION ALL
SELECT 'best_movies_du' AS table_name, COUNT(distinct title) AS row_count
FROM best_movies_du
UNION ALL
SELECT 'matched_movies' AS table_name, COUNT(*) AS row_count
FROM (
    SELECT distinct best_movies.TITLE
    FROM best_movies
    INNER JOIN best_movies_du ON best_movies.RELEASE_YEAR = best_movies_du.RELEASE_YEAR 
                                AND best_movies.SCORE = best_movies_du.SCORE
) AS matched_movies;


-- rename the column of the movies_shows
alter table movies_shows
rename column  ï»¿name to name;

select * from movies_shows;

--  selects name where 3rd letter is a from the left of the string
select * from movies_shows where name like '__a%';

-- row selection
select * from best_movies;
desc best_movies;
select * from best_movies_du;
select * from best_shows;
select * from movies_shows;
 
 /* best_movies table does not contain the column for the duration of the movie, 
 so that this is retrived from the best_movies_du table */
 
select distinct *, best_movies_du.DURATION as duration from best_movies
inner join best_movies_du on best_movies.title = best_movies_du.TITLE ;

-- updates the column name 'director' and 'creator' of the table movies_shows if there is blank space in that field
select * from movies_shows;

update movies_shows set director = 'not_known',  creator = 'not_known' where  director= '' or  creator = '';


-- select the top genre name in which maximum movies are made
select MAIN_GENRE, count(*) as count from best_movies_du group by MAIN_GENRE order by count desc limit 2 ;

/* 1. subquery select the top genre from the best_movies_du with alias name top_genre
2. outer query selects the title of the movie from the best_movies whose main_genre mathches with the top_genre */


select title, MAIN_GENRE
from best_movies 
where main_genre in  (
select MAIN_GENRE from 
( select MAIN_GENRE, count(*) as count 
from best_movies_du 
group by MAIN_GENRE 
order by count desc 
 limit 2 )  
 as top_genre);
 
-- creation of table best_1
CREATE TABLE best_1 (
    sr_no INT,
    title_of_movie VARCHAR(255),
    score DOUBLE
);

alter table best_1 modify column title_of_movie varchar(200) primary key;
desc best_1;

-- recors insertio in the table best_1
INSERT INTO best_1 (sr_no, title_of_movie, score) VALUES
(1, 'The Shawshank Redemption', 9.3),
(2, 'The Godfather', 9.2),
(3, 'The Dark Knight', 9.0),
(4, 'Pulp Fiction', 8.9);


-- table create
create table project_table (
sr_no  int primary key auto_increment,
movie_title varchar(20),
foreign key (movie_title) references best_1(title_of_movie),
movie_score double);


-- Below sql statement will throw the error, because foreign key constraint is applicable on movie_title
insert into project_table ( movie_title, movie_score) 
values ('The main', 4.6);

-- correct statement is
insert into project_table ( movie_title, movie_score) 
values ('Pulp Fiction', 4.6);

delete from project_table where movie_title = 'Pulp Fiction';

delete from project_table;

select now();



 


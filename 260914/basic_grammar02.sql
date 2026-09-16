USE sakila;

SELECT
	rating,
    COUNT(*) rating_count,
    AVG(rental_rate) avg_rental_rate
FROM film
GROUP BY rating
ORDER BY avg_rental_rate DESC; # default ASC DESC

SELECT
	rating,
    COUNT(*) rating_count,
    AVG(rental_rate) avg_rental_rate
FROM film
WHERE release_year = 2006 OR release_year = 2007
GROUP BY rating
HAVING rating_count >= 200
ORDER BY avg_rental_rate DESC;
# GROUP화를 하고자 하는 대상존재 : 해당 그룹화 대상의 조건이 직접 x, where
# 표기순서 : S -> F -> W -> G -> H -> O
# 실행순서 : F .... S O
# GROUP화 되어있는 대상의 조건을 설정 : HAVING



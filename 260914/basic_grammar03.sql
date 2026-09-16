# DB => Table > RDBMS = 관계형 데이터베이스 관리 시스템
# MySQL 프로그램의 SQL 문법
# 관계

# 서브쿼리 : 1개의 SELECT FROM 조회구문 안에 또 다른 SELECT FROM 조회구문 사용! 값을 조회
# JOIN :
# 서브쿼리 구문은 1개의 쿼리문 안에서 횟수 제약없이 사용 가능
# 서브쿼리가 많아질수록 구문을 이해하는데 있어서 가독성 매우 안좋아짐
# 문제점 개선
# INNER JOIN : 서로 다른 테이블간 공통 요소만 살려두는 문법
# OUTER JOIN : 먼저 사용 및 선택된 테이블 요소를 중심으로 살려두는 문법
# LEFT OUTER JOIN
# RIGHT OUTER JOIN

SHOW TABLES;

SELECT * FROM film_category LIMIT 10;
# film_id, category_id, last_update

SELECT * FROM category LIMIT 10;
# category_id, name, last_update

SELECT category_id, COUNT(*)
FROM film_category
WHERE film_category.category_id > (
		SELECT category.category_id
        FROM category
        WHERE category.name = "Comedy"
	)
GROUP BY film_category.category_id;

# 현업 개발자 : 서브쿼리를 더 선호
# 현업 데이터사이언티스트 : JOIN 선호

SELECT * FROM customer LIMIT 10;
# customer_id, store_id, first_name, last_name, email, address_id, active, create_date, last_update

SELECT * FROM payment LIMIT 10;
# customer_id

SELECT first_name, last_name
FROM customer
WHERE customer_id IN (
	SELECT customer_id
    FROM payment
    WHERE amount > (
		SELECT AVG(amount)
        FROM payment
    )
);

SELECT
	DISTINCT C.first_name, C.last_name
FROM customer C
JOIN payment P ON C.customer_id = P.customer_id
JOIN (
	SELECT AVG(amount) avg_amount
    FROM payment
) A ON P.amount > A.avg_amount;

# Sakila DB > 가장 많은 결제 (횟수) = 집계 를 한 고객 찾기!!
# 서브쿼리로 해결할 것!! //

# 1-출력하고자 하는 값 : 풀네임 (성, 이름) -> customer
# 2-출력하고자 하는 값 : 결제가 일어났을 때의 정보 -> payment

SELECT * FROM payment LIMIT 10;

SHOW TABLES;

SELECT
	first_name, last_name
FROM customer
WHERE customer_id IN (
	SELECT customer_id
    FROM (
		SELECT
			customer_id,
			COUNT(*) payment_count
		FROM payment
		GROUP BY customer_id
    ) AS payment_counts
	ORDER BY payment_count DESC
    LIMIT 10
);

SELECT P.customer_id, P.amount, P.payment_date
FROM payment P
WHERE P.amount > (
	SELECT AVG(amount)
    FROM payment
    WHERE customer_id = P.customer_id
);
# SELECT FROM > SELECT FROM (상관서브쿼리)
# 서브쿼리가 자체적으로 값을 도출하지 못하고, 밖에 있는 컬럼을 참조해서 도출

# film 테이블에서 평균영화길이보다 긴 영화들의 제목을 조회!!
SELECT title FROM film
WHERE length > (
	SELECT
		AVG(length)
    FROM film
);

# sakila DB, 각 고객들이 자신이 대여한 영화들 존재
# 그동안 대여했었던 영화들의 평균 길이보다 긴 영화들의 제목만 취합해서 출력!
# first_name, last_name, film_title
# customer
# 
# film

SELECT * FROM customer LIMIT 10;
# customer_id, first_name, last_name

SELECT * FROM rental LIMIT 10;
# film_id, title, length

SELECT
	C.first_name, C.last_name, F.title
FROM customer C
JOIN rental R ON R.customer_id = C.customer_id
JOIN inventory I ON I.inventory_id = R.inventory_id
JOIN film F ON F.film_id = I.film_id
WHERE F.length > (
	SELECT AVG(FIL.length)
    FROM film FIL
    JOIN inventory INV ON INV.film_id = FIL.film_id
    JOIN rental REN ON REN.inventory_id = INV.inventory_id
    WHERE REN.customer_id = C.customer_id
);

SHOW TABLES;

# payment, rental, inventory (inventory_id, film_id)
# customer rental inventory film

SELECT * FROM film LIMIT 10;
# replacement_cost : $20달러 이상인 영화를 대여한 고객의 이름 조회
# 출력값 고객 이름

SELECT
	DISTINCT CONCAT(C.first_name, "_", C.last_name) fullname
FROM customer C
JOIN rental R ON R.customer_id = C.customer_id
JOIN inventory I ON I.inventory_id = R.inventory_id
JOIN film F ON F.film_id = I.film_id
WHERE F.replacement_cost >= 20;

# film 테이블에서 rating이 "PG-13"등급인 영화들이 있음
# 전체 영화들은 각각 description(영화설명)이 존재
# 전체 영화들의 개별적인 description의 문자길이가 rating이 "PG-13"등급에 한한
# 영화들의 평균 description의 문자길이보다 긴 영화들의 제목만 조회.출력
# LENGTH() : 특정 컬럼 안에 입력되어있는 문자열의 길이를 조회.추출하는 함수
# 해당 조건에 충족되는 영화 "제목"만 출력

USE sakila;

SELECT title
FROM film
WHERE LENGTH(description) > (
	SELECT AVG(LENGTH(description))
    FROM film
    WHERE rating = "PG-13"
);

# 2005년 8월에 대여된 모든 "R"등급 영화의 제목(title)과
# 해당 영화를 대여한 고객의 이메일을 조회
# 날짜와 관련된 컬럼 -> 특정 년도 및 월을 추출하고자 할 때
# YEAR(customer.rental_date)
# MONTH(customer.rental_date)

# 렌탈이라는 대여 비즈니스 : "고객 대여 > 재고 > 영화"
SELECT * FROM film LIMIT 10; # film_id
SELECT * FROM inventory LIMIT 10; # film_id, inventory_id
SELECT * FROM rental LIMIT 10; # inventory_id, customer_id
SELECT * FROM customer LIMIT 10; # customer_id

SHOW TABLES;

SELECT
	F.title, C.email
FROM film F
JOIN inventory I ON I.film_id = F.film_id
JOIN rental R ON R.inventory_id = I.inventory_id
JOIN customer C ON C.customer_id = R.customer_id
WHERE 
	MONTH(R.rental_date) = 8 AND
    YEAR(R.rental_date) = 2005 AND
    F.rating = "R";	

SELECT
	F.title, C.email
FROM film F
JOIN inventory I USING(film_id)
JOIN rental R USING(inventory_id)
JOIN customer C USING(customer_id)
WHERE 
	MONTH(R.rental_date) = 8 AND
    YEAR(R.rental_date) = 2005 AND
    F.rating = "R";	

# 고객들의 렌탈 결제 정보 존재
# 각 고객별 마지막 결제 시점, 해당 시점으로부터 30일 이전 기간동안 결제 내역을 찾아서
# 해당 결제 내역들의 전체 결제 내역 합계, 평균 결제 금액 조회
# 출력 시, 소수점 첫번째 자리까지 반올림해서 출력

SELECT * FROM payment LIMIT 10;

SELECT
	customer_id,
    ROUND(SUM(amount), 1) customer_sum,
    ROUND(AVG(amount), 1) customer_avg
FROM payment
WHERE payment_date >= DATE_SUB(
	(SELECT MAX(payment_date) FROM payment), INTERVAL 30 DAY
)
GROUP BY customer_id;

# 영화는 모두 카테고리를 가지고 있습니다.
# 카테고리가 공상과학인 영화들에 출연한 배우의 이름을 찾아서 조회!
# 배우의 이름은 성, 이름 => 하나로 연결해서 출력 (CONCAT)
# 배우의 이름 출력 시, 대문자로 출력 (UPPER)

SELECT
	UPPER(CONCAT(A.first_name, "_", A.last_name)) fullname
FROM actor A
JOIN film_actor F USING(actor_id)
JOIN film_category FC USING(film_id)
JOIN category C USING(category_id)
WHERE C.name = "Sci-Fi";

# 집합, UNION, UNION ALL, INTERSECT, EXCEPT
# 트랜잭션, COMMIT, ROLLBACK
# 가상쿼리, VIEW, WITH












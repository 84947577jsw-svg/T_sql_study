# VIEW : DB에 저장 / 계속 사용 가능 / CREATE VIEW / "재사용"
# WITH = CTE = Common Table Expression : 
# > 저장 x, WITH절을 사용한 그 순간의 쿼리에서만 한시적 사용 / WITH / "가독성"

WITH FilmInventory AS (
	SELECT DISTINCT film_id FROM inventory
)

SELECT
	F.film_id, F.title
FROM film F
JOIN FilmInventory FI USING(film_id);

# CASE WHEN
SELECT * FROM film LIMIT 10; # rental_rate

SELECT
	title,
    CASE
		WHEN rental_rate < 1 THEN "Cheap"
        WHEN rental_rate BETWEEN 1 AND 3 THEN "Moderate"
        ELSE "Expensive"
	END price_category
FROM film;

# Sakila > 각 고객별 총 결제금액을 계산
# 총 결제금액 구간에 따라서 고객을 다음 항목으로 분류 후 출력
# 총 결제금액 0 - 50 : Low / 51 - 100 : Medium / 100초과 : High
# 단, 고객별 총 결제금액은 WITH절로 작성 후 위 쿼리문을 조회.출력하세요!

WITH CustomerPayments AS (
	SELECT
		customer_id,
        SUM(amount) total_payment
    FROM payment
    GROUP BY customer_id
)

SELECT
	customer_id,
    CASE
		WHEN total_payment BETWEEN 0 AND 50 THEN "Low"
        WHEN total_payment BETWEEN 51 AND 100 THEN "Medium"
        ELSE "High"
	END PaymentStatus
FROM CustomerPayments;






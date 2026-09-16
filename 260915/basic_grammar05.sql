# VIEW = 가상 테이블 = Virtual Table
# SubQuery | JOIN => 쿼리구문 행수가 많아짐 => 코드 가독성 저하
# 사람이 코드를 보면서 쿼리구문 작성 => 실수가 많아질 수 있음
# 사전에 가상으로 값을 저장시켜놓은 테이블 준비
# 해당 테이블을 필요에 따라서 가져다가 사용 => 쿼리구문 독립성 유지 // 실수 저하
# VIEW => 실제 데이터가 저장 x // SELECT 형식의 쿼리 구문 저장

CREATE VIEW ActorInfo AS
SELECT first_name, last_name
FROM actor
WHERE actor_id < 100;

SELECT * FROM ActorInfo;

# VIEW 한번 생성이 되면, 다른 프로젝트 구문에서도 사용!!
# VIEW는 동일한 이름으로 이미 생성되어있다면, 같은 이름을 또 다시 사용 x

CREATE OR REPLACE VIEW ActorInfo AS
SELECT first_name
FROM actor
WHERE actor_id < 50;

DROP VIEW ActorInfo;

SELECT * FROM customer; # MARY SMITH

CREATE OR REPLACE VIEW myview AS
SELECT * FROM customer
WHERE customer_id = 1;

SELECT * FROM myview;

UPDATE customer
SET first_name = "MARY"
WHERE customer_id = 1;

DROP VIEW myview;





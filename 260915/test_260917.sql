USE wconcept_db_260916_02;

SHOW TABLES;

DESC blog_posts;

SELECT * FROM crawl_runs;
SELECT * FROM blog_posts;
SELECT * FROM brands;
SELECT * FROM product_rankings;
SELECT * FROM products;
SELECT * FROM product_snapshots;
SELECT * FROM review_evaluations;
SELECT * FROM review_images;
SELECT * FROM reviews;


SELECT 1;

ALTER TABLE blog_posts
MODIFY COLUMN title VARCHAR(500) NULL;
SELECT * FROM "AIRBNB"."DEV"."FCT_REVIEWS" WHERE listing_id=3176;
INSERT INTO "AIRBNB"."RAW"."RAW_REVIEWS"
VALUES (3176, CURRENT_TIMESTAMP(), 'Zlatan', 'excellent stay!', 'positive');

{{ config(
materialized = 'table',
) }}
WITH fct_reviews AS (
SELECT * FROM {{ ref('fct_reviews') }}
),
full_moon_dates AS (
SELECT * FROM {{ ref('seed_full_moon_dates') }}
)
SELECT
r.*,
CASE
WHEN fm.full_moon_date IS NULL THEN 'not full moon’
ELSE 'full moon’
END AS is_full_moon
FROM
fct_reviews r
LEFT JOIN full_moon_dates fm
ON (TO_DATE(r.review_date) = DATEADD(DAY, 1, fm.full_moon_date))
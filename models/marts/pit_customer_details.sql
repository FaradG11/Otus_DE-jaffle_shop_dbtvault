WITH as_of_dates AS (
    SELECT *
    FROM {{ ref('as_of_date') }}
),


new_rows_as_of_date AS (
    SELECT
        a.CUSTOMER_PK,
        b.AS_OF_DATE
    FROM {{ ref('sat_customer_details') }} AS a
    INNER JOIN as_of_dates AS b
    ON (1=1)
),

new_rows AS (
    SELECT
        a.customer_pk,
        a.first_name,
        a.last_name,
        a.email,
        c.country,
        c.age,
        a.effective_from,
        b.as_of_date AS actual_dt
    FROM new_rows_as_of_date AS b
    LEFT JOIN  {{ ref('sat_customer_details') }} AS a
        ON a.customer_pk = b.customer_pk
        AND a.effective_from <= b.as_of_date
    LEFT JOIN  {{ ref('sat_customer_country_age') }} AS c
        ON c.customer_pk = b.customer_pk
        AND c.effective_from <= b.as_of_date

),

pit AS (
    SELECT * FROM new_rows
    WHERE (customer_pk, effective_from, actual_dt) IN (
        SELECT customer_pk, MAX(effective_from), actual_dt
        FROM new_rows
        GROUP BY 1,3
    )
)

SELECT DISTINCT * FROM pit
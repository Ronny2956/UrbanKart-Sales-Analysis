SELECT * FROM urbankart.urbankart_sales_final;

SELECT
    -- Q1
    (
        SELECT region
        FROM urbankart_sales_final
        GROUP BY region
        ORDER BY SUM(CAST(total_revenue AS DECIMAL(15,2))) DESC
        LIMIT 1
    ) AS top_region,

    (
        SELECT SUM(CAST(total_revenue AS DECIMAL(15,2)))
        FROM urbankart_sales_final
    ) AS total_revenue,

    -- Q2: April → May growth
    ROUND(
        (
            SUM(
                CASE
                    WHEN MONTH(STR_TO_DATE(order_date, '%Y-%m-%d')) = 5
                    THEN CAST(total_revenue AS DECIMAL(15,2))
                    ELSE 0
                END
            )
            -
            SUM(
                CASE
                    WHEN MONTH(STR_TO_DATE(order_date, '%Y-%m-%d')) = 4
                    THEN CAST(total_revenue AS DECIMAL(15,2))
                    ELSE 0
                END
            )
        )
        /
        SUM(
            CASE
                WHEN MONTH(STR_TO_DATE(order_date, '%Y-%m-%d')) = 4
                THEN CAST(total_revenue AS DECIMAL(15,2))
                ELSE 0
            END
        ) * 100,
        1
    ) AS april_to_may_pct,

    -- Q2: May → June growth
    ROUND(
        (
            SUM(
                CASE
                    WHEN MONTH(STR_TO_DATE(order_date, '%Y-%m-%d')) = 6
                    THEN CAST(total_revenue AS DECIMAL(15,2))
                    ELSE 0
                END
            )
            -
            SUM(
                CASE
                    WHEN MONTH(STR_TO_DATE(order_date, '%Y-%m-%d')) = 5
                    THEN CAST(total_revenue AS DECIMAL(15,2))
                    ELSE 0
                END
            )
        )
        /
        SUM(
            CASE
                WHEN MONTH(STR_TO_DATE(order_date, '%Y-%m-%d')) = 5
                THEN CAST(total_revenue AS DECIMAL(15,2))
                ELSE 0
            END
        ) * 100,
        1
    ) AS may_to_june_pct

FROM urbankart_sales_final;

SELECT
    CASE
        WHEN april_to_may > 0 AND may_to_june > 0 THEN 'Up'
        WHEN april_to_may < 0 AND may_to_june < 0 THEN 'Down'
        ELSE 'Mixed'
    END AS overall_direction
FROM (
    SELECT
        (
            (
                SUM(CASE WHEN MONTH(STR_TO_DATE(order_date, '%Y-%m-%d')) = 5
                    THEN CAST(total_revenue AS DECIMAL(15,2)) ELSE 0 END)
                -
                SUM(CASE WHEN MONTH(STR_TO_DATE(order_date, '%Y-%m-%d')) = 4
                    THEN CAST(total_revenue AS DECIMAL(15,2)) ELSE 0 END)
            )
            /
            SUM(CASE WHEN MONTH(STR_TO_DATE(order_date, '%Y-%m-%d')) = 4
                THEN CAST(total_revenue AS DECIMAL(15,2)) ELSE 0 END)
        ) AS april_to_may,

        (
            (
                SUM(CASE WHEN MONTH(STR_TO_DATE(order_date, '%Y-%m-%d')) = 6
                    THEN CAST(total_revenue AS DECIMAL(15,2)) ELSE 0 END)
                -
                SUM(CASE WHEN MONTH(STR_TO_DATE(order_date, '%Y-%m-%d')) = 5
                    THEN CAST(total_revenue AS DECIMAL(15,2)) ELSE 0 END)
            )
            /
            SUM(CASE WHEN MONTH(STR_TO_DATE(order_date, '%Y-%m-%d')) = 5
                THEN CAST(total_revenue AS DECIMAL(15,2)) ELSE 0 END)
        ) AS may_to_june
    FROM urbankart_sales_final
) x;

SELECT
    sales_channel,
    SUM(CAST(total_revenue AS DECIMAL(15,2))) AS channel_revenue
FROM urbankart_sales_final
GROUP BY sales_channel
ORDER BY channel_revenue DESC;

SELECT
    sales_channel,
    ROUND(
        SUM(CAST(total_revenue AS DECIMAL(15,2))) /
        (SELECT SUM(CAST(total_revenue AS DECIMAL(15,2)))
         FROM urbankart_sales_final) * 100,
        1
    ) AS revenue_share
FROM urbankart_sales_final
GROUP BY sales_channel
ORDER BY SUM(CAST(total_revenue AS DECIMAL(15,2))) ASC
LIMIT 1;

SELECT 
    SUM(total_revenue) AS q1_revenue
FROM urbankart_sales_final
WHERE MONTH(STR_TO_DATE(order_date, '%Y-%m-%d')) IN (1, 2, 3);

SELECT 
    SUM(total_revenue) AS q1_revenue
FROM urbankart_sales_final
WHERE MONTH(order_date) IN (1, 2, 3);

SELECT
    SUM(CASE 
        WHEN MONTH(STR_TO_DATE(order_date, '%Y-%m-%d')) = 4 
        THEN total_revenue ELSE 0 END) AS april_revenue,

    SUM(CASE 
        WHEN MONTH(STR_TO_DATE(order_date, '%Y-%m-%d')) = 5 
        THEN total_revenue ELSE 0 END) AS may_revenue,

    SUM(CASE 
        WHEN MONTH(STR_TO_DATE(order_date, '%Y-%m-%d')) = 6 
        THEN total_revenue ELSE 0 END) AS june_revenue
FROM urbankart_sales_final;
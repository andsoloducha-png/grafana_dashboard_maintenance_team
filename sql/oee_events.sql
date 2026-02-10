
WITH classified_events AS (
    SELECT
        -- To jest tabela, gdzie są pojedyncze rekordy posiadające:
        -- Przypisanie ID dla zmiany
        CASE
            WHEN start::TIME BETWEEN '06:07:00' AND '14:15:00' THEN 1
            WHEN start::TIME BETWEEN '14:20:00' AND '22:30:00' THEN 2
            ELSE NULL
        END AS shift_id,

        -- Przypisanie ID dla linii i zrzutni
        CASE
            WHEN item::NUMERIC BETWEEN 401.010 AND 401.140 OR item::NUMERIC BETWEEN 660.000 AND 666.007 THEN 1 -- Multi 1
            WHEN item::NUMERIC BETWEEN 402.010 AND 402.140 OR item::NUMERIC BETWEEN 677.000 AND 683.007 THEN 2 -- Multi 2
            WHEN item::NUMERIC BETWEEN 403.010 AND 403.140 OR item::NUMERIC BETWEEN 694.000 AND 700.007 THEN 3 -- Multi 3
            WHEN item::NUMERIC BETWEEN 404.010 AND 404.140 OR item::NUMERIC BETWEEN 711.000 AND 717.007 THEN 4 -- Multi 4
            WHEN item::NUMERIC BETWEEN 405.010 AND 405.140 OR item::NUMERIC BETWEEN 728.000 AND 734.007 THEN 5 -- Multi 5
            WHEN item::NUMERIC BETWEEN 421.010 AND 421.020 OR item::NUMERIC BETWEEN 605.000 AND 605.007 THEN 6 -- Big item
            WHEN item::NUMERIC BETWEEN 423.010 AND 423.030 OR item::NUMERIC BETWEEN 627.000 AND 627.007 THEN 7 -- High Value
            WHEN item::NUMERIC BETWEEN 411.010 AND 411.051 OR item::NUMERIC BETWEEN 649.002 AND 649.007 THEN 8 -- Single line stara część
            WHEN item::NUMERIC BETWEEN 412.010 AND 412.064 THEN 9 --single line nowa część (sital right)
            WHEN item::NUMERIC IN (218.040, 219.040, 220.040, 221.040, 222.040, 223.040, 224.040,
                                   225.040, 226.040, 227.040, 228.040, 229.040, 230.040, 231.040,
                                   232.040, 233.040, 234.040, 235.040, 236.040, 237.040, 238.040,
                                   239.040, 240.040, 241.040, 242.040, 243.050) THEN FLOOR(item::NUMERIC) - 200 -- Tak będzie najszybciej. Dzięki temu zrzutnie mają krótsze i intuicyjne id (218.040 to 18 itd)
            WHEN item::NUMERIC BETWEEN 244.011 AND 244.999 THEN 44 -- NOK jako oddzielna zrzutnia, gdyż tu analizujemy również jam, za które odpowiada Fiege
            WHEN item::NUMERIC BETWEEN 301.010 AND 308.020 OR item::NUMERIC BETWEEN 311.010 AND 311.040 THEN 10 -- Dodaję jeszcze waste line, jakby kiedyś zliczanie Product jam było potrzebne
            ELSE NULL
        END AS line_id,

        -- Przypisanie ID dla eventu
        CASE
             WHEN event = 'Product jam' THEN 100 -- Przekroczenia wymiarów proponuję jako jedno zdarzenie, czyli ID 110
             WHEN event = 'Product too long' THEN 110
             WHEN event = 'Product too wide' THEN 110
             WHEN event = 'Product too high' THEN 110
             WHEN event = 'Product out of dimensions' THEN 110
             WHEN event = 'Chute full' THEN 120
             WHEN event = 'Emergency stop button' THEN 130 -- Wszystkie emergency stop proponuję jako jedno zdarzenie ID 130
             WHEN event = 'Emergency stop pull cord' THEN 130
             WHEN event = 'Emergency stop area' THEN 130
        ELSE NULL
        END AS event_id,

        start, "end"
    FROM oee_events
    WHERE
    event IN ('Product jam', 'Product too long', 'Product too wide', 'Product too high', 'Product out of dimensions',
              'Chute full', 'Emergency stop button', 'Emergency stop pull cord', 'Emergency stop area')
    AND (item::NUMERIC IN (218.040, 219.040, 220.040, 221.040, 222.040, 223.040, 224.040,
                          225.040, 226.040, 227.040, 228.040, 229.040, 230.040, 231.040,
                          232.040, 233.040, 234.040, 235.040, 236.040, 237.040, 238.040,
                          239.040, 240.040, 241.040, 242.040, 243.050)
        OR item::NUMERIC BETWEEN 244.011 AND 244.999
        OR item::NUMERIC BETWEEN 401.010 AND 401.140 OR item::NUMERIC BETWEEN 660.000 AND 666.007
        OR item::NUMERIC BETWEEN 402.010 AND 402.140 OR item::NUMERIC BETWEEN 677.000 AND 683.007
        OR item::NUMERIC BETWEEN 403.010 AND 403.140 OR item::NUMERIC BETWEEN 694.000 AND 700.007
        OR item::NUMERIC BETWEEN 404.010 AND 404.140 OR item::NUMERIC BETWEEN 711.000 AND 717.007
        OR item::NUMERIC BETWEEN 405.010 AND 405.140 OR item::NUMERIC BETWEEN 728.000 AND 734.007
        OR item::NUMERIC BETWEEN 421.010 AND 421.020 OR item::NUMERIC BETWEEN 605.000 AND 605.007
        OR item::NUMERIC BETWEEN 423.010 AND 423.030 OR item::NUMERIC BETWEEN 627.000 AND 627.007
        OR item::NUMERIC BETWEEN 411.010 AND 411.051 OR item::NUMERIC BETWEEN 649.002 AND 649.007
        OR item::NUMERIC BETWEEN 412.010 AND 412.064
        OR item::NUMERIC BETWEEN 301.010 AND 308.020 OR item::NUMERIC BETWEEN 311.010 AND 311.040)

        AND (start::TIME BETWEEN '06:07:00' AND '14:15:00' OR start::TIME BETWEEN '14:20:00' AND '22:30:00')
        AND start >= now()::date
),
-- Tabela posiadająca interesujące nas wyniki
aggregated_events AS (
    SELECT
        CONCAT(shift_id, '_', line_id, '_', event_id) AS key,
        shift_id,
        line_id,
        event_id,
        COUNT(*) AS count2,
        SUM(COALESCE(EXTRACT(EPOCH FROM ("end" - start)), 0)) AS duration
    FROM classified_events
    WHERE shift_id IS NOT NULL AND line_id IS NOT NULL
    GROUP BY shift_id, line_id, event_id
    ORDER BY count2 DESC
)

--
SELECT
    key,
    event_id,
    count2,
    duration
FROM aggregated_events;


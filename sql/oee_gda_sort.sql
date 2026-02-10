WITH classified_sort AS (
    SELECT
        -- Tworzenie ID zmiany na podstawie godziny
        COALESCE(
            CASE
                WHEN "STR_TIME_START"::TIME BETWEEN '06:00:00' AND '14:00:00' THEN 1
                WHEN "STR_TIME_START"::TIME BETWEEN '14:00:00' AND '23:00:00' THEN 2 -- Możemy zrobić od 15, żeby sie dane nie nanosiły na siebie
                ELSE NULL
            END, 0) AS shift_id,

        -- Konwersja id_sorter z SOXX na liczbę (np. SO20 to 20)
        CAST(SUBSTRING("ID_SORTER" FROM 3) AS INTEGER) AS sorter_id,

        -- Kolumny z datą i czasem
        "STR_DATE",
        "STR_TIME_START",
        "STR_TIME_END",

        -- Kolumny NIO
        "CNT_SORTED",
        "CNT_NOK", -- Suma wszystkich NIO
        "CNT_DUPLICATEBARCODE",
        "CNT_GAP",
        "CNT_MANYBARCODES",
        "CNT_NODEST",
        "CNT_REASON_NOK",
        "CNT_NOREAD",
        "CNT_OVERFLOW",
        "CNT_REJECT",
        "CNT_TOOEARLY",
        "CNT_TOOLATE",
        "CNT_UNKNOWN",
        "CNT_WRONGSORTER",

        -- Pozostałe kolumny
        "ID_SITE",
        "TYPE_SORTER",
        "PCT_ONLINE" -- To jest informacja, ile czasu sorter był włączony, ale w przypadku niepełnych godzin zmian wynik będzie fałszywy

    FROM oee_gda_sort
    WHERE "STR_DATE"::DATE >= now()::DATE
      AND ("STR_TIME_START"::TIME BETWEEN '06:00:00' AND '14:00:00'
           OR "STR_TIME_START"::TIME BETWEEN '14:00:00' AND '23:00:00')
),

aggregated_sort AS (
    SELECT
        -- Klucz
        CONCAT(shift_id, '_', sorter_id) AS key,
        shift_id,
        sorter_id,

        -- Read Ratio. Tutaj CNT_SORTED nie zawiera w sobie noread
        100 - COALESCE(SUM("CNT_NOREAD") * 100.0 / NULLIF(SUM("CNT_SORTED"), 0), 0) AS read_ratio,


        COALESCE(SUM("CNT_SORTED"), 0) AS sorted,
        COALESCE(SUM("CNT_NOK"), 0) AS nok, -- Suma wszystkich NIO
        COALESCE(SUM("CNT_DUPLICATEBARCODE"), 0) AS duplicatebarcode,
        COALESCE(SUM("CNT_GAP"), 0) AS gap,
        COALESCE(SUM("CNT_MANYBARCODES"), 0) AS manybarcodes,
        COALESCE(SUM("CNT_NODEST"), 0) AS nodest,
        COALESCE(SUM("CNT_REASON_NOK"), 0) AS reason_nok,
        COALESCE(SUM("CNT_NOREAD"), 0) AS noread,
        COALESCE(SUM("CNT_OVERFLOW"), 0) AS overflow,
        COALESCE(SUM("CNT_REJECT"), 0) AS reject,
        COALESCE(SUM("CNT_TOOEARLY"), 0) AS tooearly,
        COALESCE(SUM("CNT_TOOLATE"), 0) AS toolate,
        COALESCE(SUM("CNT_UNKNOWN"), 0) AS unknown,
        COALESCE(SUM("CNT_WRONGSORTER"), 0) AS wrongsorter


    FROM classified_sort
    WHERE shift_id IS NOT NULL

    GROUP BY sorter_id, shift_id
)

SELECT
    key,
    read_ratio,
    sorted,
    nok,
    duplicatebarcode,
    gap,
    manybarcodes,
    nodest,
    reason_nok,
    noread,
    overflow,
    reject,
    tooearly,
    toolate,
    unknown,
    wrongsorter
FROM aggregated_sort;


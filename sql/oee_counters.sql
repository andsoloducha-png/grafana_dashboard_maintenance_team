WITH classified_counters AS (
    SELECT

    -- Ustalanie zmiany na podstawie lokalnego czasu (przeliczonego z UTC)

        COALESCE(
            CASE
                WHEN ("time-stamp" AT TIME ZONE 'UTC' AT TIME ZONE 'Europe/Warsaw')::TIME
                        BETWEEN '06:07:00' AND '14:15:00' THEN 1
                WHEN ("time-stamp" AT TIME ZONE 'UTC' AT TIME ZONE 'Europe/Warsaw')::TIME
                        BETWEEN '14:20:00' AND '22:30:00' THEN 2
                ELSE NULL
            END, 0) AS shift_id,


        -- Te dwie kolumny są błędnie podpisane, bo dotyczą outbound scanner (shipping), a nie DWMS (w MFC jest dobrze).
        -- Są one potrzebne do wyliczenia read ratio.
        "dwmsscanner1count",
        "dwmsscanner1noread",

        -- Mutli line 1-5
        "inf1", "inf2", "inf3", "inf4", "inf5",

        -- Single line: stara część, nowa część
        "inf6", "sittalrightscannercount",

        -- Big item, High value
        "inf7", "inf8",

        -- Shipping sorted, reinfeed nok
        "sr_sorted", "inf9",

        -- Zrzutnie
        "out_218", "out_219", "out_220", "out_221", "out_222", "out_223", "out_224",
        "out_225", "out_226", "out_227", "out_228", "out_229", "out_230", "out_231",
        "out_232", "out_233", "out_234", "out_235", "out_236", "out_237", "out_238",
        "out_239", "out_240", "out_241", "out_242", "out_243", "out_244"

    FROM oee_counters
    WHERE (
        ("time-stamp" AT TIME ZONE 'UTC' AT TIME ZONE 'Europe/Warsaw')::TIME
            BETWEEN '06:07:00' AND '14:15:00'
        OR
        ("time-stamp" AT TIME ZONE 'UTC' AT TIME ZONE 'Europe/Warsaw')::TIME
            BETWEEN '14:20:00' AND '22:30:00'
    )
    AND "time-stamp" >= (now() AT TIME ZONE 'Europe/Warsaw')::date AT TIME ZONE 'Europe/Warsaw'
),

aggregated_counters AS (
    SELECT
        CONCAT(shift_id) AS key,
        shift_id,

        COALESCE((SUM(dwmsscanner1count) - SUM(dwmsscanner1noread)) * 100.0 / NULLIF(SUM(dwmsscanner1count) * 1.0, 0), 100) AS read_ratio
,

        COALESCE(SUM(inf1), 0) AS multi_line_1,
        COALESCE(SUM(inf2), 0) AS multi_line_2,
        COALESCE(SUM(inf3), 0) AS multi_line_3,
        COALESCE(SUM(inf4), 0) AS multi_line_4,
        COALESCE(SUM(inf5), 0) AS multi_line_5,

        COALESCE(SUM(inf6), 0) AS single_line,
        COALESCE(SUM(sittalrightscannercount), 0) AS sital_right,

        COALESCE(SUM(inf7), 0) AS big_item,
        COALESCE(SUM(inf8), 0) AS high_value,

        COALESCE(SUM(sr_sorted), 0) AS sorted_shipping,
        COALESCE(SUM(inf9), 0) AS reinfeed_nok,

        COALESCE(SUM(out_218), 0) AS chute_218,
        COALESCE(SUM(out_219), 0) AS chute_219,
        COALESCE(SUM(out_220), 0) AS chute_220,
        COALESCE(SUM(out_221), 0) AS chute_221,
        COALESCE(SUM(out_222), 0) AS chute_222,
        COALESCE(SUM(out_223), 0) AS chute_223,
        COALESCE(SUM(out_224), 0) AS chute_224,
        COALESCE(SUM(out_225), 0) AS chute_225,
        COALESCE(SUM(out_226), 0) AS chute_226,
        COALESCE(SUM(out_227), 0) AS chute_227,
        COALESCE(SUM(out_228), 0) AS chute_228,
        COALESCE(SUM(out_229), 0) AS chute_229,
        COALESCE(SUM(out_230), 0) AS chute_230,
        COALESCE(SUM(out_231), 0) AS chute_231,
        COALESCE(SUM(out_232), 0) AS chute_232,
        COALESCE(SUM(out_233), 0) AS chute_233,
        COALESCE(SUM(out_234), 0) AS chute_234,
        COALESCE(SUM(out_235), 0) AS chute_235,
        COALESCE(SUM(out_236), 0) AS chute_236,
        COALESCE(SUM(out_237), 0) AS chute_237,
        COALESCE(SUM(out_238), 0) AS chute_238,
        COALESCE(SUM(out_239), 0) AS chute_239,
        COALESCE(SUM(out_240), 0) AS chute_240,
        COALESCE(SUM(out_241), 0) AS chute_241,
        COALESCE(SUM(out_242), 0) AS chute_242,
        COALESCE(SUM(out_243), 0) AS chute_243,
        COALESCE(SUM(out_244), 0) AS chute_244

    FROM classified_counters
    GROUP BY shift_id
)

SELECT
    key,
    read_ratio,
    multi_line_1,
    multi_line_2,
    multi_line_3,
    multi_line_4,
    multi_line_5,
    single_line,
    sital_right,
    big_item,
    high_value,
    sorted_shipping,
    reinfeed_nok,
    chute_218,
    chute_219,
    chute_220,
    chute_221,
    chute_222,
    chute_223,
    chute_224,
    chute_225,
    chute_226,
    chute_227,
    chute_228,
    chute_229,
    chute_230,
    chute_231,
    chute_232,
    chute_233,
    chute_234,
    chute_235,
    chute_236,
    chute_237,
    chute_238,
    chute_239,
    chute_240,
    chute_241,
    chute_242,
    chute_243,
    chute_244
FROM aggregated_counters;


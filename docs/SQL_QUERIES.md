# SQL Queries Documentation

## Overview

This document provides detailed information about the SQL queries used in the GDA MFT Overview Dashboard.

## Common Patterns

All queries in this project follow these common patterns:

### 1. CTE (Common Table Expression) Structure
Each query uses a two-level CTE approach:
- **Classification layer** (`classified_*`) - filters and classifies raw data
- **Aggregation layer** (`aggregated_*`) - performs calculations and grouping

### 2. Shift Classification
Data is assigned to shifts based on local time:
```sql
CASE
    WHEN time::TIME BETWEEN '06:07:00' AND '14:15:00' THEN 1
    WHEN time::TIME BETWEEN '14:20:00' AND '22:30:00' THEN 2
    ELSE NULL
END AS shift_id
```

### 3. NULL Handling
All aggregations use `COALESCE` to prevent NULL-related errors:
```sql
COALESCE(SUM(column_name), 0) AS result
```

### 4. Key Generation
Logical keys are created for Grafana visualization:
```sql
CONCAT(shift_id, '_', line_id, '_', event_id) AS key
```

## Query Details

### oee_counters.sql

**Purpose:** Calculates throughput metrics and read ratio for scanners and chutes.

**Data Classification:**
- Converts UTC timestamps to Europe/Warsaw timezone
- Assigns shift_id based on local time
- Filters data to only include shift hours

**Metrics Calculated:**
- `read_ratio`: Scanner read success rate
  - Formula: `(scanned - noread) * 100 / scanned`
  - Range: 0-100%
- Line throughput: Sum of packages per line (multi_line_1-5, single_line, sital_right, big_item, high_value)
- Chute throughput: Sum per chute (chute_218 through chute_244)
- Shipping metrics: sorted_shipping, reinfeed_nok

**Key Features:**
- Handles misnamed columns (dwmsscanner1count is actually outbound scanner)
- Aggregates data by shift only (no line breakdown)
- Single key format: `shift_id`

**Time Handling:**
```sql
("time-stamp" AT TIME ZONE 'UTC' AT TIME ZONE 'Europe/Warsaw')::TIME
```

### oee_events.sql

**Purpose:** Tracks operational events and calculates their frequency and duration.

**Data Classification:**
- `shift_id`: Based on event start time (06:07-14:15 or 14:20-22:30)
- `line_id`: Numeric ranges mapped to line identifiers
  - Multi lines: 1-5
  - Big Item: 6
  - High Value: 7
  - Single lines: 8-9
  - Chutes: 18-43
  - NOK: 44
  - Waste: 10
- `event_id`: Event type classification
  - 100: Product jam
  - 110: Dimension violations (too long/wide/high)
  - 120: Chute full
  - 130: Emergency stops (all types)

**Metrics Calculated:**
- `count2`: Number of event occurrences
- `duration`: Total duration in seconds
  - Formula: `SUM(EXTRACT(EPOCH FROM (end - start)))`
  - NULL ends treated as 0 duration

**Key Features:**
- Consolidates similar events (e.g., all dimension violations → 110)
- Handles ongoing events (where end is NULL)
- Complex item number ranges for line identification
- Key format: `shift_id_line_id_event_id`

**Item Number Ranges:**
```sql
-- Multi 1 example
WHEN item::NUMERIC BETWEEN 401.010 AND 401.140 
  OR item::NUMERIC BETWEEN 660.000 AND 666.007 THEN 1
```

### oee_gda_sort.sql

**Purpose:** Analyzes Optimus sorter performance and NIO (Non-Identified Objects) metrics.

**Data Classification:**
- `shift_id`: Based on STR_TIME_START (06:00-14:00 or 14:00-23:00)
  - Note: Slightly different from other queries (23:00 instead of 22:30)
- `sorter_id`: Extracted from ID_SORTER field
  - Format: "SO20" → 20
  - Formula: `CAST(SUBSTRING(ID_SORTER FROM 3) AS INTEGER)`

**Metrics Calculated:**
- `read_ratio`: Read success percentage
  - Formula: `100 - (noread * 100 / sorted)`
  - Only calculated when sorted > 0
- NIO counts (all types):
  - duplicatebarcode, gap, manybarcodes, nodest
  - reason_nok, noread, overflow, reject
  - tooearly, toolate, unknown, wrongsorter
- `sorted`: Total items sorted
- `nok`: Total NIO items (sum of all error types)

**Key Features:**
- Handles incomplete hour intervals (PCT_ONLINE may be inaccurate)
- Filters to only shift hours from current date onwards
- Key format: `shift_id_sorter_id`
- Sourced from Inconso system

**Sorter IDs:**
- 20, 25: Presorters
- 30, 35, 40, 45: Main sorters

## Performance Considerations

### Date Filtering
All queries filter to current date or later:
```sql
WHERE timestamp >= now()::date
```

### Time Range Filtering
Shift time filtering is applied in the WHERE clause for efficiency:
```sql
WHERE time::TIME BETWEEN '06:07:00' AND '14:15:00'
   OR time::TIME BETWEEN '14:20:00' AND '22:30:00'
```

### Aggregation Strategy
- Use GROUP BY with shift_id and relevant dimensions
- Apply COALESCE to prevent NULL propagation
- Calculate ratios only when denominators are non-zero (NULLIF)

## Grafana Integration

### Required Transformations
1. **Difference (diff)**: 1-hour interval aggregation
2. **Filter by value**: Remove zeros (> 0)
3. **Reduce**: Simplify multi-row results

### Visualization Keys
Each query produces a unique key for Grafana labeling:
- oee_counters: `shift_id`
- oee_events: `shift_id_line_id_event_id`
- oee_gda_sort: `shift_id_sorter_id`

## Troubleshooting

### Common Issues

**Issue:** Read ratio showing 0% or NULL
- **Cause:** No reads in the period or division by zero
- **Solution:** Check NULLIF protection in ratio calculation

**Issue:** Missing data for partial shifts
- **Cause:** Filtering excludes data outside shift hours
- **Solution:** Expected behavior; shift boundaries are strict

**Issue:** Timezone discrepancies
- **Cause:** UTC vs local time confusion
- **Solution:** Verify AT TIME ZONE conversion in oee_counters

**Issue:** Event duration showing 0
- **Cause:** Event end timestamp is NULL
- **Solution:** Expected for ongoing events; COALESCE handles this

## Best Practices

1. **Always use COALESCE** when summing or averaging
2. **Apply timezone conversion** consistently for time-based logic
3. **Filter by date first** to improve query performance
4. **Use NULLIF** in division operations to prevent divide-by-zero
5. **Document item number ranges** when adding new lines or chutes
6. **Test queries** against multi-day datasets to verify aggregations

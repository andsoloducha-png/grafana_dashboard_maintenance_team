# Installation Guide

## Prerequisites

### Required Software
- PostgreSQL 12 or higher
- Grafana 8.0 or higher
- SQL client (DataGrip, pgAdmin, or psql)

### Required Access
- PostgreSQL database connection details
- Access to tables: `oee_counters`, `oee_events`, `oee_gda_sort`
- Grafana admin or editor permissions

## Database Setup

### 1. Verify Table Access

Connect to your PostgreSQL database and verify access to required tables:

```sql
-- Check oee_counters
SELECT COUNT(*) FROM oee_counters;

-- Check oee_events
SELECT COUNT(*) FROM oee_events;

-- Check oee_gda_sort
SELECT COUNT(*) FROM oee_gda_sort;
```

### 2. Test Timezone Configuration

Verify timezone conversion works correctly:

```sql
SELECT 
    "time-stamp" AS utc_time,
    ("time-stamp" AT TIME ZONE 'UTC' AT TIME ZONE 'Europe/Warsaw') AS local_time
FROM oee_counters
LIMIT 5;
```

## Grafana Setup

### 1. Configure PostgreSQL Data Source

1. Navigate to **Configuration → Data Sources** in Grafana
2. Click **Add data source**
3. Select **PostgreSQL**
4. Configure connection:
   - **Name**: GDA_MFT_PostgreSQL (or your preferred name)
   - **Host**: your-database-host:5432
   - **Database**: your-database-name
   - **User**: your-username
   - **Password**: your-password
   - **TLS/SSL Mode**: Configure according to your security requirements
5. Click **Save & Test** to verify connection

### 2. Import SQL Queries

For each SQL file in the `sql/` directory:

1. Open the file in a text editor
2. Copy the entire query
3. In Grafana, create a new panel
4. Paste the query into the SQL editor
5. Configure panel settings as described below

### 3. Configure Panels

#### For oee_counters.sql

**Panel Type:** Table or Stat
**Key Column:** key
**Transformations:**
1. Add transformation: **Difference**
   - Field: All numeric fields
   - Interval: 1h
2. Add transformation: **Filter by value**
   - Condition: Greater than 0

#### For oee_events.sql

**Panel Type:** Table or Bar Chart
**Key Column:** key
**Transformations:**
1. Add transformation: **Difference**
   - Field: count2, duration
   - Interval: 1h
2. Add transformation: **Filter by value**
   - Condition: Greater than 0
3. Add transformation: **Reduce**
   - Mode: All values
   - Calculations: Total

#### For oee_gda_sort.sql

**Panel Type:** Table or Gauge
**Key Column:** key
**Transformations:**
1. Add transformation: **Reduce**
   - Mode: All values
   - Calculations: Total (for counts), Mean (for read_ratio)

### 4. Create Dashboard

1. Create new dashboard: **Dashboards → New Dashboard**
2. Add panels for each query type
3. Organize into four sections:
   - **Zdarzenia (Events)**
   - **Multi, Single, BI, HV**
   - **Shipping**
   - **Optimus - NIO**

### 5. Configure Variables (Optional)

Add dashboard variables for dynamic filtering:

**Shift Selection:**
- **Name**: shift
- **Type**: Custom
- **Values**: 1,2
- **Label**: Shift

**Date Range:**
- Use Grafana's built-in time range picker
- Default range: Last 24 hours

## Testing Installation

### 1. Verify Data Flow

Check each panel displays data:
- Events panel shows operational events
- Lines panel shows throughput metrics
- Shipping panel shows chute data
- Optimus panel shows NIO breakdown

### 2. Test Multi-Day Analysis

1. Set time range to last 7 days
2. Verify aggregations are correct
3. Check no duplicate data appears

### 3. Validate Shift Classification

1. Filter to Shift 1 (06:07-14:15)
2. Verify only relevant data appears
3. Repeat for Shift 2 (14:20-22:30)

## Troubleshooting

### No Data Displayed

**Check:**
- Database connection is active
- Tables contain recent data
- Shift times match your operation hours
- Timezone conversion is correct

**Solution:**
```sql
-- Verify current date data exists
SELECT COUNT(*) 
FROM oee_events 
WHERE start >= now()::date;
```

### Incorrect Timezone

**Symptom:** Data appears in wrong shifts

**Solution:**
- Verify PostgreSQL timezone: `SHOW timezone;`
- Adjust timezone in queries if needed
- Restart Grafana after timezone changes

### Performance Issues

**Symptom:** Queries timeout or slow to load

**Solutions:**
1. Add indexes on frequently filtered columns:
```sql
CREATE INDEX idx_oee_events_start ON oee_events(start);
CREATE INDEX idx_oee_counters_timestamp ON oee_counters("time-stamp");
CREATE INDEX idx_oee_gda_sort_date ON oee_gda_sort("STR_DATE");
```

2. Reduce time range in Grafana
3. Implement data retention policies

### Transformation Errors

**Symptom:** Panels show "No data" after transformations

**Solution:**
- Remove transformations one by one to identify issue
- Verify field names match query output
- Check filter conditions aren't too restrictive

## Maintenance

### Regular Tasks

**Daily:**
- Monitor dashboard for anomalies
- Verify data freshness

**Weekly:**
- Review query performance
- Check for missing data gaps

**Monthly:**
- Update documentation if logic changes
- Archive old dashboard versions

### Backup

Backup dashboard JSON regularly:
1. Open dashboard
2. Click **Settings** (gear icon)
3. Select **JSON Model**
4. Copy and save JSON to version control

## Support

For installation issues:
- Check logs: Grafana logs and PostgreSQL logs
- Review query syntax in SQL client
- Verify network connectivity to database
- Contact MFT technical team

## Next Steps

After successful installation:
1. Review dashboard sections in detail
2. Configure alerts for critical metrics (if needed)
3. Share dashboard with operations team
4. Set up user permissions
5. Plan future enhancements (see README.md)

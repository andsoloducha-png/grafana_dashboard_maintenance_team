# Changelog

All notable changes to the GDA MFT Overview Dashboard project will be documented in this file.

## [1.0.0] - 2025-02-10

### Added
- Initial dashboard implementation in Grafana
- SQL queries for three main data sources:
  - oee_counters.sql - counters and throughput data
  - oee_events.sql - operational events tracking
  - oee_gda_sort.sql - Optimus sorter NIO analysis
- Four main dashboard sections:
  - Events (Zdarzenia)
  - Multi, Single, BI, HV lines
  - Shipping analysis
  - Optimus NIO breakdown
- Shift-based data classification (Shift 1: 06:07-14:15, Shift 2: 14:20-22:30)
- Read ratio calculations for scanner performance
- Comprehensive documentation in Polish

### Features
- Real-time and historical data monitoring
- Multi-day analysis capability
- Event duration tracking
- Chute full detection and counting
- Emergency stop monitoring
- Product jam analysis
- Dimension violation tracking (too long/wide/high)

### Technical
- PostgreSQL database integration
- Grafana transformations for multi-day analysis
- CTE-based SQL queries for better readability
- NULL handling with COALESCE
- UTC to Europe/Warsaw timezone conversion

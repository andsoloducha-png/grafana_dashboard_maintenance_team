# Contributing to GDA MFT Overview Dashboard

Thank you for your interest in contributing to the GDA MFT Overview Dashboard project.

## Code Style Guidelines

### SQL

- Use uppercase for SQL keywords (`SELECT`, `FROM`, `WHERE`, etc.)
- Use lowercase for table and column names
- Indent nested queries and CTEs for readability
- Always use explicit column names (avoid `SELECT *`)
- Comment complex logic with inline comments
- Use meaningful CTE names (e.g., `classified_events`, `aggregated_counters`)

### Naming Conventions

- **Tables**: `snake_case` (e.g., `oee_events`)
- **Columns**: `snake_case` (e.g., `shift_id`, `line_id`)
- **CTEs**: `descriptive_snake_case` (e.g., `classified_events`, `aggregated_sort`)
- **Keys**: Use concatenation format `dimension1_dimension2_...` (e.g., `shift_id_line_id_event_id`)

## Adding New Features

### New SQL Queries

1. Follow the established CTE pattern:
   - First CTE: Classification/filtering
   - Second CTE: Aggregation
   - Final SELECT: Return formatted results

2. Include standard elements:
   - Shift classification
   - NULL handling with COALESCE
   - Key generation for Grafana
   - Date filtering for current data

3. Document your query:
   - Purpose and use case
   - Input tables and columns
   - Output metrics
   - Any special considerations

### New Dashboard Sections

1. Plan the visualization before writing SQL
2. Identify required metrics and dimensions
3. Create SQL query following project patterns
4. Test with multi-day datasets
5. Document Grafana transformations needed
6. Update README.md with new section details

## Testing

Before submitting changes:

1. **SQL Syntax**: Test queries in DataGrip or PostgreSQL client
2. **Data Validation**: Verify results against known values
3. **Multi-day Testing**: Ensure aggregations work across date boundaries
4. **NULL Handling**: Test with incomplete or missing data
5. **Performance**: Check query execution time with large datasets

## Documentation

Update documentation when:

- Adding new SQL queries
- Modifying existing logic
- Adding dashboard sections
- Changing shift definitions or time ranges
- Updating line/sorter ID mappings

Required documentation updates:
- README.md - high-level changes
- SQL_QUERIES.md - detailed query documentation
- CHANGELOG.md - version history
- Inline SQL comments - complex logic explanation

## Shift Time Changes

If modifying shift times:

1. Update ALL queries consistently:
   - oee_counters.sql
   - oee_events.sql
   - oee_gda_sort.sql
2. Update documentation (README.md, SQL_QUERIES.md)
3. Coordinate with dashboard users
4. Test boundary conditions

## Adding New Lines or Chutes

When adding equipment:

1. Determine appropriate line_id range
2. Update classification CASE statements in oee_events.sql
3. Add counter columns in oee_counters.sql if needed
4. Update documentation with new ID mappings
5. Test with historical data

## Database Schema Changes

For schema modifications:

1. Document the change reason
2. Provide migration scripts if needed
3. Update all affected queries
4. Test backward compatibility if possible
5. Coordinate with database administrators

## Submitting Changes

1. Create a descriptive commit message
2. Reference relevant documentation updates
3. Include test results or validation notes
4. Note any breaking changes
5. Update CHANGELOG.md

## Questions and Support

For questions about:
- Technical implementation → Contact MFT technical team
- Business logic → Contact operations team
- Dashboard usage → Refer to user documentation

## Code Review Checklist

- [ ] SQL follows project style guidelines
- [ ] NULL handling implemented with COALESCE
- [ ] Shift classification applied correctly
- [ ] Keys generated for Grafana integration
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
- [ ] Tested with multi-day data
- [ ] Performance verified
- [ ] Comments added for complex logic

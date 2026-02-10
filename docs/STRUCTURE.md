# Repository Structure

```
gda-mft-overview-dashboard/
│
├── README.md                  # Main project documentation
├── LICENSE                    # MIT License
├── CHANGELOG.md              # Version history and changes
├── CONTRIBUTING.md           # Contribution guidelines
├── .gitignore               # Git ignore patterns
│
├── sql/                      # SQL query files
│   ├── oee_counters.sql     # Counters and throughput metrics
│   ├── oee_events.sql       # Operational events tracking
│   └── oee_gda_sort.sql     # Optimus sorter NIO analysis
│
├── docs/                     # Documentation
│   ├── SQL_QUERIES.md       # Detailed SQL documentation
│   ├── INSTALLATION.md      # Setup and installation guide
|
└── images/                   # Dashboard screenshots
    ├── README.md            # Screenshot descriptions
    ├── 1.jpg               # Main dashboard overview (both shifts)
    ├── 2.jpg               # Events detail view
    ├── 3.jpg               # Chutes sorted analysis
    └── 4.jpg               # Optimus NIO breakdown
```

## Directory Descriptions

### Root Files
- **README.md**: Comprehensive project overview, features, and usage
- **LICENSE**: MIT license for the project
- **CHANGELOG.md**: Version history with detailed change notes
- **CONTRIBUTING.md**: Guidelines for contributing to the project
- **.gitignore**: Specifies intentionally untracked files

### sql/
Contains all SQL query files used in Grafana dashboard:
- Each file corresponds to a data source table
- Queries follow consistent CTE pattern
- Well-commented and documented

### docs/
Project documentation:
- Technical SQL query reference
- Installation and setup instructions
- Original project documentation (PDF)

### images/
Dashboard screenshots for documentation:
- Visual reference for dashboard sections
- Training materials
- Version comparison baseline

## File Naming Conventions

- **SQL files**: `table_name.sql` (lowercase, underscores)
- **Documentation**: `UPPERCASE.md` for root-level, `Title_Case.md` for docs/
- **Images**: Numbered sequentially (1.jpg, 2.jpg, etc.)

## Version Control

This repository uses Git with the following branch structure:
- **master**: Stable, production-ready code
- Feature branches: For development work (if needed)

Commits follow conventional format:
```
type: subject

- Detailed point 1
- Detailed point 2
```

## Updates and Maintenance

Key files to update when making changes:
1. **SQL files**: When modifying queries
2. **CHANGELOG.md**: For every version change
3. **README.md**: For feature additions or major changes
4. **docs/SQL_QUERIES.md**: When query logic changes
5. **images/**: When dashboard layout changes significantly

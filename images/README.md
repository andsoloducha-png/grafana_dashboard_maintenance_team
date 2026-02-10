# Dashboard Screenshots

This directory contains screenshots of the GDA MFT Overview Dashboard in Grafana.

## Files

### 1.jpg - Main Dashboard Overview (Shift 1 & 2)
Shows the complete dashboard view with both shifts displayed side by side:
- **Multi lines section**: Product jam, too long, emergency, and chute full metrics
- **Single lines section**: Jam duration, counts, and sorted packages
- **Big Item and High Value sections**: Event metrics and sorted counts
- **Shipping section**: Chute full, NOK chute full, NOK jam, shipping sorted stats, read ratio, and reinfeed NOK parcels
- **Optimus NIO section**: Sorted packages and NIO total by sorter (SO20-SO45), read ratios

**Key Metrics Visible:**
- Total event counts and durations per shift
- Sorted package counts per line
- Read ratios (99.8-99.9%)
- Emergency stop indicators

### 2.jpg - Events Detail View
Detailed breakdown of operational events with visual bar charts:
- **Jam Duration**: Time-based visualization per line
- **Jam Count**: Occurrence frequency
- **Too long Duration**: Dimension violation tracking
- **Too long Count**: Number of oversized items
- **Sorted**: Total packages processed per line
- **Emergency Duration**: Emergency stop time analysis
- **Emergency Count**: Safety event frequency

**Visual Features:**
- Color-coded bars for different lines (Multi 1-5, Single, Sital, Big Item, High Value)
- Time duration displayed in HH:MM:SS format
- Real-time event counts

### 3.jpg - Chutes Sorted Analysis (Shift 1 & 2)
Comprehensive shipping analysis:
- **Chutes sorted bar chart**: Packages sorted by each chute (218-244)
  - Green/yellow gradient indicating volume levels
  - Numbers displayed on each bar
- **Chute full count**: Incidents per chute
- **Ch.full duration**: Time each chute was full
- **Shipping sorted timeline**: Line graph showing hourly distribution
- **Chutes sorted total**: Aggregate count
- **Read Ratio**: Scanner performance percentage
- **Reinfeed nok**: Failed reinfeed parcels
- **NOK jam duration**: Time spent clearing jams
- **Count**: Total NOK jam occurrences

**Notable Data Points:**
- Highest throughput chutes: 226 (2130), 229 (2400), 233 (2557)
- Read ratio consistently above 99%
- Chute full events tracked with duration

### 4.jpg - Optimus NIO Breakdown (Shift 1 & 2)
Detailed NIO (Non-Identified Objects) analysis by sorter:
- **Sorted**: Total packages processed by each sorter (SO20-SO45)
- **NIO Total**: Count of all error types
- **Duplicate barcode**: Packages with duplicate identifiers
- **Gap**: Gap detection errors
- **Many barcodes**: Multiple barcode detection
- **No dest**: No destination assigned
- **Reason NOK**: Quality rejection
- **No read**: Failed barcode reads
- **Overflow**: Buffer overflow incidents
- **Reject**: Manual/automatic rejections
- **Too early/Too late**: Timing errors
- **Unknown**: Unclassified errors
- **Wrongsorter**: Routing errors

**Read Ratio Section:**
- Presorters (SO20, SO25): 99.3%, 98.9%
- Main Sorters (SO30, SO35): 99.0%, 98.5%
- Color-coded boxes for quick visual assessment

**Key Insights:**
- SO25 shows highest sorted volume across both shifts
- Most common errors: No read, Gap, Duplicate barcode
- Read ratios maintained above 98% target

## Usage

These screenshots serve as:
1. Visual documentation of dashboard features
2. Reference for dashboard configuration
3. Training material for new users
4. Baseline for performance comparisons

## Update Frequency

Screenshots should be updated when:
- Dashboard layout changes significantly
- New panels or sections are added
- Major visualization improvements are implemented
- Quarterly for documentation purposes

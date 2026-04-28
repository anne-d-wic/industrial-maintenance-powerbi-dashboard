# Industrial Maintenance Analytics Dashboard

## Project Overview

This project simulates an industrial maintenance environment and turns raw operational data into a structured analytics workflow built across Python, SQL Server, and Power BI.

The dashboard is designed for maintenance and operations stakeholders who need to monitor downtime, maintenance cost, request volume, machine performance, and technician-level execution patterns.

The final solution follows a clear analytics pipeline:

1. Python generates realistic source data.
2. SQL Server transforms and models the data into reporting-ready views.
3. Power BI consumes the SQL views through a cleaned semantic model and delivers interactive business reporting.

This project was intentionally upgraded from a flat-file dashboard into a more credible end-to-end BI workflow so that the analytical logic is distributed in a realistic way across the stack rather than concentrated only inside Power BI.

## Business Objective

The dashboard answers three operational questions:

1. How much maintenance activity, downtime, and cost is the organization absorbing over time?
2. Which machines are driving the biggest operational and financial impact?
3. How do maintenance execution patterns vary by technician, priority, and maintenance type?

The reporting layer is organized to support both executive monitoring and operational investigation.

## End-To-End Pipeline

### 1. Python - Source Data Generation

Python is used to simulate source data for an industrial maintenance environment.

The generated datasets include:

- `machines.csv`
- `maintenance_requests.csv`

Python is responsible for the source layer only. It produces the raw entities that feed the rest of the stack.

### 2. SQL Server - Transformation And Reporting Layer

SQL Server is used as the core transformation layer.

This layer handles:

- relational joins between machines and maintenance requests
- derived operational metrics such as resolution time and start delay
- business flags such as preventive versus corrective maintenance
- priority ranking and machine age segmentation
- reporting views aligned to dashboard pages

The SQL layer is organized in five scripts:

```text
sql/
  01_create_staging_tables.sql
  02_load_source_tables.sql
  03_create_core_views.sql
  04_create_reporting_views.sql
  05_validation_queries.sql
```

### SQL Scripts Breakdown

Each SQL script has a specific role in the reporting pipeline.

#### `01_create_staging_tables.sql`

Creates the database objects used to receive the source data.

Main responsibilities:

- create the target database
- create the staging tables
- define the basic relational structure between machines and maintenance requests

#### `02_load_source_tables.sql`

Documents and supports the data load step from CSV into SQL Server.

Main responsibilities:

- load `machines.csv` into the machine staging table
- load `maintenance_requests.csv` into the request staging table
- provide the import logic needed to move the raw source files into SQL

#### `03_create_core_views.sql`

Creates the main enriched analytical base view.

Main responsibilities:

- join source entities
- derive analytical fields
- prepare request-level business logic for downstream reporting

This is the key bridge between raw operational data and reporting-ready SQL outputs.

#### `04_create_reporting_views.sql`

Creates the SQL views that map directly to the Power BI pages.

Main responsibilities:

- build executive-level aggregates
- build machine-level performance views
- build technician and priority reporting views
- build month-level trend views

This script is what turns the enriched view into page-ready reporting datasets.

#### `05_validation_queries.sql`

Provides validation checks to confirm that the SQL layer is behaving as expected.

Main responsibilities:

- reconcile row counts between source and transformed layers
- compare totals such as downtime hours
- inspect sample outputs from reporting views
- support debugging during the Power BI remapping phase

This validation step is important because it shows that the SQL layer was not only built, but also tested before replacing the legacy model.

### 3. Power BI - Semantic Model And Dashboarding

Power BI consumes the SQL views rather than rebuilding the full transformation logic from CSV files.

Power BI is used for:

- shared dimensions and filter design
- KPI measures and display formatting
- page-level analytical storytelling
- interactive exploration through slicers and cross-page filter sync

The model was cleaned so that the final report no longer depends on the original legacy tables.

## Data Model Design

The final Power BI model is built around a shared-dimension approach.

### Shared Dimensions

- `Plant`
- `Machine`
- `Technician`
- `Priority`
- `Date`
- `Month`

These dimensions drive consistent filtering across report pages and avoid mixing visual logic directly between reporting views.

### Core SQL Views

#### `vw_maintenance_requests_enriched`

This is the central detailed analytical view.

It joins source entities and derives the fields used throughout the report, including:

- machine attributes
- created day and created month
- maintenance category flags
- priority rank
- resolution time
- start delay
- downtime band
- machine age band

#### `vw_executive_overview`

This view supports high-level monitoring by plant and month.

Main outputs:

- maintenance request volume
- total downtime hours
- total maintenance cost
- average resolution time
- preventive maintenance ratio

#### `vw_machine_performance`

This view supports machine-level ranking and asset investigation.

Main outputs:

- request count by machine
- total downtime by machine
- total maintenance cost by machine
- average resolution time by machine
- high-priority request count
- downtime and cost ranking

#### `vw_operational_performance`

This view supports technician and monthly execution analysis.

Main outputs:

- request count by technician, priority, and month
- downtime hours by technician, priority, and month
- maintenance cost by technician, priority, and month
- average resolution time by technician, priority, and month

#### `vw_priority_resolution`

This view isolates priority-level service patterns.

Main outputs:

- request count by priority
- average resolution time by priority
- average start delay by priority

#### `vw_plant_monthly_trend`

This view supports monthly trend analysis by plant.

Main outputs:

- request count by plant and month
- downtime hours by plant and month
- maintenance cost by plant and month

## Dashboard Pages

### 1. Executive Overview

This page is designed for high-level operational monitoring.

It focuses on:

- total maintenance requests
- total downtime hours
- total maintenance cost
- preventive maintenance ratio
- average downtime per request
- average resolution time
- monthly maintenance trend

Recommended filters:

- Month
- Plant
- Priority

Suggested screenshot reference:

```markdown
![Executive Overview](maintenance_dashboard_overview.png)
```

### 2. Machine Performance Analysis

This page is designed for asset-level diagnosis.

It focuses on:

- top machines by downtime
- top machines by maintenance cost
- highest machine downtime
- downtime versus cost relationship
- machine-level performance comparison
- age-related risk analysis

Recommended filters:

- Plant
- Machine Type

Suggested screenshot reference:

```markdown
![Machine Performance Analysis](machine_performance_analysis.png)
```

### 3. Operational Performance

This page is designed for execution analysis at technician and priority level.

It focuses on:

- corrective maintenance requests
- average cost per maintenance request
- requests by priority
- average resolution time by priority
- technician-level operational comparisons
- monthly operational trend

Recommended filters:

- Month
- Priority
- Technician

Suggested screenshot reference:

```markdown
![Operational Performance](operational_performance.png)
```

## Why The SQL Layer Matters

The most important upgrade in this project is the introduction of a real SQL transformation layer.

Instead of keeping all logic inside Power BI or relying only on flat files, the project now demonstrates a more realistic BI architecture:

- Python handles data generation
- SQL handles transformation and reporting logic
- Power BI handles semantic modeling and visualization

This matters because it shows:

- SQL joins and data shaping
- KPI-ready reporting views
- cleaner separation of responsibilities across the stack
- a stronger analytics engineering mindset than a dashboard-only build

## Validation Approach

The SQL migration was validated through a parallel-model comparison inside Power BI.

Validation steps included:

- comparing old and new visuals page by page
- checking KPI alignment under controlled filter scenarios
- correcting view grain where required
- rebuilding slicers from shared dimensions rather than fact tables
- removing legacy tables only after cross-page validation passed

This ensured that the final report was not only technically migrated, but also behaviorally consistent.

## Repository Structure

```text
industrial-dashboard-project/
  generate_industrial_dataset.py
  analysis.py
  machines.csv
  maintenance_requests.csv
  industrial-operations-dashboard.pbix
  industrial-operations-dashboard-sql.pbix
  machine_performance_analysis.png
  maintenance_dashboard_overview.png
  operational_performance.png
  SQL_TRANSFORMATION_GUIDE.md
  POWERBI_SQL_REMAP_GUIDE.docx
  POWERBI_SHARED_DIMENSIONS_GUIDE.docx
  sql/
    01_create_staging_tables.sql
    02_load_source_tables.sql
    03_create_core_views.sql
    04_create_reporting_views.sql
    05_validation_queries.sql
```

## Tools Used

- Python
- pandas
- SQL Server
- SQL Server Management Studio
- Power BI

## Key Analytical Skills Demonstrated

- synthetic dataset design in Python
- SQL staging and transformation workflow
- analytical view design for BI consumption
- dimension-based Power BI modeling
- DAX measures for KPI display and ratio logic
- cross-page filter design and model cleanup
- dashboard remapping from legacy tables to SQL-backed views

## Outcome

This project evolved from a dashboard built on generated flat files into a more mature BI project with an explicit reporting pipeline.

The final deliverable shows how operational data can move from simulated source generation to SQL modeling and then into a Power BI report structured for both executive and operational analysis.

That upgrade makes the project stronger both technically and professionally because it demonstrates not only dashboarding, but also the upstream data modeling and transformation work that makes reporting reliable.
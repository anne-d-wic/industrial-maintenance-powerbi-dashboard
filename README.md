# industrial-maintenance-powerbi-dashboard
## Project Overview

This project demonstrates how data analytics can support industrial maintenance operations.
The dashboard was designed to monitor machine downtime, maintenance costs and technician workload, and to help identify operational inefficiencies.
It provides a structured decision-support view for operations and maintenance managers.

---

## Business Questions Addressed

This dashboard helps answer key operational questions such as:
- Which machines generate the most downtime?
- What are the main drivers of maintenance costs?
- How is the workload distributed across technicians?
- Are high-priority incidents resolved quickly enough?
- What is the balance between preventive and corrective maintenance?

---

## Dashboard Structure
### 1. Executive Overview

Provides a high-level operational view with key KPIs and maintenance trends.

![Executive Overview](images/maintenance_dashboard_overview.png)

Main elements:
- Total maintenance requests
- Total downtime
- Maintenance cost
- Average resolution time
- Maintenance requests over time
- Preventive maintenance ratio
- Maintenance requests by machine type

---

### 2. Machine Performance Analysis

Focuses on equipment performance and identifies machines with the highest operational impact.

![Machine Performance Analysis](images/machine_performance_analysis.png)

Main elements:
- Top 5 machines by downtime
- Top 5 machines by maintenance cost
- Downtime vs maintenance cost analysis
- Machine performance detail table

---

### 3. Operational Performance

Monitors technician workload and maintenance efficiency.

![Operational Performance](images/operational_performance.png)

Main elements:
- Maintenance requests by technician
- Average resolution time by priority
- Requests by priority
- Monthly maintenance workload

---

## Tools Used

- Power BI
- DAX
- Python
- GitHub

---

## Files Included

### Dashboard
- `dashboard/industrial-maintenance-dashboard.pbix`

### Data
- `data/machines.csv`
- `data/maintenance_requests.csv`

### Screenshots
- `images/maintenance_dashboard_overview.png`
- `images/machine_performance_analysis.png`
- `images/operational_performance.png`

---

## Dataset

The dataset is simulated and represents an industrial maintenance environment.

It includes:
- machine inventory
- maintenance interventions
- technicians
- downtime duration
- maintenance costs
- maintenance priority
- preventive vs corrective activities

---

## Skills Demonstrated

This project highlights the following skills:

- data modeling
- DAX measures and KPI design
- dashboard design in Power BI
- operational analytics
- maintenance performance analysis
- business-oriented data storytelling

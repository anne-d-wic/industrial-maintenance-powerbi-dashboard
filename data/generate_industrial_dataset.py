import random
from datetime import datetime, timedelta
import csv

random.seed(42)

# --------- Configuration ----------
N_REQUESTS = 1000
N_MACHINES = 60
PLANTS = ["Plant A", "Plant B"]
TECHNICIANS = ["Alex", "Sam", "Jordan", "Taylor", "Morgan", "Casey", "Riley", "Jamie"]
PRIORITIES = ["High", "Medium", "Low"]
CATEGORIES = ["Preventive", "Corrective"]
MACHINE_TYPES = ["CNC", "Packaging", "Conveyor", "Mixer", "Pump", "Filler", "Compressor"]

START_DATE = datetime(2024, 1, 1)
END_DATE = datetime(2025, 12, 31)

# --------- Helpers ----------
def rand_date(start: datetime, end: datetime) -> datetime:
    delta = end - start
    return start + timedelta(days=random.randint(0, delta.days), minutes=random.randint(0, 24*60-1))

def clamp(x, lo, hi):
    return max(lo, min(hi, x))

# --------- Machines dimension ----------
machines = []
for i in range(1, N_MACHINES + 1):
    machine_id = f"M-{i:03d}"
    plant = random.choice(PLANTS)
    mtype = random.choice(MACHINE_TYPES)
    install_year = random.randint(2008, 2024)
    machines.append({
        "MachineID": machine_id,
        "MachineType": mtype,
        "InstallationYear": install_year,
        "Plant": plant
    })

# Index machines by id for quick lookup
machine_by_id = {m["MachineID"]: m for m in machines}

# --------- Requests fact ----------
requests = []
for i in range(1, N_REQUESTS + 1):
    req_id = f"R-{i:05d}"
    machine = random.choice(machines)
    machine_id = machine["MachineID"]
    plant = machine["Plant"]

    created = rand_date(START_DATE, END_DATE)

    category = random.choices(CATEGORIES, weights=[0.45, 0.55])[0]  # more corrective than preventive
    priority = random.choices(PRIORITIES, weights=[0.25, 0.5, 0.25])[0]
    technician = random.choice(TECHNICIANS)

    # Start delay depends on priority
    start_delay_hours = {
        "High": random.randint(0, 8),
        "Medium": random.randint(4, 24),
        "Low": random.randint(12, 72)
    }[priority]

    start = created + timedelta(hours=start_delay_hours)

    # Duration depends on category & priority
    base_duration_hours = 0
    if category == "Preventive":
        base_duration_hours = random.randint(1, 6)
    else:
        base_duration_hours = random.randint(2, 18)

    if priority == "High":
        base_duration_hours += random.randint(0, 6)

    duration_hours = clamp(base_duration_hours + random.choice([0, 0, 1, 2, 3, -1]), 1, 36)
    end = start + timedelta(hours=duration_hours)

    # Downtime: preventive often lower, corrective higher
    if category == "Preventive":
        downtime = clamp(random.gauss(1.5, 1.0), 0.0, 8.0)
    else:
        downtime = clamp(random.gauss(6.0, 4.0), 0.0, 48.0)

    # Cost model (simple but realistic-ish):
    # labor + parts, corrective tends to cost more; downtime can increase cost slightly.
    labor_rate = 95  # CHF/EUR-ish per hour (placeholder)
    labor_cost = labor_rate * duration_hours
    parts_cost = 0
    if category == "Preventive":
        parts_cost = random.uniform(20, 250)
    else:
        parts_cost = random.uniform(100, 1800)

    # Older machines slightly more expensive
    age = 2026 - machine["InstallationYear"]
    age_factor = 1.0 + (age * 0.01)

    cost = (labor_cost + parts_cost + downtime * 15) * age_factor
    cost = round(cost, 2)
    downtime = round(downtime, 2)

    # Status derived (all closed for simplicity; you can extend later)
    status = "Closed"

    requests.append({
        "RequestID": req_id,
        "MachineID": machine_id,
        "Plant": plant,
        "CreatedDate": created.strftime("%Y-%m-%d %H:%M:%S"),
        "StartDate": start.strftime("%Y-%m-%d %H:%M:%S"),
        "EndDate": end.strftime("%Y-%m-%d %H:%M:%S"),
        "Category": category,
        "Priority": priority,
        "Technician": technician,
        "DowntimeHours": downtime,
        "Cost": cost,
        "Status": status
    })

# --------- Write CSVs ----------
with open("machines.csv", "w", newline="", encoding="utf-8") as f:
    writer = csv.DictWriter(f, fieldnames=["MachineID", "MachineType", "InstallationYear", "Plant"])
    writer.writeheader()
    writer.writerows(machines)

with open("maintenance_requests.csv", "w", newline="", encoding="utf-8") as f:
    writer = csv.DictWriter(
        f,
        fieldnames=[
            "RequestID", "MachineID", "Plant",
            "CreatedDate", "StartDate", "EndDate",
            "Category", "Priority", "Technician",
            "DowntimeHours", "Cost", "Status"
        ]
    )
    writer.writeheader()
    writer.writerows(requests)

print("Generated: machines.csv, maintenance_requests.csv")
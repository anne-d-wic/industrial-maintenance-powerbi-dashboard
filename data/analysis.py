import pandas as pd
from ydata_profiling import ProfileReport

# Charger le dataset
df = pd.read_csv("maintenance_requests.csv")

# Aperçu des données
print("First rows:")
print(df.head())

print("\nDataset structure:")
print(df.info())

# Convertir les dates
df["StartDate"] = pd.to_datetime(df["StartDate"])
df["EndDate"] = pd.to_datetime(df["EndDate"])

# Calcul du temps de résolution
df["ResolutionTimeHours"] = (
    df["EndDate"] - df["StartDate"]
).dt.total_seconds() / 3600

# Analyse des priorités
print("\nRequests by priority:")
print(df["Priority"].value_counts())

# Downtime par machine
downtime_by_machine = df.groupby("MachineID")["DowntimeHours"].sum()

print("\nDowntime by machine:")
print(downtime_by_machine)

# Temps moyen de résolution par priorité
resolution_time = df.groupby("Priority")["ResolutionTimeHours"].mean()

print("\nAverage resolution time by priority:")
print(resolution_time)

# Tableau croisé dynamique
pivot = pd.pivot_table(
    df,
    values="DowntimeHours",
    index="MachineID",
    columns="Priority",
    aggfunc="sum"
)

print("\nDowntime pivot table:")
print(pivot)

profile = ProfileReport(
    df,
    title="Maintenance Requests Profiling Report",
    explorative=True
)
profile.to_file("maintenance_requests_profile.html")

print("\nProfiling report generated: maintenance_requests_profile.html")
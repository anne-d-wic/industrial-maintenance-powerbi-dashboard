USE IndustrialMaintenanceDB;
GO

CREATE OR ALTER VIEW dbo.vw_executive_overview AS
SELECT
    MachinePlant AS Plant,
    CreatedMonth,
    COUNT(*) AS TotalMaintenanceRequests,
    SUM(DowntimeHours) AS TotalDowntimeHours,
    SUM(Cost) AS TotalMaintenanceCost,
    AVG(CAST(ResolutionTimeHours AS DECIMAL(10,2))) AS AvgResolutionTimeHours,
    AVG(CASE WHEN IsPreventive = 1 THEN 1.0 ELSE 0.0 END) AS PreventiveMaintenanceRatio
FROM dbo.vw_maintenance_requests_enriched
GROUP BY
    MachinePlant,
    CreatedMonth;
GO

CREATE OR ALTER VIEW dbo.vw_machine_performance AS
SELECT
    MachineID,
    MachineType,
    MachinePlant AS Plant,
    InstallationYear,
    YEAR(GETDATE()) - InstallationYear AS MachineAgeYears,
    CASE
        WHEN YEAR(GETDATE()) - InstallationYear >= 12 THEN 'Old'
        WHEN YEAR(GETDATE()) - InstallationYear >= 6 THEN 'Mid-life'
        ELSE 'Recent'
    END AS MachineAgeBand,
    COUNT(*) AS RequestCount,
    SUM(DowntimeHours) AS TotalDowntimeHours,
    SUM(Cost) AS TotalMaintenanceCost,
    AVG(CAST(ResolutionTimeHours AS DECIMAL(10,2))) AS AvgResolutionTimeHours,
    SUM(CASE WHEN Priority = 'High' THEN 1 ELSE 0 END) AS HighPriorityRequestCount,
    RANK() OVER (ORDER BY SUM(DowntimeHours) DESC) AS DowntimeRank,
    RANK() OVER (ORDER BY SUM(Cost) DESC) AS CostRank
FROM dbo.vw_maintenance_requests_enriched
GROUP BY
    MachineID,
    MachineType,
    MachinePlant,
    InstallationYear;
GO

CREATE OR ALTER VIEW dbo.vw_operational_performance AS
SELECT
    Technician,
    Priority,
    PriorityRank,
    CreatedMonth,
    COUNT(*) AS RequestCount,
    SUM(DowntimeHours) AS TotalDowntimeHours,
    SUM(Cost) AS TotalMaintenanceCost,
    AVG(CAST(ResolutionTimeHours AS DECIMAL(10,2))) AS AvgResolutionTimeHours
FROM dbo.vw_maintenance_requests_enriched
GROUP BY
    Technician,
    Priority,
    PriorityRank,
    CreatedMonth;
GO

CREATE OR ALTER VIEW dbo.vw_priority_resolution AS
SELECT
    Priority,
    PriorityRank,
    COUNT(*) AS RequestCount,
    AVG(CAST(ResolutionTimeHours AS DECIMAL(10,2))) AS AvgResolutionTimeHours,
    AVG(CAST(StartDelayHours AS DECIMAL(10,2))) AS AvgStartDelayHours
FROM dbo.vw_maintenance_requests_enriched
GROUP BY
    Priority,
    PriorityRank;
GO

CREATE OR ALTER VIEW dbo.vw_maintenance_mix AS
SELECT
    Category,
    COUNT(*) AS RequestCount,
    SUM(DowntimeHours) AS TotalDowntimeHours,
    SUM(Cost) AS TotalMaintenanceCost,
    AVG(CAST(ResolutionTimeHours AS DECIMAL(10,2))) AS AvgResolutionTimeHours
FROM dbo.vw_maintenance_requests_enriched
GROUP BY Category;
GO

CREATE OR ALTER VIEW dbo.vw_plant_monthly_trend AS
SELECT
    MachinePlant AS Plant,
    CreatedMonth,
    COUNT(*) AS RequestCount,
    SUM(DowntimeHours) AS TotalDowntimeHours,
    SUM(Cost) AS TotalMaintenanceCost
FROM dbo.vw_maintenance_requests_enriched
GROUP BY
    MachinePlant,
    CreatedMonth;
GO
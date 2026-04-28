USE IndustrialMaintenanceDB;
GO

CREATE OR ALTER VIEW dbo.vw_maintenance_requests_enriched AS
SELECT
    r.RequestID,
    r.MachineID,
    m.MachineType,
    m.Plant AS MachinePlant,
    r.Plant AS RequestPlant,
    m.InstallationYear,
    YEAR(r.CreatedDate) - m.InstallationYear AS MachineAgeYears,
    r.CreatedDate,
    r.StartDate,
    r.EndDate,
    CAST(r.CreatedDate AS DATE) AS CreatedDay,
    DATEFROMPARTS(YEAR(r.CreatedDate), MONTH(r.CreatedDate), 1) AS CreatedMonth,
    YEAR(r.CreatedDate) AS CreatedYear,
    MONTH(r.CreatedDate) AS CreatedMonthNumber,
    DATENAME(MONTH, r.CreatedDate) AS CreatedMonthName,
    r.Category,
    r.Priority,
    CASE
        WHEN r.Priority = 'High' THEN 1
        WHEN r.Priority = 'Medium' THEN 2
        WHEN r.Priority = 'Low' THEN 3
        ELSE 4
    END AS PriorityRank,
    r.Technician,
    r.DowntimeHours,
    r.Cost,
    r.Status,
    DATEDIFF(HOUR, r.StartDate, r.EndDate) AS ResolutionTimeHours,
    DATEDIFF(HOUR, r.CreatedDate, r.StartDate) AS StartDelayHours,
    CASE WHEN r.Category = 'Preventive' THEN 1 ELSE 0 END AS IsPreventive,
    CASE WHEN r.Category = 'Corrective' THEN 1 ELSE 0 END AS IsCorrective,
    CASE
        WHEN YEAR(r.CreatedDate) - m.InstallationYear >= 12 THEN 'Old'
        WHEN YEAR(r.CreatedDate) - m.InstallationYear >= 6 THEN 'Mid-life'
        ELSE 'Recent'
    END AS MachineAgeBand,
    CASE
        WHEN r.DowntimeHours >= 12 THEN 'High downtime'
        WHEN r.DowntimeHours >= 4 THEN 'Medium downtime'
        ELSE 'Low downtime'
    END AS DowntimeBand
FROM dbo.stg_maintenance_requests r
INNER JOIN dbo.stg_machines m
    ON r.MachineID = m.MachineID;
GO
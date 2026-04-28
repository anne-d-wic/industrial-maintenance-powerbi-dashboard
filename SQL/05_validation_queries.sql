USE IndustrialMaintenanceDB;
GO

SELECT COUNT(*) AS SourceMachineCount
FROM dbo.stg_machines;

SELECT COUNT(*) AS SourceRequestCount
FROM dbo.stg_maintenance_requests;

SELECT COUNT(*) AS EnrichedRequestCount
FROM dbo.vw_maintenance_requests_enriched;

SELECT SUM(DowntimeHours) AS SourceDowntimeHours
FROM dbo.stg_maintenance_requests;

SELECT SUM(DowntimeHours) AS EnrichedDowntimeHours
FROM dbo.vw_maintenance_requests_enriched;

SELECT TOP 10
    MachineID,
    SUM(DowntimeHours) AS TotalDowntimeHours
FROM dbo.vw_maintenance_requests_enriched
GROUP BY MachineID
ORDER BY TotalDowntimeHours DESC;

SELECT TOP 10 *
FROM dbo.vw_executive_overview
ORDER BY CreatedMonth DESC;

SELECT TOP 10 *
FROM dbo.vw_machine_performance
ORDER BY DowntimeRank ASC;

SELECT TOP 10 *
FROM dbo.vw_operational_performance
ORDER BY CreatedMonth DESC;
GO
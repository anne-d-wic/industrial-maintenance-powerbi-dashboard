USE IndustrialMaintenanceDB;
GO

/*
Step 1 in SSMS:
- Right-click the database IndustrialMaintenanceDB
- Go to Tasks > Import Flat File
- Import machines.csv into dbo.stg_machines
- Import maintenance_requests.csv into dbo.stg_maintenance_requests

Optional alternative:
- Use BULK INSERT if your SQL Server instance can access the local file path.

Update the paths below if you choose the BULK INSERT route.
*/

/*
BULK INSERT dbo.stg_machines
FROM 'C:\Users\annew\Documents\ANIA\Formations\industrial-dashboard-project\machines.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001',
    TABLOCK
);

BULK INSERT dbo.stg_maintenance_requests
FROM 'C:\Users\annew\Documents\ANIA\Formations\industrial-dashboard-project\maintenance_requests.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    CODEPAGE = '65001',
    TABLOCK
);
*/

SELECT COUNT(*) AS MachineCount FROM dbo.stg_machines;
SELECT COUNT(*) AS RequestCount FROM dbo.stg_maintenance_requests;
GO
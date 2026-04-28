IF DB_ID('IndustrialMaintenanceDB') IS NULL
BEGIN
    CREATE DATABASE IndustrialMaintenanceDB;
END;
GO

USE IndustrialMaintenanceDB;
GO

IF OBJECT_ID('dbo.stg_maintenance_requests', 'U') IS NOT NULL
    DROP TABLE dbo.stg_maintenance_requests;
GO

IF OBJECT_ID('dbo.stg_machines', 'U') IS NOT NULL
    DROP TABLE dbo.stg_machines;
GO

CREATE TABLE dbo.stg_machines (
    MachineID VARCHAR(20) NOT NULL PRIMARY KEY,
    MachineType VARCHAR(50) NULL,
    InstallationYear INT NULL,
    Plant VARCHAR(50) NULL
);
GO

CREATE TABLE dbo.stg_maintenance_requests (
    RequestID VARCHAR(20) NOT NULL PRIMARY KEY,
    MachineID VARCHAR(20) NOT NULL,
    Plant VARCHAR(50) NULL,
    CreatedDate DATETIME NULL,
    StartDate DATETIME NULL,
    EndDate DATETIME NULL,
    Category VARCHAR(20) NULL,
    Priority VARCHAR(20) NULL,
    Technician VARCHAR(50) NULL,
    DowntimeHours DECIMAL(10,2) NULL,
    Cost DECIMAL(12,2) NULL,
    Status VARCHAR(20) NULL
);
GO

ALTER TABLE dbo.stg_maintenance_requests
ADD CONSTRAINT FK_stg_maintenance_requests_machines
FOREIGN KEY (MachineID) REFERENCES dbo.stg_machines (MachineID);
GO
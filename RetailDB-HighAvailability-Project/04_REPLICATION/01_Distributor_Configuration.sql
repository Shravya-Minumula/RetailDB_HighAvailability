-- Configure the Distributor for Replication (T-SQL Script)
-- Server: SHRAVYA-REDDY\SERVER02

-- Step 1: Install the server as a Distributor
USE [master];
GO

EXEC sp_adddistributor 
    @distributor = N'SHRAVYA-REDDY\SERVER02', 
    @password = N'';  -- Leave empty or securely pass the password
GO

-- Step 2: Add the Distribution database
EXEC sp_adddistributiondb 
    @database = N'Distribution_RetailDB',
    @data_folder = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SERVER02\MSSQL\Data',
    @log_folder = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SERVER02\MSSQL\Data',
    @log_file_size = 2,
    @min_distretention = 0,
    @max_distretention = 72,
    @history_retention = 48,
    @deletebatchsize_xact = 5000,
    @deletebatchsize_cmd = 2000,
    @security_mode = 1;  -- Windows Authentication
GO

-- Step 3: Set the snapshot folder path as an extended property
USE [Distribution_RetailDB];
GO

IF NOT EXISTS (
    SELECT * FROM sysobjects 
    WHERE name = 'UIProperties' AND type = 'U'
)
    CREATE TABLE UIProperties (id INT);

IF EXISTS (
    SELECT * FROM ::fn_listextendedproperty('SnapshotFolder', 'user', 'dbo', 'table', 'UIProperties', NULL, NULL)
)
    EXEC sp_updateextendedproperty 
        @name = N'SnapshotFolder', 
        @value = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SERVER02\MSSQL\ReplData',
        @level0type = N'user', @level0name = dbo,
        @level1type = N'table', @level1name = 'UIProperties';
ELSE
    EXEC sp_addextendedproperty 
        @name = N'SnapshotFolder', 
        @value = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SERVER02\MSSQL\ReplData',
        @level0type = N'user', @level0name = dbo,
        @level1type = N'table', @level1name = 'UIProperties';
GO

-- Step 4: Register the Publisher with the Distributor
EXEC sp_adddistpublisher 
    @publisher = N'SHRAVYA-REDDY\SERVER01',
    @distribution_db = N'Distribution_RetailDB',
    @security_mode = 1,  -- Windows Authentication
    @working_directory = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SERVER02\MSSQL\ReplData',
    @trusted = N'false',
    @thirdparty_flag = 0,
    @publisher_type = N'MSSQLSERVER';
GO

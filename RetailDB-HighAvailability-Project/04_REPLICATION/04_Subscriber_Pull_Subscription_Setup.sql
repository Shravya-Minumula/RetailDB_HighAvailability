-- Configure Pull Subscription (Subscriber)
-- Server: SHRAVYA-REDDY\SERVER02

USE [Retail_DB_SUB];
GO

-- Step 1: Create the Pull Subscription
EXEC sp_addpullsubscription 
    @publisher = N'SHRAVYA-REDDY\SERVER01',
    @publication = N'Publication_RetailDB',
    @publisher_db = N'RetailDB',
    @independent_agent = N'True',
    @subscription_type = N'pull',
    @description = N'Pull Subscription from Publisher to Subscriber',
    @update_mode = N'read only',
    @immediate_sync = 1;
GO

-- Step 2: Create the Subscription Agent Job
EXEC sp_addpullsubscription_agent 
    @publisher = N'SHRAVYA-REDDY\SERVER01',
    @publisher_db = N'RetailDB',
    @publication = N'Publication_RetailDB',
    @distributor = N'SHRAVYA-REDDY\SERVER02',
    @distributor_security_mode = 1,
    @enabled_for_syncmgr = N'False',
    @frequency_type = 64, -- Start automatically with SQL Server Agent
    @frequency_interval = 0,
    @frequency_relative_interval = 0,
    @frequency_recurrence_factor = 0,
    @frequency_subday = 0,
    @frequency_subday_interval = 0,
    @active_start_time_of_day = 0,
    @active_end_time_of_day = 235959,
    @active_start_date = 0,
    @active_end_date = 0,
    @publication_type = 0;
GO

-- Confirm Subscription from Publisher Side
-- Server: SHRAVYA-REDDY\SERVER01

USE [RetailDB];
GO

EXEC sp_addsubscription 
    @publication = N'Publication_RetailDB',
    @subscriber = N'SHRAVYA-REDDY\SERVER02',
    @destination_db = N'Retail_DB_SUB',
    @sync_type = N'Automatic',
    @subscription_type = N'pull',
    @update_mode = N'read only';
GO

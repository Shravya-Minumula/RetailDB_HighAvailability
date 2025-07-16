-- Check Replication Monitor summary
EXEC sp_replmonitorhelpsubscriptionpendingcmds 
    @publisher = N'SHRAVYA-REDDY\SERVER01',
    @publisher_db = N'RetailDB',
    @publication = N'Publication_RetailDB',
    @subscriber = N'SHRAVYA-REDDY\SERVER02',
    @subscriber_db = N'Retail_DB_SUB';
GO

-- Check replication agents history (if jobs exist)
EXEC msdb.dbo.sp_help_jobhistory @job_name = 'Log Reader Agent for Publication_RetailDB';
GO

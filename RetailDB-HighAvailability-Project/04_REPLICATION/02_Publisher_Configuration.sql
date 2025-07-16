-- Configure the Publisher for Replication
-- Publisher Server: SHRAVYA-REDDY\SERVER01

-- Step 1: Add Distributor info (if not already present)
USE [master];
GO

EXEC sp_adddistributor 
    @distributor = N'SHRAVYA-REDDY\SERVER02', 
    @password = N''; 
GO

-- Step 2: Add Subscriber record
EXEC sp_addsubscriber 
    @subscriber = N'SHRAVYA-REDDY\SERVER02', 
    @type = 0, 
    @description = N''; 
GO

-- Step 3: Enable the database for publishing
EXEC sp_replicationdboption 
    @dbname = N'RetailDB', 
    @optname = N'publish', 
    @value = N'true'; 
GO

-- Step 4: Add the Log Reader and Queue Reader Agents
EXEC [RetailDB].sys.sp_addlogreader_agent 
    @job_login = NULL, 
    @job_password = NULL, 
    @publisher_security_mode = 1;
GO

EXEC [RetailDB].sys.sp_addqreader_agent 
    @job_login = NULL, 
    @job_password = NULL, 
    @frompublisher = 1;
GO

-- Step 5: Create the transactional publication
USE [RetailDB];
GO

EXEC sp_addpublication 
    @publication = N'Publication_RetailDB',
    @description = N'Transactional publication of database ''RetailDB'' from Publisher ''SHRAVYA-REDDY\SERVER01''.',
    @sync_method = N'concurrent',
    @retention = 0,
    @allow_push = N'true',
    @allow_pull = N'true',
    @allow_anonymous = N'true',
    @enabled_for_internet = N'false',
    @snapshot_in_defaultfolder = N'true',
    @compress_snapshot = N'false',
    @ftp_port = 21,
    @ftp_login = N'anonymous',
    @allow_subscription_copy = N'false',
    @add_to_active_directory = N'false',
    @repl_freq = N'continuous',
    @status = N'active',
    @independent_agent = N'true',
    @immediate_sync = N'true',
    @allow_sync_tran = N'false',
    @autogen_sync_procs = N'false',
    @allow_queued_tran = N'false',
    @allow_dts = N'false',
    @replicate_ddl = 1,
    @allow_initialize_from_backup = N'false',
    @enabled_for_p2p = N'false',
    @enabled_for_het_sub = N'false';
GO

-- Step 6: Create the Snapshot Agent job
EXEC sp_addpublication_snapshot 
    @publication = N'Publication_RetailDB',
    @frequency_type = 1,
    @frequency_interval = 0,
    @frequency_relative_interval = 0,
    @frequency_recurrence_factor = 0,
    @frequency_subday = 0,
    @frequency_subday_interval = 0,
    @active_start_time_of_day = 0,
    @active_end_time_of_day = 235959,
    @active_start_date = 0,
    @active_end_date = 0,
    @job_login = NULL,
    @job_password = NULL,
    @publisher_security_mode = 1;
GO

-- Step 7: Grant access to snapshot agents
EXEC sp_grant_publication_access @publication = N'Publication_RetailDB', @login = N'sa';
EXEC sp_grant_publication_access @publication = N'Publication_RetailDB', @login = N'NT AUTHORITY\SYSTEM';
EXEC sp_grant_publication_access @publication = N'Publication_RetailDB', @login = N'SHRAVYA-REDDY\manik';
EXEC sp_grant_publication_access @publication = N'Publication_RetailDB', @login = N'NT SERVICE\SQLAgent$SERVER01';
EXEC sp_grant_publication_access @publication = N'Publication_RetailDB', @login = N'NT SERVICE\Winmgmt';
EXEC sp_grant_publication_access @publication = N'Publication_RetailDB', @login = N'NT SERVICE\SQLWriter';
EXEC sp_grant_publication_access @publication = N'Publication_RetailDB', @login = N'NT SERVICE\MSSQL$SERVER01';
GO

-- Step 8: Add articles (tables) to the publication
-- Repeat for each table

-- Example for table: AuditLog
EXEC sp_addarticle 
    @publication = N'Publication_RetailDB', 
    @article = N'AuditLog', 
    @source_owner = N'dbo', 
    @source_object = N'AuditLog', 
    @type = N'logbased', 
    @pre_creation_cmd = N'drop', 
    @schema_option = 0x000000000803509F, 
    @identityrangemanagementoption = N'manual', 
    @destination_table = N'AuditLog', 
    @destination_owner = N'dbo',
    @status = 24,
    @vertical_partition = N'false',
    @ins_cmd = N'CALL [sp_MSins_dboAuditLog]', 
    @del_cmd = N'CALL [sp_MSdel_dboAuditLog]', 
    @upd_cmd = N'SCALL [sp_MSupd_dboAuditLog]';
GO

EXEC sp_addarticle 
    @publication = N'Publication_RetailDB', 
    @article = N'Customers', 
    @source_owner = N'dbo', 
    @source_object = N'Customers', 
    @type = N'logbased', 
    @pre_creation_cmd = N'drop', 
    @schema_option = 0x000000000803509F, 
    @identityrangemanagementoption = N'manual', 
    @destination_table = N'Customers', 
    @destination_owner = N'dbo',
    @status = 24,
    @vertical_partition = N'false',
    @ins_cmd = N'CALL [sp_MSins_dboCustomers]', 
    @del_cmd = N'CALL [sp_MSdel_dboCustomers]', 
    @upd_cmd = N'SCALL [sp_MSupd_dboCustomers]';
GO

EXEC sp_addarticle 
    @publication = N'Publication_RetailDB', 
    @article = N'Employees', 
    @source_owner = N'dbo', 
    @source_object = N'Employees', 
    @type = N'logbased', 
    @pre_creation_cmd = N'drop', 
    @schema_option = 0x000000000803509F, 
    @identityrangemanagementoption = N'manual', 
    @destination_table = N'Employees', 
    @destination_owner = N'dbo',
    @status = 24,
    @vertical_partition = N'false',
    @ins_cmd = N'CALL [sp_MSins_dboEmployees]', 
    @del_cmd = N'CALL [sp_MSdel_dboEmployees]', 
    @upd_cmd = N'SCALL [sp_MSupd_dboEmployees]';
GO

EXEC sp_addarticle 
    @publication = N'Publication_RetailDB', 
    @article = N'Inventory', 
    @source_owner = N'dbo', 
    @source_object = N'Inventory', 
    @type = N'logbased', 
    @pre_creation_cmd = N'drop', 
    @schema_option = 0x000000000803509F, 
    @identityrangemanagementoption = N'manual', 
    @destination_table = N'Inventory', 
    @destination_owner = N'dbo',
    @status = 24,
    @vertical_partition = N'false',
    @ins_cmd = N'CALL [sp_MSins_dboInventory]', 
    @del_cmd = N'CALL [sp_MSdel_dboInventory]', 
    @upd_cmd = N'SCALL [sp_MSupd_dboInventory]';
GO

EXEC sp_addarticle 
    @publication = N'Publication_RetailDB', 
    @article = N'Products', 
    @source_owner = N'dbo', 
    @source_object = N'Products', 
    @type = N'logbased', 
    @pre_creation_cmd = N'drop', 
    @schema_option = 0x000000000803509F, 
    @identityrangemanagementoption = N'manual', 
    @destination_table = N'Products', 
    @destination_owner = N'dbo',
    @status = 24,
    @vertical_partition = N'false',
    @ins_cmd = N'CALL [sp_MSins_dboProducts]', 
    @del_cmd = N'CALL [sp_MSdel_dboProducts]', 
    @upd_cmd = N'SCALL [sp_MSupd_dboProducts]';
GO

EXEC sp_addarticle 
    @publication = N'Publication_RetailDB', 
    @article = N'Sales', 
    @source_owner = N'dbo', 
    @source_object = N'Sales', 
    @type = N'logbased', 
    @pre_creation_cmd = N'drop', 
    @schema_option = 0x000000000803509F, 
    @identityrangemanagementoption = N'manual', 
    @destination_table = N'Sales', 
    @destination_owner = N'dbo',
    @status = 24,
    @vertical_partition = N'false',
    @ins_cmd = N'CALL [sp_MSins_dboSales]', 
    @del_cmd = N'CALL [sp_MSdel_dboSales]', 
    @upd_cmd = N'SCALL [sp_MSupd_dboSales]';
GO

EXEC sp_addarticle 
    @publication = N'Publication_RetailDB', 
    @article = N'SalesDetails', 
    @source_owner = N'dbo', 
    @source_object = N'SalesDetails', 
    @type = N'logbased', 
    @pre_creation_cmd = N'drop', 
    @schema_option = 0x000000000803509F, 
    @identityrangemanagementoption = N'manual', 
    @destination_table = N'SalesDetails', 
    @destination_owner = N'dbo',
    @status = 24,
    @vertical_partition = N'false',
    @ins_cmd = N'CALL [sp_MSins_dboSalesDetails]', 
    @del_cmd = N'CALL [sp_MSdel_dboSalesDetails]', 
    @upd_cmd = N'SCALL [sp_MSupd_dboSalesDetails]';
GO

EXEC sp_addarticle 
    @publication = N'Publication_RetailDB', 
    @article = N'Stores', 
    @source_owner = N'dbo', 
    @source_object = N'Stores', 
    @type = N'logbased', 
    @pre_creation_cmd = N'drop', 
    @schema_option = 0x000000000803509F, 
    @identityrangemanagementoption = N'manual', 
    @destination_table = N'Stores', 
    @destination_owner = N'dbo',
    @status = 24,
    @vertical_partition = N'false',
    @ins_cmd = N'CALL [sp_MSins_dboStores]', 
    @del_cmd = N'CALL [sp_MSdel_dboStores]', 
    @upd_cmd = N'SCALL [sp_MSupd_dboStores]';
GO

EXEC sp_addarticle 
    @publication = N'Publication_RetailDB', 
    @article = N'Suppliers', 
    @source_owner = N'dbo', 
    @source_object = N'Suppliers', 
    @type = N'logbased', 
    @pre_creation_cmd = N'drop', 
    @schema_option = 0x000000000803509F, 
    @identityrangemanagementoption = N'manual', 
    @destination_table = N'Suppliers', 
    @destination_owner = N'dbo',
    @status = 24,
    @vertical_partition = N'false',
    @ins_cmd = N'CALL [sp_MSins_dboSuppliers]', 
    @del_cmd = N'CALL [sp_MSdel_dboSuppliers]', 
    @upd_cmd = N'SCALL [sp_MSupd_dboSuppliers]';
GO


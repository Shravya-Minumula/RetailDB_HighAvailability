-- Backup the Principal Database on S1
BACKUP DATABASE RetailDB
TO DISK = 'C:\Backup\RetailDB_Full.bak'
WITH FORMAT;

-- Backup the Log File
BACKUP LOG RetailDB
TO DISK = 'C:\Backup\RetailDB_Log.trn';

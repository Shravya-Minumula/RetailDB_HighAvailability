-- Restore Full Backup on Mirror Server S2
RESTORE DATABASE RetailDB
FROM DISK = 'C:\Backup\RetailDB_Full.bak'
WITH NORECOVERY;

-- Restore Log Backup on Mirror Server S2
RESTORE LOG RetailDB
FROM DISK = 'C:\Backup\RetailDB_Log.trn'
WITH NORECOVERY;

---Check current roles after failover

SELECT
    DB_NAME(database_id) AS DatabaseName,
    mirroring_state_desc,
    mirroring_role_desc,
    mirroring_safety_level_desc
FROM sys.database_mirroring
WHERE DB_NAME(database_id) = 'RetailDB';

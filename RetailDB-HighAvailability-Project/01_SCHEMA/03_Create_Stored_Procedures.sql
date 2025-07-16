---creating stored procedures for monitoring mirror status
CREATE PROCEDURE usp_GetMirroringStatus
AS
BEGIN
    SELECT 
        database_id,
        DB_NAME(database_id) AS DatabaseName,
        mirroring_state_desc,
        mirroring_role_desc,
        mirroring_partner_name,
        mirroring_safety_level_desc,
        mirroring_witness_name,
        mirroring_witness_state_desc
    FROM sys.database_mirroring
    WHERE mirroring_guid IS NOT NULL;
END;

---To get the result
EXEC usp_GetMirroringStatus;


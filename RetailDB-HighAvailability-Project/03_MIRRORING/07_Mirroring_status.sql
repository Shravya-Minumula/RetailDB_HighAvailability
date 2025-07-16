---Mirroring Status
---Run this on both principal and mirror servers to verify the mirroring status and roles

SELECT
    DB_NAME(database_id) AS DatabaseName,
    mirroring_state_desc AS MirroringState,
    mirroring_role_desc AS MirroringRole,
    mirroring_safety_level_desc AS SafetyLevel,
    mirroring_partner_name AS PartnerServer,
    mirroring_witness_name AS WitnessServer,
    mirroring_safety_sequence AS SafetySequence,
    mirroring_failover_lsn AS FailoverLSN
FROM sys.database_mirroring
WHERE DB_NAME(database_id) = 'RetailDB';

# Retail Inventory System using SQL Server Mirroring and Replication
---

## Project Overview 

This project demonstrates a **Retail Database System** implemented in **SQL Server** with a focus on **High Availability** using two enterprise-grade techniques:

-  **Database Mirroring**
-  **Transactional Replication**

The goal of this project is to simulate real-world database reliability, data redundancy, and read scalability for a retail business with distributed operations.

This repository contains:
- Full schema scripts for database creation
- Sample data inserts
- T-SQL scripts to configure both **Mirroring** and **Replication**
- Visual documentation through screenshots and ER diagrams


##  Technologies Used 

- Microsoft SQL Server 2022
- SQL Server Management Studio (SSMS)
- T-SQL Scripting
- Database Mirroring (Principal, Mirror, Witness)
- Transactional Replication (Distributor, Publisher, Subscriber)


##  Database Schema Overview 

| **Table Name**     | **Description**                                                                 |
|--------------------|---------------------------------------------------------------------------------|
| `Stores`           | Stores details such as name and location                                       |
| `Employees`        | Employees working at different store locations                                 |
| `Customers`        | Customers with contact information                                             |
| `Suppliers`        | Vendors supplying products to the store                                        |
| `Products`         | List of items sold by the retail business                                      |
| `Inventory`        | Tracks available quantity of each product at each store                        |
| `Sales`            | Master sales table recording store, customer, employee, and total amount       |
| `SalesDetails`     | Line-item details for each sale including quantity and unit price              |
| `AuditLog`         | Logs important system events and data changes                                  |

##  Database Mirroring

**Mirroring** is a high-availability solution in SQL Server that maintains two identical copies of a database on separate servers. It provides automatic or manual failover capabilities, ensuring business continuity and minimal downtime in case of a failure.


###  Concepts Implemented

| **Component**      | **Description**                                                                                                                                 |
|--------------------|--------------------------------------------------------------------------------------------------------------------------------------------------|
| **Principal Server** | The main server that actively handles client requests and performs database transactions.                                                      |
| **Mirror Server**    | A standby server that continuously receives transaction logs from the principal and maintains a synchronized copy of the database.             |
| **Witness Server**   | A third optional server that enables automatic failover by monitoring the health of the principal server.                                      |


### Configuration Details

- **Configured High-Safety Mode with Automatic Failover**  
  Ensures that transactions are committed on both the principal and mirror servers, enabling synchronous data transfer. With a witness server in place, automatic failover occurs when the principal becomes unavailable.

- **TCP Endpoints for Communication**  
  Secure communication channels (TCP endpoints) were created on each server to facilitate reliable and secure transmission of transaction logs between the principal and mirror servers.

- **Manual Failover (Validation)**  
  Manual failover was performed to validate the configuration and ensure that the mirror server can seamlessly take over when the principal is offline. This confirms the failover readiness.

- **Real-time Mirroring Status and Role Monitoring**  
  Custom queries were used to monitor the mirroring state, role (principal/mirror), synchronization status, and potential issues. This helps DBAs track the health and effectiveness of the mirroring setup.

###  Key Queries used in Mirroring 
-- Check current mirroring state

```sql
SELECT
    database_id,
    database_name = RetailDB(database_id),
    mirroring_state_desc,
    mirroring_role_desc,
    mirroring_partner_name 
FROM sys.database_mirroring
WHERE mirroring_guid IS NOT NULL;
```

-- Manual failover
```sql
ALTER DATABASE RetailDB SET PARTNER FAILOVER;
```

##  Replication Process

**Replication** in SQL Server is a data distribution technique that ensures consistency and availability by replicating data from a primary database (Publisher) to one or more secondary databases (Subscribers). This supports use cases like reporting, load balancing, and disaster recovery.



###  Servers Involved in Replication

| **Server Role**   | **Description**                                                                                                                                   |
|-------------------|----------------------------------------------------------------------------------------------------------------------------------------------------|
| **Distributor**   | Manages the distribution database, stores replication metadata, and coordinates replication jobs. Configured on the primary server.              |
| **Publisher**     | The primary server that owns the source data and publishes it to subscribers. In this project, it hosts the `RetailDB` and pushes changes.       |
| **Subscriber**    | The secondary server(s) that receive replicated data from the publisher. The subscriber holds a synchronized copy of the `RetailDB` database.     |


###  Replication Model Used

- **Transactional Replication with Pull Subscription**  
  In this model, the **subscriber** initiates the synchronization process by pulling changes from the **publisher**. This setup is ideal for high-performance and low-latency replication of transactional data.


###  Key Queries Used in Replication

--  List all publications on the publisher server
```sql
EXEC sp_helppublication;
```
--  Check the status of replication agents on the distributor
```sql
EXEC sp_replmonitorhelppublisher;
```
--  Verify replicated data at the subscriber
```sql
SELECT TOP 10 * FROM RetailDB.dbo.Products;
````
##  Conclusion

This project demonstrates high availability and data redundancy using SQL Server **Database Mirroring** and **Transactional Replication**.

- Configured **High-Safety Mode Mirroring** with Principal, Mirror, and Witness servers enabling automatic failover.
- Implemented **Transactional Replication** with Pull Subscription for efficient data distribution.
- Automated setup and monitoring using T-SQL scripts.
- Ensured real-time synchronization and fault tolerance across servers.
- Developed skills in backup/restore, endpoint configuration, replication setup, and job monitoring.
- Provided a solid foundation for enterprise-level SQL Server high availability solutions.

---

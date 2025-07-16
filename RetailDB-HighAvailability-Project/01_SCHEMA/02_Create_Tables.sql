-- STORES TABLE
CREATE TABLE Stores (
    StoreID INT PRIMARY KEY IDENTITY(1,1),
    StoreName NVARCHAR(100),
    Location NVARCHAR(150)
);

-- EMPLOYEES TABLE
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100),
    Position NVARCHAR(50),
    StoreID INT FOREIGN KEY REFERENCES Stores(StoreID)
);

-- CUSTOMERS TABLE
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100),
    Email NVARCHAR(100),
    Phone NVARCHAR(15)
);

-- SUPPLIERS TABLE
CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY IDENTITY(1,1),
    SupplierName NVARCHAR(100),
    ContactPerson NVARCHAR(100),
    Phone NVARCHAR(30),
    Email NVARCHAR(100)
);

-- PRODUCTS TABLE
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(100),
    Category NVARCHAR(50),
    UnitPrice DECIMAL(10,2),
    SupplierID INT FOREIGN KEY REFERENCES Suppliers(SupplierID)
);

-- INVENTORY TABLE
CREATE TABLE Inventory (
    InventoryID INT PRIMARY KEY IDENTITY(1,1),
    StoreID INT FOREIGN KEY REFERENCES Stores(StoreID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    QuantityAvailable INT
);

-- SALES TABLE (main sales record)
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    StoreID INT FOREIGN KEY REFERENCES Stores(StoreID),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    EmployeeID INT FOREIGN KEY REFERENCES Employees(EmployeeID),
    SaleDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2)
);

-- SALESDETAILS TABLE (line items for each sale)
CREATE TABLE SalesDetails (
    SalesDetailID INT PRIMARY KEY IDENTITY(1,1),
    SaleID INT FOREIGN KEY REFERENCES Sales(SaleID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    LineTotal AS (Quantity * UnitPrice) PERSISTED
);

-- AuditLog Table
CREATE TABLE AuditLog (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    EventType NVARCHAR(100),
    Description NVARCHAR(255),
    EventTime DATETIME DEFAULT GETDATE()
);

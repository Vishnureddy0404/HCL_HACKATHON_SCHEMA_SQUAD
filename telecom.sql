-- ============================================
-- TELECOM CDR DATA MART — STAR SCHEMA
-- ============================================

-- 1. DIMENSION TABLE: Date_Dim
CREATE TABLE Date_Dim (
    DateKey       INT          NOT NULL,
    FullDate      DATE         NOT NULL,
    Day           INT          NOT NULL CHECK (Day BETWEEN 1 AND 31),
    Month         INT          NOT NULL CHECK (Month BETWEEN 1 AND 12),
    Year          INT          NOT NULL CHECK (Year >= 2000),
    Hour          INT          NOT NULL CHECK (Hour BETWEEN 0 AND 23),
    CONSTRAINT PK_Date_Dim PRIMARY KEY (DateKey)
);

-- 2. DIMENSION TABLE: Customer_Dim
CREATE TABLE Customer_Dim (
    CustomerKey   INT          NOT NULL,
    PhoneNumber   VARCHAR(15)  NOT NULL,
    CustomerName  VARCHAR(100) NOT NULL,
    PlanType      VARCHAR(50)  NOT NULL,
    CONSTRAINT PK_Customer_Dim PRIMARY KEY (CustomerKey),
    CONSTRAINT UQ_PhoneNumber  UNIQUE (PhoneNumber)
);

-- 3. DIMENSION TABLE: Tower_Dim
CREATE TABLE Tower_Dim (
    TowerKey      INT          NOT NULL,
    TowerID       VARCHAR(10)  NOT NULL,
    Region        VARCHAR(50)  NOT NULL,
    City          VARCHAR(50)  NOT NULL,
    CONSTRAINT PK_Tower_Dim PRIMARY KEY (TowerKey),
    CONSTRAINT UQ_TowerID   UNIQUE (TowerID)
);

-- 4. FACT TABLE: CDR_Fact
-- All FK columns use INT to match PK in each Dim table
CREATE TABLE CDR_Fact (
    CallID          VARCHAR(10)    NOT NULL,
    CustomerKey     INT            NOT NULL,
    TowerKey        INT            NOT NULL,
    DateKey         INT            NOT NULL,
    Duration        INT            NOT NULL DEFAULT 0,
    Revenue         DECIMAL(10,2)  NOT NULL DEFAULT 0.00,
    IsInternational INT            NOT NULL DEFAULT 0,
    CallType        VARCHAR(10)    NOT NULL,
    CONSTRAINT PK_CDR_Fact        PRIMARY KEY (CallID),
    CONSTRAINT FK_CDR_Customer    FOREIGN KEY (CustomerKey)
                                  REFERENCES Customer_Dim(CustomerKey),
    CONSTRAINT FK_CDR_Tower       FOREIGN KEY (TowerKey)
                                  REFERENCES Tower_Dim(TowerKey),
    CONSTRAINT FK_CDR_Date        FOREIGN KEY (DateKey)
                                  REFERENCES Date_Dim(DateKey),
    CONSTRAINT CHK_Duration       CHECK (Duration >= 0),
    CONSTRAINT CHK_Revenue        CHECK (Revenue >= 0),
    CONSTRAINT CHK_IsInternational CHECK (IsInternational IN (0, 1)),
    CONSTRAINT CHK_CallType       CHECK (CallType IN ('LOCAL', 'STD', 'INT'))
);
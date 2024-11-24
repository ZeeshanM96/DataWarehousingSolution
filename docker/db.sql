-- Script for tables and indexes creation

-- Drop existing tables if they exist
DROP TABLE IF EXISTS Order_Status;
DROP TABLE IF EXISTS Order_Items;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Preferences;
DROP TABLE IF EXISTS Members;
DROP TABLE IF EXISTS Marketing;

-- Create tables
CREATE TABLE Marketing (
    CampaignID VARCHAR PRIMARY KEY,
    TargetAudience VARCHAR,
    StoreID VARCHAR,
    CampaignStartDate DATE,
    CampaignEndDate DATE
);

CREATE TABLE Members (
    MemberID VARCHAR PRIMARY KEY,
    Name VARCHAR,
    MembershipType VARCHAR,
    JoinDate DATE,
    ExpirationDate DATE
);

CREATE TABLE Preferences (
    MemberID VARCHAR,
    Preference VARCHAR,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

CREATE TABLE Orders (
    OrderID VARCHAR PRIMARY KEY,
    MemberID VARCHAR,
    StoreID VARCHAR,
    CampaignID VARCHAR NULL,
    OrderDate DATE,
    SubTotal FLOAT,
    Total FLOAT,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (CampaignID) REFERENCES Marketing (CampaignID)
);

CREATE TABLE Order_Items (
    OrderID VARCHAR,
    ItemName VARCHAR,
    Price FLOAT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

CREATE TABLE Order_Status (
    OrderID VARCHAR,
    Status VARCHAR,
    StatusTimestamp TIMESTAMP,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Create Indexing
CREATE INDEX idx_memberid_orders ON Orders(MemberID);
CREATE INDEX idx_campaignid_orders ON Orders(CampaignID);
CREATE INDEX idx_storeid_orders ON Orders(StoreID);
CREATE INDEX idx_orderid_order_items ON Order_Items(OrderID);
CREATE INDEX idx_orderid_order_status ON Order_Status(OrderID);
CREATE INDEX idx_memberid_preferences ON Preferences(MemberID);

-- Composite Indexes
CREATE INDEX idx_memberid_orderdate_orders ON Orders(MemberID, OrderDate);
CREATE INDEX idx_storeid_targetaudience_marketing ON Marketing(StoreID, TargetAudience);




# DataWarehousingSolution
Data warehousing solution that reflects real-world data engineering  challenges, showcasing skills in data modelling, SQL, and Python. 

### ERD
![Database ER diagram (crow's foot)](https://github.com/user-attachments/assets/dca3b19d-bc9a-4602-b2f2-234f8fea6012)

### Entity Relationships Table


| **Parent Entity**     | **Child Entity**       | **Relationship Type** | **Parent Key**       | **Child Key**       | **Cardinality**       |
|------------------------|------------------------|------------------------|-----------------------|----------------------|------------------------|
| **Marketing**          | **Orders**            | One-to-Many            | `CampaignID PK`       | `CampaignID FK`      | One Campaign → Many Orders |
| **Marketing**          | **Orders**            | One-to-Many            | `StoreID UNIQUE`      | `StoreID FK`         | One Store → Many Orders    |
| **Members**            | **Orders**            | One-to-Many            | `MemberID PK`         | `MemberID FK`        | One Member → Many Orders   |
| **Members**            | **Preferences**       | One-to-Many            | `MemberID PK`         | `MemberID FK`        | One Member → Many Preferences |
| **Orders**             | **Order_Items**       | One-to-Many            | `OrderID PK`          | `OrderID FK`         | One Order → Many Items    |
| **Orders**             | **Order_Status**      | One-to-Many            | `OrderID PK`          | `OrderID FK`         | One Order → Many Statuses  |

### Indexing
- #### Foreign Keys (FKs)
```
CREATE INDEX idx_memberid_orders ON Orders(MemberID);
CREATE INDEX idx_campaignid_orders ON Orders(CampaignID);
CREATE INDEX idx_storeid_orders ON Orders(StoreID);
CREATE INDEX idx_orderid_order_items ON Order_Items(OrderID);
CREATE INDEX idx_orderid_order_status ON Order_Status(OrderID);
CREATE INDEX idx_memberid_preferences ON Preferences(MemberID);
```
- #### Composite Indexes

Composite indexes are helpful when queries filter by multiple columns.
Example: If queries often filter by MemberID and OrderDate in Orders:
```
CREATE INDEX idx_memberid_orderdate ON Orders(MemberID, OrderDate);
```

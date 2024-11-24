# DataWarehousingSolution
Data warehousing solution that reflects real-world data engineering  challenges, showcasing skills in data modelling, SQL, and Python. 

### ERD
![Database ER diagram (crow's foot) (1)](https://github.com/user-attachments/assets/5d69497d-119d-4d7d-a437-473009f0cacc)


### Entity Relationships Table

| **Parent Entity** | **Child Entity**  | **Relationship Type** | **Parent Key**     | **Child Key**     | **Cardinality**                 |
|--------------------|-------------------|------------------------|--------------------|-------------------|----------------------------------|
| `Marketing`        | `Orders`         | `Referenced by`        | `CampaignID (PK)`  | `CampaignID (FK)` | One Campaign → Many Orders (1:∞)|
| `Members`          | `Orders`         | `Places`               | `MemberID (PK)`    | `MemberID (FK)`   | One Member → Many Orders (1:∞)  |
| `Orders`           | `Order_Items`    | `Consists of`          | `OrderID (PK)`     | `OrderID (FK)`    | One Order → Many Items (1:∞)    |
| `Orders`           | `Order_Status`   | `In`                   | `OrderID (PK)`     | `OrderID (FK)`    | One Order → Many Statuses (1:∞) |
| `Members`          | `Preferences`    | `Has`                  | `MemberID (PK)`    | `MemberID (FK)`   | One Member → Many Preferences (1:∞) |
| `Marketing          | `Orders`        | One-to-Many            | `StoreID `         | `StoreID`         | One Store → Many or zero Orders (0:∞)   |

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

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


### Keys
- #### Primary Keys (PK): 
  - `CampaignID` for Marketing,
  - `MemberID` for Members,
  - `OrderID` for Orders.

- #### Foreign Keys (FK):
  - `MemberID` in Preferences references Members.
  - `MemberID` in Orders references Members.
  - `CampaignID` in Orders references Marketing.
  - `OrderID` in Order_Items references Orders.
  - `OrderID` in Order_Status references Orders.

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

Composite indexes for queries filter by multiple columns.
```
CREATE INDEX idx_memberid_orderdate_orders ON Orders(MemberID, OrderDate);
CREATE INDEX idx_storeid_targetaudience_marketing ON Marketing(StoreID, TargetAudience);
```
- ### Overview of files
  - data/ : Contains csv files
  - docker/db.sql: Contains query to create tables and indexes
  - docker/dockerfile: dDocker file for etl container
  - docker/etl_load_data.py: Python file for the ETL pipeline
  - docker/queries: Includes all the querires requested in section 3 of the assignment

- ### How to run
  - Open a terminal and navigate to the docker folder. 
  - Run the following command to start the containers: 
    `docker-compose up -d`
  - This will create 3 container `pgadmin_container`, `postgres_container`, `etl_container`
  - When etl_container will be created, it will automatically run the `db.sql` script to create tables and indexes, then it      will run the `etl_load_data.py` script to run the pipeline and in the end it will run the requested queries one by one
  - Access the pgAdmin here: `http://localhost:5050` to views tables created and data within it.

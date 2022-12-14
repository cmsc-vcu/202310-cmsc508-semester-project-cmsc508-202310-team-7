-- Template Select
SELECT 
    * 
FROM 
    table_name
WHERE
    1=1
;
SHOW TABLES

SHOW COLUMNS FROM Assigned_To
SHOW COLUMNS FROM Associated_With
SHOW COLUMNS FROM Bill_of_Lading
SHOW COLUMNS FROM Client
SHOW COLUMNS FROM Drives
SHOW COLUMNS FROM Employee
SHOW COLUMNS FROM Involves
SHOW COLUMNS FROM Items
SHOW COLUMNS FROM Leads
SHOW COLUMNS FROM Move_Table
SHOW COLUMNS FROM Own
SHOW COLUMNS FROM Packaged_As
SHOW COLUMNS FROM Packaged_Unit
SHOW COLUMNS FROM Point_of_Contact
SHOW COLUMNS FROM Signs
SHOW COLUMNS FROM Truck
SHOW COLUMNS FROM Truck_Group
SHOW COLUMNS FROM Trucks_With



-- Query 01
-- Who are the employees who are Sales Representatives?

SELECT
    *
FROM
    viewSalesReps
; 

-- Query 02
-- What are the heights of all trucks that have a length greater than 17 feet?

SELECT DISTINCT
    Truck_Height_Feet
FROM 
    Truck
WHERE
    1=1
    AND Truck_Length_Feet > 17
;


-- Query 03
-- Who are all the drivers, and their respective trucks, who are hauling during the month of June 2023?

SELECT 
    Employee_ID,
    CONCAT(Employee_Last_Name,", ", Employee_First_Name) AS "FULL NAME",
    Drives_VIN_Number
FROM 
    Move_Table
    JOIN Assigned_To ON(Assigned_To_Move_Table_Move_ID=Move_Table_Move_ID)
    JOIN Trucks_With ON(Assigned_To_Truck_Group_ID=Trucks_With_Truck_Group_ID)
    JOIN Drives      ON(Drives_VIN_Number=Trucks_With_VIN_Number)
    JOIN Employee    ON(Drives_Employee_ID=Employee_ID)
WHERE
    1=1
    AND ( Move_Table_Pickup_Date >= DATE("2023-06-01") AND Move_Table_Pickup_Date <= DATE("2023-06-30") )
    OR  ( Move_Table_Drop_Off_Date >= DATE("2023-06-01") AND Move_Table_Drop_Off_Date <= DATE("2023-06-30") )
;


-- Query 04
-- Display all of the moves that cost more than 8500 dollars and the point of contact for these moves.

SELECT 
    Move_Table_Move_ID AS "MOVE ID",
    Bill_of_Lading_Cost AS "COST",
    CONCAT(Client_Last_Name,", ", Client_First_Name) AS "POINT OF CONTACT",
    Client_Phone_Number AS "PHONE NUMBER"

FROM 
    Move_Table
    JOIN Involves           ON(Involves_Move_Table_Move_ID=Move_Table_Move_ID)
    JOIN Bill_of_Lading     ON(Bill_of_Lading_Bill_ID=Involves_Bill_of_Lading_Bill_ID)
    JOIN Point_of_Contact   ON(Point_of_Contact_Move_Table_Move_ID=Move_Table_Move_ID)
    JOIN Client             ON(Point_of_Contact_Client_ID=Client_ID)
WHERE
    1=1
    AND Bill_of_Lading_Cost > 8500
;


-- Query 05
-- Where are all the locations for which a specific driver goes to in 2023?
-- TO BE FINISHED

SELECT 
    Employee_ID,
    CONCAT(Employee_Last_Name,", ", Employee_First_Name) AS "FULL NAME",
    Move_Table_Move_ID AS "MOVE ID"
FROM 
    Move_Table
    JOIN Assigned_To ON(Assigned_To_Move_Table_Move_ID=Move_Table_Move_ID)
    JOIN Trucks_With ON(Assigned_To_Truck_Group_ID=Trucks_With_Truck_Group_ID)
    JOIN Drives      ON(Drives_VIN_Number=Trucks_With_VIN_Number)
    JOIN Employee    ON(Drives_Employee_ID=Employee_ID)
WHERE
    1=1
    AND Employee_First_Name = "John"
    AND ( 
            ( Move_Table_Pickup_Date >= DATE("2023-01-01") AND Move_Table_Pickup_Date <= DATE("2023-12-31") )
        OR  ( Move_Table_Drop_Off_Date >= DATE("2023-01-01") AND Move_Table_Drop_Off_Date <= DATE("2023-12-31") ) 
    )
;


-- Query 06
-- Have all the bill of ladings been uploaded for the moves happening during a specific week?

-- Returns all the Move IDS that are MISSING Bill of Ladings AND are within a Specified Time Range
SELECT 
    Move_Table_Move_ID 
FROM 
    Move_Table
    LEFT JOIN Involves ON (Involves_Move_Table_Move_ID=Move_Table_Move_ID)
WHERE
    1=1
    AND ( Move_Table_Pickup_Date >= DATE("2023-07-01") AND Move_Table_Pickup_Date <= DATE("2023-07-07") )
    AND Involves_Bill_of_Lading_Bill_ID IS NULL
;


-- Query 07
-- For a specific move, are all the containers packed?

-- Returns the Move ID and Container Barcode OF ALL Containers that are NOT packed and thus NOTready for the Move
SELECT 
    Move_Table_Move_ID,
    Signed_To_Container_Barcode
FROM 
    Move_Table
    JOIN Involves  ON(Involves_Move_Table_Move_ID=Move_Table_Move_ID)
    JOIN Signed_To ON(Signed_To_Bill_of_Lading_Bill_ID=Involves_Bill_of_Lading_Bill_ID)
    JOIN Container ON(Signed_To_Container_Barcode=Container_Barcode)
WHERE
    1=1
    AND Container_Packing_Status = FALSE
;


-- Query 08
-- Which employees lead truck groups involved in moves during December 2023?

SELECT 
    Employee_ID,
    CONCAT(Employee_Last_Name,", ", Employee_First_Name) AS "FULL NAME"
FROM 
    Move_Table
    JOIN Assigned_To ON (Assigned_To_Move_Table_Move_ID=Move_Table_Move_ID)
    JOIN Truck_Group ON (Assigned_To_Truck_Group_ID=Truck_Group_ID)
    JOIN Leads ON (Leads_Truck_Group_ID=Truck_Group_ID)
    JOIN Employee ON (Leads_Employee_ID=Employee_ID)
WHERE
    1=1
    AND ( 
            ( Move_Table_Pickup_Date >= DATE("2023-12-01") AND Move_Table_Pickup_Date <= DATE("2023-12-31") )
        OR  ( Move_Table_Drop_Off_Date >= DATE("2023-12-01") AND Move_Table_Drop_Off_Date <= DATE("2023-12-31") ) 
    )
;


-- Query 09
-- Display the boxes a specific client has with volume greater than 1 cubic foot that are not packed.

SELECT 
    Container_Barcode
FROM 
    Client
    JOIN Own ON(Client_ID=Own_Client_ID)
    JOIN Container ON(Container_Barcode=Own_Container_Barcode)
WHERE
    1=1
    AND Client_First_Name = "Kai"
    AND Client_Last_Name = "Leigh"
    AND Container_Volume > 1
    AND Container_Packing_Status = FALSE
;

-- Query 10
-- Who are all the point of contacts for all of the moves happening in February 2023?


-- Query 11
-- What are all the states that a truck is going to in one year?

WITH pickupStates AS (
    SELECT DISTINCT
        Move_Table_Pickup_State
    FROM 
        Trucks_With
        JOIN Truck_Group ON (Truck_Group_ID=Trucks_With_Truck_Group_ID)
        JOIN Assigned_To ON (Assigned_To_Truck_Group_ID=Truck_Group_ID)
        JOIN Move_Table  ON (Assigned_To_Move_Table_Move_ID=Move_Table_Move_ID)
    WHERE
        1=1
        AND ( 
                ( Move_Table_Pickup_Date >= DATE("2023-01-01") AND Move_Table_Pickup_Date <= DATE("2023-12-31") )
            OR  ( Move_Table_Drop_Off_Date >= DATE("2023-01-01") AND Move_Table_Drop_Off_Date <= DATE("2023-12-31") ) 
        )
        AND Trucks_With_VIN_Number = "1FADP3F20D3248721"
),
dropOffStates AS (
    SELECT DISTINCT
        Move_Table_Drop_Off_State
    FROM 
        Trucks_With
        JOIN Truck_Group ON (Truck_Group_ID=Trucks_With_Truck_Group_ID)
        JOIN Assigned_To ON (Assigned_To_Truck_Group_ID=Truck_Group_ID)
        JOIN Move_Table  ON (Assigned_To_Move_Table_Move_ID=Move_Table_Move_ID)
    WHERE
        1=1
        AND ( 
                ( Move_Table_Pickup_Date >= DATE("2023-01-01") AND Move_Table_Pickup_Date <= DATE("2023-12-31") )
            OR  ( Move_Table_Drop_Off_Date >= DATE("2023-01-01") AND Move_Table_Drop_Off_Date <= DATE("2023-12-31") ) 
        )
        AND Trucks_With_VIN_Number = "1FADP3F20D3248721"
)
SELECT
    *
FROM
    dropOffStates
UNION 
SELECT
    * 
FROM pickupStates
;

-- Query 12
-- What container did a specific client put their winter coat?

SELECT 
    Contains_Container_Barcode
FROM 
    Items
    JOIN Contains ON ((Items_Client_ID=Contains_Client_ID) AND (Contains_Items_Item_Name=Items_Item_Name))
WHERE
    1=1
    AND Items_Client_ID = "C1"
    AND Items_Item_Name LIKE "Winter%"
;

-- Query 13
-- What containers for a specific client contain items that belong in the Bedroom?

SELECT DISTINCT
    Contains_Container_Barcode
FROM 
    Items
    JOIN Contains ON ((Items_Client_ID=Contains_Client_ID) AND (Contains_Items_Item_Name=Items_Item_Name))
WHERE
    1=1
    AND Items_Client_ID = "C1"
    AND Items_Room = "Bedroom"
;


-- Query 14
-- What are all the containers for an address that contain items from the Kitchen?

SELECT 
    *
FROM 
    Items
    JOIN Contains ON ((Items_Client_ID=Contains_Client_ID) AND (Contains_Items_Item_Name=Items_Item_Name))
WHERE
    1=1
    AND Items_Client_ID = "C1"
    AND Items_Category = "Kitchen"
;

-- Query 15
-- What are the VIN numbers and truck driver names for the trucks associated with a given move?

SELECT
    Move_Table_Move_ID,
    Employee_ID,
    CONCAT(Employee_Last_Name, ", ", Employee_First_Name) AS "Last Name, First Name",
    Drives_VIN_Number
FROM
    Move_Table
    JOIN Assigned_To ON (Assigned_To_Move_Table_Move_ID=Move_Table_Move_ID)
    JOIN Trucks_With ON (Assigned_To_Truck_Group_ID=Trucks_With_Truck_Group_ID)
    JOIN Drives      ON (Trucks_With_VIN_Number=Drives_VIN_Number)
    JOIN Employee    ON (Drives_Employee_ID=Employee_ID)
WHERE
    1=1
    AND Move_Table_Move_ID = "M1"
;


-- Query 16
-- What is the total weight for all containers for an address?

SELECT 
    CONCAT(Move_Table_Pickup_Street," ",Move_Table_Pickup_City,", ",Move_Table_Pickup_State," ", Move_Table_Pickup_ZipCode) AS "Address",
    SUM(Container_Weight) AS "Total Weight in Pounds"
FROM 
    Move_Table
    JOIN Involves   ON (Move_Table_Move_ID=Involves_Move_Table_Move_ID)
    JOIN Signed_To  On (Involves_Bill_of_Lading_Bill_ID=Signed_To_Bill_of_Lading_Bill_ID)
    JOIN Container  ON (Signed_To_Container_Barcode=Container_Barcode)
WHERE
    1=1
GROUP BY
    1
;



-- Query 17
-- How many days until a favorite toy arrives? ( For a specific client )

SELECT 
    * 
FROM 
    table_name
WHERE
    1=1
;

-- Query 18
-- Who has the largest container for a specific address?

SELECT 
    * 
FROM 
    table_name
WHERE
    1=1
;

-- Query 19
-- Does anyone in a specific house have an unpacked box I can use?

SELECT 
    * 
FROM 
    table_name
WHERE
    1=1
;


-- Query 20
-- Which moves that take longer than a 4 days to complete?

SELECT
    Move_Table_Move_ID
FROM 
    Move_Table
WHERE
    1=1
    AND DATEDIFF (Move_Table_Drop_Off_Date, Move_Table_Pickup_Date) > 4
;



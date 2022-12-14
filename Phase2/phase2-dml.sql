-- Template Select
SELECT 
    * 
FROM 
    table_name
WHERE
    1=1
;

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
ORDER BY 
    2, 1
;


-- Query 05
-- Where are all the locations for which a specific driver goes to in 2023?

WITH driverMoves AS (
    SELECT 
        Move_Table_Move_ID
    FROM 
        Move_Table
        JOIN Assigned_To ON(Assigned_To_Move_Table_Move_ID=Move_Table_Move_ID)
        JOIN Trucks_With ON(Assigned_To_Truck_Group_ID=Trucks_With_Truck_Group_ID)
        JOIN Drives      ON(Drives_VIN_Number=Trucks_With_VIN_Number)
        JOIN Employee    ON(Drives_Employee_ID=Employee_ID)
    WHERE
        1=1
        AND Employee_First_Name = "Kasey"
        AND ( 
                ( Move_Table_Pickup_Date >= DATE("2023-01-01") AND Move_Table_Pickup_Date <= DATE("2023-12-31") )
            OR  ( Move_Table_Drop_Off_Date >= DATE("2023-01-01") AND Move_Table_Drop_Off_Date <= DATE("2023-12-31") ) 
        )
),
pickUpAddresses AS (
    SELECT
        Move_Table_Move_ID AS PickUpID,
        CONCAT(Move_Table_Pickup_Street,", ", Move_Table_Pickup_City, ", ", Move_Table_Pickup_State, ", ", Move_Table_Pickup_ZipCode) AS PickUpAddress
    FROM
        Move_Table
),
dropOffAddresses AS (
    SELECT
        Move_Table_Move_ID AS DropOffID,
        CONCAT(Move_Table_Drop_Off_Street,", ", Move_Table_Drop_Off_City, ", ", Move_Table_Drop_Off_State, ", ", Move_Table_Drop_Off_ZipCode) AS DropOffAdress
    FROM
        Move_Table
)
SELECT
    PickUpAddress AS "Locations"
FROM
    driverMoves
    JOIN pickUpAddresses ON (Move_Table_Move_ID = PickUpID)
UNION
SELECT
    DropOffAdress AS "Locations"
FROM
    driverMoves
    JOIN dropOffAddresses ON (Move_Table_Move_ID = DropOffID)
;


-- Query 06
-- Have all the bill of ladings been uploaded for the moves happening during a specific month?
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
-- Returns the Move ID and Container Barcode OF ALL Containers that are NOT packed and thus NOT ready for the Move

SELECT 
    Move_Table_Move_ID,
    Associated_With_Packaged_Unit_Barcode
FROM 
    Move_Table
    JOIN Involves           ON(Involves_Move_Table_Move_ID=Move_Table_Move_ID)
    JOIN Associated_With    ON(Associated_With_Bill_of_Lading_Bill_ID=Involves_Bill_of_Lading_Bill_ID)
    JOIN Packaged_Unit      ON(Associated_With_Packaged_Unit_Barcode=Packaged_Unit_Barcode)
WHERE
    1=1
    AND Packaged_Unit_Packing_Status = FALSE
;


-- Query 08
-- Which employees lead truck groups involved in moves during December 2023?

SELECT 
    Employee_ID,
    CONCAT(Employee_Last_Name,", ", Employee_First_Name) AS "FULL NAME",
    Leads_Truck_Group_ID
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
-- Display the packaged units for a specific client that have a volume greater than 1 cubic foot and are not packed.

SELECT 
    Packaged_Unit_Barcode
FROM 
    Client
    JOIN Own ON(Client_ID=Own_Client_ID)
    JOIN Packaged_Unit ON(Packaged_Unit_Barcode=Own_Packaged_Unit_Barcode)
WHERE
    1=1
    AND Client_First_Name = "Kai"
    AND Client_Last_Name = "Leigh"
    AND Packaged_Unit_Volume >= 1
    AND Packaged_Unit_Packing_Status = FALSE
;


-- Query 10
-- Who are all the point of contacts for all of the moves happening in February 2023?

SELECT
    CONCAT(Client_Last_Name,", ", Client_First_Name) AS "POINT OF CONTACT"
FROM
    Move_Table
    JOIN Point_of_Contact ON (Move_Table_Move_ID=Point_of_Contact_Move_Table_Move_ID)
    JOIN Client           ON (Client_ID=Point_of_Contact_Client_ID)
WHERE
    1=1
    AND ( 
            ( Move_Table_Pickup_Date >= DATE("2023-02-01") AND Move_Table_Pickup_Date <= DATE("2023-02-28") )
        OR  ( Move_Table_Drop_Off_Date >= DATE("2023-02-01") AND Move_Table_Drop_Off_Date <= DATE("2023-02-28") ) 
    )
;


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
    Packaged_As_Packaged_Unit_Barcode AS "Barcode",
    Items_Item_Name AS "Item"
FROM 
    Items
    JOIN Packaged_As ON ((Items_Client_ID=Packaged_As_Client_ID) AND (Packaged_As_Items_Item_Name=Items_Item_Name))
WHERE
    1=1
    AND Items_Client_ID = "C1"
    AND Items_Item_Name LIKE "coat%"
;


-- Query 13
-- What containers for a specific client contain items that belong in the Bedroom?

SELECT
    Items_Room AS "Room",
    Packaged_As_Packaged_Unit_Barcode AS "Barcode"
FROM 
    Items
    JOIN Packaged_As ON ((Items_Client_ID=Packaged_As_Client_ID) AND (Packaged_As_Items_Item_Name=Items_Item_Name) AND (Packaged_As_Items_Room=Items_Room))
WHERE
    1=1
    AND Items_Client_ID = "C3"
    AND Items_Room LIKE "Bedroom%"
ORDER BY
    1
;


-- Query 14
-- What are all the containers for an address that contain items from the Kitchen?

SELECT 
    Own_Packaged_Unit_Barcode
FROM 
    Items
    JOIN Packaged_As        ON ((Items_Client_ID=Packaged_As_Client_ID) AND (Packaged_As_Items_Item_Name=Items_Item_Name) AND (Packaged_As_Items_Room=Items_Room))
    JOIN Own                ON (Packaged_As_Packaged_Unit_Barcode=Own_Packaged_Unit_Barcode)
    JOIN Point_of_Contact   ON (Own_Client_ID=Point_of_Contact_Client_ID)
    JOIN Move_Table         ON (Point_of_Contact_Move_Table_Move_ID=Move_Table_Move_ID)
WHERE
    1=1
    AND Move_Table_Pickup_Street = "3305 Webb Rd"
    AND Move_Table_Pickup_City = "Richmond"
    AND Move_Table_Pickup_State = "VA"
    AND Move_Table_Pickup_ZipCode = "23228"
    AND Items_Room = "Kitchen"
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
-- Which room, for a specific move, has the most stuff?

SELECT 
    CONCAT(Move_Table_Pickup_Street," ",Move_Table_Pickup_City,", ",Move_Table_Pickup_State," ", Move_Table_Pickup_ZipCode) AS "Address"
FROM 
    Move_Table
    JOIN Involves           ON (Move_Table_Move_ID=Involves_Move_Table_Move_ID)
    JOIN Associated_With    ON (Involves_Bill_of_Lading_Bill_ID=Associated_With_Bill_of_Lading_Bill_ID)
    JOIN Packaged_Unit      ON (Associated_With_Packaged_Unit_Barcode=Packaged_Unit_Barcode)
WHERE
    1=1
GROUP BY
    1
;



-- Query 17
-- How many days until a favorite toy arrives? ( For a specific client )

SELECT 
    DATEDIFF (Move_Table_Drop_Off_Date, CURDATE()) AS "Days Until My Laptop Arrives At The New Address"
FROM 
    Items
    JOIN Packaged_As        ON ((Items_Client_ID=Packaged_As_Client_ID) AND (Packaged_As_Items_Item_Name=Items_Item_Name) AND (Packaged_As_Items_Room=Items_Room))
    JOIN Own                ON (Packaged_As_Packaged_Unit_Barcode=Own_Packaged_Unit_Barcode)
    JOIN Point_of_Contact   ON (Own_Client_ID=Point_of_Contact_Client_ID)
    JOIN Move_Table         ON (Point_of_Contact_Move_Table_Move_ID=Move_Table_Move_ID)
WHERE
    1=1
    AND Items_Client_ID = "C16"
    AND Items_Item_Name = "Laptop"
;


-- Query 18
-- Who has the largest container for a specific address?

SELECT 
    CONCAT(Move_Table_Pickup_Street," ",Move_Table_Pickup_City,", ",Move_Table_Pickup_State," ", Move_Table_Pickup_ZipCode) AS "Address",
    CONCAT(Client_Last_Name,", ", Client_First_Name) AS "Client Name",
    Packaged_Unit_Volume
FROM 
    Items
    JOIN Packaged_As        ON ((Items_Client_ID=Packaged_As_Client_ID) AND (Packaged_As_Items_Item_Name=Items_Item_Name) AND (Packaged_As_Items_Room=Items_Room))
    JOIn Packaged_Unit      ON (Packaged_As_Packaged_Unit_Barcode=Packaged_Unit_Barcode)
    JOIN Own                ON (Packaged_As_Packaged_Unit_Barcode=Own_Packaged_Unit_Barcode)
    JOIN Point_of_Contact   ON (Own_Client_ID=Point_of_Contact_Client_ID)
    JOIN Move_Table         ON (Point_of_Contact_Move_Table_Move_ID=Move_Table_Move_ID)
    JOIN Client             ON (Point_of_Contact_Client_ID=Client_ID)
WHERE
    1=1
    AND Move_Table_Pickup_Street = "3305 Webb Rd"
    AND Move_Table_Pickup_City = "Richmond"
    AND Move_Table_Pickup_State = "VA"
    AND Move_Table_Pickup_ZipCode = "23228"
ORDER BY
    Packaged_Unit_Volume DESC
LIMIT
    1
;


-- Query 19
-- What is the average cost per packaged unit to move my stuff ( for a specific move )

WITH numberOfUnitsTable AS (
    SELECT
        Move_Table_Move_ID AS "ID",
        Count(*) AS "Number_of_Packaged_Units"
    FROM
        Move_Table
        JOIN Involves           ON (Involves_Move_Table_Move_ID=Move_Table_Move_ID)
        JOIN Associated_With    ON (Associated_With_Bill_of_Lading_Bill_ID=Involves_Bill_of_Lading_Bill_ID)
    WHERE
        1=1
        AND Move_Table_Move_ID = "M33"
)
SELECT 
    ROUND(Bill_of_Lading_Cost/Number_of_Packaged_Units,3) AS "Average Cost Per Packaged Unit"
FROM 
    Move_Table
    JOIN Involves           ON (Involves_Move_Table_Move_ID=Move_Table_Move_ID)
    JOIN Bill_of_Lading     ON (Bill_of_Lading_Bill_ID=Involves_Bill_of_Lading_Bill_ID)
    JOIN numberOfUnitsTable ON (Move_Table_Move_ID=ID)
WHERE
    1=1
    AND Move_Table_Move_ID = "M33"
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



## Assumptions 

1. Trucks are limited to a single operating region each
1. One truck per operating region
1. Truck capacities will be static
1. Desktop App design requirements still need to be discussed with PO


## WebService API Classes and Methods

    *Provide a high level outline for how these classes will be used to maintain a
    current “state”*:
    A SQL Server service can be utilized to notify the desktop app when a truck has updated
    the database. This prompt triggers a GET request from the desktop app to update the dispatcher's
    view of the trucks.


    *Trucks* Class matching DB table
    *TruckViewModel* Class that queries previously posted data and incoming data
    *FuelDeliveryEvent* Class matching DB table

### Trucks Controller Class

    GET: .../AllTrucks
    // This method queries the DB and returns **CurrentStop**, **NextStop**(nullable), and 
    **CurrentFuelLevel** for all trucks

    POST: .../Truck/TruckID
    // This method receives a truck's **TruckID**, **CurrentStop**, and **CurrentFuelLevel** 
    at the endstage of a stop. Using a ViewModel, it queries the DB for the truck's 
    previous CurrentFuelLevel and calculates TotalFuelDelivered for CurrentStop. It then 
    updates the appropriate tables in DB with **TruckID**, **CurrentStopID**, **FuelLevelPercent**, and 
    **FuelDeliveredPercent**

### Stops Controller Class

    GET: .../NextStop/TruckID
    // This method queries the DB and returns the **NextStopID** for the given **TruckID**

    POST: .../NextStop/TruckID
    // This method updates the Trucks table with the **NextStopID** for the truck matching the given 
    **TruckID**

### DatabaseInterface Class

    GET: .../Query
    // This method receives a query from any authorized point and converts it to a SQL 
    command. It then returns the results of the given query

## DeskTop App Classes and Methods



## SQL Queries
    I built the database these queries were written against using DB Browser and SQLite. The .db file and SQLite queries are both in this repo if you wish to run them.

    // Top 10 fuel consuming “Stops” over the past 12 months
    select StopID, FuelDeliveredPercent, DeliveryTime 
    from FuelDeliveryEvent 
    inner join DeliveryEventStops on DeliveryEventStops.FuelDeliveryEventID = FuelDeliveryEvent.FuelDeliveryEventID
    where DeliveryTime between "2016-10-30" and "2017-10-31"
    order by
    FuelDeliveredPercent desc
    limit 10;

    // Average fuel consumption per delivery, listed by “Stop” for the month
    select StopID, AVG(FuelDeliveredPercent) as "Average Delivery"
    from FuelDeliveryEvent 
    inner join DeliveryEventStops on DeliveryEventStops.FuelDeliveryEventID = FuelDeliveryEvent.FuelDeliveryEventID
    where DeliveryTime between "2017-09-01" and "2017-10-01"
    group by 
    StopID;
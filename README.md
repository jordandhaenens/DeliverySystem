## Assumptions 

1. Trucks are limited to a single operating region each
1. One truck per operating region
1. Truck capacities will be static
1. Desktop App design requirements still need to be discussed with PO
1. The burden on the dispatcher could be greatly relieved by uploading predetermined routes
for each truck


## WebService API Classes and Methods

Provide a high level outline for how these classes will be used to maintain a
current “state”:

    A SQL Server service can be utilized to notify the desktop app when a truck has updated
    the database. This prompt triggers a GET request from the desktop app to update the dispatcher's
    view of the trucks.

Describe how we will store and retrieve information from a SQL database for a
recorded fuel stop:

    The WebService API will be the gateway to the SQL database. It could have one, two,
    or three interfaces to controll specific requests to the DB. In my diagram I have listed
    three interfaces to create an additional layer of abstraction and separation of duties, 
    however, you could just as easily have all of these methods live in a single controller on 
    the API.

    Trucks post their status to the DB at the end of each stop and then request their NextStop
    until the NextStopID no longer matches their CurrentStopID and is not null. The desktop
    app requests the status of all trucks each time there is an update to the DB and the dispatcher
    is then able to send NextStopIDs to each truck that is waiting (we could add an extra boolean
    to one of the tables to indicate this).


### Trucks Controller Class

#### GET: .../AllTrucks
This method queries the DB and returns **CurrentStop**, **NextStop**(nullable), and 
**CurrentFuelLevel** for all trucks

#### POST: .../Truck/TruckID
This method receives a truck's **TruckID**, **CurrentStop**, and **CurrentFuelLevel** 
at the endstage of a stop. Using a ViewModel, it queries the DB for the truck's 
previous CurrentFuelLevel and calculates TotalFuelDelivered for CurrentStop. It then 
updates the appropriate tables in DB with **TruckID**, **CurrentStopID**, **FuelLevelPercent**, and 
**FuelDeliveredPercent**

### Stops Controller Class

#### GET: .../NextStop/TruckID
This method queries the DB and returns the **NextStopID** for the given **TruckID**

#### POST: .../NextStop/TruckID
This method updates the Trucks table with the **NextStopID** for the truck matching the given 
**TruckID**

### DatabaseInterface Class

##### GET: .../Query
This method receives a query from any authorized point and converts it to a SQL 
command. It then returns the results of the given query


### Additional Classes

- **Trucks Class** matching the DB table
- **TruckViewModel Class** that queries previously posted data and incoming data
- **FuelDeliveryEvent Class** matching the DB table


## DeskTop App Classes and Methods

    I don't know exactly how I would build out the Desktop App and I don't have enough 
    information to build a complete outline of classes for it. I failed to ask the right 
    questions before the weekend started.

    I assume the dispatcher would have a GUI / map overlay to interact with and see
    stops and trucks as their information is updated. There would need to be a DataFactory 
    Controller to handle the outgoing API calls and make the response available to the other
    classes in the Desktop App. Additionally there would need to be Truck and Stop classes 
    to handle the data from the DB.



## SQL Queries
    I built the database these queries were written against using DB Browser and SQLite. 
    The .db file and SQLite queries are both in this repo if you wish to run them.

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
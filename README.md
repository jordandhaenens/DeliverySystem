##Assumptions 

1. Trucks are limited to a single operating region each
1. One truck per operating region
1. Truck capacities will be static
1. Desktop App design requirements still need to be discussed with PO


##WebService API Classes and Methods
    Trucks Class matching DB table
    TruckViewModel Class that queries previously posted data and incoming data
    FuelDeliveryEvent Class matching DB table

###Trucks Controller Class
    GET: .../AllTrucks
    // This method queries the DB and returns CurrentStop, NextStop(nullable), and CurrentFuelLevel for all trucks

    POST: .../Truck/TruckID
    // This method receives a truck's TruckID, CurrentStop, and CurrentFuelLevel at the endstage of a stop. Using a ViewModel, it queries the DB for the truck's previous CurrentFuelLevel and calculates TotalFuelDelivered for CurrentStop. It then updates the appropriate tables in DB with TruckID, CurrentStop, CurrentFuelLevel, and TotalFuelDelivered

###Stops Controller Class
    GET: .../NextStop/TruckID
    // This method queries the DB and returns the NextStop for the given TruckID

    POST: .../NextStop/TruckID
    // This method updates the Trucks table with the NextStop for the truck matching the given TruckID

###DatabaseInterface Class
    GET: .../Query
    // This method receives a query from any authorized point and converts it to a SQL command. It then returns the results of the given query

##DeskTop App Classes and Methods
    
    
insert into OperatingRegion
values (null, "North");

insert into Stops
 values (null, null, null, null, null, 1);
 
insert into Trucks
values (null, 1, null, null, null);

insert into FuelDeliveryEvent
values (null, 12, "2016-10-23 14:12:45"),
 (null, 10, "2016-11-23 14:10:45"),
 (null, 8, "2017-04-22 14:12:45"),
 (null, 6, "2017-08-12 14:12:45"),
 (null, 5, "2017-03-23 14:12:45"),
 (null, 15, "2017-09-03 14:12:45");
 
insert into DeliveryEventStops
values (null, 1, 1, 1),
(null, 2, 2, 1),
(null, 1, 3, 1),
(null, 2, 4, 1),
(null, 1, 5, 1),
(null, 2, 6, 1),
(null, 1, 7, 1);

select StopID, FuelDeliveredPercent, DeliveryTime 
from FuelDeliveryEvent 
inner join DeliveryEventStops on DeliveryEventStops.FuelDeliveryEventID = FuelDeliveryEvent.FuelDeliveryEventID
where DeliveryTime between "2016-10-30" and "2017-10-31"
order by
FuelDeliveredPercent desc
limit 10;

select StopID, AVG(FuelDeliveredPercent) as "Average Delivery"
from FuelDeliveryEvent 
inner join DeliveryEventStops on DeliveryEventStops.FuelDeliveryEventID = FuelDeliveryEvent.FuelDeliveryEventID
where DeliveryTime between "2017-09-01" and "2017-10-01"
group by 
StopID;


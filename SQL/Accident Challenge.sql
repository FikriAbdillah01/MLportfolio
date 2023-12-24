use new_schema;
select * from accident limit 100;

-- question 1:  How many accident have occured in urban areas versus rural areas

select *  from accident;
select Area, count(Area) as total_accident from accident group by Area;

-- question 2: which day of week has the highest number of accident?

select * from accident;
select `Day`, count(`Day`) as accident_day from accident group by `Day` order by accident_day desc;

-- question 3: what is the average age of vehicles involved in the accident based on their type

select * from vehicle;
select * from accident;

select VehicleType, avg(AgeVehicle) as average_age_vehicles from vehicle group by VehicleType  order by average_age_vehicles desc;

-- question 4: can we identify any trends in accident based on age vehicles involved?
-- compare age of vehicle with number of accident involved

select * from vehicle;
select AgeVehicle, count(*) as num_vehicle from vehicle group by AgeVehicle order by num_vehicle desc;

-- question 5: Are the spesific weather condition that contribute to severe accident?

select * from accident;
select Severity, WeatherConditions, count(*) as total_acc from accident where Severity in ('Fatal', 'Serious') group by Severity, WeatherConditions order by total_acc desc;

-- question 6: Do accident often involve impacts on the left-hand side of vehicle?

select * from vehicle;
select Lefthand, count(*) from vehicle group by Lefthand;

-- question 7: Are they relationship between journey purposes and the severity of accident?

select a.Severity as severity, v.JourneyPurpose as journey, count(*) as num_accident 
from accident as a inner join vehicle as v on a.AccidentIndex = v.AccidentIndex group by severity, journey;

-- question 8: create stored procedure to calculate the average  age of vehicle involved in accidents,
-- considering light conditions and point impact as two variable/inputs:
-- light condition = 'Daylight'
-- point impact = 'Offside'

select a.LightConditions as light_cond, v.PointImpact as point_impact, avg(v.AgeVehicle) as average_age_ride
from accident as a inner join vehicle as v on a.AccidentIndex = v.AccidentIndex where a.LightConditions = Daylight and v.PointImpact = Offside group by light_cond, point_impact;

delimiter $$
create procedure avg_age_ride(in light_cond varchar (100), in point_impact varchar(100))
begin
select avg(v.AgeVehicle) as avg_age_ride from vehicle as v join accident as a on v.AccidentIndex = a.AccidentIndex where a.LightConditions = light_cond and v.PointImpact = point_impact;
end $$ 
delimiter;

call avg_age_ride ('Daylight','Offside')


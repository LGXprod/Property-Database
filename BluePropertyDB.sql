DROP TABLE rentalApplication;
DROP TABLE allocated;
DROP TABLE residential;
DROP TABLE commercial;
DROP TABLE staff_table;
DROP TABLE property;

CREATE TABLE staff_table (

	staffID CHAR(8) NOT NULL,
	fName VARCHAR(20),
	sName VARCHAR(20),
	email VARCHAR(20),
	phoneNo CHAR(10),
	managerID CHAR(8),
	CONSTRAINT staff_table_PK PRIMARY KEY(staffID)

);


ALTER TABLE staff_table ADD CONSTRAINT managerID_FK FOREIGN KEY(managerID) references staff_table(staffID);


CREATE TABLE property (

	propertyID CHAR(10) NOT NULL,
	status BOOLEAN, -- false if for buying, true for renting
	street VARCHAR(25),
	suburb VARCHAR(15),
	state VARCHAR(10),
	postcode VARCHAR(4),
	minPrice NUMERIC(10,2),
	propertyType TEXT, 
	CONSTRAINT property_PK PRIMARY KEY (propertyID)

);

CREATE TABLE residential (

	numBeds SMALLINT,
	numBathrooms SMALLINT,
	propertyDesc TEXT,
	propertyID CHAR(10) NOT NULL,
	CONSTRAINT residential_FK FOREIGN KEY (propertyID) references property(propertyID)

);

CREATE TABLE commercial (

	propertyDesc TEXT,
	propertyID CHAR(10) NOT NULL,
	CONSTRAINT residential_FK FOREIGN KEY (propertyID) references property(propertyID)

);

CREATE TABLE allocated (

	propertyID CHAR(10),
	staffID CHAR(8),
	dateAllocated CHAR(10),
	CONSTRAINT allocated_FK1 FOREIGN KEY (propertyID) references property(propertyID),
	CONSTRAINT allocated_FK2 FOREIGN KEY (staffID) references staff_table(staffID)

);

CREATE TABLE rentalApplication (

	applicationID CHAR(8),
	fName VARCHAR(20),
	sName VARCHAR(20),
	phoneNo CHAR(10),
	licenceNo NUMERIC(8,0),
	income NUMERIC(10, 2),
	propertyID CHAR(10),
	CONSTRAINT rentalApplication_PK PRIMARY KEY (applicationID),
	CONSTRAINT rentalApplication_FK FOREIGN KEY (propertyID) references property(propertyID)

);

INSERT INTO staff_table(staffID, fName, sName, email, phoneNo, managerID) values ('00000001', 'Gabriel', 
	'Chambers', 'gc@gmail.com', '0400000001', null);
INSERT INTO staff_table(staffID, fName, sName, email, phoneNo, managerID) values ('00000002', 'Hughie', 
	'Bowen', 'hb@gmail.com', '0400000011', '00000001');
INSERT INTO staff_table(staffID, fName, sName, email, phoneNo, managerID) values ('00000003', 'Lily-Anne', 
	'Morales', 'lm@gmail.com', '0400000111', null);
INSERT INTO staff_table(staffID, fName, sName, email, phoneNo, managerID) values ('00000004', 'Woodrow', 
	'Irwin', 'wi@gmail.com', '0400001111', '00000003');
INSERT INTO staff_table(staffID, fName, sName, email, phoneNo, managerID) values ('00000005', 'Mariah', 
	'Frost', 'mf@gmail.com', '0400011111', null);

INSERT INTO property(propertyID, status, street, suburb, state, postcode, minPrice, propertyType) 
values ('0000000001', true, 'street1', 'suburb1', 'state1', '1111', 1000000.53, 'Residential');
INSERT INTO property(propertyID, status, street, suburb, state, postcode, minPrice, propertyType) 
values ('0000000002', true, 'street2', 'suburb1', 'state1', '1111', 1049200.53, 'Vacant land');
INSERT INTO property(propertyID, status, street, suburb, state, postcode, minPrice, propertyType) 
values ('0000000003', true, 'street4', 'suburb3', 'state1', '1112', 2590000.53, 'Vacant land');
INSERT INTO property(propertyID, status, street, suburb, state, postcode, minPrice, propertyType) 
values ('0000000004', true, 'street5', 'suburb3', 'state1', '3311', 2149200.53, 'Residential');
INSERT INTO property(propertyID, status, street, suburb, state, postcode, minPrice, propertyType) 
values ('0000000005', true, 'street1', 'suburb1', 'state1', '1111', 1005700.53, 'Commercial');

INSERT INTO allocated(propertyID, staffID, dateAllocated) values ('0000000001', '00000004', '2009-20-06');
INSERT INTO allocated(propertyID, staffID, dateAllocated) values ('0000000002', '00000003', '2017-01-11');
INSERT INTO allocated(propertyID, staffID, dateAllocated) values ('0000000003', '00000005', '2017-01-11');
INSERT INTO allocated(propertyID, staffID, dateAllocated) values ('0000000004', '00000002', '2019-23-11');
INSERT INTO allocated(propertyID, staffID, dateAllocated) values ('0000000005', '00000001', '2017-01-07');

INSERT INTO residential(numBeds, numBathrooms, propertyDesc, propertyID) values (2, 3, 'House', '0000000004');
INSERT INTO residential(numBeds, numBathrooms, propertyDesc, propertyID) values (2, 2, 'Unit', '0000000001');
INSERT INTO commercial(propertyDesc, propertyID) values ('Land Development', '0000000005');

INSERT INTO rentalApplication(applicationID, fName, sName, phoneNo, licenceNo, income, propertyID)
values ('00000001', 'Ravinder', 'Boyer', '0421111111', '22222252', 2000000.31, '0000000004');
INSERT INTO rentalApplication(applicationID, fName, sName, phoneNo, licenceNo, income, propertyID) 
values ('00000002', 'Will', 'Ramirez', '0411111111', '22232222', 100000.10, '0000000001');
INSERT INTO rentalApplication(applicationID, fName, sName, phoneNo, licenceNo, income, propertyID) 
values ('00000003', 'Margo', 'Schmitt', '0411112311', '22222222', 1500000.59, '0000000003');

-- Three SELECT * statements for three separate tables
SELECT * FROM property; -- Returns and displays all fields and instances of property
SELECT * FROM staff_table; -- Returns and displays all fields and instances of staff_table
SELECT * FROM allocated; -- Returns and displays all fields and instances of allocated

-- A query involving a “Group by”, perhaps also with a “HAVING” 
-- Lists the amount of propertys in each property type if that type has more than zero properties.
SELECT COUNT(propertyType), propertyType 
-- Returns the propertyType field and a field with the result of the aggregate function count of propertyType. 
-- The aggregate function count finds how many instances in property contain a specific propertyType.
FROM property -- From the property table
GROUP BY propertyType -- Groups rows that use the same input for propertyType.
HAVING COUNT (propertyType) > 0; -- Only shows propertyType's that have 1 or more instances that contain that propertType in the property table

-- A query which uses "inner join"
-- Inner joins property and bookings
select * FROM property p INNER JOIN rentalApplication r ON p.propertyID = r.propertyID;
-- displays all fields from instances returned from the inner join between the property and rentalApplication table
-- the inner join is performed by checking the propertyID primary key in p against every instance of r until there is a match with its foreign key propertyID.
-- OR if there are no matches doesn't return an instance for that property

select * FROM property p INNER JOIN residential r ON p.propertyID = r.propertyID;
-- displays all fields from instances returned from the inner join between the property and residental table
-- the inner join is performed by checking the propertyID primary key in p against every instance of r until there is a match with its foreign key propertyID.
-- OR if there are no matches doesn't return an instance for that property

-- A query which uses a “sub query”
-- Shows all staff who dont manage other staff. 
SELECT staffID, fName, sName, email, phoneNo -- Returns the specified fields specified of all instances that meet the following criteria
FROM staff_table -- Selects from staff_table
WHERE staffID NOT IN (SELECT staffID FROM staff_table where managerID is not null); 
-- Inner query: returns a list that contains the staffID's of staff who have a manager
-- Outer query: returns all staff who are not in the above list. I.e. returns staff detals of those who don't have a manager. 

select fName, sName, income -- Shows the specified fields of all instances that meet the following criteria
from rentalApplication -- Selects from the rentalApplication table
where propertyID in (select propertyID from property where minPrice > 1500000.00); 
-- Inner query: returns a list of propertyIDs that belong to property's that had a minPrice above 1500000.00
-- Outer query: checks the every foriegn key propertyID in the rentalApplications table against the list returned by the inner query.
-- To find a two keys that match. I.e find a property that was above $1500000.00 but also had a rentalApplication from at least one person.

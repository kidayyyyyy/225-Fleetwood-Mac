drop table if exists `Branch`, `Category`, `Customer`, `Equipment`, `RentSchedule`, `ServiceCompany`, `Staff`, `Unit`, `Maintenance`;

create table Staff (
    staffID int primary key,
    firstName varchar(30) not null,
    lastName varchar(30),
    -- Phone number must be in the format 000-000-0000 or 00-000-0000
    phone varchar(20) not null check (phone regexp '^[0-9]{2,3}-[0-9]{3}-[0-9]{4}$'),
    email varchar(60),
    position varchar(30) not null check (position in ('Manager', 'Staff', 'Left')) 
);

create table Customer (
    customerID int primary key,
    firstName varchar(30) not null,
    lastName varchar(30),
    -- Email is optional but phone is needed for contact
    email varchar(30),
    phone varchar(20) not null check (phone regexp '^[0-9]{2,3}-[0-9]{3}-[0-9]{4}$')
);

create table Branch (
    branchID int primary key,
    branchAddress varchar(100) not null,
    phone varchar(20) not null check (phone regexp '^[0-9]{2,3}-[0-9]{3}-[0-9]{4}$'),
    managerID int not null,

    foreign key (managerID) references Staff(staffID)
);

create table Category (
    categoryID int primary key,
    categoryName varchar(30) not null,
    -- If category is a subcategory, this will contain the ID of the parent category
    -- If it is a top-level category, this will be null
    parentCategoryID int DEFAULT null,

    foreign key (parentCategoryID) references Category (categoryID)
);

create table Equipment (
    equipmentID int primary key,
    equipmentName varchar(30) not null,
    equipmentDesc varchar(100),
    -- Used to show rank equipment by popularity
    rentedTimes int default 0,
    categoryID int not null,
    foreign key (categoryID) references Category (categoryID)
);

create table Unit (
    unitID int primary key,
    unitStatus varchar(30) check (unitStatus in ('Available', 'Rented', 'Maintenance')),
    equipmentID int not null,
    branchID int not null,
    foreign key (equipmentID) references Equipment (equipmentID),
    foreign key (branchID) references Branch (branchID)
);

create table RentSchedule (
    rentalID int,
    customerID int,
    unitID int,
    pickupBranchID int not null,
    -- Since the customer may return the unit to a different branch, this can be null if the customer has not yet returned the unit
    returnBranchID int default null,
    -- Pickup and return dates are needed
    -- Timestamp used to store date and time of pickup and return
    pickupDate timestamp not null,
    returnDate timestamp not null,
    actualPickupDate timestamp,
    actualReturnDate timestamp,

    primary key (rentalID, customerID, unitID),
    foreign key (customerID) references Customer (customerID),
    foreign key (unitID) references Unit (unitID),
    foreign key (pickupBranchID) references Branch (branchID),
    foreign key (returnBranchID) references Branch (branchID)
);

create table ServiceCompany(
    companyID int primary key,
    companyName varchar(60) not null,
    companyAddress varchar(100) not null,
    phone varchar(20) not null check (phone regexp '^[0-9]{2,3}-[0-9]{3}-[0-9]{4}$'),
    email varchar(60)
);

create table Maintenance (
    maintenanceID int primary key,
    unitID int not null,
    -- Staff ID or company ID will be used to know who is performing the maintenance
    staffID int,
    companyID int,

    -- Timestamp for 
    scheduledDate timestamp not null,
    completedDate timestamp,
    notes varchar(100),

    foreign key (unitID) references Unit (unitID),
    foreign key (staffID) references Staff (staffID),
    foreign key (companyID) references ServiceCompany (companyID)
);

-- Insert statements for sample data into the tables

insert into Staff(staffID, firstName, lastName, phone, email, position) values
(1, 'Grant', 'Ferguson', '027-481-2093', 'grant.ferguson@equipeaserentals.co.nz', 'Manager'),
(2, 'Whitney', 'Marsh', '027-552-6614', 'whitney.marsh@equipeaserentals.co.nz', 'Manager'),
(3, 'Tama', 'Ropata', '021-340-7758', 'tama.ropata@equipeaserentals.co.nz', 'Staff'),
(4, 'Aroha', 'Winiata', '022-918-4471', 'aroha.winiata@equipeaserentals.co.nz', 'Staff'),
(5, 'Colin', 'Baxter', '021-662-0038', 'colin.baxter@equipeaserentals.co.nz', 'Left');
 
insert into Branch(branchID, branchAddress, phone, managerID) values
(1, '184 Anglesea Street, Hamilton Central, Hamilton 3204', '078-390-1220', 1),
(2, '58 Maui Street, Pukete, Hamilton 3200', '078-850-4317', 2),
(3, '20 Maui Street, Pukete, Hamilton 3200', '078-850-4317', 2),
(4, '23 Maui Street, Pukete, Hamilton 3200', '078-850-4317', 2);
 
insert into Category(categoryID, categoryName, parentCategoryID) values
(1, 'Power Tools', null),
(2, 'Access Equipment', null),
(3, 'Landscaping Equipment', null),
(4, 'Concrete & Compaction', null),
(5, 'Drills & Breakers', 1);
 
insert into Equipment(equipmentID, equipmentName, equipmentDesc, categoryID) values
(1, 'Makita Angle Grinder 125mm', 'Corded 9-inch angle grinder for cutting and grinding metal or masonry', 1),
(2, 'Genie GS-1932 Scissor Lift', 'Electric scissor lift, 7.9m platform height, indoor/outdoor use', 2),
(3, 'Honda Petrol Lawnmower', '21-inch self-propelled mower with rear roller for a striped finish', 3),
(4, 'Wacker Neuson Plate Compactor', 'Reversible plate compactor for paving and sub-base compaction', 4),
(5, 'Bosch SDS Rotary Hammer Drill', 'Corded rotary hammer drill for concrete drilling and light breaking', 5);
 
insert into Unit(unitID, unitStatus, equipmentID, branchID) values
(1, 'Available', 1, 1),
(2, 'Rented', 2, 1),
(3, 'Maintenance', 3, 2),
(4, 'Available', 3, 2),
(5, 'Available', 3, 2),
(6, 'Available', 4, 1),
(7, 'Rented', 5, 2),
(8, 'Available', 1, 2);
 
insert into Customer(customerID, firstName, lastName, email, phone) values
(1, 'Marcus', 'Delaney', 'marcus.delaney@gmail.com', '021-774-3390'),
(2, 'Huia', 'Ngata', 'huia.ngata@outlook.com', '022-401-6685'),
(3, 'Sione', 'Fifita', 'sione.fifita@yahoo.co.nz', '027-218-5539'),
(4, 'Loneet', 'Velaidan', 'loneet.velaidan@yahoo.co.nz', '027-222-5539');
 
insert into ServiceCompany(companyID, companyName, companyAddress, phone, email) values
(1, 'Waikato Small Engine Repairs', '123 Main Street', '07-847-3321', 'bookings@waikatosmallengine.co.nz'),
(2, 'Hamilton Hydraulics & Lift Services', '456 Oak Avenue', '07-855-9042', 'service@hamiltonhydraulics.co.nz'),
(3, 'Easy Fixing', '789 Pine Road', '07-999-9042', 'service@easyfixing.co.nz'),
(4, 'Fix It People', '321 Elm Street', '07-855-9999', 'service@fixitpeople.co.nz');
 
insert into Maintenance(maintenanceID, unitID, staffID, companyID, scheduledDate, completedDate, notes) values
(1, 3, 3, 1, '2026-08-25 09:00:00', '2026-08-29 09:00:00', 'Mower not starting, suspected fouled spark plug'),
(2, 7, 4, 1, '2026-08-20 09:00:00', '2026-08-22 09:00:00', 'Replaced worn SDS chuck, drill tested and returned to fleet'),
(3, 7, 4, 1, '2026-12-20 09:00:00', '2026-12-22 09:00:00', 'No issues found, drill returned to fleet'),
(4, 7, 4, 1, '2026-08-20 09:00:00', '2026-08-22 09:00:00', 'Drill tested and returned to fleet');
 
insert into RentSchedule(rentalID, customerID, unitID, pickupBranchID, returnBranchID, pickupDate, returnDate) values
(1, 1, 1, 1, null, '2026-09-05 09:00:00', '2026-09-06 09:00:00'),
(2, 1, 1, 1, null, '2026-09-05 09:00:00', '2026-09-06 09:00:00'),
(3, 1, 1, 1, null, '2026-09-05 09:00:00', '2026-09-06 09:00:00'),
(4, 1, 1, 1, null, '2026-09-05 09:00:00', '2026-09-06 09:00:00');

-- Select statements

select Unit.unitID, Equipment.equipmentName, Unit.unitStatus, Branch.branchAddress from Equipment
inner join Unit on Equipment.equipmentID = Unit.equipmentID
inner join Branch on Unit.branchID = Branch.branchID;

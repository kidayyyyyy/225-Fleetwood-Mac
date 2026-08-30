create table Staff (
    staffID int primary key,
    firstName varchar(30),
    lastName varchar(30),
    phone varchar(30),
    email varchar(30),
    position varchar(30) check (position in ('Manager', 'Staff', 'Retired'))
);

create table Customer (
    customerID int primary key,
    firstName varchar(30),
    lastName varchar(30),
    email varchar(30),
    phone varchar(30)
);

create table Branch (
    branchID int primary key,
    branchAddress varchar(100),
    phone varchar(10),
    managerID int,

    foreign key (managerID) references Staff(staffID)
);

create table Category (
    categoryID int primary key,
    categoryName varchar(30),
    parentCategoryID int DEFAULT null,

    foreign key (parentCategoryID) references Category (categoryID)
);

create table Equipment (
    equipmentID int primary key,
    equipmentName varchar(30),
    equipmentDesc varchar(100),
    parentCategoryID int,
    foreign key (parentCategoryID) references Category (parentCategoryID)
);

create table Unit (
    unitID int primary key,
    unitStatus varchar(30) check (unitStatus in ('Available', 'Rented', 'Maintenance')),
    equipmentID int,
    branchID int,

    foreign key (unitID) references Equipment (equipmentID),
    foreign key (branchID) references Branch (branchID)
);



create table RentSchedule (
    rentalID int,
    customerID int,
    unitID int,
    pickupBranchID int,
    returnBranchID int default null,

    primary key (rentalID, customerID, unitID),

    foreign key (customerID) references Customer (customerID),
    foreign key (unitID) references Unit (unitID),
    foreign key (pickupBranchID) references Branch (branchID),
    foreign key (returnBranchID) references Branch (branchID),
    
    pickupDate timestamp not null,
    returnDate timestamp not null,
    actualPickupDate timestamp,
    actualReturnDate timestamp
);

create table ServiceCompany(
    companyID int primary key,
    companyName varchar(30),
    phone varchar(30),
    email varchar(30)
);

create table Maintenance (
    maintenanceID int primary key,
    unitID int,
    staffID int,
    companyID int,

    scheduledDate date,
    completedDate date,
    notes varchar(50),

    foreign key (unitID) references Unit (unitID),
    foreign key (staffID) references Staff (staffID),
    foreign key (companyID) references ServiceCompany (companyID)
)

insert into Category(categoryID, categoryName, parentCategoryID) values
(1, 'Electronics', null),
(2, 'Computers', 1),
(3, 'Accessories', 1),
(4, 'Monitors', 2),
(5, 'Keyboards', 2);

insert into Equipment(equipmentID, equipmentName, equipmentDesc, parentCategoryID) values
(1, 'Equipment 1', 'Description 1', 1),
(2, 'Equipment 2', 'Description 2', 2),
(3, 'Equipment 3', 'Description 3', 3);

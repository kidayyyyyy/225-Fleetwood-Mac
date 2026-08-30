create table Staff (
    staffID int primary key,
    firstName varchar(30),
    lastName varchar(30),
    phone varchar(30),
    email varchar(30),
    position varchar(30)
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
    parentCategoryID int primary key,
    categoryName varchar(30),
    childCategoryID int default null,

    foreign key (childCategoryID) references Category(parentCategoryID)
);

create table Equipment (
    equipmentID int primary key,
    equip_name varchar(30),
    equip_descrip varchar(100),
    specification varchar(100),
    parentCategoryID int,

    foreign key (parentCategoryID) references Category(parentCategoryID)
);

create table Unit (
    unitID int primary key,
    unit_quantity int not null,
    equipmentID int,
    branchID int,

    foreign key (unitID) references Equipment(equipmentID),
    foreign key (branchID) references Branch(branchID)
);



create table RentSchedule (
    rentalID int,
    customerID int,
    unitID int,
    pickupBranchID int,
    returnBranchID int default null,

    primary key (rentalID, customerID, unitID),

    foreign key (customerID) references Customer(customerID),
    foreign key (unitID) references Unit(unitID),
    foreign key (pickupBranchID) references Branch(branchID),
    foreign key (returnBranchID) references Branch(branchID),
    
    pickupDate date not null,
    returnDate date,
    actualPickupDate date,
    actualReturnDate date
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

    foreign key (unitID) references Unit(unitID),
    foreign key (staffID) references Staff(staffID),
    foreign key (companyID) references ServiceCompany(companyID)
)


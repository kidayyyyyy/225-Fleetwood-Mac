drop table maintenance;
drop table SERVICE_COMPANY;
drop table rent_schedule;
drop table 

--create table parentcategory(
    parentCategoryID int default null,
    parentcat_name varchar(30),
    categoryID int,
);

create table CATEGORY (
    categoryID int primary default null,
    categoryName varchar(30),
    parentCategoryID int,

    foreign key parentCategoryID references CATEGORY(categoryID)
);

create table EQUIPMENT(
    equipmentID int primary,
    equip_name varchar(30),
    equip_descrip varchar(100),
    specification varchar(100),
    rcm_SafetyEquipment varchar(100),
    safetyNotes varchar(100),

    foreign key categoryID references CATEGORY(categoryID)
);

create table STAFF(
    staffID int primary,
    firstName varchar(30),
    lastName varchar(30),
    phone varchar(30),
    email varchar(30),
    position varchar(30),
);

create table BRANCH(
branchID int primary key,
main_address varchar(50),
Phone varchar(30),
managerID int,

foreign key managerID references STAFF(staffID)
);

ALTER TABLE STAFF
ADD CONSTRAINT
FOREIGN KEY (branchID) 
REFERENCES BRANCH(branchID);

create table UNIT (
    unitID int primary key,
    unit_status varchar(30),
    equipmentID int,
    branchID int,

    foreign key equipmentID references EQUIPMENT(equipmentID),
    foreign key branchID references BRANCH(branchID),
);

create table CUSTOMER (
    customerID int primary key,
    firstName varchar(30),
    lastName varchar(30),
    email varchar(30),
    phone varchar(30)
);

create table rent_schedule(
    rentalID int primary key,
    customerID int,
    unitID int,
    pickupBranchID int,
    returnBranchID int,

    foreign key customerID references CUSTOMER(customerID),
    foreign key unitID references UNIT(unitID),
    foreign key pickupBranchID references BRANCH(branchID),
    foreign key returnBranchID references BRANCH(branchID),
    
    pickupDate date,
    returnDate date,
    actualPickupDate date,
    actualReturnDate date
;)

create table SERVICE_COMPANY(
    companyID int primary,
    comp_name varchar(30),
    Phone varchar(30),
    Email varchar(30)
);

create table maintenance (
    maintenanceID int primary key,
    unitID int,
    staffID int,
    companyID int,

    foreign key unitID references UNIT(unitID),
    foreign key staffID references STAFF(staffID),
    foreign key companyID references SERVICE_COMPANY(companyID),

    scheduledDate date,
    completedDate date,
    notes varchar(50)
);



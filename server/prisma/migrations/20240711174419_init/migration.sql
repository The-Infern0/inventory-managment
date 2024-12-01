
CREATE TABLE CLASS (
ClassID int not null AUTO_INCREMENT PRIMARY KEY,
ClassName varchar(12) not null,
BasePrice decimal(7,2) not null
);
# establishes the 4 types of classes of car that our company will use,
# as well as their cost WEEKLY; 
# later, 'duration' attribute refers to the number of weeks a car is rented out for
INSERT INTO CLASS (ClassName, BasePrice) VALUES ('Compact', 200);
INSERT INTO CLASS (ClassName, BasePrice) VALUES ('Subcompact', 300);
INSERT INTO CLASS (ClassName, BasePrice) VALUES ('Sedan', 400);
INSERT INTO CLASS (ClassName, BasePrice) VALUES ('Luxury', 650);


CREATE TABLE TANK (
TankID int not null AUTO_INCREMENT PRIMARY KEY,
TankStatus varchar(12) not null
);
INSERT INTO TANK (TankStatus) VALUES ('Empty');
INSERT INTO TANK (TankStatus) VALUES ('1/4 Full');
INSERT INTO TANK (TankStatus) VALUES ('1/2 Full');
INSERT INTO TANK (TankStatus) VALUES ('3/4 Full');
INSERT INTO TANK (TankStatus) VALUES ('Full');

CREATE TABLE CAR (
CarID int not null AUTO_INCREMENT PRIMARY KEY,
VIN varchar(17) not null,
ClassID int not null, 
Model varchar(20) not null,
Make varchar(20) not null,
Color varchar(15) not null,
LPlate varchar(12) not null,
Odometer int DEFAULT 0,
TankID int DEFAULT 5,
FOREIGN KEY (ClassID) REFERENCES CLASS(ClassID),
FOREIGN KEY (TankID) REFERENCES TANK(TankID),
CONSTRAINT NonNegativeOdometer CHECK (Odometer > -1)


);

CREATE TABLE ADDRESS (
AddressID int not null AUTO_INCREMENT PRIMARY KEY,
Street varchar(25)  not null,
AbodeNumber int,
City varchar(15) not null,
ZipCode varchar(10) not null,
State varchar(2) not null
);

CREATE TABLE BRANCH (
BranchID int not null AUTO_INCREMENT PRIMARY KEY,
BStreet varchar(35) not null ,
BCity varchar(15) not null ,
BState varchar(2) not null,
BZipCode varchar(10) not null,
isHQ boolean DEFAULT false
);

-- lets establish our common branches. we will have 11 branches, 1 of which is HQ
INSERT INTO BRANCH (BStreet, BCity, BState, BZipCode) 
VALUES ('Main Street', 'varcharlotte', 'NC', 28202);
INSERT INTO BRANCH (BStreet, BCity, BState, BZipCode) 
VALUES ('Peachtree Street', 'Atlanta', 'GA', 30303);
INSERT INTO BRANCH (BStreet, BCity, BState, BZipCode) 
VALUES ('Market Street', 'Wilmington', 'NC', 28401);
INSERT INTO BRANCH (BStreet, BCity, BState, BZipCode) 
VALUES ('Broad Street', 'Columbus', 'GA', 31901);
INSERT INTO BRANCH (BStreet, BCity, BState, BZipCode) 
VALUES ('Beale Street', 'Memphis', 'TN', 38103);
INSERT INTO BRANCH (BStreet, BCity, BState, BZipCode) 
VALUES ('King Street', 'varcharleston', 'SC', 29401);
INSERT INTO BRANCH (BStreet, BCity, BState, BZipCode) 
VALUES ('Church Street', 'Nashville', 'TN', 37219);
INSERT INTO BRANCH (BStreet, BCity, BState, BZipCode) 
VALUES ('Dexter Avenue', 'Montgomery', 'AL', 36104);
INSERT INTO BRANCH (BStreet, BCity, BState, BZipCode) 
VALUES ('Dauphin Street', 'Mobile', 'AL', 36602);
INSERT INTO BRANCH (BStreet, BCity, BState, BZipCode) 
VALUES ('Front Street', 'Beaufort', 'SC', 29902);
INSERT INTO BRANCH(BStreet, BCity, BState, BZipCode, isHQ) 
VALUES ('Kingsley Street', 'Fort Mill', 'SC', 29715, true);




CREATE TABLE CUSTOMER(
CustomerID int not null auto_increment PRIMARY KEY,
DL varchar(25) not null,
FName varchar(20) not null,
LName varchar(20) not null,
AddressID int not null,
isPreferred boolean DEFAULT false,
FOREIGN KEY (AddressID) REFERENCES ADDRESS(AddressID)
);

CREATE TABLE PHONE(
CustomerID int not null,
PhoneNumber varchar(14) not null,
FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID)
);

CREATE TABLE EMPLOYEE(
EmployeeID int not null auto_increment primary key,
Emp_Type varchar(15) not null,
BranchID int not null,
CustomerID int not null,
isPres boolean default false,
FOREIGN KEY (BranchID) REFERENCES BRANCH(BranchID),
FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID)
);

CREATE TABLE PRESIDENTS (
EmployeeID int not null,
PresTitle varchar(25) not null,
FOREIGN KEY (EmployeeID) REFERENCES EMPLOYEE(EmployeeID)
);

CREATE TABLE RENTAL (
RentalID int not null auto_increment primary key ,
CarID int not null,
CustomerID int not null,
FromDate date not null, 
StartOdometer int not null,
EndOdometer int default null,
FromLocation int not null,
ToLocation int default null,
EndTank int default null,
Duration int not null,
FOREIGN KEY (CarID) REFERENCES CAR(CarID),
FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID),
FOREIGN KEY (FromLocation) REFERENCES BRANCH(BranchID),
FOREIGN KEY (ToLocation) REFERENCES BRANCH(BranchID),
FOREIGN KEY (EndTank) REFERENCES TANK(TankID),
CONSTRAINT NonZeroDuration CHECK (Duration > 0)
);

CREATE TABLE DURATION(
RentalID int not null primary key,
FromDate date not null,
Duration int not null,
ToDate date not null,
FOREIGN KEY (RentalID) REFERENCES RENTAL(RentalID)
-- implmenet ToDate later
);


CREATE TABLE BASEPRICE(
ClassID int not null, 
RentalID int not null,
WeeklyBasePrice decimal(7,2) not null,
Duration int not null,
FinalBasePrice decimal(7,2) not null,
PRIMARY KEY (ClassID, RentalID),
FOREIGN KEY (ClassID) REFERENCES CLASS(ClassID),
FOREIGN KEY (RentalID) REFERENCES RENTAL(RentalID)
);

CREATE TABLE PROMO (
ClassID int not null,
PromoValue decimal(6,3) not null,
PromoDuration int not null,
PromoStartDate date not null,
PromoEndDate date not null,
FOREIGN KEY (ClassID) REFERENCES CLASS(ClassID)
);

CREATE TABLE FINALPRICE (
PriceID int not null auto_increment primary key,
RentalID int not null,
FinalBasePrice decimal(6,3) not null,
PromoValue decimal(6,3) not null default 1.0, 
EmpDiscount decimal(6,3) default 1.0, -- erm what teh sigma
FinalPrice decimal(7,2) not null,
FOREIGN KEY (RentalID) REFERENCES RENTAL(RentalID)
);
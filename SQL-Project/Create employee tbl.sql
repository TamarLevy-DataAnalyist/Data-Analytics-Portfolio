	--על הפרויקט:
	--בפרויקט זה בניתי מסד נתונים רלציוני בשם RetailManagement, 
	--המדמה מערכת ניהול של רשת קמעונאית בסגנון רשת "רמי לוי".
	--מסד הנתונים כולל חמש טבלאות, כאשר כל טבלה מייצגת ישות עסקית שונה, והקשרים ביניהן
	--ממומשים באמצעות מפתחות ראשיים ומפתחות זרים.
	--:תיאור הטבלאות
--טבלת Employees מכילה מידע על עובדי הרשת, כגון שם, תאריך לידה, כתובת וטלפון. לכל עובד מזהה ייחודי (EmployeeID), והוא יכול להיות משויך למספר הזמנות
--טבלת Customers כוללת נתונים על לקוחות הרשת, כגון שם לקוח, כתובת, עיר ופרטי קשר. לכל לקוח מזהה ייחודי (CustomerID), ולקוח אחד יכול לבצע מספר הזמנות
--טבלת Categories מייצגת קטגוריות של מוצרים (כגון משקאות, מוצרי חלב, ניקיון ועוד), ומאפשרת סיווג מוצרים לפי תחום.
--טבלת Products מכילה מידע על המוצרים הנמכרים ברשת, כולל שם מוצר, מחיר, כמות במלאי וכמות בהזמנה. כל מוצר משויך לקטגוריה אחת באמצעות מפתח זר (CategoryID).
--טבלת Orders מייצגת הזמנות שבוצעו במערכת וכוללת מידע על תאריך ההזמנה, הלקוח שביצע אותה, העובד שטיפל בה, עלות משלוח ופרטי יעד. הטבלה מקשרת בין לקוחות לעובדים ומהווה את מרכז המידע.
--:קשרים בין הטבלאות
--במערכת קיימים קשרים של אחד-לרבים
--לקוח אחד יכול לבצע מספר הזמנות 1
--2 עובד אחד יכול לטפל במספר הזמנות
--קטגוריה אחת יכולה להכיל מספר מוצרים 3
--הקשרים ממומשים באמצעות Foreign Keys,
--מה שמבטיח שלמות נתונים ומניעת הזנת נתונים לא תקינים.
--השימוש במפתחות ראשיים מסוג IDENTITY
--מאפשר יצירת מזהים ייחודיים באופן אוטו' ומייעל את הרצת הנתונים.


CREATE DATABASE  RetailManagement
GO


USE RetailManagement
GO


CREATE TABLE Employees(
EmployeeID INT PRIMARY KEY IDENTITY(1,1) not null,
FirstName VARCHAR(20) null,
LastName VARCHAR(20) null,
BirthDate DATETIME null,
Address VARCHAR (60)null,
City VARCHAR (15)null,
PostalCode VARCHAR (15)null,
Country VARCHAR (15)null,
PhoneNumber VARCHAR (24)null,
)
GO

CREATE TABLE Categories(
CategoryID INT PRIMARY KEY IDENTITY(1,1)  not null,
CategoryName VARCHAR(40) null,
DESCRIPTION VARCHAR(max) null,
)
GO

CREATE TABLE Products(
ProductID INT PRIMARY KEY IDENTITY(1,1)  not null,
ProductName VARCHAR(40) null,
CategoryID INT FOREIGN KEY REFERENCES Categories(CategoryID),
UnitPrice INT null,
UnitsInStock INT null,
UnitsOnOrder INT null,
)
GO

CREATE TABLE Customers(
CustomerID INT PRIMARY KEY IDENTITY(1,1)  not null,
Address VARCHAR(40) null,
CustomerName VARCHAR (20),
City VARCHAR (50) null,
Country VARCHAR(25) null,
Phone VARCHAR (10) null,
Fax VARCHAR(10) null,
Email VARCHAR(50)
)
GO

CREATE TABLE Orders(
OrderID INT PRIMARY KEY IDENTITY(1,1)  not null,
CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
Orderdate DateTime null,
EmployeeID  INT FOREIGN KEY REFERENCES Employees(EmployeeID),
Freight INT null,
OrderName  VARCHAR(40) null,
OrderCity  VARCHAR(40) null,
OrderPostalCode VARCHAR (10) null,
OrderCountry  VARCHAR(15) null,
RequiredDate DateTime null,
)
GO

INSERT INTO Employees(
FirstName,
LastName,
BirthDate,
Address,
City,
PostalCode,
Country,
PhoneNumber
)
VALUES
('SHIRA','LEVY','2001-04-23','SOKOLOV 23','JEROSALEM','12334','ISRAEL','0504134230'),
('DANI','COHEN','1985-07-12','BEN-DAVID 12','TEL-AVIV','4345','ISRAEL','0504112345'),
('ALMA','SHIP','1999-04-18','HERZOG 2','RAMAT-GAN','51527','ISRAEL','0548240196'),
('YAIR','PELEG','1977-01-01','YARDEN 14','HULON','58367','ISRAEL','0538200159'),
('HAIM','TABISI','1968-08-25','MATE 22','HERZELIA','92478','ISRAEL','0523840598'),
('YONATAN','AHARONOV','1993-11-02','KINGSTON 47','RAMAT-HASHSRON','51762','ISRAEL','0503819756'),
('SHIRLY','AMAR','2000-05-10','RAMBAM 8','NETANIA','98350','ISRAEL','0535830597'),
('ADI','COHEN','1960-09-30','NAMIR 156','BEIT-SHEMESH','49261','ISRAEL','0521128230'),
('AMIR','LEV','1974-02-06','ZVULUN 18','HOD-HASHARON','51973','ISRAEL','0509284763'),
('HANA','WISS','1962-12-14','ROKACH 13','HERZELIA','52504','ISRAEL','0548249339'),
('YAEL','BITON','1980-06-06','NAVE 28','JEROSALEM','29385','ISRAEL','0526683531'),
('DANIEL','KELMAN','1985-10-15','HALOCHMIM 6','TEL-AVIV','53281','ISRAEL','0533394052'),
('LIOR','FRENKEL','1989-03-28','MIVTAHIM 58','TEL-AVIV','50463','ISRAEL','0508249910'),
('DANA','LIEL','1990-12-02','GOLOMB 9','TEL-AVIV','57186','ISRAEL','0548494728'),
('AMIT','ROZEN','1995-08-17','GOREN 15','HOD-HASHARON','38051','ISRAEL','0542287736'),
('NOA','ALTER','2002-03-25','HASHOMER 69','RAANANA','39069','ISRAEL','0528407723'),
('NOAM','OFEK','1982-07-13','HAYARKON 148','TEL-AVIV','51542','ISRAEL','0518924039'),
('ARI','GRIN','1968-10-09','HAROEH 133','JEROSALEM','27048','ISRAEL','0523374401'),
('SARA','PEKTOR','1997-11-04','KALISHER 10','HERZELIA','30369','ISRAEL','0557923045'),
('OMER','LEVIN','1983-02-16','BEN-GURYON 187','RAANANA','38107','ISRAEL','0504293955');

GO

INSERT INTO Categories(
CategoryName,
DESCRIPTION
)
VALUES
('Beverages','Soft drinks, coffees, teas, beers'),
('Condiments','Sweet and savory sauces, relishes'),
('Confections','Desserts, candies, and sweet breads'),
('Dairy Products','Cheeses, milk, and yogurt'),
('Grains','Breads, cereals, pasta, and rice'),
('Meat','Prepared and fresh meat'),
('Seafood','Fish and seafood products'),
('Produce','Fresh fruits and vegetables'),
('Frozen Foods','Frozen meals and ingredients'),
('Snacks','Chips, crackers, and snack foods'),
('Bakery','Fresh bread and baked goods'),
('Spices','Herbs, spices, and seasonings'),
('Canned Goods','Canned vegetables and fruits'),
('Breakfast','Breakfast cereals and spreads'),
('Beverage Alcohol','Wine, beer, and spirits'),
('Health Foods','Organic and health products'),
('Baby Products','Food and products for babies'),
('Pet Supplies','Food and products for pets'),
('Cleaning Products','Household cleaning items'),
('Personal Care','Cosmetics and hygiene products');
GO

INSERT INTO Products(
ProductName,
CategoryID,
UnitPrice,
UnitsInStock,
UnitsOnOrder
)
VALUES

('Cola Drink', 1,7,120,30),
('Orange Juice',1,8,80,20),
('Ketchup Bottle',2,6,60,15),
('Chocolate Bar',3,5,200,50),
('Cheddar Cheese',4, 12,40,10),
('White Bread',5,4,150,25),
('Fresh Chicken',6,18,35,12),
('Salmon Fillet',7,25,20,5),
('Red Apples',8,3,300,40),
('Frozen Pizza',9,15,70,20),
('Potato Chips',10,6,180,35),
('Croissant',11,5,130,30),
('Black Pepper',12,4,90,15),
('Canned Corn',13,5,160,25),
('Breakfast Cereal',14,14,85,20),
('Red Wine Bottle',15,35,40,10),
('Organic Honey',16,22,55,15),
('Baby Formula',17,28,30,10),
('Dog Food Bag',18,20,45,12),
('Laundry Detergent',19,18,60,20);

GO

INSERT INTO Customers(
Address,
City, 
CustomerName,
Country, 
Phone, 
Fax,
Email
)

VALUES
('Herzl 10','Tel Aviv','Dani Cohen','Israel','03-5551111','03-5551112','dani.cohen@mail.com'),
('Ben Gurion 25','Jerusalem','Yael Levy','Israel','02-6223344','02-6223345','yael.levy@mail.com'),
('Rothschild 3','Tel Aviv','Amir Katz','Israel','03-7778899','03-7778890','amir.katz@mail.com'),
('HaNassi 14','Haifa','Sharon Mizrahi','Israel','04-8662233','04-8662234','sharon.mizrahi@mail.com'),
('Weizmann 8','Rehovot','Ronen Adler','Israel','08-9445566','08-9445567','ronen.adler@mail.com'),
('Begin 19','Ashdod','Orly Shahar','Israel','08-8557788','08-8557789','orly.shahar@mail.com'),
('Sokolov 45','Ramat Gan','Tal Green','Israel','03-6778899','03-6778800','tal.green@mail.com'),
('Hillel 7','Jerusalem','Noa Peretz','Israel','02-6332211','02-6332212','noa.peretz@mail.com'),
('Bialik 12','Holon','Eli Shavit','Israel','03-5083344','03-5083345','eli.shavit@mail.com'),
('Hasharon 6','Herzliya','Michal Oren','Israel','09-9556677','09-9556678','michal.oren@mail.com'),
('Galil 18','Tiberias','Yossi Dagan','Israel','04-6723344','04-6723345','yossi.dagan@mail.com'),
('Arlozorov 22','Tel Aviv','Neta Rosen','Israel','03-6889911','03-6889912','neta.rosen@mail.com'),
('HaPalmach 9','Beer Sheva','Gil Aviv','Israel','08-6467788','08-6467789','gil.aviv@mail.com'),
('Hagana 30','Petah Tikva','Liron Sade','Israel','03-9221133','03-9221134','liron.sade@mail.com'),
('Jabotinsky 55','Bnei Brak','Avraham Gold','Israel','03-5788899','03-5788800','avraham.gold@mail.com'),
('Derech Yam 4','Eilat','Maya Levin','Israel','08-6374455','08-6374456','maya.levin@mail.com'),
('Nahalal 11','Kfar Saba','Eran Tamir','Israel','09-7678899','09-7678800','eran.tamir@mail.com'),
('Hadar 2','Nazareth','Samir Haddad','Israel','04-6567788','04-6567789','samir.haddad@mail.com'),
('Yefe Nof 16','Haifa','Rina Azoulay','Israel','04-8334455','04-8334456','rina.azoulay@mail.com'),
('HaShaked 5','Modiin','Itay Ben-Ami','Israel','08-9701122','08-9701123','itay.benami@mail.com');

GO

INSERT INTO Orders(
CustomerID, 
Orderdate, 
EmployeeID,
Freight,
OrderName,
OrderCity,
OrderPostalCode,
OrderCountry,
RequiredDate
)

VALUES
(1,'2024-01-05',3,120, 'Order Cola', 'Tel Aviv','61000','Israel','2024-01-12'),
(2,'2024-01-06',5,80, 'Order Juice', 'Jerusalem','91000','Israel','2024-01-13'),
(3,'2024-01-07',2,60, 'Order Snacks','Tel Aviv','62000','Israel','2024-01-14'),
(4,'2024-01-08',4,150, 'Order Cheese','Haifa','33000','Israel','2024-01-15'),
(5,'2024-01-09',1,90, 'Order Bread','Rehovot','76000','Israel','2024-01-16'),
(6,'2024-01-10',6,110, 'Order Meat','Ashdod','77000','Israel','2024-01-17'),
(7,'2024-01-11',7,200, 'Order Fish','Ramat Gan','52000','Israel','2024-01-18'),
(8,'2024-01-12',8,75, 'Order Produce','Holon','58000','Israel','2024-01-19'),
(9,'2024-01-13',2,95, 'Order Frozen','Herzliya','46000','Israel','2024-01-20'),
(10,'2024-01-14',3,130, 'Order Snacks','Beer Sheva','84000','Israel','2024-01-21'),
(11,'2024-01-15',4,85, 'Order Bakery','Tel Aviv','61000','Israel','2024-01-22'),
(12,'2024-01-16',5,140, 'Order Spices','Haifa','33000','Israel','2024-01-23'),
(13,'2024-01-17',6,70, 'Order Canned','Petah Tikva','49000','Israel','2024-01-24'),
(14,'2024-01-18',7,160, 'Order Breakfast','Tel Aviv','62000','Israel','2024-01-25'),
(15,'2024-01-19',8,220, 'Order Wine','Jerusalem','91000','Israel','2024-01-26'),
(16,'2024-01-20',1,100, 'Order Health','Kfar Saba','44000','Israel','2024-01-27'),
(17,'2024-01-21',2,180, 'Order Baby','Nazareth','16000','Israel','2024-01-28'),
(18,'2024-01-22',3,90, 'Order Pets','Eilat','88000', 'Israel','2024-01-29'),
(19,'2024-01-23',4,110, 'Order Cleaning','Modiin','71700','Israel','2024-01-30'),
(20,'2024-01-24',5,125, 'Order Personal','Netanya','42000','Israel','2024-01-31');




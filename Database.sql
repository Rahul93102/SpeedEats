
CREATE DATABASE Blinkit;
USE Blinkit;
DROP TABLE IF EXISTS Customer;
CREATE TABLE Customer (
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    street_no VARCHAR(20),
    street_name VARCHAR(100),
    apt VARCHAR(20),
    city VARCHAR(100) NOT NULL,
    state VARCHAR(50) NOT NULL,
    zip_code VARCHAR(20) NOT NULL,
    phone_no VARCHAR(20) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    age INTEGER(30) NOT NULL, 
    Gender VARCHAR(10) NOT NULL, 
    check (Gender in ('Male', 'Female', 'Others')),
    User_ID INTEGER NOT NULL PRIMARY KEY auto_increment
); -- Removed the semicolon
INSERT INTO Customer (first_name, middle_name, last_name, email, street_no, street_name, apt, city, state, zip_code, phone_no, password, age, Gender)
VALUES 
('John', 'A', 'Doe', 'john.doe@example.com', '123', 'Main Street', 'Apt 101', 'Anytown', 'CA', '12345', '555-1230', 'password1', 32, 'Male'),
('Jane', 'B', 'Smith', 'jane.smith@example.com', '456', 'Maple Avenue', 'Apt 202', 'Otherville', 'NY', '67890', '555-5678', 'password2', 37, 'Female'),
('Michael', NULL, 'Johnson', 'michael.j@example.com', '789', 'Oak Street', NULL, 'Smalltown', 'TX', '45678', '555-9019', 'password3', 34, 'Male'),
('Emily', 'C', 'Brown', 'emily.b@example.com', '1011', 'Cedar Avenue', 'Apt 303', 'Villageton', 'FL', '90123', '555-3456', 'password4', 29, 'Female'),
('Christopher', 'D', 'Lee', 'chris.lee@example.com', '1213', 'Pine Street', NULL, 'Townsville', 'WA', '23456', '555-7890', 'password5', 41, 'Male'),
('Sarah', NULL, 'Taylor', 'sarah.t@example.com', '1415', 'Elm Road', 'Apt 404', 'Metropolis', 'IL', '34567', '555-2345', 'password6', 32, 'Female'),
('Matthew', 'E', 'White', 'matt.white@example.com', '1617', 'Birch Lane', NULL, 'Cityville', 'MA', '45678', '555-6789', 'password7', 44, 'Male'),
('Amanda', 'F', 'Anderson', 'amanda.a@example.com', '1819', 'Rose Street', 'Apt 505', 'Hamlet', 'NJ', '56789', '555-1234', 'password8', 35, 'Female'),
('David', 'G', 'Martinez', 'david.m@example.com', '2021', 'Magnolia Drive', NULL, 'Village', 'PA', '67890', '555-0000', 'password9', 33, 'Male'),
('Jessica', NULL, 'Wilson', 'jessica.w@example.com', '2223', 'Sunset Boulevard', 'Apt 606', 'Hometown', 'OH', '78901', '555-9012', 'password10', 28, 'Female');
-- Disable foreign key checks
SET FOREIGN_KEY_CHECKS=0;
-- Drop the Vendor table if it exists
DROP TABLE IF EXISTS Vendor;
-- Recreate the Vendor table with the specified structure
CREATE TABLE Vendor (
    vendor_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    GST_Number VARCHAR(20) NOT NULL UNIQUE,
    street_no VARCHAR(20),
    street_name VARCHAR(100),
    apt VARCHAR(20),
    Opening_Time TIME NOT NULL,
    Closing_Time TIME NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(50) NOT NULL,
    zip_code VARCHAR(20) NOT NULL,
    CHECK (Closing_Time > Opening_Time)
);
-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS=1;
INSERT IGNORE INTO Vendor (first_name, middle_name, last_name, phone_number, GST_Number, street_no, street_name, apt, city, state, zip_code, Opening_Time, Closing_Time) 
VALUES 
('John', 'A', 'Vendor1', '555-1234', 'GST123456789', '123', 'Main Street', 'Apt 101', 'Anytown', 'CA', '12345', '08:00:00', '18:00:00'),
('Jane', 'B', 'Vendor2', '555-5678', 'GST987654321', '456', 'Maple Avenue', 'Apt 202', 'Otherville', 'NY', '67890', '09:00:00', '19:00:00'),
('Michael', NULL, 'Vendor3', '555-9012', 'GST456789123', '789', 'Oak Street', NULL, 'Smalltown', 'TX', '45678', '10:00:00', '20:00:00'),
('Emily', 'C', 'Vendor4', '555-3456', 'GST789123456', '1011', 'Cedar Avenue', 'Apt 303', 'Villageton', 'FL', '90123', '08:30:00', '18:30:00'),
('Christopher', 'D', 'Vendor5', '555-7890', 'GST234567891', '1213', 'Pine Street', NULL, 'Townsville', 'WA', '23456', '09:30:00', '19:30:00'),
('Sarah', NULL, 'Vendor6', '555-2345', 'GST678912345', '1415', 'Elm Road', 'Apt 404', 'Metropolis', 'IL', '34567', '10:30:00', '20:30:00'),
('Matthew', 'E', 'Vendor7', '555-6789', 'GST345678912', '1617', 'Birch Lane', NULL, 'Cityville', 'MA', '45678', '08:00:00', '18:00:00'),
('Amanda', 'F', 'Vendor8', '555-1234', 'GST891234567', '1819', 'Rose Street', 'Apt 505', 'Hamlet', 'NJ', '56789', '09:00:00', '19:00:00'),
('David', 'G', 'Vendor9', '555-5678', 'GST456789123', '2021', 'Magnolia Drive', NULL, 'Village', 'PA', '67890', '10:00:00', '20:00:00'),
('Jessica', NULL, 'Vendor10', '555-9012', 'GST123456789', '2223', 'Sunset Boulevard', 'Apt 606', 'Hometown', 'OH', '78901', '08:30:00', '18:30:00');
-- Disable foreign key checks
SET FOREIGN_KEY_CHECKS=0;
-- Drop the foreign key constraint referencing Cart in Orders table
ALTER TABLE Orders DROP FOREIGN KEY orders_ibfk_1;
-- Drop the Cart table
DROP TABLE IF EXISTS Cart;
-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS=1;
-- Recreate the Cart table
CREATE TABLE Cart (
    cart_id INT PRIMARY KEY AUTO_INCREMENT
);
-- Disable foreign key checks
SET FOREIGN_KEY_CHECKS=0;
-- Drop the Orders table if it exists
DROP TABLE IF EXISTS Orders;
-- Recreate the Orders table with the foreign key constraint
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    cart_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    location VARCHAR(255) NOT NULL, 
    FOREIGN KEY (cart_id) REFERENCES Cart(cart_id)
);
-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS=1;
DROP TABLE IF EXISTS GIVE;
CREATE TABLE GIVE (
    order_id  int NOT NULL REFERENCES school
 , vendor_id int NOT NULL REFERENCES student
 , PRIMARY KEY (order_id, vendor_id)
);
DROP TABLE IF EXISTS Payment;
CREATE TABLE payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    payment_date DATE NOT NULL,
    payment_type VARCHAR(50)NOT NULL,
    amount DECIMAL(10, 2),
    transaction_id INT NOT NULL
);
-- Populate the Cart table with some data
INSERT INTO Cart (cart_id) VALUES (1), (2), (3), (4), (5);
INSERT INTO Orders (cart_id, quantity, price, location)
VALUES
(1, 2, 10.50, 'Location A'),
(2, 1, 15.75, 'Location B'),
(3, 3, 20.00, 'Location C'),
(4, 2, 12.00, 'Location D'),
(5, 2, 18.50, 'Location E');
-- Populate GIVE table
INSERT INTO GIVE (order_id, vendor_id)
VALUES
(1, 101),
(2, 102),
(3, 103),
(4, 104),
(5, 105),
(6, 106),
(7, 107),
(8, 108);
-- Populate Payment table
INSERT INTO Payment (payment_date, payment_type, amount, transaction_id)
VALUES
('2024-02-01', 'Credit Card', 50.00, 101),
('2024-02-02', 'Cash', 25.00, 102),
('2024-02-03', 'Debit Card', 35.00, 103),
('2024-02-04', 'Credit Card', 40.00, 104),
('2024-02-05', 'Cash', 30.00, 105),
('2024-02-06', 'Credit Card', 20.00, 106),
('2024-02-07', 'Debit Card', 45.00, 107),
('2024-02-08', 'Cash', 15.00, 108);
SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS Wishlist;
SET FOREIGN_KEY_CHECKS=1;
-- Create the Wishlist table with a foreign key constraint referencing the Cart table
CREATE TABLE Wishlist (
    wishlist_id INT PRIMARY KEY AUTO_INCREMENT,
    cart_id INT,
    FOREIGN KEY (cart_id) REFERENCES Cart(cart_id)
);
-- Now, you can insert data into the Wishlist table
INSERT INTO Wishlist (cart_id)
VALUES (1), (2), (3), (4), (5);
SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS Product;
SET FOREIGN_KEY_CHECKS=1;
CREATE TABLE Product (
  product_id INT PRIMARY KEY AUTO_INCREMENT,
  product_name VARCHAR(255) NOT NULL,
  quantity INT NOT NULL DEFAULT 0,
  price DECIMAL(10,2) NOT NULL,
  wishlist_id INT,
  cart_id INT,
  FOREIGN KEY (wishlist_id) REFERENCES Wishlist(wishlist_id),
  FOREIGN KEY (cart_id) REFERENCES Cart(cart_id)
);
-- Insert data into the Product table
INSERT INTO Product (product_name, quantity, price)
VALUES
  ('Cozy Cotton T-Shirt', 50, 19.99),
  ('Smartwatch with Fitness Tracker', 20, 149.99),
  ('Wooden Desk Organizer', 10, 24.95),
  ('Gourmet Coffee Blend', 35, 12.99),
  ('Noise-Cancelling Headphones', 15, 79.99),
  ('Travel Backpack with Laptop Compartment', 25, 45.99),
  ('Set of 3 Scented Candles', 40, 19.99),
  ('Water-resistant Hiking Boots', 12, 99.99),
  ('Organic Vegan Protein Powder', 8, 34.99),
  ('Educational Board Game for Kids', 18, 29.99);
SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS Warehouse;
SET FOREIGN_KEY_CHECKS=1;
CREATE TABLE Warehouse (
    warehouse_id INT AUTO_INCREMENT PRIMARY KEY,
    location VARCHAR(100) NOT NULL,
    capacity INT NOT NULL,
    vendor_id INT,
    FOREIGN KEY (vendor_id) REFERENCES Vendor(vendor_id)
);
-- Insert data into the Warehouse table
INSERT INTO Warehouse (location, capacity) 
VALUES 
('Location 1', 1000),
('Location 2', 1500),
('Location 3', 1200),
('Location 4', 800),
('Location 5', 1000),
('Location 6', 1100),
('Location 7', 900),
('Location 8', 1300),
('Location 9', 1400),
('Location 10', 1000);
-- Drop the table if it exists
DROP TABLE IF EXISTS Store;
-- Create the Store table with corrected references
CREATE TABLE Store (
    warehouse_id INT NOT NULL, -- Corrected column name
    product_id INT NOT NULL, -- Corrected column name
    PRIMARY KEY (warehouse_id, product_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id), -- Corrected foreign key reference
    FOREIGN KEY (product_id) REFERENCES Product(product_id) -- Corrected foreign key reference
);
SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS Delivery;
SET FOREIGN_KEY_CHECKS=1;
CREATE TABLE Delivery (
    delivery_id INT NOT NULL,
    vendor_id INT NOT NULL,
    PRIMARY KEY (delivery_id, vendor_id),
    FOREIGN KEY (delivery_id) REFERENCES Warehouse(warehouse_id),
    FOREIGN KEY (vendor_id) REFERENCES Vendor(vendor_id)
);
INSERT INTO Delivery (delivery_id, vendor_id)
VALUES
    (1, 1),
    (2, 5),
    (3, 7),
    (4, 3),
    (5, 6),
    (6, 4),
    (7, 8),
    (8, 2);
DROP TABLE IF EXISTS Take;
CREATE TABLE Take (
    delivery_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    PRIMARY KEY (delivery_id, warehouse_id),
    FOREIGN KEY (delivery_id) REFERENCES Delivery(delivery_id), -- Corrected foreign key reference
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id) -- Corrected foreign key reference
);
-- Populate the Store table
INSERT INTO Store (warehouse_id, product_id) 
VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);
INSERT INTO Take (delivery_id, warehouse_id)
VALUES
    (1, 1),
    (8, 2),
    (4, 3),
    (6, 4),
    (2, 5),
    (5, 6),
    (3, 7),
    (7, 8);
DROP TABLE IF EXISTS Manager;
CREATE TABLE Manager (
    manager_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    phone_no VARCHAR(20) NOT NULL,
    delivery_feedback VARCHAR(255),
    warehouse_id INT, -- Added the warehouse_id column
    FOREIGN KEY (warehouse_id) REFERENCES warehouse(warehouse_id) -- Corrected the foreign key reference
);
INSERT INTO Manager (name, phone_no, delivery_feedback, warehouse_id)
VALUES 
('John Doe', '123-456-7890', 'Good', 1),
('Jane Smith', '456-789-0123', 'Excellent', 2),
('Michael Johnson', '789-012-3456', 'Satisfactory', 3),
('Emily Davis', '321-654-9870', 'Good', 4),
('Chris Wilson', '654-987-0123', 'Excellent', 5),
('Sarah Brown', '987-012-3456', 'Satisfactory', 6),
('Alex Lee', '111-222-3333', 'Good', 7),
('Jessica Garcia', '444-555-6666', 'Excellent', 8),
('Ryan Martinez', '777-888-9999', 'Satisfactory', 9),
('Michelle Rodriguez', '000-999-8888', 'Good', 10);
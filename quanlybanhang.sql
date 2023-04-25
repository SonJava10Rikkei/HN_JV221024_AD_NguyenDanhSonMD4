create database QUANLYBANHANG;
use QUANLYBANHANG;

create table CUSTOMERS(
customer_id varchar(4) primary key not null,
name varchar(100) not null,
email varchar (100) not null,
phone varchar(25) not null,
address varchar(255) not null
);

create table ORDERS(
order_id varchar(4) primary key not null,
customer_id varchar(4) not null,
order_date date not null,
total_amount double not null,
foreign key (customer_id) references CUSTOMERS(customer_id)
);

create table PRODUCTS(
product_id varchar(4) primary key not null,
name varchar(255) not null,
description text,
price double not null,
status bit(1) not null
);

create table ORDERS_DETAILS(
order_id varchar(4)not null,
product_id varchar(4) not null,
quantity int(11) not null,
price double not null,
primary key(order_id, product_id),
foreign key (order_id) references ORDERS(order_id),
foreign key (product_id) references PRODUCTS(product_id)
);

-- Bài 2: Thêm dữ liệu [20 điểm]:

insert into CUSTOMERS values
('C001', 'Nguyễn Trung Mạnh','manhnt@gmail.com','0984756322','Cầu Giấy, Hà Nội'),
('C002', 'Hồ Hải Nam','namhh@gmail.com','0984875926','Ba Vì, Hà Nội'),
('C003', 'Tô Ngọc Vũ','vutn@gmail.com','0904725784','Mộc Châu, Sơn La'),
('C004', 'Phạm Ngọc Anh','anhpn@gmail.com','0984635365','Vinh, Nghệ An'),
('C005', 'Trương Minh Cương','cuongtm@gmail.com','0989735624','Hai Ba Trưng, Hà Nội')
;

insert into PRODUCTS values 
('P001', 'Iphone 13 ProMax','Bản 512 GB, xanh lá', 22999999,1),
('P002', 'Dell Vostro V3510','Core i5, RAM 8GB', 14999999,1),
('P003', 'Macbook Pro M2','8CPU 10CPU 8GB 256GB', 28999999,1),
('P004', 'Apple Watch Ultra','Titanium Alpine Loop Small', 18999999,1),
('P005', 'Airpods 2 2022','Spatial Audio', 4090000,1)
;


insert into ORDERS( order_id, customer_id, total_amount, order_date) values 
('H001', 'C001',52999997,'2023-2-22'),
('H002', 'C001',80999997,'2023-3-11'),
('H003', 'C002',54359998,'2023-1-22'),
('H004', 'C003',102999995,'2023-3-14'),
('H005', 'C003',80999997,'2022-3-12'),
('H006', 'C004',110449994,'2023-2-1'),
('H007', 'C004',79999996,'2023-3-29'),
('H008', 'C005',29999998,'2023-2-14'),
('H009', 'C005',28999999,'2023-1-10'),
('H010', 'C005',149999994,'2023-4-1')
;

insert into ORDERS_DETAILS( order_id, product_id, price, quantity) values 
('H001','P002',14999999,1),
('H001','P004',18999999,2),
('H002','P001',22999999,1),
('H002','P003',28999999,2),
('H003','P004',18999999,2),
('H003','P005',4090000,4),
('H004','P002',14999999,3),
('H004','P003',28999999,2),
('H005','P001',22999999,1),
('H005','P003',28999999,2),
('H006','P005',4090000,5),
('H006','P002',14999999,6),
('H007','P004',18999999,3),
('H007','P001',22999999,1),
('H008','P002',14999999,2),
('H009','P003',28999999,1),
('H010','P003',28999999,2),
('H010','P001',22999999,4)
;

-- Bài 3: Truy vấn dữ liệu [30 điểm]:
-- 1. Lấy ra tất cả thông tin gồm: tên, email, số điện thoại và địa chỉ trong bảng Customers 
select name, email, phone, address  from Customers;

-- 2. Thống kê những khách hàng mua hàng trong tháng 3/2023 (thông tin bao gồm tên, số điện thoại và địa chỉ khách hàng).
select c.name, c.phone, c.address
from ORDERS o
join Customers c on o.customer_id = c.customer_id
where o.order_date like "2023-03-%" ;

-- 3. Thống kê doanh thu theo từng tháng của cửa hàng trong năm 2023 (thông tin bao gồm tháng và tổng doanh thu ). [4 điểm]
select o.order_date , sum(total_amount)
from ORDERS o
where year(o.order_date)=2023
group by month(o.order_date)
order by month(o.order_date) asc
;

-- 4. Thống kê những người dùng không mua hàng trong tháng 2/2023 (thông tin gồm tên khách hàng, địa chỉ , email và số điên thoại). [4 điểm]
select name as 'Tên', address as 'Địa chỉ', email, phone as 'Số điện thoại'
from customers c
where c.customer_id not in (select orders.customer_id from orders where month(order_date)=2)
group by name;

-- 5. Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023 (thông tin bao gồm mã sản phẩm, tên sản phẩm và số lượng bán ra). [4 điểm]
select p.product_id, p.name, quantity, o.order_date
from ORDERS_DETAILS od
join PRODUCTS p on od.product_id = p.product_id
join ORDERS o on od.order_id = o.order_id
where year(o.order_date)=2023 and month(o.order_date)=3
;

-- 6. Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần theo mức chi tiêu (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu). [5 điểm]

select c.customer_id 'Mã Khách Hàng', c.name 'Tên Khách Hàng', sum(total_amount) 'Mức chi tiêu'
from customers c
join orders o on c.customer_id = o.customer_id
where c.customer_id  in (select orders.customer_id from orders where year(order_date)=2023)
group by c.customer_id ;

-- 7. Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên (thông tin bao gồm tên người mua, tổng tiền , ngày tạo hoá đơn, tổng số lượng sản phẩm) . [5 điểm]
select c.name, o.total_amount, o.order_date, sum(od.quantity)
from customers c
join orders o on o.customer_id = c.customer_id
join orders_details od on od.order_id = o.order_id
group by o.order_id
having sum(od.quantity)>=5;


-- Bài 4: Tạo View, Procedure [30 điểm]:

-- 1. Tạo VIEW lấy các thông tin hoá đơn bao gồm : Tên khách hàng, số điện thoại, địa chỉ, tổng tiền và ngày tạo hoá đơn . [3 điểm]
create view order_view as 
select c.name 'Tên Khách Hàng', c.phone 'Số Điện Thoại', 
c.address 'Địa Chỉ', o.total_amount 'Tổng Tiền', 
o.order_date 'Ngày Tạo Hóa Đơn' 
from ORDERS o
join customers c on o.customer_id = c.customer_id
; 
select *from orders_view;
-- drop view order_view;

-- 2. Tạo VIEW hiển thị thông tin khách hàng gồm : tên khách hàng, địa chỉ, số điện thoại và tổng số đơn đã đặt. [3 điểm]
create view customer_view as 
select c.name, c.address, c.phone, count(o.order_id)
from customers c
join ORDERS o on o.customer_id = c.customer_id
group by c.customer_id
; 
select *from customer_view;

-- 3. Tạo VIEW hiển thị thông tin sản phẩm gồm: tên sản phẩm, mô tả, giá và tổng số lượng đã bán ra của mỗi sản phẩm.
create view product_view as 
select p.name, p.description, p.price, sum(od.quantity)
from products p
join orders_details od on od.product_id = p.product_id
group by p.product_id
; 
select *from product_view;

-- 4.  Đánh Index cho trường `phone` và `email` của bảng Customer. 
create index index_face on customers (email,phone);

-- 5. Tạo PROCEDURE lấy tất cả thông tin của 1 khách hàng dựa trên mã số khách hàng.
DELIMITER //
CREATE PROCEDURE getCustomersById
(IN customerNumber varchar(4))
BEGIN
  SELECT * FROM customers WHERE customer_id = customerNumber;
END //
DELIMITER ;
call getCustomersById('C002');

-- 6. Tạo PROCEDURE lấy thông tin của tất cả sản phẩm.
DELIMITER //
CREATE PROCEDURE getListProducts
()
BEGIN
  SELECT * FROM products ;
END //
DELIMITER ;
call getListProducts;
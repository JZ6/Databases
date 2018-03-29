-- Add data to the schema from Car-data.txt

-- Add data to the schema from Car-data.txt

SET SEARCH_PATH to schema;

-- customer values 
INSERT INTO customer values ('Sofia Jan', 24,'j.s@mail.com'); 
INSERT INTO customer values ('Atena Najm', 39,'a.n@mail.com'); 
INSERT INTO customer values ('Yu Chang', 42,'y.c@mail.com'); 
INSERT INTO customer values ('Ryan King', 52,'r.k@mail.com'); 
INSERT INTO customer values ('Thomas George', 34,'t.g@gmail.com'); 
INSERT INTO customer values ('Marie Smith', 22,'ma.smith@mail.com'); 
INSERT INTO customer values ('Jonah Swartz', 28,'jj.swtz@mail.com'); 
INSERT INTO customer values ('Terry Su', 31,'terry.su@mail.com'); 
INSERT INTO customer values ('David Chen', 45,'dchen@mail.com'); 
INSERT INTO customer values ('Cynthia Nguyen', 27,'cyngu@mail.com'); 
INSERT INTO customer values ('Malik Abdullah', 27,'malik_aa@mail.com'); 
INSERT INTO customer values ('John Parkinson', 33,'jparki@mail.com'); 
INSERT INTO customer values ('Stan Orlowski', 26,'orlows@mail.com'); 
INSERT INTO customer values ('Sanja Hilbert', 23,'s.hilbert@mail.com'); 
INSERT INTO customer values ('Ian Hsu', 41,'shenian@mail.com'); 

-- model values 
INSERT INTO model values (1,'BMW X5', 'SUV', 415, 5); 
INSERT INTO model values (2,'E400', 'Luxury', 1848, 4);
INSERT INTO model values (3,'Chevrolet Spark', 'Economy', 1521, 4);
INSERT INTO model values (4,'Dodge Grand Caravan', 'Mini Van', 2210, 7);
INSERT INTO model values (5,'Chevrolet Suburban', 'SUV', 1121, 8);
INSERT INTO model values (6,'Toyota Inception', 'Sports', 1631, 2);
INSERT INTO model values (7,'Volvo V231', 'Economy', 1737, 4);
INSERT INTO model values (8,'Kia T21', 'Economy', 1221, 4);

-- rental stations 
INSERT INTO station values (1001, 'SuperCar College', '333 College St', 'M5T1P7', 'Toronto');
INSERT INTO station values (1002, 'SuperCar Billy Bishop Airport', '200 Spadina Ave', 'M5V1A1', 'Toronto');
INSERT INTO station values (1003, 'SuperCar York', '220 Eglinton St', 'M6E2G8', 'Toronto');
INSERT INTO station values (1004, 'SuperCar East Toronto', '200 Richmond St E', 'M5A2P2', 'Toronto');
INSERT INTO station values (1005, 'SuperCar Parliament', '200 Wellington St', 'K1A0G9', 'Ottawa');
INSERT INTO station values (1006, 'SuperCar Ottawa Airport', '216 Airport Rd', 'K1V9B4', 'Ottawa');
INSERT INTO station values (1007, 'SuperCar Central Station', '895 Rue Mansfield', 'H3B4G1', 'Montreal');
INSERT INTO station values (1008, 'SuperCar North Montreal', '2351 Rue Masson', 'H1Y1V8', 'Montreal');
INSERT INTO station values (1009, 'SuperCar College', '7000 Avenue Van Horne', 'H3S2B2', 'Montreal');

-- car
INSERT INTO car values (101, 'torc566', 1001, 1);
INSERT INTO car values (102, 'torc212', 1001, 8);
INSERT INTO car values (103, 'torc631', 1001, 7);
INSERT INTO car values (104, 'torc522', 1001, 4);
INSERT INTO car values (105, 'torbb10', 1002, 2);
INSERT INTO car values (106, 'torbb11', 1002, 7);
INSERT INTO car values (107, 'torbb12', 1002, 8);
INSERT INTO car values (108, 'tory011', 1003, 3);
INSERT INTO car values (109, 'tory016', 1003, 4);
INSERT INTO car values (110, 'tory017', 1003, 5);
INSERT INTO car values (111, 'tore101', 1004, 5);
INSERT INTO car values (112, 'tore102', 1004, 7);
INSERT INTO car values (113, 'ottp111', 1005, 2);
INSERT INTO car values (114, 'ottp112', 1005, 7);
INSERT INTO car values (115, 'ottp113', 1005, 8);
INSERT INTO car values (116, 'otta101', 1006, 1);
INSERT INTO car values (117, 'otta102', 1006, 7);
INSERT INTO car values (118, 'otta103', 1006, 6);
INSERT INTO car values (119, 'mocs300', 1007, 3);
INSERT INTO car values (120, 'mocs302', 1007, 7);
INSERT INTO car values (121, 'mocs303', 1007, 7);
INSERT INTO car values (122, 'mono201', 1008, 8);
INSERT INTO car values (123, 'mono202', 1008, 4);
INSERT INTO car values (124, 'mono203', 1008, 5);
INSERT INTO car values (125, 'mowe501', 1009, 8);
INSERT INTO car values (126, 'mowe502', 1009, 8);
INSERT INTO car values (127, 'mowe503', 1009, 7);
INSERT INTO car values (128, 'mowe504', 1009, 1);

-- reservation 
INSERT INTO reservation values (22001, '2017-09-01 09:00:00', '2017-09-03 17:00:00', 101, NULL, 'Completed');
INSERT INTO reservation values (22002, '2018-03-17 16:00:00', '2018-03-25 16:00:00', 101, NULL, 'Cancelled');
INSERT INTO reservation values (22003, '2018-03-19 10:00:00', '2018-03-23 20:00:00', 101, 22002, 'Confirmed');
INSERT INTO reservation values (22004, '2018-03-01 08:00:00', '2018-03-10 20:00:00', 101, NULL, 'Ongoing');
INSERT INTO reservation values (22005, '2017-12-15 13:30:00', '2017-12-25 18:00:00', 101, NULL, 'Completed');
INSERT INTO reservation values (22006, '2017-11-01 06:00:00', '2017-11-04 12:00:00', 102, NULL, 'Completed');
INSERT INTO reservation values (22007, '2018-02-23 10:00:00', '2018-03-05 17:00:00', 102, NULL, 'Cancelled');
INSERT INTO reservation values (22008, '2018-03-10 10:00:00', '2018-03-16 20:00:00', 102, 22007, 'Confirmed');
INSERT INTO reservation values (22009, '2018-02-25 09:00:00', '2018-03-10 21:00:00', 103, NULL, 'Ongoing');
INSERT INTO reservation values (22010, '2017-12-09 14:00:00', '2017-12-11 17:00:00', 103, NULL, 'Completed');
INSERT INTO reservation values (22011, '2018-02-01 08:00:00', '2018-02-05 16:00:00', 104, NULL, 'Cancelled');
INSERT INTO reservation values (22012, '2017-12-25 09:00:00', '2018-01-05 19:00:00', 106, NULL, 'Completed');
INSERT INTO reservation values (22013, '2018-04-23 09:00:00', '2018-05-01 14:00:00', 106, NULL, 'Confirmed');
INSERT INTO reservation values (22014, '2018-02-19 08:00:00', '2018-02-23 20:00:00', 107, NULL, 'Cancelled');
INSERT INTO reservation values (22015, '2018-02-21 08:00:00', '2018-03-10 20:00:00', 107, 22014, 'Ongoing');
INSERT INTO reservation values (22016, '2017-10-09 08:00:00', '2017-10-09 21:00:00', 107, NULL, 'Completed');
INSERT INTO reservation values (22017, '2018-06-03 07:00:00', '2018-06-20 15:00:00', 107, NULL, 'Confirmed');
INSERT INTO reservation values (22018, '2018-01-14 09:00:00', '2018-01-20 14:00:00', 109, NULL, 'Cancelled');
INSERT INTO reservation values (22019, '2018-02-01 09:00:00', '2018-02-03 16:00:00', 111, NULL, 'Completed');
INSERT INTO reservation values (22020, '2018-02-26 06:00:00', '2018-03-07 12:00:00', 113, NULL, 'Cancelled');
INSERT INTO reservation values (22021, '2018-02-28 11:00:00', '2018-03-08 23:00:00', 113, 22020, 'Ongoing');
INSERT INTO reservation values (22022, '2017-07-02 09:00:00', '2017-07-05 21:30:00', 113, NULL, 'Completed');
INSERT INTO reservation values (22023, '2018-02-05 08:00:00', '2018-02-08 18:00:00', 114, NULL, 'Completed');
INSERT INTO reservation values (22024, '2018-04-02 16:00:00', '2018-04-06 16:00:00', 116, NULL, 'Confirmed');
INSERT INTO reservation values (22025, '2018-03-03 07:00:00', '2018-03-15 23:30:00', 116, NULL, 'Ongoing');
INSERT INTO reservation values (22026, '2018-01-01 07:00:00', '2018-01-01 17:00:00', 118, NULL, 'Completed');
INSERT INTO reservation values (22027, '2018-04-04 09:00:00', '2018-04-06 15:00:00', 119, NULL, 'Cancelled');
INSERT INTO reservation values (22028, '2018-02-14 13:00:00', '2018-03-25 23:00:00', 119, NULL, 'Ongoing');
INSERT INTO reservation values (22029, '2017-09-26 08:00:00', '2017-10-03 20:00:00', 119, NULL, 'Completed');
INSERT INTO reservation values (22030, '2018-03-26 10:00:00', '2018-03-29 16:00:00', 123, NULL, 'Confirmed');
INSERT INTO reservation values (22031, '2017-12-21 06:00:00', '2017-12-28 22:00:00', 124, NULL, 'Completed');
INSERT INTO reservation values (22032, '2017-09-22 16:00:00', '2017-09-23 08:00:00', 126, NULL, 'Cancelled');
INSERT INTO reservation values (22033, '2017-09-23 14:00:00', '2017-09-23 17:00:00', 126, 22032, 'Completed');
INSERT INTO reservation values (22034, '2018-01-01 22:00:00', '2018-04-05 14:00:00', 127, NULL, 'Ongoing');
INSERT INTO reservation values (22035, '2017-12-07 09:00:00', '2017-12-13 12:00:00', 127, NULL, 'Cancelled');
INSERT INTO reservation values (22036, '2018-03-24 10:00:00', '2018-04-02 21:00:00', 128, NULL, 'Confirmed');
INSERT INTO reservation values (22037, '2017-09-25 09:00:00', '2017-09-27 20:00:00', 103, NULL, 'Cancelled');
INSERT INTO reservation values (22038, '2018-03-24 10:00:00', '2018-04-02 21:00:00', 104, NULL, 'Completed');


-- customer_reservation
INSERT INTO customer_reservation values ('j.s@mail.com', '22001');
INSERT INTO customer_reservation values ('terry.su@mail.com', '22001');
INSERT INTO customer_reservation values ('s.hilbert@mail.com', '22002');
INSERT INTO customer_reservation values ('s.hilbert@mail.com', '22003');
INSERT INTO customer_reservation values ('dchen@mail.com', '22004');
INSERT INTO customer_reservation values ('jj.swtz@mail.com', '22005');
INSERT INTO customer_reservation values ('r.k@mail.com', '22006');
INSERT INTO customer_reservation values ('cyngu@mail.com', '22006');
INSERT INTO customer_reservation values ('ma.smith@mail.com', '22007');
INSERT INTO customer_reservation values ('ma.smith@mail.com', '22008');
INSERT INTO customer_reservation values ('jparki@mail.com', '22008');
INSERT INTO customer_reservation values ('orlows@mail.com', '22009');
INSERT INTO customer_reservation values ('j.s@mail.com', '22010');
INSERT INTO customer_reservation values ('malik_aa@mail.com', '22011');
INSERT INTO customer_reservation values ('malik_aa@mail.com', '22012');
INSERT INTO customer_reservation values ('jparki@mail.com', '22013');
INSERT INTO customer_reservation values ('shenian@mail.com', '22014');
INSERT INTO customer_reservation values ('shenian@mail.com', '22015');
INSERT INTO customer_reservation values ('shenian@mail.com', '22016');
INSERT INTO customer_reservation values ('shenian@mail.com', '22017');
INSERT INTO customer_reservation values ('orlows@mail.com', '22018');
INSERT INTO customer_reservation values ('t.g@gmail.com', '22019');
INSERT INTO customer_reservation values ('t.g@gmail.com', '22020');
INSERT INTO customer_reservation values ('t.g@gmail.com', '22021');
INSERT INTO customer_reservation values ('orlows@mail.com', '22022');
INSERT INTO customer_reservation values ('s.hilbert@mail.com', '22023');
INSERT INTO customer_reservation values ('s.hilbert@mail.com', '22024');
INSERT INTO customer_reservation values ('y.c@mail.com', '22025');
INSERT INTO customer_reservation values ('y.c@mail.com', '22026');
INSERT INTO customer_reservation values ('y.c@mail.com', '22027');
INSERT INTO customer_reservation values ('cyngu@mail.com', '22028');
INSERT INTO customer_reservation values ('dchen@mail.com', '22029');
INSERT INTO customer_reservation values ('shenian@mail.com', '22030');
INSERT INTO customer_reservation values ('dchen@mail.com', '22030');
INSERT INTO customer_reservation values ('y.c@mail.com', '22030');
INSERT INTO customer_reservation values ('t.g@gmail.com', '22031');
INSERT INTO customer_reservation values ('malik_aa@mail.com', '22032');
INSERT INTO customer_reservation values ('a.n@mail.com', '22032');
INSERT INTO customer_reservation values ('malik_aa@mail.com', '22033');
INSERT INTO customer_reservation values ('a.n@mail.com', '22033');
INSERT INTO customer_reservation values ('terry.su@mail.com', '22034');
INSERT INTO customer_reservation values ('jj.swtz@mail.com', '22035');
INSERT INTO customer_reservation values ('cyngu@mail.com', '22036');
INSERT INTO customer_reservation values ('s.hilbert@mail.com', '22037');
INSERT INTO customer_reservation values ('s.hilbert@mail.com', '22038');


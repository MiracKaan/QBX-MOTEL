CREATE TABLE IF NOT EXISTS `motel_rooms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(100) NOT NULL,
  `room` varchar(50) NOT NULL,
  `lastpayment` bigint NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE  booking (
  booking_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  doc_id int(10) unsigned NOT NULL,
  user_id int(10) unsigned NOT NULL,
  apt_date DATE NOT NULL,
  apt_time int(10) unsigned NOT NULL,
  booked_at bigint(20) NOT NULL,
  PRIMARY KEY (booking_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
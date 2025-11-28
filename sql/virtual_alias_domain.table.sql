CREATE TABLE `virtual_alias_domain` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `alias_domain` varchar(150) DEFAULT NULL,
  `target_domain` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`id`)
);

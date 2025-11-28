CREATE TABLE `virtual_users` (
`id` INT NOT NULL AUTO_INCREMENT,
`domain_id` INT NOT NULL,
`password` VARCHAR(100) NOT NULL,
`user` VARCHAR(100) NOT NULL,
PRIMARY KEY (`id`),
UNIQUE KEY `email` (`user`, `domain_id`)
);

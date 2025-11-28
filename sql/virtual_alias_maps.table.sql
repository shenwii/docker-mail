CREATE TABLE `virtual_alias_maps` (
`id` int(11) NOT NULL auto_increment,
`source` varchar(100) NOT NULL,
`destination` varchar(100) NOT NULL,
PRIMARY KEY (`id`),
);

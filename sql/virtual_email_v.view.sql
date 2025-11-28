CREATE OR REPLACE `virtual_email_v` AS
select
    `a`.`id` AS `id`,
    `a`.`domain_id` AS `domain_id`,
    `a`.`password` AS `password`,
    `a`.`user` AS `user`,
    `b`.`domain` AS `domain`,
    concat(`a`.`user`, '@', `b`.`domain`) AS `email`
from
    `virtual_users` `a`
join `virtual_domains` `b`
on
    `a`.`domain_id` = `b`.`id`;

create database test_aop;
use test_aop;
#задача: есть магазины и продукты. необхдоимо найти все магазины и продукты в них, где есть продукты
# у которых срок годности истекает позже указанной даты и в радиусе 10км
create table shop_t(
  id int(10) not null auto_increment,
  name varchar(400) comment 'shop name',
  latitude double not null comment 'latitude coordinate in decimal degrees format',
  longitude double not null comment 'longitude coordinate in decimal degrees format',
  primary key (id),
  key shop$latitude_i(latitude),
  key shop$longitude_i(longitude)
) comment 'shop';

create table product_t(
  id int(10) not null auto_increment,
  name varchar(400) comment 'product name',
  primary key (id)
) comment 'shop';

create table shop__product_t (
  id int(10) not null auto_increment,
  shop_id int(10) not null comment 'shop identifier',
  product_id int(10) not null comment 'product identifier',
  primary key (id),
  unique key shop__product$shop_id_product_id_iu (shop_id, product_id),
  key shop__product$shop_id_i (shop_id),
  key shop__product$product_id_i (product_id),
  constraint shop__product2shop_fk foreign key (shop_id) references shop_t (id),
  constraint shop__product2product_fk foreign key (product_id) references product_t (id)
) comment 'the product in the shop';

create table product_supply_t (
  id int(10) not null auto_increment,
  best_before_dt datetime comment 'product expiration date',
  shop__product_id int(10) comment 'shop-product identifier',
  primary key (id),
  unique key product_supply$shop__product_id_best_before_dt_iu (shop__product_id, best_before_dt),
  key product_supply$shop__product_id_i (shop__product_id),
  constraint shop__product_id2shop__product_fk foreign key (shop__product_id) references shop__product_t (id)
) comment 'the product in the shop supply';

# put id in insert statements only for init
# shops
insert into shop_t(id, name, latitude, longitude) values (1, 'shop-1', 55.510,-1);
insert into shop_t(id, name, latitude, longitude) values (2, 'shop-2', 55.511,-1);
insert into shop_t(id, name, latitude, longitude) values (3, 'shop-3', 55.512,-1);
insert into shop_t(id, name, latitude, longitude) values (4, 'shop-4', 53.000,-1);

# products
insert into product_t(id, name) values (1,'tomato');
insert into product_t(id, name) values (2,'potato');
insert into product_t(id, name) values (3,'cucumber');

# shop__product
insert into shop__product_t(id, shop_id, product_id) values (1, 1,1);
insert into shop__product_t(id, shop_id, product_id) values (2, 1,2);
insert into shop__product_t(id, shop_id, product_id) values (3, 1,3);

insert into shop__product_t(id, shop_id, product_id) values (4, 2,1);
insert into shop__product_t(id, shop_id, product_id) values (5, 2,2);
insert into shop__product_t(id, shop_id, product_id) values (6, 2,3);

insert into shop__product_t(id, shop_id, product_id) values (7, 3,1);
insert into shop__product_t(id, shop_id, product_id) values (8, 3,2);
insert into shop__product_t(id, shop_id, product_id) values (9, 3,3);

insert into shop__product_t(id, shop_id, product_id) values (10, 4,1);
insert into shop__product_t(id, shop_id, product_id) values (11, 4,2);
insert into shop__product_t(id, shop_id, product_id) values (12, 4,3);

# product_supply_t
# shop-1 (all fresh)
insert into product_supply_t(best_before_dt, shop__product_id) values (STR_TO_DATE('2016-04-30', '%Y-%m-%d'),1);
insert into product_supply_t(best_before_dt, shop__product_id) values (STR_TO_DATE('2016-04-30', '%Y-%m-%d'),2);
insert into product_supply_t(best_before_dt, shop__product_id) values (STR_TO_DATE('2016-04-30', '%Y-%m-%d'),3);
# shop-2 (all products are expired)
insert into product_supply_t(best_before_dt, shop__product_id) values (STR_TO_DATE('2016-04-25', '%Y-%m-%d'),4);
insert into product_supply_t(best_before_dt, shop__product_id) values (STR_TO_DATE('2016-04-25', '%Y-%m-%d'),5);
insert into product_supply_t(best_before_dt, shop__product_id) values (STR_TO_DATE('2016-04-25', '%Y-%m-%d'),6);
# shop-3 (30/70)
insert into product_supply_t(best_before_dt, shop__product_id) values (STR_TO_DATE('2016-04-25', '%Y-%m-%d'),7);
insert into product_supply_t(best_before_dt, shop__product_id) values (STR_TO_DATE('2016-04-27', '%Y-%m-%d'),8);
insert into product_supply_t(best_before_dt, shop__product_id) values (STR_TO_DATE('2016-04-30', '%Y-%m-%d'),9);
# shop-4 (70/30) but more than 10 km
insert into product_supply_t(best_before_dt, shop__product_id) values (STR_TO_DATE('2016-04-24', '%Y-%m-%d'),10);
insert into product_supply_t(best_before_dt, shop__product_id) values (STR_TO_DATE('2016-04-25', '%Y-%m-%d'),11);
insert into product_supply_t(best_before_dt, shop__product_id) values (STR_TO_DATE('2016-04-30', '%Y-%m-%d'),12);

-- sql query gives as a list of products and shops which are X rm not further away from specified
-- location and contains products with best before date bigger than Y

SELECT st.id, st.name, pt.name,
  (
    6371 * acos (
        cos ( radians(55.504) )
        * cos( radians( st.latitude ) )
        * cos( radians( st.longitude ) - radians(-1) )
        + sin ( radians(55.504) )
          * sin( radians( st.latitude ) )
    )
  ) AS distance
FROM shop_t st
  INNER JOIN shop__product_t spt on spt.shop_id = st.id
  INNER JOIN product_supply_t pst on pst.shop__product_id = spt.id
  INNER JOIN product_t pt on pt.id = spt.product_id
WHERE pst.best_before_dt > STR_TO_DATE('2016-04-26', '%Y-%m-%d')
HAVING distance < 10
ORDER BY distance, pst.best_before_dt, pst.shop__product_id;
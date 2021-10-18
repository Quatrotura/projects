INSERT INTO users VALUES (NULL, 'Judy', 'Dickinson', 'dickinson.judy', '9f0000106ea539eb6bda8cb2f1cd16362ada0dd7', 'miguel.feil@example.net',  'deactivated', '2000-06-21 11:35:18');
INSERT INTO users VALUES (NULL, 'Jovanny', 'Smith', 'jovanny.smith', '441cbba5dffcc3e315f1ec8dce33219c0712aa3b', 'gleichner.nadia@example.net', 'deactivated', '1988-01-30 04:01:26');
INSERT INTO users VALUES (NULL, 'Haylie', 'Schulist', 'schulist.haylie', '68c7fad6c099ec43912dda581ec48f7c43101ac5', 'kulas.trenton@example.net',  'deactivated', '2013-01-21 02:55:39');
INSERT INTO users VALUES (NULL, 'Mireya', 'Hoppe', 'hoppe.mireya', 'a606d05710aac2fdbacbf86461174655c5dcdf41', 'xbeatty@example.net', 'active', '2007-07-07 18:04:29');
INSERT INTO users VALUES (NULL, 'Zap', 'Rolfson', 'zrolfson', '48477817566966d2f2d111df65d4988d9fd905c9', 'gthiel@example.com', 'deactivated', '1987-09-28 14:58:26');
INSERT INTO users VALUES (NULL, 'Timur', 'Murzik', 'tmurazik', '7cac1070c6b7af8ca3f8bcbf3f62d3bafe32be7d', 'vonrueden.khalil@example.org',  'active', '1978-03-05 23:25:04');
INSERT INTO users VALUES (NULL, 'Jenifer', 'Weimann', 'weimann.jenifer', '483f264ceb6c81e2d1f615e895aa429cfb3ab7d3', 'drolfson@example.org', 'deactivated', '1987-07-08 15:22:45');
INSERT INTO users VALUES (NULL, 'Sadye', 'Schneider', 'sadye.schneider', 'e9ff98c447c8fe6331c5ddf7ff8cfb4a991d31e2', 'eanderson@example.net',  'deactivated', '1977-01-28 18:24:35');
INSERT INTO users VALUES (NULL, 'Natalie', 'Swift', 'nswift', '5503ff403ff6ca7cec306a6b9652be7d21d3104c', 'taurean.wisoky@example.org',  'deactivated', '2016-04-25 14:42:33');
INSERT INTO users VALUES (NULL, 'Amira', 'Schumm', 'amira.schumm', '222c4c8ea342f86c4ce47c063226b0f72cffd7fa', 'bauch.raven@example.net', 'active', '1978-10-21 20:31:47');

INSERT INTO country_cities(country,city) VALUES
	('China', 'Shanghai'),
	('China', 'Shenzhen'),
	('China', 'Ningbo'),
	('China', 'Xiamen'),
	('China', 'Hong Kong'),
	('Russia', 'Moscow'),
	('British Virgin Islands', 'Road Town'),
	('Bangladesh', 'Chittagong'),
	('Turkey', 'Istambul'),
	('Korea', 'Busan');
INSERT INTO country_cities (country, city) VALUES
('Russia', 'Saint Petersburg'),
('Russia', 'Yekaterinburg'),
('Russia', 'Vladivostok'),
('Russia', 'Novosibirsk');

SELECT * FROM country_cities;
INSERT INTO alias_suppliers(alias_suppl_name, alias_suppl_country_city_id) VALUES
	('Shanghai Textiles', 1),
	('Ningbo Supreme', 3),
	('Shanghai Knitwear', 1),
	('Shuangfeng Accessories',2),
	('Minar Industry',8),
	('Zeria Tekstil',9),
	('Heung Apparels',10),
	('Anhui Garments',1),
	('H&J',4),
	('Top Shirts',5);

SELECT * FROM alias_suppliers;
SELECT alias_suppliers.alias_suppl_name, country_cities.country, country_cities.city
FROM alias_suppliers LEFT JOIN country_cities ON alias_suppliers.alias_suppl_country_city_id = country_cities.id
ORDER BY 2;

INSERT INTO alias_buyers(alias_buyer_name, alias_buyer_country_city_id) VALUES
	('Inditex', 6 ),
	('Inditex Logistics', 6);

SELECT * FROM alias_buyers;

INSERT INTO suppliers_leg_entities VALUES
(NULL, 'Shanghai Textiles Supplies Co. Ltd.', 3747498593,
 'Mainstreet 2, Road Town, British Virgin Islands', 'Xuehuadadao 23, Shanghai, China', 7, 1 ),
(NULL, 'Ningbo Supreme Import & Export Co. Ltd', 3747492984,
 'Shijiedadao 84, Ningbo, China', 'Shijiedadao 84, Ningbo, China', 3, 2 ),
(NULL, 'Shanghai Knitwear Co. Ltd.', 3747490193,
 'Dongfengdadao 13, Shanghai, China', 'Dongfengdadao 13, Shanghai, China', 1, 3 ),
(NULL, 'Shanghai Trading I&E Co. Ltd', 3747498450,
 'Xuehuadadao 23, Shanghai, China', 'Xuehuadadao 23, Shanghai, China', 1, 1 ),
(NULL, 'Shuangfeng Accessories Manufacturing Co. Ltd', 3747491095,
 'Xinguolu 65, Shenzhen, China', 'Xinguolu 65, Shenzhen, China', 2, 4 ),
(NULL, 'Chittagong Minar Industries Co. Ltd', 24578510,
 'Queens Street 10, Chittagong, Bangladesh', 'Queens Street 10, Chittagong, Bangladesh', 8, 5),
(NULL, 'Zeria Tekstil Sanayi ve Dİs Ticaret Ltd Sti', 569384917,
 'Esenler Sk 1, Istanbul, Turkey', 'Esenler Sk 1, Istanbul, Turkey', 9, 6),
(NULL, 'Heung Apparels Manufacturing LLC', 384950276,
 'Minhaseung 34, Busan, Korea', 'Minhaseung 34, Busan, Korea', 10, 7),
(NULL, 'Anhui Dafeng Garments I&E Co. Ltd', 3747495739,
 'Liudalu 98, Shanghai, China', 'Liudalu 98, Shanghai, China', 1, 8),
(NULL, 'H&J Outerwear Apparels Co. Ltd', 3747499384,
 'Xihulu 29, Xiamen, China', 'Xihulu 29, Xiamen, China', 4, 9);

SELECT * FROM suppliers_leg_entities;

--  узнать у какого поставщика более одного юрлица:
SELECT alias.alias_suppl_name, COUNT(legal.entity_name) AS number_of_entities_per_alias
FROM alias_suppliers AS alias LEFT JOIN suppliers_leg_entities AS legal ON alias.id = legal.entity_alias_id
GROUP BY 1 HAVING number_of_entities_per_alias > 1
ORDER BY 1;

-- или так (по левому джойну в названиях юрлиц будет null там где юрлицо не заведено:
SELECT alias.alias_suppl_name, legal.entity_name
FROM alias_suppliers AS alias LEFT JOIN suppliers_leg_entities AS legal ON alias.id = legal.entity_alias_id
WHERE legal.entity_name is NULL;



-- узнать на какого поставщика не заведены юр лица:
SELECT alias.alias_suppl_name, COUNT(legal.entity_name) AS number_of_entities_per_alias
FROM alias_suppliers AS alias LEFT JOIN suppliers_leg_entities AS legal ON alias.id = legal.entity_alias_id
GROUP BY 1 HAVING number_of_entities_per_alias = 0
ORDER BY 1;

-- или

SELECT alias.alias_suppl_name, (SELECT COUNT(entity_name) FROM suppliers_leg_entities WHERE alias.id = entity_alias_id) AS number_of_entities_per_alias
FROM alias_suppliers AS alias
GROUP BY 1 HAVING number_of_entities_per_alias = 0
ORDER BY 1;

-- узнать у каких поставщиков фактическая страна нахождения отличается от страны, где зарегистрировано юр лицо поставщика, с выводом названия стран к обеим таблицам:
SELECT alias.alias_suppl_name, leg.entity_name, geo.country AS legal_entity_reg_country, geo_2.country AS alias_country
FROM suppliers_leg_entities leg
JOIN alias_suppliers alias ON (leg.entity_alias_id = alias.id) AND (leg.entity_reg_country_city_id != alias.alias_suppl_country_city_id)
JOIN country_cities geo ON leg.entity_reg_country_city_id = geo.id
JOIN country_cities geo_2 ON alias.alias_suppl_country_city_id = geo_2.id;

INSERT INTO buyers_leg_entities VALUES
(NULL, 'Inditex Retail Solutions Rus Co., Ltd.', 481983947, 'ulitsa Yakimanka 31, Moscow, Russia', 'Presnenskay Naberezhnaya 10, Blok C, etazh 35, Moscow, Russia', 6, 1),
(NULL, 'Inditex Logistcs Services Rus Co. Ltd.', 481983384, 'Promyshlenny Proezd 485, Moscow, Russia', 'Promyshlenny Proezd 485, Moscow, Russia', 6, 2);

-- простая проверочка
SELECT leg.entity_name, alias.alias_buyer_name, geo.country
FROM buyers_leg_entities leg JOIN country_cities geo ON leg.entity_fact_country_city_id = geo.id
JOIN alias_buyers alias ON leg.entity_alias_id = alias.id;

INSERT INTO ports_of_loading VALUES
(NULL, 'Shanghai', 1),
(NULL, 'Shenzhen', 2),
(NULL, 'Ningbo', 3),
(NULL, 'Xiamen', 4),
(NULL, 'Hong Kong', 5),
(NULL, 'Chittagong', 8),
(NULL, 'Istambul', 9),
(NULL, 'Busan', 10);

SELECT pol.id as polID, pol.name, geo.id, geo.country, geo.city
FROM ports_of_loading pol JOIN country_cities geo ON pol.country_city_id = geo.id;

INSERT INTO production_types VALUES
(NULL, 'CUTKNITS', 'T-SHIRTS'),
(NULL, 'CUTKNITS', 'HOODIES'),
(NULL, 'CUTKNITS', 'SWEATSHIRTS'),
(NULL, 'DENIM', 'JACKETS'),
(NULL, 'DENIM', 'JEANS'),
(NULL, 'WOVEN', 'SHIRTS'),
(NULL, 'WOVEN', 'TROUSERS'),
(NULL, 'WOVEN', 'SHORTS'),
(NULL, 'OUTERWEAR', 'PADDED JACKETS'),
(NULL, 'OUTERWEAR', 'WINDJACKETS');

SELECT * FROM production_types ORDER BY id;

INSERT INTO product_descriptions VALUES
(NULL, 'female padded jacket with hydrophobic coating', 9),
(NULL, 'male natural down padded jacket', 9),
(NULL, 'female oversize fancy hoodie', 2),
(NULL, 'male slimfit hoodie', 2),
(NULL, 'male casual hoodie with zipper', 2),
(NULL, 'male t-shirt with front print', 1),
(NULL, 'male basic straight jeans', 5),
(NULL, 'female basic blouse', 6),
(NULL, 'male casual oxford shirt', 6),
(NULL, 'male swimming shorts printed', 8);

--  простенький джойн для проверки вставок:
SELECT  type.class, type.subclass, descr.description
FROM product_descriptions descr JOIN production_types type ON descr.production_type_id = type.id;

INSERT INTO product_compositions VALUES
(NULL, '100% polyester'),
(NULL, '80% cotton, 20% polyester'),
(NULL, '60% cotton, 40% polyester'),
(NULL, '100% cotton'),
(NULL, '50% cotton 50% polyester'),
(NULL, '70% cotton, 30% polyester'),
(NULL, '65% cotton, 30% polyester, 5% spandex'),
(NULL, 'SHELL: 90% polyester, 10% acrylic, PADDING: 100% goose down'),
(NULL, 'SHELL: 100% polyester, PADDING: 50% goose down, 50% sintepon'),
(NULL, '70% cotton, 30% polyamide');

SELECT * FROM product_compositions;

SELECT alias.id, alias.alias_suppl_country_city_id, geo_1.country, geo_1.city, alias.alias_suppl_name, legal.entity_name, legal.entity_fact_address, geo_2.country, geo_2.city
FROM alias_suppliers AS alias LEFT JOIN suppliers_leg_entities AS legal ON alias.id = legal.entity_alias_id
JOIN country_cities AS geo_1 ON alias.alias_suppl_country_city_id = geo_1.id
JOIN country_cities AS geo_2 ON legal.entity_reg_country_city_id = geo_2.id
ORDER BY 1;

INSERT INTO production_facilities VALUES
(NULL, 'Xinshuai Zhenfeng Textile Co. Ltd', 'Bingfengdadao 34, Shanghai, China', 1, 1, 'Approved', '2020-10-03', 1, null),
(NULL, 'Shanghai Textiles Industries Co. Ltd', 'Xuehuadadao 23, Shanghai, China', 1, 1, 'Approved', '2020-12-31', 1, null),
(NULL, 'Ningbo Seduno Top Sewing Co. Ltd', 'Shijiedadao 84, Ningbo, China', 3, 2, 'Approved', '2018-10-12', 3, null),
(NULL, 'Minar Woven Manufacturing Co. Ltd', 'Queens Street 10, Chittagong, Bangladesh', 8, 5, 'Inspection', '2021-10-17', 6, 'Problems with quality system, 6% defection ratio in the last batch. Need to reinspect in-line quality system'),
(NULL, 'Minar Excellent Sewing Industries Co. Ltd', 'Dhaka-Bangalore National Highway 456 km, building 1, Dhaka, Bangladesh', 8, 5, 'Rejected', '2021-09-30', 6, '35% of SS21 bulk orders with major defects, 25% of retail returns. Need to go through inspection.'),
(NULL, 'Zeria Tekstil Sanayi ve Dİs Ticaret Ltd Sti', 'Esenler Sk 1, Istanbul, Turkey', 9, 6, 'Inspection', '2021-10-09', 7, 'Good quality PPS. Inspection planned on Nov 1, 2021'),
(NULL, 'Xiamen H&J Outerwear Manufacturing Co. Ltd', 'Xihulu 29, Xiamen, China', 4, 9, 'Approved', '2019-12-31', 4, null),
(NULL, 'Haochi Huluobo Indusrial Co. Ltd. ', 'Xinguolu 65, Shenzhen, China',2, 4, 'Approved', '2016-01-31', 2, null),
(NULL, 'Ssang Yong Heung Textile Industries Co., Ltd', 'Minhaseung 34, Busan, Korea', 10, 7, 'Approved', '2021-04-20', 8, null),
(NULL, 'Istanbul tekstil üretim şirketi', 'Sarhoş rusların sokağı 10, Instanbul, Turkey', 9, 6, 'Approved', '2020-08-19', 7, null);

-- вывести наименования поставщиков (псевдонимы), их страну и все ссылочные айди в данной таблицы заменить на значения из соответствующих таблиц:
SELECT alias.alias_suppl_name, factory.facility_name, factory.fact_address, geo.country, geo.city, factory.`status`, factory.status_updated_at
FROM production_facilities factory JOIN country_cities geo ON factory.fact_country_city_id = geo.id
JOIN alias_suppliers alias ON alias.id = factory.alias_suppl_id
JOIN ports_of_loading pol ON factory.port_of_loading_id = pol.id
ORDER BY 1;

--  узнать у каких поставщиков не заведены в систему фабрики:
SELECT alias.alias_suppl_name, COUNT(factory.id) AS factory_qty
FROM production_facilities factory RIGHT JOIN alias_suppliers alias ON factory.alias_suppl_id = alias.id
GROUP BY 1 WITH ROLLUP HAVING factory_qty = 0
ORDER BY 2;

-- допустим пользователь хочет вывести список неподтвержденных фабрик и понять что с ними не так(прочитать комментарии)
SELECT alias.alias_suppl_name, factory.facility_name, factory.status, factory.comments
FROM alias_suppliers alias JOIN production_facilities factory ON alias.id = factory.alias_suppl_id AND factory.status != 'Approved'
ORDER BY 4;

-- допустим пользователю необходимо сделать выборку подтвержденных фабрик, инспекция которых была более двух лет назад
SELECT alias.alias_suppl_name, factory.facility_name, factory.status, factory.status_updated_at, (SELECT TIMESTAMPDIFF(YEAR, factory.status_updated_at, CURRENT_DATE)) AS years_to_last_inspection
FROM alias_suppliers alias JOIN production_facilities factory ON alias.id = factory.alias_suppl_id AND factory.status = 'Approved'
	AND factory.status_updated_at < CURRENT_DATE - INTERVAL 2 YEAR
ORDER BY 1;

-- можно сделать обновление статуса по вышеуказанной выборке:
UPDATE production_facilities factory
SET factory.status = 'To be reinspected', factory.comments = 'Factories were inspected more than two years ago. Got to be re-inspected shortly.'
WHERE factory.status_updated_at < CURRENT_DATE - INTERVAL 2 YEAR;

INSERT INTO production_facilities_types VALUES
	(1, 6),
	(1, 7),
	(2, 8),
	(3, 1),
	(4, 6),
	(5, 2),
	(6, 5),
	(7, 9),
	(8, 8),
	(9, 4),
	(10, 3);

-- узнаем кто что производит
SELECT types.class, types.subclass, alias.alias_suppl_name ,sle.entity_name,factory.facility_name, factory.status
FROM production_facilities_types factory_types JOIN production_facilities factory ON factory_types.production_facility_id = factory.id
JOIN alias_suppliers alias ON factory.alias_suppl_id = alias.id
JOIN production_types types ON factory_types.production_types_id = types.id
JOIN suppliers_leg_entities sle ON alias.id = sle.entity_alias_id;

-- допустим нам надо узнать какой поставщик/фабрикd сможет производить пуховики:
-- можно потом сделать процедуру из этого выражения
SELECT types.class, types.subclass, alias.alias_suppl_name ,factory.facility_name, factory.status
FROM production_facilities_types factory_types JOIN production_facilities factory ON factory_types.production_facility_id = factory.id
JOIN alias_suppliers alias ON factory.alias_suppl_id = alias.id
JOIN production_types types ON factory_types.production_types_id = types.id AND types.class = 'OUTERWEAR' AND types.subclass = 'PADDED JACKETS';

INSERT INTO currencies VALUES
(NULL, 'USD'),
(NULL, 'RUB'),
(NULL, 'EUR'),
(NULL, 'CNY'),
(NULL, 'TRY'),
(NULL, 'BYN'),
(NULL, 'BDT'),
(NULL, 'UZS'),
(NULL, 'INR'),
(NULL, 'HKD'),
(NULL, 'SGD');

INSERT currency_exchange_rates VALUES
(NULL, 4, 2, 11.2128, '2021-10-08'),
(NULL, 3, 1, 1.1564,  '2021-10-08'),
(NULL, 3, 2, 83.1400, '2021-10-08'),
(NULL, 1, 2, 71.8800, '2021-10-08'),
(NULL, 1, 4, 6.4369,  '2021-10-08'),
(NULL, 9, 2, 9.5374,  '2021-10-15'),
(NULL, 4, 2, 11.1569, '2021-10-15'),
(NULL, 3, 2, 82.3900, '2021-10-15'),
(NULL, 3, 1, 1.1601,  '2021-10-15'),
(NULL, 1, 2, 71.0300, '2021-10-15');

SELECT cur1.name_acronym, cur2.name_acronym, rates.rate_value, rates.created_at
FROM currency_exchange_rates rates JOIN currencies cur1 ON rates.from_currency_id = cur1.id
JOIN currencies cur2 ON rates.to_currency_id = cur2.id
ORDER BY 4 DESC;

INSERT INTO collections VALUES
(NULL, 'SS19'),
(NULL, 'AW19'),
(NULL, 'SS20'),
(NULL, 'AW20'),
(NULL, 'SS21'),
(NULL, 'AW21'),
(NULL, 'SS22'),
(NULL, 'AW22'),
(NULL, 'SS23'),
(NULL, 'AW23');

SELECT * FROM collections;

INSERT INTO delivery_basis VALUES
(NULL, 'FOB'),
(NULL, 'FCA'),
(NULL, 'FAS'),
(NULL, 'DAP'),
(NULL, 'DAT'),
(NULL, 'CIF'),
(NULL, 'CFR'),
(NULL, 'EXW'),
(NULL, 'FOR'),
(NULL, 'DPU');

SELECT * FROM delivery_basis;

INSERT INTO payment_modes VALUES
(NULL, 'T/T'),
(NULL, 'L/C'),
(NULL, 'mixed');

SELECT * FROM payment_modes;

INSERT INTO payment_due_points VALUES
(NULL, 'planned latest shipment'),
(NULL, 'order allocation'),
(NULL, 'quality approval'),
(NULL, 'actual shipment date'),
(NULL, 'planned delivery to final destination'),
(NULL, 'actual delivery to final destination');

SELECT * FROM payment_due_points;

INSERT INTO payment_terms VALUES
(NULL, 1, 10, 60, 30, 0, 0 , -150, -14, 90, 0),
(NULL, 1, 20, 50, 30, 0, 0 , -150, -14, 60, 0),
(NULL, 1, 0, 50, 50, 0, 0 , -150, -14, 120, 0),
(NULL, 1, 10, 0, 50, 40, 0 , -150, 0, 30, 120),
(NULL, 1, 10, 0, 60, 30, 0 , -150, 0, 21, 150),
(NULL, 3, 0, 0, 100, 0, 0 , 0, 0, 110, 0),
(NULL, 3, 10, 0, 90, 0, 0 , -120, 0, 100, 0),
(NULL, 4, 0, 0, 100, 0, 0 , 0, 0, 70, 0),
(NULL, 1, 30, 60, 10, 0, 0 , -150, -14, 90, 0),
(NULL, 6, 0, 0, 80, 20, 0 , 0, 0, 14, 30);

SELECT pdp.due_points, payment_terms.* FROM payment_terms JOIN payment_due_points pdp on payment_terms.payment_due_point_id = pdp.id;

INSERT INTO destination_points VALUES
(NULL, 'FDC Moscow', 6),
(NULL, 'RDC Saint Petersburg', 21),
(NULL, 'RDC Yekaterinburg', 22),
(NULL, 'RDC Vladivostok', 23),
(NULL, 'RDC Novosibirsk', 24),
(NULL, 'NDC Shanghai', 1);

SELECT dp.*, cc.country, cc.city FROM destination_points dp JOIN country_cities cc on dp.country_city_id = cc.id;

INSERT INTO transhipment_hubs VALUES
(NULL, 'HUB Vladivostok', 23),
(NULL, 'HUB Vostochny', 23),
(NULL, 'HUB Ust Luga', 21),
(NULL, 'HUB Shanghai', 1),
(NULL, 'HUB Busan', 10),
(NULL, 'HUB Hong Kong', 5),
(NULL, 'HUB Shenzhen', 2),
(NULL, 'HUB Chittagong', 8),
(NULL, 'HUB Moscow', 6),
(NULL, 'HUB Yekaterinburg', 22);

SELECT th.*, cc.country, cc.city FROM transhipment_hubs th JOIN country_cities cc on th.country_city_id = cc.id;

INSERT INTO transportation_modes (trans_mode) VALUES
('sea'),
('air'),
('railway'),
('truck'),
('river');

SELECT * from transportation_modes;

INSERT INTO transportation_routes VALUES
(NULL, 1, 2, 1, 3, NULL, 1, 8, 35),
(NULL, 1, 2, 1, 3, NULL, 3, 8, 30),
(NULL, 1, 3, 1, 4, NULL, 1, 8, 57),
(NULL, 6, 1, 1, 3, NULL, 1, 8, 45),
(NULL, 6, 3, 1, 4, NULL, 1, 8, 52),
(NULL, 1, NULL, NULL, NULL, 2, 1, 8, 12),
(NULL, 4, NULL, NULL, NULL, 2, 1, 8, 7),
(NULL, 7, NULL, NULL, NULL, 4, 1, 8, 14),
(NULL, 3, NULL, NULL, NULL, 3, 5, 8, 17),
(NULL, 3, NULL, NULL, NULL, 3, 1, 8, 21);

SELECT c.name, pol.name, th.name, tm1.trans_mode, tm2.trans_mode, tm3.trans_mode, dp.name, tr.transit_time
FROM transportation_routes tr
LEFT JOIN ports_of_loading pol on tr.port_of_loading_id = pol.id
LEFT JOIN transhipment_hubs th on tr.trans_hub_id = th.id
LEFT JOIN transportation_modes tm1 on tr.from_port_to_hub_trans_mode_id = tm1.id
LEFT JOIN transportation_modes tm2 on tr.from_hub_to_dest_point_trans_mode_id = tm2.id
LEFT JOIN transportation_modes tm3 on tr.from_port_to_dest_point_trans_mode_id = tm3.id
LEFT JOIN destination_points dp on tr.destination_point_id = dp.id
LEFT JOIN collections c on tr.collection_id = c.id;

-- найти самый быстрый маршрут доставки в Москву из Шанхая кроме авиа транспорта
SELECT pol.name, th.name, tm1.trans_mode, tm2.trans_mode, tm3.trans_mode, dp.name, tr.transit_time
FROM transportation_routes tr
LEFT JOIN ports_of_loading pol on tr.port_of_loading_id = pol.id
LEFT JOIN transhipment_hubs th on tr.trans_hub_id = th.id
LEFT JOIN transportation_modes tm1 on tr.from_port_to_hub_trans_mode_id = tm1.id
LEFT JOIN transportation_modes tm2 on tr.from_hub_to_dest_point_trans_mode_id = tm2.id
LEFT JOIN transportation_modes tm3 on tr.from_port_to_dest_point_trans_mode_id = tm3.id
LEFT JOIN destination_points dp on tr.destination_point_id = dp.id
WHERE (pol.name = 'Shanghai') AND (dp.name = 'FDC Moscow') AND (tm3.trans_mode != 'air' or tm3.trans_mode is NULL)
  AND (tm2.trans_mode != 'air' OR tm2.trans_mode is NULL) AND (tm1.trans_mode != 'air' OR tm1.trans_mode is NULL)
ORDER BY tr.transit_time LIMIT 1;

-- вывести результирующую таблицу с объединенными названиями маршрутов, видом транспорта и транзитным временем
-- иф можно сделать через функцию
SELECT tr.id, CONCAT (pol.name, ' - ',
    IF(th.name is NOT NULL, CONCAT(th.name,' '), ''),
    IF(tm1.trans_mode is NOT NULL, CONCAT('by ',tm1.trans_mode, ' - '), ''), dp.name,
    IF(tm2.trans_mode is NOT NULL, CONCAT(' by ',tm2.trans_mode), ''),
    IF(tm3.trans_mode is NOT NULL, CONCAT(' by ',tm3.trans_mode), '') ) AS transit_route_name, tr.transit_time
FROM transportation_routes tr
LEFT JOIN ports_of_loading pol on tr.port_of_loading_id = pol.id
LEFT JOIN transhipment_hubs th on tr.trans_hub_id = th.id
LEFT JOIN transportation_modes tm1 on tr.from_port_to_hub_trans_mode_id = tm1.id
LEFT JOIN transportation_modes tm2 on tr.from_hub_to_dest_point_trans_mode_id = tm2.id
LEFT JOIN transportation_modes tm3 on tr.from_port_to_dest_point_trans_mode_id = tm3.id
LEFT JOIN destination_points dp on tr.destination_point_id = dp.id
ORDER BY tr.id;

INSERT INTO contracts VALUES
(NULL, 1, 1, 'IRR/STS/001/AW22', 8, 'active', 1, 1, 1, 1, 2, NULL),
(NULL, 1, 4, 'IRR/STI/002/AW22', 8, 'active', 4, 1, 8, 1, 1, NULL),
(NULL, 2, 7, 'IRL/ZTS/003/AW22', 8, 'active', 3, 7, 2, 1, 9, NULL),
(NULL, 1, 10, 'IRR/HJO/005/AW22', 8, 'active', 1, 4, 1, 1, 3, NULL),
(NULL, 1, 6, 'IRR/CMI/004/AW22', 8, 'active', 1, 6, 1, 1, 10, NULL),
(NULL, 1, 5, 'IRR/SAM/006/AW22', 8, 'active', 4, 2, 1, 1, 4, NULL),
(NULL, 1, 2, 'IRR/NSI/007/AW21', 6, 'deactivated', 1, 3, 2, 1, 9, NULL),
(NULL, 1, 3, 'IRR/SHC/008/AW22', 8, 'active', 4, 1, 1, 1, 2, NULL),
(NULL, 2, 8, 'IRL/HEM/010/AW22', 8, 'active', 1, 8, 8, 1, 7, 15),
(NULL, 1, 9, 'IRR/ADG/012/SS22', 7, 'on hold', 1, 1, 1, 1, 1, NULL)

SELECT pdp.due_points, payment_terms.* FROM payment_terms JOIN payment_due_points pdp on payment_terms.payment_due_point_id = pdp.id;

Shanghai Textiles  leg entity id 1 and 4
order id 1 and 7 and 2
pt 20 - 50 - 30 / 60
pt 10 - 60 - 30 / 90
amount 70378.70 21277.08 67075.82

SELECT * FROM contracts;

-- достать валюты
SELECT alias.alias_suppl_name, cur.name_acronym, cur.id as cur_id, con.contract_no
FROM contracts con
JOIN suppliers_leg_entities sle ON con.supplier_leg_entity_id = sle.id
JOIN alias_suppliers alias ON alias.id = sle.entity_alias_id
JOIN currencies cur ON con.currency_id = cur.id;

-- допустим байер хочет закупить партию рубашек, и ему надо узнать кому можно разместить заказ
-- по след критериям (поставщик производит футболки, подписан договор, договор активный,
-- есть действующая фабрика,  варианты доставки в Москву не более 30 дней, отсрочка платежа не менее 30% и не менее 90 дней )

select * from contracts;


SELECT alias.alias_suppl_name, sle.entity_name, tr.transit_time, pt.class, pt.subclass, con.status, pf.status
FROM contracts con
JOIN suppliers_leg_entities sle on con.supplier_leg_entity_id = sle.id
JOIN alias_suppliers alias on sle.entity_alias_id = alias.id
JOIN production_facilities pf on alias.id = pf.alias_suppl_id
JOIN production_facilities_types pft on pf.id = pft.production_facility_id
JOIN production_types pt on pft.production_types_id = pt.id
JOIN transportation_routes tr on con.ports_of_loading_id = tr.port_of_loading_id = pf.port_of_loading_id
JOIN destination_points dp on tr.destination_point_id = dp.id
WHERE pt.subclass = 'SHIRTS' AND con.status = 'active' AND pf.status = 'Approved'
AND tr.transit_time <= 40 AND dp.name = 'FDC Moscow';

INSERT INTO bank_details_status (name) VALUES
    ('active'),
    ('deactivated');

SELECT * FROM bank_details_status;

INSERT INTO bank_details VALUES
(NULL, 1, 'Shanghai Textiles Supplies Co. Ltd.', 'Mainstreet 2, Road Town, British Virgin Islands', 7, 'Virgin Trust Bank BVI', 'Mainstreet 5, Road Town, British Virgin Islands',
 7, 38585904, 3040053, 'VTBBVI', 1, NOW(), NOW()),
(NULL, 2, 'Shanghai Trading I&E Co. Ltd', 'Xuehuadadao 23, Shanghai, China', 1, 'Construction Bank of China', 'Liujielu 34, Shanghai, China',
 1, 90394984, 00309393, 'CBHSWF', 1, NOW(), NOW()),
(NULL, 3, 'Zeria Tekstil Sanayi ve Dİs Ticaret Ltd Sti', 'Esenler Sk 1, Istanbul, Turkey ', 9, 'International Bank of Commerce',
 'Turkoglu 34, Istanbul, Turkey', 9, 24948943, 849398384, 'IBCTURK', 1, NOW(),NOW()),
(NULL, 4, 'H&J Outerwear Apparels Co. Ltd', 'Xihulu 29, Xiamen, China ', 4, 'Bank of China Xiamen Branch', 'Shangxiadadao 34, Xiamen, China',
 4, 949403033,94940402, 'BOCXMN', 1, NOW(), NOW()),
(NULL, 5, 'Chittagong Minar Industries Co. Ltd', 'Queens Street 10, Chittagong, Bangladesh', 8, 'Islamic Bank of Bangladesh', 'Fortune Road 23, Chittagong, Bangladesh', 8,
 57389393, 203948484, 'ISBCTG', 1, NOW(), NOW()),
 (NULL, 6, 'Shuangfeng Accessories Manufacturing Co. Ltd', 'Xinguolu 65, Shenzhen, China', 2, 'Agricultural Bank of China',
  'Zhuyaodadao 84, Shenzhen, China', 2, 7383943, 10984742, 'ABCSHZ', 2, now(), now()),
(NULL, 7, 'Ningbo Supreme Import & Export Co. Ltd', 'Shijiedadao 84, Ningbo, China', 3, 'ICBC Ningbo branch', 'Louhongqiao 29, Ningbo, China',
 3, 8694943, 84949384, 'ICBCNGB', 1, NOW(), NOW()),
(NULL, 8, 'Shanghai Knitwear Co. Ltd.', 'Dongfengdadao 13, Shanghai, China', 1, 'Construction Bank of China', 'Xidonglu 48, Shanghai, China',
 1, 95958432,50595984, 'CBCSHA', 2, NOW(), NOW()),
(NULL, 9, 'Heung Apparels Manufacturing LLC', 'Minhaseung 34, Busan, Korea', 10, 'Korean Bank of Trade and Commerce',
 'Bunghaseyong 93, Busan, Korea', 10, 8478722, 84733823,'KBRCBSN', 1, NOW(), NOW()),
(NULL, 10, 'Anhui Dafeng Garments I&E Co. Ltd', 'Liudalu 98, Shanghai, China', 1, 'Shanghai Trading Bank', 'Xinshijielu 23, Shanghai, China',
 1, 57348393, 94587362, 'STBSHA', 2, NOW(), NOW());

SELECT * FROM bank_details;

INSERT INTO delivery_instores VALUES
(NULL, 8, 10, '2022-07-06'),
(NULL, 8, 9, '2022-06-22'),
(NULL, 8, 8, '2022-06-08'),
(NULL, 8, 7, '2022-05-25'),
(NULL, 8, 6, '2022-05-11'),
(NULL, 8, 5, '2022-04-27'),
(NULL, 8, 4, '2022-04-13'),
(NULL, 8, 3, '2022-03-30'),
(NULL, 8, 2, '2022-03-16'),
(NULL, 8, 1, '2022-03-02');

SELECT * from delivery_instores;

-- как натянуть маршруты на заказы

INSERT INTO product_styles VALUES
('LT4R3400', 8, 1, 4.7800, 4, 3455, 6, 8, 2, 2, 1, NOW(), NOW()),
('MK5R3499', 8, 1, 3.4800, 4, 14529, 8, 10, 7, 1, 2, NOW(), NOW()),
('MK9F4278', 8, 5, 5.9300, 1, 45395, 2, 3, 3, 1, 5, NOW(), NOW()),
('MP3L9402', 8, 6, 9.4500, 3, 24520, 5, 7, 4, 5, 6, NOW(), NOW()),
('LD3O4901', 8, 9, 34.2300, 1, 18428, 9, 2, 8, 6, 7, NOW(), NOW()),
('MO3J4828', 8, 1, 5.9400, 1, 3582, 6, 9, 6, 4, 1, NOW(), NOW()),
('LE9I8308', 8, 4, 4.7300, 4, 5380, 8, 8, 6, 2, 8, NOW(), NOW()),
('GP2K3800', 8, 1, 7.4200, 1, 9485, 6, 8, 2, 7, 1, NOW(), NOW()),
('MJ9L9399', 8, 6, 12.9200, 3, 32560, 5, 7, 2, 6, 6, NOW(), NOW()),
('LP2H6255', 8, 9, 23.4900, 1, 21840, 9, 1, 9, 10, 7, NOW(), NOW());


SELECT style_no, SUM(price_value * ordered_qty) FROM product_styles GROUP BY 1;

select alias.alias_suppl_name, count(ps.style_no)
from product_styles ps join alias_suppliers alias on alias.id = ps.supplier_alias_id
GROUP BY 1;

# update product_styles set price_currency_id = 4 where style_no = 'GP2K3800';
# update product_styles set price_currency_id = 4 where style_no = 'MO3J4828';
# update product_styles set price_currency_id = 1 where style_no = 'LT4R3400';
# update product_styles set price_currency_id = 1 where style_no = 'MK5R3499';

-- группировка стоимости всех моделей по валюте платежа
SELECT c.name_acronym, SUM(ps.price_value * ps.ordered_qty) AS amount
FROM product_styles ps JOIN currencies c on ps.price_currency_id = c.id
GROUP BY 1
ORDER BY 2;

SELECT alias.alias_suppl_name, c.id as contract_id
FROM product_styles ps
JOIN alias_suppliers alias on ps.supplier_alias_id = alias.id
JOIN suppliers_leg_entities sle on alias.id = sle.entity_alias_id
JOIN contracts c on sle.id = c.supplier_leg_entity_id
GROUP BY 2;
+------------------------+-------------+
| alias_suppl_name       | contract_id |
+------------------------+-------------+
| Shanghai Textiles      |           1 |
| Shanghai Textiles      |           2 |
| Shuangfeng Accessories |           6 |
| Minar Industry         |           5 |
| Zeria Tekstil          |           3 |
| H&J                    |           4 |
+------------------------+-------------+

INSERT INTO orders VALUES
(NULL, 1, now()),
(NULL, 2, now()),
(NULL, 3, now()),
(NULL, 4, now()),
(NULL, 5, now()),
(NULL, 6, now()),
(NULL, 1, now()),
(NULL, 1, now()),
(NULL, 5, now());
SELECT ps.style_no, alias.alias_suppl_name, cc.city, ps.ordered_qty
FROM product_styles ps
JOIN alias_suppliers alias ON ps.supplier_alias_id = alias.id
JOIN country_cities cc ON alias.alias_suppl_country_city_id = cc.id;
+----+----------------------------------------------------------------+--------------+
| id | transit_route_name                                             | transit_time |
+----+----------------------------------------------------------------+--------------+
|  1 | Shanghai - HUB Vostochny by sea - FDC Moscow by railway        |           35 |
|  2 | Shanghai - HUB Vostochny by sea - RDC Yekaterinburg by railway |           30 |
|  3 | Shanghai - HUB Ust Luga by sea - FDC Moscow by truck           |           57 |
|  4 | Chittagong - HUB Vladivostok by sea - FDC Moscow by railway    |           45 |
|  5 | Chittagong - HUB Ust Luga by sea - FDC Moscow by truck         |           52 |
|  6 | Shanghai - FDC Moscow by air                                   |           12 |
|  7 | Xiamen - FDC Moscow by air                                     |            7 |
|  8 | Istambul - FDC Moscow by truck                                 |           14 |
|  9 | Ningbo - RDC Novosibirsk by railway                            |           17 |
| 10 | Ningbo - FDC Moscow by railway                                 |           21 |
+----+----------------------------------------------------------------+--------------+
INSERT INTO orders_products (order_id, style_no_id, qty_share_to_ship_by_route, transportation_route_id) VALUES
(5, 'MK9F4278', 70, 4),
(5, 'MK9F4278', 30, 5),
(3, 'MJ9L9399', 100, 8),
(3, 'MP3L9402', 100, 8),
(1, 'GP2K3800', 60, 1),
(1, 'GP2K3800', 40, 2),
(2, 'LT4R3400', 80, 1),
(2, 'LT4R3400', 20, 3),
(2, 'MK5R3499', 70, 1),
(2, 'MK5R3499', 30, 6),
(7, 'MO3J4828', 100, 3),
(6, 'LE9I8308', 100, 7),
(4, 'LD3O4901', 100, 7),
(4, 'LP2H6255', 100, 7);

Shanghai Textiles  leg entity id 1 and 4
order id 1 and 7 and 2
pt 20 - 50 - 30 / 60
pt 10 - 60 - 30 / 90
amount 70378.70 21277.08 67075.82 = 158731.6
|        1 | GP2K3800    |                         60 |                       1 |     42227.22 |
|        1 | GP2K3800    |                         40 |                       2 |     28151.48 |
|        2 | LT4R3400    |                         80 |                       1 |     13211.92 |
|        2 | LT4R3400    |                         20 |                       3 |      3302.98 |
|        2 | MK5R3499    |                         70 |                       1 |     35392.64 |
|        2 | MK5R3499    |                         30 |                       6 |     15168.28 |
|        7 | MO3J4828    |                        100 |                       3 |     21277.08 |
+----------+-------------+----------------------------+-------------------------+--------------+
| order_id | style_no_id | qty_share_to_ship_by_route | transportation_route_id | order_amount |
+----------+-------------+----------------------------+-------------------------+--------------+
|        5 | MK9F4278    |                         70 |                       4 |    188434.65 |
|        5 | MK9F4278    |                         30 |                       5 |     80757.71 |
|        3 | MJ9L9399    |                        100 |                       8 |    420675.20 |
|        3 | MP3L9402    |                        100 |                       8 |    231714.00 |
|        1 | GP2K3800    |                         60 |                       1 |     42227.22 |
|        1 | GP2K3800    |                         40 |                       2 |     28151.48 |
|        2 | LT4R3400    |                         80 |                       1 |     13211.92 |
|        2 | LT4R3400    |                         20 |                       3 |      3302.98 |
|        2 | MK5R3499    |                         70 |                       1 |     35392.64 |
|        2 | MK5R3499    |                         30 |                       6 |     15168.28 |
|        7 | MO3J4828    |                        100 |                       3 |     21277.08 |
|        6 | LE9I8308    |                        100 |                       7 |     25447.40 |
|        4 | LD3O4901    |                        100 |                       7 |    630790.44 |
|        4 | LP2H6255    |                        100 |                       7 |    513021.60 |
+----------+-------------+----------------------------+-------------------------+--------------+

DELIMITER //
DROP TRIGGER IF EXISTS calc_amount //
CREATE TRIGGER calc_amount BEFORE INSERT ON orders_products
FOR EACH ROW
BEGIN
    SET NEW.order_amount =
        (SELECT ps.price_value FROM product_styles AS ps WHERE ps.style_no = NEW.style_no_id LIMIT 1) *
        (SELECT ps.ordered_qty FROM product_styles AS ps WHERE ps.style_no = NEW.style_no_id LIMIT 1) *
        (NEW.qty_share_to_ship_by_route / 100);
END //

INSERT INTO payments VALUES
(NULL, 'advance payment', 1, 0, 0, 'approved', now()),
(NULL, 'before shipment', 1, 0, 0, 'created', now()),
(NULL, 'advance payment', 7, 0, 0, 'created', now()),
(NULL, 'advance payment', 2, 0, 0, 'created', now()),
(NULL, 'advance payment', 3, 0, 0, 'approved', now()),
(NULL, 'before shipment', 3, 0, 0, 'approved', now()),
(NULL, 'postpayment_1', 3, 0, 0, 'created', now()),
(NULL, 'before shipment', 4, 0, 0, 'created', now()),
(NULL, 'postpayment_1', 5, 0, 0, 'approved', now()),
(NULL, 'postpayment_2', 5, 0, 0, 'created', now());

DELIMITER //
DROP TRIGGER IF EXISTS calc_check_payment //
CREATE TRIGGER calc_check_payment BEFORE INSERT ON payments
FOR EACH ROW
BEGIN
    DECLARE p_type VARCHAR(255);
    DECLARE amount_share_for_payment INT;
    DECLARE order_calc_amount DECIMAL(12,2);
    SET p_type = NEW.payment_type;
    SET order_calc_amount = (SELECT sum(order_amount)
                            FROM orders_products op WHERE op.order_id = NEW.order_id);

    CASE p_type
        WHEN 'advance payment' THEN
        SET amount_share_for_payment = (SELECT pt.advance_payment_val
                                FROM orders
                                JOIN contracts contr on orders.contract_no_id = contr.id
                                JOIN payment_terms pt on contr.payment_terms_id = pt.id
                                WHERE NEW.order_id = orders.id);
        WHEN 'before shipment' THEN
        SET amount_share_for_payment = (SELECT pt.before_shpmt_payment_val
                                FROM orders
                                JOIN contracts contr on orders.contract_no_id = contr.id
                                JOIN payment_terms pt on contr.payment_terms_id = pt.id
                                WHERE NEW.order_id = orders.id);
        WHEN 'postpayment_1' THEN
        SET amount_share_for_payment = (SELECT pt.postpayment_1_val
                                FROM orders
                                JOIN contracts contr on orders.contract_no_id = contr.id
                                JOIN payment_terms pt on contr.payment_terms_id = pt.id
                                WHERE NEW.order_id = orders.id);
        WHEN 'postpayment_2' THEN
        SET amount_share_for_payment = (SELECT pt.postpayment_2_val
                                FROM orders
                                JOIN contracts contr on orders.contract_no_id = contr.id
                                JOIN payment_terms pt on contr.payment_terms_id = pt.id
                                WHERE NEW.order_id = orders.id);
    END CASE;
    SET NEW.payment_amount_suggested = order_calc_amount * (amount_share_for_payment/100);

END //

SELECT alias_suppl_name, sle.id, orders.id  as order_id, contr.contract_no, SUM(op.order_amount),
       pt.advance_payment_val,
       pt.before_shpmt_payment_val,
       pt.postpayment_1_val, pt.postpayment_2_val,
       pt.postpayment_1_due_point_delta, pt.postpayment_2_due_point_delta
FROM orders
JOIN contracts contr on orders.contract_no_id = contr.id
JOIN suppliers_leg_entities sle on contr.supplier_leg_entity_id = sle.id
JOIN alias_suppliers alias on sle.entity_alias_id = alias.id
JOIN orders_products op on orders.id = op.order_id
JOIN payment_terms pt on contr.payment_terms_id = pt.id
GROUP BY 1,2,3;

SELECT alias.alias_suppl_name, sle.id
FROM suppliers_leg_entities sle
JOIN alias_suppliers alias on sle.entity_alias_id = alias.id;

Shanghai Textiles contract id 1 and 4; leg entity id 1 and 4
order id 1 and 7 and 2
pt 20 - 50 - 30 / 60
pt 10 - 60 - 30 / 90
amount 70378.70 21277.08 67075.82





SELECT alias.alias_suppl_name, ord.id as order_id, contr.id as contr_id
FROM orders ord
JOIN contracts contr on ord.contract_no_id = contr.id
JOIN suppliers_leg_entities sle on contr.supplier_leg_entity_id = sle.id
JOIN alias_suppliers alias on sle.entity_alias_id = alias.id
+------------------------+--------------+--------+------------------+
| alias_suppl_name       | name_acronym | cur_id | contract_no      |
+------------------------+--------------+--------+------------------+
| Shanghai Textiles      | USD          |      1 | IRR/STS/001/AW22 |
| Shanghai Textiles      | CNY          |      4 | IRR/STI/002/AW22 |
| Zeria Tekstil          | EUR          |      3 | IRL/ZTS/003/AW22 |
| H&J                    | USD          |      1 | IRR/HJO/005/AW22 |
| Minar Industry         | USD          |      1 | IRR/CMI/004/AW22 |
| Shuangfeng Accessories | CNY          |      4 | IRR/SAM/006/AW22 |
| Ningbo Supreme         | USD          |      1 | IRR/NSI/007/AW21 |
| Shanghai Knitwear      | CNY          |      4 | IRR/SHC/008/AW22 |
| Heung Apparels         | USD          |      1 | IRL/HEM/010/AW22 |
| Anhui Garments         | USD          |      1 | IRR/ADG/012/SS22 |
+------------------------+--------------+--------+------------------+


-- для проверки заполнения:
SELECT alias.id as alias_id, alias.alias_suppl_name as alias_name, pt.id as pt_type, pt.class, pt.subclass, pd.id as descr, pd.description,
       pf.id as factory_id, pf.facility_name as factory_name,sle.entity_name, sle.entity_reg_address, cc.country, cc.city
FROM contracts con
JOIN suppliers_leg_entities sle on con.supplier_leg_entity_id = sle.id
JOIN alias_suppliers alias on sle.entity_alias_id = alias.id
JOIN country_cities cc on alias.alias_suppl_country_city_id = cc.id
JOIN production_facilities pf on alias.id = pf.alias_suppl_id
JOIN production_facilities_types pft on pf.id = pft.production_facility_id
JOIN production_types pt on pft.production_types_id = pt.id
JOIN product_descriptions pd on pt.id = pd.production_type_id
ORDER BY 1;


+-------------+------------------------+----------------------------------------------+-------------------------------------------------+------------+------------+
| CONTRACT_ID | alias_suppl_name       | entity_name                                  | entity_reg_address                              | country    | city       |
+-------------+------------------------+----------------------------------------------+-------------------------------------------------+------------+------------+
|           1 | Shanghai Textiles      | Shanghai Textiles Supplies Co. Ltd.          | Mainstreet 2, Road Town, British Virgin Islands | China      | Shanghai   |
|           2 | Shanghai Textiles      | Shanghai Trading I&E Co. Ltd                 | Xuehuadadao 23, Shanghai, China                 | China      | Shanghai   |
|           3 | Zeria Tekstil          | Zeria Tekstil Sanayi ve Dİs Ticaret Ltd Sti  | Esenler Sk 1, Istanbul, Turkey                  | Turkey     | Istambul   |
|           4 | H&J                    | H&J Outerwear Apparels Co. Ltd               | Xihulu 29, Xiamen, China                        | China      | Xiamen     |
|           5 | Minar Industry         | Chittagong Minar Industries Co. Ltd          | Queens Street 10, Chittagong, Bangladesh        | Bangladesh | Chittagong |
|           6 | Shuangfeng Accessories | Shuangfeng Accessories Manufacturing Co. Ltd | Xinguolu 65, Shenzhen, China                    | China      | Shenzhen   |
|           7 | Ningbo Supreme         | Ningbo Supreme Import & Export Co. Ltd       | Shijiedadao 84, Ningbo, China                   | China      | Ningbo     |
|           8 | Shanghai Knitwear      | Shanghai Knitwear Co. Ltd.                   | Dongfengdadao 13, Shanghai, China               | China      | Shanghai   |
|           9 | Heung Apparels         | Heung Apparels Manufacturing LLC             | Minhaseung 34, Busan, Korea                     | Korea      | Busan      |
|          10 | Anhui Garments         | Anhui Dafeng Garments I&E Co. Ltd            | Liudalu 98, Shanghai, China                     | China      | Shanghai   |
+-------------+------------------------+----------------------------------------------+-------------------------------------------------+------------+------------+
+------------------------+------+----------------------------------------------+
| alias_suppl_name       | id   | entity_name                                  |
+------------------------+------+----------------------------------------------+
| Top Shirts             | NULL | NULL                                         |
| Shanghai Textiles      |    1 | Shanghai Textiles Supplies Co. Ltd.          |
| Ningbo Supreme         |    2 | Ningbo Supreme Import & Export Co. Ltd       |
| Shanghai Knitwear      |    3 | Shanghai Knitwear Co. Ltd.                   |
| Shanghai Textiles      |    4 | Shanghai Trading I&E Co. Ltd                 |
| Shuangfeng Accessories |    5 | Shuangfeng Accessories Manufacturing Co. Ltd |
| Minar Industry         |    6 | Chittagong Minar Industries Co. Ltd          |
| Zeria Tekstil          |    7 | Zeria Tekstil Sanayi ve Dİs Ticaret Ltd Sti  |
| Heung Apparels         |    8 | Heung Apparels Manufacturing LLC             |
| Anhui Garments         |    9 | Anhui Dafeng Garments I&E Co. Ltd            |
| H&J                    |   10 | H&J Outerwear Apparels Co. Ltd               |
+------------------------+------+----------------------------------------------+

--
+-------+------------+----+------------+------------+
| polID | name       | id | country    | city       |
+-------+------------+----+------------+------------+
|     1 | Shanghai   |  1 | China      | Shanghai   |
|     2 | Shenzhen   |  2 | China      | Shenzhen   |
|     3 | Ningbo     |  3 | China      | Ningbo     |
|     4 | Xiamen     |  4 | China      | Xiamen     |
|     5 | Hong Kong  |  5 | China      | Hong Kong  |
|     6 | Chittagong |  8 | Bangladesh | Chittagong |
|     7 | Istambul   |  9 | Turkey     | Istambul   |
|     8 | Busan      | 10 | Korea      | Busan      |
+-------+------------+----+------------+------------+

+----+-------------------+-----------------+
| id | name              | country_city_id |
+----+-------------------+-----------------+
|  1 | HUB Vladivostok   |              23 |
|  2 | HUB Vostochny     |              23 |
|  3 | HUB Ust Luga      |              21 |
|  4 | HUB Shanghai      |               1 |
|  5 | HUB Busan         |              10 |
|  6 | HUB Hong Kong     |               5 |
|  7 | HUB Shenzhen      |               2 |
|  8 | HUB Chittagong    |               8 |
|  9 | HUB Moscow        |               6 |
| 10 | HUB Yekaterinburg |              22 |
+----+-------------------+-----------------+

+----+----------------------+-----------------+
| id | name                 | country_city_id |
+----+----------------------+-----------------+
|  1 | FDC Moscow           |               6 |
|  2 | RDC Saint Petersburg |              21 |
|  3 | RDC Yekaterinburg    |              22 |
|  4 | RDC Vladivostok      |              23 |
|  5 | RDC Novosibirsk      |              24 |
|  6 | NDC Shanghai         |               1 |
+----+----------------------+-----------------+

+----+------+
| id | name |
+----+------+
|  2 | AW19 |
|  4 | AW20 |
|  6 | AW21 |
|  8 | AW22 |
| 10 | AW23 |
|  1 | SS19 |
|  3 | SS20 |
|  5 | SS21 |
|  7 | SS22 |
|  9 | SS23 |
+----+------+

cny styles alias.id = 1:
('LT4R3400', 8, 1, 4.7800, 4, 3455, 6, 8, 2, 2, 1, NOW(), NOW()),
('MK5R3499', 8, 1, 3.4800, 4, 14529, 8, 10, 7, 1, 2, NOW(), NOW()),
contract id = 2, currency CNY - IRR/STI/002/AW22
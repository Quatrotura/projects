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
ORDER BY 2;


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
SELECT types.class, types.subclass, alias.alias_suppl_name ,factory.facility_name
FROM production_facilities_types factory_types JOIN production_facilities factory ON factory_types.production_facility_id = factory.id
JOIN alias_suppliers alias ON factory.alias_suppl_id = alias.id
JOIN production_types types ON factory_types.production_types_id = types.id;

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
    (NULL, 1, 3, 1, 3, NULL, 3, 8, 55),
--
-- найти самый быстрый маршрут доставки в Москву из Шанхая
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
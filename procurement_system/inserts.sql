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
	('Korea', 'Busan'),
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

INSERT INTO alias_buyers(alias_buyer_name, alias_buyer_country_city_id) VALUES
	('Inditex', 6 ),
	('Inditex Logistics', 6);

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

INSERT INTO buyers_leg_entities VALUES
(NULL, 'Inditex Retail Solutions Rus Co., Ltd.', 481983947, 'ulitsa Yakimanka 31, Moscow, Russia', 'Presnenskay Naberezhnaya 10, Blok C, etazh 35, Moscow, Russia', 6, 1),
(NULL, 'Inditex Logistcs Services Rus Co. Ltd.', 481983384, 'Promyshlenny Proezd 485, Moscow, Russia', 'Promyshlenny Proezd 485, Moscow, Russia', 6, 2);

INSERT INTO ports_of_loading VALUES
(NULL, 'Shanghai', 1),
(NULL, 'Shenzhen', 2),
(NULL, 'Ningbo', 3),
(NULL, 'Xiamen', 4),
(NULL, 'Hong Kong', 5),
(NULL, 'Chittagong', 8),
(NULL, 'Istambul', 9),
(NULL, 'Busan', 10);

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

INSERT INTO production_facilities VALUES
(NULL, 'Xinshuai Zhenfeng Textile Co. Ltd', 'Bingfengdadao 34, Shanghai, China', 1, 1, 'Approved', '2020-10-03', 1, null),
(NULL, 'Shanghai Textiles Industries Co. Ltd', 'Xuehuadadao 23, Shanghai, China', 1, 1, 'Approved', '2020-12-31', 1, null),
(NULL, 'Ningbo Seduno Top Sewing Co. Ltd', 'Shijiedadao 84, Ningbo, China', 3, 2, 'Approved', '2018-10-12', 3, null),
(NULL, 'Minar Woven Manufacturing Co. Ltd', 'Queens Street 10, Chittagong, Bangladesh', 8, 5, 'Inspection', '2021-10-17', 6, 'Problems with quality system, 6% defection ratio in the last batch. Need to reinspect in-line quality system'),
(NULL, 'Minar Excellent Sewing Industries Co. Ltd', 'Dhaka-Bangalore National Highway 456 km, building 1, Dhaka, Bangladesh', 8, 5, 'Rejected', '2021-09-30', 6, '35% of SS21 bulk orders with major defects, 25% of retail returns. Need to go through inspection.'),
(NULL, 'Zeria Tekstil Sanayi ve Dİs Ticaret Ltd Sti', 'Esenler Sk 1, Istanbul, Turkey', 9, 6, 'Inspection', '2021-10-09', 7, 'Good quality PPS. Inspection planned on Nov 1, 2021'),
(NULL, 'Xiamen H&J Outerwear Manufacturing Co. Ltd', 'Xihulu 29, Xiamen, China', 4, 9, 'Approved', '2019-12-31', 4, null),
(NULL, 'Haochi Huluobo Indusrial Co. Ltd.', 'Xinguolu 65, Shenzhen, China',2, 4, 'Approved', '2016-01-31', 2, null),
(NULL, 'Ssang Yong Heung Textile Industries Co., Ltd', 'Minhaseung 34, Busan, Korea', 10, 7, 'Approved', '2021-04-20', 8, null),
(NULL, 'Istanbul tekstil üretim şirketi', 'Sarhoş rusların sokağı 10, Instanbul, Turkey', 9, 6, 'Approved', '2020-08-19', 7, null);

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

INSERT INTO destination_points VALUES
(NULL, 'FDC Moscow', 6),
(NULL, 'RDC Saint Petersburg', 11),
(NULL, 'RDC Yekaterinburg', 12),
(NULL, 'RDC Vladivostok', 13),
(NULL, 'RDC Novosibirsk', 14),
(NULL, 'NDC Shanghai', 1);

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

INSERT INTO transportation_modes (trans_mode) VALUES
('sea'),
('air'),
('railway'),
('truck'),
('river');

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

INSERT INTO contracts VALUES
(NULL, 1, 1, 'IRR/STS/001/AW22', 8, 'active', 1, 1, 1, 1, 2, NULL),
(NULL, 1, 4, 'IRR/STI/002/AW22', 8, 'active', 4, 1, 8, 1, 1, NULL),
(NULL, 2, 7, 'IRL/ZTS/003/AW22', 8, 'active', 3, 7, 2, 1, 9, NULL),
(NULL, 1, 10, 'IRR/HJO/005/AW22', 8, 'active', 1, 4, 1, 1, 3, NULL),
(NULL, 1, 6, 'IRR/CMI/004/AW22', 8, 'active', 1, 6, 1, 1, 10, NULL),
(NULL, 1, 5, 'IRR/SAM/006/AW22', 8, 'deactivated', 4, 2, 1, 1, 4, NULL),
(NULL, 1, 2, 'IRR/NSI/007/AW21', 6, 'deactivated', 1, 3, 2, 1, 9, NULL),
(NULL, 1, 3, 'IRR/SHC/008/AW22', 8, 'active', 4, 1, 1, 1, 2, NULL),
(NULL, 2, 8, 'IRL/HEM/010/AW22', 8, 'active', 1, 8, 8, 1, 7, 15),
(NULL, 1, 9, 'IRR/ADG/012/SS22', 7, 'on hold', 1, 1, 1, 1, 1, NULL);

INSERT INTO bank_details_status (name) VALUES
    ('active'),
    ('deactivated');

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

INSERT INTO payments VALUES
(NULL, 'advance payment', 7, 0, 0, 'remitted', now()),
(NULL, 'advance payment', 8, 0, 0, 'remitted', now()),
(NULL, 'advance payment', 9, 0, 0, 'remitted', now()),
(NULL, 'advance payment', 10, 0, 0, 'remitted', now()),
(NULL, 'before shipment', 7, 0, 0, 'remitted', now()),
(NULL, 'before shipment', 8, 0, 0, 'remitted', now()),
(NULL, 'before shipment', 9, 0, 0, 'remitted', now()),
(NULL, 'before shipment', 10, 0, 0, 'remitted', now()),
(NULL, 'advance payment', 11, 0, 0, 'remitted', now()),
(NULL, 'before shipment', 11, 0, 0, 'remitted', now()),
(NULL, 'postpayment_1', 11, 0, 0, 'remitted', now()),
(NULL, 'advance payment', 12, 0, 0, 'remitted', now()),
(NULL, 'postpayment_1', 12, 0, 0, 'remitted', now()),
(NULL, 'advance payment', 3, 0, 0, 'remitted', now()),
(NULL, 'advance payment', 5, 0, 0, 'remitted', now());






DROP DATABASE IF EXISTS procurement_db;
CREATE DATABASE IF NOT EXISTS procurement_db;

use procurement_db;

DROP TABLE IF EXISTS roles;
CREATE TABLE IF NOT EXISTS roles (
    role_name VARCHAR(60) PRIMARY KEY,
    commands TEXT NOT NULL,
    permitted_tables TEXT NOT NULL
);


-- сделать тригер на создание роли (нет: подтягивание ролей из mysql.role_edges, mysql.user после создания роли)

DROP TABLE IF EXISTS users;
CREATE TABLE IF NOT EXISTS users (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    firstname CHAR NOT NULL,
    lastname CHAR NOT NULL,
    patron_name CHAR NOT NULL,
    acc_name VARCHAR(45) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    role_name VARCHAR(60) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    phone TINYINT UNSIGNED DEFAULT NULL UNIQUE,
    `status` ENUM ('active','deactivated'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(45),
    updated_at TIMESTAMP DEFAULT NULL ON update CURRENT_TIMESTAMP,
    updated_by VARCHAR(45),
    KEY index_of_roles (role_name),
    KEY index_of_lastname(lastname),
    KEY index_of_names (firstname,lastname),
    KEY index_of_emails (email),

    CONSTRAINT fk_users_role_name FOREIGN KEY (role_name) REFERENCES roles(role_name)

-- сделать триггер на создание пользователя и роли при вставке значений в эту таблицу
-- сделать триггер на встаку значения created_by, updated_by имя пользователя вставившего значения
-- еще один тригер должен учитывать статус пользователя(при выдаче прав и при удалении)

);

DROP TABLE IF EXISTS country_cities;
CREATE TABLE IF NOT EXISTS country_cities (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    country VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    KEY index_of_city (city),
    UNIQUE KEY index_of_country_city (country,city)
    -- составные индексы требуются при составных запросах с AND
    -- не ставим отдельный индекс на страну, т.к. страна - первая в составном индексе
);

DROP TABLE IF EXISTS alias_suppliers;
CREATE TABLE IF NOT EXISTS alias_suppliers(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    alias_suppl_name VARCHAR(255) NOT NULL UNIQUE COMMENT 'Псевдоним поставщика внутри закупочной компании необходим, т.к. у одного поставщика может быть несколько юр лиц.',
    alias_suppl_country_city_id BIGINT UNSIGNED NOT NULL,

    CONSTRAINT fk_alias_suppl_country_city_id FOREIGN KEY (alias_suppl_country_city_id)
    REFERENCES country_cities(id),

    KEY index_of_alias_suppl_name (alias_suppl_name),
    KEY index_of_alias_suppl_country_city_id (alias_suppl_country_city_id)
    -- потом добавить scoring_id (инфа подтягивается триггером)
);

DROP TABLE IF EXISTS alias_buyers;
CREATE TABLE IF NOT EXISTS alias_buyers(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    alias_buyer_name VARCHAR(255) NOT NULL UNIQUE,
    alias_buyer_country_city_id BIGINT UNSIGNED NOT NULL,

    CONSTRAINT fk_alias_buyers_country_city_id FOREIGN KEY (alias_buyer_country_city_id)
    REFERENCES country_cities(id),

    KEY index_of_alias_suppl_name (alias_buyer_name),
    KEY index_of_alias_suppl_country_city_id (alias_buyer_country_city_id)
);

DROP TABLE IF EXISTS suppliers_leg_entities;
CREATE TABLE IF NOT EXISTS suppliers_leg_entities(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    entity_name VARCHAR(255) NOT NULL COMMENT 'Юридическое наименование поставщика, не уникально, т.к. юридические наименования могут повторяться',
    entity_tax_id BIGINT UNSIGNED NOT NULL UNIQUE COMMENT 'ИНН',
    entity_reg_address TEXT NOT NULL,
    entity_fact_address TEXT NOT NULL,
    entity_reg_country_city_id BIGINT UNSIGNED NOT NULL COMMENT 'Необходимо т.к. офис поставщика может находиться в одном городе-стране, а юридическое лицо где-нибуль на виргинских островах',
    entity_alias_id BIGINT UNSIGNED NOT NULL,

    CONSTRAINT fk_suppl_leg_entities_country_city_id FOREIGN KEY (entity_reg_country_city_id)
    REFERENCES country_cities(id)
    ON UPDATE RESTRICT
    ON DELETE RESTRICT,

    CONSTRAINT fk_suppl_leg_entities_entity_alias FOREIGN KEY (entity_alias_id)
    REFERENCES alias_suppliers(id),

    KEY index_of_entity_name(entity_name),
    KEY index_of_country_city_id(entity_reg_country_city_id),
    KEY index_of_entity_alias_id(entity_alias_id)
    -- добавить чеки на ИНН по стране (кол-во знаков) и триггер на удаление пробелов по краям строк
);

DROP TABLE IF EXISTS buyers_leg_entities;
CREATE TABLE IF NOT EXISTS buyers_leg_entities(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    entity_name VARCHAR(255) NOT NULL,
    entity_tax_id BIGINT UNSIGNED NOT NULL UNIQUE COMMENT 'ИНН',
    entity_reg_address TEXT NOT NULL,
    entity_fact_address TEXT NOT NULL,
    entity_fact_country_city_id BIGINT UNSIGNED NOT NULL,
    entity_alias_id BIGINT UNSIGNED NOT NULL,
    CONSTRAINT fk_buyer_leg_entities_country_city_id FOREIGN KEY (entity_fact_country_city_id)
    REFERENCES country_cities(id)
    ON UPDATE RESTRICT
    ON DELETE RESTRICT,

    CONSTRAINT fk_buyer_leg_entities_entity_alias FOREIGN KEY (entity_alias_id)
    REFERENCES alias_buyers(id),

    KEY index_of_entity_name(entity_name),
    KEY index_of_country_city_id(entity_fact_country_city_id),
    KEY index_of_entity_alias_id(entity_alias_id)
);

DROP TABLE IF EXISTS ports_of_loading;
CREATE TABLE IF NOT EXISTS ports_of_loading(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    country_city_id BIGINT UNSIGNED NOT NULL,

    CONSTRAINT fk_pol_country_city_id FOREIGN KEY (country_city_id)
    REFERENCES country_cities(id)
    --  думаю индексирование делать не обязательно, т.к. таблица не будет большой
);
DROP TABLE IF EXISTS production_types;
CREATE TABLE IF NOT EXISTS production_types(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    class VARCHAR(255) NOT NULL,
    subclass VARCHAR(255) NOT NULL,

    UNIQUE index_of_product_types (class, subclass)
);

DROP TABLE IF EXISTS product_descriptions;
CREATE TABLE IF NOT EXISTS product_descriptions(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(255) NOT NULL,
    production_type_id BIGINT UNSIGNED NOT NULL,

    CONSTRAINT fk_product_descr_production_type_id
    FOREIGN KEY (production_type_id) REFERENCES production_types(id),

    UNIQUE index_of_descr_product_type (description, production_type_id)
);

DROP TABLE IF EXISTS product_compositions;
CREATE TABLE IF NOT EXISTS product_compositions(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    composition VARCHAR(255) NOT NULL UNIQUE
);
-- сделать парсинг составов, чтобы общая цифра была не больше 100%

DROP TABLE IF EXISTS production_facilities; -- список заводов и фабрик
CREATE TABLE IF NOT EXISTS production_facilities (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    facility_name VARCHAR(255) NOT NULL,
    fact_address VARCHAR(255) NOT NULL,
    fact_country_city_id BIGINT UNSIGNED NOT NULL,
    alias_suppl_id BIGINT UNSIGNED NOT NULL,
    `status` ENUM('Inspection', 'Approved', 'Rejected', 'To be reinspected', 'Reinspection') NOT NULL,
    status_updated_at TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    port_of_loading_id INT UNSIGNED NOT NULL,
    comments TEXT DEFAULT NULL,

    -- добавить триггер на сверку порта в фабрике с портом в контракте (IN)
    -- потом добавить rejected_info в виде json словаря, который аккумулирует данные по отброковкам:
    -- тип производства-кол-во отбраковок в штуках (инфа подтягивается триггером)
    -- сделать процедуру на определение реинспекции фабрики по сроку последней инспекции
    CONSTRAINT fk_prod_facil_fact_country_city_id
    FOREIGN KEY (fact_country_city_id) REFERENCES country_cities (id),

    CONSTRAINT fk_prod_facil_port_of_loading_id
    FOREIGN KEY (port_of_loading_id) REFERENCES ports_of_loading(id),

    CONSTRAINT fk_prod_facil_alias_suppl_id
    FOREIGN KEY (alias_suppl_id) REFERENCES alias_suppliers(id),

    KEY index_of_facility_name (facility_name),
    KEY index_of_fact_country_city_id (fact_country_city_id),
    KEY index_of_alias_suppl_id (alias_suppl_id),
    KEY index_of_status (`status`)
);
-- данная таблица фиксирует типы доступных производств на определнных фабриках
DROP TABLE IF EXISTS production_facilities_types;
CREATE TABLE IF NOT EXISTS production_facilities_types (
    production_facility_id BIGINT UNSIGNED NOT NULL,
    production_types_id BIGINT UNSIGNED NOT NULL,

    UNIQUE index_of_facility_production_type (production_facility_id,production_types_id),

    CONSTRAINT fk_prod_fac_type_prod_facility_id FOREIGN KEY (production_facility_id) REFERENCES production_facilities(id),
    CONSTRAINT fk_prod_fac_type_prod_type_id FOREIGN KEY (production_types_id) REFERENCES production_types(id)
);

DROP TABLE IF EXISTS currencies;
CREATE TABLE IF NOT EXISTS currencies(
    id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name_acronym CHAR (5) NOT NULL
);

DROP TABLE IF EXISTS currency_exchange_rates;
CREATE TABLE IF NOT EXISTS currency_exchange_rates(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    from_currency_id TINYINT UNSIGNED NOT NULL,
    to_currency_id TINYINT UNSIGNED NOT NULL,
    rate_value DECIMAL(10,4),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_curr_exch_rates_from_currency_id
    FOREIGN KEY (from_currency_id)
    REFERENCES currencies(id),

    CONSTRAINT fk_curr_exch_rates_to_currency_id
    FOREIGN KEY (to_currency_id)
    REFERENCES currencies(id),

    KEY index_of_currency_pair (from_currency_id,to_currency_id),
    KEY index_of_created_at (created_at),
    KEY index_of_rate_value (rate_value)

    -- добавить ограничение на обновление самого курса через триггер
);

DROP TABLE IF EXISTS collections;
CREATE TABLE IF NOT EXISTS collections(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name CHAR(4) NOT NULL UNIQUE
);

DROP TABLE IF EXISTS delivery_basis;
CREATE TABLE IF NOT EXISTS delivery_basis(
    id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name CHAR(4) NOT NULL
    --  думаю индексирование делать не обязательно, т.к. таблица не будет большой
);
DROP TABLE IF EXISTS payment_modes;
CREATE TABLE IF NOT EXISTS payment_modes(
    id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name ENUM('T/T', 'L/C', 'mixed') NOT NULL
     --  думаю индексирование делать не обязательно, т.к. таблица не будет большой
);
DROP TABLE IF EXISTS payment_due_points;
CREATE TABLE IF NOT EXISTS payment_due_points (
    id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    due_points ENUM ('planned latest shipment', 'order allocation',
        'quality approval', 'actual shipment date',
        'planned delivery to final destination',
        'actual delivery to final destination')
);

DROP TABLE IF EXISTS payment_terms;
CREATE TABLE IF NOT EXISTS payment_terms(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    payment_due_point_id TINYINT UNSIGNED NOT NULL DEFAULT 1,
    advance_payment_val TINYINT UNSIGNED DEFAULT 0,
    before_shpmt_payment_val TINYINT UNSIGNED DEFAULT 0,
    postpayment_1_val TINYINT UNSIGNED DEFAULT 0,
    postpayment_2_val TINYINT UNSIGNED DEFAULT 0,
    lc_val TINYINT UNSIGNED DEFAULT 0,
    advance_payment_due_point_delta INT DEFAULT -100,
    before_shpmt_payment_due_point_delta INT DEFAULT -14,
    postpayment_1_due_point_delta INT DEFAULT 120,
    postpayment_2_due_point_delta INT DEFAULT NULL,
    -- прописать тригеры на проверку максимальных значений (не более 100 по все платежам)

    CONSTRAINT fk_payment_terms_due_point_id FOREIGN KEY (payment_due_point_id) REFERENCES payment_due_points(id)
);

DROP TABLE IF EXISTS destination_points;
CREATE TABLE IF NOT EXISTS destination_points(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    country_city_id BIGINT UNSIGNED NOT NULL,

    CONSTRAINT fk_destin_points_country_city_id FOREIGN KEY (country_city_id)
    REFERENCES country_cities(id)
);
DROP TABLE IF EXISTS transhipment_hubs;
CREATE TABLE IF NOT EXISTS transhipment_hubs(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    country_city_id BIGINT UNSIGNED NOT NULL,

    CONSTRAINT fk_trans_hubs_country_city_id FOREIGN KEY (country_city_id)
    REFERENCES country_cities(id)
);
DROP TABLE IF EXISTS transportation_modes;
CREATE TABLE IF NOT EXISTS transportation_modes(
    id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    trans_mode ENUM('sea', 'air', 'railway', 'truck', 'river')
);
--
DROP TABLE IF EXISTS transportation_routes;
CREATE TABLE IF NOT EXISTS transportation_routes(
-- указать транзитки, подтягивать по коллекции
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    port_of_loading_id INT UNSIGNED NOT NULL COMMENT 'Точка отгрузки',
    trans_hub_id INT UNSIGNED DEFAULT NULL,                --  --можно оставить пустым, т.к. точки перегрузки товара в маршруте может и не быть
    from_port_to_hub_trans_mode_id TINYINT UNSIGNED DEFAULT NULL,
    from_hub_to_dest_point_trans_mode_id TINYINT UNSIGNED DEFAULT NULL,
    from_port_to_dest_point_trans_mode_id TINYINT UNSIGNED DEFAULT NULL,
    destination_point_id BIGINT UNSIGNED NOT NULL,
    collection_id BIGINT UNSIGNED NOT NULL,
    transit_time INT UNSIGNED NOT NULL DEFAULT 60,

    KEY index_of_transit_time (transit_time),
    UNIQUE index_of_trans_routes (collection_id,port_of_loading_id,trans_hub_id,destination_point_id),

    CONSTRAINT fk_trans_routes_pol_id FOREIGN KEY (port_of_loading_id) REFERENCES ports_of_loading(id),
    CONSTRAINT fk_trans_routes_trans_hub_id FOREIGN KEY (trans_hub_id) REFERENCES transhipment_hubs(id),

    CONSTRAINT fk_trans_routes_from_port_to_hub_trans_mode_id FOREIGN KEY (from_port_to_hub_trans_mode_id)
    REFERENCES transportation_modes(id),

    CONSTRAINT fk_trans_routes_from_hub_to_dest_point_trans_mode_id FOREIGN KEY (from_hub_to_dest_point_trans_mode_id)
    REFERENCES transportation_modes(id),

    CONSTRAINT fk_trans_routes_from_port_to_dest_point_trans_mode_id FOREIGN KEY (from_port_to_dest_point_trans_mode_id)
    REFERENCES transportation_modes(id),

    CONSTRAINT fk_trans_routes_destination_point_id FOREIGN KEY (destination_point_id) REFERENCES destination_points(id),
    CONSTRAINT fk_trans_routes_collection_id FOREIGN KEY (collection_id) REFERENCES collections(id)

    -- при создании SCM ERP надо передалть ТТ по каждой точке
);

DROP TABLE IF EXISTS contracts; --  контракты
CREATE TABLE IF NOT EXISTS contracts(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    buyer_leg_entity_id BIGINT UNSIGNED NOT NULL,
    supplier_leg_entity_id BIGINT UNSIGNED NOT NULL,
    contract_no VARCHAR(255) NOT NULL,
    collection_id BIGINT UNSIGNED NOT NULL,
    `status` ENUM('active','deactivated','on hold'),
    currency_id TINYINT UNSIGNED NOT NULL,
    ports_of_loading_id INT UNSIGNED NOT NULL,
    delivery_basis_id TINYINT UNSIGNED NOT NULL,
    payment_mode_id TINYINT UNSIGNED NOT NULL,
    payment_terms_id INT UNSIGNED NOT NULL,
    destination_points_id BIGINT UNSIGNED NOT NULL,
    vat TINYINT UNSIGNED DEFAULT NULL,
    transportation_routes_id INT UNSIGNED NOT NULL,

UNIQUE index_of_contract_no (contract_no),
KEY index_of_collection_id(collection_id),
KEY index_of_ports_of_loading_id(ports_of_loading_id),
KEY index_of_delivery_basis_id (delivery_basis_id),
KEY index_of_suppl_leg_entity_id_payment_terms_id (supplier_leg_entity_id,payment_terms_id,payment_mode_id),

CONSTRAINT fk_contracts_buyer_leg_entity_id FOREIGN KEY (buyer_leg_entity_id) REFERENCES buyers_leg_entities(id),
CONSTRAINT fk_contracts_supplier_leg_entity_id FOREIGN KEY (supplier_leg_entity_id) REFERENCES suppliers_leg_entities(id),
CONSTRAINT fk_contracts_collection_id FOREIGN KEY (collection_id) REFERENCES collections(id),
CONSTRAINT fk_contracts_currency_id FOREIGN KEY (currency_id) REFERENCES currencies(id),
CONSTRAINT fk_contracts_pol_id FOREIGN KEY (ports_of_loading_id) REFERENCES ports_of_loading(id),
CONSTRAINT fk_contracts_delivery_basis_id FOREIGN KEY (delivery_basis_id) REFERENCES delivery_basis(id),
CONSTRAINT fk_contract_payment_mode_id FOREIGN KEY (payment_mode_id) REFERENCES payment_modes(id),
CONSTRAINT fk_contracts_payment_terms_id FOREIGN KEY (payment_terms_id) REFERENCES payment_terms(id),
CONSTRAINT fk_contracts_dest_points_id FOREIGN KEY (destination_points_id) REFERENCES destination_points(id),
CONSTRAINT fk_contracts_trans_routes_id FOREIGN KEY (transportation_routes_id) REFERENCES transportation_routes(id)
);

DROP TABLE IF EXISTS bank_details_status; -- платежные реквизиты
CREATE TABLE IF NOT EXISTS bank_details_status(
    id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name ENUM('active', 'deactivated') NOT NULL
);

DROP TABLE IF EXISTS bank_details; -- платежные реквизиты
CREATE TABLE IF NOT EXISTS bank_details(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    contract_id BIGINT UNSIGNED NOT NULL,
    beneficiary VARCHAR(255) NOT NULL,
    benefic_address VARCHAR(255) NOT NULL,
    benefic_country_city_id BIGINT UNSIGNED NOT NULL,
    bank_name VARCHAR(255) NOT NULL,
    bank_address VARCHAR(255) NOT NULL,
    bank_country_city_id BIGINT UNSIGNED NOT NULL,
    account_no TINYINT UNSIGNED NOT NULL,
    corresp_account_no TINYINT UNSIGNED NOT NULL,
    swift CHAR DEFAULT NULL,
    status_id TINYINT UNSIGNED NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON update CURRENT_TIMESTAMP,
    -- потом добавить updated_by, created_by

    CONSTRAINT fk_bank_details_contract_id FOREIGN KEY (contract_id) REFERENCES contracts(id),
    CONSTRAINT fk_bank_details_benefic_country_cities_id FOREIGN KEY (benefic_country_city_id) REFERENCES country_cities(id),
    CONSTRAINT fk_bank_details_bank_country_cities_id FOREIGN KEY (bank_country_city_id) REFERENCES country_cities(id),
    CONSTRAINT fk_bank_details_status_id FOREIGN KEY (status_id) REFERENCES bank_details_status(id),
    KEY index_of_contract_id_wh_status (contract_id,status_id)
);

DROP TABLE IF EXISTS media_types;
CREATE TABLE IF NOT EXISTS media_types(
    id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    type_name ENUM ('photo','video','file') NOT NULL
);

DROP TABLE IF EXISTS media;
CREATE TABLE IF NOT EXISTS media(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    media_type_id TINYINT UNSIGNED NOT NULL,
    `filename` VARCHAR(255) NOT NULL UNIQUE,
    size INT UNSIGNED DEFAULT NULL,
    metadata JSON DEFAULT NULL,
    contract_id BIGINT UNSIGNED DEFAULT NULL,
    factory_id BIGINT UNSIGNED DEFAULT NULL,
    suppl_leg_entity_id BIGINT UNSIGNED DEFAULT NULL,
    alias_suppl_id BIGINT UNSIGNED NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    KEY index_of_media_type_id (media_type_id),
    KEY index_of_contract_id (contract_id),
    KEY index_of_factory_id (factory_id),
    KEY index_of_suppl_leg_entity_id (suppl_leg_entity_id),
    KEY index_of_alias_suppl_id (alias_suppl_id),

    CONSTRAINT fk_media_media_type_id FOREIGN KEY (media_type_id) REFERENCES media_types(id),
    CONSTRAINT fk_media_contract_id FOREIGN KEY (contract_id) REFERENCES contracts(id),
    CONSTRAINT fk_media_factory_id FOREIGN KEY (factory_id) REFERENCES production_facilities(id),
    CONSTRAINT fk_media_suppl_leg_entity_id FOREIGN KEY (suppl_leg_entity_id) REFERENCES suppliers_leg_entities(id),
    CONSTRAINT fk_media_alias_suppl_id FOREIGN KEY (alias_suppl_id) REFERENCES alias_suppliers(id)
);

DROP TABLE IF EXISTS delivery_instores;
CREATE TABLE IF NOT EXISTS delivery_instores(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    collection_id BIGINT UNSIGNED NOT NULL,
    delivery_no TINYINT UNSIGNED NOT NULL, -- все отгрузки в рамках сезона бьются на поставки для обеспечения такта поставок
    instore TIMESTAMP NOT NULL, -- плановая крайняя дата доставки на полки, от нее обратным счетом считаются все остальные контрольные точки в цепи поставки товара

    UNIQUE index_of_coll_del_instore (collection_id, delivery_no, instore),
    CONSTRAINT fk_deliv_instores_id FOREIGN KEY (collection_id) REFERENCES collections(id)
);


--  таблица с продукцией
DROP TABLE IF EXISTS product_styles;
CREATE TABLE IF NOT EXISTS product_styles(
    style_no INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    collection_no_id BIGINT UNSIGNED NOT NULL,
    supplier_alias_id BIGINT UNSIGNED NOT NULL,
    price_value DECIMAL (7,2) UNSIGNED NOT NULL,
    price_currency_id TINYINT UNSIGNED NOT NULL,
    ordered_qty INT UNSIGNED DEFAULT 0,
    production_type_id BIGINT UNSIGNED NOT NULL,
    product_description_id BIGINT UNSIGNED NOT NULL,
    product_composition_id BIGINT UNSIGNED NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL UNIQUE,
    delivery_instore_id BIGINT UNSIGNED NOT NULL,
    production_facility_id BIGINT UNSIGNED NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    -- created_by
    -- updated_by
    CONSTRAINT fk_product_styles_collection_no_id FOREIGN KEY (collection_no_id) REFERENCES collections(id),
    CONSTRAINT fk_product_styles_supplier_alias_id FOREIGN KEY (supplier_alias_id) REFERENCES alias_suppliers(id),
    CONSTRAINT fk_product_styles_price_currency_id FOREIGN KEY (price_currency_id) REFERENCES currencies(id),
    CONSTRAINT fk_product_styles_production_type_id FOREIGN KEY (production_type_id) REFERENCES production_types(id),
    CONSTRAINT fk_product_styles_product_descr_id FOREIGN KEY (product_description_id) REFERENCES product_descriptions(id),
    CONSTRAINT fk_product_styles_product_compo_id FOREIGN KEY (product_composition_id) REFERENCES product_compositions(id),
    CONSTRAINT fk_product_styles_media_id FOREIGN KEY (media_id) REFERENCES media(id),

    CONSTRAINT fk_product_styles_delivery_instore_id
    FOREIGN KEY (delivery_instore_id) REFERENCES delivery_instores(id),

    CONSTRAINT fk_product_styles_production_facility_id
    FOREIGN KEY (production_facility_id) REFERENCES production_facilities(id)
);


DROP TABLE IF EXISTS orders;
CREATE TABLE IF NOT EXISTS orders(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    collection_no_id BIGINT UNSIGNED NOT NULL, -- fk collections
    supplier_alias_id BIGINT UNSIGNED NOT NULL, -- fk alias_suppliers
    supplier_leg_entity_id BIGINT UNSIGNED NOT NULL,-- fk suppliers_leg_entities.id
    buyer_alias BIGINT UNSIGNED NOT NULL,-- fk alias_buyers.id
    buyer_leg_entity_id BIGINT UNSIGNED NOT NULL, -- fk buyers_leg_entities.id
    contract_no_id BIGINT UNSIGNED NOT NULL, -- fk contracts.id
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- created_by

    KEY index_of_collection_suppl_alias_contract (collection_no_id, supplier_alias_id, contract_no_id),
    KEY index_of_suppl_alias (supplier_alias_id),

    CONSTRAINT fk_orders_collection_no_id FOREIGN KEY (collection_no_id) REFERENCES collections(id),
    CONSTRAINT fk_orders_supplier_alias_id FOREIGN KEY (supplier_alias_id) REFERENCES alias_suppliers(id),
    CONSTRAINT fk_orders_supplier_leg_entity_id FOREIGN KEY (supplier_leg_entity_id) REFERENCES suppliers_leg_entities(id),
    CONSTRAINT fk_orders_buyer_alias FOREIGN KEY (buyer_alias) REFERENCES alias_buyers(id),
    CONSTRAINT fk_orders_buyer_leg_entity_id FOREIGN KEY (buyer_leg_entity_id) REFERENCES buyers_leg_entities(id),
    CONSTRAINT fk_orders_contract_no_id FOREIGN KEY (contract_no_id) REFERENCES contracts(id)

);
--  добавить триггер на сумму заказа
DROP TABLE IF EXISTS orders_products;
CREATE TABLE IF NOT EXISTS orders_products(
    order_id BIGINT UNSIGNED NOT NULL,
    style_no_id INT UNSIGNED NOT NULL,
    order_amount DECIMAL(12,2) UNSIGNED,  --  сумму заказа записываем сюда, т.к. зачастую сумма нужна закупочной, а не продуктовой команде
    order_currency_id TINYINT UNSIGNED NOT NULL,
    UNIQUE (order_id, style_no_id),
    KEY index_orders_products_order_amount (order_amount),
    KEY index_orders_products_order_id_currency_id (order_id, order_currency_id), -- условия джойнов в эту таблицу будут в основном именно на эти два столбца

    CONSTRAINT fk_orders_products_order_id FOREIGN KEY (order_id) REFERENCES orders(id),
    CONSTRAINT fk_orders_products_style_no_id FOREIGN KEY (style_no_id) REFERENCES product_styles(style_no),
    CONSTRAINT fk_orders_products_order_currency_id FOREIGN KEY(order_currency_id) REFERENCES product_styles(price_currency_id)
);

DROP TABLE IF EXISTS payments;
CREATE TABLE IF NOT EXISTS payments(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    payment_type ENUM ('advance payment', 'before shipment', 'postpayment_1', 'postpayment_2', 'lc'),
    order_id BIGINT UNSIGNED NOT NULL, -- fk
    payment_amount_suggested DECIMAL(12,2) UNSIGNED,
    payment_amount_user DECIMAL(12,2) UNSIGNED,
    status ENUM ('created', 'approved', 'remitted', 'cancelled'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    KEY index_of_payments (order_id, status, payment_amount_user),
    CONSTRAINT fk_payments_order_id FOREIGN KEY (order_id) REFERENCES orders(id)
    -- trigger to check status amendment
    -- trigger to restrict deletion and update
    -- trigger to check payment amount vs balance
);

-- чеки на значения
-- триггеры



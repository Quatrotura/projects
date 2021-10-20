--  узнать у какого поставщика более одного юрлица:
SELECT alias.alias_suppl_name, COUNT(legal.entity_name) AS number_of_entities_per_alias
FROM alias_suppliers AS alias LEFT JOIN suppliers_leg_entities AS legal ON alias.id = legal.entity_alias_id
GROUP BY 1 HAVING number_of_entities_per_alias > 1
ORDER BY 1;

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

-- или так (по левому джойну в названиях юрлиц будет null там где юрлицо не заведено:
SELECT alias.alias_suppl_name, legal.entity_name
FROM alias_suppliers AS alias LEFT JOIN suppliers_leg_entities AS legal ON alias.id = legal.entity_alias_id
WHERE legal.entity_name is NULL;

-- узнать у каких поставщиков фактическая страна нахождения отличается от страны, где зарегистрировано юр лицо поставщика, с выводом названия стран к обеим таблицам:
SELECT alias.alias_suppl_name, leg.entity_name, geo.country AS legal_entity_reg_country, geo_2.country AS alias_fact_country
FROM suppliers_leg_entities leg
JOIN alias_suppliers alias ON (leg.entity_alias_id = alias.id) AND (leg.entity_reg_country_city_id != alias.alias_suppl_country_city_id)
JOIN country_cities geo ON leg.entity_reg_country_city_id = geo.id
JOIN country_cities geo_2 ON alias.alias_suppl_country_city_id = geo_2.id;

--  узнать у каких поставщиков не заведены в систему фабрики:
SELECT alias.alias_suppl_name, alias.id, COUNT(factory.id) AS factory_qty
FROM production_facilities factory RIGHT JOIN alias_suppliers alias ON factory.alias_suppl_id = alias.id
GROUP BY 1 HAVING factory_qty = 0
ORDER BY 2;

-- вывести общую информацию по заказам поставщикам, с которыми не подписан или расторжен договор:
SELECT op.style_no_id, c2.name_acronym contract_currency, alias.alias_suppl_name supplier_name, c.contract_no, c.status contract_status, SUM(op.order_amount) as order_amount
FROM orders_products op
JOIN orders ON op.order_id = orders.id
JOIN contracts c on orders.contract_no_id = c.id
JOIN suppliers_leg_entities sle on c.supplier_leg_entity_id = sle.id
JOIN alias_suppliers alias on sle.entity_alias_id = alias.id
JOIN currencies c2 on c.currency_id = c2.id
WHERE c.status != 'active' or c.status IS NULL
GROUP BY 1, 2, 3, 4, 5;

-- узнать общую сумму заказов по валютам платежа:

SELECT c2.name_acronym contract_currency, SUM(op.order_amount) as order_amount
FROM orders_products op
RIGHT JOIN orders ON op.order_id = orders.id
RIGHT JOIN contracts c on orders.contract_no_id = c.id
RIGHT JOIN currencies c2 on c.currency_id = c2.id
GROUP BY 1
ORDER BY 2 DESC;


-- допустим пользователь хочет вывести список неподтвержденных фабрик и понять что с ними не так(прочитать комментарии)
SELECT alias.alias_suppl_name, factory.facility_name, factory.status, factory.comments
FROM alias_suppliers alias JOIN production_facilities factory ON alias.id = factory.alias_suppl_id AND factory.status != 'Approved'
ORDER BY 4;

-- допустим пользователю необходимо сделать выборку подтвержденных фабрик, инспекция которых была более двух лет назад
SELECT alias.alias_suppl_name, factory.id,factory.facility_name, factory.status, factory.status_updated_at, (SELECT TIMESTAMPDIFF(YEAR, factory.status_updated_at, CURRENT_DATE)) AS years_to_last_inspection
FROM alias_suppliers alias JOIN production_facilities factory ON alias.id = factory.alias_suppl_id AND factory.status = 'Approved'
	AND factory.status_updated_at < CURRENT_DATE - INTERVAL 2 YEAR
ORDER BY 1;

-- можно сделать обновление статуса по вышеуказанной выборке:
UPDATE production_facilities factory
SET factory.status = 'To be reinspected', factory.comments = 'Factories were inspected more than two years ago. Got to be re-inspected shortly.'
WHERE factory.status_updated_at < CURRENT_DATE - INTERVAL 2 YEAR;

-- узнаем кто что производит и по каким производственным группам вообще нет поставщиков/производителей
SELECT pt.class, pt.subclass, alias.alias_suppl_name as supplier_name, c.status as contract_status,pf.facility_name as factory_name, pf.status as factory_status
FROM production_types pt LEFT JOIN production_facilities_types pft on pt.id = pft.production_types_id
LEFT JOIN production_facilities pf on pft.production_facility_id = pf.id
LEFT JOIN alias_suppliers alias on pf.alias_suppl_id = alias.id
LEFT JOIN suppliers_leg_entities sle on alias.id = sle.entity_alias_id
LEFT JOIN contracts c on sle.id = c.supplier_leg_entity_id
-- можно ограничить выборку исключительно проблемными производственными группами, т.е. теми группами, продукцию которых негде производить по различными причинам:
-- WHERE alias.alias_suppl_name IS NULL OR c.status != 'active' OR c.status IS NULL OR pf.status != 'Approved' OR pf.status IS NULL
ORDER BY 1;


-- допустим нам надо узнать какой поставщик/фабрика сможет производить пуховики:
SELECT pt.class, pt.subclass, alias.alias_suppl_name, c.status contract_status, pf.facility_name, pf.status factory_status
FROM production_types pt
LEFT JOIN production_facilities_types pft ON pt.id = pft.production_types_id
LEFT JOIN production_facilities pf ON pft.production_facility_id = pf.id
LEFT JOIN alias_suppliers alias on pf.alias_suppl_id = alias.id
LEFT JOIN suppliers_leg_entities sle on alias.id = sle.entity_alias_id
LEFT JOIN contracts c on sle.id = c.supplier_leg_entity_id
WHERE pt.class = 'OUTERWEAR' AND pt.subclass = 'PADDED JACKETS';

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

-- перед созданием платежа можно посмотреть условия оплаты по всем заказам:

SELECT op.id, op.order_id, op.style_no_id, pt.advance_payment_val, pt.before_shpmt_payment_val, pt.postpayment_1_val, pt.postpayment_2_val
FROM orders_products op
JOIN orders o on op.order_id = o.id
JOIN contracts c on o.contract_no_id = c.id
JOIN payment_terms pt on c.payment_terms_id = pt.id
ORDER BY 2;

-- вывести результирующую таблицу с объединенными названиями маршрутов, видом транспорта и транзитным временем
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


-- вывести валюты платежей по поставщикам
SELECT alias.alias_suppl_name, cur.name_acronym, con.contract_no
FROM contracts con
RIGHT JOIN suppliers_leg_entities sle ON con.supplier_leg_entity_id = sle.id
RIGHT JOIN alias_suppliers alias ON alias.id = sle.entity_alias_id
RIGHT JOIN currencies cur ON con.currency_id = cur.id
ORDER BY 3 DESC;

-- допустим байер хочет закупить партию рубашек и ему надо узнать кому можно разместить заказ
-- по след критериям: поставщик производит рубашки, коллекция AW22, подписан договор, договор активный,
-- есть действующая фабрика,  варианты доставки в Москву не более 30 дней

SELECT pt.class, pt.subclass, alias.alias_suppl_name
FROM production_facilities_types pft
JOIN production_types pt ON pft.production_types_id = pt.id
JOIN production_facilities pf ON pft.production_facility_id = pf.id
JOIN alias_suppliers alias ON pf.alias_suppl_id = alias.id
JOIN suppliers_leg_entities sle on alias.id = sle.entity_alias_id
JOIN contracts c on sle.id = c.supplier_leg_entity_id
JOIN collections coll ON c.collection_id = coll.id
JOIN transportation_routes tr ON c.collection_id = tr.collection_id AND c.ports_of_loading_id = tr.port_of_loading_id
JOIN destination_points dp on tr.destination_point_id = dp.id
WHERE pt.subclass = 'SHIRTS' AND coll.name = 'AW22' AND c.status = 'active' AND pf.status = 'Approved'
AND tr.transit_time <= 40 AND dp.name = 'FDC Moscow'
GROUP BY 1, 2, 3;

-- вывести информацию по сумме заказов на поставщика и согласованным в контракте условиям оплаты.

SELECT alias_suppl_name, contr.contract_no, SUM(op.order_amount), c.name_acronym,
       pt.advance_payment_val,
       pt.before_shpmt_payment_val,
       pt.postpayment_1_val, pt.postpayment_2_val,
       pt.postpayment_1_due_point_delta, pt.postpayment_2_due_point_delta
FROM orders
JOIN contracts contr on orders.contract_no_id = contr.id
JOIN suppliers_leg_entities sle on contr.supplier_leg_entity_id = sle.id
JOIN alias_suppliers alias on sle.entity_alias_id = alias.id
JOIN currencies c on contr.currency_id = c.id
JOIN orders_products op on orders.id = op.order_id
JOIN payment_terms pt on contr.payment_terms_id = pt.id
GROUP BY 1,2;

-- информация по заказам и условию оплаты:
SELECT alias_suppl_name, contr.contract_no, op.style_no_id,SUM(op.order_amount), c.name_acronym,
       pt.advance_payment_val,
       pt.before_shpmt_payment_val,
       pt.postpayment_1_val, pt.postpayment_2_val,
       pt.postpayment_1_due_point_delta, pt.postpayment_2_due_point_delta
FROM orders
JOIN contracts contr on orders.contract_no_id = contr.id
JOIN suppliers_leg_entities sle on contr.supplier_leg_entity_id = sle.id
JOIN alias_suppliers alias on sle.entity_alias_id = alias.id
JOIN currencies c on contr.currency_id = c.id
JOIN orders_products op on orders.id = op.order_id
JOIN payment_terms pt on contr.payment_terms_id = pt.id
GROUP BY 1, 2, 3;

-- вывести информацию по моделям, сумме заказов, оплаченной сумме и балансового платежа
SELECT op.style_no_id, SUM(DISTINCT op.order_amount) as ordered_amount, SUM(p.payment_amount_suggested) as paid_amount,
      (SELECT SUM(DISTINCT op.order_amount) - SUM(p.payment_amount_suggested)) AS balanced_payment_amount
FROM payments p
RIGHT JOIN orders_products op ON p.orders_products_id = op.id
-- если инфа нужна только по проведенным платежам
-- WHERE p.status = 'remitted' OR p.status = 'approved'
GROUP BY 1 with rollup
ORDER BY 4;

-- график отгрузок по заказам
SELECT op.style_no_id, di.delivery_no, tr.transit_time, di.instore, (SELECT DATE_SUB(di.instore, INTERVAL 14 DAY)) AS delivery_to_stores,
       (SELECT DATE_SUB(di.instore, INTERVAL (14+tr.transit_time) DAY)) AS latest_shipment_fm_supplier
FROM orders_products op
JOIN product_styles ps on op.style_no_id = ps.style_no
JOIN transportation_routes tr on op.transportation_route_id = tr.id
JOIN delivery_instores di on ps.delivery_instore_id = di.id;

-- представление возвращает сумму, которую осталось заплатить за ту или иную заказанную(!) модель
CREATE OR REPLACE VIEW balance_amount_for_payment AS
    SELECT op.style_no_id AS style_number, SUM(DISTINCT op.order_amount) AS ordered_amount, SUM(p.payment_amount_suggested) AS paid_amount,
    (SELECT SUM(DISTINCT op.order_amount) - SUM(p.payment_amount_suggested)) AS balance_amount FROM payments p
    RIGHT JOIN orders_products op ON p.orders_products_id = op.id
    WHERE p.status = 'remitted' OR p.status = 'approved'
    GROUP BY 1 with rollup
    ORDER BY 4;

-- представление возвращает общую результирующую таблицу со всей информацией об имеющихся маршрутах доставки
CREATE OR REPLACE VIEW transit_routes_times AS
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


-- процедура обновляет статус фабрики на "необходимо проинспектировать", если текущий статус фабрики устанавливался last_inspection лет назад
-- и если у фабрики текущий статус current_factory_status
-- процедура также сообщает пользователю статус каких именно фабрик был обновлен
DELIMITER //
DROP PROCEDURE IF EXISTS update_old_factory_status //
CREATE PROCEDURE update_old_factory_status (last_inspection INT, current_factory_status VARCHAR(50))
BEGIN
    SELECT CONCAT('The status of the following factories has been changed to "To be reinspected": ', factory.facility_name)
    FROM production_facilities factory
    WHERE factory.status = current_factory_status AND factory.status_updated_at < CURRENT_DATE - INTERVAL last_inspection YEAR;

    UPDATE production_facilities factory
    SET factory.status = 'To be reinspected', factory.comments = 'Factories were inspected more than two years ago. Got to be re-inspected shortly.'
    WHERE factory.status = current_factory_status AND factory.status_updated_at < CURRENT_DATE - INTERVAL last_inspection YEAR;
END //

-- CALL update_old_factory_status(2,'Approved');

-- функция определяет срок отгрузки относительно аргумента delivery_number и значения transit_time выбранного маршрута определенной коллекции
DELIMITER //
DROP FUNCTION IF EXISTS get_planned_shipment //
CREATE FUNCTION get_planned_shipment (delivery_number TINYINT, trans_route_id INT, collection_name CHAR(4))
RETURNS TIMESTAMP DETERMINISTIC
BEGIN
    DECLARE instore TIMESTAMP;
    DECLARE coll_id BIGINT;
    DECLARE delivery_time INT;
    DECLARE calculated_planned_spmnt TIMESTAMP;
    SET coll_id = (SELECT id FROM collections WHERE name = collection_name);
    SET instore = (SELECT di.instore FROM delivery_instores di WHERE di.delivery_no = delivery_number AND di.collection_id = coll_id);
    SET delivery_time = (SELECT tr.transit_time FROM transportation_routes tr WHERE tr.id = trans_route_id);
    SET calculated_planned_spmnt = DATE_SUB(instore, INTERVAL (delivery_time+14) DAY);

    RETURN calculated_planned_spmnt;

END //

DELIMITER ;
-- вызываем представление для понимания какой айди маршрута надо указывать
-- SELECT * FROM transit_routes_times;
-- вызываем функцию:
-- SELECT get_planned_shipment(3, 5, 'AW22');


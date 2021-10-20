
DELIMITER //
DROP TRIGGER IF EXISTS calc_amount //
-- данный триггер проверяет соответствие установленного поставщика на модели поставщику на заказе
-- если поставщики сходятся, то триггер калькулирует и вставляет сумму заказа
-- если не сходятся инсерт не выполняется и триггер возвращает пользователю соответстующее сообщение
CREATE TRIGGER check_insert_calc_amount BEFORE INSERT ON orders_products
FOR EACH ROW
BEGIN
    DECLARE alias_id_from_product_styles BIGINT UNSIGNED;
    DECLARE alias_id_from_order BIGINT UNSIGNED;

    SET alias_id_from_product_styles = (SELECT prod_st.supplier_alias_id
                                        FROM product_styles prod_st WHERE NEW.style_no_id = prod_st.style_no);
    SET alias_id_from_order = (SELECT alias.id
                                FROM orders
                                JOIN contracts con ON orders.contract_no_id = con.id
                                JOIN suppliers_leg_entities sle on con.supplier_leg_entity_id = sle.id
                                JOIN alias_suppliers alias on sle.entity_alias_id = alias.id
                                WHERE orders.id = NEW.order_id);
    IF alias_id_from_product_styles = alias_id_from_order
        THEN
            SET NEW.order_amount =
                (SELECT ps.price_value FROM product_styles AS ps WHERE ps.style_no = NEW.style_no_id LIMIT 1) *
                (SELECT ps.ordered_qty FROM product_styles AS ps WHERE ps.style_no = NEW.style_no_id LIMIT 1) *
                (NEW.qty_share_to_ship_by_route / 100);
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Alias of supplier id set in style does not match alias of supplier set in contract assigned to selected order number.';
    END IF;
END //

-- данный триггер:
-- 1) целостность добавляемых в payments данные (пользователь может создать только тот платеж, который предусмотрен договором)
-- 2) считает сумму к оплате в соответствии с предусмотреннымы договором условиями оплаты

DELIMITER //
DROP TRIGGER IF EXISTS calc_check_payment //
CREATE TRIGGER calc_check_payment BEFORE INSERT ON payments
FOR EACH ROW
BEGIN
    DECLARE p_type VARCHAR(255);
    DECLARE amount_share_for_payment INT;
    DECLARE order_calc_amount DECIMAL(12,2) DEFAULT 0;
    SET p_type = NEW.payment_type;
    SET order_calc_amount = (SELECT sum(op.order_amount)
                            FROM orders_products op WHERE op.id = NEW.orders_products_id);
    CASE p_type
        WHEN 'advance payment' THEN
        SET amount_share_for_payment = (SELECT pt.advance_payment_val FROM orders_products op
                                        JOIN orders o ON op.order_id = o.id
                                        JOIN contracts con ON o.contract_no_id = con.id
                                        JOIN payment_terms pt ON con.payment_terms_id = pt.id
                                        WHERE op.id = NEW.orders_products_id);

        WHEN 'before shipment' THEN
        SET amount_share_for_payment = (SELECT pt.before_shpmt_payment_val FROM orders_products op
                                        JOIN orders o ON op.order_id = o.id
                                        JOIN contracts con ON o.contract_no_id = con.id
                                        JOIN payment_terms pt ON con.payment_terms_id = pt.id
                                        WHERE op.id = NEW.orders_products_id);
        WHEN 'postpayment_1' THEN
        SET amount_share_for_payment = (SELECT pt.postpayment_1_val FROM orders_products op
                                        JOIN orders o ON op.order_id = o.id
                                        JOIN contracts con ON o.contract_no_id = con.id
                                        JOIN payment_terms pt ON con.payment_terms_id = pt.id
                                        WHERE op.id = NEW.orders_products_id);
        WHEN 'postpayment_2' THEN
        SET amount_share_for_payment = (SELECT pt.postpayment_2_val FROM orders_products op
                                        JOIN orders o ON op.order_id = o.id
                                        JOIN contracts con ON o.contract_no_id = con.id
                                        JOIN payment_terms pt ON con.payment_terms_id = pt.id
                                        WHERE op.id = NEW.orders_products_id);
    END CASE;
    IF amount_share_for_payment != 0 OR amount_share_for_payment IS NOT NULL THEN
        SET NEW.payment_amount_suggested = order_calc_amount * (amount_share_for_payment/100);
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This type of payment is not stipulated by the contract payment terms.';
    END IF;
END //

DELIMITER //

-- тригер на проверку остаточной суммы к оплате при добавлении очередного платежа (чтобы не было переплаты за тот или иной заказ)
DROP TRIGGER IF EXISTS check_style_payment_account //
CREATE TRIGGER check_style_payment_account BEFORE INSERT ON payments
    FOR EACH ROW
    BEGIN
        DECLARE order_amount DECIMAL(12,2) DEFAULT 0;
        DECLARE already_paid DECIMAL(12,2) DEFAULT 0;

        SET order_amount = (SELECT sum(op.order_amount)
                            FROM orders_products op WHERE op.id = NEW.orders_products_id);
        SET already_paid = (SELECT SUM(payment_amount_suggested)
                            FROM payments WHERE orders_products_id = NEW.orders_products_id);
        IF order_amount - already_paid <= 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This style under indicated order has been fully paid to supplier.';
        END IF;
    END //

DELIMITER ;


---- 1. На каждую дату покупки показать ФИО покупателей и названия компаний-поставщиков.

--SELECT DISTINCT
--	p.Date AS 'Дата',
--    CONCAT(pu.F_purchaser, ' ', pu.I_purchaser, ' ', pu.O_purchaser) AS 'ФИО покупателя',
--    d.Name_company AS 'Поставщик'
--	FROM Purchase p
--	JOIN Purchaser pu ON p.ID_purchaser = pu.ID_purchaser
--	JOIN Delivery d ON p.ID_delivery = d.ID_delivery


---- 2. Вывести состав покупки с минимальной ценой.

--SELECT o.ID, o.ID_purchase, o.ID_product, o.Count_product
--FROM Order_Items o
--WHERE o.ID_purchase = (
--    SELECT TOP 1 ID_purchase 
--    FROM Purchase 
--    ORDER BY Cost ASC
--);


---- 3. Изменить рейтинг покупателя на 0.12, если значение поля является пустым, и у него есть оптовая покупка.
--UPDATE Purchaser
--SET rating = 0.12
--WHERE 
--    rating IS NULL
--    AND EXISTS (
--        SELECT 1
--        FROM Purchase p
--        WHERE 
--            p.ID_purchaser = Purchaser.ID_purchaser
--            AND p.Type = 'False'  --  оптовая покупка
--    );


---- 4. Показать количество покупок по городам покупателей.

--SELECT DISTINCT pur.City, COUNT(p.ID_purchase) AS Count
--FROM Purchase p
--JOIN Purchaser pur ON p.ID_purchaser = pur.ID_purchaser
--GROUP BY pur.City


---- 5. Показать ФИО покупателей, у которых более двух видов товаров в одной покупке.

--SELECT DISTINCT CONCAT(pu.F_purchaser, ' ', pu.I_purchaser, ' ', pu.O_purchaser) AS 'ФИО покупателя'
--FROM Purchaser pu
--WHERE EXISTS (
--    SELECT 1
--    FROM Purchase p
--    JOIN Order_Items o ON p.ID_purchase = o.ID_purchase
--    WHERE p.ID_purchaser = pu.ID_purchaser
--    GROUP BY p.ID_purchase
--    HAVING COUNT(DISTINCT o.ID_product) > 2
--);


-- 6. Представление должно показывать названия компаний-поставщиков из Уфы, у которых нет розничных продаж.

--CREATE VIEW View1 AS
--SELECT d.Name_company AS 'Компания-поставщик'
--FROM Delivery d
--WHERE 
--    d.City = 'Уфа'
--    AND NOT EXISTS (
--        SELECT 1
--        FROM Purchase p
--        WHERE p.ID_delivery = d.ID_delivery
--        AND p.Type = 'True'  -- розничные продажи
--    );


-- 7. Хранимая процедура с параметром должна показывать среднее значение комиссионных компаний-поставщиков из заданного города.

--CREATE PROCEDURE Procedure1
--    @City VARCHAR(50)
--AS
--BEGIN
--    SELECT AVG(Comis) 
--    FROM Delivery
--    WHERE City = @City;
--END;


-- 8. Триггер при модификации таблицы «Покупатель» должен проверять условие: значение рейтинга покупателя не должно быть больше 95.

--CREATE TRIGGER Trigger1
--ON Purchaser
--AFTER INSERT, UPDATE
--AS
--BEGIN
--	IF EXISTS
--	(SELECT 1
--	FROM inserted i
--	WHERE rating > 95)
--	BEGIN
--		RAISERROR('Рейтинг покупателя не должен превышать 95', 16, 1);
--      ROLLBACK TRANSACTION;
--	END;
--END;
USE publishing;

-- UPDATE: меняем страну автора
UPDATE Authors SET Country = 'Germany' WHERE AuthorID = 10;

-- UPDATE: меняем статус заказа
UPDATE Orders SET Status = 'InProgress' WHERE OrderID = 1;

-- UPDATE: меняем цену
UPDATE OrderItem SET UnitPrice = 55.00 WHERE OrderItemID = 1;

-- DELETE: удаляем сначала позицию заказа, потом сам заказ
DELETE FROM OrderItem WHERE OrderID = 10;
DELETE FROM Orders WHERE OrderID = 10;

-- SELECT: все авторы
SELECT * FROM Authors;

-- SELECT: книги после 2022
SELECT Title, Genre, PublishYear FROM Books WHERE PublishYear > 2022;

-- SELECT: завершённые заказы
SELECT * FROM Orders WHERE Status = 'Completed';
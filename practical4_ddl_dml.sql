-- Практична робота 4: DDL та DML команди
-- База даних: publishing

USE publishing;

-- ======= DDL: Створення таблиць =======
-- (виконано в окремому скрипті, всі 8 таблиць створені)

-- ======= DML: INSERT =======
-- (10 записів у кожну таблицю — виконано)

-- ======= DML: UPDATE =======
SET SQL_SAFE_UPDATES = 0;

UPDATE Orders
SET Status = 'Completed'
WHERE ClientName = 'DataWorks AG';

-- Перевірка
SELECT OrderID, ClientName, Status FROM Orders;

-- ======= DML: DELETE =======
DELETE FROM Orders
WHERE Status = 'Canceled';

-- Перевірка
SELECT OrderID, ClientName, Status FROM Orders;

-- ======= DML: SELECT + GROUP BY =======
SELECT Genre, COUNT(*) AS BooksCount
FROM Books
GROUP BY Genre
ORDER BY BooksCount DESC;

-- ======= DML: JOIN =======
-- Автори та їхні книги
SELECT a.Name AS Author, b.Title AS Book, b.Genre
FROM Authors a
JOIN AuthorBook ab ON a.AuthorID = ab.AuthorID
JOIN Books b ON b.BookID = ab.BookID
ORDER BY a.Name;

-- Замовлення з деталями та сумою
SELECT o.ClientName, b.Title,
       oi.Quantity, oi.UnitPrice,
       (oi.Quantity * oi.UnitPrice) AS Total
FROM Orders o
JOIN OrderItem oi ON oi.OrderID = o.OrderID
JOIN Books b ON b.BookID = oi.BookID
ORDER BY o.ClientName;

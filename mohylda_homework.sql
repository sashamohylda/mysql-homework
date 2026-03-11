USE publishing;

-- Авторы и их книги
SELECT a.Name AS Автор, b.Title AS Книга, b.PublishYear
FROM Authors a
JOIN AuthorBook ab ON a.AuthorID = ab.AuthorID
JOIN Books b ON ab.BookID = b.BookID;

-- Сотрудники и их задачи
SELECT e.Name AS Співробітник, e.Role, b.Title AS Книга, eb.Task
FROM Employees e
JOIN EmployeeBook eb ON e.EmployeeID = eb.EmployeeID
JOIN Books b ON eb.BookID = b.BookID;

-- Заказы с книгами и суммой
SELECT o.ClientName, b.Title, oi.Quantity, oi.UnitPrice,
       (oi.Quantity * oi.UnitPrice) AS Сума
FROM Orders o
JOIN OrderItem oi ON o.OrderID = oi.OrderID
JOIN Books b ON oi.BookID = b.BookID;
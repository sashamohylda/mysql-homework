USE publishing;
SELECT 'Authors'      AS Таблиця, COUNT(*) AS Рядків FROM Authors
UNION ALL SELECT 'Employees',  COUNT(*) FROM Employees
UNION ALL SELECT 'Books',      COUNT(*) FROM Books
UNION ALL SELECT 'Orders',     COUNT(*) FROM Orders
UNION ALL SELECT 'AuthorBook', COUNT(*) FROM AuthorBook
UNION ALL SELECT 'EmployeeBook',COUNT(*) FROM EmployeeBook
UNION ALL SELECT 'Contracts',  COUNT(*) FROM Contracts
UNION ALL SELECT 'OrderItem',  COUNT(*) FROM OrderItem;
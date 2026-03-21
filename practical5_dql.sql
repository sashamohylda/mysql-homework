USE publishing;

-- Задача 1
SELECT * FROM authors;
SELECT Name, Country FROM authors WHERE Country = 'Ukraine';
SELECT Title, Genre, PublishYear FROM books ORDER BY PublishYear DESC;

Задача 1 — Прості вибірки

SELECT * повертає всі стовпці. WHERE фільтрує рядки за умовою. ORDER BY ... DESC сортує від більшого до меншого.

-- Задача 2
SELECT a.Name AS Author, b.Title AS Book
FROM authors a
JOIN authorbook ab ON a.AuthorID = ab.AuthorID
JOIN books b ON b.BookID = ab.BookID;

Задача 2 — JOIN

JOIN об'єднує таблиці за спільним полем. Через AuthorBook зв'язуємо Authors і Books — отримуємо пари автор-книга.

-- Задача 3
SELECT Title, Genre, PublishYear FROM books
WHERE Genre = 'Technology' ORDER BY PublishYear DESC;

Задача 3 — Фільтрація

WHERE Genre = 'Technology' залишає тільки книги потрібного жанру. ORDER BY PublishYear DESC сортує від новіших.


-- Задача 4
SELECT b.Genre, COUNT(*) AS BooksCount
FROM books b GROUP BY b.Genre ORDER BY BooksCount DESC;

Задача 4 — GROUP BY

COUNT(*) рахує кількість книг. GROUP BY Genre групує рядки за жанром. Отримуємо скільки книг у кожному жанрі.

-- Задача 5
SELECT b.Title, SUM(oi.Quantity * oi.UnitPrice) AS Revenue
FROM orderitem oi JOIN books b ON b.BookID = oi.BookID
GROUP BY b.Title HAVING Revenue > 100 ORDER BY Revenue DESC;

Задача 5 — HAVING

SUM() рахує виручку. HAVING фільтрує групи після агрегації — залишає тільки книги з виручкою більше 100.

-- Задача 6
SELECT b.Title FROM books b
WHERE b.BookID IN (SELECT BookID FROM orderitem);

Задача 6 — Підзапит IN

Внутрішній запит повертає список BookID з замовлень. IN перевіряє чи є книга в цьому списку.


-- Задача 7
SELECT a.Name FROM authors a
WHERE EXISTS (
  SELECT 1 FROM authorbook ab
  JOIN orderitem oi ON oi.BookID = ab.BookID
  WHERE ab.AuthorID = a.AuthorID
);

Задача 7 — EXISTS

EXISTS перевіряє чи існує хоч один рядок у підзапиті. Повертає авторів чиї книги є в замовленнях.


-- Задача 8
WITH sales AS (
  SELECT b.Title, b.Genre,
         SUM(oi.Quantity * oi.UnitPrice) AS Revenue
  FROM orderitem oi JOIN books b ON b.BookID = oi.BookID
  GROUP BY b.Title, b.Genre
)
SELECT *, RANK() OVER (PARTITION BY Genre ORDER BY Revenue DESC) AS GenreRank
FROM sales;

Задача 8 — Віконна функція

WITH створює тимчасову таблицю sales. RANK() OVER (PARTITION BY Genre) присвоює рейтинг книзі всередині свого жанру.

-- Задача 9
SELECT EmployeeID, Name, Role, Email FROM employees;
SELECT AuthorID, Name, Email, Country FROM authors;
SELECT BookID, Title, Genre, ISBN, PublishYear FROM books;

Задача 9 — Базові вибірки

Прості SELECT * для перегляду вмісту таблиць employees, authors, books.


-- Задача 10
SELECT Title, Genre, PublishYear FROM books
WHERE Genre = 'Technology' ORDER BY PublishYear DESC;
SELECT Name, Email FROM authors
WHERE Country = 'Ukraine' ORDER BY Name;

Задача 10 — Фільтрація

WHERE Country = 'Ukraine' і WHERE Genre = 'Technology' — фільтрація за конкретними значеннями поля.

-- Задача 11
SELECT b.BookID, b.Title, a.AuthorID, a.Name AS Author
FROM authorbook ab
JOIN authors a ON a.AuthorID = ab.AuthorID
JOIN books b ON b.BookID = ab.BookID
WHERE ab.AuthorOrder = 1 ORDER BY b.Title;

Задача 11 — JOIN з фільтром

WHERE ab.AuthorOrder = 1 залишає тільки головного автора кожної книги. ORDER BY b.Title сортує за назвою.


-- Задача 12
SELECT e.Name AS Employee, b.Title AS Book, eb.Task
FROM employeebook eb
JOIN employees e ON e.EmployeeID = eb.EmployeeID
JOIN books b ON b.BookID = eb.BookID
ORDER BY e.Name, b.Title;

Задача 12 — JOIN трьох таблиць

Поєднуємо EmployeeBook, Employees, Books — отримуємо хто з співробітників над якою книгою працював і яку задачу виконував.
  
-- Задача 13
SELECT o.OrderID, o.OrderDate, o.ClientName,
       b.Title, oi.Quantity, oi.UnitPrice,
       (oi.Quantity * oi.UnitPrice) AS LineTotal
FROM orders o
JOIN orderitem oi ON oi.OrderID = o.OrderID
JOIN books b ON b.BookID = oi.BookID
ORDER BY o.OrderDate DESC;

SELECT o.OrderID, o.OrderDate, o.ClientName,
       SUM(oi.Quantity * oi.UnitPrice) AS OrderTotal
FROM orders o
JOIN orderitem oi ON oi.OrderID = o.OrderID
GROUP BY o.OrderID, o.OrderDate, o.ClientName
ORDER BY o.OrderDate DESC;

Задача 13 — Деталізація і підсумок

Перший запит показує кожну позицію замовлення. Другий — SUM() з GROUP BY OrderID рахує загальну суму по кожному замовленню.

-- Задача 14
SELECT a.AuthorID, a.Name, COUNT(*) AS BooksCount
FROM authorbook ab JOIN authors a ON a.AuthorID = ab.AuthorID
GROUP BY a.AuthorID, a.Name ORDER BY BooksCount DESC;

SELECT b.BookID, b.Title,
       SUM(oi.Quantity) AS QtySold,
       SUM(oi.Quantity * oi.UnitPrice) AS Revenue
FROM orderitem oi JOIN books b ON b.BookID = oi.BookID
GROUP BY b.BookID, b.Title ORDER BY Revenue DESC;

Задача 14 — Рейтинг авторів і продажі

COUNT(*) рахує книги автора. SUM(Quantity * UnitPrice) рахує виручку по кожній книзі.


-- Задача 15
SELECT b.Title, SUM(oi.Quantity * oi.UnitPrice) AS Revenue
FROM orderitem oi JOIN books b ON b.BookID = oi.BookID
GROUP BY b.Title HAVING Revenue > 300 ORDER BY Revenue DESC;

Задача 15 — HAVING з порогом

Аналогічно задачі 5 але поріг > 300 — залишає тільки найприбутковіші книги.

-- Задача 16
SELECT a.AuthorID, a.Name FROM authors a
WHERE NOT EXISTS (
  SELECT 1 FROM authorbook ab
  JOIN orderitem oi ON oi.BookID = ab.BookID
  WHERE ab.AuthorID = a.AuthorID
);

Задача 16 — NOT EXISTS

Протилежність задачі 7 — знаходить авторів чиї книги ніхто не замовляв.

-- Задача 17
SELECT OrderID, OrderDate, ClientName, Status FROM orders
WHERE OrderDate BETWEEN '2025-05-01' AND '2025-05-31'
AND Status IN ('New','Completed') ORDER BY OrderDate DESC;

Задача 17 — Фільтр по даті

BETWEEN фільтрує замовлення за діапазоном дат. IN ('New','Completed') — тільки певні статуси.

-- Задача 18
SELECT c.ContractID, a.Name AS Author, e.Name AS Employee,
       c.ContractType, c.StartDate, c.EndDate
FROM contracts c
LEFT JOIN authors a ON a.AuthorID = c.AuthorID
LEFT JOIN employees e ON e.EmployeeID = c.EmployeeID
ORDER BY c.StartDate DESC;

Задача 18 — LEFT JOIN контрактів

LEFT JOIN показує всі контракти навіть якщо автор або співробітник не знайдений. IFNULL можна використати для заміни NULL.


-- Задача 19
WITH sales AS (
  SELECT b.BookID, b.Title, b.Genre,
         SUM(oi.Quantity * oi.UnitPrice) AS Revenue
  FROM orderitem oi JOIN books b ON b.BookID = oi.BookID
  GROUP BY b.BookID, b.Title, b.Genre
)
SELECT *,
  DENSE_RANK() OVER (PARTITION BY Genre ORDER BY Revenue DESC) AS GenreRank
FROM sales ORDER BY Genre, GenreRank;

Задача 19 — DENSE_RANK

Аналог задачі 8 але DENSE_RANK не пропускає номери при однакових значеннях (на відміну від RANK).

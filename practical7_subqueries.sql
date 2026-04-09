-- ============================================================
-- Практична робота 7. Вкладені запити. Повторне використання коду
-- База даних: publishing
-- ============================================================

USE publishing;

-- ============================================================
-- Підготовка: додаємо тестового автора без замовлень
-- ============================================================

INSERT INTO Authors (Name, Country) VALUES ('Тест Безпродажний', 'Україна');

INSERT INTO Books (Title, Genre, ISBN, PublishYear)
VALUES ('Невидима книга', 'Фантастика', '000-0-00-000000-0', 2024);

INSERT INTO AuthorBook (AuthorID, BookID)
VALUES (
  (SELECT AuthorID FROM Authors WHERE Name = 'Тест Безпродажний'),
  (SELECT BookID FROM Books WHERE ISBN = '000-0-00-000000-0')
);

-- ============================================================
-- Задача 1. Підзапит: автори, чиї книги не замовляли (NOT EXISTS)
-- ============================================================

SELECT a.AuthorID, a.Name
FROM Authors a
WHERE NOT EXISTS (
  SELECT 1
  FROM AuthorBook ab
  JOIN OrderItem oi ON oi.BookID = ab.BookID
  WHERE ab.AuthorID = a.AuthorID
);

-- ============================================================
-- Задача 2. Книги з доходом вище середнього (HAVING + підзапит)
-- ============================================================

SELECT b.Title, SUM(oi.Quantity * oi.UnitPrice) AS Revenue
FROM OrderItem oi
JOIN Books b ON b.BookID = oi.BookID
GROUP BY b.Title
HAVING Revenue > (
  SELECT AVG(Quantity * UnitPrice) FROM OrderItem
)
ORDER BY Revenue DESC;

-- ============================================================
-- Задача 3. Рейтинг книг у межах жанру (CTE + віконна функція)
-- ============================================================

WITH sales AS (
  SELECT
    b.Title,
    b.Genre,
    SUM(oi.Quantity * oi.UnitPrice) AS Revenue
  FROM Books b
  JOIN OrderItem oi ON oi.BookID = b.BookID
  GROUP BY b.Title, b.Genre
)
SELECT
  Title,
  Genre,
  Revenue,
  RANK() OVER (PARTITION BY Genre ORDER BY Revenue DESC) AS GenreRank
FROM sales
ORDER BY Genre, GenreRank;

-- ============================================================
-- Задача 4. VIEW для повторного використання коду
-- ============================================================

-- Крок 1: Створити VIEW
CREATE OR REPLACE VIEW v_book_sales AS
SELECT
  b.BookID,
  b.Title,
  b.Genre,
  COALESCE(SUM(oi.Quantity * oi.UnitPrice), 0) AS Revenue
FROM Books b
LEFT JOIN OrderItem oi ON oi.BookID = b.BookID
GROUP BY b.BookID, b.Title, b.Genre;

-- Крок 2: Використати VIEW
SELECT * FROM v_book_sales ORDER BY Revenue DESC;

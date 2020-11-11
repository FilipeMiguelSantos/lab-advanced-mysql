use publications;

select * from sales
group by title_id;
select * from titles;
select * from authors;
select * from titleauthor;
select * from sales;


-- ---------- CHALLENGE 1 ----------
-- STEP 1
SELECT ta.au_id, t.title_id,
    ROUND(((t.advance * ta.royaltyper) / 100), 2) advance,
    ROUND(((t.price * s.qty * t.royalty) / 100 * ta.royaltyper / 100),2) royalties
FROM sales as s
LEFT JOIN titles as t ON s.title_id = t.title_id
LEFT JOIN titleauthor as ta ON t.title_id = ta.title_id;
    
 -- STEP 2
SELECT title_id, au_id, SUM(royalties) total_royalties, advance
FROM (SELECT t.title_id, ta.au_id,
    ROUND(((t.advance * ta.royaltyper) / 100), 2) advance,
    ROUND(((t.price * s.qty * t.royalty) / 100 * ta.royaltyper / 100),2) royalties
FROM sales s
LEFT JOIN titles t ON s.title_id = t.title_id
LEFT JOIN titleauthor ta ON t.title_id = ta.title_id) as royalties
group by au_id, title_id;

-- STEP 3 
SELECT au_id, total_royalties+advance revenue
FROM (SELECT title_id, au_id, SUM(royalties) total_royalties, advance
FROM (SELECT t.title_id, ta.au_id,
    ROUND((t.advance * ta.royaltyper / 100), 2) advance,
    ROUND((t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100),2) royalties
FROM sales s
LEFT JOIN titles t ON s.title_id = t.title_id
LEFT JOIN titleauthor ta ON t.title_id = ta.title_id) as royalties
group by au_id, title_id) as profits
group by au_id
order by revenue desc
limit 3;

-- ---------- CHALLENGE 2 ----------
DROP TABLE IF EXISTS royalties;
CREATE TEMPORARY TABLE royalties
SELECT t.title_id, ta.au_id,
    ROUND(((t.advance * ta.royaltyper) / 100), 2) advance,
    ROUND(((t.price * s.qty * t.royalty) / 100 * ta.royaltyper / 100),2) royalties
FROM sales as s
LEFT JOIN titles as t ON s.title_id = t.title_id
LEFT JOIN titleauthor as ta ON t.title_id = ta.title_id;

select * from royalties;
 
DROP TABLE IF EXISTS profits;
CREATE TEMPORARY TABLE profits
SELECT title_id, au_id, SUM(royalties) total_royalties, advance
FROM royalties
group by au_id, title_id;

SELECT au_id, total_royalties+advance revenue
FROM profits
GROUP BY au_id
ORDER BY revenue desc
LIMIT 3;

-- ---------- CHALLENGE 3 ----------
DROP TABLE most_profitable;
CREATE TABLE most_profitable
SELECT au_id, total_royalties+total_advance revenue
FROM profits
GROUP BY au_id
ORDER BY revenue desc
LIMIT 3;

select * from most_profitable


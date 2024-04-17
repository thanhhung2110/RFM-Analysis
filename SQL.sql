
-- Invoice has more than 2 items 
WITH sub AS (
SELECT `Member Account Code` 
	,Invoice
	,SUM(`Sale Amt`) AS sale_amt 
	,COUNT(`Item Name`) AS items_amt 
FROM test_assesment
GROUP BY `Member Account Code` ,Invoice 
HAVING COUNT(`Item Name`) >=2 
)
SELECT COUNT(Invoice)
	,COUNT(CASE WHEN sale_amt >= 23000*50000 THEN Invoice END) AS platinum_trans_2items 
	,COUNT(CASE WHEN sale_amt < 23000*50000 AND sale_amt >= 23000*25000 THEN Invoice END) AS gold_trans_2items 
	,COUNT(CASE WHEN sale_amt < 23000*25000 AND sale_amt >= 23000*10000 THEN Invoice END) AS silver_trans_2items
	,COUNT(CASE WHEN sale_amt < 23000*10000 AND sale_amt >= 23000*3000 THEN Invoice END) AS ct_trans_2items 
	,COUNT(CASE WHEN sale_amt < 23000*3000 THEN Invoice END) AS others_trans_2items 
FROM sub 

-- Total & Segmentation no. of clients, Sales, Transactions, Items Sold
WITH sub1 AS (
SELECT `Member Account Code` 
	,CASE WHEN SUM(`Sale Amt`) >= 23000*50000 THEN 'PLATINUM' 
		WHEN SUM(`Sale Amt`) >= 23000*25000 AND SUM(`Sale Amt`) < 23000*50000 THEN 'GOLD' 
		WHEN SUM(`Sale Amt`) >= 23000*10000 AND SUM(`Sale Amt`) < 23000*25000 THEN 'SILVER'
		WHEN SUM(`Sale Amt`) >= 23000*3000 AND SUM(`Sale Amt`) < 23000*10000 THEN 'CT' 
		ELSE 'OTHERS' END AS Segmentation 
	,SUM(`Sale Amt`) AS sales_amt 
	,COUNT(DISTINCT `Invoice`) AS trans_amt  
	,SUM(`Sale Qty`) AS items_sold 
FROM test_assesment 
GROUP BY `Member Account Code` 
)
SELECT COUNT(DISTINCT `Member Account Code`) AS Total_clients 
	,SUM(`Sale Amt`) AS Total_Sales 
	,COUNT(DISTINCT `Invoice`) AS Total_Transactions 
	,SUM(`Sale Qty`) AS Total_Items_Sold 
	,ROUND(SUM(`Sale Amt`)/COUNT(DISTINCT `Invoice`),0) AS ATV 
	,ROUND(SUM(`Sale Qty`)/COUNT(DISTINCT `Invoice`),2) AS UPT 
FROM test_assesment
UNION  
SELECT COUNT(`Member Account Code`) 
	,SUM(`sales_amt`) 
	,SUM(`trans_amt`) 
	,SUM(`items_sold`)
	,ROUND(SUM(`sales_amt`)/SUM(`trans_amt`),0)
	,ROUND(SUM(`items_sold`)/SUM(`trans_amt`),2)
FROM sub1
WHERE Segmentation = 'PLATINUM' 
UNION 
SELECT COUNT(`Member Account Code`) 
	,SUM(`sales_amt`) 
	,SUM(`trans_amt`) 
	,SUM(`items_sold`)
	,ROUND(SUM(`sales_amt`)/SUM(`trans_amt`),0)
	,ROUND(SUM(`items_sold`)/SUM(`trans_amt`),2)
FROM sub1
WHERE Segmentation = 'GOLD'  
UNION 
SELECT COUNT(`Member Account Code`) 
	,SUM(`sales_amt`) 
	,SUM(`trans_amt`) 
	,SUM(`items_sold`)
	,ROUND(SUM(`sales_amt`)/SUM(`trans_amt`),0)
	,ROUND(SUM(`items_sold`)/SUM(`trans_amt`),2)
FROM sub1
WHERE Segmentation = 'SILVER'
UNION 
SELECT COUNT(`Member Account Code`) 
	,SUM(`sales_amt`) 
	,SUM(`trans_amt`) 
	,SUM(`items_sold`)
	,ROUND(SUM(`sales_amt`)/SUM(`trans_amt`),0)
	,ROUND(SUM(`items_sold`)/SUM(`trans_amt`),2)
FROM sub1
WHERE Segmentation = 'CT'  
UNION 
SELECT COUNT(`Member Account Code`) 
	,SUM(`sales_amt`) 
	,SUM(`trans_amt`) 
	,SUM(`items_sold`)
	,ROUND(SUM(`sales_amt`)/SUM(`trans_amt`),0)
	,ROUND(SUM(`items_sold`)/SUM(`trans_amt`),2)
FROM sub1
WHERE Segmentation = 'OTHERS' 

--- QUESTION 1.a TOP 10 MEMBER ACCOUNT CODE BY SALES QUANTITY 
SELECT `Member Account Code` 
	,SUM(`Sale Qty`) AS sale_quantity 
FROM test_assesment 
GROUP BY `Member Account Code` 
ORDER BY sale_quantity DESC 
LIMIT 10 
--- QUESTION 1.b TOP 10 MEMBER ACCOUNT CODE BY SALES AMOUNT 
SELECT `Member Account Code` 
	,SUM(`Sale Amt`) AS sale_quantity 
FROM test_assesment 
GROUP BY `Member Account Code` 
ORDER BY sale_quantity DESC 
LIMIT 10
--- QUESTION 2.a SCHEME NAME  
SELECT `Scheme Name` 
	,SUM(`Sale Qty`) AS sale_qty 
	,SUM(`Sale Amt`) AS sale_amt 
FROM test_assesment 
GROUP BY `Scheme Name` 
--- QUESTION 3 TOP 10 ITEM SOLD 
SELECT `Item Name` 
	,SUM(`Sale Qty`) AS item_sale_qty 
FROM test_assesment
GROUP BY `Item Name` 
ORDER BY item_sale_qty DESC 
LIMIT 10 

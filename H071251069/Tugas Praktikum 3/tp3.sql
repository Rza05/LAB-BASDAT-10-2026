SET search_path TO classicmodels; 

-- NO 1

SELECT ordernumber, UPPER (productcode) AS "Kode Produk", quantityordered, priceeach FROM orderdetails
WHERE (quantityordered BETWEEN 20 AND 50 OR priceeach <30 )AND LEFT (productcode,3) LIKE 'S18%'
ORDER By quantityordered DESC;

-- NO 2

SELECT customerNumber,customerName,country,creditlimit, CONCAT (contactFirstName,' ',contactLastName) AS "Nama Kontak",Creditlimit - 10000 AS "Selisih Kredit" FROM customers
WHERE  (country= 'USA'OR country='Canada'OR country='France') AND creditlimit > 30000
ORDER BY creditlimit DESC;

SELECT * FROM customers
WHERE contactlastname IS NULL;
-- NO 3
-- Pindahkan tahun ke belakang
SELECT productCode,CONCAT(SUBSTRING(productname ,5,20),' ',LEFT(productname ,4)) AS productname,buyPrice,msrp,GREATEST(buyprice,msrp) AS "Harga Tertinggi", LEAST(buyprice,msrp) AS "Harga Terendah" FROM products
WHERE productName ILIKE '%car%'
;
SELECT productname FROM products;

-- NO 4

SELECT orderNumber,orderDate,shippedDate,EXTRACT (YEAR FROM orderDate) AS "Tahun",EXTRACT(MONTH FROM orderDate) AS "Bulan",shippedDate-orderDate AS "Lama Pengiriman", AGE (shippedDate,orderDate) AS "Interval Pengiriman", CURRENT_DATE AS "Tanggal Laporan", CURRENT_TIME AS "Waktu Laporan" FROM orders
WHERE shippedDate IS NOT NULL;

-- NO 5

SELECT orderNumber,
orderDate,
shippedDate, 
orderDate + INTERVAL '10 days'AS "Estimasi Kirim",
COALESCE (shippedDate,orderDate+INTERVAL '10 days') AS "Tanggal Aktual", 
AGE (shippedDate,orderDate) AS "Selisih Waktu" FROM orders
WHERE comments ILIKE '%customer%' AND EXTRACT(MONTH FROM orderDate) BETWEEN 10 AND 12 AND (orderNumber % 2) !=0
ORDER BY orderDate DESC;

-- Soal Tambahan 1
select productcode,productname,UPPER (SUBSTRING(productname ,6,15)) AS shortName,(buyprice *0.7) + (quantityinstock%10) AS promoPrice FROM products
WHERE productname ILIKE '%V%'
		AND quantityinstock BETWEEN 1000 AND 4000
		AND quantityinstock & 4 =4;

-- Soal Tambahan 2
SELECT ordernumber,orderdate, 
	COALESCE(shippeddate,CURRENT_DATE)AS TanggalPenyelesaian, 
	GREATEST(requireddate,shippeddate) AS ToleransiAkhir,
	EXTRACT(DAY FROM(requireddate-orderdate)) AS targetHari FROM orders
WHERE EXTRACT(YEAR FROM orderdate)= 2003 AND comments IS NOT NULL
ORDER BY requireddate-orderdate DESC;

	
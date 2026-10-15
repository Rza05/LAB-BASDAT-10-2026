SET search_path to classicmodels;

-- NO 1
SELECT customernumber, 
SUM (amount) AS total_dana, 
COUNT (paymentdate) AS frekuensi_transaksi, 
MAX (amount) AS  setoran_terbesar FROM payments
GROUP BY customernumber
HAVING COUNT (paymentdate) > 4 AND AVG (amount) > 20000;

-- NO 2
SELECT customernumber, 
SUM (amount) AS total_setor FROM payments
GROUP BY customernumber
HAVING SUM (amount)>80000
ORDER BY total_setor DESC;

-- NO 3
SELECT productline, 
COUNT(productcode) AS jumlah_produk, 
ROUND(AVG(msrp),2) AS rata_retail, 
STRING_AGG (productname,', ' ORDER BY productname) FROM products
GROUP BY productline
HAVING COUNT ( productcode)>10;

-- NO 4
SELECT employeenumber FROM employees
WHERE reportsto IS NOT NULL

EXCEPT 

SELECT employeenumber FROM employees 
WHERE jobtitle ILIKE '%VP%' OR jobtitle ILIKE '%President%';

-- NO 5
SELECT productcode, 
SUM (quantityordered) AS total_terjual, 
ROUND(AVG(priceeach),2) AS harga_rata FROM orderdetails
WHERE priceeach>100
GROUP BY productcode
HAVING SUM (quantityordered)>50
ORDER BY total_terjual DESC;

-- NO 6
SELECT productcode,
SUM(quantityordered) AS total_unit,
SUM(quantityordered * priceeach) AS pendapatan_kotor,
ROUND(AVG(priceeach),2) AS rata_harga,
(MAX(priceeach)-  MIN (priceeach)) AS rentang_volatilitas
FROM orderdetails
WHERE quantityordered > 20
GROUP BY productcode
HAVING SUM(quantityordered * priceeach) > 50000
ORDER BY pendapatan_kotor DESC;

-- NO 7
SELECT customernumber FROM customers
WHERE creditlimit > 80000

INTERSECT

SELECT customernumber FROM orders
WHERE status ILIKE '%Cancelled%' OR '%On hold%'

EXCEPT

SELECT customernumber FROM payments
GROUP BY customernumber
HAVING SUM (amount) > 100000;

-- NO 1 Tambahan
SELECT 
	EXTRACT (YEAR FROM orderdate) AS tahun, 
	status,
	COUNT (ordernumber) AS total_pesanan,
	ROUND(AVG(shippeddate::date-orderdate::date),1) AS rata_tenggat_hari,
	COALESCE (ROUND(AVG(shippeddate::date-orderdate::date),1),0) AS rata_durasi_kirim,
	COUNT(comments) AS jumlah_berkomentar FROM orders
WHERE 
	EXTRACT(YEAR FROM orderdate) BETWEEN 2003 AND 2005 
	AND status ILIKE '%ship%' OR status ILIKE '%cancelled%' AND comments IS NOT NULL
GROUP BY 
	tahun,status
HAVING 
	COUNT(ordernumber)>5
ORDER BY tahun ASC;

-- NO 2 Tambahan
SELECT productcode AS kode_produk,
SUM(quantityordered) AS total_unit,
SUM(quantityordered*priceeach) AS total_pendapatan,
MAX(priceeach) AS harga_tertinggi,
MIN(priceeach) AS harga_terendah FROM orderdetails
WHERE priceeach >= 50 AND priceeach <=150
GROUP BY productcode
HAVING SUM(quantityordered*priceeach)> 30000
ORDER BY total_pendapatan DESC;


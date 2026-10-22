SET search_path TO classicmodels;

-- NO 1
SELECT c.contactfirstname,
c.customername,o.city, 
firstname || ' ' || lastname AS sales_rep_name
FROM customers as c
JOIN employees AS e 
	ON c.salesrepemployeenumber = e.employeenumber
JOIN offices AS o
	ON e.officecode = o.officecode

WHERE c.contactfirstname ILIKE 'A%' AND o.city != 'NYC'
ORDER BY c.customername ;

-- NO 2
SELECT c.customername, 
SUM (p.amount) AS total_payment,
MAX (p.amount) AS max_single_payment 
FROM customers AS c
JOIN payments AS p
	ON c.customernumber = p.customernumber
GROUP BY c.customername
HAVING SUM(p.amount) > 50000
ORDER BY total_payment DESC;

-- NO 3
SELECT c.customername,
COUNT (DISTINCT o.ordernumber) AS total_order,
ROUND(AVG(od.quantityordered),2) AS avg_quantity_per_order
FROM customers AS c
JOIN orders AS o
	ON c.customernumber = o.customernumber
JOIN orderdetails AS od
	ON o.ordernumber = od.ordernumber
GROUP BY c.customername
HAVING COUNT (DISTINCT o.ordernumber)>3 AND 
ROUND(AVG(od.quantityordered),2) > 35
ORDER BY  total_order DESC, avg_quantity_per_order DESC;

-- NO 4
SELECT pl.productline,
SUM (od.quantityordered) AS total_terjual,
ROUND(AVG(priceeach),2) AS rata_rata_harga,
ROUND(AVG(((p.msrp - od.priceeach) / p.msrp) * 100),2) || ' '|| '%' AS avg_discount_percentage
FROM productlines AS pl
JOIN products AS p
	ON pl.productline = p.productline
JOIN orderdetails AS od
	ON p.productcode = od.productcode
GROUP BY pl.productline
HAVING SUM (od.quantityordered)>3000 AND ROUND(AVG(priceeach),2) >80
ORDER BY total_terjual DESC;

-- NO 5
SELECT c.customername, 
SUM (od.quantityordered*od.priceeach) AS total_transaksi,
COUNT (DISTINCT o.ordernumber) AS total_shipped_orders,
ROUND((SUM(od.quantityordered*od.priceeach)/COUNT(DISTINCT od.ordernumber)),2) AS avg_transaction_per_order
FROM customers AS c
JOIN orders AS o
	ON c.customernumber = o.customernumber
JOIN orderdetails AS od
	ON o.ordernumber = od.ordernumber

WHERE o.status = 'Shipped'
GROUP BY c.customername
HAVING COUNT(DISTINCT EXTRACT(YEAR FROM o.orderdate)) > 1
ORDER BY total_transaksi DESC
LIMIT 5;

-- NO 6
SELECT c.customername,
c.city,
of.city,
SUM(od.quantityordered) AS total_unit_terjual,
ROUND(SUM(od.quantityordered*od.priceeach)/COUNT(DISTINCT o.ordernumber),2) AS avg_nilai_per_order
FROM customers AS c
JOIN orders AS o
	ON c.customernumber = o.customernumber
JOIN orderdetails AS od
	ON o.ordernumber = od.ordernumber
JOIN employees AS e
	ON c.salesrepemployeenumber = e.employeenumber
JOIN offices AS of
	ON e.officecode = of.officecode
	
WHERE of.territory = 'EMEA'
GROUP BY c.customername, c.city,of.city
HAVING COUNT(DISTINCT EXTRACT(YEAR FROM o.orderdate)) > 2 AND 
SUM(od.quantityordered) > 1000 AND 
ROUND(SUM(od.quantityordered*od.priceeach)/COUNT(DISTINCT c.customernumber),2) > 10000
ORDER BY avg_nilai_per_order DESC;



--soal tambahan 1
SELECT e.firstname || ' ' || e.lastname AS nama_sales,
coalesce (STRING_AGG (DISTINCT c.customername, ', ') ,'belum ada pelanggan') AS daftar_pelanggan,
coalesce (SUM (od.quantityordered),0) AS total_barang,
coalesce (SUM (od.quantityordered*od.priceeach),0) AS total_pendapatan
from employees AS e
left join customers as c
ON e.employeenumber = c.salesrepemployeenumber
left join orders as o
on c.customernumber = o.customernumber
left join orderdetails as od
on o.ordernumber = od.ordernumber
WHERE e.jobtitle = 'Sales Rep'
GROUP BY nama_sales
ORDER BY total_pendapatan DESC;

-- soal tambahan 2
select o.city, 
coalesce(STRING_AGG(distinct (firstname || ' '|| lastname), '-'),'tidak ada karyawan') AS nama_karyawan,
coalesce(Count(distinct (c.customernumber)),0) AS total_pelanggan
FROM offices as o
join employees as e
on o.officecode = e.officecode
join customers as c
on e.employeenumber = c.salesrepemployeenumber
group by o.city
ORDER by total_pelanggan DESC;

-- soal tambahan 3
select 
c.customername,
coalesce(STRING_AGG(distinct (p.productline),', '),'belum berbelanja') AS kategori_produk,
coalesce(SUM (od.quantityordered),0) AS total_barang,
coalesce(SUM (od.quantityordered*od.priceeach),0) total_pengeluaran
from offices as o
join employees as e
on o.officecode = e.officecode
join customers as c
on e.employeenumber = c.salesrepemployeenumber
left join orders as ord
on c.customernumber = ord.customernumber
left join orderdetails as od
on ord.ordernumber = od.ordernumber
left join products as p
on od.productcode = p.productcode
WHERE o.city = 'Paris'
GROUP BY o.city,c.customername
ORDER BY total_pengeluaran desc;











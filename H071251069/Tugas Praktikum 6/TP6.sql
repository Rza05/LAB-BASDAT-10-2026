CREATE table kurir (
	id_kurir SERIAL PRIMARY KEY,
	nama_kurir VARCHAR(50) NOT NULL,
	no_telepon VARCHAR (20)NOT NULL UNIQUE,
	status_aktif BOOLEAN default TRUE
);

CREATE table pengiriman(
	id_pengiriman SERIAL PRIMARY KEY ,
	nomor_resi VARCHAR(30) NOT NULL UNIQUE,
	id_kurir INT,
	tanggal_kirim TIMESTAMP DEFAULT current_timestamp,
	ongkos_kirim NUMERIC(12,2) NOT NULL CHECK(ongkos_kirim>0),
	status_pengiriman VARCHAR(20) DEFAULT 'Dalam Perjalanan',
	FOREIGN KEY (id_kurir) references kurir (id_kurir)
);

CREATE INDEX index_pengiriman_kurir
ON pengiriman(id_kurir);

CREATE INDEX index_pengiriman_status
ON pengiriman(status_pengiriman);

DROP index index_pengiriman_status;

insert into kurir VALUES (DEFAULT,'Asep',0812,TRUE);
insert into kurir VALUES (DEFAULT,'AsepP',0813,TRUE);
insert into kurir VALUES (DEFAULT,'AsepP',0813,TRUE);
insert into kurir VALUES (DEFAULT,'AsepP',0813,TRUE);

SELECT * from kurir;
DROP TABLE pengiriman;
DROP TABLE kurir;
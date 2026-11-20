
-- =====================================
-- THE REDS GAMING LOUNGE
-- 1. MASTER TABLES
-- =====================================

-- Tabel pelanggan
CREATE TABLE customers (
    customer_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Tabel pegawai
CREATE TABLE employees (
    employee_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    position VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20),
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

-- Tabel unit PlayStation
CREATE TABLE ps_units (
    unit_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    unit_code VARCHAR(20) NOT NULL UNIQUE,
    ps_type VARCHAR(20) NOT NULL,
    unit_status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',

    CONSTRAINT chk_ps_type
        CHECK (ps_type IN ('PS4', 'PS5')),

    CONSTRAINT chk_unit_status
        CHECK (unit_status IN ('ACTIVE', 'MAINTENANCE', 'INACTIVE'))
);


-- =====================================
-- 2. TRANSACTION TABLES
-- =====================================

-- Tabel booking
CREATE TABLE bookings (
    booking_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    booking_code VARCHAR(30) NOT NULL UNIQUE,
    customer_id BIGINT NOT NULL,
    employee_id BIGINT,
    booking_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    booking_channel VARCHAR(10) NOT NULL,
    booking_status VARCHAR(20) NOT NULL DEFAULT 'BOOKED',

    CONSTRAINT fk_booking_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id),

    CONSTRAINT fk_booking_employee
        FOREIGN KEY (employee_id) REFERENCES employees(employee_id),

    CONSTRAINT chk_booking_channel
        CHECK (booking_channel IN ('ONLINE', 'OFFLINE')),

    CONSTRAINT chk_booking_status
        CHECK (booking_status IN ('BOOKED', 'IN_PROGRESS', 'COMPLETED')),

    CONSTRAINT chk_booking_employee
        CHECK (
            (booking_channel = 'ONLINE' AND employee_id IS NULL)
            OR
            (booking_channel = 'OFFLINE' AND employee_id IS NOT NULL)
        )
);

-- Tabel detail booking
CREATE TABLE booking_details (
    booking_detail_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    booking_id BIGINT NOT NULL,
    unit_id BIGINT NOT NULL,
    start_time TIMESTAMPTZ NOT NULL,
    end_time TIMESTAMPTZ NOT NULL,
    hourly_rate NUMERIC(12,2) NOT NULL,

    CONSTRAINT fk_detail_booking
        FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),

    CONSTRAINT fk_detail_unit
        FOREIGN KEY (unit_id) REFERENCES ps_units(unit_id),

    CONSTRAINT uq_booking_unit
        UNIQUE (booking_id, unit_id),

    CONSTRAINT chk_booking_time
        CHECK (end_time > start_time),

    CONSTRAINT chk_hourly_rate
        CHECK (hourly_rate > 0)
);

-- Tabel pembayaran
CREATE TABLE payments (
    payment_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    booking_id BIGINT NOT NULL,
    payment_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    amount NUMERIC(12,2) NOT NULL,
    payment_type VARCHAR(20) NOT NULL,
    payment_method VARCHAR(20) NOT NULL,

    CONSTRAINT fk_payment_booking
        FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),

    CONSTRAINT chk_payment_amount
        CHECK (amount > 0),

    CONSTRAINT chk_payment_type
        CHECK (payment_type IN ('DP', 'PELUNASAN')),

    CONSTRAINT chk_payment_method
        CHECK (payment_method IN ('CASH', 'TRANSFER', 'QRIS', 'CARD'))
);


-- =====================================
-- 3. INSERT MASTER DATA
-- =====================================

-- Data pelanggan
INSERT INTO customers (customer_name, phone_number, email)
VALUES
('Andi Pratama', '081234567801', 'andi@email.com'),
('Budi Santoso', '081234567802', 'budi@email.com'),
('Citra Amelia', '081234567803', 'citra@email.com');

-- Data pegawai
INSERT INTO employees (employee_name, position, phone_number)
VALUES
('Rizky Maulana', 'Admin', '081234567811'),
('Dinda Putri', 'Operator', '081234567812');

-- Data unit PlayStation
INSERT INTO ps_units (unit_code, ps_type, unit_status)
VALUES
('PS4-01', 'PS4', 'ACTIVE'),
('PS4-02', 'PS4', 'ACTIVE'),
('PS5-01', 'PS5', 'ACTIVE'),
('PS5-02', 'PS5', 'ACTIVE');

SELECT
    (SELECT COUNT(*) FROM customers) AS total_customers,
    (SELECT COUNT(*) FROM employees) AS total_employees,
    (SELECT COUNT(*) FROM ps_units) AS total_ps_units;

SELECT * FROM customers;

SELECT * FROM employees;

SELECT * FROM ps_units;


-- =====================================
-- 4. INSERT BOOKING DATA
-- =====================================

INSERT INTO bookings
(booking_code, customer_id, employee_id, booking_channel, booking_status)
VALUES
('TRX001', 1, NULL, 'ONLINE', 'BOOKED'),
('TRX002', 2, 1, 'OFFLINE', 'BOOKED'),
('TRX003', 3, 2, 'OFFLINE', 'BOOKED');

SELECT * FROM bookings;


-- =====================================
-- 5. INSERT BOOKING DETAILS
-- =====================================

INSERT INTO booking_details
(booking_id, unit_id, start_time, end_time, hourly_rate)
VALUES
(1, 3, '2026-11-21 10:00:00+07', '2026-11-21 12:00:00+07', 20000),
(2, 1, '2026-11-21 13:00:00+07', '2026-11-21 15:00:00+07', 20000),
(2, 2, '2026-11-21 13:00:00+07', '2026-11-21 16:00:00+07', 20000),
(3, 4, '2026-11-21 16:00:00+07', '2026-11-21 17:00:00+07', 20000);

SELECT * FROM booking_details;


-- =====================================
-- 6. INSERT PAYMENT DATA
-- =====================================

INSERT INTO payments
(booking_id, amount, payment_type, payment_method)
VALUES
(1, 20000, 'DP', 'QRIS'),
(1, 20000, 'PELUNASAN', 'QRIS'),
(2, 40000, 'DP', 'CASH'),
(2, 60000, 'PELUNASAN', 'CASH'),
(3, 20000, 'PELUNASAN', 'TRANSFER');

SELECT * FROM payments;

SELECT
    booking_id,
    amount,
    payment_type,
    payment_method,
    COUNT(*) AS jumlah
FROM payments
GROUP BY
    booking_id,
    amount,
    payment_type,
    payment_method
ORDER BY booking_id, payment_type;

DELETE FROM payments
WHERE payment_id IN (
    SELECT payment_id
    FROM (
        SELECT
            payment_id,
            ROW_NUMBER() OVER (
                PARTITION BY
                    booking_id,
                    amount,
                    payment_type,
                    payment_method
                ORDER BY payment_id
            ) AS nomor
        FROM payments
    ) AS duplikat
    WHERE nomor > 1
);

SELECT COUNT(*) FROM payments;

SELECT * FROM payments
ORDER BY payment_id;

SELECT
    b.booking_id,
    b.booking_code,
    c.customer_name,
    b.booking_channel,
    b.booking_status
FROM bookings b
JOIN customers c
    ON b.customer_id = c.customer_id
ORDER BY b.booking_id;

SELECT
    b.booking_code,
    c.customer_name,
    u.unit_code,
    u.ps_type,
    bd.start_time,
    bd.end_time,
    bd.hourly_rate
FROM bookings b
JOIN customers c
    ON b.customer_id = c.customer_id
JOIN booking_details bd
    ON b.booking_id = bd.booking_id
JOIN ps_units u
    ON bd.unit_id = u.unit_id
ORDER BY b.booking_id, u.unit_id;

SELECT
    b.booking_code,
    c.customer_name,
    SUM(
        EXTRACT(EPOCH FROM (bd.end_time - bd.start_time)) / 3600
        * bd.hourly_rate
    ) AS total_biaya
FROM bookings b
JOIN customers c
    ON b.customer_id = c.customer_id
JOIN booking_details bd
    ON b.booking_id = bd.booking_id
GROUP BY b.booking_id, b.booking_code, c.customer_name
ORDER BY b.booking_id;

SELECT
    b.booking_code,
    c.customer_name,
    SUM(
        EXTRACT(EPOCH FROM (bd.end_time - bd.start_time)) / 3600
        * bd.hourly_rate
    ) AS total_biaya,
    COALESCE(SUM(p.amount), 0) AS total_dibayar,
    SUM(
        EXTRACT(EPOCH FROM (bd.end_time - bd.start_time)) / 3600
        * bd.hourly_rate
    ) - COALESCE(SUM(p.amount), 0) AS sisa_tagihan
FROM bookings b
JOIN customers c
    ON b.customer_id = c.customer_id
JOIN booking_details bd
    ON b.booking_id = bd.booking_id
LEFT JOIN payments p
    ON b.booking_id = p.booking_id
GROUP BY b.booking_id, b.booking_code, c.customer_name
ORDER BY b.booking_id;

SELECT
    b.booking_code,
    c.customer_name,
    p.payment_date,
    p.amount,
    p.payment_type,
    p.payment_method
FROM payments p
JOIN bookings b
    ON p.booking_id = b.booking_id
JOIN customers c
    ON b.customer_id = c.customer_id
ORDER BY b.booking_id, p.payment_id;

SELECT
    b.booking_code,
    c.customer_name,
    SUM(
        EXTRACT(EPOCH FROM (bd.end_time - bd.start_time)) / 3600
        * bd.hourly_rate
    ) AS total_biaya,
    COALESCE(p.total_dibayar, 0) AS total_dibayar,
    CASE
        WHEN COALESCE(p.total_dibayar, 0) >= SUM(
            EXTRACT(EPOCH FROM (bd.end_time - bd.start_time)) / 3600
            * bd.hourly_rate
        ) THEN 'LUNAS'
        ELSE 'BELUM LUNAS'
    END AS status_pembayaran
FROM bookings b
JOIN customers c
    ON b.customer_id = c.customer_id
JOIN booking_details bd
    ON b.booking_id = bd.booking_id
LEFT JOIN (
    SELECT booking_id, SUM(amount) AS total_dibayar
    FROM payments
    GROUP BY booking_id
) p
    ON b.booking_id = p.booking_id
GROUP BY
    b.booking_id,
    b.booking_code,
    c.customer_name,
    p.total_dibayar
ORDER BY b.booking_id;

WITH biaya AS (
    SELECT
        booking_id,
        SUM(
            EXTRACT(EPOCH FROM (end_time - start_time)) / 3600
            * hourly_rate
        ) AS total_biaya
    FROM booking_details
    GROUP BY booking_id
),
pembayaran AS (
    SELECT
        booking_id,
        SUM(amount) AS total_dibayar
    FROM payments
    GROUP BY booking_id
)
SELECT
    b.booking_code,
    c.customer_name,
    biaya.total_biaya,
    COALESCE(pembayaran.total_dibayar, 0) AS total_dibayar,
    biaya.total_biaya - COALESCE(pembayaran.total_dibayar, 0) AS sisa_tagihan
FROM bookings b
JOIN customers c ON b.customer_id = c.customer_id
JOIN biaya ON b.booking_id = biaya.booking_id
LEFT JOIN pembayaran ON b.booking_id = pembayaran.booking_id
ORDER BY b.booking_id;
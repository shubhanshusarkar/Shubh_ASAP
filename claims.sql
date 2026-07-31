INSERT INTO claims (claim_id, policyholder_id, incident_date, claimed_amount, provider_id, device_fingerprint, claim_description, bank_account, address, fraud_label) VALUES
('CLM0001','PH0001','2026-01-12',48000.00,'PROV001','DEV001','Rear collision with repeated repair invoices','BANK001','ADDR001',1),
('CLM0002','PH0002','2026-01-15',62000.00,'PROV001','DEV002','Medical reimbursement with inflated bills','BANK002','ADDR002',1),
('CLM0003','PH0003','2026-01-17',9500.00,'PROV003','DEV003','Windshield replacement','BANK003','ADDR003',0),
('CLM0004','PH0004','2026-01-19',81000.00,'PROV002','DEV001','Large bodily injury settlement','BANK001','ADDR001',1),
('CLM0005','PH0005','2026-01-22',15000.00,'PROV004','DEV004','Water damage after pipe leakage','BANK004','ADDR004',0),
('CLM0006','PH0006','2026-01-24',72000.00,'PROV001','DEV005','Multiple surgery invoices','BANK002','ADDR002',1),
('CLM0007','PH0007','2026-01-26',18000.00,'PROV005','DEV006','Minor collision','BANK005','ADDR005',0),
('CLM0008','PH0008','2026-01-28',56000.00,'PROV002','DEV001','Repeated accident with same garage','BANK001','ADDR001',1),
('CLM0009','PH0009','2026-01-30',43000.00,'PROV006','DEV007','Fire damage','BANK006','ADDR006',0),
('CLM0010','PH0010','2026-02-02',92000.00,'PROV001','DEV002','Total vehicle loss','BANK002','ADDR002',1);

-- Dynamically Populate Claims CLM0011 to CLM0100
INSERT INTO claims (claim_id, policyholder_id, incident_date, claimed_amount, provider_id, device_fingerprint, claim_description, bank_account, address, fraud_label)
SELECT 
    'CLM' || LPAD(i::TEXT, 4, '0') AS claim_id,
    'PH' || LPAD(i::TEXT, 4, '0') AS policyholder_id,
    DATE('2026-02-01') + (i || ' days')::INTERVAL AS incident_date,
    ROUND((2000 + (RANDOM() * 75000))::NUMERIC, 2) AS claimed_amount,
    'PROV' || LPAD(((i % 10) + 1)::TEXT, 3, '0') AS provider_id,
    CASE WHEN i % 3 = 0 THEN 'DEV001' ELSE 'DEV' || LPAD(i::TEXT, 3, '0') END AS device_fingerprint,
    'Synthetic claim incident description for pattern testing #' || i AS claim_description,
    CASE WHEN i % 3 = 0 THEN 'BANK001' ELSE 'BANK' || LPAD(i::TEXT, 3, '0') END AS bank_account,
    CASE WHEN i % 3 = 0 THEN 'ADDR001' ELSE 'ADDR' || LPAD(i::TEXT, 3, '0') END AS address,
    CASE WHEN i % 3 = 0 THEN 1 ELSE 0 END AS fraud_label
FROM generate_series(11, 100) i;

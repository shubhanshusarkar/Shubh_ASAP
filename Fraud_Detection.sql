BEGIN TRANSACTION;

-- ----------------------------------------------------------------------------
-- SCHEMA DEFINITIONS (SQLite Compatible)
-- ----------------------------------------------------------------------------

DROP TABLE IF EXISTS fraud_embeddings;
DROP TABLE IF EXISTS graph_edges;
DROP TABLE IF EXISTS graph_nodes;
DROP TABLE IF EXISTS claims;
DROP TABLE IF EXISTS devices;
DROP TABLE IF EXISTS bank_accounts;
DROP TABLE IF EXISTS service_providers;
DROP TABLE IF EXISTS policyholders;

CREATE TABLE policyholders (
    policyholder_id TEXT PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE service_providers (
    provider_id TEXT PRIMARY KEY,
    provider_name TEXT NOT NULL,
    category TEXT NOT NULL,
    risk_score REAL
);

CREATE TABLE bank_accounts (
    account_id TEXT PRIMARY KEY,
    account_number TEXT NOT NULL,
    routing_number TEXT NOT NULL,
    bank_name TEXT
);

CREATE TABLE devices (
    device_id TEXT PRIMARY KEY,
    device_fingerprint TEXT UNIQUE NOT NULL,
    ip_address TEXT,
    os TEXT
);

CREATE TABLE claims (
    claim_id TEXT PRIMARY KEY,
    policyholder_id TEXT REFERENCES policyholders(policyholder_id),
    provider_id TEXT REFERENCES service_providers(provider_id),
    device_id TEXT REFERENCES devices(device_id),
    bank_account_id TEXT REFERENCES bank_accounts(account_id),
    incident_date TEXT NOT NULL,
    claimed_amount REAL NOT NULL,
    claim_status TEXT DEFAULT 'PENDING',
    is_fraudulent INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE graph_nodes (
    node_id TEXT PRIMARY KEY,
    node_type TEXT NOT NULL,
    entity_id TEXT NOT NULL,
    label TEXT
);

CREATE TABLE graph_edges (
    edge_id TEXT PRIMARY KEY,
    source_node_id TEXT REFERENCES graph_nodes(node_id),
    target_node_id TEXT REFERENCES graph_nodes(node_id),
    relationship_type TEXT NOT NULL,
    weight REAL DEFAULT 1.00
);

CREATE TABLE fraud_embeddings (
    library_id TEXT PRIMARY KEY,
    pattern_type TEXT NOT NULL,
    description TEXT NOT NULL,
    embedding TEXT NOT NULL,
    severity_level TEXT NOT NULL
);


-- ----------------------------------------------------------------------------
-- DATA INSERTION
-- ----------------------------------------------------------------------------

INSERT INTO policyholders (policyholder_id, first_name, last_name, email) VALUES
  ('PH-00001', 'Joshua', 'Davis', 'joshua.davis1@example.com'),
  ('PH-00002', 'Mary', 'Mitchell', 'mary.mitchell2@example.com'),
  ('PH-00003', 'Sarah', 'Thomas', 'sarah.thomas3@example.com'),
  ('PH-00004', 'Joseph', 'Rodriguez', 'joseph.rodriguez4@example.com'),
  ('PH-00005', 'Melissa', 'Miller', 'melissa.miller5@example.com'),
  ('PH-00006', 'Amanda', 'Mitchell', 'amanda.mitchell6@example.com'),
  ('PH-00007', 'Steven', 'Garcia', 'steven.garcia7@example.com'),
  ('PH-00008', 'Donna', 'Ramirez', 'donna.ramirez8@example.com'),
  ('PH-00009', 'John', 'Johnson', 'john.johnson9@example.com'),
  ('PH-00010', 'Jennifer', 'Wilson', 'jennifer.wilson10@example.com'),
  ('PH-00011', 'Joseph', 'Allen', 'joseph.allen11@example.com'),
  ('PH-00012', 'Kenneth', 'Johnson', 'kenneth.johnson12@example.com'),
  ('PH-00013', 'Emily', 'Gonzalez', 'emily.gonzalez13@example.com'),
  ('PH-00014', 'Dorothy', 'Adams', 'dorothy.adams14@example.com'),
  ('PH-00015', 'Brian', 'Wright', 'brian.wright15@example.com'),
  ('PH-00016', 'Anthony', 'Anderson', 'anthony.anderson16@example.com'),
  ('PH-00017', 'Donald', 'Nguyen', 'donald.nguyen17@example.com'),
  ('PH-00018', 'Sarah', 'Smith', 'sarah.smith18@example.com'),
  ('PH-00019', 'Edward', 'Hernandez', 'edward.hernandez19@example.com'),
  ('PH-00020', 'Brian', 'Ramirez', 'brian.ramirez20@example.com'),
  ('PH-00021', 'Nancy', 'Moore', 'nancy.moore21@example.com'),
  ('PH-00022', 'Elizabeth', 'Wilson', 'elizabeth.wilson22@example.com'),
  ('PH-00023', 'Edward', 'Perez', 'edward.perez23@example.com'),
  ('PH-00024', 'Michael', 'Garcia', 'michael.garcia24@example.com'),
  ('PH-00025', 'Matthew', 'Miller', 'matthew.miller25@example.com'),
  ('PH-00026', 'Daniel', 'Thompson', 'daniel.thompson26@example.com'),
  ('PH-00027', 'Kenneth', 'Taylor', 'kenneth.taylor27@example.com'),
  ('PH-00028', 'John', 'Campbell', 'john.campbell28@example.com'),
  ('PH-00029', 'Sandra', 'Wright', 'sandra.wright29@example.com'),
  ('PH-00030', 'Linda', 'Harris', 'linda.harris30@example.com'),
  ('PH-00031', 'Jennifer', 'Scott', 'jennifer.scott31@example.com'),
  ('PH-00032', 'Charles', 'Green', 'charles.green32@example.com'),
  ('PH-00033', 'Michelle', 'White', 'michelle.white33@example.com'),
  ('PH-00034', 'Andrew', 'Gonzalez', 'andrew.gonzalez34@example.com'),
  ('PH-00035', 'Dorothy', 'Jones', 'dorothy.jones35@example.com'),
  ('PH-00036', 'John', 'Nelson', 'john.nelson36@example.com'),
  ('PH-00037', 'Joseph', 'Roberts', 'joseph.roberts37@example.com'),
  ('PH-00038', 'Charles', 'Garcia', 'charles.garcia38@example.com'),
  ('PH-00039', 'Joseph', 'Miller', 'joseph.miller39@example.com'),
  ('PH-00040', 'Matthew', 'Moore', 'matthew.moore40@example.com'),
  ('PH-00041', 'Sandra', 'Green', 'sandra.green41@example.com'),
  ('PH-00042', 'Lisa', 'Hernandez', 'lisa.hernandez42@example.com'),
  ('PH-00043', 'Lisa', 'Thompson', 'lisa.thompson43@example.com'),
  ('PH-00044', 'Susan', 'Nelson', 'susan.nelson44@example.com'),
  ('PH-00045', 'Sarah', 'Hall', 'sarah.hall45@example.com'),
  ('PH-00046', 'Amanda', 'Adams', 'amanda.adams46@example.com'),
  ('PH-00047', 'Robert', 'Hill', 'robert.hill47@example.com'),
  ('PH-00048', 'Joshua', 'Hernandez', 'joshua.hernandez48@example.com'),
  ('PH-00049', 'Steven', 'Campbell', 'steven.campbell49@example.com'),
  ('PH-00050', 'Jessica', 'Hernandez', 'jessica.hernandez50@example.com'),
  ('PH-00051', 'Sandra', 'Harris', 'sandra.harris51@example.com'),
  ('PH-00052', 'Sarah', 'Green', 'sarah.green52@example.com'),
  ('PH-00053', 'Brian', 'Scott', 'brian.scott53@example.com'),
  ('PH-00054', 'Joseph', 'Baker', 'joseph.baker54@example.com'),
  ('PH-00055', 'Christopher', 'Roberts', 'christopher.roberts55@example.com'),
  ('PH-00056', 'Deborah', 'Brown', 'deborah.brown56@example.com'),
  ('PH-00057', 'Joseph', 'Williams', 'joseph.williams57@example.com'),
  ('PH-00058', 'Christopher', 'Sanchez', 'christopher.sanchez58@example.com'),
  ('PH-00059', 'Sarah', 'Jones', 'sarah.jones59@example.com'),
  ('PH-00060', 'Susan', 'Torres', 'susan.torres60@example.com'),
  ('PH-00061', 'Dorothy', 'Lee', 'dorothy.lee61@example.com'),
  ('PH-00062', 'Susan', 'Adams', 'susan.adams62@example.com'),
  ('PH-00063', 'Ashley', 'Sanchez', 'ashley.sanchez63@example.com'),
  ('PH-00064', 'Carol', 'Robinson', 'carol.robinson64@example.com'),
  ('PH-00065', 'Elizabeth', 'Taylor', 'elizabeth.taylor65@example.com'),
  ('PH-00066', 'William', 'Thomas', 'william.thomas66@example.com'),
  ('PH-00067', 'Melissa', 'Scott', 'melissa.scott67@example.com'),
  ('PH-00068', 'Steven', 'Taylor', 'steven.taylor68@example.com'),
  ('PH-00069', 'Melissa', 'Nguyen', 'melissa.nguyen69@example.com'),
  ('PH-00070', 'Margaret', 'Nguyen', 'margaret.nguyen70@example.com'),
  ('PH-00071', 'Betty', 'White', 'betty.white71@example.com'),
  ('PH-00072', 'Joseph', 'Rodriguez', 'joseph.rodriguez72@example.com'),
  ('PH-00073', 'Paul', 'Young', 'paul.young73@example.com'),
  ('PH-00074', 'Jennifer', 'Carter', 'jennifer.carter74@example.com'),
  ('PH-00075', 'Patricia', 'Davis', 'patricia.davis75@example.com'),
  ('PH-00076', 'Elizabeth', 'Green', 'elizabeth.green76@example.com'),
  ('PH-00077', 'David', 'Baker', 'david.baker77@example.com'),
  ('PH-00078', 'Margaret', 'Hill', 'margaret.hill78@example.com'),
  ('PH-00079', 'Robert', 'Harris', 'robert.harris79@example.com'),
  ('PH-00080', 'Matthew', 'Hill', 'matthew.hill80@example.com'),
  ('PH-00081', 'Sandra', 'King', 'sandra.king81@example.com'),
  ('PH-00082', 'Thomas', 'Scott', 'thomas.scott82@example.com'),
  ('PH-00083', 'James', 'Baker', 'james.baker83@example.com'),
  ('PH-00084', 'George', 'Davis', 'george.davis84@example.com'),
  ('PH-00085', 'Amanda', 'Wright', 'amanda.wright85@example.com'),
  ('PH-00086', 'Edward', 'Moore', 'edward.moore86@example.com'),
  ('PH-00087', 'Deborah', 'Adams', 'deborah.adams87@example.com'),
  ('PH-00088', 'Nancy', 'Davis', 'nancy.davis88@example.com'),
  ('PH-00089', 'Charles', 'Ramirez', 'charles.ramirez89@example.com'),
  ('PH-00090', 'David', 'Robinson', 'david.robinson90@example.com'),
  ('PH-00091', 'James', 'Campbell', 'james.campbell91@example.com'),
  ('PH-00092', 'George', 'Taylor', 'george.taylor92@example.com'),
  ('PH-00093', 'Paul', 'Carter', 'paul.carter93@example.com'),
  ('PH-00094', 'Barbara', 'Allen', 'barbara.allen94@example.com'),
  ('PH-00095', 'Michael', 'Green', 'michael.green95@example.com'),
  ('PH-00096', 'Karen', 'Green', 'karen.green96@example.com'),
  ('PH-00097', 'Paul', 'Hill', 'paul.hill97@example.com'),
  ('PH-00098', 'Richard', 'Martinez', 'richard.martinez98@example.com'),
  ('PH-00099', 'Lisa', 'Carter', 'lisa.carter99@example.com'),
  ('PH-00100', 'David', 'Wright', 'david.wright100@example.com');

INSERT INTO service_providers (provider_id, provider_name, category, risk_score) VALUES
  ('PRV-001', 'Apex Auto Repair', 'MEDICAL_CLINIC', 0.19),
  ('PRV-002', 'Metro Health Clinic', 'DENTAL', 0.06),
  ('PRV-003', 'Summit Dental Group', 'REHAB', 0.48),
  ('PRV-004', 'Precision Body Shop', 'DIAGNOSTIC', 0.27),
  ('PRV-005', 'City Care Medical', 'AUTO_REPAIR', 0.83),
  ('PRV-006', 'Valley Mechanical', 'MEDICAL_CLINIC', 0.49),
  ('PRV-007', 'ProCare Rehab Center', 'DENTAL', 0.61),
  ('PRV-008', 'Trinity Orthopedics', 'REHAB', 0.15),
  ('PRV-009', 'Reliable Auto Care', 'DIAGNOSTIC', 0.74),
  ('PRV-010', 'Northside Vision & Wellness', 'AUTO_REPAIR', 0.44),
  ('PRV-011', 'Beacon Auto Restorations', 'MEDICAL_CLINIC', 0.75),
  ('PRV-012', 'Harmony Urgent Care', 'DENTAL', 0.51),
  ('PRV-013', 'Pinnacle Diagnostic Lab', 'REHAB', 0.43),
  ('PRV-014', 'Evergreen Family Practice', 'DIAGNOSTIC', 0.4),
  ('PRV-015', 'Crossroads Collision Center', 'AUTO_REPAIR', 0.2);

INSERT INTO bank_accounts (account_id, account_number, routing_number, bank_name) VALUES
  ('ACC-0001', '155165334', '371096600', 'Citi'),
  ('ACC-0002', '222500131', '982739959', 'Chase'),
  ('ACC-0003', '530256336', '628008852', 'Chase'),
  ('ACC-0004', '719571745', '775862179', 'Chase'),
  ('ACC-0005', '262915636', '260199682', 'Capital One'),
  ('ACC-0006', '426240903', '191462297', 'Bank of America'),
  ('ACC-0007', '227186396', '699226355', 'Citi'),
  ('ACC-0008', '751028618', '740086326', 'Capital One'),
  ('ACC-0009', '342329714', '932894596', 'Capital One'),
  ('ACC-0010', '508427798', '583736219', 'Citi');

INSERT INTO devices (device_id, device_fingerprint, ip_address, os) VALUES
  ('DEV-0001', 'fp_64071e7a9cf6448e', '89.111.29.73', 'iOS 17.1'),
  ('DEV-0002', 'fp_34cb675954fe4d1d', '125.135.171.79', 'iOS 16.4'),
  ('DEV-0003', 'fp_f90b6f83314041fb', '57.102.253.154', 'iOS 16.4'),
  ('DEV-0004', 'fp_fabc5caff5e24db2', '2.53.78.243', 'Android 13'),
  ('DEV-0005', 'fp_3da1a4d150f74a92', '197.36.196.66', 'Windows 11');

INSERT INTO claims (claim_id, policyholder_id, provider_id, device_id, bank_account_id, incident_date, claimed_amount, claim_status, is_fraudulent) VALUES
  ('CLM-00001', 'PH-00001', 'PRV-008', 'DEV-0001', 'ACC-0001', '2025-01-04', 3021.17, 'PAID', 0),
  ('CLM-00002', 'PH-00002', 'PRV-004', 'DEV-0002', 'ACC-0002', '2026-05-04', 4018.56, 'CLOSED', 0),
  ('CLM-00003', 'PH-00003', 'PRV-010', 'DEV-0003', 'ACC-0003', '2025-05-14', 6255.35, 'APPROVED', 0),
  ('CLM-00004', 'PH-00004', 'PRV-012', 'DEV-0004', 'ACC-0004', '2025-08-27', 2314.05, 'APPROVED', 0),
  ('CLM-00012', 'PH-00012', 'PRV-003', 'DEV-0005', 'ACC-0003', '2025-04-14', 41835.87, 'FLAGGED', 1);

INSERT INTO graph_nodes (node_id, node_type, entity_id, label) VALUES
  ('N-PH-00001', 'CLAIMANT', 'PH-00001', 'Claimant PH-00001'),
  ('N-PH-00002', 'CLAIMANT', 'PH-00002', 'Claimant PH-00002'),
  ('N-PRV-00501', 'PROVIDER', 'PRV-001', 'Provider PRV-001');

INSERT INTO graph_edges (edge_id, source_node_id, target_node_id, relationship_type, weight) VALUES
  ('E-000001', 'N-PH-00001', 'N-PRV-00501', 'SERVICED_BY', 1.0),
  ('E-000002', 'N-PH-00001', 'N-BA-00551', 'USES_BANK_ACCOUNT', 1.0);

INSERT INTO fraud_embeddings (library_id, pattern_type, description, embedding, severity_level) VALUES
  ('LIB-001', 'Overcharging Medical Network', 'Staged vehicle theft; device fingerprint matches 3 other flagged claims.', '[-0.9817, -0.1391, -0.4142, -0.5376, -0.9856, -0.2527, -0.1765, 0.1211]', 'HIGH'),
  ('LIB-002', 'Staged Accident Ring', 'Identical high-value windshield replacement claims across policyholders.', '[0.4299, 0.292, 0.6569, -0.5588, -0.8416, 0.2506, 0.0332, 0.5999]', 'CRITICAL');

COMMIT;

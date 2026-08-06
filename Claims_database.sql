-- =====================================
-- schema.sql
-- =====================================

DROP TABLE IF EXISTS claims;
DROP TABLE IF EXISTS verification_records;
DROP TABLE IF EXISTS claim_relationships;
DROP TABLE IF EXISTS historical_fraud_patterns;

CREATE TABLE claims (
    claim_id TEXT PRIMARY KEY,
    policyholder_id TEXT NOT NULL,
    incident_date TEXT NOT NULL,
    claimed_amount REAL NOT NULL,
    provider_id TEXT NOT NULL,
    device_fingerprint TEXT NOT NULL,
    claim_description TEXT,
    bank_account TEXT,
    address TEXT,
    fraud_label INTEGER DEFAULT 0
);

CREATE TABLE verification_records (
    claim_id TEXT PRIMARY KEY,
    customer_exists INTEGER DEFAULT 1,
    provider_verified INTEGER DEFAULT 1,
    policy_active INTEGER DEFAULT 1,
    previous_claims INTEGER DEFAULT 0,
    previous_fraud INTEGER DEFAULT 0,
    bank_account_verified INTEGER DEFAULT 1,
    device_reuse_count INTEGER DEFAULT 0,
    shared_bank_count INTEGER DEFAULT 0,
    shared_address_count INTEGER DEFAULT 0,
    provider_risk TEXT DEFAULT 'Low',
    verification_summary TEXT
);

CREATE TABLE claim_relationships (
    claim_id TEXT,
    node_type TEXT,
    node_id TEXT
);

CREATE TABLE historical_fraud_patterns (
    pattern_id TEXT PRIMARY KEY,
    fraud_type TEXT,
    embedding_text TEXT,
    risk_level TEXT
);

-- =====================================
-- claims.sql
-- =====================================

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
('CLM0010','PH0010','2026-02-02',92000.00,'PROV001','DEV002','Total vehicle loss','BANK002','ADDR002',1),
('CLM0011','PH0011','2026-02-03',12400.00,'PROV003','DEV008','Minor bumper damage','BANK007','ADDR007',0),
('CLM0012','PH0012','2026-02-04',54000.00,'PROV002','DEV001','Multiple claims from shared device','BANK001','ADDR001',1),
('CLM0013','PH0013','2026-02-05',8900.00,'PROV004','DEV009','Side mirror replacement','BANK008','ADDR008',0),
('CLM0014','PH0014','2026-02-06',31000.00,'PROV005','DEV010','Engine overheating after service','BANK009','ADDR009',0),
('CLM0015','PH0015','2026-02-07',68000.00,'PROV001','DEV002','Duplicate billing ring suspect','BANK002','ADDR002',1),
('CLM0016','PH0016','2026-02-08',14500.00,'PROV006','DEV011','Hail damage on vehicle roof','BANK010','ADDR010',0),
('CLM0017','PH0017','2026-02-09',22000.00,'PROV003','DEV012','Theft of personal belongings inside car','BANK011','ADDR011',0),
('CLM0018','PH0018','2026-02-10',75000.00,'PROV002','DEV001','Suspicious bodily injury claim','BANK001','ADDR001',1),
('CLM0019','PH0019','2026-02-11',11000.00,'PROV004','DEV013','Scratch marks repair','BANK012','ADDR012',0),
('CLM0020','PH0020','2026-02-12',19500.00,'PROV005','DEV014','Tire puncture and rim replacement','BANK013','ADDR013',0),
('CLM0021','PH0021','2026-02-13',61000.00,'PROV001','DEV002','Repeated provider billing anomaly','BANK002','ADDR002',1),
('CLM0022','PH0022','2026-02-14',13000.00,'PROV006','DEV015','Brake failure incident','BANK014','ADDR014',0),
('CLM0023','PH0023','2026-02-15',17500.00,'PROV003','DEV016','Flood damage indoors','BANK015','ADDR015',0),
('CLM0024','PH0024','2026-02-16',83000.00,'PROV002','DEV001','Shared bank account payout flag','BANK001','ADDR001',1),
('CLM0025','PH0025','2026-02-17',25000.00,'PROV004','DEV017','AC compression breakdown','BANK016','ADDR016',0),
('CLM0026','PH0026','2026-02-18',16000.00,'PROV005','DEV018','Door panel replacement','BANK017','ADDR017',0),
('CLM0027','PH0027','2026-02-19',79000.00,'PROV001','DEV005','Inflated medical invoices','BANK002','ADDR002',1),
('CLM0028','PH0028','2026-02-20',12000.00,'PROV006','DEV019','Glass crack repair','BANK018','ADDR018',0),
('CLM0029','PH0029','2026-02-21',21000.00,'PROV003','DEV020','Key loss and lock cylinder replacement','BANK019','ADDR019',0),
('CLM0030','PH0030','2026-02-22',88000.00,'PROV002','DEV001','High risk provider network link','BANK001','ADDR001',1),
('CLM0031','PH0031','2026-02-23',10500.00,'PROV004','DEV021','Headlight repair','BANK020','ADDR020',0),
('CLM0032','PH0032','2026-02-24',27000.00,'PROV005','DEV022','Transmission fluid leak','BANK021','ADDR021',0),
('CLM0033','PH0033','2026-02-25',64000.00,'PROV001','DEV002','Staged accident pattern match','BANK002','ADDR002',1),
('CLM0034','PH0034','2026-02-26',15500.00,'PROV006','DEV023','Minor scratches on bumper','BANK022','ADDR022',0),
('CLM0035','PH0035','2026-02-27',18500.00,'PROV003','DEV024','Shattered rear window','BANK023','ADDR023',0),
('CLM0036','PH0036','2026-02-28',71000.00,'PROV002','DEV001','Organized syndicate device reuse','BANK001','ADDR001',1),
('CLM0037','PH0037','2026-03-01',14000.00,'PROV004','DEV025','Water leak in home kitchen','BANK024','ADDR024',0),
('CLM0038','PH0038','2026-03-02',23000.00,'PROV005','DEV026','Electrical failure on dash','BANK025','ADDR025',0),
('CLM0039','PH0039','2026-03-03',69000.00,'PROV001','DEV005','Inflated surgical fees','BANK002','ADDR002',1),
('CLM0040','PH0040','2026-03-04',11500.00,'PROV006','DEV027','Dent repair on side door','BANK026','ADDR026',0),
('CLM0041','PH0041','2026-03-05',26000.00,'PROV003','DEV028','Radiator leak service','BANK027','ADDR027',0),
('CLM0042','PH0042','2026-03-06',85000.00,'PROV002','DEV001','High frequency claim submitter','BANK001','ADDR001',1),
('CLM0043','PH0043','2026-03-07',13500.00,'PROV004','DEV029','Battery failure towing','BANK028','ADDR028',0),
('CLM0044','PH0044','2026-03-08',29000.00,'PROV005','DEV030','Suspension damage repair','BANK029','ADDR029',0),
('CLM0045','PH0045','2026-03-09',59000.00,'PROV001','DEV002','Multiple claims connected to PROV001','BANK002','ADDR002',1),
('CLM0046','PH0046','2026-03-10',16500.00,'PROV006','DEV031','Minor home storm damage','BANK030','ADDR030',0),
('CLM0047','PH0047','2026-03-11',20500.00,'PROV003','DEV032','Exhaust pipe replacement','BANK031','ADDR031',0),
('CLM0048','PH0048','2026-03-12',91000.00,'PROV002','DEV001','Syndicate banking address link','BANK001','ADDR001',1),
('CLM0049','PH0049','2026-03-13',12800.00,'PROV004','DEV033','Shattered side mirror','BANK032','ADDR032',0),
('CLM0050','PH0050','2026-03-14',24000.00,'PROV005','DEV034','Minor fender bender','BANK033','ADDR033',0),
('CLM0051','PH0051','2026-03-15',73000.00,'PROV001','DEV005','Phantom billing ring suspect','BANK002','ADDR002',1),
('CLM0052','PH0052','2026-03-16',15000.00,'PROV006','DEV035','Car roof dent due to tree branch','BANK034','ADDR034',0),
('CLM0053','PH0053','2026-03-17',28000.00,'PROV003','DEV036','Brake system overhaul','BANK035','ADDR035',0),
('CLM0054','PH0054','2026-03-18',86000.00,'PROV002','DEV001','Suspicious bodily injury repeat','BANK001','ADDR001',1),
('CLM0055','PH0055','2026-03-19',11800.00,'PROV004','DEV037','Tire replacement after nail','BANK036','ADDR036',0),
('CLM0056','PH0056','2026-03-20',22500.00,'PROV005','DEV038','Water damage in home basement','BANK037','ADDR037',0),
('CLM0057','PH0057','2026-03-21',67000.00,'PROV001','DEV002','Shared bank account payout flag','BANK002','ADDR002',1),
('CLM0058','PH0058','2026-03-22',14200.00,'PROV006','DEV039','Bumper paint restoration','BANK038','ADDR038',0),
('CLM0059','PH0059','2026-03-23',19800.00,'PROV003','DEV040','Windshield crack propagation','BANK039','ADDR039',0),
('CLM0060','PH0060','2026-03-24',94000.00,'PROV002','DEV001','Total loss claim staged incident','BANK001','ADDR001',1),
('CLM0061','PH0061','2026-03-25',13200.00,'PROV004','DEV041','Minor garage dent','BANK040','ADDR040',0),
('CLM0062','PH0062','2026-03-26',25500.00,'PROV005','DEV042','Alternator breakdown towing','BANK041','ADDR041',0),
('CLM0063','PH0063','2026-03-27',63000.00,'PROV001','DEV005','Duplicate clinic bill submission','BANK002','ADDR002',1),
('CLM0064','PH0064','2026-03-28',16000.00,'PROV006','DEV043','Minor collision with parking post','BANK042','ADDR042',0),
('CLM0065','PH0065','2026-03-29',21500.00,'PROV003','DEV044','Key Fob replacement and sync','BANK043','ADDR043',0),
('CLM0066','PH0066','2026-03-30',77000.00,'PROV002','DEV001','Cross-policy shared device match','BANK001','ADDR001',1),
('CLM0067','PH0067','2026-03-31',10900.00,'PROV004','DEV045','Tail light glass crack','BANK044','ADDR044',0),
('CLM0068','PH0068','2026-04-01',30500.00,'PROV005','DEV046','Engine belt snap service','BANK045','ADDR045',0),
('CLM0069','PH0069','2026-04-02',70000.00,'PROV001','DEV002','High risk provider network link','BANK002','ADDR002',1),
('CLM0070','PH0070','2026-04-03',12500.00,'PROV006','DEV047','Scratched paint job','BANK046','ADDR046',0),
('CLM0071','PH0071','2026-04-04',18000.00,'PROV003','DEV048','Small pipe burst in bathroom','BANK047','ADDR047',0),
('CLM0072','PH0072','2026-04-05',82000.00,'PROV002','DEV001','Recycled bank account fraud pattern','BANK001','ADDR001',1),
('CLM0073','PH0073','2026-04-06',14800.00,'PROV004','DEV049','Side door latch repair','BANK048','ADDR048',0),
('CLM0074','PH0074','2026-04-07',23500.00,'PROV005','DEV050','Trunk hydraulic strut replacement','BANK049','ADDR049',0),
('CLM0075','PH0075','2026-04-08',66000.00,'PROV001','DEV005','Inflated medical invoices','BANK002','ADDR002',1),
('CLM0076','PH0076','2026-04-09',11200.00,'PROV006','DEV051','Windshield wiper motor service','BANK050','ADDR050',0),
('CLM0077','PH0077','2026-04-10',27500.00,'PROV003','DEV052','Oil pan leak repair','BANK051','ADDR051',0),
('CLM0078','PH0078','2026-04-11',90000.00,'PROV002','DEV001','Organized fraud ring cluster','BANK001','ADDR001',1),
('CLM0079','PH0079','2026-04-12',13900.00,'PROV004','DEV053','Rear view camera failure','BANK052','ADDR052',0),
('CLM0080','PH0080','2026-04-13',20000.00,'PROV005','DEV054','Minor fender scrape','BANK053','ADDR053',0),
('CLM0081','PH0081','2026-04-14',71500.00,'PROV001','DEV002','Repeated provider billing anomaly','BANK002','ADDR002',1),
('CLM0082','PH0082','2026-04-15',15200.00,'PROV006','DEV055','Airbag warning light sensor service','BANK054','ADDR054',0),
('CLM0083','PH0083','2026-04-16',22000.00,'PROV003','DEV056','Home window storm damage','BANK055','ADDR055',0),
('CLM0084','PH0084','2026-04-17',87000.00,'PROV002','DEV001','Device reuse velocity alert','BANK001','ADDR001',1),
('CLM0085','PH0085','2026-04-18',11700.00,'PROV004','DEV057','Flat tire towing cost','BANK056','ADDR056',0),
('CLM0086','PH0086','2026-04-19',24500.00,'PROV005','DEV058','Radiator fan failure','BANK057','ADDR057',0),
('CLM0087','PH0087','2026-04-20',68500.00,'PROV001','DEV005','Staged medical claim ring','BANK002','ADDR002',1),
('CLM0088','PH0088','2026-04-21',13000.00,'PROV006','DEV059','Door dent repair','BANK058','ADDR058',0),
('CLM0089','PH0089','2026-04-22',19000.00,'PROV003','DEV060','Sunroof seal leak','BANK059','ADDR059',0),
('CLM0090','PH0090','2026-04-23',93000.00,'PROV002','DEV001','Shared address and bank account link','BANK001','ADDR001',1),
('CLM0091','PH0091','2026-04-24',12100.00,'PROV004','DEV061','Headlight bulb socket repair','BANK060','ADDR060',0),
('CLM0092','PH0092','2026-04-25',26500.00,'PROV005','DEV062','Power steering pump fix','BANK061','ADDR061',0),
('CLM0093','PH0093','2026-04-26',65000.00,'PROV001','DEV002','Multiple claims connected to PROV001','BANK002','ADDR002',1),
('CLM0094','PH0094','2026-04-27',14100.00,'PROV006','DEV063','Minor car dent from shopping cart','BANK062','ADDR062',0),
('CLM0095','PH0095','2026-04-28',21000.00,'PROV003','DEV064','Brake pad replacement','BANK063','ADDR063',0),
('CLM0096','PH0096','2026-04-29',84000.00,'PROV002','DEV001','Syndicate network ring match','BANK001','ADDR001',1),
('CLM0097','PH0097','2026-04-30',11600.00,'PROV004','DEV065','Horn replacement service','BANK064','ADDR064',0),
('CLM0098','PH0098','2026-05-01',23800.00,'PROV005','DEV066','Exhaust manifold crack fix','BANK065','ADDR065',0),
('CLM0099','PH0099','2026-05-02',76000.00,'PROV001','DEV005','Phantom treatment invoice suspect','BANK002','ADDR002',1),
('CLM0100','PH0100','2026-05-03',18200.00,'PROV006','DEV067','Clean record minor fender repair','BANK066','ADDR066',0);

-- =====================================
-- verification_records.sql
-- =====================================

INSERT INTO verification_records (claim_id, customer_exists, provider_verified, policy_active, previous_claims, previous_fraud, bank_account_verified, device_reuse_count, shared_bank_count, shared_address_count, provider_risk, verification_summary) VALUES
('CLM0001',1,1,1,5,1,1,3,3,3,'High','Device DEV001 reused; bank BANK001 shared; address ADDR001 shared; provider PROV002 flagged.'),
('CLM0002',1,1,1,7,2,1,2,3,3,'High','Provider PROV001 appears in multiple claims; bank BANK002 shared; address ADDR002 shared.'),
('CLM0003',1,1,1,0,0,1,0,0,0,'Low','Unique device, bank account, and address. No prior fraud history.'),
('CLM0004',1,1,1,8,3,1,3,3,3,'High','Device DEV001 reused; bank BANK001 shared; address ADDR001 shared; 8 prior claims.'),
('CLM0005',1,1,1,1,0,1,0,0,0,'Low','Clean record. No shared entities detected.'),
('CLM0006',1,1,1,9,2,1,2,3,3,'High','Provider PROV001 appears in multiple claims; bank BANK002 shared; address ADDR002 shared.'),
('CLM0007',1,1,1,2,0,1,0,0,0,'Low','Clean record. Unique device and bank account.'),
('CLM0008',1,1,1,6,1,1,3,3,3,'Medium','Device DEV001 shared; bank BANK001 shared; address ADDR001 shared.'),
('CLM0009',1,1,1,1,0,1,0,0,0,'Low','Clean record. No shared entities.'),
('CLM0010',1,1,1,10,4,1,2,3,3,'High','Provider PROV001 appears in multiple claims; bank BANK002 shared; highest risk.'),
('CLM0011',1,1,1,1,0,1,0,0,0,'Low','Clean record. No shared entities.'),
('CLM0012',1,1,1,6,2,1,3,3,3,'High','Device DEV001 reused; bank BANK001 shared; address ADDR001 shared.'),
('CLM0013',1,1,1,0,0,1,0,0,0,'Low','Clean record. Unique device.'),
('CLM0014',1,1,1,2,0,1,0,0,0,'Low','Clean record. Unique bank account.'),
('CLM0015',1,1,1,5,1,1,2,3,3,'High','Provider PROV001 appears in multiple claims; shared bank account.'),
('CLM0016',1,1,1,1,0,1,0,0,0,'Low','Clean record.'),
('CLM0017',1,1,1,0,0,1,0,0,0,'Low','Clean record.'),
('CLM0018',1,1,1,7,3,1,3,3,3,'High','Device DEV001 reused; bank BANK001 shared.'),
('CLM0019',1,1,1,1,0,1,0,0,0,'Low','Clean record.'),
('CLM0020',1,1,1,0,0,1,0,0,0,'Low','Clean record.'),
('CLM0021',1,1,1,8,2,1,2,3,3,'High','Provider PROV001 billing anomaly.'),
('CLM0022',1,1,1,1,0,1,0,0,0,'Low','Clean record.'),
('CLM0023',1,1,1,2,0,1,0,0,0,'Low','Clean record.'),
('CLM0024',1,1,1,9,4,1,3,3,3,'High','Shared bank account payout flag.'),
('CLM0025',1,1,1,0,0,1,0,0,0,'Low','Clean record.'),
('CLM0026',1,1,1,1,0,1,0,0,0,'Low','Clean record.'),
('CLM0027',1,1,1,6,2,1,2,3,3,'High','Inflated medical invoices.'),
('CLM0028',1,1,1,0,0,1,0,0,0,'Low','Clean record.'),
('CLM0029',1,1,1,1,0,1,0,0,0,'Low','Clean record.'),
('CLM0030',1,1,1,8,3,1,3,3,3,'High','High risk provider network link.'),
('CLM0031',1,1,1,0,0,1,0,0,0,'Low','Clean record.'),
('CLM0032',1,1,1,2,0,1,0,0,0,'Low','Clean record.'),
('CLM0033',1,1,1,5,1,1,2,3,3,'High','Staged accident pattern match.'),
('CLM0034',1,1,1,1,0,1,0,0,0,'Low','Clean record.'),
('CLM0035',1,1,1,0,0,1,0,0,0,'Low','Clean record.'),
('CLM0036',1,1,1,7,2,1,3,3,3,'High','Organized syndicate device reuse.'),
('CLM0037',1,1,1,1,0,1,0,0,0,'Low','Clean record.'),
('CLM0038',1,1,1,0,0,1,0,0,0,'Low','Clean record.'),
('CLM0039',1,1,1,9,3,1,2,3,3,'High','Inflated surgical fees.'),
('CLM0040',1,1,1,2,0,1,0,0,0,'Low','Clean record.'),
('CLM0041',1,1,1,1,0,1,0,0,0,'Low','Clean record.'),
('CLM0042',1,1,1,10,4,1,3,3,3,'High','High frequency claim submitter.'),
('CLM0043',1,1,1,0,0,1,0,0,0,'Low','Clean record.'),
('CLM0044',1,1,1,1,0,1,0,0,0,'Low','Clean record.'),
('CLM0045',1,1,1,6,1,1,2,3,3,'High','Multiple claims connected to PROV001.'),
('CLM0046',1,1,1,0,0,1,0,0,0,'Low','Clean record.'),
('CLM0047',1,1,1,2,0,1,0,0,0,'Low','Clean record.'),
('CLM0048',1,1,1,8,3,1,3,3,3,'High','Syndicate banking address link.'),
('CLM0049',1,1,1,1,0,1,0,0,0,'Low','Clean record.'),
('CLM0050',1,1,1,0,0,1,0,0,0,'Low','Clean record.'),
('CLM0051',1,1,1,7,2,1,2,3,3,'High','Phantom billing ring suspect.'),
('CLM0052',1,1,1,1,0,1,0,0,0,'Low','Clean record.'),
('CLM0053',1,1,1,0,0,1,0,0,0,'Low','Clean record.'),
('CLM0054',1,1,1,9,3,1,3,3,3,'High','Suspicious bodily injury repeat.'),
('CLM0055',1,1,1,2,0,1,0,0,0,'Low','Clean record.'),
('CLM0056',1,1,1,1,0,1,0,0,0,'Low','Clean record.'),
('CLM0057',1,1,1,6,1,1,2,3,3,'High','Shared bank account payout flag.'),
('CLM0058',1,1,1,0,0,1,0,0,0,'Low','Clean record.'),
('CLM0059',1,1,1,1,0,1,0,0,0,'Low','Clean record.'),
('CLM0060',1,1,1,10,4,1,3,3,3,'High','Total loss claim staged incident.'),
('CLM0061',1,1,1,0,0,1,0,0,0,'Low','Clean record.'),
('CLM0062',1,1,1,2,0,1,0,0,0,'Low','Clean record.'),
('CLM0063',1,1,1,5,1,1,2,3,3,'High','Duplicate clinic bill submission.'),
('CLM0064',1,1,1,1,0,1,0,0,0,'Low','Clean record.'),
('CLM0065',1,1,1,0,0,1,0,0,0,'Low','Clean record.'),
('CLM0066',1,1,1,8,3,1,3,3,3,'High','Cross-policy shared device match.'),
('CLM0067',1,1,1,1,0,1,0,0,0,'Low','Clean record.'),
('CLM0068',1,1,1,2,0,1,0,0,0,'Low','Clean record.'),
('CLM0069',1,1,1,7,2,1,2,3,3,'High','High risk provider network link.'),
('CLM0070',1,1,1,0,0,1,0,0,0,'Low','Clean record.'),
('CLM0071',1,1,1,1,0,1,0,0,0,'Low','Clean record.'),
('CLM0072',1,1,1,9,4,1,3,3,3,'High','Recycled bank account fraud pattern.'),
('CLM0073',1,1,1,0,0,1,0,0,0,'Low','Clean record.'),
('CLM0074',1,1,1,2,0,1,0,0,0,'Low','Clean record.'),
('CLM0075',1,1,1,6,1,1,2,3,3,'High','Inflated medical invoices.'),
('CLM0076',1,1,1,1,0,1,0,0,0,'Low','Clean record.'),
('CLM0077',1,1,1,0,0,1,0,0,0,'Low','Clean record.'),
('CLM0078',1,1,1,8,3,1,3,3,3,'High','Organized fraud ring cluster.'),
('CLM0079',1,1,1,1,0,1,0,0,0,'Low','Clean record.'),
('CLM0080',1,1,1,0,0,1,0,0,0,'Low','Clean record.'),
('CLM0081',1,1,1,7,2,1,2,3,3,'High','Repeated provider billing anomaly.'),
('CLM0082',1,1,1,1,0,1,0,0,0,'Low','Clean record.'),
('CLM0083',1,1,1,2,0,1,0,0,0,'Low','Clean record.'),
('CLM0084',1,1,1,9,3,1,3,3,3,'High','Device reuse velocity alert.'),
('CLM0085',1,1,1,0,0,1,0,0,0,'Low','Clean record.'),
('CLM0086',1,1,1,1,0,1,0,0,0,'Low','Clean record.'),
('CLM0087',1,1,1,6,1,1,2,3,3,'High','Staged medical claim ring.'),
('CLM0088',1,1,1,0,0,1,0,0,0,'Low','Clean record.'),
('CLM0089',1,1,1,2,0,1,0,0,0,'Low','Clean record.'),
('CLM0090',1,1,1,10,4,1,3,3,3,'High','Shared address and bank account link.'),
('CLM0091',1,1,1,1,0,1,0,0,0,'Low','Clean record.'),
('CLM0092',1,1,1,0,0,1,0,0,0,'Low','Clean record.'),
('CLM0093',1,1,1,5,1,1,2,3,3,'High','Multiple claims connected to PROV001.'),
('CLM0094',1,1,1,1,0,1,0,0,0,'Low','Clean record.'),
('CLM0095',1,1,1,2,0,1,0,0,0,'Low','Clean record.'),
('CLM0096',1,1,1,8,3,1,3,3,3,'High','Syndicate network ring match.'),
('CLM0097',1,1,1,0,0,1,0,0,0,'Low','Clean record.'),
('CLM0098',1,1,1,1,0,1,0,0,0,'Low','Clean record.'),
('CLM0099',1,1,1,7,2,1,2,3,3,'High','Phantom treatment invoice suspect.'),
('CLM0100',1,1,1,0,0,1,0,0,0,'Low','Clean record minor fender repair.');

-- =====================================
-- claim_relationships.sql
-- =====================================

INSERT INTO claim_relationships (claim_id, node_type, node_id)
SELECT claim_id, 'POLICYHOLDER', policyholder_id FROM claims
UNION ALL
SELECT claim_id, 'PROVIDER', provider_id FROM claims
UNION ALL
SELECT claim_id, 'DEVICE', device_fingerprint FROM claims
UNION ALL
SELECT claim_id, 'BANK', bank_account FROM claims
UNION ALL
SELECT claim_id, 'ADDRESS', address FROM claims;

-- =====================================
-- historical_fraud_patterns.sql
-- =====================================

INSERT INTO historical_fraud_patterns (pattern_id, fraud_type, embedding_text, risk_level) VALUES
('PAT001', 'Staged Accident', 'Multiple policyholders used the same repair garage, identical accident descriptions, and shared device fingerprints.', 'HIGH'),
('PAT002', 'Medical Billing Fraud', 'Claims contain duplicate hospital invoices, inflated treatment costs, and repeated providers.', 'HIGH'),
('PAT003', 'Identity Fraud', 'Different customers submitted claims from the same mobile device and bank account.', 'HIGH'),
('PAT004', 'Organized Fraud Ring', 'Several claims share provider, payout account, witness names, and filing location.', 'CRITICAL'),
('PAT005', 'Low Risk Claim', 'Small claim with unique provider, device, and no prior fraud history.', 'LOW'),
('PAT006', 'Phantom Medical Treatment', 'Billing for treatments or diagnostic scans that were never rendered by the provider facility.', 'HIGH'),
('PAT007', 'Device Velocity Anomaly', 'Multiple claims submitted within minutes using identical hardware fingerprints and IP subnets.', 'CRITICAL'),
('PAT008', 'Recycled Bank Account Payout', 'Different policyholder names routing settlement payouts into identical bank account numbers.', 'CRITICAL'),
('PAT009', 'Inflated Property Loss', 'Exaggerated inventory replacement claims backed by fabricated purchase receipts.', 'MEDIUM'),
('PAT010', 'Syndicate Towing Ring', 'Unreasonable towing and vehicle storage fees charged by affiliated collusion garages.', 'HIGH');

-- =====================================
-- enrich.sql
-- =====================================

UPDATE claims SET bank_account = 'BANK001', address = 'ADDR001', fraud_label = 1 WHERE claim_id = 'CLM0001';
UPDATE claims SET bank_account = 'BANK002', address = 'ADDR002', fraud_label = 1 WHERE claim_id = 'CLM0002';
UPDATE claims SET bank_account = 'BANK003', address = 'ADDR003', fraud_label = 0 WHERE claim_id = 'CLM0003';
UPDATE claims SET bank_account = 'BANK001', address = 'ADDR001', fraud_label = 1 WHERE claim_id = 'CLM0004';
UPDATE claims SET bank_account = 'BANK004', address = 'ADDR004', fraud_label = 0 WHERE claim_id = 'CLM0005';
UPDATE claims SET bank_account = 'BANK002', address = 'ADDR002', fraud_label = 1 WHERE claim_id = 'CLM0006';
UPDATE claims SET bank_account = 'BANK005', address = 'ADDR005', fraud_label = 0 WHERE claim_id = 'CLM0007';
UPDATE claims SET bank_account = 'BANK001', address = 'ADDR001', fraud_label = 1 WHERE claim_id = 'CLM0008';
UPDATE claims SET bank_account = 'BANK006', address = 'ADDR006', fraud_label = 0 WHERE claim_id = 'CLM0009';
UPDATE claims SET bank_account = 'BANK002', address = 'ADDR002', fraud_label = 1 WHERE claim_id = 'CLM0010';

INSERT OR IGNORE INTO claim_relationships VALUES
  ('CLM0001','ADDRESS','ADDR001'),
  ('CLM0002','ADDRESS','ADDR002'),
  ('CLM0003','ADDRESS','ADDR003'),
  ('CLM0004','ADDRESS','ADDR001'),
  ('CLM0005','ADDRESS','ADDR004'),
  ('CLM0006','ADDRESS','ADDR002'),
  ('CLM0007','ADDRESS','ADDR005'),
  ('CLM0008','ADDRESS','ADDR001'),
  ('CLM0009','ADDRESS','ADDR006'),
  ('CLM0010','ADDRESS','ADDR002');

UPDATE verification_records SET device_reuse_count = 3, shared_bank_count = 3, shared_address_count = 3, provider_risk = 'High', verification_summary = 'Device DEV001 reused across 3 claims; bank BANK001 shared by 3 policyholders; address ADDR001 shared by 3 claims; provider PROV002 flagged.' WHERE claim_id = 'CLM0001';
UPDATE verification_records SET device_reuse_count = 2, shared_bank_count = 3, shared_address_count = 3, provider_risk = 'High', verification_summary = 'Provider PROV001 appears in 4 claims; bank BANK002 shared by 3 policyholders; address ADDR002 shared by 3 claims.' WHERE claim_id = 'CLM0002';
UPDATE verification_records SET device_reuse_count = 0, shared_bank_count = 0, shared_address_count = 0, provider_risk = 'Low', verification_summary = 'Unique device, bank account, and address. No prior fraud history.' WHERE claim_id = 'CLM0003';
UPDATE verification_records SET device_reuse_count = 3, shared_bank_count = 3, shared_address_count = 3, provider_risk = 'High', verification_summary = 'Device DEV001 reused across 3 claims; bank BANK001 shared; address ADDR001 shared; 8 prior claims, 3 fraud cases on record.' WHERE claim_id = 'CLM0004';
UPDATE verification_records SET device_reuse_count = 0, shared_bank_count = 0, shared_address_count = 0, provider_risk = 'Low', verification_summary = 'Clean record. No shared entities detected.' WHERE claim_id = 'CLM0005';
UPDATE verification_records SET device_reuse_count = 2, shared_bank_count = 3, shared_address_count = 3, provider_risk = 'High', verification_summary = 'Provider PROV001 appears in 4 claims; bank BANK002 shared; address ADDR002 shared; 9 prior claims, 2 fraud cases.' WHERE claim_id = 'CLM0006';
UPDATE verification_records SET device_reuse_count = 0, shared_bank_count = 0, shared_address_count = 0, provider_risk = 'Low', verification_summary = 'Clean record. Unique device and bank account.' WHERE claim_id = 'CLM0007';
UPDATE verification_records SET device_reuse_count = 3, shared_bank_count = 3, shared_address_count = 3, provider_risk = 'Medium', verification_summary = 'Device DEV001 shared; bank BANK001 shared; address ADDR001 shared; 6 prior claims, 1 fraud case.' WHERE claim_id = 'CLM0008';
UPDATE verification_records SET device_reuse_count = 0, shared_bank_count = 0, shared_address_count = 0, provider_risk = 'Low', verification_summary = 'Clean record. No shared entities.' WHERE claim_id = 'CLM0009';
UPDATE verification_records SET device_reuse_count = 2, shared_bank_count = 3, shared_address_count = 3, provider_risk = 'High', verification_summary = 'Provider PROV001 appears in 4 claims; bank BANK002 shared; address ADDR002 shared; 10 prior claims, 4 fraud cases — highest risk in dataset.' WHERE claim_id = 'CLM0010';

ALTER TABLE claims ADD COLUMN bank_account TEXT;
ALTER TABLE claims ADD COLUMN address TEXT;
ALTER TABLE claims ADD COLUMN fraud_label INTEGER DEFAULT 0;

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

ALTER TABLE verification_records ADD COLUMN bank_account_verified INTEGER DEFAULT 1;
ALTER TABLE verification_records ADD COLUMN device_reuse_count INTEGER DEFAULT 0;
ALTER TABLE verification_records ADD COLUMN shared_bank_count INTEGER DEFAULT 0;
ALTER TABLE verification_records ADD COLUMN shared_address_count INTEGER DEFAULT 0;
ALTER TABLE verification_records ADD COLUMN provider_risk TEXT DEFAULT 'Low';
ALTER TABLE verification_records ADD COLUMN verification_summary TEXT;

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

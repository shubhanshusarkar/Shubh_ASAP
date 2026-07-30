INSERT INTO historical_fraud_patterns VALUES
('PAT001',
'Staged Accident',
'Multiple policyholders used the same repair garage, identical accident descriptions, and shared device fingerprints.',
'HIGH'),

('PAT002',
'Medical Billing Fraud',
'Claims contain duplicate hospital invoices, inflated treatment costs, and repeated providers.',
'HIGH'),

('PAT003',
'Identity Fraud',
'Different customers submitted claims from the same mobile device and bank account.',
'HIGH'),

('PAT004',
'Organized Fraud Ring',
'Several claims share provider, payout account, witness names, and filing location.',
'CRITICAL'),

('PAT005',
'Low Risk Claim',
'Small claim with unique provider, device, and no prior fraud history.',
'LOW');

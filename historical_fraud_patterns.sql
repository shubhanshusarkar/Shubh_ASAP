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

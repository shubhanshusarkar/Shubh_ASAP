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

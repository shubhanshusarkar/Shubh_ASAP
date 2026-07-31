INSERT INTO verification_records (
    claim_id, customer_exists, provider_verified, policy_active, 
    previous_claims, previous_fraud, bank_account_verified, 
    device_reuse_count, shared_bank_count, shared_address_count, provider_risk, verification_summary
)
SELECT 
    c.claim_id,
    1 AS customer_exists,
    1 AS provider_verified,
    1 AS policy_active,
    FLOOR(RANDOM() * 8)::INT AS previous_claims,
    CASE WHEN c.fraud_label = 1 THEN FLOOR(1 + RANDOM() * 3)::INT ELSE 0 END AS previous_fraud,
    1 AS bank_account_verified,
    CASE WHEN c.device_fingerprint = 'DEV001' THEN 33 ELSE 1 END AS device_reuse_count,
    CASE WHEN c.bank_account = 'BANK001' THEN 33 ELSE 1 END AS shared_bank_count,
    CASE WHEN c.address = 'ADDR001' THEN 33 ELSE 1 END AS shared_address_count,
    CASE WHEN c.fraud_label = 1 THEN 'High' ELSE 'Low' END AS provider_risk,
    CASE 
        WHEN c.fraud_label = 1 THEN 'Flagged: High shared entity count (Device/Bank/Address) detected across syndicate ring.'
        ELSE 'Clean record. Standard verification passed with no shared high-risk entities.'
    END AS verification_summary
FROM claims c;

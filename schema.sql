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

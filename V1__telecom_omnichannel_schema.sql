-- =============================================================================
-- TELECOM OMNICHANNEL CARE AGENT - DATABASE SCHEMA & SYNTHETIC SEED DATA
-- Database Engine: PostgreSQL 15+ (with pgvector extension)
-- =============================================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "vector"; -- Used for Knowledge Base RAG Search

-- =============================================================================
-- 1. SUBSCRIBER & BILLING DOMAIN
-- =============================================================================

CREATE TABLE service_plans (
    plan_id VARCHAR(32) PRIMARY KEY,
    plan_name VARCHAR(100) NOT NULL,
    data_limit_gb NUMERIC(6,2) NOT NULL, -- e.g. 50.00 GB (or -1 for unlimited)
    monthly_rate_usd NUMERIC(6,2) NOT NULL,
    has_5g BOOLEAN DEFAULT TRUE,
    roaming_included BOOLEAN DEFAULT FALSE
);

CREATE TABLE subscribers (
    account_number VARCHAR(20) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(15) UNIQUE NOT NULL,
    authenticated_role VARCHAR(20) DEFAULT 'AuthorizedUser' CHECK (authenticated_role IN ('AccountHolder', 'AuthorizedUser', 'Guest')),
    plan_id VARCHAR(32) REFERENCES service_plans(plan_id),
    device_type VARCHAR(100) NOT NULL,
    device_imei VARCHAR(18) UNIQUE,
    home_tower_id VARCHAR(32) NOT NULL,
    account_status VARCHAR(20) DEFAULT 'ACTIVE' CHECK (account_status IN ('ACTIVE', 'SUSPENDED', 'PENDING')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE data_usage_billing (
    usage_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    account_number VARCHAR(20) REFERENCES subscribers(account_number) ON DELETE CASCADE,
    billing_cycle_start DATE NOT NULL,
    billing_cycle_end DATE NOT NULL,
    data_used_gb NUMERIC(6,2) NOT NULL DEFAULT 0.00,
    current_bill_usd NUMERIC(8,2) NOT NULL DEFAULT 0.00,
    payment_due_date DATE NOT NULL,
    payment_status VARCHAR(20) DEFAULT 'UNPAID' CHECK (payment_status IN ('PAID', 'UNPAID', 'OVERDUE', 'AUTOPAY'))
);

-- Index for instant lookup during authenticated intent checks
CREATE INDEX idx_subscribers_auth ON subscribers(account_number, authenticated_role);

-- =============================================================================
-- 2. NETWORK HEALTH & DIAGNOSTICS DOMAIN
-- =============================================================================

CREATE TABLE cell_towers (
    tower_id VARCHAR(32) PRIMARY KEY,
    region VARCHAR(50) NOT NULL,
    latitude NUMERIC(9,6) NOT NULL,
    longitude NUMERIC(9,6) NOT NULL,
    outage_status VARCHAR(20) DEFAULT 'OPERATIONAL' CHECK (outage_status IN ('OPERATIONAL', 'DEGRADED', 'OUTAGE', 'MAINTENANCE')),
    signal_strength_dbm INT CHECK (signal_strength_dbm BETWEEN -140 AND -40), -- e.g. -85 dBm
    active_connections INT DEFAULT 0,
    last_ping_timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE network_tickets (
    ticket_id VARCHAR(32) PRIMARY KEY,
    tower_id VARCHAR(32) REFERENCES cell_towers(tower_id),
    issue_type VARCHAR(50) NOT NULL,
    severity VARCHAR(20) CHECK (severity IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')),
    status VARCHAR(20) DEFAULT 'OPEN' CHECK (status IN ('OPEN', 'IN_PROGRESS', 'RESOLVED')),
    estimated_resolution TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_towers_outage ON cell_towers(tower_id, outage_status);

-- =============================================================================
-- 3. KNOWLEDGE BASE DOMAIN (Vector Store for RAG)
-- =============================================================================

CREATE TABLE knowledge_base (
    kb_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category VARCHAR(50) NOT NULL, -- 'Billing', 'Troubleshooting', 'Plans', 'General'
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    embedding vector(1536), -- Standard size for text-embedding-3-small or similar
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_kb_category ON knowledge_base(category);

-- =============================================================================
-- 4. COMPLIANCE & CPNI AUDIT LOGS
-- =============================================================================

CREATE TABLE cpni_audit_logs (
    log_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id VARCHAR(64) NOT NULL,
    account_number VARCHAR(20) REFERENCES subscribers(account_number),
    authenticated_role VARCHAR(20) NOT NULL,
    channel VARCHAR(20) CHECK (channel IN ('WEB_CHAT', 'MOBILE_APP', 'SMS', 'VOICE_IVR')),
    queried_intent VARCHAR(50) NOT NULL,
    pii_redacted_prompt TEXT NOT NULL,
    cpni_data_accessed BOOLEAN DEFAULT FALSE,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================================
-- SEED DATA INSERTION
-- =============================================================================

-- 1. Insert Service Plans
INSERT INTO service_plans (plan_id, plan_name, data_limit_gb, monthly_rate_usd, has_5g, roaming_included) VALUES
('PLAN_UNL_5G', 'Unlimited Elite 5G', 100.00, 85.00, TRUE, TRUE),
('PLAN_50GB', 'Plus Family 50GB', 50.00, 55.00, TRUE, FALSE),
('PLAN_BASIC_10GB', 'Starter 10GB', 10.00, 30.00, FALSE, FALSE);

-- 2. Insert Cell Towers
INSERT INTO cell_towers (tower_id, region, latitude, longitude, outage_status, signal_strength_dbm, active_connections) VALUES
('TWR-NY-001', 'New York - Midtown', 40.754932, -73.984012, 'OPERATIONAL', -72, 1420),
('TWR-NY-002', 'New York - Downtown', 40.712776, -74.005974, 'DEGRADED', -105, 2100),
('TWR-CA-104', 'Los Angeles - Downtown', 34.052235, -118.243683, 'OUTAGE', -128, 0);

-- 3. Insert Network Incident Tickets
INSERT INTO network_tickets (ticket_id, tower_id, issue_type, severity, status, estimated_resolution) VALUES
('TCK-88201', 'TWR-NY-002', 'Fiber Backhaul Congestion', 'MEDIUM', 'IN_PROGRESS', CURRENT_TIMESTAMP + INTERVAL '4 hours'),
('TCK-99410', 'TWR-CA-104', 'Hardware Power Unit Failure', 'CRITICAL', 'OPEN', CURRENT_TIMESTAMP + INTERVAL '8 hours');

-- 4. Insert Subscribers
INSERT INTO subscribers (account_number, first_name, last_name, email, phone_number, authenticated_role, plan_id, device_type, device_imei, home_tower_id, account_status) VALUES
('ACC-10029384', 'Andre', 'Wallace', 'andre.wallace@example.com', '+15550192834', 'AccountHolder', 'PLAN_UNL_5G', 'iPhone 15 Pro Max', '356938030000001', 'TWR-NY-001', 'ACTIVE'),
('ACC-55920194', 'Elena', 'Rostova', 'elena.r@example.com', '+15550183392', 'AccountHolder', 'PLAN_50GB', 'Samsung Galaxy S24', '356938030000002', 'TWR-NY-002', 'ACTIVE'),
('ACC-33019283', 'Marcus', 'Chen', 'm.chen@example.com', '+15550172281', 'AuthorizedUser', 'PLAN_BASIC_10GB', 'Google Pixel 8', '356938030000003', 'TWR-CA-104', 'ACTIVE');

-- 5. Insert Usage & Billing Info
INSERT INTO data_usage_billing (account_number, billing_cycle_start, billing_cycle_end, data_used_gb, current_bill_usd, payment_due_date, payment_status) VALUES
('ACC-10029384', '2026-07-01', '2026-07-31', 42.15, 85.00, '2026-08-15', 'AUTOPAY'),
('ACC-55920194', '2026-07-01', '2026-07-31', 48.90, 55.00, '2026-08-15', 'UNPAID'),
('ACC-33019283', '2026-07-01', '2026-07-31', 10.00, 45.00, '2026-08-05', 'OVERDUE'); -- Exceeded 10GB with overage charge

-- 6. Insert Knowledge Base Records
INSERT INTO knowledge_base (category, title, content) VALUES
('Billing', 'Understanding Data Overage Charges', 'If you exceed your monthly high-speed data cap on the Starter 10GB plan, additional data is automatically billed at $15.00 per 1GB block, up to a maximum of 3 blocks per billing cycle.'),
('Troubleshooting', 'How to Reset Network Settings on iOS and Android', 'For iOS: Go to Settings > General > Transfer or Reset iPhone > Reset > Reset Network Settings. For Android: Go to Settings > System > Reset options > Reset Wi-Fi, mobile & Bluetooth.'),
('Plans', 'International Data Roaming Policies', 'Unlimited Elite 5G includes free high-speed data in Canada and Mexico. International Roaming passes for Europe and Asia can be activated for $10/day by texting ROAM to 611.');

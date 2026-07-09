-- Create schema
CREATE SCHEMA IF NOT EXISTS raw;


-- =========================
-- Projects
-- =========================

CREATE TABLE raw.projects (
    project_id INTEGER PRIMARY KEY,
    fobbing_plan NUMERIC,
    export_tax_plan NUMERIC,
    profit_plan NUMERIC,
    cost_of_goods_plan NUMERIC,
    price_ctr_manual NUMERIC
);


-- =========================
-- Vessels
-- =========================

CREATE TABLE raw.vessels (
    vessel_id INTEGER PRIMARY KEY,
    name TEXT,
    shipped_mt NUMERIC,
    loading_port TEXT,
    loading_date DATE,
    discharge_port TEXT,
    project_id INTEGER,

    CONSTRAINT fk_vessels_project
        FOREIGN KEY (project_id)
        REFERENCES raw.projects(project_id)
);


-- =========================
-- Counterparts
-- =========================

CREATE TABLE raw.counterparts (
    counterpart_id INTEGER PRIMARY KEY,
    name TEXT,
    inn TEXT,
    org_type TEXT
);


-- =========================
-- Contract types
-- =========================

CREATE TABLE raw.contract_types (
    contract_type_id INTEGER PRIMARY KEY,
    name TEXT
);


-- =========================
-- Contract groups
-- =========================

CREATE TABLE raw.contract_groups (
    contract_group_id INTEGER PRIMARY KEY,
    group_type TEXT,
    commodity TEXT,
    basis TEXT,
    loading_place TEXT,
    quality TEXT,
    needs_vessel_alloc BOOLEAN,
    vessel_id INTEGER,
    vessel_id_loose_manual INTEGER,

    CONSTRAINT fk_contract_groups_vessel
        FOREIGN KEY (vessel_id)
        REFERENCES raw.vessels(vessel_id)
);


-- =========================
-- Contracts
-- =========================

CREATE TABLE raw.contracts (
    contract_id INTEGER PRIMARY KEY,
    counterpart_id INTEGER,
    date DATE,
    number TEXT,
    quantity_mt NUMERIC,
    delivery_due_date DATE,
    total_by_ctr NUMERIC,
    price_without_vat NUMERIC,
    vat NUMERIC,
    price_with_vat NUMERIC,
    shipped_by_supplier_mt NUMERIC,
    received_on_wh_mt NUMERIC,
    contract_group_id INTEGER,
    contract_type_id INTEGER,

    CONSTRAINT fk_contracts_counterpart
        FOREIGN KEY (counterpart_id)
        REFERENCES raw.counterparts(counterpart_id),

    CONSTRAINT fk_contracts_group
        FOREIGN KEY (contract_group_id)
        REFERENCES raw.contract_groups(contract_group_id),

    CONSTRAINT fk_contracts_type
        FOREIGN KEY (contract_type_id)
        REFERENCES raw.contract_types(contract_type_id)
);


-- =========================
-- Vessel allocation
-- =========================

CREATE TABLE raw.vessel_allocation (
    vessel_allocation_id INTEGER PRIMARY KEY,
    vessel_id INTEGER,
    contract_id INTEGER,
    quantity_allocated_mt NUMERIC,
    quantity_planned_mt NUMERIC,

    CONSTRAINT fk_vessel_allocation_vessel
        FOREIGN KEY (vessel_id)
        REFERENCES raw.vessels(vessel_id),

    CONSTRAINT fk_vessel_allocation_contract
        FOREIGN KEY (contract_id)
        REFERENCES raw.contracts(contract_id)
);


-- =========================
-- Payments
-- =========================

CREATE TABLE raw.payments (
    payment_id INTEGER PRIMARY KEY,
    internal_number TEXT,
    payment_date DATE,
    contract_id INTEGER,
    counterpart_id INTEGER,
    received_rub NUMERIC,
    paid_rub NUMERIC,
    operation_type TEXT,

    CONSTRAINT fk_payments_contract
        FOREIGN KEY (contract_id)
        REFERENCES raw.contracts(contract_id),

    CONSTRAINT fk_payments_counterpart
        FOREIGN KEY (counterpart_id)
        REFERENCES raw.counterparts(counterpart_id)
);
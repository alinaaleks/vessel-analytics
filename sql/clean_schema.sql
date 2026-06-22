CREATE SCHEMA clean;

CREATE TABLE clean.projects (
    project_id      INT PRIMARY KEY,
    project_code    TEXT,
    fobbing         NUMERIC,
    export_tax     NUMERIC,
    profit_calc    NUMERIC,
    cost_of_goods  NUMERIC,
    comment        TEXT
);

CREATE TABLE clean.vessels (
    vessel_id       INT PRIMARY KEY,
    name            TEXT,
    shipped_mt      NUMERIC,
    loading_port    TEXT,
    loading_date    DATE,
    discharge_port  TEXT,
    project_id      INT,
    vessel_code     TEXT
);

CREATE TABLE clean.counterparts (
    counterpart_id  INT PRIMARY KEY,
    name            TEXT,
    inn             TEXT
);

CREATE TABLE clean.contract_groups (
    contract_group_id  INT PRIMARY KEY,
    group_type         TEXT,
    description        TEXT,
    comment            TEXT,
    cost_of_goods      NUMERIC,
    cost_of_transport  NUMERIC,
    cost_of_agent      NUMERIC
);

CREATE TABLE clean.contracts (
    contract_id              INT PRIMARY KEY,
    counterpart_id           INT,
    counterpart_name         TEXT,
    date                     DATE,
    number                   TEXT,
    subject                  TEXT,
    commodity                TEXT,
    quantity                NUMERIC,
    basis                   TEXT,
    loading_place          TEXT,
    delivery_period        TEXT,
    total_by_contract      NUMERIC,
    total_by_payments      NUMERIC,
    total_calc             NUMERIC,
    price_without_vat      NUMERIC,
    vat                    NUMERIC,
    price_with_vat        NUMERIC,
    shipped_by_supplier_mt NUMERIC,
    received_on_wh_mt     NUMERIC,
    quality               TEXT,
    contract_group_id      INT,
    type                  TEXT
);

CREATE TABLE clean.vessel_allocation (
    vessel_allocation_id  INT PRIMARY KEY,
    vessel_id             INT,
    contract_id           INT,
    quantity_allocated    NUMERIC
);

CREATE TABLE clean.budget_categories (
    budget_category_id INT PRIMARY KEY,
    name               TEXT
);

CREATE TABLE clean.payments (
    payment_id          INT PRIMARY KEY,
    internal_number     TEXT,
    payment_date        DATE,
	contract_code       TEXT,
    contract_id         INT,
	contract_number     TEXT,
    counterpart_id      INT,
    counterpart_name    TEXT,
    description         TEXT,
    quantity_mt         NUMERIC,
    received_rub        NUMERIC,
    paid_rub            NUMERIC,
    received_minus_paid_rub NUMERIC,
    operation_type      TEXT,
    budget_category_id  INT
);

ALTER TABLE clean.vessels
ADD CONSTRAINT fk_vessels_project
FOREIGN KEY (project_id) REFERENCES clean.projects(project_id);

ALTER TABLE clean.contracts
ADD CONSTRAINT fk_contracts_counterpart
FOREIGN KEY (counterpart_id) REFERENCES clean.counterparts(counterpart_id);

ALTER TABLE clean.vessel_allocation
ADD CONSTRAINT fk_alloc_contract
FOREIGN KEY (contract_id) REFERENCES clean.contracts(contract_id);

ALTER TABLE clean.vessel_allocation
ADD CONSTRAINT fk_alloc_vessel
FOREIGN KEY (vessel_id) REFERENCES clean.vessels(vessel_id);

ALTER TABLE clean.payments
ADD CONSTRAINT fk_payments_counterpart
FOREIGN KEY (counterpart_id) REFERENCES clean.counterparts(counterpart_id);

ALTER TABLE clean.payments
ADD CONSTRAINT fk_payments_contract
FOREIGN KEY (contract_id) REFERENCES clean.contracts(contract_id);

ALTER TABLE clean.payments
ADD CONSTRAINT fk_payments_budget_cat
FOREIGN KEY (budget_category_id) REFERENCES clean.budget_categories(budget_category_id);

ALTER TABLE clean.contracts
ADD CONSTRAINT fk_contract_group
FOREIGN KEY (contract_group_id) REFERENCES clean.contract_groups(contract_group_id);

INSERT INTO clean.counterparts (
    counterpart_id,
    name,
    inn
)
SELECT
    counterpart_id::int,
    name,
    inn
FROM raw.counterparts;

INSERT INTO clean.projects (
    project_id,
    project_code,
    fobbing,
    export_tax,
    profit_calc,
    cost_of_goods,
    comment
)
SELECT
    project_id::int,
    project_code,
    fobbing::numeric,
    NULLIF(REPLACE(REPLACE(export_tax,' ',''),',','.'),'')::numeric,
    NULLIF(REPLACE(REPLACE(profit_calc,' ',''),',','.'),'')::numeric,
    NULLIF(REPLACE(REPLACE(cost_of_goods,' ',''),',','.'),'')::numeric,
    comment
FROM raw.projects;

SELECT * FROM raw.projects;

DELETE FROM raw.projects
WHERE project_id IS NULL
  AND project_code IS NULL
  AND fobbing IS NULL
  AND export_tax IS NULL
  AND profit_calc IS NULL
  AND cost_of_goods IS NULL
  AND comment IS NULL;

INSERT INTO clean.vessels (
    vessel_id,
    name,
    shipped_mt,
    loading_port,
    loading_date,
    discharge_port,
    project_id,
    vessel_code
)
SELECT
    vessel_id::int,
    name,
    NULLIF(REPLACE(REPLACE(shipped_mt,' ',''),',','.'),'')::numeric,
    loading_port,
    NULLIF(loading_date,'')::date,
    discharge_port,
    project_id::int,
    vessel_code
FROM raw.vessels;


INSERT INTO clean.contract_groups (
    contract_group_id,
    group_type,
    description,
    comment,
    cost_of_goods,
    cost_of_transport,
    cost_of_agent
)
SELECT
    contract_group_id::int,
    group_type,
    description,
    comment,
    cost_of_goods::numeric,
    cost_of_transport::numeric,
    cost_of_agent::numeric
FROM raw.contract_groups;

INSERT INTO clean.contracts (
    contract_id,
    counterpart_id,
    counterpart_name,
    date,
    number,
    subject,
    commodity,
    quantity,
    basis,
    loading_place,
    delivery_period,
    total_by_contract,
    total_by_payments,
    total_calc,
    price_without_vat,
    vat,
    price_with_vat,
    shipped_by_supplier_mt,
    received_on_wh_mt,
    quality,
    contract_group_id,
    type
)
SELECT
    contract_id::int,
    counterpart_id::int,
    counterpart_name,
    NULLIF(NULLIF(date, '1900-01-00'), '')::date,
    number,
    subject,
    commodity,
    NULLIF(
    NULLIF(REPLACE(REPLACE(quantity,' ',''),',','.'), '-'),
'')::numeric,
    basis,
    loading_place,
    delivery_period,
	NULLIF(
    NULLIF(REPLACE(REPLACE(total_by_contract,' ',''),',','.'), '-'),
'')::numeric,
NULLIF(
    NULLIF(REPLACE(REPLACE(total_by_payments,' ',''),',','.'), '-'),
'')::numeric,
NULLIF(
    NULLIF(REPLACE(REPLACE(total_calc,' ',''),',','.'), '-'),
'')::numeric,
NULLIF(
    NULLIF(REPLACE(REPLACE(price_without_vat,' ',''),',','.'), '-'),
'')::numeric,
NULLIF(
    NULLIF(REPLACE(REPLACE(vat,' ',''),',','.'), '-'),
'')::numeric,
NULLIF(
    NULLIF(REPLACE(REPLACE(price_with_vat,' ',''),',','.'), '-'),
'')::numeric,
NULLIF(
    NULLIF(REPLACE(REPLACE(shipped_by_supplier_mt,' ',''),',','.'), '-'),
'')::numeric,
NULLIF(
    NULLIF(REPLACE(REPLACE(received_on_wh_mt,' ',''),',','.'), '-'),
'')::numeric,
    quality,
    contract_group_id::int,
    type
FROM raw.contracts;

DELETE FROM raw.contracts
WHERE contract_id IS NULL;

SELECT * FROM raw.contracts
WHERE contract_id IS NULL;


INSERT INTO clean.vessel_allocation (
    vessel_allocation_id,
    vessel_id,
    contract_id,
    quantity_allocated
)
SELECT
    vessel_allocation_id::int,
    vessel_id::int,
    contract_id::int,
	NULLIF(
    NULLIF(REPLACE(REPLACE(quantity_allocated,' ',''),',','.'), '-'),
'')::numeric
FROM raw.vessel_allocation;


INSERT INTO clean.payments (
    payment_id,
    internal_number,
    payment_date,
	contract_code,
    contract_id,
	contract_number,
    counterpart_id,
    counterpart_name,
    description,
    quantity_mt,
    received_rub,
    paid_rub,
    received_minus_paid_rub,
    operation_type,
    budget_category_id
)
SELECT
    payment_id::int,
    internal_number,
	NULLIF(NULLIF(payment_date, '1900-01-00'), '')::date,
	contract_code,
	contract_id::int,
	contract_number,
	counterpart_id::int,
    counterpart_name,
    description,
		NULLIF(
    NULLIF(REPLACE(REPLACE(quantity_mt,' ',''),',','.'), '-'),
'')::numeric,
	NULLIF(
    NULLIF(REPLACE(REPLACE(received_rub,' ',''),',','.'), '-'),
'')::numeric,
	NULLIF(
    NULLIF(REPLACE(REPLACE(paid_rub,' ',''),',','.'), '-'),
'')::numeric,
	NULLIF(
    NULLIF(REPLACE(REPLACE(received_minus_paid_rub,' ',''),',','.'), '-'),
'')::numeric,
    operation_type,
    budget_category_id::int
FROM raw.payments;




SELECT *
FROM raw.payments
WHERE
    payment_id IS NULL;

DELETE FROM raw.payments
WHERE payment_id IS NULL;


SELECT *
FROM raw.payments
WHERE budget_category_id = '#Н/Д';

UPDATE raw.payments
SET budget_category_id = NULL
WHERE budget_category_id = '#Н/Д';

UPDATE raw.payments
SET contract_id = NULL
WHERE contract_id = 'no';

INSERT INTO clean.budget_categories (
    budget_category_id,
    name
)
SELECT
    budget_category_id::int,
    name
FROM raw.budget_categories;









SELECT *
FROM clean.payments
WHERE contract_id IS NOT NULL
AND contract_id NOT IN (SELECT contract_id FROM clean.contracts);

SELECT *
FROM clean.payments
WHERE counterpart_id IS NOT NULL
AND counterpart_id NOT IN (SELECT counterpart_id FROM clean.counterparts);

SELECT *
FROM clean.payments
WHERE budget_category_id IS NOT NULL
AND budget_category_id NOT IN (SELECT budget_category_id FROM clean.budget_categories);

SELECT *
FROM clean.vessels
WHERE project_id IS NOT NULL
AND project_id NOT IN (SELECT project_id FROM clean.projects);

SELECT *
FROM clean.vessel_allocation
WHERE vessel_id IS NOT NULL
AND vessel_id NOT IN (SELECT vessel_id FROM clean.vessels);

SELECT *
FROM clean.vessel_allocation
WHERE contract_id IS NOT NULL
AND contract_id NOT IN (SELECT contract_id FROM clean.contracts);

SELECT *
FROM clean.contracts
WHERE counterpart_id IS NOT NULL
AND counterpart_id NOT IN (SELECT counterpart_id FROM clean.counterparts);

SELECT *
FROM clean.contracts
WHERE contract_group_id IS NOT NULL
AND contract_group_id NOT IN (SELECT contract_group_id FROM clean.contract_groups);

SELECT *
FROM clean.contracts
WHERE total_calc IS NULL;

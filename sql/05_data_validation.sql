-- Row counts check
SELECT COUNT(*) FROM raw.projects;
SELECT COUNT(*) FROM raw.vessels;
SELECT COUNT(*) FROM raw.counterparts;
SELECT COUNT(*) FROM raw.contract_types;
SELECT COUNT(*) FROM raw.contract_groups;
SELECT COUNT(*) FROM raw.contracts;
SELECT COUNT(*) FROM raw.vessel_allocation;
SELECT COUNT(*) FROM raw.payments;

-- Primary keys
SELECT
    project_id,
    COUNT(*)
FROM raw.projects
GROUP BY project_id
HAVING COUNT(*) > 1;

SELECT
    vessel_id,
    COUNT(*)
FROM raw.vessels
GROUP BY vessel_id
HAVING COUNT(*) > 1;

SELECT
    counterpart_id,
    COUNT(*)
FROM raw.counterparts
GROUP BY counterpart_id
HAVING COUNT(*) > 1;

SELECT
    contract_id,
    COUNT(*)
FROM raw.contracts
GROUP BY contract_id
HAVING COUNT(*) > 1;

SELECT
    contract_group_id,
    COUNT(*)
FROM raw.contract_groups
GROUP BY contract_group_id
HAVING COUNT(*) > 1;

SELECT
    contract_type_id,
    COUNT(*)
FROM raw.contract_types
GROUP BY contract_type_id
HAVING COUNT(*) > 1;

SELECT
    vessel_allocation_id,
    COUNT(*)
FROM raw.vessel_allocation
GROUP BY vessel_allocation_id
HAVING COUNT(*) > 1;

SELECT
    payment_id,
    COUNT(*)
FROM raw.payments
GROUP BY payment_id
HAVING COUNT(*) > 1;

-- Foreign keys
SELECT c.*
FROM raw.contracts c
LEFT JOIN raw.counterparts cp
ON c.counterpart_id = cp.counterpart_id
WHERE cp.counterpart_id IS NULL;

SELECT c.*
FROM raw.contracts c
LEFT JOIN raw.contract_groups g
ON c.contract_group_id = g.contract_group_id
WHERE g.contract_group_id IS NULL;

SELECT c.*
FROM raw.contracts c
LEFT JOIN raw.contract_types t
ON c.contract_type_id = t.contract_type_id
WHERE t.contract_type_id IS NULL;

SELECT va.*
FROM raw.vessel_allocation va
LEFT JOIN raw.contracts c
ON va.contract_id = c.contract_id
WHERE c.contract_id IS NULL;

SELECT va.*
FROM raw.vessel_allocation va
LEFT JOIN raw.vessels v
ON va.vessel_id = v.vessel_id
WHERE v.vessel_id IS NULL;

SELECT p.*
FROM raw.payments p
LEFT JOIN raw.contracts c
ON p.contract_id = c.contract_id
WHERE c.contract_id IS NULL;

SELECT p.*
FROM raw.payments p
LEFT JOIN raw.counterparts cp
ON p.counterpart_id = cp.counterpart_id
WHERE cp.counterpart_id IS NULL;

SELECT v.*
FROM raw.vessels v
LEFT JOIN raw.projects pj
ON v.project_id = pj.project_id
WHERE pj.project_id IS NULL;

-- Missing Values
SELECT
    COUNT(*) AS total_rows,
    COUNT(project_id) AS project_id_not_null,
    COUNT(price_ctr_manual) AS price_not_null
FROM raw.projects;

SELECT
	COUNT(*) FILTER (WHERE name IS NULL) AS missing_name,
	COUNT(*) FILTER (WHERE shipped_mt IS NULL) AS missing_shipped_mt,
	COUNT(*) FILTER (WHERE loading_port IS NULL) AS missing_loading_port,
    COUNT(*) FILTER (WHERE loading_date IS NULL) AS missing_loading_date,
    COUNT(*) FILTER (WHERE discharge_port IS NULL) AS missing_discharge_port,
	COUNT(*) FILTER (WHERE project_id IS NULL) AS missing_project_id
FROM raw.vessels;

SELECT * FROM raw.contracts;

SELECT
    COUNT(*) FILTER (WHERE internal_number IS NULL) AS missing_internal_number,
    COUNT(*) FILTER (WHERE payment_date IS NULL) AS missing_payment_date,
	COUNT(*) FILTER (WHERE contract_id IS NULL) AS missing_contract_id,
	COUNT(*) FILTER (WHERE counterpart_id IS NULL) AS missing_counterpart_id,
	COUNT(*) FILTER (WHERE received_rub IS NULL) AS missing_received_rub,
	COUNT(*) FILTER (WHERE paid_rub IS NULL) AS missing_paid_rub,
	COUNT(*) FILTER (WHERE operation_type IS NULL) AS missing_operation_type
FROM raw.payments;

SELECT
	COUNT(*) FILTER (WHERE counterpart_id IS NULL) AS missing_counterpart_id,
	COUNT(*) FILTER (WHERE date IS NULL) AS missing_date,
    COUNT(*) FILTER (WHERE number IS NULL) AS missing_number,
    COUNT(*) FILTER (WHERE quantity_mt IS NULL) AS missing_quantity_mt,
	COUNT(*) FILTER (WHERE delivery_due_date IS NULL) AS missing_delivery_due_date,
	COUNT(*) FILTER (WHERE total_by_ctr IS NULL) AS missing_total_by_ctr,
	COUNT(*) FILTER (WHERE price_without_vat IS NULL) AS missing_price_without_vat,
	COUNT(*) FILTER (WHERE vat IS NULL) AS missing_vat,
	COUNT(*) FILTER (WHERE price_with_vat IS NULL) AS missing_price_with_vat,
	COUNT(*) FILTER (WHERE shipped_by_supplier_mt IS NULL) AS missing_shipped_by_supplier_mt,
	COUNT(*) FILTER (WHERE received_on_wh_mt IS NULL) AS missing_received_on_wh_mt,
	COUNT(*) FILTER (WHERE contract_group_id IS NULL) AS missing_contract_group_id,
	COUNT(*) FILTER (WHERE contract_type_id IS NULL) AS missing_contract_type_id
FROM raw.contracts;

-- Negative values
SELECT *
FROM raw.contracts
WHERE quantity_mt < 0;

SELECT *
FROM raw.contracts
WHERE price_without_vat < 0;

SELECT *
FROM raw.contracts
WHERE price_with_vat < 0;

SELECT *
FROM raw.contracts
WHERE vat < 0 OR vat > 1;

SELECT *
FROM raw.payments
WHERE received_rub < 0
   OR paid_rub < 0;

SELECT DISTINCT vat
FROM raw.contracts
ORDER BY vat;

-- Dates
SELECT *
FROM raw.contracts
WHERE delivery_due_date < date;

SELECT *
FROM raw.vessels
WHERE loading_date > CURRENT_DATE;

-- Uniqueness of business fields
SELECT
    number,
    COUNT(*)
FROM raw.contracts
GROUP BY number
HAVING COUNT(*) > 1;

SELECT
    internal_number,
    COUNT(*)
FROM raw.payments
GROUP BY internal_number
HAVING COUNT(*) > 1;

SELECT
    name,
    COUNT(*)
FROM raw.vessels
GROUP BY name
HAVING COUNT(*) > 1;

-- Quick look
SELECT *
FROM raw.contracts
LIMIT 10;
\copy raw.projects FROM 'C:/Users/alinaaleks/Downloads/GitHub/vessel-analytics/data/csv/projects.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy raw.vessels FROM 'C:/Users/alinaaleks/Downloads/GitHub/vessel-analytics/data/csv/vessels.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy raw.counterparts FROM 'C:/Users/alinaaleks/Downloads/GitHub/vessel-analytics/data/csv/counterparts.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy raw.contract_types FROM 'C:/Users/alinaaleks/Downloads/GitHub/vessel-analytics/data/csv/contract_types.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy raw.contract_groups FROM 'C:/Users/alinaaleks/Downloads/GitHub/vessel-analytics/data/csv/contract_groups.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy raw.contracts FROM 'C:/Users/alinaaleks/Downloads/GitHub/vessel-analytics/data/csv/contracts.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy raw.vessel_allocation FROM 'C:/Users/alinaaleks/Downloads/GitHub/vessel-analytics/data/csv/vessel_allocation.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy raw.payments FROM 'C:/Users/alinaaleks/Downloads/GitHub/vessel-analytics/data/csv/payments.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
import pandas as pd
from db import get_engine, ensure_schema

engine = get_engine()
ensure_schema(engine)

def load_csv(file_path, table_name):
    df = pd.read_csv(file_path, sep=';')
    df.to_sql(table_name, engine, schema="raw", if_exists="replace", index=False)
    print(f"Loaded {table_name}")

if __name__ == "__main__":
    load_csv("data/raw/projects.csv", "projects")
    load_csv("data/raw/vessels.csv", "vessels")
    load_csv("data/raw/counterparts.csv", "counterparts")
    load_csv("data/raw/contract_groups.csv", "contract_groups")
    load_csv("data/raw/contracts.csv", "contracts")
    load_csv("data/raw/vessel_allocation.csv", "vessel_allocation")
    load_csv("data/raw/budget_categories.csv", "budget_categories")
    load_csv("data/raw/payments.csv", "payments")
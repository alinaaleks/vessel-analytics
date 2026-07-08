import pandas as pd
from db import get_engine

engine = get_engine()

df = pd.read_csv(
    "data/raw/payments.csv",
    sep=";"
)

df.to_sql(
    "payments",
    engine,
    schema="raw",
    if_exists="replace",
    index=False
)
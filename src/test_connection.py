from sqlalchemy import create_engine, text
from db import get_engine

engine = get_engine()

with engine.connect() as conn:
    print(conn.execute(text("SELECT 1")).scalar())
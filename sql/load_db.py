"""
load_db.py — Build the SQLite analysis database from the cleaned CSV.

Usage (from the project root):
    python sql/load_db.py

Requires: pandas (already in requirements.txt)
Creates:  sql/telco_churn.db   with a single table called 'customers'

Extra columns added beyond the clean CSV:
  ChurnFlag   : 1 if Churn=="Yes" else 0  (integer flag for arithmetic)
  CLV_Proxy   : MonthlyCharges * tenure   (approximate historical revenue)
  AddonCount  : count of internet add-ons set to "Yes" (0–6)
"""

import sqlite3
from pathlib import Path

import pandas as pd

PROJECT_ROOT = Path(__file__).resolve().parents[1]
CLEAN_CSV = PROJECT_ROOT / "data" / "clean" / "telco_clean.csv"
DB_PATH = PROJECT_ROOT / "sql" / "telco_churn.db"

ADDON_COLS = [
    "OnlineSecurity", "OnlineBackup", "DeviceProtection",
    "TechSupport", "StreamingTV", "StreamingMovies",
]

def build_db() -> None:
    print(f"Reading: {CLEAN_CSV}")
    df = pd.read_csv(CLEAN_CSV)

    df["ChurnFlag"] = (df["Churn"] == "Yes").astype(int)
    df["CLV_Proxy"] = df["MonthlyCharges"] * df["tenure"]
    df["AddonCount"] = (df[ADDON_COLS] == "Yes").sum(axis=1)

    print(f"Rows: {len(df)}  |  Columns: {df.shape[1]}")
    print(f"Writing: {DB_PATH}")

    con = sqlite3.connect(DB_PATH)
    df.to_sql("customers", con, if_exists="replace", index=False)
    con.close()

    print("Done. Table 'customers' created in sql/telco_churn.db")
    print(f"Run queries with:  sqlite3 {DB_PATH}")

if __name__ == "__main__":
    build_db()

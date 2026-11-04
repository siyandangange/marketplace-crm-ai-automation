"""AutoConnect T09: export a minimal synthetic CRM audience from SQLite.

Run from the repository root:
    py python/export_eligible_audience.py

The CSV is portfolio evidence only; do not import example.com contacts
into a live sending platform. Use owned test addresses for Brevo tests.
"""
from __future__ import annotations

import csv
import sqlite3
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DB_PATH = ROOT / "output" / "t05" / "autoconnect_t05.db"
SQL_PATH = ROOT / "sql" / "audience.sql"
OUTPUT_PATH = ROOT / "output" / "t09" / "eligible_audience.csv"
FIELDS = ("customer_id", "first_name", "email", "vehicle_make", "vehicle_model")
EXPECTED_COUNT = 35


def main() -> None:
    if not DB_PATH.is_file():
        raise SystemExit(f"Missing database: {DB_PATH}. Run T05 generator first.")
    if not SQL_PATH.is_file():
        raise SystemExit(f"Missing SQL query: {SQL_PATH}")

    query = SQL_PATH.read_text(encoding="utf-8-sig").strip().rstrip(";")
    with sqlite3.connect(DB_PATH) as db:
        cursor = db.execute(query)
        columns = [item[0] for item in cursor.description]
        rows = [dict(zip(columns, row)) for row in cursor.fetchall()]
        if any(field not in columns for field in FIELDS):
            raise SystemExit("Audience query is missing a required export field")

        emails = [str(row["email"]).strip().lower() for row in rows]
        ids = [row["customer_id"] for row in rows]
        assert len(rows) == EXPECTED_COUNT, f"Expected {EXPECTED_COUNT}, got {len(rows)}"
        assert len(ids) == len(set(ids)), "Duplicate customer IDs"
        assert len(emails) == len(set(emails)), "Duplicate normalized emails"
        assert all(email.endswith("@example.com") for email in emails), (
            "Non-example.com address found: stop and review before exporting"
        )

    OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    with OUTPUT_PATH.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=FIELDS)
        writer.writeheader()
        writer.writerows({field: row[field] for field in FIELDS} for row in rows)

    print("T09 PASS — synthetic campaign audience exported")
    print("Rows:", len(rows))
    print("Columns:", ", ".join(FIELDS))
    print("Unique customer IDs: PASS | Unique emails: PASS")
    print("Synthetic email domain check: PASS")
    print("Output:", OUTPUT_PATH)
    print("IMPORTANT: This CSV is NOT a live Brevo contact import list.")


if __name__ == "__main__":
    main()

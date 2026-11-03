"""AutoConnect T05: deterministic, synthetic CRM dataset generator.

Run from the repository root:
    py python/generate_synthetic_data.py

Reads sql/schema.sql and sql/seed.sql. Writes output/t05/*.csv and
output/t05/autoconnect_t05.db. Never sends emails or contacts anyone.
"""
from __future__ import annotations

import csv
import json
import sqlite3
from collections import Counter
from datetime import datetime, timedelta
from pathlib import Path

REFERENCE = datetime(2026, 11, 3, 19, 0, 0)
CAMPAIGN = "SAVED_SEARCH_REENGAGEMENT"
TABLES = (
    "customers", "saved_searches", "browsing_events", "consents",
    "consent_history", "campaign_events", "raw_customer_staging",
)


def timestamp(days: int = 0, seconds: int = 0) -> str:
    return (REFERENCE + timedelta(days=days, seconds=seconds)).strftime("%Y-%m-%d %H:%M:%S")


def export_csv(db: sqlite3.Connection, table: str, path: Path) -> None:
    cur = db.execute(f"SELECT * FROM {table} ORDER BY 1")
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.writer(handle)
        writer.writerow([column[0] for column in cur.description])
        writer.writerows(cur.fetchall())


def main() -> None:
    root = Path(__file__).resolve().parent.parent
    schema = root / "sql" / "schema.sql"
    seed = root / "sql" / "seed.sql"
    if not schema.is_file() or not seed.is_file():
        raise SystemExit("Run from a project containing sql/schema.sql and sql/seed.sql")

    output = root / "output" / "t05"
    output.mkdir(parents=True, exist_ok=True)
    database_path = output / "autoconnect_t05.db"
    # Rebuild ONLY the dedicated T05 output database, never autoconnect.db.
    if database_path.exists():
        database_path.unlink()
    db = sqlite3.connect(database_path)
    db.execute("PRAGMA foreign_keys=ON")
    try:
        db.executescript(schema.read_text(encoding="utf-8-sig"))
        db.executescript(seed.read_text(encoding="utf-8-sig"))
        actual_tables = {row[0] for row in db.execute(
            "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'")}
        assert actual_tables == set(TABLES), f"Unexpected schema tables: {actual_tables}"
        assert db.execute("SELECT COUNT(*) FROM customers").fetchone()[0] == 6, (
            "Expected exactly the six original seed customers"
        )

        # Make original seed timestamps deterministic, preserving all six identities.
        original_scenarios = {
            1: ("inactive_eligible", -10, -30, "opted_in", None),
            2: ("recently_active", -1, -20, "opted_in", None),
            3: ("opted_out", -14, -25, "opted_out", None),
            4: ("inactive_eligible", -20, -20, "opted_in", None),
            5: ("recently_contacted", -20, -40, "opted_in", -3),
            6: ("inactive_search", -12, -15, "opted_in", None),
        }
        scenarios: dict[int, str] = {}
        for cid, (scenario, browsing_age, search_age, consent, sent_age) in original_scenarios.items():
            scenarios[cid] = scenario
            db.execute("UPDATE customers SET created_at=? WHERE customer_id=?", (timestamp(-100), cid))
            db.execute("UPDATE saved_searches SET created_at=? WHERE customer_id=?", (timestamp(search_age), cid))
            db.execute("UPDATE browsing_events SET occurred_at=? WHERE customer_id=?", (timestamp(browsing_age), cid))
            db.execute("UPDATE consents SET status=?, updated_at=? WHERE customer_id=?", (consent, timestamp(-5), cid))
            if sent_age is not None:
                db.execute("UPDATE campaign_events SET occurred_at=? WHERE customer_id=?", (timestamp(sent_age), cid))

        # Total target counts include the six original customers above.
        targets = {
            "inactive_eligible": 20,
            "recently_active": 15,
            "opted_out": 10,
            "inactive_search": 10,
            "no_browsing_eligible": 10,
            "no_browsing_recent": 5,
            "recently_contacted": 5,
            "boundary": 5,
        }
        initial = Counter(scenarios.values())
        new_scenarios = [name for name, target in targets.items()
                         for _ in range(target - initial[name])]
        assert len(new_scenarios) == 74

        vehicle_options = [
            ("Volkswagen", "Golf"), ("BMW", "3 Series"),
            ("Audi", "A3"), ("Toyota", "Yaris"),
            ("Opel", "Corsa"), ("Ford", "Focus"),
            ("Skoda", "Octavia"), ("Hyundai", "i30"),
        ]
        for cid, scenario in enumerate(new_scenarios, start=7):
            scenarios[cid] = scenario
            first_name = f"Test{cid:03d}"
            last_name = "Customer"
            email = f"autoconnect.customer{cid:03d}@example.com"
            db.execute("""INSERT INTO customers
                (customer_id, first_name, last_name, email, created_at, country)
                VALUES (?, ?, ?, ?, ?, ?)""",
                (cid, first_name, last_name, email, timestamp(-100), "Germany"))

            make, model = vehicle_options[(cid - 7) % len(vehicle_options)]
            active = 0 if scenario == "inactive_search" else 1
            search_age = -3 if scenario == "no_browsing_recent" else -30
            db.execute("""INSERT INTO saved_searches
                (search_id, customer_id, vehicle_make, vehicle_model,
                 min_price, max_price, created_at, is_active)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)""",
                (1000 + cid, cid, make, model, 5000, 25000,
                 timestamp(search_age), active))

            if scenario not in ("no_browsing_eligible", "no_browsing_recent"):
                browsing_age = -1 if scenario == "recently_active" else -15
                if scenario == "boundary":
                    # Exactly seven days ago: included by an inclusive cutoff.
                    browsing_age = -7
                db.execute("""INSERT INTO browsing_events
                    (event_id, customer_id, event_type, occurred_at)
                    VALUES (?, ?, 'vehicle_view', ?)""",
                    (2000 + cid, cid, timestamp(browsing_age)))

            status = "opted_out" if scenario == "opted_out" else "opted_in"
            db.execute("""INSERT INTO consents
                (consent_id, customer_id, channel, status, updated_at)
                VALUES (?, ?, 'email', ?, ?)""",
                (3000 + cid, cid, status, timestamp(-5)))
            if scenario == "recently_contacted":
                db.execute("""INSERT INTO campaign_events
                    (campaign_event_id, customer_id, campaign_id, event_type, occurred_at)
                    VALUES (?, ?, ?, 'sent', ?)""",
                    (4000 + cid, cid, CAMPAIGN, timestamp(-3)))

        # Consent history: a historical opt-in followed by a newer opt-out
        # for opted-out customers; a single opt-in for all others.
        history_id = 5000
        for cid in range(1, 81):
            status = db.execute("SELECT status FROM consents WHERE customer_id=? AND channel='email'", (cid,)).fetchone()[0]
            db.execute("""INSERT INTO consent_history
                (consent_history_id, customer_id, channel, status, changed_at, source_system)
                VALUES (?, ?, 'email', 'opted_in', ?, 'synthetic_generator')""",
                (history_id, cid, timestamp(-40)))
            history_id += 1
            if status == "opted_out":
                db.execute("""INSERT INTO consent_history
                    (consent_history_id, customer_id, channel, status, changed_at, source_system)
                    VALUES (?, ?, 'email', 'opted_out', ?, 'synthetic_generator')""",
                    (history_id, cid, timestamp(-5)))
                history_id += 1

        # Exactly 15 intentionally imperfect staging records.
        staging = [
            ("EXT001", "Lena", "Weber", "lena@example.com"),
            ("EXT002", "Lena", "Weber", "lena@example.com"),
            ("EXT003", "Missing", "Email", None),
            ("EXT004", "Malformed", "Email", "invalid-email"),
            ("EXT005", "Case", "Difference", "LENA@EXAMPLE.COM"),
            ("EXT006", "Spaces", "Around", " lena@example.com "),
            ("EXT007", "Blank", "Email", ""),
            ("EXT008", "NoAt", "Symbol", "person.example.com"),
            ("EXT009", "DoubleAt", "Symbol", "a@@example.com"),
            ("EXT010", "Duplicate", "Customer", "dupe@example.com"),
            ("EXT011", "Duplicate", "Customer", "dupe@example.com"),
            ("EXT012", "Valid", "Contact", "valid12@example.com"),
            ("EXT013", "Other", "Valid", "valid13@example.com"),
            ("EXT014", "NoDomain", "Contact", "person@"),
            ("EXT015", "Other", "Valid", "valid15@example.com"),
        ]
        for idx, (source_id, first, last, email) in enumerate(staging, start=1):
            db.execute("""INSERT INTO raw_customer_staging
                (staging_id, source_customer_id, first_name, last_name,
                 email, country, imported_at, source_system)
                VALUES (?, ?, ?, ?, ?, 'Germany', ?, 'synthetic_import')""",
                (idx, source_id, first, last, email, timestamp(-1)))

        db.commit()
        counts = {table: db.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]
                  for table in TABLES}
        assert counts["customers"] == 80
        assert counts["raw_customer_staging"] == 15
        assert Counter(scenarios.values()) == Counter(targets)
        assert db.execute("PRAGMA foreign_key_check").fetchall() == []
        assert db.execute("PRAGMA foreign_keys").fetchone()[0] == 1
        assert db.execute("SELECT COUNT(*) FROM customers WHERE email IS NULL").fetchone()[0] == 0
        assert db.execute("SELECT COUNT(DISTINCT lower(trim(email))) FROM customers").fetchone()[0] == 80
        assert db.execute("SELECT COUNT(*) FROM consents").fetchone()[0] == 80
        assert db.execute("SELECT COUNT(*) FROM consent_history").fetchone()[0] == 90
        for cid in range(1, 81):
            latest = db.execute("""SELECT status FROM consent_history
                WHERE customer_id=? AND channel='email'
                ORDER BY changed_at DESC, consent_history_id DESC LIMIT 1""", (cid,)).fetchone()[0]
            current = db.execute("SELECT status FROM consents WHERE customer_id=? AND channel='email'", (cid,)).fetchone()[0]
            assert latest == current, f"Consent mismatch for customer {cid}"

        for table in TABLES:
            export_csv(db, table, output / f"{table}.csv")
        with (output / "scenario_manifest.csv").open("w", encoding="utf-8", newline="") as handle:
            writer = csv.writer(handle)
            writer.writerow(["customer_id", "scenario", "expected_outcome"])
            for cid, scenario in sorted(scenarios.items()):
                expected = "eligible" if scenario in ("inactive_eligible", "no_browsing_eligible", "boundary") else "excluded"
                writer.writerow([cid, scenario, expected])
        summary = {
            "reference_timestamp": timestamp(),
            "table_counts": counts,
            "scenario_counts": dict(sorted(Counter(scenarios.values()).items())),
            "expected_eligible_count": sum(s in ("inactive_eligible", "no_browsing_eligible", "boundary") for s in scenarios.values()),
            "foreign_key_check": "passed",
            "consent_history_consistency": "passed",
            "note": "Expected outcomes are scenario fixtures; validate them independently in T07/T08 SQL.",
        }
        (output / "validation_summary.json").write_text(json.dumps(summary, indent=2) + "\n", encoding="utf-8")
        print("T05 PASS — deterministic synthetic dataset generated")
        print("Reference timestamp:", timestamp())
        for table, count in counts.items():
            print(f"  {table}: {count}")
        print("Expected eligible fixtures:", summary["expected_eligible_count"])
        print("Foreign keys: PASS | Consent consistency: PASS")
        print("Output:", output)
    finally:
        db.close()


if __name__ == "__main__":
    main()


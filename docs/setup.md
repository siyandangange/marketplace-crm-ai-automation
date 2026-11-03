
# AutoConnect — Local Development Setup

## Overview

AutoConnect uses a local SQLite database to prototype customer lifecycle segmentation and CRM automation for a fictional vehicle marketplace.

All customer data is synthetic.

## Technology Stack

- Python 3.10.8
- SQLite (via Python's built-in sqlite3 module)
- GitHub for version control
- SQL for relational data modelling and segmentation

## Database Structure

The database contains five tables:

1. customers — Customer profiles
2. saved_searches — Customer vehicle search preferences
3. browsing_events — Customer browsing activity
4. consents — Marketing permissions
5. campaign_events — Campaign interactions

## Local Setup

### Prerequisites

Install Python 3.10 or newer.

### Step 1 — Open the project folder

Open Command Prompt in the downloaded AutoConnect project directory.

### Step 2 — Create and populate the database

Run this command from the project root:

```bat
py -c "import sqlite3, pathlib; db=sqlite3.connect('autoconnect.db'); db.executescript(pathlib.Path('sql/schema.sql').read_text(encoding='utf-8-sig')); db.executescript(pathlib.Path('sql/seed.sql').read_text(encoding='utf-8-sig')); db.commit(); print('Database created successfully'); db.close()"
```

This command creates the SQLite database, builds the tables and loads the synthetic customer records.

Run it against a new database, not one that has already been populated.

### Step 3 — Verify customer records

```bat
py -c "import sqlite3; db=sqlite3.connect('autoconnect.db'); print('Customers:', db.execute('SELECT COUNT(*) FROM customers').fetchone()[0]); db.close()"
```

Expected result:

```text
Customers: 6
```

## Data Protection

- No real customer data is used.
- SQLite database files are excluded through `.gitignore`.
- SQL scripts remain version-controlled for reproducibility.

## Current Status

- Relational customer data model created
- Synthetic customer records loaded
- Local SQLite environment verified
- SQL segmentation and CRM journey implementation pending

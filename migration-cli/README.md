Formula Factory Migration CLI

This lightweight scaffold provides commands for the migration workflow:

Commands:

- `discover` — find duplicates/overlaps and write a CSV report
- `stage` — stage discovered items for validation
- `validate` — run validations against staged items
- `promote` — promote staged & validated items to production
- `rollback` — rollback a promotion

Quickstart

1. Install dependencies:

```bash
cd migration-cli
npm install
```

2. Run discovery (writes `discover-report.csv`):

```bash
node index.js discover -o discover-report.csv
```

Notes

- The `discover` command contains example SQL in comments that can be used against a Postgres database. Provide `DATABASE_URL` env var and uncomment the `pg` client code to run live.
- Each command is a scaffold/stub. Implement the DB interactions and business logic to match your schema and governance needs.

Recommended next steps

- Implement `discover` SQL suited for your `formula_version` and `formula` tables.
- Wire `stage` to insert into `formula_migration_staging` table.
- Implement `validate` with the same validators used in your production pipeline.
- Make `promote` transactional and record audits in `audit_log`.

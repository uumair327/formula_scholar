# Postgres Integration for Migration CLI

## Overview

The migration CLI now supports dual-mode operation:

- **JSON Mode** (default): Uses a local JSON file (`workflow-state.json`) for state persistence
- **Postgres Mode** (new): Connects to a real Postgres database for scalable, persistent approval workflow management

## Architecture

### Components

1. **PostgresWorkflowStore** (`lib/workflow/postgres_store.js`)
   - Direct Postgres implementation using `pg` client
   - Provides async methods for approval policy, decision, and job management
   - Handles transactions for data consistency
   - Maps Postgres snake_case columns to camelCase JavaScript objects

2. **StoreAdapter** (`lib/workflow/store_adapter.js`)
   - Unified interface supporting both JSON and Postgres backends
   - Transparent switching based on configuration
   - Backward compatible with existing JSON-only commands
   - Factory function for environment-based store selection

3. **Database Initialization** (`lib/workflow/db_init.js`)
   - Standalone utility to set up Postgres schema
   - Creates tables: `approval_policy`, `approvals`, `approval_actions`, `publish_job`, `audit_log`
   - Creates necessary indexes for query performance
   - Idempotent (safe to run multiple times)

### Commands Updated

All workflow commands now support both modes:

#### Policy Management

```bash
# JSON mode (default)
migration-cli policy --entity-type formula_version --minimum-approvals 2

# Postgres mode
migration-cli policy --entity-type formula_version --minimum-approvals 2 \
  --db-host localhost --db-name formula_factory --db-user postgres
```

#### Approval Decisions

```bash
# JSON mode (default)
migration-cli approve --approval-id a123 --action approve

# Postgres mode
migration-cli approve --approval-id a123 --action approve \
  --db-host localhost --db-name formula_factory --db-user postgres
```

#### Publish Worker

```bash
# JSON mode (default)
migration-cli worker

# Postgres mode
migration-cli worker --db-host localhost --db-name formula_factory --db-user postgres
```

#### Database Initialization (NEW)

```bash
# Initialize Postgres schema
migration-cli db-init --db-host localhost --db-name formula_factory --db-user postgres

# With password
migration-cli db-init --db-host localhost --db-password mysecret
```

## Configuration

### Environment Variables

The CLI respects the following environment variables:

```bash
STORE_MODE=postgres           # Default: json
DB_HOST=localhost             # Default: localhost
DB_PORT=5432                  # Default: 5432
DB_NAME=formula_factory       # Default: formula_factory
DB_USER=postgres              # Default: postgres
DB_PASSWORD=                  # (optional)
```

### Connection Examples

**Local Postgres:**

```bash
export DB_HOST=localhost
export DB_NAME=formula_factory
export DB_USER=postgres
migration-cli worker
```

**Remote Postgres:**

```bash
migration-cli worker \
  --db-host prod-db.example.com \
  --db-port 5432 \
  --db-name formula_factory \
  --db-user formula_admin \
  --db-password $SECRET_PASSWORD
```

## Database Schema

The Postgres implementation operates on these tables:

### approval_policy

```sql
id VARCHAR(255) PRIMARY KEY
entity_type VARCHAR(255) NOT NULL
region VARCHAR(255)
minimum_approvals INT NOT NULL DEFAULT 1
sequential_signoff BOOLEAN NOT NULL DEFAULT false
enabled BOOLEAN NOT NULL DEFAULT true
created_at TIMESTAMP NOT NULL
updated_at TIMESTAMP NOT NULL
```

### approvals

```sql
id VARCHAR(255) PRIMARY KEY
target_type VARCHAR(255) NOT NULL
target_id VARCHAR(255) NOT NULL
requested_by VARCHAR(255) NOT NULL
policy_id VARCHAR(255) REFERENCES approval_policy(id)
state VARCHAR(50) NOT NULL DEFAULT 'pending'
priority INT NOT NULL DEFAULT 0
due_at TIMESTAMP
created_at TIMESTAMP NOT NULL
updated_at TIMESTAMP NOT NULL
```

### approval_actions

```sql
id VARCHAR(255) PRIMARY KEY
approval_id VARCHAR(255) NOT NULL REFERENCES approvals(id)
actor VARCHAR(255) NOT NULL
action VARCHAR(50) NOT NULL
comment TEXT
created_at TIMESTAMP NOT NULL
```

### publish_job

```sql
id VARCHAR(255) PRIMARY KEY
approval_id VARCHAR(255) NOT NULL REFERENCES approvals(id)
version_id VARCHAR(255) NOT NULL
status VARCHAR(50) NOT NULL DEFAULT 'queued'
attempts INT NOT NULL DEFAULT 0
created_by VARCHAR(255) NOT NULL
scheduled_at TIMESTAMP
started_at TIMESTAMP
finished_at TIMESTAMP
created_at TIMESTAMP NOT NULL
updated_at TIMESTAMP NOT NULL
```

### audit_log (append-only)

```sql
id SERIAL PRIMARY KEY
entity_type VARCHAR(255) NOT NULL
entity_id VARCHAR(255) NOT NULL
action VARCHAR(255) NOT NULL
performed_by VARCHAR(255) NOT NULL
delta JSONB
created_at TIMESTAMP NOT NULL
```

## Migration Strategy

### Phase 1: Dual-Mode Operation (Current)

- Deploy Postgres components alongside JSON store
- Test commands with both `--store` (JSON) and `--db-*` (Postgres) flags
- Keep JSON store as fallback during transition

### Phase 2: Gradual Migration

1. Initialize Postgres schema in target environment
2. Create approval policies in Postgres
3. Test worker with `--db-*` flags
4. Monitor publish jobs created in Postgres
5. Gradually shift production to Postgres mode

### Phase 3: Legacy Sunset

- After stable Postgres operation, retire JSON mode
- Archive old JSON state files
- Simplify CLI to Postgres-only

## Testing

All new functionality includes test coverage:

```bash
npm test  # Run all tests
```

Test files:

- `tests/postgres.test.js` - PostgresWorkflowStore unit tests (11 tests)
- `tests/adapter.test.js` - StoreAdapter dual-mode tests (8 tests)
- `tests/worker.test.js` - Existing publish worker tests (1 test)
- `tests/discover.test.js` - Existing discover command tests (1 test)

**Test Results**: 21 tests pass, 0 failures

## Development Workflow

### Setting Up Local Postgres

```bash
# Install Postgres (macOS with Homebrew)
brew install postgresql@15

# Start server
brew services start postgresql@15

# Create database
createdb formula_factory

# Initialize schema
migration-cli db-init --db-name formula_factory
```

### Testing Against Local Postgres

```bash
# Create a test policy
migration-cli policy \
  --entity-type formula_version \
  --minimum-approvals 2 \
  --db-name formula_factory

# Simulate approval workflow
migration-cli approve \
  --approval-id test_a_1 \
  --action approve \
  --actor reviewer_1 \
  --db-name formula_factory

# Run worker to queue jobs
migration-cli worker --db-name formula_factory
```

## Performance Considerations

### Indexes

The schema includes strategic indexes on:

- Approval state lookups (fast filtering of pending/approved items)
- Entity type matching for policy resolution
- Audit log queries by entity and timestamp
- Unique constraints preventing duplicate publish jobs

### Connection Pooling

Default pool size: 10 connections

- Tunable via pool configuration in StoreAdapter

### Query Patterns

- All approval readiness checks use indexed lookups
- Batch operations via transactions
- Append-only audit log for immutable history

## Troubleshooting

### Connection Issues

```bash
# Test Postgres connectivity
psql -h localhost -d formula_factory -U postgres -c "SELECT 1"

# Check connection string
migration-cli db-init \
  --db-host localhost \
  --db-name formula_factory \
  --db-user postgres
```

### Schema Mismatches

```bash
# Recreate schema (safe - uses IF NOT EXISTS)
migration-cli db-init --db-name formula_factory

# Verify tables exist
psql -d formula_factory -c "\dt"
```

### Debugging

Enable SQL logging (future enhancement):

```bash
DEBUG=migration-cli:* migration-cli worker --db-name formula_factory
```

## Next Steps

1. **Job Executor Integration**
   - Wire publish_job table to background worker
   - Implement retry logic and status tracking
   - Add payload storage for version details

2. **Postgres Replication**
   - Set up read replicas for scaling reads
   - Implement connection pooling (PgBouncer)

3. **Monitoring & Alerts**
   - Add query performance metrics
   - Monitor job queue depth
   - Alert on policy violations

4. **Data Migration**
   - Script to migrate JSON workflow state to Postgres
   - Validation queries to confirm migration
   - Cutover procedure for production

## See Also

- [Formula Factory Schema](../../formula_factory_schema.sql)
- [Approval Workflow Design](./APPROVAL_WORKFLOW.md)
- [Migration CLI Rollout Checklist](./ROLLOUT_CHECKLIST.md)

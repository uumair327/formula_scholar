#!/usr/bin/env node
const { program } = require('commander');
const discover = require('./lib/commands/discover');
const stage = require('./lib/commands/stage');
const validate = require('./lib/commands/validate');
const promote = require('./lib/commands/promote');
const rollback = require('./lib/commands/rollback');
const worker = require('./lib/commands/worker');
const policy = require('./lib/commands/policy');
const approve = require('./lib/commands/approve');
const dbInit = require('./lib/commands/db-init');
const executor = require('./lib/commands/executor');
const migrate = require('./lib/commands/migrate');

program
    .name('migration-cli')
    .description('Formula Factory migration CLI')
    .version('0.1.0');

program
    .command('discover')
    .description('Discover duplicate/overlapping formulas and produce a report')
    .option('-o, --out <file>', 'output CSV path', 'discover-report.csv')
    .action(discover);

program
    .command('stage')
    .description('Stage discovered changes into the staging area for validation')
    .option('--dry-run', 'do not persist changes')
    .action(stage);

program
    .command('validate')
    .description('Run validation pipeline on staged items')
    .option('--fast', 'fast validations only')
    .action(validate);

program
    .command('promote')
    .description('Promote staged and validated items to production')
    .option('--force', 'force promote even with warnings')
    .action(promote);

program
    .command('rollback')
    .description('Rollback a previous promote operation')
    .option('-i, --id <id>', 'promotion id to rollback')
    .action(rollback);

program
    .command('worker')
    .description('Process approved items into publish jobs')
    .option('--store <file>', 'path to workflow state store (JSON mode)')
    .option('--db-host <host>', 'database host (Postgres mode)')
    .option('--db-port <port>', 'database port (Postgres mode)', '5432')
    .option('--db-name <name>', 'database name (Postgres mode)')
    .option('--db-user <user>', 'database user (Postgres mode)')
    .option('--db-password <password>', 'database password (Postgres mode)')
    .option('--actor <name>', 'actor to record in audit entries', 'system')
    .action(worker);

program
    .command('policy')
    .description('Create or update an approval policy')
    .requiredOption('--entity-type <type>', 'target entity type, such as formula_version')
    .option('--id <id>', 'policy identifier')
    .option('--region-id <id>', 'region identifier')
    .option('--minimum-approvals <count>', 'minimum approvals required', '1')
    .option('--requires-sequential-signoff', 'enforce sequential signoff')
    .option('--enabled', 'enable the policy', true)
    .option('--store <file>', 'path to workflow state store (JSON mode)')
    .option('--db-host <host>', 'database host (Postgres mode)')
    .option('--db-port <port>', 'database port (Postgres mode)', '5432')
    .option('--db-name <name>', 'database name (Postgres mode)')
    .option('--db-user <user>', 'database user (Postgres mode)')
    .option('--db-password <password>', 'database password (Postgres mode)')
    .option('--actor <name>', 'actor to record in audit entries', 'system')
    .action(policy);

program
    .command('approve')
    .description('Record an approval decision')
    .requiredOption('--approval-id <id>', 'approval identifier')
    .requiredOption('--action <decision>', 'approve, reject, or cancel')
    .option('--comment <text>', 'approval comment', '')
    .option('--store <file>', 'path to workflow state store (JSON mode)')
    .option('--db-host <host>', 'database host (Postgres mode)')
    .option('--db-port <port>', 'database port (Postgres mode)', '5432')
    .option('--db-name <name>', 'database name (Postgres mode)')
    .option('--db-user <user>', 'database user (Postgres mode)')
    .option('--db-password <password>', 'database password (Postgres mode)')
    .option('--actor <name>', 'actor to record in audit entries', 'system')
    .action(approve);

program
    .command('db-init')
    .description('Initialize Postgres database schema for workflow management')
    .option('--db-host <host>', 'database host', 'localhost')
    .option('--db-port <port>', 'database port', '5432')
    .option('--db-name <name>', 'database name', 'formula_factory')
    .option('--db-user <user>', 'database user', 'postgres')
    .option('--db-password <password>', 'database password')
    .action(dbInit);

program
    .command('executor')
    .description('Start the background job executor (polls publish_job queue)')
    .option('--db-host <host>', 'database host', 'localhost')
    .option('--db-port <port>', 'database port', '5432')
    .option('--db-name <name>', 'database name', 'formula_factory')
    .option('--db-user <user>', 'database user', 'postgres')
    .option('--db-password <password>', 'database password')
    .option('--pool-size <size>', 'connection pool size', '10')
    .action(executor);

program
    .command('migrate')
    .description('Migrate JSON workflow state to Postgres database')
    .requiredOption('--source <file>', 'path to workflow-state.json file')
    .option('--db-host <host>', 'database host', 'localhost')
    .option('--db-port <port>', 'database port', '5432')
    .option('--db-name <name>', 'database name', 'formula_factory')
    .option('--db-user <user>', 'database user', 'postgres')
    .option('--db-password <password>', 'database password')
    .action(migrate);

program.parse(process.argv);

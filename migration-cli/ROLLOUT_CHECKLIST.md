# Formula Factory Rollout Checklist

## Before rollout

- [ ] Confirm schema migration scripts are applied in staging.
- [ ] Run `npm test` in `migration-cli/` and save the latest regression output.
- [ ] Verify the discovery report is empty or understood for each duplicate cluster.
- [ ] Confirm RBAC rules for promote/rollback actions are enforced.
- [ ] Validate indexes on `formula`, `formula_version`, and mapping tables.

## Staged validation

- [ ] Run `discover` against production-like data.
- [ ] Stage only a small representative batch first.
- [ ] Run validation with dependency resolution enabled.
- [ ] Review any semantic/type failures before promotion.
- [ ] Confirm audit events are written for each stage/validate action.

## Production promote

- [ ] Promote one batch at a time.
- [ ] Freeze writes to affected records during transactional promote.
- [ ] Verify post-promote counts match staging counts.
- [ ] Compare sample outputs between old and new formula resolution.
- [ ] Record the promotion id for rollback.

## Rollback criteria

- [ ] Roll back if validation misses a broken dependency or semantic regression.
- [ ] Roll back if performance degrades beyond the agreed threshold.
- [ ] Roll back if audit or RBAC enforcement is missing.
- [ ] Re-run the same regression vectors after rollback.

## Test matrix

- [ ] Duplicate discovery clusters.
- [ ] Dependency cycle detection.
- [ ] Missing formula references.
- [ ] Permission denied for promote/rollback.
- [ ] Successful promote followed by deterministic rollback.

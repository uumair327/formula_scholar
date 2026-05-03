Running tests

1. Install dependencies:

```bash
cd migration-cli
npm install
```

2. Run tests:

```bash
npm test
```

Notes

- The test suite currently runs a unit/integration check against the `discover` stub which writes a CSV file. This verifies the scaffolding and provides a starting point for richer regression vectors and determinism tests.
- Add more vector-driven tests under `tests/` and use `tests/vectors/example_vectors.json` as sample input.

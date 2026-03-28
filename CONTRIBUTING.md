# Contributing to Formula Scholar

Thank you for your interest in contributing! This document provides guidelines and standards for contributing to Formula Scholar.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Architecture Guidelines](#architecture-guidelines)
- [Commit Convention](#commit-convention)
- [Pull Request Process](#pull-request-process)
- [Code Style](#code-style)
- [Testing](#testing)

---

## Code of Conduct

This project adheres to the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

---

## Getting Started

1. **Fork** the repository on GitHub
2. **Clone** your fork locally:
   ```bash
   git clone https://github.com/your-username/formula_scholar.git
   cd formula_scholar
   ```
3. **Install dependencies**:
   ```bash
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   ```
4. Create a **feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

---

## Development Workflow

### Branch Naming

| Type | Pattern | Example |
|------|---------|---------|
| Feature | `feature/short-description` | `feature/dark-mode` |
| Bug Fix | `fix/short-description` | `fix/login-crash` |
| Refactor | `refactor/short-description` | `refactor/dashboard-cubit` |
| Docs | `docs/short-description` | `docs/api-readme` |
| Chore | `chore/short-description` | `chore/update-deps` |

### Before Submitting

- [ ] Run `dart analyze lib` — must have **zero issues**
- [ ] Run `dart format lib` — must be fully formatted
- [ ] Run `flutter test` — all tests must pass
- [ ] Ensure no secrets, API keys, or credentials are committed

---

## Architecture Guidelines

This project uses **Hexagonal Architecture (Ports & Adapters)**. All contributions must follow these rules:

### 1. Domain Layer (Inner Ring) — Pure Dart Only
- **Entities**: Extend `Equatable`, no Flutter imports
- **Ports**: Abstract interfaces defining contracts (`*RepositoryPort`, `*DataSourcePort`)
- **Use Cases**: One class per business operation, injectable via `@injectable`
- **No dependencies** on Flutter, infrastructure, or presentation

### 2. Infrastructure Layer (Outer Ring) — Adapters
- **Adapters** implement `DataSourcePort` interfaces
- **Repository Impls** wrap adapter calls in `Result<T>` (Success/Error)
- Annotated with `@LazySingleton(as: PortType)` for DI

### 3. Presentation Layer (Outer Ring) — UI
- **Cubits** depend on **Use Cases**, not repositories
- Use `Result` pattern matching (`switch`) for typed error handling
- Pages use `BlocBuilder`/`BlocListener`

### 4. Dependency Rule
All dependencies point **inward**:
```
Infrastructure → Domain ← Presentation
```
Never import from `infrastructure/` in `domain/` or `presentation/`.

### 5. Adding a New Feature
```
lib/features/new_feature/
├── domain/
│   ├── entities/
│   ├── ports/
│   │   ├── new_feature_repository_port.dart
│   │   └── new_feature_data_source_port.dart
│   ├── usecases/
│   └── domain.dart                    # barrel
├── infrastructure/
│   ├── adapters/
│   │   └── new_feature_local_adapter.dart
│   ├── repositories/
│   │   └── new_feature_repository_impl.dart
│   └── infrastructure.dart            # barrel
├── presentation/
│   ├── cubit/
│   ├── pages/
│   ├── widgets/
│   └── presentation.dart              # barrel
└── new_feature.dart                   # feature barrel
```

---

## Commit Convention

We follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <short description>

[optional body]

[optional footer(s)]
```

### Types

| Type | Description |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `style` | Formatting, no code change |
| `refactor` | Code change that neither fixes a bug nor adds a feature |
| `perf` | Performance improvement |
| `test` | Adding or correcting tests |
| `build` | Build system or dependencies |
| `ci` | CI/CD configuration |
| `chore` | Other changes (tooling, config) |
| `revert` | Reverts a previous commit |

### Examples

```
feat(dashboard): add daily challenge card
fix(algebra): fix formula bookmark toggle not persisting
refactor(profile): migrate cubit to use cases
docs(readme): update architecture diagram
test(geometry): add unit tests for GetGeometryTopicsUseCase
ci: add GitHub Actions workflow for Flutter analyze
```

---

## Pull Request Process

1. **Title**: Use conventional commit format (e.g., `feat(dashboard): add search`)
2. **Description**: Explain what and why, not just how
3. **Screenshots**: Include before/after for UI changes
4. **Testing**: Describe what tests were added or updated
5. **Breaking Changes**: Clearly mark any breaking changes

### PR Checklist

```markdown
- [ ] Code follows the project's architecture guidelines
- [ ] `dart analyze lib` passes with zero issues
- [ ] `dart format lib` produces no changes
- [ ] Tests pass (`flutter test`)
- [ ] New code has appropriate test coverage
- [ ] Documentation updated (if applicable)
- [ ] No secrets or credentials committed
- [ ] Conventional commit messages used
```

---

## Code Style

### Dart Formatting
- Use `dart format` with default settings (line length 80)
- Enable all recommended lints via `analysis_options.yaml`

### Naming Conventions
| What | Convention | Example |
|------|-----------|---------|
| Files | `snake_case` | `dashboard_cubit.dart` |
| Classes | `PascalCase` | `DashboardCubit` |
| Ports | `PascalCase` + `Port` suffix | `DashboardRepositoryPort` |
| Adapters | `PascalCase` + `Adapter` suffix | `DashboardLocalAdapter` |
| Use Cases | `PascalCase` + `UseCase` suffix | `GetStudyProgressUseCase` |
| Variables/functions | `camelCase` | `loadDashboard()` |
| Constants | `camelCase` in class | `AppColors.primary` |
| Log Tags | Defined in `AppLogTags` | Always use constants, never strings |

### Documentation
- All public APIs must have `///` doc comments
- Port interfaces must describe their hexagonal role (primary/driven)
- Use `@override` annotation on all overridden methods

---

## Testing

### Test Structure
```
test/
├── core/
│   └── error/
│       └── result_test.dart
├── features/
│   └── {feature}/
│       ├── domain/
│       │   └── usecases/
│       │       └── get_*_use_case_test.dart
│       ├── infrastructure/
│       │   └── repositories/
│       │       └── *_repository_impl_test.dart
│       └── presentation/
│           └── cubit/
│               └── *_cubit_test.dart
└── helpers/
    └── mocks.dart
```

### Test Requirements
- All use cases **must** have unit tests
- All cubits **must** have unit tests covering all states
- Repository impls should test both success and error paths
- Use `mocktail` or `mockito` for mocking

---

## Questions?

If you have questions about contributing, please open a [Discussion](https://github.com/your-username/formula_scholar/discussions) or reach out to the maintainers.

Thank you for making Formula Scholar better! 🎉

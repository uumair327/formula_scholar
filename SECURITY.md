# Security Policy

## Supported Versions

| Version | Supported         |
| ------- | ----------------- |
| 1.x.x   | ✅ Active support |
| < 1.0   | ❌ Not supported  |

## Reporting a Vulnerability

We take security seriously. If you discover a security vulnerability, please follow responsible disclosure:

### ⚠️ DO NOT open a public GitHub Issue for security vulnerabilities.

Instead:

1. **Email**: Send a detailed report to **security@formulascholar.dev** (or the maintainer's email)
2. **Include**:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)
3. **Response Time**: We aim to acknowledge reports within **48 hours** and provide a resolution within **7 days** for critical issues.

## Security Best Practices for Contributors

### 🔐 Secrets & Credentials

- **NEVER** commit API keys, passwords, tokens, or service account files
- **NEVER** commit `firebase_options.dart`, `google-services.json`, `GoogleService-Info.plist`, or `*.keystore` files
- Use `.env.example` as a template — copy to `.env` (which is gitignored)
- Firebase Admin SDK keys must be stored **outside the repository**
- Use `FIREBASE_SERVICE_ACCOUNT_PATH` or a command-line path argument for local admin scripts
- Use environment variables or secure vaults for CI/CD secrets

### 🔑 Firebase Security

- Configure Firebase Security Rules to restrict data access
- Enable App Check to prevent API abuse
- Restrict API keys in the Google Cloud Console (limit to your app's package name and SHA fingerprint)
- Use Firebase Authentication with appropriate providers only

### 📋 Pre-Commit Checklist

Before every commit, verify:

- [ ] No hardcoded secrets, tokens, or API keys in code
- [ ] No service account JSON files in the repo
- [ ] No keystore files committed
- [ ] `.gitignore` includes all sensitive file patterns
- [ ] Environment variables used for all configurable values
- [ ] Any Firebase admin scripts resolve credentials from local-only paths

### 🛡️ Recommended Tools

- **[git-secrets](https://github.com/awslabs/git-secrets)** — Prevents committing secrets
- **[trufflehog](https://github.com/trufflesecurity/trufflehog)** — Scans git history for secrets
- **[gitleaks](https://github.com/gitleaks/gitleaks)** — Secret detection in git repos

## Disclosure Policy

- Vulnerabilities will be patched and released as soon as possible
- We will credit reporters (unless they prefer anonymity)
- A security advisory will be published on GitHub after the fix is deployed

## Contact

For security concerns, reach out to the project maintainers through:

- GitHub Security Advisories (preferred)
- Direct email to maintainers listed in the repository

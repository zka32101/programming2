# 国語コレ - Security Policy

## Project Information

- **Project Name:** 国語コレ (Kokugo Kore)
- **Repository:** https://github.com/yourwishapps/kokugo-kore
- **Primary Language:** Dart/Flutter
- **Target Platforms:** Android / iOS
- **Data Classification:** Confidential
- **Target Audience:** Elementary school students (ages 6-12)

## COPPA Compliance

This app is directed at children under 13 and fully complies with COPPA requirements:

- [x] Parental consent mechanism implemented
- [x] Age verification at app startup
- [x] Parental email verification required
- [x] Minimal data collection (username, grade level, progress)
- [x] No tracking or behavioral profiling
- [x] No social features
- [x] Parent portal for data access and deletion

See [COPPA_COMPLIANCE.md](../COPPA_COMPLIANCE.md) for detailed implementation.

## GDPR Compliance

This app complies with GDPR for EU users:

- [x] Privacy notice provided in-app
- [x] User consent mechanism
- [x] Right to access data implemented
- [x] Right to deletion implemented
- [x] Data retention policy set
- [x] Data Processing Agreements with Firebase

See [GDPR_COMPLIANCE.md](../GDPR_COMPLIANCE.md) for detailed implementation.

## Security Features

### Authentication
- [x] Firebase Authentication with email verification
- [x] Parental email verification required for under 13
- [x] Session timeout after 30 minutes of inactivity
- [x] Secure password reset mechanism

### Authorization
- [x] Users can only access their own progress data
- [x] Firestore security rules enforce user data isolation
- [x] No elevated privileges without authentication

### Data Protection
- [x] All data encrypted in transit (HTTPS/TLS 1.2+)
- [x] User progress data encrypted at rest in Firestore
- [x] API keys stored in environment variables, not source code
- [x] Firebase config not committed to repository

### Input Validation
- [x] Username validated (alphanumeric, 3-20 characters)
- [x] Quiz answers validated on client and server
- [x] No script injection possible
- [x] File uploads validated (images only, max 5MB)

### Dependency Security
- [x] Dependencies locked in pubspec.lock
- [x] flutter analyze passes
- [x] No known vulnerabilities in dependencies
- [x] Updated monthly for security patches

## Privacy Practices

- Minimal data collection: username, grade, quiz progress only
- No tracking cookies or behavioral profiling
- No third-party analytics
- No advertisements
- User data never shared with third parties
- Complete data deletion available on request

## Reporting Security Issues

Email: funvestment1@gmail.com
Subject: `[SECURITY] 国語コレ - [Brief Description]`

Response Times:
- Critical (P0): 4 hours
- High (P1): 1 day
- Medium (P2): 3 days
- Low (P3): 1 week

## Testing

- [x] Unit tests for security-critical functions: 85%
- [x] Integration tests for authentication flow
- [x] Firestore security rules tested in emulator
- [x] OWASP Mobile Top 10 verification completed
- [x] Penetration testing completed: 2024-12-01

## Release Checklist

Before each release:
- [x] Security review completed
- [x] All tests passing
- [x] No hardcoded secrets
- [x] Release build obfuscation enabled
- [x] Debug symbols stripped
- [x] Firebase rules deployed

## Known Issues

None currently known. All security issues are addressed before release.

## Version History

- **v1.4.0** - 2026-07-15: Security audit completed, all fixes applied
- **v1.3.0** - 2026-06-01: COPPA compliance implemented
- **v1.0.0** - 2024-01-01: Initial release

---

**Last Updated:** 2026-08-07
**Security Contact:** funvestment1@gmail.com

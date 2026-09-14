# Evidence Rules

Store only sanitized evidence from the owned/authorized lab tenant.

## Required evidence chain

For any item marked **Lab validated**, keep enough evidence to reconstruct:

1. request;
2. approval;
3. before state where relevant;
4. change performed;
5. independent verification;
6. outcome and timestamps.

## Suggested naming

```text
screenshots/IAM-001-user-state.png
screenshots/IAM-001-finance-group.png
screenshots/IAM-006-before-groups.png
screenshots/IAM-006-after-groups.png
screenshots/IAM-007-disabled.png
exports/2026-09-14/users.csv
exports/2026-09-14/group-memberships.csv
access-reviews/2026-09-14-findings.csv
ticket-completions/IAM-007.md
```

## Redact before publishing

- real tenant IDs where unnecessary;
- real email addresses or names;
- tokens, secrets, passwords and recovery data;
- billing/subscription identifiers;
- employer, university or client data;
- IPs or device details that are not needed for the evidence claim.

A portal screenshot with no clear before/after or ticket relationship is weak evidence. Prefer small, claim-specific evidence.

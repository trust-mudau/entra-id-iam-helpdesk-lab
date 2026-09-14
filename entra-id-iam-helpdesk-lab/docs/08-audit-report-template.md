# IAM Audit Report Template

## Executive summary

Summarize what was reviewed, how many identities/groups/tickets were tested, key findings and overall control quality.

## Scope

- Microsoft Entra users
- Department/application groups
- Microsoft 365 licenses
- Exchange Online permissions where applicable
- Joiner/mover/leaver tickets
- Privileged access

## Findings table

| ID | Finding | Risk | Evidence | Remediation | Status |
|---|---|---|---|---|---|
| IAM-01 | Example: mover retained old department group | Medium | export filename | remove membership; update mover SOP | Open |

## Control tests

1. Disabled users have no inappropriate active access.
2. Department groups match current department.
3. Sensitive access has an approval record.
4. Leaver tickets meet the termination target.
5. Privileged roles/groups are limited to authorized administrators.
6. License reclamation is documented.
7. Ticket records contain verification evidence.

## Final statement

State clearly which controls were actually lab-validated and which remain design-only due to licensing or environment limits.

# Project Status and Evidence Standard

## Current state

The repository design is complete and automated preflight validation is active. **Live Microsoft tenant execution is still pending.**

### Automated preflight — passed

On 14 September 2026, GitHub Actions successfully executed:

- repository data/ticket validation;
- PowerShell syntax parsing across every `.ps1` file.

The repository validator returned:

`OK: 20 users, 10 groups, 27 planned memberships, 15 tickets.`

This is **synthetic/technical validation only**. It does not upgrade Entra ID, Microsoft 365, Exchange Online, joiner/mover/leaver, or governance tasks to **Lab validated** until those changes are executed in an owned/authorized Microsoft tenant and evidence is captured.

## Workstream status

| Workstream | Current status | Completion evidence |
|---|---|---|
| Repository/data integrity | Synthetic validation passed | Successful GitHub Actions validation run |
| PowerShell syntax | Synthetic validation passed | Successful CI parsing of all `.ps1` files |
| Tenant setup | Designed | Tenant overview screenshot with sensitive values redacted |
| Fictional users | Designed | Sanitized user export + sample screenshots |
| Department groups | Designed | Group export + membership evidence |
| License assignment | Designed | Sanitized license assignment evidence |
| Joiner workflow | Designed | Completed joiner ticket + user/group/license evidence |
| Mover workflow | Designed | Before/after membership evidence + approval record |
| Leaver workflow | Designed | Completed termination ticket + account-disabled/session-revocation evidence |
| Exchange Online tasks | Designed | Sanitized mailbox/delegation evidence |
| Access review | Designed | Review output if licensed, otherwise manual review export clearly labelled |
| IAM audit | Designed | Final audit report with findings and remediations |

## Evidence quality rules

A task is **Lab validated** only if all of the following exist:

1. A ticket or change request states what was requested.
2. The required approval/authorization is documented.
3. The change is executed in the test tenant.
4. The result is verified independently from the action itself.
5. Evidence is sanitized and stored.
6. The ticket records completion time and outcome.
7. Any failure, rollback, or exception is documented.

## Evidence labels

- **Designed** — documented but not executed.
- **Synthetic validation** — exercised against fictional data or automated static checks.
- **Lab validated** — executed in an owned/authorized Microsoft tenant with sanitized proof.
- **Production validated** — not claimed by this repository.

## What this project does not claim

This repository does not claim employment as an IAM administrator, production Microsoft 365 ownership, enterprise-scale ticket volume, or access to a real employer's confidential systems.

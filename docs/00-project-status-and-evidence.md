# Project Status and Evidence Standard

## Current default state

Everything starts as **Designed** until executed in the lab.

| Workstream | Initial status | Completion evidence |
|---|---|---|
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

## What this project does not claim

This repository does not claim employment as an IAM administrator, production Microsoft 365 ownership, enterprise-scale ticket volume, or access to a real employer's confidential systems.

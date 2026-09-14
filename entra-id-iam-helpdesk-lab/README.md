# Microsoft Entra ID / Microsoft 365 IAM Helpdesk Lab

> A recruiter-facing IAM service-desk portfolio project demonstrating identity lifecycle administration, access control, ticket discipline, Microsoft Graph PowerShell, Microsoft 365/Exchange workflows, access governance, and audit evidence.

## Current status

**Design complete / hands-on tenant validation pending.** This repository does not present design documents or synthetic tickets as production experience.

Evidence labels used throughout:

- **Designed** — documented but not executed.
- **Synthetic validation** — exercised against fictional data only.
- **Lab validated** — executed in an owned/authorized Microsoft tenant and supported by sanitized evidence.
- **Production validated** — not claimed by this project.

## Why this project exists

The lab is intentionally narrower than a general cybersecurity capstone. It models the operational work of an IAM / IT Helpdesk Technician supporting Microsoft Entra ID and Microsoft 365: creating identities, granting and removing group-based access, onboarding/offboarding, handling role changes, processing approvals, working to ticket SLAs, verifying outcomes, and producing an audit trail.

The fictional organization is **Northstar Services Group** with 20 users across Finance, People Operations, Sales, Engineering and IT.

## What the finished lab demonstrates

| Job capability | Portfolio evidence |
|---|---|
| Entra ID user administration | Create/update/disable users, attributes, verification exports |
| Security groups & permissions | Department groups, sensitive groups, approved membership plan |
| Joiner / mover / leaver | End-to-end tickets, before/after states, session revocation, access cleanup |
| Microsoft 365 licensing | SKU discovery, controlled assignment/reclamation if tenant licensing permits |
| Exchange Online | Shared-mailbox FullAccess grant/removal and verification if Exchange is licensed |
| IAM ticket queue | 15 scenarios with P1–P4 priority, approvals, SLA targets and closure evidence |
| Access governance | Manual access certification plus native Access Reviews only if licensed |
| Audit & compliance | Approval register, exports, verification, findings/remediation report |
| Automation | Microsoft Graph PowerShell with `ShouldProcess`, verification and evidence output |
| Least privilege | Sensitive access separated from baseline department access; no routine Global Admin dependency |

## Fast path

1. Read `docs/10-lab-execution-guide.md`.
2. Run `python tools/validate_repo.py`.
3. Prepare a safe Microsoft test tenant.
4. Install modules with `scripts/Install-LabPrerequisites.ps1`.
5. Connect using `scripts/Connect-IamLab.ps1`.
6. Build groups/users, then execute IAM-001, IAM-006 and IAM-007 first.
7. Capture sanitized evidence and update the corresponding ticket files.
8. Run audit exports and access-review checks.
9. Complete `reports/FINAL-IAM-AUDIT.md`.

## High-value scenarios

- **IAM-001 Joiner:** Finance starter receives only approved baseline access and an available M365 license.
- **IAM-006 Mover:** Finance -> People Operations; old Finance access must be removed before closure.
- **IAM-007 P1 Termination:** disable account, revoke sessions, remove access, verify, and calculate SLA.
- **IAM-010 Least privilege:** grant helpdesk scope while explicitly avoiding Global Administrator.
- **IAM-015 Residual-access incident:** identify a disabled identity that still has group access and remediate it.

## Repository structure

```text
entra-id-iam-helpdesk-lab/
├── README.md
├── SOURCES.md
├── docs/                 # design, SOPs, execution guide, governance, troubleshooting
├── data/                 # fictional identities, access plan, approvals, tickets, SLA matrix
├── tickets/              # 15 evidence-ready IAM ticket records
├── scripts/              # Graph / Exchange PowerShell automation
├── tools/                # local integrity and metrics checks
├── evidence/             # sanitized screenshots, exports and ticket completions
└── reports/              # final audit report
```

## Important evidence rule

A command that returns success is not enough. Every completed IAM task should have:

**request -> approval -> action -> independent verification -> sanitized evidence -> ticket closure**.

That sequence is one of the main skills this project is designed to demonstrate.

## Safety

Use only systems you own or are explicitly authorized to administer. Never commit passwords, tokens, recovery codes, tenant secrets, private keys, billing details, or real employee information. Keep licensed features labelled **Designed** if your tenant cannot execute them.

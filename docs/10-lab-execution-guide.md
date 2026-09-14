# Hands-On Lab Execution Guide

This is the core of the portfolio project. Complete the labs in order and keep every control **Designed** until you actually execute and verify it in a tenant you own or are authorized to administer.

## Phase 0 — Prepare safely

1. Use a dedicated test tenant, not an employer or school production tenant.
2. Install PowerShell 7 where practical, Microsoft Graph PowerShell, and ExchangeOnlineManagement.
3. Never commit passwords, refresh tokens, tenant secrets, private keys, recovery codes, or real-user data.
4. Replace `YOURTENANT.onmicrosoft.com` only in your private working copy or use the scripts' `-TenantDomain` parameters.
5. Run `tools/validate_repo.py` before publishing.

## Lab 1 — Tenant reconnaissance and least privilege

**Objective:** prove that you can connect, identify the tenant context, and work without defaulting to Global Administrator.

Actions:
- Connect with `scripts/Connect-IamLab.ps1`.
- Record the delegated Graph scopes in use.
- Export subscribed SKUs without exposing billing data.
- Document which admin role your lab administrator uses and why it is sufficient.

Evidence:
- `evidence/screenshots/LAB-01-graph-context.png`
- `evidence/exports/LAB-01-subscribed-skus.csv`
- short note explaining least privilege.

## Lab 2 — Build the identity baseline

**Objective:** create the fictional workforce and department/security groups **without pre-creating the onboarding scenario users**.

Reserve these users for the joiner tickets:
- `NSG019` — Tumi Sibiya (`IAM-001`)
- `NSG020` — Rethabile Moagi (`IAM-002`)

Actions:

```powershell
$InitialPassword = Read-Host "Temporary lab password" -AsSecureString
$ScenarioJoiners = @('NSG019','NSG020')

.\scripts\New-LabUsers.ps1 `
  -CsvPath .\data\users.csv `
  -TenantDomain YOURTENANT.onmicrosoft.com `
  -InitialPassword $InitialPassword `
  -ExcludeEmployeeId $ScenarioJoiners

.\scripts\Initialize-LabGroups.ps1 `
  -AccessMatrixCsv .\data\access-matrix.csv

.\scripts\Set-LabGroupMemberships.ps1 `
  -MembershipPlanCsv .\data\group-membership-plan.csv `
  -UsersCsv .\data\users.csv `
  -TenantDomain YOURTENANT.onmicrosoft.com `
  -ExcludeEmployeeId $ScenarioJoiners
```

Then verify user attributes and group membership independently.

Evidence:
- user export;
- group export;
- two example user screenshots;
- one sensitive-group membership screenshot.

## Lab 3 — Joiner: IAM-001

**Objective:** handle a standard onboarding ticket end-to-end.

Target: Tumi Sibiya.

Actions:
1. Validate `APR-001`.
2. Confirm no duplicate user exists.
3. Create/verify the user account and attributes.
4. Add `SG-FIN-Users`.
5. Assign an available M365 license only if the tenant has one.
6. Verify account enabled state, group membership, and license state.
7. Complete `tickets/IAM-001.md` and store evidence.

Success criteria:
- request and approval are traceable;
- account state matches the request;
- no sensitive Finance group is granted accidentally;
- verification is separate from the change action.

## Lab 4 — Access request: IAM-003

**Objective:** show that sensitive access is approval-gated.

Target: Tumi Sibiya -> `SG-FIN-Payments-Approvers`.

Process:
- first document what you would do if the approval were missing: **do not grant**;
- then use the fictional approved state in `approval-register.csv`;
- add the user to the group;
- verify membership;
- record the approval reference in the ticket.

## Lab 5 — Mover: IAM-006

**Objective:** demonstrate that a mover is a remove-and-add workflow, not only an add workflow.

Target: Thabo Nkosi, Finance -> People Operations.

Actions:
1. Export before-state memberships.
2. Remove Finance baseline and any Finance-only delegation.
3. Update department/job attributes for the fictional scenario.
4. Add People Operations baseline.
5. Check for residual Finance access.
6. Export after-state memberships.
7. Complete the ticket with a before/after comparison.

Critical interview point: old access must be actively removed to prevent privilege accumulation.

## Lab 6 — P1 immediate termination: IAM-007

**Objective:** demonstrate time-critical offboarding.

Target: Lwazi Mthembu.

Actions:
1. Record the authorized HR request timestamp.
2. Run `Invoke-LabOffboarding.ps1`.
3. Disable sign-in first.
4. Revoke sign-in sessions.
5. Remove direct group memberships that are safe to remove.
6. Reclaim **directly assigned** licenses only if your lab policy calls for it; group-based licenses are handled through group membership.
7. Handle Exchange mailbox/delegation separately if licensed.
8. Verify the account is disabled and the target groups no longer contain the user.
9. Calculate completion minutes against the 15-minute lab SLA.

Evidence should make the sequence visible: **cut off access first, clean up second**.

## Lab 7 — Exchange Online: IAM-012 and IAM-013

Complete only if your tenant has Exchange Online.

- Connect using modern authentication.
- Create or use a fictional shared mailbox.
- For IAM-012, grant approved FullAccess to the Finance user.
- Verify using `Get-EXOMailboxPermission` where available.
- For IAM-013, remove the old HR delegation as part of the mover scenario.
- Verify removal.

Do not mark this phase Lab validated if the tenant lacks Exchange Online.

## Lab 8 — Access governance review: IAM-009 and IAM-015

Works in every tenant as a manual control.

1. Run `Export-IamAuditSnapshot.ps1`.
2. Run `Test-IamAccessAgainstPlan.ps1`.
3. Review for:
   - disabled accounts retaining groups;
   - cross-department residue;
   - sensitive groups without approval references;
   - non-IT members in helpdesk group;
   - duplicate or orphaned identities.
4. Introduce one safe lab-only misconfiguration if you want a remediation example, then correct it.
5. Re-run the audit and show the finding closed.

If your tenant has licensed native Access Reviews, add that as a second validation. Do not substitute documentation for actual execution.

## Lab 9 — IAM metrics and service-desk quality

For every completed ticket record:
- request timestamp;
- start timestamp;
- completion timestamp;
- SLA target;
- SLA met/missed;
- approval reference;
- technician action summary;
- independent verification;
- evidence file paths.

Use `tools/calculate_metrics.py` after filling `data/ticket-results.csv`.

Recruiter-facing metrics can include:
- tickets completed;
- SLA attainment;
- inappropriate memberships detected/remediated;
- average completion time by priority;
- joiner/mover/leaver verification pass rate.

## Lab 10 — Final audit report

Copy `docs/08-audit-report-template.md` to `reports/FINAL-IAM-AUDIT.md` and complete it from actual evidence. The conclusion must separate:

- **Lab validated** controls;
- **Synthetic validation**;
- **Designed only** controls because of licensing/environment limits.

That distinction is part of the project quality.

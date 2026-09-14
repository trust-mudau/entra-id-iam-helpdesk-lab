# Access Governance

## Objective

Demonstrate that access is not only granted correctly but also reviewed, justified, and removed when no longer needed.

## Manual access review (works without premium governance features)

1. Export all users and group memberships.
2. Compare membership to `data/access-matrix.csv`.
3. Flag:
   - disabled users still in access groups;
   - users with groups from a previous department;
   - sensitive groups without documented approval;
   - privileged groups with non-IT users;
   - duplicate or orphaned accounts.
4. Record each finding, owner, risk and remediation.
5. Re-export after remediation.

## Native Entra access reviews

If your tenant is appropriately licensed, configure a review for selected group/application access. Capture sanitized evidence of:

- review scope;
- reviewer;
- decision outcome;
- removed access;
- completion date.

If the feature is not licensed, keep it labelled **Designed** and use the manual review above. Do not imply the native feature was executed.

## Governance KPIs for the lab

- Provisioning accuracy rate.
- Termination completion time.
- Tickets completed within target SLA.
- Number of inappropriate memberships detected.
- Number of stale/disabled accounts with residual access.
- Number of access exceptions without approval evidence.

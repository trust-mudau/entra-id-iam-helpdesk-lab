# Joiner / Mover / Leaver SOP

## Joiner

### Inputs required
- Approved ticket
- Legal/display name
- Start date
- Department
- Job title
- Manager
- Required applications/groups
- License type

### Procedure
1. Validate requester and approval.
2. Confirm no duplicate identity exists.
3. Create the user with the correct UPN and attributes.
4. Set usage location if licensing requires it.
5. Assign baseline department group(s).
6. Assign approved application/security groups.
7. Assign Microsoft 365 license if available/required.
8. Configure mailbox-related settings if applicable.
9. Require secure initial authentication setup.
10. Verify sign-in/account state and group/license membership.
11. Record evidence and close ticket.

## Mover

The mover workflow is not "add new access and leave old access intact."

1. Confirm approved role/department change.
2. Export current memberships.
3. Identify access that must be removed.
4. Remove obsolete department/application access.
5. Add new approved access.
6. Reassess sensitive or privileged groups separately.
7. Verify effective access.
8. Attach before/after evidence.
9. Close ticket with exceptions clearly documented.

## Leaver / termination

### Standard leaver
1. Validate HR/authorized termination request and effective time.
2. Disable sign-in/account.
3. Revoke active sign-in sessions where available.
4. Remove privileged and application group memberships.
5. Remove/reclaim licenses according to policy.
6. Apply mailbox/data-retention steps defined by policy.
7. Remove delegated mailbox/app permissions where required.
8. Record all actions and timestamps.
9. Verify account is disabled and inappropriate access is gone.
10. Close ticket.

### Immediate termination

Treat as a priority security event. Sequence the access cutoff first; cleanup/documentation follows immediately after. Record exact request and completion timestamps to calculate SLA performance.

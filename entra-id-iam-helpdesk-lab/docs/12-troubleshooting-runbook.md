# IAM Helpdesk Troubleshooting Runbook

Use this as an interview and lab troubleshooting framework.

## User cannot sign in

Check in order:
1. Correct identity/UPN and account exists.
2. `AccountEnabled` state.
3. Password/reset or authentication-method issue.
4. License state if the failure is workload-specific.
5. Group-based access or app assignment.
6. Conditional Access/sign-in logs if licensed and available.
7. Service health/workload issue.
8. Record what changed and verify after remediation.

## User cannot access an application

Separate authentication from authorization:
- Can the user authenticate?
- Is the enterprise application assigned directly or through a group?
- Is group membership current?
- Is provisioning required and has it succeeded?
- Is the requested access approved?
- Is there stale access from a former role?

## Mailbox or shared mailbox access fails

- Confirm Exchange Online license/mailbox provisioning where relevant.
- Verify mailbox identity.
- Query mailbox permissions rather than relying only on the admin portal.
- Confirm the correct permission type (FullAccess vs SendAs vs SendOnBehalf).
- Check whether the change has propagated before repeatedly modifying permissions.

## Offboarded user still appears to have access

- Verify account disabled state.
- Revoke sign-in sessions.
- Inspect direct and group-derived access separately.
- Check dynamic groups: they cannot be cleaned up like assigned groups.
- Check mailbox delegation/app-specific access.
- Verify actual state after each remediation.

## Access request has no approval

Do not grant it. Record that required authorization is missing, contact the appropriate approver/requester, and keep the ticket pending. SLA pressure does not justify bypassing an access control.

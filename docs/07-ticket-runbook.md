# IAM Ticket Runbook

## Required fields

Every IAM ticket should contain:

- Ticket ID
- Request type
- Requester
- Target user
- Department
- Requested access/change
- Business justification
- Required approval
- Priority
- SLA target
- Request timestamp
- Completion timestamp
- Technician action summary
- Validation performed
- Evidence reference
- Final status

## Priority model

| Priority | Example | Lab target |
|---|---|---|
| P1 | Immediate termination / suspected unauthorized access | 15 minutes |
| P2 | New starter blocked on start day / critical access removal | 60 minutes |
| P3 | Standard onboarding/mover/access request | 4 business hours |
| P4 | Routine review/documentation request | 1 business day |

## Closure quality check

Do not close a ticket merely because a command ran successfully. Verify the intended state separately. For example, after removing a user from a group, query membership and confirm the user is absent.

# Identity and Access Model

## Design principles

1. Grant access through groups where possible.
2. Separate department membership from application privilege.
3. Use least privilege and avoid permanent admin rights for ordinary users.
4. Require approval for sensitive access changes.
5. Remove obsolete access during role changes instead of only adding new access.
6. Treat termination as a security-sensitive, time-critical workflow.

## Core groups

| Group | Purpose | Approval owner |
|---|---|---|
| SG-FIN-Users | Baseline Finance access | Finance manager |
| SG-HR-Users | Baseline People Operations access | HR manager |
| SG-SALES-Users | Baseline Sales access | Sales manager |
| SG-ENG-Users | Baseline Engineering access | Engineering manager |
| SG-IT-Users | Baseline IT access | IT manager |
| SG-FIN-Payments-Approvers | Sensitive payment approval function | Finance director |
| SG-HR-Confidential | Sensitive HR records | HR director |
| SG-SALES-CRM-Write | CRM modification rights | Sales manager |
| SG-ENG-DevOps-Contributors | Engineering deployment access | Engineering lead |
| SG-IT-Helpdesk | Standard helpdesk admin scope | IT manager |

## Role model

Standard users receive no Entra admin role. Helpdesk privileges should be tested with the least-privileged role available for the task. Do not use Global Administrator for routine work.

## Separation-of-duties examples

- A Finance employee should not automatically receive `SG-FIN-Payments-Approvers`.
- A People Operations employee should not automatically receive IT helpdesk privileges.
- A mover leaving Finance must lose Finance groups before or as the new department access is granted.
- A terminated account should not remain enabled merely because mailbox preservation is still required.

# Microsoft 365 and Exchange Online Operations

This section should be validated only in a tenant where the relevant Microsoft 365/Exchange features are licensed.

## Common IAM/helpdesk operations to practice

- Confirm account and license state.
- Confirm mailbox existence/provisioning.
- Review mailbox forwarding settings.
- Grant/remove approved mailbox delegation.
- Validate distribution/Microsoft 365 group membership.
- Remove inappropriate delegation during mover/leaver workflows.
- Distinguish identity disablement from mailbox/data-retention requirements.

## Exchange Online connection

```powershell
Connect-ExchangeOnline -UserPrincipalName admin@yourtenant.onmicrosoft.com
```

## Validation examples

```powershell
Get-EXOMailbox -Identity user@yourtenant.onmicrosoft.com
Get-MailboxPermission -Identity user@yourtenant.onmicrosoft.com
Get-RecipientPermission -Identity user@yourtenant.onmicrosoft.com
```

Use only commands/features available in your tenant and document the exact result. Do not publish real addresses or tenant-sensitive data.

## Lab cases

1. New employee receives mailbox after licensing.
2. Finance shared mailbox delegation is granted only with manager approval.
3. Mover loses old shared mailbox access.
4. Terminated user is blocked from sign-in while mailbox/data handling follows policy.

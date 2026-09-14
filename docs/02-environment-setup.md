# Environment Setup

## Option A — Microsoft 365 E5 developer sandbox

Use this only if you qualify for the Microsoft 365 Developer Program sandbox. The E5 sandbox is ideal because it includes Microsoft 365 workloads and sample users.

## Option B — Free Microsoft Entra tenant

Use a free Entra tenant for core user/group administration. Some security/governance features require premium licensing. Keep those sections as **Designed** or **Manual synthetic validation** unless you have an eligible trial or subscription.

## Local tools

Install current supported versions of:

```powershell
Install-Module Microsoft.Graph -Scope CurrentUser
Install-Module ExchangeOnlineManagement -Scope CurrentUser
```

Then validate:

```powershell
Get-Module Microsoft.Graph -ListAvailable
Get-Module ExchangeOnlineManagement -ListAvailable
```

## Tenant variables

Never hard-code credentials. Use parameters/environment variables where practical.

Recommended lab values:

```text
Company: Northstar Services Group
Departments: Finance, People Operations, Sales, Engineering, IT
Users: 20 fictional users
UPN domain: yourtenant.onmicrosoft.com
```

## Evidence to capture

- Tenant overview with tenant ID/domain partially redacted.
- User list showing fictional accounts only.
- Group list.
- License page if applicable.
- Exchange admin center evidence if applicable.

Do not publish passwords, secret keys, recovery codes, tokens, real email addresses, or billing data.

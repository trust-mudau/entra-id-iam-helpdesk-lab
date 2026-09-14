# Publishing the Project to GitHub

## Repository name

Use:

`entra-id-iam-helpdesk-lab`

Recommended description:

> Hands-on Microsoft Entra ID / Microsoft 365 IAM service-desk lab covering joiner-mover-leaver workflows, group-based access, PowerShell automation, Exchange operations, ticket SLAs and access governance.

## Before publishing

Run:

```bash
python tools/validate_repo.py
```

Confirm:

- no passwords, tokens, tenant secrets or real employee data are present;
- evidence folders contain only sanitized material;
- the README still says **tenant validation pending** until you have executed the labs;
- any feature unavailable in your tenant remains **Designed**.

## Command-line publishing after creating the empty GitHub repo

From inside the project folder:

```bash
git init
git add .
git commit -m "Build Microsoft Entra IAM helpdesk lab"
git branch -M main
git remote add origin https://github.com/trust-mudau/entra-id-iam-helpdesk-lab.git
git push -u origin main
```

If Git asks for identity configuration, use the name/email associated with your own GitHub account; do not copy credentials into the repository.

## Suggested GitHub About section

**Description**

Microsoft Entra ID / M365 IAM helpdesk lab: JML lifecycle, access control, Graph PowerShell, Exchange permissions, ITSM tickets, access governance and audit evidence.

**Topics**

`microsoft-entra-id`, `iam`, `microsoft-365`, `powershell`, `microsoft-graph`, `exchange-online`, `identity-governance`, `helpdesk`, `access-control`, `cybersecurity`

## Pinning order on profile

For an IAM/helpdesk application, suggested top pins are:

1. `entra-id-iam-helpdesk-lab`
2. `enterprise-blue-team-security-lab`
3. `novacore-campus-network`
4. `Python-Security-Log-Analyzer`

This order makes the job-relevant project visible first instead of forcing the recruiter to infer IAM capability from broader security work.

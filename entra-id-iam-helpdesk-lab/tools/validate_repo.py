from pathlib import Path
import csv, sys
ROOT=Path(__file__).resolve().parents[1]
errors=[]
def rows(name):
    with open(ROOT/'data'/name, newline='', encoding='utf-8') as f: return list(csv.DictReader(f))
users=rows('users.csv'); matrix=rows('access-matrix.csv'); plan=rows('group-membership-plan.csv'); queue=rows('iam-ticket-queue.csv')
emp={u['EmployeeId'] for u in users}; groups={r['GroupName'] for r in matrix}; tickets={t['TicketId'] for t in queue}
for p in plan:
    if p['EmployeeId'] not in emp: errors.append(f"Unknown employee in plan: {p['EmployeeId']}")
    if p['GroupName'] not in groups: errors.append(f"Unknown group in plan: {p['GroupName']}")
    ref=p['ApprovalReference']
    if ref.startswith('IAM-') and ref not in tickets and ref not in {'IAM-BASELINE','IAM-APPROVED-SEED'}:
        errors.append(f"Unknown ticket/approval reference: {ref}")
for t in tickets:
    if not (ROOT/'tickets'/f'{t}.md').exists(): errors.append(f'Missing ticket file: {t}.md')
if errors:
    print('VALIDATION FAILED')
    for e in errors: print('-',e)
    sys.exit(1)
print(f'OK: {len(users)} users, {len(groups)} groups, {len(plan)} planned memberships, {len(queue)} tickets.')

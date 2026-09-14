from pathlib import Path
import csv
from datetime import datetime
ROOT=Path(__file__).resolve().parents[1]
path=ROOT/'data'/'ticket-results.csv'
rows=list(csv.DictReader(open(path, newline='', encoding='utf-8')))
completed=[r for r in rows if r.get('CompletionTimestampUtc')]
if not completed:
    print('No completed ticket results yet. Populate data/ticket-results.csv after executing labs.')
    raise SystemExit(0)
def dt(s): return datetime.fromisoformat(s.replace('Z','+00:00'))
mins=[]; met=0
for r in completed:
    elapsed=(dt(r['CompletionTimestampUtc'])-dt(r['RequestTimestampUtc'])).total_seconds()/60
    target=float(r['TargetMinutes'])
    mins.append(elapsed)
    met += elapsed <= target
print(f'Completed tickets: {len(completed)}')
print(f'SLA attainment: {met/len(completed):.1%}')
print(f'Average request-to-completion: {sum(mins)/len(mins):.1f} minutes')

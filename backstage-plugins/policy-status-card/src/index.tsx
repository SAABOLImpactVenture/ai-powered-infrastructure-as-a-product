import React, { useEffect, useState } from 'react';
import { InfoCard, Progress, StatusError, StatusOK } from '@backstage/core-components';

type CloudStatus = { ok: boolean; status: number; body?: any; error?: string };
type Aggregate = Record<'azure'|'aws'|'gcp'|'oci', CloudStatus>;

export const PolicyStatusCard = ({ endpoint = '/api/policy/aggregate', title = 'Policy Status' }: { endpoint?: string, title?: string }) => {
  const [data, setData] = useState<Aggregate | null>(null);
  const [err, setErr] = useState<string | null>(null);
  useEffect(() => {
    let mounted = true;
    fetch(endpoint).then(r => r.json()).then(j => { if (mounted) setData(j); }).catch(e => setErr(String(e)));
    const id = setInterval(() => {
      fetch(endpoint).then(r => r.json()).then(j => { if (mounted) setData(j); }).catch(e => setErr(String(e)));
    }, 5000);
    return () => { mounted = false; clearInterval(id); };
  }, [endpoint]);
  if (err) return <InfoCard title={title}><StatusError> {err} </StatusError></InfoCard>;
  if (!data) return <InfoCard title={title}><Progress /></InfoCard>;
  const clouds: Array<keyof Aggregate> = ['azure','aws','gcp','oci'];
  const allOk = clouds.every(c => data[c]?.ok);
  return (
    <InfoCard title={title} subheader={allOk ? 'OK' : 'VIOLATIONS'}>
      <table style={{ width: '100%' }}>
        <thead><tr><th align="left">Cloud</th><th align="left">Status</th></tr></thead>
        <tbody>
          {clouds.map(c => {
            const ok = data[c]?.ok;
            return <tr key={c}><td>{c.toUpperCase()}</td><td>{ok ? <StatusOK/> : <StatusError/>}</td></tr>
          })}
        </tbody>
      </table>
    </InfoCard>
  );
};

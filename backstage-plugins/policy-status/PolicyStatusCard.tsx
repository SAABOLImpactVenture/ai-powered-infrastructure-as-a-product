
import React, { useEffect, useState } from 'react';

type Result = {
  name?: string;
  status?: string;
  evidence?: string;
  statusCode?: number;
  body?: any;
};

export const PolicyStatusCard: React.FC<{ dashboardUrl: string }> = ({ dashboardUrl }) => {
  const [rows, setRows] = useState<Result[]>([]);
  const [error, setError] = useState<string | undefined>(undefined);
  const [loading, setLoading] = useState<boolean>(true);

  const fetchData = async () => {
    setLoading(true);
    setError(undefined);
    try {
      const res = await fetch(dashboardUrl);
      const html = await res.text();
      // naive parse: extract <tbody> rows via regex (since the dashboard returns HTML)
      const matches = [...html.matchAll(/<tr><td>(.*?)<\/td><td>(.*?)<\/td><td>(.*?)<\/td><td><pre>(.*?)<\/pre><\/td><\/tr>/g)];
      const parsed: Result[] = matches.map(m => ({
        name: decodeHTMLEntities(m[1]),
        status: decodeHTMLEntities(m[2]),
        evidence: decodeHTMLEntities(m[3]),
        body: decodeHTMLEntities(m[4]),
      }));
      setRows(parsed);
    } catch (e:any) {
      setError(String(e));
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { fetchData(); }, [dashboardUrl]);

  return (
    <div style={{ border: '1px solid #ddd', borderRadius: 12, padding: 16 }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <h3 style={{ margin: 0 }}>Policy Status</h3>
        <button onClick={fetchData} disabled={loading} style={{ padding: '6px 10px' }}>
          {loading ? 'Refreshing...' : 'Refresh'}
        </button>
      </div>
      {error && <p style={{ color: 'red' }}>Error: {error}</p>}
      <table style={{ width: '100%', borderCollapse: 'collapse', marginTop: 12 }}>
        <thead>
          <tr>
            <th style={th}>Target</th>
            <th style={th}>Status</th>
            <th style={th}>Evidence</th>
            <th style={th}>Details</th>
          </tr>
        </thead>
        <tbody>
          {rows.map((r, i) => (
            <tr key={i}>
              <td style={td}>{r.name || '-'}</td>
              <td style={{...td, fontWeight: 600, color: r.status === 'OK' ? 'green' : (r.status === 'VIOLATIONS' || r.status === 'DRIFT') ? 'orange' : 'red' }}>{r.status || '-'}</td>
              <td style={td}><code>{r.evidence || '-'}</code></td>
              <td style={{...td, maxWidth: 500}}><pre style={{whiteSpace:'pre-wrap', wordBreak:'break-word'}}>{typeof r.body === 'string' ? r.body : JSON.stringify(r.body, null, 2)}</pre></td>
            </tr>
          ))}
          {rows.length === 0 && !loading && <tr><td colSpan={4} style={td}>No data</td></tr>}
        </tbody>
      </table>
    </div>
  );
};

const th: React.CSSProperties = { textAlign: 'left', borderBottom: '1px solid #eee', padding: 8 };
const td: React.CSSProperties = { borderBottom: '1px solid #f0f0f0', padding: 8 };

function decodeHTMLEntities(text: string) {
  const entities: Record<string,string> = { '&amp;':'&', '&lt;':'<', '&gt;':'>', '&quot;':'"', '&#39;':''' };
  return text.replace(/(&amp;|&lt;|&gt;|&quot;|&#39;)/g, m => entities[m] || m);
}

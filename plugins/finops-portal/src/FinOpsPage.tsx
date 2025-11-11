import React, { useEffect, useState } from 'react';
import { Content, Header, Page, Table, Progress } from '@backstage/core-components';

type CostItem = {
  date: string;
  provider: string;
  account: string;
  service: string;
  environment: string;
  cost: string;
  currency: string;
};

export const FinOpsPage = () => {
  const [rows, setRows] = useState<CostItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | undefined>(undefined);

  useEffect(() => {
    const run = async () => {
      try {
        const res = await fetch('/finops/costs');
        if (!res.ok) throw new Error(`HTTP ${res.status}`);
        const data = await res.json();
        setRows(data.items || []);
      } catch (e: any) {
        setError(e.message);
      } finally {
        setLoading(false);
      }
    };
    run();
  }, []);

  const columns = [
    { title: 'Date', field: 'date' },
    { title: 'Provider', field: 'provider' },
    { title: 'Account/Proj', field: 'account' },
    { title: 'Service', field: 'service' },
    { title: 'Env', field: 'environment' },
    { title: 'Cost', field: 'cost' },
    { title: 'Currency', field: 'currency' },
  ] as any;

  return (
    <Page themeId="tool">
      <Header title="FinOps Cost Overview" subtitle="Unified multi-cloud cost table" />
      <Content>
        {loading ? <Progress /> : error ? <div>Error: {error}</div> :
          <Table title="Costs" options={{ paging: true, search: true }} columns={columns} data={rows as any} />}
      </Content>
    </Page>
  );
};

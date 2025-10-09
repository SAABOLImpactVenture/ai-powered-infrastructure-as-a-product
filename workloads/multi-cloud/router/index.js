
import http from 'http';
import { request as httpRequest } from 'http';

const PORT = process.env.PORT ? Number(process.env.PORT) : 7071;
const targets = {
  azure: { mcp: process.env.AZURE_MCP || 'http://mcp-azure:8080', policy: process.env.AZURE_POLICY || 'http://mcp-policy-aws:8081/policy/check' },
  aws:   { mcp: process.env.AWS_MCP   || 'http://mcp-aws:8080',   policy: process.env.AWS_POLICY   || 'http://mcp-policy-aws:8081/policy/check' },
  gcp:   { mcp: process.env.GCP_MCP   || 'http://mcp-gcp:8080',   policy: process.env.GCP_POLICY   || 'http://mcp-policy-gcp:8081/policy/check' },
  oci:   { mcp: process.env.OCI_MCP   || 'http://mcp-oci:8080',   policy: process.env.OCI_POLICY   || 'http://mcp-policy-oci:8081/policy/check' },
};

function call(url, body) {
  return new Promise((resolve,reject) => {
    const u = new URL(url);
    const data = JSON.stringify(body||{});
    const req = httpRequest({ hostname:u.hostname, port:u.port, path:u.pathname, method:'POST', headers:{'content-type':'application/json','content-length':Buffer.byteLength(data)}}, res=>{
      let buf=''; res.on('data',d=>buf+=d.toString()); res.on('end',()=>resolve({status:res.statusCode, body:buf}))});
    req.on('error', reject); req.write(data); req.end();
  });
}

const server = http.createServer(async (req,res)=>{
  if (req.method==='POST' && req.url==='/run') {
    let b=''; req.on('data',d=>b+=d.toString()); req.on('end', async ()=>{
      try{
        const body = JSON.parse(b||'{}'); const { cloud, path } = body;
        const tgt = targets[cloud]; if (!tgt) throw new Error('unknown cloud');
        const plan = await call(`${tgt.mcp}/plan`, { path });
        const policy = await call(`${tgt.policy}`, { path });
        res.writeHead(200, {'content-type':'application/json'});
        res.end(JSON.stringify({ ok:true, plan: JSON.parse(plan.body), policy: JSON.parse(policy.body)}));
      } catch(e){ res.writeHead(500, {'content-type':'application/json'}); res.end(JSON.stringify({ ok:false, error:String(e)})); }
    });
    return;
  }
  res.writeHead(404); res.end();
});

server.listen(PORT, ()=>console.log('multi-cloud router on', PORT));

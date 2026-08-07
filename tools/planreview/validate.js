import fs from 'fs';
import path from 'path';
import Ajv from 'ajv';
import addFormats from 'ajv-formats';

const schemaPath = process.argv[2] || 'workloads/agents-mcp-aoai/prompts/output-schema.json';
const dir = process.argv[3] || 'evidence';

function findSummaryJsonFiles(root) {
  const matches = [];
  const stack = [root];

  while (stack.length > 0) {
    const current = stack.pop();
    if (!fs.existsSync(current)) continue;

    for (const entry of fs.readdirSync(current, { withFileTypes: true })) {
      const fullPath = path.join(current, entry.name);
      if (entry.isDirectory()) {
        stack.push(fullPath);
      } else if (entry.isFile() && entry.name.includes('summary') && entry.name.endsWith('.json')) {
        matches.push(fullPath);
      }
    }
  }

  return matches.sort();
}

const schema = JSON.parse(fs.readFileSync(schemaPath, 'utf-8'));
const ajv = new Ajv({ allErrors: true, strict: false });
addFormats(ajv);
const validate = ajv.compile(schema);

let failed = 0;
const files = findSummaryJsonFiles(dir);
if (files.length === 0) {
  console.error(`No summary JSON files found under ${dir}`);
  process.exit(2);
}
for (const f of files) {
  const data = JSON.parse(fs.readFileSync(f, 'utf-8'));
  const ok = validate(data);
  if (!ok) {
    failed++;
    console.error(`Schema errors in ${f}:`);
    console.error(ajv.errorsText(validate.errors, { separator: '\n' }));
  } else {
    const d = data.deltas || {};
    const nonneg = (x) => Number.isInteger(x) && x >= 0;
    if (!nonneg(d.add) || !nonneg(d.change) || !nonneg(d.destroy)) {
      failed++;
      console.error(`Invalid deltas in ${f} (must be non-negative integers)`);
    }
  }
}
if (failed) {
  console.error(`Validation failed in ${failed} file(s)`);
  process.exit(1);
} else {
  console.log(`Validation OK for ${files.length} file(s)`);
}

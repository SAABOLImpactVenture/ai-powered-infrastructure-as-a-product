# Consuming the private Policy Status Card (@your-org scope)

Add to your Backstage app:
```json
// package.json
"dependencies": {
  "@your-org/policy-status-card": "1.x"
}
```

Tell npm where to find it (GitHub Packages):
```
# .npmrc
@your-org:registry=https://npm.pkg.github.com
//npm.pkg.github.com/:_authToken=<YOUR_GH_PAT_OR_GITHUB_TOKEN>
```

Use the component:
```tsx
import { PolicyStatusCard } from '@your-org/policy-status-card';
<PolicyStatusCard endpoint="/api/policy/aggregate" title="Policy Status" />
```

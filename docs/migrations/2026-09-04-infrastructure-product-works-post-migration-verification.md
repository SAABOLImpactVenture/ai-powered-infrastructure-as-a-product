# Infrastructure Product Works post-migration verification

**Recorded:** 2026-09-04  
**Status:** Organization and repository migration verified; parent enterprise layer deferred  
**Asserted author and repository custodian:** Larry Cureton (`GEP-V`)

This record is the additive companion to the
[pre-migration evidence checkpoint](2026-09-04-infrastructure-product-works.md).
It does not replace that checkpoint or rewrite historical evidence.

This record preserves an authorship and custody assertion only. It does not
make or resolve any legal conclusion about inventorship, ownership,
patentability, or trademark clearance.

## Verification result

The GitHub organization and repository migration is verified at the
repository layer:

- the organization handle and display name are `InfrastructureProductWorks`
  and Infrastructure Product Works;
- all twelve retained repositories resolve under the new organization with
  the same GitHub repository IDs recorded before migration;
- every active portfolio `main` branch reports protection enabled;
- the archived adopter-validation repository remains an intentionally frozen
  evidence repository and is not treated as an active protected branch;
- six namespace-sensitive workflow migrations completed through protected
  pull requests and passed their exact-main checks;
- the current assurance product name is IaaP Assurance, while historical
  Vanguard identifiers remain unchanged where required for compatibility and
  evidence integrity; and
- the IaaP Guard GitHub App, organization public profile, and repository
  homepage resolve under the current organization namespace.

The parent enterprise layer is intentionally outside this result and remains
deferred to a separate audit-and-rename decision.

## Repository continuity

| Repository | Repository ID | Verified `main` | Protected |
|---|---:|---|---|
| `ai-powered-infrastructure-as-a-product` | 1071094103 | `7716bf32fdb4bb17a029c574fb4dba53aea2daec` | yes |
| `iaap-guard-adopter-validation` (archived evidence) | 1335448475 | `533b802b3b7afc24a0bfdd4f7480f0c7691ded6f` | archived, not active |
| `crossplane-multicloud-seed-poc` | 1325855160 | `f8453e0850a14774574bfd9f2f9a364472b6606a` | yes |
| `multicloud-foundation-product-poc` | 1325858364 | `b98e1cd75ca61a9b1ea30fa1ab9a4f6cc08dcbdc` | yes |
| `composite-ai-infrastructure-product-poc` | 1325912761 | `ca801af4a83d1daa2ed578d602ab0a6cd43cabfb` | yes |
| `multicloud-foundation-poc-integration` | 1325941868 | `3228ea826b84a9065ffc15806576618c7d6cc04c` | yes |
| `backstage-infrastructure-product-storefront-poc` | 1326530811 | `4a0326324a42b749ed9729ea5d0723736d150e0a` | yes |
| `iaap-guard` | 1327901784 | `aaf134c759318d081ebf0741d7d1753b4de62c22` | yes |
| `iaap-forge` | 1335488842 | `f760a49ae838f69fac2207aeee4ff58bed05567f` | yes |
| `iaap-guard-core` | 1338845269 | `f7ae64df476b696488f22f734c93acaef47c7ed1` | yes |
| `iaap-console` | 1341726140 | `3f51d38563a988f9b3923be3c326a5dcdb9c60e4` | yes |
| `iaap-assurance` | 1351256788 | `38dd536a46e6dceb249b506910bfe8c0f5f54f56` | yes |

Repository IDs, rather than mutable organization or repository names, are the
continuity anchors for this verification. The hub row records the exact
protected-main base on which this additive verification record was prepared;
the protected merge commit remains visible in repository history.

## Workflow migration evidence

| Repository | Protected PR | Accepted `main` | Exact-main evidence |
|---|---|---|---|
| Seed POC | [#5](https://github.com/InfrastructureProductWorks/crossplane-multicloud-seed-poc/pull/5) | `f8453e0850a14774574bfd9f2f9a364472b6606a` | [`validate` passed](https://github.com/InfrastructureProductWorks/crossplane-multicloud-seed-poc/actions/runs/33898058333/job/101105319057) |
| Foundation Product POC | [#11](https://github.com/InfrastructureProductWorks/multicloud-foundation-product-poc/pull/11) | `b98e1cd75ca61a9b1ea30fa1ab9a4f6cc08dcbdc` | [`validate` passed](https://github.com/InfrastructureProductWorks/multicloud-foundation-product-poc/actions/runs/33899585820/job/101110247203) |
| Composite AI POC | [#5](https://github.com/InfrastructureProductWorks/composite-ai-infrastructure-product-poc/pull/5) | `ca801af4a83d1daa2ed578d602ab0a6cd43cabfb` | [`validate` passed](https://github.com/InfrastructureProductWorks/composite-ai-infrastructure-product-poc/actions/runs/33898095313/job/101105441130) |
| Integration | [#32](https://github.com/InfrastructureProductWorks/multicloud-foundation-poc-integration/pull/32) | `3228ea826b84a9065ffc15806576618c7d6cc04c` | [`validate`](https://github.com/InfrastructureProductWorks/multicloud-foundation-poc-integration/actions/runs/33898540686/job/101106882628), [`synthetic-proof`](https://github.com/InfrastructureProductWorks/multicloud-foundation-poc-integration/actions/runs/33898540727/job/101106882643), and [`synthetic-journey`](https://github.com/InfrastructureProductWorks/multicloud-foundation-poc-integration/actions/runs/33898540729/job/101106882328) passed |
| Storefront POC | [#13](https://github.com/InfrastructureProductWorks/backstage-infrastructure-product-storefront-poc/pull/13) | `4a0326324a42b749ed9729ea5d0723736d150e0a` | [`validate`](https://github.com/InfrastructureProductWorks/backstage-infrastructure-product-storefront-poc/actions/runs/33898083159/job/101105399372), [`iaap-guard`](https://github.com/InfrastructureProductWorks/backstage-infrastructure-product-storefront-poc/actions/runs/33898083199/job/101105399831), and [`runtime-smoke`](https://github.com/InfrastructureProductWorks/backstage-infrastructure-product-storefront-poc/actions/runs/33898083088/job/101105399259) passed |
| IaaP Guard | [#62](https://github.com/InfrastructureProductWorks/iaap-guard/pull/62) | `aaf134c759318d081ebf0741d7d1753b4de62c22` | [`dogfood-action`](https://github.com/InfrastructureProductWorks/iaap-guard/actions/runs/33899594012/job/101110321499), [`validate-core`](https://github.com/InfrastructureProductWorks/iaap-guard/actions/runs/33899594012/job/101110271978), [`build-and-validate`](https://github.com/InfrastructureProductWorks/iaap-guard/actions/runs/33899594206/job/101110272692), and [`Analyze (actions)`](https://github.com/InfrastructureProductWorks/iaap-guard/actions/runs/33899594172/job/101110279394) passed |

The five consuming workflows use the current organization namespace and retain
the accepted IaaP Guard action revision
`66f5cf9bf466e7653ae7c8b07a6af5382c64d503`. The retired organization name
remains in IaaP Guard only as an explicit leak-detection compatibility case.

## IaaP Assurance naming verification

[IaaP Assurance PR #17](https://github.com/InfrastructureProductWorks/iaap-assurance/pull/17)
merged to protected `main` at
`38dd536a46e6dceb249b506910bfe8c0f5f54f56` after a clean exact-head review.
Its exact-main [`validate`](https://github.com/InfrastructureProductWorks/iaap-assurance/actions/runs/33901469570/job/101116304723)
and [`Analyze (python)`](https://github.com/InfrastructureProductWorks/iaap-assurance/actions/runs/33901469006/job/101116308836)
checks passed.

Current user-facing names are:

- IaaP Assurance;
- IaaP Assurance Sentry;
- IaaP Assurance Shield; and
- IaaP Assurance Portal.

Historical contracts, paths, package identifiers, fixtures, evidence, releases,
and manifests that contain Vanguard terminology remain unchanged. The
repository's short description now uses IaaP Assurance. No versioned contract
or evidence identity was silently renamed.

## Governance verification

The three formerly unprotected active POC repositories now have active
`Protect main` rulesets:

| Repository | Ruleset | Verified controls |
|---|---|---|
| `crossplane-multicloud-seed-poc` | [22202324](https://github.com/InfrastructureProductWorks/crossplane-multicloud-seed-poc/rules/22202324) | default branch only; pull request; resolved conversations; strict `validate`; deletion and force-push protection; empty bypass list |
| `multicloud-foundation-product-poc` | [22202430](https://github.com/InfrastructureProductWorks/multicloud-foundation-product-poc/rules/22202430) | default branch only; pull request; resolved conversations; strict `validate`; deletion and force-push protection; empty bypass list |
| `composite-ai-infrastructure-product-poc` | [22202547](https://github.com/InfrastructureProductWorks/composite-ai-infrastructure-product-poc/rules/22202547) | default branch only; pull request; resolved conversations; strict `validate`; deletion and force-push protection; empty bypass list |

No bypass actor, collaborator, or repository visibility change was introduced.

## App and publishing verification

- The organization display name is Infrastructure Product Works.
- The organization homepage is
  `https://github.com/InfrastructureProductWorks/ai-powered-infrastructure-as-a-product`.
- The [IaaP Guard GitHub App](https://github.com/apps/iaap-guard) retains its
  name and public identifier.
- Its homepage is `https://github.com/InfrastructureProductWorks/iaap-guard`.
- Its installation remains limited to selected repositories rather than all
  repositories: the public hub, Foundation Product POC, and Storefront POC.
- No App permission, webhook, credential, installation owner, or selected
  repository was added during the namespace migration.

## Provenance and historical evidence

The trusted-main Portfolio Provenance Gate remained operational after the
namespace change. At hub `main`
`7716bf32fdb4bb17a029c574fb4dba53aea2daec`, the
[`boundary`, `docs`, and `attest-provenance` jobs](https://github.com/InfrastructureProductWorks/ai-powered-infrastructure-as-a-product/actions/runs/33895723667)
passed, along with the Pages build and security-policy evaluation.

The version-1 provenance statement intentionally retains the namespace and
product vocabulary it attested before migration. This post-migration record
adds continuity evidence; it does not mutate that signed historical claim.
Any future canonical-origin statement for the new namespace must use a new,
reviewed provenance version rather than rewriting version 1.

Existing commits, tags, releases, attestations, manifests, archived evidence,
and disclosure records remain historical facts. Git object IDs and repository
IDs provide continuity across the rename.

## Deferred enterprise layer

The organization continues to appear as part of the existing parent
enterprise. The enterprise display name and slug were not changed. That layer
has different redirect, API, identity-provider, and administrative consequences
and remains subject to a separate audit-and-rename decision. An account-level
administrative prerequisite remains outside this public record.

Deferring the enterprise layer does not reopen or block the verified
organization and repository migration.

## Authority and ownership boundary

This migration added no credentials, token scopes, collaborators, bypass
actors, repository visibility, cloud access, live data, spending authority,
pilot authority, or production authority.

`InfrastructureProductWorks` is an administrative and publishing namespace,
not an asserted legal entity or separate IP owner. Nothing in this record
assigns or transfers copyright, patent rights, trademarks, goodwill, source
repositories, or other assets. The authorship and custody assertion preserved
in the pre-migration checkpoint remains unchanged.

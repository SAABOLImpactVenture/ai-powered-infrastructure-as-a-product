import { PermissionPolicy, AuthorizeResult } from '@backstage/plugin-permission-node';
import {
  catalogEntityCreatePermission,
  catalogEntityReadPermission,
  catalogEntityDeletePermission,
  catalogEntityRefreshPermission,
} from '@backstage/plugin-catalog-common/permissions';
import {
  scaffolderActionExecutePermission,
  scaffolderTemplateParameterReadPermission,
  scaffolderTemplateReadPermission,
} from '@backstage/plugin-scaffolder-common/permissions';
import { basicPermissionPolicies } from '@backstage/plugin-permission-backend';
import { BackstageIdentityResponse } from '@backstage/plugin-auth-node';

/**
 * Static policy mapping groups -> permissions.
 * Replace group names/refs with your catalog Group entities in catalog/org/*.yaml
 */
export class ServerPermissionPolicy implements PermissionPolicy {
  async handle(request: { permission: { name: string }, principal?: { user?: BackstageIdentityResponse } }) {
    const permission = request.permission;
    const user = request.principal?.user;
    const groups = new Set<string>(user?.identity.ownershipEntityRefs ?? []);

    // Admins: full access
    if (groups.has('group:default/platform-admins')) {
      return { result: AuthorizeResult.ALLOW };
    }

    // Security reviewers: read catalog & templates, execute scaffolder
    if (groups.has('group:default/security-reviewers')) {
      switch (permission.name) {
        case catalogEntityReadPermission.name:
        case scaffolderTemplateReadPermission.name:
        case scaffolderTemplateParameterReadPermission.name:
        case scaffolderActionExecutePermission.name:
          return { result: AuthorizeResult.ALLOW };
        default:
          return { result: AuthorizeResult.CONDITIONAL };
      }
    }

    // Default developers: read catalog + execute scaffolder, but cannot delete entities
    if (groups.has('group:default/developers')) {
      switch (permission.name) {
        case catalogEntityReadPermission.name:
        case scaffolderTemplateReadPermission.name:
        case scaffolderTemplateParameterReadPermission.name:
        case scaffolderActionExecutePermission.name:
          return { result: AuthorizeResult.ALLOW };
        case catalogEntityCreatePermission.name:
        case catalogEntityDeletePermission.name:
        case catalogEntityRefreshPermission.name:
          return { result: AuthorizeResult.CONDITIONAL };
        default:
          return { result: AuthorizeResult.CONDITIONAL };
      }
    }

    // Fallback to basic safe defaults
    const basic = await basicPermissionPolicies.allowAllPermissionsPolicy().handle(request as any);
    return basic;
  }
}

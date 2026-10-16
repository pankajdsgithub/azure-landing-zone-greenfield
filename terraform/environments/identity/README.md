# Phase 3 - Identity and RBAC foundation

This root manages explicitly supplied Azure RBAC role assignments.
It does not create users, groups, service principals, or management groups.

- Assignments default to an empty map.
- Only a small allowlist of least-privilege roles is accepted.
- Scope and principal object IDs must be reviewed before planning.
- Management-group scope strings must use the correct Azure resource ID.

Before deployment, confirm the signed-in identity has permission to create
role assignments at the target scope. Do not grant Owner or User Access
Administrator broadly as a workaround.

Policy definitions and initiatives remain in the existing governance root.
Review that root before adding duplicate assignments here.

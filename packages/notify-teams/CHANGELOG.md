# @sagui-actions/notify-teams

## 1.2.1

### Patch Changes

- 71c8da7: Improve Teams notification: send only on actual release, remove duplicate status, add delivery date and author profile link

## 1.2.0

### Minor Changes

- 6423cdb: feat: publish semantic refs for root action usage

  Release flow now syncs package subtree refs to support clean usage:

  - sagui-oficial/actions@notify-teams/v1
  - sagui-oficial/actions@notify-teams/v1.1.0

  This keeps major refs updated to latest patch and preserves exact version pinning.

## 1.1.0

### Minor Changes

- 2f53ff0: feat: add notify-teams composite action

  Sends workflow notifications to Microsoft Teams via incoming webhook.
  Includes repository name, workflow name, branch, status, and optional build version.

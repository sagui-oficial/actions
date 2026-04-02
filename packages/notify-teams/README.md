# notify-teams

GitHub Composite Action that sends workflow notifications to Microsoft Teams via incoming webhook.

## Inputs

| Input           | Required | Description                                    |
| --------------- | -------- | ---------------------------------------------- |
| `github-token`  | Yes      | GitHub token for authentication                |
| `webhook-uri`   | Yes      | Microsoft Teams incoming webhook URI           |
| `build-version` | No       | Build version to include in the notification   |

## Usage

```yaml
- name: Notify Teams
  if: always()
  uses: sagui-oficial/actions/packages/notify-teams@v1
  with:
    github-token: ${{ secrets.GITHUB_TOKEN }}
    webhook-uri: ${{ secrets.TEAMS_WEBHOOK_URI }}
    build-version: "1.2.3"
```

## Notification Contents

The Teams message card includes:

- **Repository** name
- **Workflow** name
- **Branch** that triggered the workflow
- **Triggered by** (actor)
- **Status** (Success / Failure / Cancelled) with color-coded theme
- **Build Version** (when provided)
- **View Run** button linking to the workflow run

## Status Indicators

| Status    | Emoji | Color  |
| --------- | ----- | ------ |
| Success   | ✅    | Green  |
| Failure   | ❌    | Red    |
| Cancelled | ⚠️    | Orange |

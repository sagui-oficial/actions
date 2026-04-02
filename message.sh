#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${WEBHOOK_URI}" ]]; then
  echo "::error::webhook-uri is required"
  exit 1
fi

STATUS_EMOJI="✅"
STATUS_TEXT="Success"
THEME_COLOR="00FF00"

if [[ "${RUN_STATUS}" == "failure" ]]; then
  STATUS_EMOJI="❌"
  STATUS_TEXT="Failure"
  THEME_COLOR="FF0000"
elif [[ "${RUN_STATUS}" == "cancelled" ]]; then
  STATUS_EMOJI="⚠️"
  STATUS_TEXT="Cancelled"
  THEME_COLOR="FFA500"
fi

VERSION_SECTION=""
if [[ -n "${BUILD_VERSION}" ]]; then
  VERSION_SECTION=$(cat <<EOF
,{
  "name": "Build Version",
  "value": "${BUILD_VERSION}"
}
EOF
)
fi

PAYLOAD=$(cat <<EOF
{
  "@type": "MessageCard",
  "@context": "http://schema.org/extensions",
  "themeColor": "${THEME_COLOR}",
  "summary": "${STATUS_EMOJI} ${REPO_NAME} - ${STATUS_TEXT}",
  "sections": [
    {
      "activityTitle": "${STATUS_EMOJI} GitHub Actions - ${STATUS_TEXT}",
      "facts": [
        {
          "name": "Repository",
          "value": "${REPO_NAME}"
        },
        {
          "name": "Workflow",
          "value": "${WORKFLOW_NAME}"
        },
        {
          "name": "Branch",
          "value": "${REF}"
        },
        {
          "name": "Triggered by",
          "value": "${ACTOR}"
        },
        {
          "name": "Status",
          "value": "${STATUS_TEXT}"
        }${VERSION_SECTION}
      ],
      "markdown": true
    }
  ],
  "potentialAction": [
    {
      "@type": "OpenUri",
      "name": "View Run",
      "targets": [
        {
          "os": "default",
          "uri": "${RUN_URL}"
        }
      ]
    }
  ]
}
EOF
)

HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
  -H "Content-Type: application/json" \
  -d "${PAYLOAD}" \
  "${WEBHOOK_URI}")

if [[ "${HTTP_STATUS}" -lt 200 || "${HTTP_STATUS}" -ge 300 ]]; then
  echo "::error::Teams notification failed with HTTP status ${HTTP_STATUS}"
  exit 1
fi

echo "::notice::Teams notification sent successfully (HTTP ${HTTP_STATUS})"

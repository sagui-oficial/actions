#!/usr/bin/env bash
set -euo pipefail

DRY_RUN="${DRY_RUN:-0}"

run_cmd() {
  if [[ "$DRY_RUN" == "1" ]]; then
    echo "[dry-run] $*"
  else
    eval "$*"
  fi
}

PUBLISHED=""

echo "Syncing semantic refs for actions..."

git fetch origin --tags

for pkg_dir in packages/*/; do
  pkg_name=$(basename "$pkg_dir")

  if [[ ! -f "${pkg_dir}action.yml" || ! -f "${pkg_dir}package.json" ]]; then
    echo "Skipping ${pkg_name}: missing action.yml or package.json"
    continue
  fi

  version=$(node -p "require('./${pkg_dir}package.json').version")
  major=$(echo "$version" | cut -d. -f1)

  major_ref="${pkg_name}/v${major}"
  exact_ref="${pkg_name}/v${version}"

  # Skip packages whose exact version tag already exists on remote
  if git ls-remote --tags origin "refs/tags/${exact_ref}" | grep -q "${exact_ref}"; then
    echo "Skipping ${pkg_name}@${version}: tag ${exact_ref} already exists"
    continue
  fi

  split_commit=$(git subtree split --prefix "$pkg_dir" HEAD)

  echo "Publishing ${pkg_name}@${version}"
  echo " - split commit: ${split_commit}"
  echo " - major ref: ${major_ref}"
  echo " - exact ref: ${exact_ref}"

  run_cmd "git push origin ${split_commit}:refs/heads/${major_ref} --force"

  run_cmd "git tag -f ${major_ref} ${split_commit}"
  run_cmd "git push origin refs/tags/${major_ref} --force"

  run_cmd "git tag -f ${exact_ref} ${split_commit}"
  run_cmd "git push origin refs/tags/${exact_ref} --force"

  if [[ -n "$PUBLISHED" ]]; then
    PUBLISHED="${PUBLISHED}, ${pkg_name}@v${version}"
  else
    PUBLISHED="${pkg_name}@v${version}"
  fi
done

if [[ -z "$PUBLISHED" ]]; then
  PUBLISHED="no new packages"
  echo "No packages had version changes to publish."
fi

# Export for downstream steps
if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
  echo "published=${PUBLISHED}" >> "$GITHUB_OUTPUT"
fi

echo "Semantic refs sync completed: ${PUBLISHED}"

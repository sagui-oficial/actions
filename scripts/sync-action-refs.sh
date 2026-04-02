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
done

echo "Semantic refs sync completed."

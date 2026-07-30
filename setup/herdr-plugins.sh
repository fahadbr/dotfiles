#!/bin/bash

set -e

# Reinstalls herdr plugins recorded in common-home/.config/herdr/plugins.json.
# Run from the repo root, after stow has linked plugins.json into place
# (or with it still sitting in the repo, since we read it by path either way).
manifest=common-home/.config/herdr/plugins.json

jq -c '.[]' "${manifest}" | while read -r plugin; do
    id=$(echo "${plugin}" | jq -r '.plugin_id')
    owner=$(echo "${plugin}" | jq -r '.source.owner')
    repo=$(echo "${plugin}" | jq -r '.source.repo')
    ref=$(echo "${plugin}" | jq -r '.source.requested_ref')
    enabled=$(echo "${plugin}" | jq -r '.enabled')

    echo "installing ${owner}/${repo}@${ref}"
    herdr plugin install "${owner}/${repo}" --ref "${ref}" -y

    if [[ "${enabled}" == "false" ]]; then
        herdr plugin disable "${id}"
    fi
done

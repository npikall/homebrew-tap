#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# tool → type (go|python)
declare -A TOOL_TYPE=(
  [gotpm]=go
  [tiss-cli]=python
  [go-typstwatch]=go
)

# go tool → upstream github repo (owner/repo)
declare -A GO_REPO=(
  [gotpm]=npikall/gotpm
  [go-typstwatch]=npikall/go-typstwatch
)

# python tool → pypi package name
declare -A PYPI_NAME=(
  [tiss-cli]=tiss-cli
)

update_go_formula() {
  local tool="$1"
  local repo="${GO_REPO[$tool]}"
  local formula="${REPO_ROOT}/Formula/${tool}.rb"

  local tag
  tag=$(gh api "repos/${repo}/releases/latest" --jq '.tag_name' 2>/dev/null || true)

  if [[ -z "$tag" ]]; then
    echo "SKIP ${tool}: no releases found"
    return
  fi

  local url="https://github.com/${repo}/archive/refs/tags/${tag}.tar.gz"
  echo "Fetching ${tool} ${tag} tarball..."
  local sha256
  sha256=$(curl -sL "$url" | sha256sum | awk '{print $1}')

  # update url line
  sed -i "s|url \"https://github.com/${repo}/archive/.*\"|url \"${url}\"|" "$formula"
  # update sha256 on the line immediately after url
  sed -i "/url \"https:\/\/github.com\/${repo//\//\\/}\//{ n; s/sha256 \"[a-f0-9]*\"/sha256 \"${sha256}\"/; }" "$formula"

  echo "OK ${tool} → ${tag} (${sha256:0:12}...)"
}

update_python_formula() {
  local tool="$1"
  local pypi="${PYPI_NAME[$tool]}"
  local formula="${REPO_ROOT}/Formula/${tool}.rb"

  local pypi_data
  pypi_data=$(curl -s "https://pypi.org/pypi/${pypi}/json")

  local version url sha256
  version=$(echo "$pypi_data" | jq -r '.info.version')
  url=$(echo "$pypi_data" | jq -r '[.urls[] | select(.packagetype=="sdist")] | first | .url')
  sha256=$(echo "$pypi_data" | jq -r '[.urls[] | select(.packagetype=="sdist")] | first | .digests.sha256')

  # update main package url (pythonhosted sdist url)
  sed -i "s|url \"https://files.pythonhosted.org/.*${pypi//-/_}.*\"|url \"${url}\"|" "$formula"
  # update sha256 on line immediately after that url
  sed -i "/url \"https:\/\/files.pythonhosted.org\/.*${pypi//-/_}.*\/\"/{ n; s/sha256 \"[a-f0-9]*\"/sha256 \"${sha256}\"/; }" "$formula"

  echo "OK ${tool} → ${version}"
  echo "NOTE: run 'brew update-python-resources Formula/${tool}.rb' to refresh dependency resources"
}

update_tool() {
  local tool="$1"
  local type="${TOOL_TYPE[$tool]:-}"

  if [[ -z "$type" ]]; then
    echo "ERROR: unknown tool '${tool}'" >&2
    exit 1
  fi

  case "$type" in
    go)     update_go_formula "$tool" ;;
    python) update_python_formula "$tool" ;;
  esac
}

main() {
  local target="${1:-}"

  if [[ -n "$target" ]]; then
    update_tool "$target"
  else
    for tool in "${!TOOL_TYPE[@]}"; do
      update_tool "$tool"
    done
  fi
}

main "$@"

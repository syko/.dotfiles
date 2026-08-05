#!/usr/bin/env bash
# Prints the host port of the supersimple-app service from the nearest
# docker-compose file (walking up from $PWD), falling back to supersimple-api.
# Exits non-zero when there is no compose file or no matching service.

set -u

find_compose() {
  local dir="$PWD"
  while [ "$dir" != "/" ]; do
    for name in docker-compose.yml docker-compose.yaml compose.yml compose.yaml; do
      if [ -f "$dir/$name" ]; then
        printf '%s\n' "$dir/$name"
        return 0
      fi
    done
    dir=$(dirname "$dir")
  done
  return 1
}

compose=$(find_compose) || exit 1

port=$(yq -r '
  .services | to_entries
  | map(select((.value.profiles // []) | contains(["disabled"]) | not))
  | (map(select(.key | test("supersimple-app"))) + map(select(.key | test("supersimple-api"))))
  | .[0].value.ports
  | (map(select(tag == "!!str" and test(":3000$"))) + map(select(tag == "!!str")))
  | .[0] | split(":") | .[-2]
' "$compose" 2>/dev/null)

[ -n "$port" ] || exit 1
printf '%s\n' "$port"

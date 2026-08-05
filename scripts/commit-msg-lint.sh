#!/usr/bin/env bash
# Validates a commit message against the Nanimo convention :
#   <type>(<scope>): <description> NAN-<id>
#
# Two modes :
#   - As a git hook         : $1 is a path to the commit message file
#   - From CI / by hand     : $1 is the message string itself
#
# Auto-generated messages (Merge / Revert) are accepted as-is.

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: $0 <commit-msg-file|commit-msg-string>" >&2
  exit 2
fi

if [[ -f "$1" ]]; then
  msg=$(head -n1 "$1")
else
  msg="$1"
fi

# Skip messages that GitHub / git itself generates.
if [[ "$msg" =~ ^Merge\  ]] || [[ "$msg" =~ ^Revert\ \" ]]; then
  exit 0
fi

# Dependabot writes its own messages and cannot append a ticket id, so its
# dependency bumps are exempted the same way merges are. The scope is pinned to
# deps / deps-dev so a handwritten commit cannot borrow the exemption.
if [[ "$msg" =~ ^chore\((deps|deps-dev)\):\  ]]; then
  exit 0
fi

regex='^(feat|fix|docs|style|refactor|test|chore|perf|ci|build|revert)\([a-z0-9-]+\): .+ NAN-[0-9]+$'

if [[ ! "$msg" =~ $regex ]]; then
  cat >&2 <<EOF
❌ Commit message invalide :
   "$msg"

Format attendu :
   <type>(<scope>): <description> NAN-<id>

   • type   : feat | fix | docs | style | refactor | test | chore | perf | ci | build | revert
   • scope  : kebab-case (ex: subscription-config)
   • NAN-id : identifiant du ticket en suffixe

Exemple :
   feat(subscription): add subscription cubit NAN-008
EOF
  exit 1
fi

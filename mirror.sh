#!/usr/bin/env bash

readonly tmpdir=/tmp/foo

clone() {
  local source="$1"

  git clone --bare "$source" .git
  git config --unset core.bare
  git reset --hard
}

mirror() {
  local target="$1"
  git push --mirror "$target"
}

add_file() {
  local uri="$1"
  local name="${2:-file}"
  curl -sRO "$uri"
  git add . && git commit -m "adding $name"
}

push() {
  local target="$1"
  git push "$target"
}

main() {
  local source=${@:1:1}
  local target=${@:2:1}

  mkdir -p "$tmpdir" && cd "$tmpdir"

  echo "mirroring $source to $target"

  clone "$source"
  mirror "$target"

  add_file https://raw.githubusercontent.com/jw3/openshift-kinesalite/master/template.yml 'a file from another repo'
  push "$target"
}

main "$@"


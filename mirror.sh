#!/usr/bin/env bash

readonly tmpdir=/tmp/foo
readonly history=/tmp/.mig

init() {
  local source="$1"

  mkdir -p "$tmpdir" && cd "$tmpdir"
  clone "$source"
  list_branches | tee "$history"
}

list_branches() {
  git branch -v --no-abbrev | sed -e 's/*//g' | awk '{print $1"="$2}'
}

clone() {
  local source="$1"

  git clone --bare "$source" .git
  git config --unset core.bare
  git reset --hard
}

add_file() {
  local uri="$1"
  local name="${2:-file}"
  curl -sRO "$uri"
  git add . && git commit -m "adding $name"
}

push() {
  git push "$@"
}

mirror() {
  local source=${@:1:1}
  local target=${@:2:1}

  mkdir -p "$tmpdir" && cd "$tmpdir"

  echo "mirroring $source to $target"

  clone "$source"
  push --mirror "$target"

  add_file https://raw.githubusercontent.com/jw3/openshift-kinesalite/master/template.yml 'a file from another repo'
  push "$target"
}

"$@"


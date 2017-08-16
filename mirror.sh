#!/usr/bin/env bash

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
  curl -O "$uri"
  git add . && git commit -m "adding $name"
}

push() {
  local target="$1"
  git push "$target"
}

main() {
  cd /tmp && mkdir foo
  clone "$@"
  mirror "$@"

  add_file https://raw.githubusercontent.com/jw3/openshift-kinesalite/master/template.yml 'a file from another repo'

  cd /tmp && rm -rf foo
}

main "$@"

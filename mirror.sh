#!/usr/bin/env bash

readonly t=$(date +%s)
readonly tmp="${MIG_TMP:-/tmp/mig-$t}"
readonly mig="$HOME/.mig"

init() {
  local source="$1"

  mkdir -p "$tmp" && cd "$tmp"
  if [[ -z ${MIG_TMP} ]]; then clone "$source"; fi
  list_branches | awk '{"echo " $1 " | base64 | sed -e s#=#_#g" | getline x; print x "=" $2 " #" $1}' | tee "$mig"
}

list_branches() {
  git branch -v --no-abbrev | sed -e 's/*//g'
}

list_changed_branches() {
  cd "$tmp"
  source "$mig"

  for b in $(list_branches | awk '{print $1"="$2}'); do
    IFS='=' read -ra B <<< "$b"
    compare_branch "${B[@]}"
  done
}

compare_branch() {
  local name="$1"
  local hash="$2"

  local ename=$(echo "$name" | base64 | sed -e 's#=#_#g')

  if [[ -v "$ename" && "$hash" != "${!ename}" ]]; then echo "$ename" | sed -e 's#_#=#g'; fi
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

  mkdir -p "$tmp" && cd "$tmp"

  echo "mirroring $source to $target"

  clone "$source"
  push --mirror "$target"

  for b in $(list_changed_branches); do
    git checkout "$b"
    add_file https://raw.githubusercontent.com/jw3/example-mirrored-cicfg/master/Dockerfile 'dockerfile'
    add_file https://raw.githubusercontent.com/jw3/example-mirrored-cicfg/master/.gitlab-ci.yml 'ci config'
    push "$target"
  done
}

"$@"

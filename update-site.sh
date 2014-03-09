#!/bin/sh
if [ ! "$1" ]; then
  echo 'comment not specified'
  exit 1
fi

bundle exec jekyll build \
  && git add --all --verbose . \
  && git commit -m "$1" --verbose \
  && pushd _site \
  && git add --all --verbose . \
  && git commit -m "$1" --verbose \
  && popd \
  && git push --all --verbose origin
exit 0

jk_build="bundle exec jekyll build"
git_add="git add --all --verbose ."
git_commit="git commit --verbose -m '$1'"
git_push="git push --all --verbose origin"

echo $jk_build
echo $git_commit
$jk_build && $git_add && $git_commit \
  && pushd _site && $git_add && $git_commit \
  && popd \
  && $git_push

exit 0

if $build; then
  git add --all --verbose .
  git commit -m $1
  pushd _site
  git add --all --verbose .
  git commit -m $1
  popd
  git push --all --verbose origin
fi
exit 0


#!/bin/sh
if [ ! "$1" ]; then
  echo 'comment not specified'
  exit 1
fi

bundle exec jekyll build \
  && echo '--------' \
  && git add --all --verbose . \
  && echo '--------' \
  && git commit -m "$1" --verbose \
  && echo '--------' \
  && pushd _site \
  && echo '--------' \
  && git add --all --verbose . \
  && echo '--------' \
  && git commit -m "$1" --verbose \
  && echo '--------' \
  && popd \
  && echo '--------' \
  && git push --all --verbose origin
exit 0


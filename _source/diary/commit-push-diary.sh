#!/bin/sh
if [ ! "$1" ]; then
  echo 'comment not specified'
  exit 1
fi

git add --all --verbose . \
  && echo '--------' \
  && git commit -m "$1" --verbose \
  && echo '--------' \
  && git push --verbose origin master
exit 0


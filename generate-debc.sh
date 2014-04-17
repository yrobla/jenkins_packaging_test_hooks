#!/bin/sh

cat <<EOF
  ┌──────────────────────────────────────────────────────────────────────────────┐
  │  Displaying content of generated Debian packages.                            │
  └──────────────────────────────────────────────────────────────────────────────┘
EOF

if ! which debc >/dev/null 2>&1 ; then
  echo "Error: debc executable not available, please install the devscripts Debian package." >&2
  exit 1
fi

CHANGES=$(find . -maxdepth 1 -name \*.changes ! -name \*_source.changes)

if [ -n "$CHANGES" ] >/dev/null 2>&1 ; then
  for file in $CHANGES ; do
    debc "$file"
  done
elif ls *.deb >/dev/null 2>&1 ; then
  debc *.deb
else
  echo "No changes and deb files found in $(pwd), ignoring."
fi

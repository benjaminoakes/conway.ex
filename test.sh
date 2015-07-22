#/usr/bin/env bash
set -o errexit
set -x

bin/conway --test

bin/conway
bin/conway --help
bin/conway 15 15 10

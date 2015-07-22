#/usr/bin/env bash
set -o errexit
set -x

elixir lib/conway.ex --test

elixir lib/conway.ex
elixir lib/conway.ex --help
elixir lib/conway.ex 15 15 10

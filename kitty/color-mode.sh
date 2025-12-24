#!/bin/sh
if [ "${COLOR_MODE:-dark}" = "light" ]; then
  echo "include light.conf"
else
  echo "include dark.conf"
fi

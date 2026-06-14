#!/bin/bash

echo "lanzando..."

CONF_DIR="$(dirname "$0")"

conky -c $CONF_DIR/wayland.conkyrc 



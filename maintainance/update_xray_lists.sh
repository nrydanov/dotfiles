#!/bin/sh

GEOSITE_URL="https://raw.githubusercontent.com/runetfreedom/russia-v2ray-rules-dat/release/geosite.dat"
GEOIP_URL="https://raw.githubusercontent.com/runetfreedom/russia-v2ray-rules-dat/release/geoip.dat"

GEOSITE_CLIENT_PATH="/Applications/V2RayXS.app/Contents/Resources/geosite.dat"
GEOIP_CLIENT_PATH="/Applications/V2RayXS.app/Contents/Resources/geoip.dat"

SYMLINK_DIR="$HOME/.geodata"

mkdir -p "$SYMLINK_DIR"

ln -sf "$GEOSITE_CLIENT_PATH" "$SYMLINK_DIR/geosite.dat"
ln -sf "$GEOIP_CLIENT_PATH" "$SYMLINK_DIR/geoip.dat"

curl -fsSL -o "$SYMLINK_DIR/geosite.dat" "$GEOSITE_URL"
curl -fsSL -o "$SYMLINK_DIR/geoip.dat" "$GEOIP_URL"

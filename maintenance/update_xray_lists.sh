#!/bin/sh
set -u

GEOSITE_URL="https://raw.githubusercontent.com/runetfreedom/russia-v2ray-rules-dat/release/geosite.dat"
GEOIP_URL="https://raw.githubusercontent.com/runetfreedom/russia-v2ray-rules-dat/release/geoip.dat"

GEOSITE_CLIENT_PATH="/Applications/V2RayXS.app/Contents/Resources/geosite.dat"
GEOIP_CLIENT_PATH="/Applications/V2RayXS.app/Contents/Resources/geoip.dat"

SYMLINK_DIR="$HOME/.geodata"

mkdir -p "$SYMLINK_DIR"

ln -sf "$GEOSITE_CLIENT_PATH" "$SYMLINK_DIR/geosite.dat"
ln -sf "$GEOIP_CLIENT_PATH" "$SYMLINK_DIR/geoip.dat"

# Download to a tmp file next to the real target and atomically rename into
# place, so a dropped connection mid-download never leaves V2RayXS with a
# truncated/empty geosite.dat or geoip.dat.
fetch() {
    url="$1"
    dest="$2"
    tmp="$dest.tmp.$$"

    if ! curl -fsSL --retry 3 --retry-delay 2 -o "$tmp" "$url"; then
        echo "update_xray_lists: failed to download $url, keeping existing $dest" >&2
        rm -f "$tmp"
        return 1
    fi

    if [ ! -s "$tmp" ]; then
        echo "update_xray_lists: downloaded $url but got an empty file, keeping existing $dest" >&2
        rm -f "$tmp"
        return 1
    fi

    mv "$tmp" "$dest"
}

fetch "$GEOSITE_URL" "$GEOSITE_CLIENT_PATH" || true
fetch "$GEOIP_URL" "$GEOIP_CLIENT_PATH" || true

#!/usr/bin/env python3
"""Turn a base64 V2Ray/Xray subscription body (stdin) into an xray config.json
(stdout). Only the first vless://, vmess://, or trojan:// entry is used —
rerun setup/xray.sh after editing PROXY_SUBSCRIPTION_LINK to switch servers.
"""
import base64
import json
import sys
from urllib.parse import urlparse, parse_qs, unquote

SOCKS_PORT = 1080
HTTP_PORT = 1081


def pad(s):
    return s + "=" * (-len(s) % 4)


def stream_settings(net, security, params, host_fallback):
    settings = {"network": net or "tcp"}

    if net == "ws":
        settings["wsSettings"] = {
            "path": unquote(params.get("path", [""])[0]) or "/",
            "headers": {"Host": params.get("host", [host_fallback])[0]},
        }
    elif net == "grpc":
        settings["grpcSettings"] = {
            "serviceName": unquote(params.get("serviceName", [""])[0]),
        }
    elif net == "h2":
        settings["httpSettings"] = {
            "path": unquote(params.get("path", ["/"])[0]),
            "host": [params.get("host", [host_fallback])[0]],
        }

    if security == "tls":
        settings["security"] = "tls"
        settings["tlsSettings"] = {
            "serverName": params.get("sni", params.get("host", [host_fallback]))[0],
            "allowInsecure": False,
        }
    elif security == "reality":
        settings["security"] = "reality"
        settings["realitySettings"] = {
            "serverName": params.get("sni", [host_fallback])[0],
            "fingerprint": params.get("fp", ["chrome"])[0],
            "publicKey": params.get("pbk", [""])[0],
            "shortId": params.get("sid", [""])[0],
            "spiderX": unquote(params.get("spx", [""])[0]),
        }

    return settings


def parse_vless(uri):
    u = urlparse(uri)
    params = parse_qs(u.query)
    net = params.get("type", ["tcp"])[0]
    security = params.get("security", ["none"])[0]
    outbound = {
        "protocol": "vless",
        "settings": {
            "vnext": [{
                "address": u.hostname,
                "port": u.port,
                "users": [{
                    "id": u.username,
                    "encryption": params.get("encryption", ["none"])[0],
                    "flow": params.get("flow", [""])[0],
                }],
            }],
        },
        "streamSettings": stream_settings(net, security, params, u.hostname),
    }
    return outbound


def parse_trojan(uri):
    u = urlparse(uri)
    params = parse_qs(u.query)
    net = params.get("type", ["tcp"])[0]
    security = params.get("security", ["tls"])[0]
    outbound = {
        "protocol": "trojan",
        "settings": {
            "servers": [{
                "address": u.hostname,
                "port": u.port,
                "password": u.username,
            }],
        },
        "streamSettings": stream_settings(net, security, params, u.hostname),
    }
    return outbound


def parse_vmess(uri):
    data = json.loads(base64.b64decode(pad(uri[len("vmess://"):])))
    net = data.get("net", "tcp")
    security = "tls" if data.get("tls") == "tls" else "none"
    params = {
        "path": [data.get("path", "")],
        "host": [data.get("host") or data["add"]],
        "sni": [data.get("sni") or data.get("host") or data["add"]],
        "serviceName": [data.get("path", "")],
    }
    outbound = {
        "protocol": "vmess",
        "settings": {
            "vnext": [{
                "address": data["add"],
                "port": int(data["port"]),
                "users": [{
                    "id": data["id"],
                    "alterId": int(data.get("aid", 0)),
                }],
            }],
        },
        "streamSettings": stream_settings(net, security, params, data["add"]),
    }
    return outbound


def parse_first_outbound(lines):
    for line in lines:
        line = line.strip()
        if line.startswith("vless://"):
            return parse_vless(line)
        if line.startswith("trojan://"):
            return parse_trojan(line)
        if line.startswith("vmess://"):
            return parse_vmess(line)
    raise SystemExit("no vless://, vmess://, or trojan:// entries found in subscription")


def main():
    body = sys.stdin.read().strip()
    decoded = base64.b64decode(pad(body)).decode()
    proxy_outbound = parse_first_outbound(decoded.splitlines())
    proxy_outbound["tag"] = "proxy"

    config = {
        "log": {"loglevel": "warning"},
        "inbounds": [
            {
                "tag": "socks-in",
                "listen": "127.0.0.1",
                "port": SOCKS_PORT,
                "protocol": "socks",
                "settings": {"auth": "noauth", "udp": True},
            },
            {
                "tag": "http-in",
                "listen": "127.0.0.1",
                "port": HTTP_PORT,
                "protocol": "http",
            },
        ],
        "outbounds": [
            proxy_outbound,
            {"tag": "direct", "protocol": "freedom"},
        ],
    }
    json.dump(config, sys.stdout, indent=2)


if __name__ == "__main__":
    main()

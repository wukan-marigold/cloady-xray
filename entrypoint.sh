#!/bin/sh
set -eu
PORT="${PORT:-3000}"
WS_PATH="${WS_PATH:-/vless}"
: "${VLESS_UUID:?VLESS_UUID env var is required}"
mkdir -p /etc/xray
cat > /etc/xray/config.json <<EOF
{
  "log": { "loglevel": "warning" },
  "inbounds": [
    {
      "port": ${PORT},
      "listen": "0.0.0.0",
      "protocol": "vless",
      "settings": {
        "clients": [{ "id": "${VLESS_UUID}", "flow": "" }],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": { "path": "${WS_PATH}" }
      }
    }
  ],
  "outbounds": [{ "protocol": "freedom", "tag": "direct" }]
}
EOF
exec /usr/local/bin/xray run -config /etc/xray/config.json

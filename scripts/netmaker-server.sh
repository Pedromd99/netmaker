#!/bin/sh
set -e

mkdir -p /etc/netmaker
wget -O /etc/netmaker/netmaker https://github.com/gravitl/netmaker/releases/download/v0.15.0/netmaker
chmod +x /etc/netmaker/netmaker
cp /etc/netmaker/netmaker /usr/sbin/netmaker

cat >/etc/netmaker/netmaker.yaml<<EOL
server:
  server: ""
  apiport: "8081"
  apiconnection: ""
  masterkey: "82eMwuSP9k58AC"
  mqhost: "127.0.0.1"
  mqport: "8883"
  sqlconn: "http://localhost:4001"
EOL

cat >/etc/systemd/system/netmaker.service<<EOL
[Unit]
Description=Netmaker Server
After=network.target

[Service]
Type=simple
Restart=on-failure

ExecStart=/usr/sbin/netmaker -c /etc/netmaker/netmaker.yaml

[Install]
WantedBy=multi-user.target
EOL
systemctl daemon-reload
systemctl start netmaker.service

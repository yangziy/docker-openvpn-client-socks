#!/bin/bash
set -e
[ -f /etc/openvpn/up.sh ] && /etc/openvpn/up.sh "$@"
/usr/sbin/sockd -D

cat /etc/resolv.conf.todo > /etc/resolv.conf
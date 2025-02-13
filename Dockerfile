# OpenVPN client + SOCKS proxy
# Usage:
# Create configuration (.ovpn), mount it in a volume
# docker run --volume=something.ovpn:/ovpn.conf:ro --device=/dev/net/tun --cap-add=NET_ADMIN
# Connect to (container):1080
# Note that the config must have embedded certs
# See `start` in same repo for more ideas

FROM alpine

COPY sockd.sh /usr/local/bin/

RUN true \
    && apk add --update-cache dante-server openvpn bash openresolv openrc \
    && rm -rf /var/cache/apk/* \
    && chmod a+x /usr/local/bin/sockd.sh \
    && true

COPY sockd.conf /etc/

ENTRYPOINT [ \
    "/bin/bash", "-c", \
    "echo \"nameserver ${DNS_SERVER}\" > /etc/resolv.conf.todo && \
    cd /etc/openvpn && /usr/sbin/openvpn --config ${OVPN_FILE}  --script-security 2 --up /usr/local/bin/sockd.sh" \
    ]

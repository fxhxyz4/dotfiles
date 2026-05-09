#!/bin/bash

sudo wg-quick down /tmp/wg0-temp.conf                                                                                                                                                                                                                          ─╯
sudo rm /tmp/wg0-temp.conf

WG_CONF="$HOME/arch-wireguard-CA-FREE-1.conf"

if [ ! -f "$WG_CONF" ]; then
    echo "WireGuard config не найден: $WG_CONF"
    exit 1
fi

TMP_CONF="/tmp/wg0-temp.conf"
grep -v "^DNS" "$WG_CONF" > "$TMP_CONF"

sudo wg-quick up "$TMP_CONF"

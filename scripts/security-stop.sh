#!/bin/bash

echo "==> Остановка VPN..."
sudo systemctl stop wg-quick@proton

echo "==> Остановка fail2ban..."
sudo systemctl stop fail2ban

echo "==> Остановка ufw..."
sudo systemctl stop ufw

echo "✓ Всё остановлено"

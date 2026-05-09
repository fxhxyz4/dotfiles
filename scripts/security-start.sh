#!/bin/bash

echo "==> Запуск VPN..."
sudo systemctl start wg-quick@proton

echo "==> Запуск файрвола..."
sudo systemctl start ufw
sudo ufw enable

echo "==> Запуск fail2ban..."
sudo systemctl start fail2ban

echo "==> Запуск apparmor..."
sudo systemctl start apparmor

echo "==> Проверка IP..."
curl -s ifconfig.me
echo " — текущий IP"

echo "✓ Всё запущено"

<div align="center">

  # 🌸 dotfiles
 
  [![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)](https://archlinux.org)
  [![Hyprland](https://img.shields.io/badge/Hyprland-58E1FF?style=for-the-badge&logo=hyprland&logoColor=black)](https://hyprland.org)
  [![Wayland](https://img.shields.io/badge/Wayland-FFB86C?style=for-the-badge&logo=wayland&logoColor=black)](https://wayland.freedesktop.org)
  [![License](https://img.shields.io/badge/License-MIT-BD93F9?style=for-the-badge)](./LICENSE.md)
 
  <p><a href="./README.md">【 🇬🇧 Eng 】</a> 【 🇺🇦 Укр 】</p>
  
[![Last README modification](https://img.shields.io/github/last-commit/fxhxyz4/dotfiles?path=README.md&style=for-the-badge&logo=readdotcv&logoColor=ffff&label=Last%20README%20modification&labelColor=0D1117&color=0D1117)](https://github.com/fxhxyz4/dotfiles/commits/main/README.md)

</div>

| |
|:-:|
| ![terminal](./assets/terminal.png)
 
| Code | Spotify |
|:-:|:-:|
| ![code](assets/code.png) | ![spotify](assets/spotify.png)
 
| |
|:-:|
![terminal](assets/terminal-shaders.png)
 
| Code з шейдером | Spotify з шейдером |
|:-:|:-:|
| ![code](assets/code-shaders.png) | ![spotify](assets/spotify-shaders.png)
 
---
 
# Навігація
 
- [Встановлення](#встановлення)
  - [1. Встановлення пакетів](#1-встановлення-пакетів)
  - [2. Встановлення HyDE](#2-встановлення-hyde)
  - [3. Відновлення конфігів](#3-відновлення-конфігів)
  - [Після встановлення](#після-встановлення)
- [Детальний огляд](#детальний-огляд)
  - [Залежності](#залежності)
  - [Hyprland](#hyprland)
  - [Waybar](#waybar)
  - [Rofi](#rofi)
  - [Mako](#mako)
  - [Wlogout](#wlogout)
  - [Термінал](#термінал)
  - [GTK & Qt](#gtk--qt)
  - [Fastfetch](#fastfetch)
> [!IMPORTANT]
> Протестовано лише на **Arch Linux**.
 
---
 
# Встановлення
 
## 1. Встановлення пакетів
 
Клонуй репозиторій і запусти скрипт встановлення пакетів. Він автоматично налаштує Chaotic-AUR, встановить yay та всі пакети з чотирьох списків (pacman, AUR, Flatpak, Snap) та встановлення nodejs & npm для [neofetch-server](./neofetch-server).
 
```bash
git clone https://github.com/fxhxyz4/dotfiles.git ~/dotfiles
cd ~/dotfiles/packages
bash install-packages.sh
```

```bash
sudo pacman -S nodejs npm
node -v
npm -v
```

 
Скрипт встановлює пакети в такому порядку:
- Додає репозиторій **Chaotic-AUR**
- Збирає та встановлює **yay** (AUR хелпер)
- Встановлює всі **pacman** пакети з `packages.txt`
- Встановлює всі **AUR** пакети з `aur.txt`
- Встановлює **Flatpak** застосунки з `flatpak.txt`
- Встановлює **Snap** застосунки з `snap.txt`
> [!NOTE]
> Якщо snap пакети пропущені, спочатку увімкни snapd:
> ```bash
> sudo systemctl enable --now snapd snapd.socket
> sudo ln -s /var/lib/snapd/snap /snap
> # перезавантажся, потім запусти скрипт знову
> ```
 
## 2. Встановлення HyDE
 
HyDE — це DE фреймворк, що керує темами, шпалерами та конфігурацією Hyprland.
 
```bash
git clone https://github.com/HyDE-Project/HyDE.git ~/HyDE
cd ~/HyDE && bash install.sh
```
 
## 3. Відновлення конфігів
 
```bash
cp -r ~/dotfiles/configs/* ~/.config/
cp ~/dotfiles/shell/.zshenv ~/
cp ~/dotfiles/misc/.gitconfig ~/
```
 
Увімкни сервіси:
 
```bash
sudo systemctl enable --now NetworkManager bluetooth sddm tlp ufw docker libvirtd
```
 
Встанови zsh як стандартну оболонку:
 
```bash
chsh -s $(which zsh)
```
 
## Після встановлення
 
- Додай свої шпалери до `~/Pictures/Wallpapers`
- Запусти `p10k configure` для налаштування промпту
- Встанови oh-my-zsh якщо не підтягнувся з конфігів:
  ```bash
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  ```
- Увійди в свої акаунти (VPN, браузери, JetBrains тощо)
- Відновни SSH ключі вручну
---
 
# Детальний огляд
 
## Залежності
 
<details>
<summary><b>Hyprland & DE</b></summary>
  
| Пакет | Опис |
| :--- | :--- |
| `hyprland` | Динамічний тайловий Wayland композитор |
| `hypridle` | Демон керування простоєм |
| `hyprlock` | Екран блокування |
| `hyprpaper` | Демон шпалер |
| `hyprsunset` | Нічний режим |
| `uwsm` | Менеджер Wayland сесій |
| `waybar` | Статусний рядок |
| `wlogout` | Меню виходу |
| `mako` | Демон сповіщень |
| `rofi` | Запускач застосунків |
| `wofi` | Запускач застосунків (альтернатива) |
| `sddm` | Менеджер дисплею |
| `grim` + `slurp` | Інструменти скріншотів |
| `swappy` + `satty` | Анотація скріншотів |
| `wallust` | Генератор кольорових схем |
| `waypaper-git` | GUI менеджер шпалер |
| `hyde-cli-git` | HyDE CLI інструмент |
 
</details>

<details>
<summary><b>Аудіо</b></summary>
  
| Пакет | Опис |
| :--- | :--- |
| `pipewire` + `wireplumber` | Аудіо сервер |
| `pipewire-alsa` + `pipewire-pulse` | Шари сумісності |
| `pamixer` + `pavucontrol` | Керування гучністю |
| `playerctl` | Керування медіаплеєром |
| `mpd` + `ncmpcpp` | Музичний плеєр + TUI клієнт |
| `cava` | Аудіо візуалізатор |
 
</details>

<details>
<summary><b>Розробка</b></summary>
  
| Пакет | Опис |
| :--- | :--- |
| `code` | Visual Studio Code |
| `jetbrains-toolbox` | Менеджер JetBrains IDE |
| `docker` + `docker-compose` | Контейнеризація |
| `github-desktop-bin` | GitHub Desktop |
| `postman-bin` + `insomnia` | API клієнти |
| `dbeaver` + `mysql-workbench` | GUI для баз даних |
| `drawio-desktop-bin` | Діаграми |
| `heidisql` | Клієнт БД (Wine) |
| `mariadb` + `postgresql` | Бази даних |
 
</details>

<details>
<summary><b>Безпека</b></summary>
  
| Пакет | Опис |
| :--- | :--- |
| `ufw` | Фаєрвол |
| `fail2ban` | Захист від перебору |
| `firejail` | Пісочниця для застосунків |
| `clamav` | Антивірус |
| `tor` + `obfs4proxy` | Анонімна мережа |
| `wireshark-qt` | Аналізатор мережі |
| `zaproxy` | Сканер веб безпеки |
 
</details>

<details>
<summary><b>Шрифти</b></summary>
  
| Пакет | Опис |
| :--- | :--- |
| `ttf-jetbrains-mono-nerd` | Основний шрифт терміналу |
| `ttf-cascadia-code-nerd` | Шрифт для коду |
| `ttf-fira-code` | Шрифт з лігатурами |
| `otf-font-awesome` + `woff2-font-awesome` | Іконкові шрифти |
| `noto-fonts` + `noto-fonts-emoji` | Універсальні шрифти |
| `ttf-victor-mono` | Курсивний шрифт для програмування |
 
</details>

---
 
## Hyprland
 
Динамічний тайловий Wayland композитор. [[конфіг](configs/hypr/)]
 
- [[hyprland.conf](configs/hypr/hyprland.conf)] — основний конфіг
- [[keybindings.conf](configs/hypr/keybindings.conf)] — комбінації клавіш
- [[windowrules.conf](configs/hypr/windowrules.conf)] — правила вікон
- [[userprefs.conf](configs/hypr/userprefs.conf)] — особисті налаштування
- [[monitors.conf](configs/hypr/monitors.conf)] — налаштування монітора
- [[hypridle.conf](configs/hypr/hypridle.conf)] — поведінка при простої
- [[hyprlock/](configs/hypr/hyprlock/)] — макети екрану блокування
---
 
## Waybar
 
Статусний рядок. [[конфіг](configs/waybar/)]
 
Кастомні кольори в `theme.css`, особисті стилі в `user-style.css`.
 
```bash
sudo pacman -S waybar
```
 
---
 
## Rofi
 
Запускач застосунків. [[конфіг](configs/rofi/)]
 
```bash
sudo pacman -S rofi
yay -S rofi-power-menu
```
 
---
 
## Mako
 
Демон сповіщень. [[конфіг](configs/mako/)]
 
```bash
sudo pacman -S mako
```
 
---
 
## Wlogout
 
Меню виходу. [[конфіг](configs/wlogout/)]
 
```bash
yay -S wlogout
```
 
---
 
## Термінал
 
**Емулятор** — [Kitty](https://sw.kovidgoyal.net/kitty) [[конфіг](configs/kitty/)]
 
**Оболонка** — [Zsh](https://www.zsh.org/) + [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) [[конфіг](configs/zsh/)]
 
**Промпт** — [Powerlevel10k](https://github.com/romkatv/powerlevel10k) [[конфіг](configs/zsh/.p10k.zsh)]
 
**Альт промпт** — [Starship](https://starship.rs) [[конфіг](configs/starship.toml)]
 
```bash
sudo pacman -S kitty zsh starship
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
 
---
 
## GTK & Qt
 
**GTK тема** — Tokyo Night [[конфіг](configs/gtk-3.0/)]
 
**Іконки** — Tela Circle Dracula
 
**Курсор** — Bibata Modern Ice
 
**Qt** — Kvantum [[qt5ct](configs/qt5ct/)] [[qt6ct](configs/qt6ct/)]
 
```bash
sudo pacman -S nwg-look kvantum kvantum-qt5 qt5ct qt6ct
yay -S bibata-cursor-theme tela-icon-theme tokyonight-gtk-theme-git
```
 
---
 
## Fastfetch
 
Інформація про систему з кастомним аніме логотипом. [[конфіг](configs/fastfetch/)]
 
```bash
sudo pacman -S fastfetch
```
 
---
 
## Подяки
 
- [HyDE Project](https://github.com/HyDE-Project/HyDE) — DE фреймворк
- [Hyprland](https://hyprland.org) — Wayland композитор
- [Tokyo Night](https://github.com/enkia/tokyo-night-vscode-theme) — Кольорова схема
- [retrilzzy/dotfiles](https://github.com/retrilzzy/dotfiles) — Натхнення для README
- [r/unixporn](https://reddit.com/r/unixporn) — Натхнення спільноти
 

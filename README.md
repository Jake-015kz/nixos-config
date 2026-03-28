# ❄️ Jake's Modular NixOS Configuration

Персональная конфигурация **NixOS**, оптимизированная для Frontend-разработки и ноутбука **ASUS TUF**.

---

## 🚀 Основные характеристики

- **OS**: NixOS 25.11 (Xantusia)
- **Ядро**: `linuxPackages_cachyos`
- **DE**: KDE Plasma 6 (Wayland)
- **Shell**: Fish + Starship
- **Терминал**: Ghostty
- **Редактор**: Neovim (LazyVim)

---

## 🛠 Технологический стек

- **Frontend**: Node.js, TypeScript, React, SCSS (BEM)
- **Инструменты**: Docker, Postman, DBeaver
- **LSP**: Prettier, ESLint, Tailwind CSS, Emmet

---

## 💻 Оптимизация ASUS TUF

- **`auto-cpufreq`** — умное управление питанием
- **`amd_pstate=active`** — эффективный профиль Ryzen
- **`LACT`** — контроль AMD GPU и вентиляторов
- **`Zram`** — сжатие RAM для тяжёлых проектов

---

## 📂 Структура репозитория

```text
.dotfiles/
├── hosts/
│   └── jake-pc/       # Конфиг хоста и железо
├── modules/
│   ├── apps/          # Софт (dev, media, cli, internet)
│   ├── desktop/       # KDE / Niri настройки
│   └── system/        # Ядро и performance-твики
└── users/
    └── jake/          # Home Manager (nvim, fish, vscode)
```

---

## ⌨️ Горячие клавиши

- Meta + Return — открыть терминал (Ghostty)
- Meta + Q — закрыть окно
- jk — выход из Insert mode (Neovim)
- Alt + Shift — переключение раскладки (US / RU)

---

## 🚀 Установка

```bash
git clone https://github.com/ваш-логин/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
nh os switch .
```

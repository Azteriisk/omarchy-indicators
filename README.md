# Omarchy Enhanced Indicators (`azterisk.indicators`)

A modular, reactive status indicators widget for the **Omarchy Desktop Shell** top bar (powered by [Quickshell](https://outfoxxed.me/quickshell/)).

---

## ✨ Features

- 󰅶 **Interactive Stay Awake & Idle Hub**: Directly integrates with [`omarchy-idle-manager`](https://github.com/Azteriisk/omarchy-idle-manager) (`azterisk.idle`).
  - **Left-Click**: Instant toggle for Stay Awake mode.
  - **Right-Click**: Interactive popup card to configure screensaver timeouts, lock delays, and Screensaver-Only vs Inhibit-All stay-awake behaviors.
- 🎙️ **Dictation Indicator**: Real-time microphone and speech-to-text status.
- ⏺️ **Screen Recording Indicator**: Visual badge when GPU screen recording or streaming is active.
- ⏰ **Reminders Indicator**: Quick status and counters for scheduled notifications.
- 🌙 **Night Light Indicator**: Fast toggle and state display for blue-light filtering.
- 🔕 **Do Not Disturb (DND)**: Notification suppression indicator.
- ⚙️ **Customizable**: Configurable widget schema allowing selective indicator display or "Always Show" mode.

---

## 📦 Installation

```bash
git clone https://github.com/Azteriisk/omarchy-indicators.git
cd omarchy-indicators
chmod +x install.sh
./install.sh
```

---

## 🔧 Omarchy 4.0.4+ Compatibility

Under Omarchy 4.0.4+, QML property bindings strictly check type conversions. `azterisk.indicators` includes clean boolean-wrapped state bindings (`Boolean(...)`) preventing undefined property warning floods and ensuring rock-solid indicator responsiveness.

---

## 📄 License

MIT © [Azteriisk](https://github.com/Azteriisk)

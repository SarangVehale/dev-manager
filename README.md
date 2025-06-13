# Dev Environment Manager 

:::::::::: ::::    ::: :::     :::      ::::    ::::   ::::::::  ::::    :::  ::::::::  :::::::::: :::::::::
:+:        :+:+:   :+: :+:     :+:      +:+:+: :+:+:+ :+:    :+: :+:+:   :+: :+:    :+: :+:        :+:    :+:
+:+        :+:+:+  +:+ +:+     +:+      +:+ +:+:+ +:+ +:+    +:+ :+:+:+  +:+ +:+        +:+        +:+    +:+
+#++:++#   +#+ +:+ +#+ +#+     +:+      +#+  +:+  +#+ +#+    +:+ +#+ +:+ +#+ :#:        +#++:++#   +#++:++#:
+#+        +#+  +#+#+#  +#+   +#+       +#+       +#+ +#+    +#+ +#+  +#+#+# +#+   +#+# +#+        +#+    +#+
#+#        #+#   #+#+#   #+#+#+#        #+#       #+# #+#    #+# #+#   #+#+# #+#    #+# #+#        #+#    #+#
########## ###    ####     ###          ###       ###  ########  ###    ####  ########  ########## ###    ###

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/yourusername/dev-env-manager)](https://github.com/yourusername/dev-env-manager/issues)
[![GitHub stars](https://img.shields.io/github/stars/yourusername/dev-env-manager)](https://github.com/yourusername/dev-env-manager/stargazers)


Welcome to **Dev Environment Manager**, your all-in-one interactive terminal assistant for bootstrapping and managing development environments with ease — no more hunting around for install commands or juggling tool versions.

---

## ✨ What is This?

Imagine a magical terminal menu that guides you through installing and managing:

- Python 3.11 with Qiskit (quantum computing made simple)  
- `pyenv` and virtualenv management  
- Conda environments for data science pros  
- Rust, Node.js, Go — the polyglot dream  
- Docker containers for smooth deployments  
- Java, .NET, Flutter — cross-platform powerhouses  
- Cloud SDKs: AWS, Azure, Google Cloud  
- DevOps essentials: kubectl, helm, terraform, ansible  
- Build tools like Maven, Gradle, Composer, and CMake

…and more — all curated for Arch, Ubuntu, Fedora, and macOS.

---

## 🚀 Why You’ll Love It

- **One script, many tools** — pick and install what you need via a friendly terminal UI.  
- **Cross-platform support** — runs on your favorite Linux distro or macOS.  
- **Smart dependency checks** — prompts you if something’s missing, so you never get stuck.  
- **Perfect for Qiskit users** — installs Python 3.11 and sets up quantum-ready environments painlessly.  
- **Saves time and frustration** — fewer googling sessions, more coding time.

---

## 🎬 Quick Demo

```

+------------------------------------------+

| Dev Environment Manager Menu                 |
| -------------------------------------------- |
| 1) Install pyenv                             |
| 2) Install Python 3.11.9                     |
| 3) Create pyenv + Qiskit env                 |
| 4) Install Conda                             |
| 5) Create Conda + Qiskit env                 |
| 6) Install Rust (rustup)                     |
| 7) Install Node.js (nvm + LTS)               |
| 8) Install Go                                |
| 9) Install Docker                            |
| 10) Install Java (OpenJDK)                   |
| ...                                          |
| 20) Exit                                     |
| +------------------------------------------+ |

Choose an option by typing the number and hitting Enter.

````

*Just pick, confirm, and watch your system transform.*

---

## ⚙️ Installation & Setup

### 1. Clone the repo

```bash
git clone https://github.com/yourusername/dev-env-manager.git
cd dev-env-manager
````

### 2. Make the script executable

```bash
chmod +x dev_env_manager.sh
```

### 3. Run the script

```bash
./dev_env_manager.sh
```

Follow the interactive menu and choose your tools.

---

## 🔍 Supported Operating Systems

| OS              | Package Manager | Status       |
| --------------- | --------------- | ------------ |
| Arch Linux      | pacman          | Fully tested |
| Ubuntu / Debian | apt             | Fully tested |
| Fedora / RHEL   | dnf             | Fully tested |
| macOS           | Homebrew        | Fully tested |

> *If you use another system, the script will politely ask you to install missing dependencies manually.*

---

## 💡 Pro Tips

> “**Need Python 3.11 with Qiskit?**”
>
> Use options 1, 2, and 3 in the menu to install pyenv, Python 3.11.9, and create a virtualenv pre-loaded with Qiskit — all automatically.

---

## 🛠 How It Works — Under the Hood

* Detects your OS and package manager.
* Checks for essential dependencies like `dialog`, `fzf`, `curl`, and `git`.
* Prompts before installing anything.
* Uses `pyenv` for Python version management (optional Conda alternative).
* Installs language runtimes and tools via native package managers or official install scripts.
* Adds relevant environment variables to your shell config automatically.
* Uses a user-friendly TUI menu (powered by `dialog`) to guide you.

---

## 🧑‍💻 Contribution

Love it? Found a bug? Want to add support for your favorite tool or OS?

Open an issue or submit a pull request — all contributions welcome.

---

## 📜 License

MIT License © 2025 

---

## Final Thought

*"Setting up your dev environment should be fun and effortless, not a headache.
Let this tool be your starting point to a smoother coding journey."*

---

God speed mate !!

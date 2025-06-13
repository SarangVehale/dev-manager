#!/bin/bash

set -e

# ========= Detect OS & Package Manager =========
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/arch-release ]; then
            PKG_MGR="pacman"
        elif [ -f /etc/debian_version ]; then
            PKG_MGR="apt"
        elif [ -f /etc/redhat-release ]; then
            PKG_MGR="dnf"
        else
            PKG_MGR=""
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        PKG_MGR="brew"
    else
        PKG_MGR=""
    fi
}

# ========= Install Dependencies =========
install_if_missing() {
    local cmd=$1
    local pkg=$2
    if ! command -v "$cmd" &>/dev/null; then
        dialog --yesno "$cmd is required but not installed. Install it now?" 8 50
        if [ $? -eq 0 ]; then
            case "$PKG_MGR" in
                pacman) sudo pacman -S --needed --noconfirm "$pkg" ;;
                apt) sudo apt update && sudo apt install -y "$pkg" ;;
                dnf) sudo dnf install -y "$pkg" ;;
                brew) brew install "$pkg" ;;
                *) echo "❌ Unsupported OS. Please install $pkg manually." ; exit 1 ;;
            esac
        else
            echo "❌ Cannot proceed without $cmd. Exiting."
            exit 1
        fi
    fi
}

validate_dependencies() {
    install_if_missing dialog dialog
    install_if_missing fzf fzf
    install_if_missing curl curl
    install_if_missing git git
}

# ========= pyenv Setup =========
install_pyenv() {
    if [ -d "$HOME/.pyenv" ]; then
        dialog --msgbox "pyenv is already installed." 6 40
    else
        curl https://pyenv.run | bash
        echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.bashrc
        echo 'eval "$(pyenv init --path)"' >> ~/.bashrc
        echo 'eval "$(pyenv init -)"' >> ~/.bashrc
        echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
        source ~/.bashrc
    fi
}

load_pyenv() {
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
}

install_python311() {
    load_pyenv
    if pyenv versions | grep -q "3.11.9"; then
        dialog --msgbox "Python 3.11.9 already installed." 6 40
    else
        pyenv install 3.11.9
    fi
}

create_pyenv_env() {
    load_pyenv
    local env_name
    env_name=$(dialog --inputbox "Enter pyenv virtualenv name:" 8 50 3>&1 1>&2 2>&3)
    [[ -z "$env_name" ]] && return
    pyenv virtualenv 3.11.9 "$env_name"
    pyenv activate "$env_name"
    pip install --upgrade pip
    pip install qiskit
    echo "$env_name" > .python-version
    dialog --msgbox "pyenv env '$env_name' with Qiskit created and activated." 6 50
}

delete_pyenv_env() {
    load_pyenv
    local env_name
    env_name=$(pyenv virtualenvs --bare | fzf --prompt="Select pyenv to delete: ")
    [[ -z "$env_name" ]] && return
    pyenv uninstall -f "$env_name"
    dialog --msgbox "Environment '$env_name' deleted." 6 40
}

uninstall_pyenv() {
    dialog --yesno "Uninstall pyenv and all environments?" 7 50
    [ $? -eq 0 ] && {
        rm -rf ~/.pyenv
        sed -i '/pyenv/d' ~/.bashrc
        dialog --msgbox "pyenv removed. Restart your shell." 6 50
    }
}

# ========= Conda =========
install_conda() {
    if command -v conda &>/dev/null; then
        dialog --msgbox "conda is already installed." 6 40
    else
        curl -o miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
        bash miniconda.sh -b -p $HOME/miniconda
        echo 'export PATH="$HOME/miniconda/bin:$PATH"' >> ~/.bashrc
        source ~/.bashrc
    fi
}

create_conda_env() {
    local env_name
    env_name=$(dialog --inputbox "Enter conda env name:" 8 50 3>&1 1>&2 2>&3)
    [[ -z "$env_name" ]] && return
    conda create -y -n "$env_name" python=3.11
    conda activate "$env_name"
    pip install qiskit
    dialog --msgbox "Conda env '$env_name' with Qiskit installed." 6 50
}

# ========= Rust (rustup) =========
install_rust() {
    if command -v rustc &>/dev/null; then
        dialog --msgbox "Rust is already installed." 6 40
    else
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        source $HOME/.cargo/env
    fi
}

# ========= Node.js (nvm) =========
install_nvm() {
    if [ -d "$HOME/.nvm" ]; then
        dialog --msgbox "nvm is already installed." 6 40
    else
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
        echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
        echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc
        source ~/.bashrc
    fi
}

install_node_lts() {
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install --lts
    dialog --msgbox "Latest LTS version of Node.js installed." 6 50
}

# ========= Main Menu =========
main_menu() {
    while true; do
        CHOICE=$(dialog --clear --title "Dev Environment Manager" \
            --menu "Choose an option:" 20 70 12 \
            1 "Install pyenv" \
            2 "Install Python 3.11.9" \
            3 "Create pyenv + Qiskit env" \
            4 "Delete pyenv env" \
            5 "Uninstall pyenv" \
            6 "Install Conda (Miniconda)" \
            7 "Create Conda + Qiskit env" \
            8 "Install Rust (rustup)" \
            9 "Install nvm (Node.js)" \
            10 "Install latest Node.js LTS" \
            11 "Exit" 3>&1 1>&2 2>&3)

        case $CHOICE in
            1) install_pyenv ;;
            2) install_python311 ;;
            3) create_pyenv_env ;;
            4) delete_pyenv_env ;;
            5) uninstall_pyenv ;;
            6) install_conda ;;
            7) create_conda_env ;;
            8) install_rust ;;
            9) install_nvm ;;
            10) install_node_lts ;;
            11) clear; exit 0 ;;
            *) dialog --msgbox "Invalid choice!" 6 40 ;;
        esac
    done
}

# ========= Run Script =========
detect_os
validate_dependencies
main_menu


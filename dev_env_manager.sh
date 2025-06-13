#!/bin/bash
set -e

# ========= Detect OS =========
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
        dialog --yesno "$cmd is missing. Install it now?" 8 50
        if [ $? -eq 0 ]; then
            case "$PKG_MGR" in
                pacman) sudo pacman -S --needed --noconfirm "$pkg" ;;
                apt) sudo apt update && sudo apt install -y "$pkg" ;;
                dnf) sudo dnf install -y "$pkg" ;;
                brew) brew install "$pkg" ;;
                *) echo "Unsupported OS. Please install $pkg manually." ; exit 1 ;;
            esac
        else
            echo "Cannot continue without $cmd"; exit 1
        fi
    fi
}

validate_dependencies() {
    install_if_missing dialog dialog
    install_if_missing fzf fzf
    install_if_missing curl curl
    install_if_missing git git
}

# ========= pyenv =========
install_pyenv() {
    [[ -d "$HOME/.pyenv" ]] && return
    curl https://pyenv.run | bash
    echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(pyenv init --path)"' >> ~/.bashrc
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc
    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
    source ~/.bashrc
}

load_pyenv() {
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
}

install_python311() {
    load_pyenv
    pyenv versions | grep -q 3.11.9 || pyenv install 3.11.9
}

create_pyenv_env() {
    load_pyenv
    name=$(dialog --inputbox "Pyenv venv name:" 8 40 3>&1 1>&2 2>&3)
    pyenv virtualenv 3.11.9 "$name"
    pyenv activate "$name"
    pip install --upgrade pip qiskit
    echo "$name" > .python-version
    dialog --msgbox "Pyenv env '$name' created with Qiskit." 6 50
}

# ========= Conda =========
install_conda() {
    [[ -d "$HOME/miniconda" ]] && return
    curl -o miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    bash miniconda.sh -b -p $HOME/miniconda
    echo 'export PATH="$HOME/miniconda/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc
}

create_conda_env() {
    name=$(dialog --inputbox "Conda env name:" 8 40 3>&1 1>&2 2>&3)
    conda create -y -n "$name" python=3.11
    conda activate "$name"
    pip install qiskit
    dialog --msgbox "Conda env '$name' with Qiskit ready." 6 40
}

# ========= Rust =========
install_rust() {
    command -v rustc &>/dev/null || curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

# ========= Node.js =========
install_nvm() {
    [[ -d "$HOME/.nvm" ]] && return
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc
    source ~/.bashrc
}

install_node_lts() {
    export NVM_DIR="$HOME/.nvm"
    . "$NVM_DIR/nvm.sh"
    nvm install --lts
}

# ========= Go =========
install_go() {
    install_if_missing go go
}

# ========= Docker =========
install_docker() {
    install_if_missing docker docker
    sudo usermod -aG docker $USER
    dialog --msgbox "Docker installed. You may need to relogin." 6 50
}

# ========= Java =========
install_java() {
    install_if_missing java default-jdk
}

# ========= .NET =========
install_dotnet() {
    install_if_missing dotnet-sdk dotnet-sdk
}

# ========= Flutter =========
install_flutter() {
    git clone https://github.com/flutter/flutter.git -b stable ~/flutter
    echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.bashrc
}

# ========= Cloud CLIs =========
install_aws_cli() { curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip && unzip awscliv2.zip && sudo ./aws/install; }
install_azure_cli() { install_if_missing az azure-cli; }
install_gcloud() { curl https://sdk.cloud.google.com | bash; }

# ========= DevOps Tools =========
install_kubectl() { install_if_missing kubectl kubectl; }
install_helm() { install_if_missing helm helm; }
install_terraform() { install_if_missing terraform terraform; }
install_ansible() { install_if_missing ansible ansible; }

# ========= Build Tools =========
install_gradle() { install_if_missing gradle gradle; }
install_maven() { install_if_missing mvn maven; }
install_composer() { install_if_missing composer composer; }
install_cmake() { install_if_missing cmake cmake; }

# ========= Main Menu =========
main_menu() {
    while true; do
        CHOICE=$(dialog --title "Dev Environment Manager" --menu "Choose:" 25 70 20 \
            1 "Install pyenv" \
            2 "Install Python 3.11.9" \
            3 "Create pyenv + Qiskit env" \
            4 "Install Conda (Miniconda)" \
            5 "Create Conda + Qiskit env" \
            6 "Install Rust (rustup)" \
            7 "Install nvm + Node LTS" \
            8 "Install Go (Golang)" \
            9 "Install Docker" \
            10 "Install Java (OpenJDK)" \
            11 "Install .NET SDK" \
            12 "Install Flutter" \
            13 "Install AWS CLI" \
            14 "Install Azure CLI" \
            15 "Install Google Cloud SDK" \
            16 "Install kubectl" \
            17 "Install Helm" \
            18 "Install Terraform" \
            19 "Install Ansible" \
            20 "Exit" 3>&1 1>&2 2>&3)

        case $CHOICE in
            1) install_pyenv ;;
            2) install_python311 ;;
            3) create_pyenv_env ;;
            4) install_conda ;;
            5) create_conda_env ;;
            6) install_rust ;;
            7) install_nvm && install_node_lts ;;
            8) install_go ;;
            9) install_docker ;;
            10) install_java ;;
            11) install_dotnet ;;
            12) install_flutter ;;
            13) install_aws_cli ;;
            14) install_azure_cli ;;
            15) install_gcloud ;;
            16) install_kubectl ;;
            17) install_helm ;;
            18) install_terraform ;;
            19) install_ansible ;;
            20) clear; exit 0 ;;
        esac
    done
}

# ========= Run =========
detect_os
validate_dependencies
main_menu


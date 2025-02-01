#!/bin/bash

# Funktion zur Prüfung, ob Ansible installiert ist
check_ansible() {
    if command -v ansible >/dev/null 2>&1; then
        echo "✅ Ansible ist installiert: $(ansible --version | head -n 1)"
        exit 0
    else
        return 1
    fi
}

#Prüfen auf Updates des Systems

# 1️⃣ Prüfen, ob Ansible installiert ist
if ! check_ansible; then
    echo "⚠️ Ansible ist nicht installiert. Installation wird gestartet..."
    
    # 2️⃣ Betriebssystem erkennen
    if [ -f /etc/debian_version ]; then
        echo "📦 Debian/Ubuntu erkannt. Installiere Ansible..."
        sudo apt update && sudo apt install -y ansible
    elif [ -f /etc/redhat-release ]; then
        echo "📦 RedHat/CentOS erkannt. Installiere Ansible..."
        sudo yum install -y epel-release && sudo yum install -y ansible
    elif [ -f /etc/arch-release ]; then
        echo "📦 Arch Linux erkannt. Installiere Ansible..."
        sudo pacman -Sy --noconfirm ansible
    elif [ "$(uname)" == "Darwin" ]; then
        echo "🍏 macOS erkannt. Installiere Ansible..."
        brew install ansible
    else
        echo "❌ Unbekanntes Betriebssystem! Bitte manuell Ansible installieren."
        exit 1
    fi
fi

# 3️⃣ Erneut prüfen, ob Ansible nun installiert ist
if ! check_ansible; then
    echo "❌ Ansible konnte nicht installiert werden!"
    exit 1
fi


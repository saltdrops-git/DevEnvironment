#!/bin/bash

# Funktion zur Prüfung, ob Ansible installiert ist
check_ansible() {
    if command -v ansible >/dev/null 2>&1; then
        echo "✅ Ansible ist installiert: $(ansible --version | head -n 1)"
    else
        echo "⚠️ Ansible ist nicht installiert. Bitte installiere es mit:"
        echo "   sudo apt install -y ansible  # Debian/Ubuntu"
        echo "   sudo yum install -y ansible  # RedHat/CentOS"
        echo "   sudo pacman -Sy ansible      # Arch Linux"
        echo "   brew install ansible         # macOS"
        exit 1
    fi
}

# Funktion zur Prüfung der wichtigsten Ansible-Umgebungsvariablen
check_ansible_env() {
    echo "🔍 Überprüfe Ansible-Umgebungsvariablen..."

    VARS=("ANSIBLE_LOG_PATH" "ANSIBLE_ROLES_PATH" "ANSIBLE_INVENTORY" "ANSIBLE_VAULT_PASSWORD_FILE" "ANSIBLE_TEMPLATES_PATH" "ANSIBLE_CONFIG")
    for var in "${VARS[@]}"; do
        if [[ -z "${!var}" ]]; then
            echo "⚠️ WARNUNG: Die Variable '$var' ist nicht gesetzt!"
        else
            echo "✅ $var = ${!var}"
        fi
    done
}

# 1️⃣ Prüfen, ob Ansible installiert ist
check_ansible

# 2️⃣ Umgebungsvariablen prüfen
check_ansible_env


#!/bin/bash

# Prüfe, ob git installiert ist
if ! command -v git &>/dev/null; then
    echo "Git ist nicht installiert. Installation wird gestartet..."

    # Prüfe, ob es sich um ein Debian-basiertes System handelt
    if [ -f "/etc/debian_version" ]; then
        echo "Debian-basiertes System erkannt. Installiere git..."
        sudo apt update && sudo apt install -y git

    # Prüfe, ob es sich um ein RedHat-basiertes System handelt
    elif [ -f "/etc/redhat-release" ]; then
        echo "RedHat-basiertes System erkannt. Installiere git..."
        sudo yum install -y git

    else
        echo "Nicht unterstütztes Betriebssystem. Bitte git manuell installieren."
        exit 1
    fi
fi

echo "Git ist installiert: $(git --version)"

# Prüfe, ob das aktuelle Verzeichnis ein Git-Repository ist
if [ -d ".git" ]; then
    echo "Git-Repository erkannt. Führe git status und git pull aus..."
    
    # Zeige den Status des Repos
    git status
    
    # Ziehe die neuesten Änderungen aus dem Remote-Repository
    git pull --rebase
else
    echo "Kein Git-Repository im aktuellen Verzeichnis gefunden."
fi


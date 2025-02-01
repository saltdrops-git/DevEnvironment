#!/bin/bash

# Überprüfen, ob ein Pfad übergeben wurde
if [ -z "$1" ]; then
    echo "❌ Fehler: Der Ansible-Arbeitsordner muss angegeben werden."
    echo "Beispiel: ./03_set_ansible_env.sh /opt/DEV"
    exit 1
else
    # Der übergebene Pfad wird in der Variablen gespeichert
    ANSIBLE_PATH="$1"

    # Überprüfen, ob der Pfad existiert
    if [ ! -d "$ANSIBLE_PATH" ]; then
        echo "❌ Der angegebene Pfad '$ANSIBLE_PATH' existiert nicht. Der Ordner wird nun erstellt..."
        mkdir -p "$ANSIBLE_PATH"  # Erstellt den Pfad, wenn er nicht existiert
    fi

    DIRS=("ansible_log" "roles" "inventory" ".ansible_vault_password" "templates" "")
    # Überprüfen, ob die Unterordner existieren und erstellen, falls nicht
    for dir in "${DIRS[@]}"; do
        if [ ! -d "$ANSIBLE_PATH/$dir" ]; then
            echo "🛠️ Erstelle Ordner '$dir' in '$ANSIBLE_PATH'..."
            mkdir -p "$ANSIBLE_PATH/$dir"
        else
            echo "✅ Ordner '$dir' existiert bereits in '$ANSIBLE_PATH'."
        fi
    done

   # Set ansible Environment neu

   VARS=("ANSIBLE_LOG_PATH" "ANSIBLE_ROLES_PATH" "ANSIBLE_INVENTORY" "ANSIBLE_VAULT_PASSWORD_FILE" "ANSIBLE_TEMPLATES_PATH" "ANSIBLE_CONFIG")

   # Der Pfad zur .bashrc Datei
   BASHRC_FILE="$HOME/.bashrc"

   # Durchlaufen der Variablen und Überprüfen, ob sie in der .bashrc existieren
   for VAR_NAME in "${VARS[@]}"; do
      if grep -q "export $VAR_NAME" "$BASHRC_FILE"; then
          echo "✅ Die Umgebungsvariable '$VAR_NAME' existiert bereits in '$BASHRC_FILE'."

          # Löschen der Zeile, die die Umgebungsvariable setzt
          sed -i "/export $VAR_NAME/d" "$BASHRC_FILE"
          echo "🛠️ Die Umgebungsvariable '$VAR_NAME' wurde aus '$BASHRC_FILE' entfernt."
      else
          echo "❌ Die Umgebungsvariable '$VAR_NAME' wurde nicht in '$BASHRC_FILE' gefunden."
      fi
   done

   for i in {0..5}; do   
   
	   ENV_VAR=${VARS[$i]}
	   ENV_PATH=${DIRS[$i]}
	   
	   if [[ "$ENV_VAR" == "ANSIBLE_LOG_PATH" ]]; then

                   echo "export $ENV_VAR=$ANSIBLE_PATH/$ENV_PATH/ansible.log"  >> ~/.bashrc
	   elif [[ "$ENV_VAR" == "ANSIBLE_CONFIG" ]]; then

                   echo "export $ENV_VAR=$ANSIBLE_PATH/ansible.cfg"  >> ~/.bashrc
           else
		   echo "export $ENV_VAR=$ANSIBLE_PATH/$ENV_PATH"  >> ~/.bashrc
	      
	   
	   fi
   done
   source ~/.bashrc   

   echo "🎉 Ansible Environment wurde neugesetzt"
   echo "🎉 Alle erforderlichen Ordner wurden erstellt oder sind bereits vorhanden!"

./02_ansible_env_check.sh
fi


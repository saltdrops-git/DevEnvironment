#!/bin/bash

# Überprüfen, ob ein Verzeichnis als Argument angegeben wurde
if [ -z "$1" ]; then
  echo "Bitte ein Verzeichnis angeben."
  exit 1
fi

# Pushgateway URL
PUSHGATEWAY_URL="http://localhost:9091/metrics/job/certificates"

# Verzeichnis, in dem nach Zertifikaten gesucht werden soll
CERT_DIR="$1"
current_timestamp=$(date +%s)

# Überprüfen, ob das angegebene Verzeichnis existiert
if [ ! -d "$CERT_DIR" ]; then
  echo "Das angegebene Verzeichnis existiert nicht."
  exit 1
fi

# Durchlaufe alle .crt und .pem Dateien im Verzeichnis
find "$CERT_DIR" -type f \( -iname "*.crt" -o -iname "*.pem" \) | while read cert_file; do
  # Extrahiere das Ablaufdatum des Zertifikats (nur das Datum, keine Uhrzeit)
  expiry_date=$(openssl x509 -enddate -noout -in "$cert_file" 2>/dev/null | sed 's/expire date=//')
  # Formatieren des Ablaufdatums in "YYYYMMDDHHMMSS" (z.B. 20250203)
  check="$(echo "$expiry_date" | cut -d"=" -f1)"
  if [[  "notAfter" == "$check" ]]; then
    expiry_timestamp=$(echo "$expiry_date" | cut -d"=" -f2)
    expiry_timestamp=$(date -d "$expiry_timestamp" +%s)

    # Extrahiere den Dateinamen des Zertifikats (ohne Verzeichnis)
    cert_filename=$(basename "$cert_file")
    
    # Berechne die Differenz in Sekunden
    time_diff=$(($expiry_timestamp - $current_timestamp))
    
    # Berechne die Differenz in Tagen (Sekunden / 86400 = Anzahl der Tage)
    time_diff_days=$((time_diff / 86400))
    
    # Pushe die Metrik an das Pushgateway deaktiviert
    #echo "cert_expiry{filename=\"$cert_filename\"}$time_diff_days" | curl --data-binary @- "$PUSHGATEWAY_URL"
    # Log
    echo "cert_expiry{filename=$cert_filename}$time_diff_days  curl --data-binary @ $PUSHGATEWAY_URL"

    echo "Zertifikat $cert_filename Ablaufdatum: $expiry_date verbleibende Tage: $time_diff_days"
  
    #node_exporter
    ne_path="/opt/DEV/work/custom_metrics.prom"
    echo "# HELP cert_expiry This is a custom metric days till expiry" >> $ne_path
    echo "# TYPE cert_expiry gauge" >> $ne_path
    echo "cert_expiry $time_diff_days" >> $ne_path
    echo "" >> $ne_path
  
  
  fi
done


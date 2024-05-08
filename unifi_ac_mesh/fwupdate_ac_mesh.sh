#!/bin/bash

# Script zum Flashen eines AC Mesh mit Freifunk Firmware
# Freifunk Nordhessen Frank Fischer
# Version 0.1 vom 08.05.2024
# Original Doku unter https://openwrt.org/toh/ubiquiti/unifiac

# Überprüfe, ob die erforderlichen Parameter übergeben wurden
if [[ $# -ne 2 ]]; then
    echo "Verwendung: $0 <IP-Adresse> <firmware.bin>"
    exit 1
fi

# Extrahiere die Parameter
ip_address="$1"
firmware_file="$2"

#commands für ssh definieren
myssh() {
    ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ForwardX11=no -o LogLevel=ERROR "$@"
}

my-ssh-copy-id() {
    ssh-copy-id -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR "$@"
}

myscp() {
    scp -O -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR "$@"
}


# SSH Schlüssel kopieren um sich das eingeben des Passworts zu sparen
my-ssh-copy-id "ubnt@$ip_address"

# Aufheben Schreibschutz Kernel Partitionen /proc/ubnthal/.uf
myssh "ubnt@$ip_address" 'echo 5edfacbf > /proc/ubnthal/.uf'

# Greife auf die PARTNAME-Information  zu
myssh "ubnt@$ip_address" 'cat /proc/mtd'

# Frage: Sind die oberen Partitionen korrekt ausgegeben worden?
read -r -p "Sind die oberen Partitionen korrekt ausgegeben worden SOLL=IST? (Ja/Nein): " answer
if [[ "$answer" != "Ja" ]]; then
    echo "Abbruch."
    exit 1
fi

# Kopiere die Fimrwaredatei nach /tmp/openwrt.bin (-O da ältere Firmwareversion kein sftp beherscht)
myscp "$firmware_file" "ubnt@$ip_address:/tmp/sysupgrade.bin"

# Entpacke und schreibe den Kernel auf kernel0
myssh "ubnt@$ip_address" 'dd if=/tmp/sysupgrade.bin of=/dev/mtdblock2'

# Entpacke und schreibe auf kernel1
myssh "ubnt@$ip_address" 'dd if=/tmp/sysupgrade.bin of=/dev/mtdblock3'

# Boot form kernel0 
myssh "ubnt@$ip_address" 'dd if=/dev/zero bs=1 count=1 of=/dev/mtdblock4'

# Frage: Soll der Host neu gestartet werden?
read -r -p "Möchten Sie den Host neu starten? (Ja/Nein): " restart_answer
if [[ "$restart_answer" == "Ja" ]]; then
    myssh "ubnt@$ip_address" 'reboot'
else
    echo "Abbruch."
    exit 1
fi

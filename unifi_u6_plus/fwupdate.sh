#!/bin/bash

# Script zum Flashen eines U6+ mit Freifunk Firmware
# Freifunk Nordhessen Frank Fischer
# Version 0.1 vom 19.03.2024
# Original Doku unter https://git.openwrt.org/?p=openwrt/openwrt.git;a=commit;h=75ee5546e9b7cfa5bbfd6f844ab8c5fffd5bb594

# Überprüfe, ob die erforderlichen Parameter übergeben wurden
if [[ $# -ne 2 ]]; then
    echo "Verwendung: $0 <IP-Adresse> <firmware.bin>"
    exit 1
fi

# Extrahiere die Parameter
ip_address="$1"
firmware_file="$2"

#Alias für ssh definieren
alias myssh='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ForwardX11=no'
alias my-ssh-copy-id='ssh-copy-id ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" '
alias myscp='scp -O -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'

# SSH Schlüssel kopieren um sich das eingeben des Passworts zu sparen
my-ssh-copy-id "ubnt@$ip_address"

# Aufheben Schreibschutz Kernel Partitionen /proc/ubnthal/.uf
myssh "ubnt@$ip_address" 'echo 5edfacbf > /proc/ubnthal/.uf'

# Greife auf die PARTNAME-Information von mmcblk0p6 zu
partname_mmcblk0p6=$(ssh "ubnt@$ip_address" 'grep PARTNAME /sys/block/mmcblk0/mmcblk0p6/uevent')

# Greife auf die PARTNAME-Information von mmcblk0p7 zu
partname_mmcblk0p7=$(ssh "ubnt@$ip_address" 'grep PARTNAME /sys/block/mmcblk0/mmcblk0p7/uevent')

# Greife auf die PARTNAME-Information von mmcblk0p8 zu
partname_mmcblk0p8=$(ssh "ubnt@$ip_address" 'grep PARTNAME /sys/block/mmcblk0/mmcblk0p8/uevent')

echo "SOLL: PARTNAME=kernel0 IST: " $partname_mmcblk0p6
echo "SOLL: PARTNAME=kernel1 IST: " $partname_mmcblk0p7
echo "SOLL: PARTNAME=bs      IST: " $partname_mmcblk0p8

# Frage: Sind die oberen Partitionen korrekt ausgegeben worden?
read -p "Sind die oberen Partitionen korrekt ausgegeben worden SOLL=IST? (Ja/Nein): " answer
if [[ "$answer" != "Ja" ]]; then
    echo "Abbruch."
    exit 1
fi

# Setze Umgebungsvariablen für das Booten von OpenWrt
myssh "ubnt@$ip_address" 'fw_setenv boot_openwrt "fdt addr \$(fdtcontroladdr); fdt rm /signature; bootubnt"'
myssh "ubnt@$ip_address" 'fw_setenv bootcmd_real "run boot_openwrt"'
myssh "ubnt@$ip_address" 'fw_printenv'

# Kopiere die Fimrwaredatei nach /tmp/openwrt.bin (-O da ältere Firmwareversion kein sftp beherscht)
myscp "$firmware_file" "ubnt@$ip_address:/tmp/openwrt.bin"

# Entpacke und schreibe den Kernel auf mmcblk0p6
myssh "ubnt@$ip_address" 'tar xf /tmp/openwrt.bin sysupgrade-ubnt_unifi-6-plus/kernel -O | dd of=/dev/mmcblk0p6'

# Entpacke und schreibe das Root-Dateisystem auf mmcblk0p7
myssh "ubnt@$ip_address" 'tar xf /tmp/openwrt.bin sysupgrade-ubnt_unifi-6-plus/root -O | dd of=/dev/mmcblk0p7'

# Setze den Wert auf mmcblk0p8
myssh "ubnt@$ip_address" 'echo -ne "\x00\x00\x00\x00\x2b\xe8\x4d\xa3" > /dev/mmcblk0p8'

# Frage: Soll der Host neu gestartet werden?
read -p "Möchten Sie den Host neu starten? (Ja/Nein): " restart_answer
if [[ "$restart_answer" == "Ja" ]]; then
    myssh "ubnt@$ip_address" 'reboot'
else
    echo "Abbruch."
    exit 1
fi

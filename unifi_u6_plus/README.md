# Installiert die Freifunksoftware auf einem UNIFI U6+ AP.

## Vorraussetzungen:

### Linux:
Bash, SSH, SSH Key, ssh-copy-id

Wenn der SSH Key mit einer Passphrase abgesichert ist, empfiehlt sich der Einsatz des ssh-agents, außer man Tippt gerne...
HowTo: https://www.cyberciti.biz/faq/how-to-use-ssh-agent-for-authentication-on-linux-unix/

### Windows:
***Freiwilliger gesucht der daraus ein Powershell Script oder was anderes macht***

### Parameter:
IP Adresse, Firmwarefile

### Firmware [1.4 Freifunk Nordhessen](https://firmware-archiv.freifunk-nordhessen.de/1.4.0/images/sysupgrade/gluon-ff_nh-1.4.0-TYM-ubiquiti-unifi-6-plus-sysupgrade.bin)

## How To:
Ohne DHCP hat der AP die IP Addresse 192.168.1.20/24, Netzwerk des Rechners demenstprechend konfigurieren.
Alternativ den AP ins Netzwerk hängen und die dort zugewiesene IP nutzen.

Aufruf mit *fwupdate.sh IP IMAGE*  Bsp: fwupdate.sh 192.168.1.20 meintollesu6plusimage.bin

Passwort für die Passwortanfrage: *ubnt*

Bitte in der nächsten Abfrage prüfen ob die Partitionnen wie erwartet vorhanden sind.
Dies ist zur Sicherheit da wir nicht wissen ob UNIFI hier nochmal was ändert!

Wenn alles erfolgreich war kann man die letzte Frage mit JA beantworten udn der AP startet die Freifunksoftware.

Jetzt wie in der **DOKU** deiner Community beschrieben den AP konfigurieren.

## Achtung: Aktueller Software-Bug (Stand: 06.09.2024) 

### Auswirkungen

Dieser Bug führt zu einer extrem langsamen Performance, insbesondere bei Downloads.

### Workaround

Um das Problem zu umgehen, setze beide WLAN-Radios in den HT20-Modus. Dadurch sollten Downloads mit bis zu 100 Mbit/s möglich sein.

#### Vorgehen:

1. **Überprüfe die aktuellen Einstellungen:**
   * Verwende den Befehl `uci show wireless | grep wireless.radio`, um die aktuellen Einstellungen Deiner WLAN-Radios anzuzeigen.

2. **Stelle die Radios auf HT20 um:**
   * Führe die folgenden Befehle aus:

     ```
     uci set wireless.radio0.htmode='HT20'
     uci set wireless.radio1.htmode='HT20'
     uci commit
     wifi
     ```

3. **Starte das System neu:**
   * Führe einen Neustart durch, um die Änderungen zu übernehmen.

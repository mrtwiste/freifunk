# Installiert die Freifunksoftware auf einem UNFI U6+ AP.

## Vorraussetzungen:

### Linux:
Bash, SSH, SSH Key, ssh-copy-id

### Windows:
***Freiwilliger gesucht der daraus ein Powershell Script oder was anderes macht***

### Parameter:
IP Adresse, Firmwarefile

### How To:
Ohne DHCP hat der AP die IP Addresse 192.168.1.20/24, Netzwerk des Rechners demenstprechend konfigurieren.
Alternativ den AP ins Netzwerk hängen und die dort zugewiesene IP nutzen.

Aufruf mit *fwupdate.sh IP IMAGE*  Bsp: fwupdate.sh 192.168.1.20 meintollesu6plusimage.bin

Passwort für die Passwortanfrage: *ubnt*

Bitte in der nächsten Abfrage prüfen ob die Partitionnen wie erwartet vorhanden sind.
Dies ist zur Sicherheit da wir nicht wissen ob UNIFI hier nochmal was ändert!

Wenn alles erfolgreich war kann man die letzte Frage mit JA eantworten udn der AP startet die Freifunksoftware.

Jetzt wie in der **DOKU** deiner Community beschrieben den AP konfigurieren.

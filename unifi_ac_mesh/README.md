# Installiert die Freifunksoftware auf einem UNIFI AC Mesh und Co.

## Sollte bei allen APs der AC Serie funtionieren, siehe https://openwrt.org/toh/ubiquiti/unifiac

## Vorraussetzungen:

### Linux:
Bash, SSH, SSH Key, ssh-copy-id

Wenn der SSH Key mit einer Passphrase abgesichert ist, empfiehlt sich der Einsatz des ssh-agents, außer man Tippt gerne...
HowTo: https://www.cyberciti.biz/faq/how-to-use-ssh-agent-for-authentication-on-linux-unix/

### Parameter:
IP Adresse, Firmwarefile

## How To:
Ohne DHCP hat der AP die IP Addresse 192.168.1.20/24, Netzwerk des Rechners demenstprechend konfigurieren.
Alternativ den AP ins Netzwerk hängen und die dort zugewiesene IP nutzen.

Aufruf mit *fwupdate_ac_mesh.sh IP IMAGE*  Bsp: fwupdate.sh 192.168.1.20 meintollesACmage.bin

Passwort für die Passwortanfrage: *ubnt*

Bitte in der nächsten Abfrage prüfen ob die Partitionnen wie erwartet vorhanden sind.
Dies ist zur Sicherheit da wir nicht wissen ob UNIFI hier nochmal was ändert!

Wenn alles erfolgreich war kann man die letzte Frage mit JA beantworten udn der AP startet die Freifunksoftware.

Jetzt wie in der **DOKU** deiner Community beschrieben den AP konfigurieren.

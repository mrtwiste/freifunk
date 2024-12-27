# Installiert die Freifunksoftware auf einem UNIFI U6+ AP

## Vorraussetzungen

### Linux

Bash, SSH, SSH Key, ssh-copy-id

Wenn der SSH Key mit einer Passphrase abgesichert ist, empfiehlt sich der Einsatz des ssh-agents, außer man Tippt gerne...
HowTo: <https://www.cyberciti.biz/faq/how-to-use-ssh-agent-for-authentication-on-linux-unix/>

### ***Wichtig***

Um Probleme mit Bootloader oder SSH zu vermeiden, installiere immer zuerst die aktuellste UniFi Firmware.

Firmware Download:
<https://www.ui.com/download/releases/firmware>

Update via Console
:
Melde dich per SSH auf dem Router an:

Benutzername: **ubnt**

Passwort: **ubnt** (Standard Passwort, falls nicht geändert)

Führe folgenden Befehl aus, um das Update zu installieren:

`upgrade <https://meinefirmwareurl>`

Ersetze <https://meinefirmwareurl> mit der tatsächlichen URL der  Firmware.

## ssh-copy-id auf OpenWrt/UniFi: Problem und Lösung

`ssh-copy-id` kopiert SSH-Schlüssel standardmäßig nach `~/.ssh/authorized_keys`.
Auf OpenWrt/UniFi-Systemen werden diese jedoch oft in `/etc/dropbear/authorized_keys` benötigt.

**Problem:**

`ssh-copy-id` erkennt zwar OpenWrt, prüft aber (versionsabhängig) auch, ob der Benutzer "root" ist.
Auf UniFi-Geräten ist der Standardbenutzer jedoch "ubnt" (mit UID 0), was zu Problemen führt.

**Lösung:**

`ssh-copy-id` muss zusätzlich zur Benutzernamenprüfung auch die UID prüfen.
Ergänze dazu folgende Bedingung in der entsprechenden Zeile in `ssh-copy-id`:

`
[ -f /etc/openwrt_release ] && ([ "\$LOGNAME" = "root" ] || [ "\$(id -u)" = "0" ]) &&`

***Alternativen:***

Eigene Version von ssh-copy-id mit angepasster Prüfung erstellen und im Script auf diese verweisen.

Schlüssel manuell kopieren: scp id_rsa.pub ubnt@<gerät>:/etc/dropbear/authorized_keys

****Hinweise:****

Backup: Vor Modifikation von ssh-copy-id ein Backup erstellen.

Distribution: Die Funktionsweise von ssh-copy-id kann variieren.

**Das Problem wird in einer der nächsten Versionen von ssh-copy-id gefixt sein!**

### Windows

***Freiwilliger gesucht der daraus ein Powershell Script oder was anderes macht***

### Parameter

IP Adresse, Firmwarefile

### Firmware [1.5.0j UST BETA Prerelase for Testing!](https://freifunk.hertel-wolfhagen.de/gluon-builds/v1.5.0j_UST_2/images/sysupgrade/)

## How To

Ohne DHCP hat der AP die IP Addresse 192.168.1.20/24, Netzwerk des Rechners demenstprechend konfigurieren.
Alternativ den AP ins Netzwerk hängen und die dort zugewiesene IP nutzen.

Aufruf mit *fwupdate.sh IP IMAGE*  Bsp: fwupdate.sh 192.168.1.20 meintollesu6plusimage.bin

Passwort für die Passwortanfrage: *ubnt*

Bitte in der nächsten Abfrage prüfen ob die Partitionnen wie erwartet vorhanden sind.
Dies ist zur Sicherheit da wir nicht wissen ob UNIFI hier nochmal was ändert!

Wenn alles erfolgreich war kann man die letzte Frage mit JA beantworten udn der AP startet die Freifunksoftware.

Jetzt wie in der **DOKU** deiner Community beschrieben den AP konfigurieren.

## Achtung

Diese Fimware ist noch recht experimentel aber funktioniert.

Sie kann **nicht** als Update auf einen konfigurierten Freifunkroter installiert werden!
Das System ist danach unbrauchbar!

### Empfohlenes Vorgehen

Gerät mit `firstboot` reseten und dann mit `sysupgrade` das neue Image installieren. 
Dann anmelden und nochmal `firstboot` und `reboot`, warum auch immer...

Danach wie gewohnt die Konfiguration durchführen!
Ob spätere Updates ohne Reset funktionieren können wir jetzt noch nicht sagen!

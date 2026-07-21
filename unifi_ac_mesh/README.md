# Freifunk-Installation auf Ubiquiti UniFi AC-Modellen (z. B. AC Mesh)

Dieses Repository enthält ein Hilfsskript (`fwupdate_ac_mesh.sh`) und eine Anleitung zur Installation der Freifunk-Software (Gluon) auf **Ubiquiti UniFi Access Points der AC-Serie** (z. B. UniFi AC Mesh, AC Lite, AC Pro).

> **Kompatibilität:**  
> Die Anleitung und das Skript sollten mit allen APs der UniFi AC-Serie funktionieren. Eine vollständige Übersicht kompatibler Geräte findest du in der [OpenWrt Table of Hardware](https://openwrt.org/toh/ubiquiti/unifiac).

---

## 📋 Voraussetzungen

### Linux-Umgebung
* Benötigte Werkzeuge: `bash`, `ssh`, `ssh-copy-id`
* **Tipp:** Wenn dein SSH-Schlüssel mit einer Passphrase geschützt ist, empfiehlt sich die Nutzung von `ssh-agent`, um ständiges Tippen zu vermeiden ([HowTo: SSH Agent nutzen](https://www.cyberciti.biz/faq/how-to-use-ssh-agent-for-authentication-on-linux-unix/)).

### Windows-Nutzer
* *Freiwillige gesucht:* Wer Lust hat, ein entsprechendes PowerShell-Skript beizusteuern, ist herzlich eingeladen, einen Pull Request zu öffnen!

---

## 1. Vorbereitung: Aktualisierung der UniFi-Firmware

Um Probleme mit dem Bootloader oder SSH zu vermeiden, installiere vor dem Freifunk-Flashing immer zuerst die **aktuellste originale UniFi-Firmware**.

1. Lade die passende Firmware für dein AC-Modell von der [Ubiquiti Release-Seite](https://www.ui.com/download/releases/firmware) herunter.
2. Verbinde dich per SSH mit dem Access Point:
   ```bash
   ssh ubnt@<IP-ADRESSE>
   ```
   *(Standard-Passwort: `ubnt`)*
3. Führe das Update auf dem Access Point aus:
   ```bash
   upgrade https://meinefirmwareurl.bin
   ```
   *(Ersetze die URL durch den direkten Download-Link der aktuellen Firmware).*

---

## 2. Sonderfall: `ssh-copy-id` auf OpenWrt / UniFi

`ssh-copy-id` kopiert Schlüssel standardmäßig nach `~/.ssh/authorized_keys`. OpenWrt und UniFi-Systeme erwarten diese Datei jedoch unter `/etc/dropbear/authorized_keys`.

### Das Problem
`ssh-copy-id` erkennt zwar OpenWrt, prüft jedoch (je nach Version) zusätzlich, ob der angemeldete Benutzer explizit "root" heißt. Auf UniFi-Geräten lautet der Standardbenutzer jedoch `ubnt` (obwohl er die UID 0 besitzt).

### Die Lösung
Ergänze in deiner lokalen `/usr/bin/ssh-copy-id` die Bedingung zur UID-Prüfung in der entsprechenden Zeile:

```bash
[ -f /etc/openwrt_release ] && ([ "$LOGNAME" = "root" ] || [ "$(id -u)" = "0" ]) &&
```

*Hinweis: In neueren Versionen von `ssh-copy-id` ist dieser Fix bereits integriert. Lege vor Modifikationen lokaler System-Skripte immer ein Backup an.*

**Alternativen ohne Skript-Anpassung:**
* Schlüssel manuell per SCP kopieren:
  ```bash
  scp ~/.ssh/id_rsa.pub ubnt@<IP-ADRESSE>:/etc/dropbear/authorized_keys
  ```

---

## 3. Freifunk-Software installieren (HowTo)

### Netzwerkeinstellungen & IP-Adresse
* **Ohne DHCP:** Der AP nutzt werkseitig die IP-Adresse `192.168.1.20/24`. Konfiguriere die Netzwerkkarteneinstellungen deines Rechners entsprechend (z. B. auf `192.168.1.50`).
* **Mit DHCP:** Hänge den AP alternativ in ein bestehendes Netzwerk mit DHCP-Server und wähle die dort zugewiesene IP-Adresse.

### Flashing-Prozess durchführen

1. **Skript aufrufen:**  
   Aufruf-Syntax: `./fwupdate_ac_mesh.sh <IP-ADRESSE> <FIRMWARE-IMAGE.bin>`

   ```bash
   ./fwupdate_ac_mesh.sh 192.168.1.20 meinACmeshImage.bin
   ```

2. **Authentifizierung & Sicherheitsabfrage:**  
   * Das Passwort für die SSH-Anfrage lautet im Werkszustand: `ubnt`
   * **Wichtig:** Prüfe bei der Sicherheitsabfrage im Terminal aufmerksam, ob die Partitionen wie erwartet angezeigt werden (Schutzmaßnahme, falls Ubiquiti das Partitionslayout bei neueren Revisionen ändert).

3. **Flashen & Geduld:**  
   * Die Schreibvorgänge (`dd`) dauern auf der älteren Hardware-Generation der AC-Serie eine Weile – bitte Ruhe bewahren und den Vorgang nicht unterbrechen!
   * Wenn alles erfolgreich war, bestätige die letzte Frage im Terminal mit **JA**.

4. **Abschluss:**  
   Der AP führt den Neustart durch und startet die Freifunk-Software. Konfiguriere den Knoten nun wie gewohnt über die Weboberfläche (Config-Mode) deiner lokalen Freifunk-Community.

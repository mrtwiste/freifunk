## Zyxel NWA55AXE für Freifunk flashen

Zugriff auf den AP mit Brwoser auf die Standard-IP https://192.168.1.2

-Standalone Mode starten

Login mit Default Credentials ( admin / 1234)

Assistent durchklicken:

Stock-Firmware aktualisieren auf die aktuelle Version um den Bootloader zu aktualisieren.

Danach einen Reboot und dann wieder über die Maintenance Firmware die aktuelle [Freifunk Nordhessen 1.4 Firmware (Factory Image) ](https://firmware-archiv.freifunk-nordhessen.de/1.4.0/images/factory/gluon-ff_nh-1.4.0-TYM-zyxel-nwa55axe.bin)hochladen und installieren.

Während des Uploads versucht die GUI immer wieder den AP zu erreichen. Da aber unser Gluon auf der 192.168.1.1 bootet, läuft diese GUI in die Leere. 
Daher ist es am sinnvollsten, ihr versucht den AP selber anzupingen über die 192.168.1.1.

Sobald ihr diese erreicht, ist das Flashen abgeschlossen und ihr könnten den Gluon-AP entsprechend mit der grafischen Oberfläche auf Eure Bedürfnisse anpassen.

Tips wenn was schief geht:
https://wiki.freifunk-stuttgart.net/anleitungen:zyxel_nwa55axe

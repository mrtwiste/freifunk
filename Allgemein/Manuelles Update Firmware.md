## Manueles Update der Firmware von stable auf experimental

`uci show autoupdater.settings.branch`    --> Zeigt aktuelle Einstallung an!

### Wenn nicht experimental, dann diese Schritte:

`uci set autoupdater.settings.branch='experimental'`

`uci commit autoupdater`

### Wenn auf experimental gesetzt, dann Update 

`autoupdater` 

### Am Ende wieder zurück von experimental auf stable, oder bleiben, wie man möchte....

`uci set autoupdater.settings.branch='stable'`

`uci commit autoupdater`

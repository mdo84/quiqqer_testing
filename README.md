# quiqqer\_testing

Dieses Script erzeugt zwei Dockercontainer für quiqqer.
- ein Container mit PHP5 und Apache2 (2.4)
- ein Container mit Mysql 5.5.x

##Usage
sudo bash quiqqer.sh <OPTION>
- start <GITREPO>     - start the containers mysql & apache2 with quiqqer installed
- build <GITREPO>     - building apache2 container, download quiqqer from repo
- stop\_all\_containers - stopping and deleting ALL containers on the host

##Abhängigkeiten
- bash
- docker
- git

##Zugangsdaten Datenbank
###mysql
- host:    mysqldb
- root-pw: quiqqer
- db:      quiqqer

##Testen der Container
"localhost:8888" im Browser eingeben


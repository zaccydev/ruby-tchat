___________________________________________________________________
FR___________________________________________________________________

Ce projet est la partie back-office d'un tchat programmé en Ruby 2011. 
Il reste sans modification depuis
Le code n'est pas commenté, mais il est fonctionnel.
En raison de l'usage de socket particulier il ne fonctionne que sous Linux.
Exemple d'utilisation simple :
 lancement du serveur de tchat : ./tchatScd.rb
 connection d'un client : ./sockClient.rb -s hello -l client486 &
 interaction avec d'autres clients après connexion : ./sockClient.rb -l client486 -s spkroom -t messageduclient
ou  ./sockClient.rb -l client486 -s spkuser -t messageduclient -d logindestinataire.

Ce tchat reste un projet en cours de développement, il utilise des aspects intéressant de Ruby : les threads, les sockets, la possiblité
de réaliser un fork. Le serveur comprend aussi un processus destiné à supprimer du système les clients (à partir du PID des clients) 
qui ne se sont pas déconnectés avec la commande logoff.

Log du serveur : log/server.log
lancer les tests : ruby test/messdispatch.rb ou ruby test/cli_test.rb, après avoir démarré le serveur.


___________________________________________________________________
EN___________________________________________________________________

This project is the back-office of a tchat written with Ruby on 2011.
It has not been modified since.
Even without comment the code is functional.
Due to the use of Unix socket, it needs to be used with Linux.

Simple usage example :
start the server : ./tchatScd.rb
connecting a client : ./sockClient.rb -s hello -l client486 &
 interact with another client after connection : ./sockClient.rb -l client486 -s spkroom -t clientmessage
 or  ./sockClient.rb -l client486 -s spkuser -t messageduclient -d receiverlogin

This project is not yet complete, but useful aspect of Ruby are shown : thread, socket and ability to do fork.
Server also use a process to suppress clients which are not correctly disconnected (logoff command).

Server log : log/server.log
running tests : ruby test/messdispatch.rb or ruby test/cli_test.rb, while server is running.

#!/bin/bash

apt-get update -y
apt-get upgrade -y

mkdir -p /vagrant/passwords
MYSQL_ROOT_PASSWORD="root"
echo "$MYSQL_ROOT_PASSWORD" > /vagrant/passwords/db_root.txt
MYSQL_USER="utente"
MYSQL_USER_PASSWORD="utente"
apt install mysql-server -y
systemctl start mysql.service
systemctl enable mysql.service
mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY '$MYSQL_ROOT_PASSWORD';
FLUSH PRIVILEGES;
EOF
mysql -u root -p$MYSQL_ROOT_PASSWORD <<EOF
-- Rimuove utenti anonimi e limita root all'accesso locale
DELETE FROM mysql.user WHERE User='';
UPDATE mysql.user SET Host='localhost' WHERE User='root' AND Host!='localhost';

-- Rimuove database di test
DROP DATABASE IF EXISTS test;

-- Crea utente "utente" e database "vagrant"
CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_USER_PASSWORD';
CREATE DATABASE vagrant;
GRANT ALL PRIVILEGES ON vagrant.* TO '$MYSQL_USER'@'%';

-- Creazione della tabella table1 e inserimento di dati di esempio
USE vagrant;
CREATE TABLE table1 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL
);

INSERT INTO table1 (nome) VALUES ('Mario'), ('Luigi'), ('Peach');

-- Applica modifiche
FLUSH PRIVILEGES;
EOF

# Verifica se ci sono errori
if [ $? -ne 0 ]; then
    echo "Si è verificato un errore nella creazione del database o delle tabelle."
else
    echo "Database 'vagrant' creato con successo."
fi

# Permetti connessioni remote cambiando il bind-address
MYSQL_CONFIG_FILE="/etc/mysql/mysql.conf.d/mysqld.cnf"
cp $MYSQL_CONFIG_FILE "$MYSQL_CONFIG_FILE.bak"
sed -i 's/^bind-address\s*=.*/bind-address = 0.0.0.0/' $MYSQL_CONFIG_FILE

# Riavvia il servizio MySQL e permette il traffico MySQL nel firewall
systemctl restart mysql
ufw allow 3306/tcp

# Messaggio di completamento
echo "MySQL configurato con l'utente '$MYSQL_USER' e il database 'vagrant' con la tabella 'table1'."

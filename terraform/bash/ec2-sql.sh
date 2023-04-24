#!/usr/bin/env bash

# If sqlplus is not available, then exit
# exec 3>&1 4>&2
# trap 'exec 2>&4 1>&3' 0 1 2 3
# exec 1>log.out 2>&1
#TODO: add script to install sqlplus here
echo "download packages... "
wget https://download.oracle.com/otn_software/linux/instantclient/1918000/oracle-instantclient19.18-sqlplus-19.18.0.0.0-2.x86_64.rpm
wget https://download.oracle.com/otn_software/linux/instantclient/1918000/oracle-instantclient19.18-basic-19.18.0.0.0-2.x86_64.rpm

# sudo apt-get install alien -y

CURRDIR="$$(pwd)";

cd $(dirname "$${0}");

# Tools and dependencies:
sudo apt-get update -y
sudo apt-get install alien libaio1 rlwrap -y

sudo pwd
sudo cd /
sudo pwd
# Oracle Packages:
echo "Installing instantclient-basic..."
sudo alien -i /oracle-instantclient*-basic*.rpm
echo "Installing instantclient-sqlplus..."
sudo alien -i /oracle-instantclient*-sqlplus*.rpm
echo "Installing instantclient-devel..."
sudo alien -i /oracle-instantclient*-devel*.rpm

# LD config:
echo "Configuring LD path..."
echo /usr/lib/oracle/*/client64/lib \
    | sort -V \
    | tail -n 1 \
    | sudo tee /etc/ld.so.conf.d/oracle.conf \
;
sudo ldconfig

# Readline wrapping:
echo "Configuring readline wrapping..."
echo "WARNING: You need to manually execute this command or re-read /etc/profile"
echo "if you want readline wrapped 'sqlplus' alias to work in current session".
(cat | sudo tee /etc/profile.d/sqlplus_rlwrap.sh) <<!EOF
alias sqlplus="rlwrap -i -f ~/.sqlplus_history -H ~/.sqlplus_history -s 30000 sqlplus64"
!EOF
touch ~/.sqlplus_history

cd "$${CURRDIR}"
echo "SQL Plus installed!!";
echo "This script requires sqlplus to be installed and on your PATH. Exiting"
exit 1


ORACLE_USERNAME=${ORACLE_USERNAME}
echo ${ORACLE_USERNAME}
ORACLE_PASSWORD=${ORACLE_PASSWORD}
ORACLE_HOST=${ORACLE_HOST}
ORACLE_PORT=${ORACLE_PORT}
ORACLE_DATABASE=${ORACLE_DATABASE}

create-table-sql="$(<"create-table.sql")"
# Connect to the database, run the query, then disconnect
echo -e "SET PAGESIZE 0\n SET FEEDBACK OFF\n $${create-table-sql}" | \
sqlplus64 -S -L "$${ORACLE_USERNAME}/$${ORACLE_PASSWORD}@$${ORACLE_HOST}:$${ORACLE_PORT}/$${ORACLE_DATABASE}"



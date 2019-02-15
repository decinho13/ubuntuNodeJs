#!/bin/sh

# sets right password

adduser --system --home /home/${WETTY_USER} --shell /bin/bash ${WETTY_USER}
echo ${WETTY_USER}:${WETTY_HASH} | chpasswd -e

unset WETTY_USER
unset WETTY_HASH

/usr/local/bin/node app.js -p ${WETTY_PORT}

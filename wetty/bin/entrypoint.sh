#!/bin/sh

# sets right password


cd /app
node app.js -p ${WETTY_PORT}
roscore

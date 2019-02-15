Wetty Docker
============

Terminal over HTTP and HTTPS. Wetty is an alternative to
ajaxterm/anyterm but much better than them because wetty uses ChromeOS'
terminal emulator (hterm) which is a full fledged implementation of
terminal emulation written entirely in Javascript. Also it uses
websockets instead of Ajax and hence better response time.

Original version: https://github.com/krishnasrinivas/wetty

hterm source - https://chromium.googlesource.com/apps/libapps/+/master/hterm/

![Wetty](https://github.com/freeeflyer/wetty/raw/master/terminal.png?raw=true)

Dockerized Version
==================

This repo includes a Dockerfile you can use to run a Dockerized version of wetty.  

Just do:

```
    docker run --name term -e WETTY_USER=your_user -e WETTY_HASH='<your hash between simple quotes>' -p 3000:3000 -dt freeflyer/wetty
```

Hash must be between single quotes, if not it will be truncated by special chars
you can generate it like that :
```
    mkpasswd  -m sha-512 -S <your_salt> <<< <yourpass>
```
or simply copy it from your /etc/shadow 

If you don't specify user & hash, the default is term/term.

Visit the appropriate URL in your browser

Compose File
============
The IP is binded on localhost on this example because I recommand using 
this behind a proxy preferably on https..

```python
  wetty:
    image: freeflyer/wetty
    environment:
      - WETTY_USER=your_user
      - WETTY_HASH=<your hash between simple quotes>
    ports:
      - "127.0.0.1:3000:3000"
    networks:
      - front
```

Proxy Setting
=============


If you are running `app.js` as `root` and have a proxy you have to use:

    http://yourserver.com/wetty

Else if you are running `app.js` as a regular user you have to use:

    http://yourserver.com/wetty/ssh/<username>

**Note that if your proxy is configured for HTTPS you should run wetty without SSL.**

traefik
-------
A good solution is to use traefik as a proxy, it integrates nicely with docker

With swarm/docker-compose you should add something like that to your yaml file :

    deploy:
      labels:
        - "traefik.domain=your-hostname"
        - "traefik.backend=wetty"
        - "traefik.enable=true"
        - "traefik.port=3001"
        - "traefik.frontend.entryPoints=https,http"
        - "traefik.frontend.redirect.entryPoint=https"
        - "traefik.frontend.redirect.permanent=true"
        - "traefik.frontend.rule=Host:<your-hostname>"
        - "traefik.docker.network=<your-docker-network-name>"
        
In this example you have a dedicted domain for your wetty frontend, it's https enabled with a redirection http to https.

see https://traefik.io/ for more info.

nginx
-----
***** Not tested *****
Put the following configuration in nginx's conf:

    location /wetty {
	    proxy_pass http://127.0.0.1:3000/wetty;
	    proxy_http_version 1.1;
	    proxy_set_header Upgrade $http_upgrade;
	    proxy_set_header Connection "upgrade";
	    proxy_read_timeout 43200000;

	    proxy_set_header X-Real-IP $remote_addr;
	    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
	    proxy_set_header Host $http_host;
	    proxy_set_header X-NginX-Proxy true;
    }

apache
------

Here is an apache proxy configuration example:

```Apache
ProxyPass /wetty http://127.0.0.1:3000/wetty
ProxyPassReverse /wetty http://127.0.0.1:3000/wetty
<Location /wetty>
    # Auth changes in 2.4 - see http://httpd.apache.org/docs/2.4/upgrading.html#run-time
    AuthUserFile /etc/apache2/xmisspasswd
    AuthType Basic
    AuthName "WTF"
    Require valid-user
</Location>
```

Latest Changes
==============

Now based on node:alpine distribution 


ToDo
====

* Add supervisord or any other watchdog like tool...
* (DREAM) Browser plugin for ssh-key based login..

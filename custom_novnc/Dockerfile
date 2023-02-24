FROM ubuntu:20.04

#<-------------- CONFIGURAZIONE INIZIALE DEL CONTAINER CON NOVNC ------------------------------->

USER root
ENV DEBIAN_FRONTEND noninteractive

#=============
# Set WORKDIR
#=============
WORKDIR /root

#==============================================
# Librerie
#==============================================

RUN apt-get -qqy update && apt-get -qqy install --no-install-recommends \
    xterm \
    git \
    feh \
    fluxbox \
    novnc \
    supervisor \
    x11vnc \
    xvfb \
 && apt clean all \
 && rm -rf /var/lib/apt/lists/*

# Setup environment variables
ENV HOME=/root \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=C.UTF-8 \
    DISPLAY=:0.0 \
    DISPLAY_WIDTH=1600 \
    DISPLAY_HEIGHT=900 \
    DISPLAY_DEPTH=24+32 \
	RUN_TERMINAl=yes \
    RUN_FLUXBOX=yes

### Non-root user

RUN \
    chmod 664 /etc/passwd /etc/group \
    && echo "user:x:1001:0:Default:/:/bin/bash" >> /etc/passwd \
    && adduser user sudo \
    && echo "user:owl" | chpasswd
 
#<-------------------- CONFIGURAZIONE DI AVVIO ---------------------->

#=======================================
#Supervisord e file di configurazione
#=======================================

COPY ./app /app
RUN chmod -R +x /app
ENTRYPOINT [ "/app/entrypoint.sh" ]

COPY fluxbox_conf /root/.fluxbox
RUN chmod -R +x /root/.fluxbox

COPY ./index.html /usr/share/novnc/index.html
RUN chmod -R +x /usr/share/novnc/index.html

EXPOSE 7900

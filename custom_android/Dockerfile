FROM appium/appium:v1.22.3-p6

#<-------------- CONFIGURAZIONE INIZIALE DEL CONTAINER CON NOVNC ------------------------------->

USER root
ENV DEBIAN_FRONTEND noninteractive

#=============
# Set WORKDIR
#=============
WORKDIR /root

# Install git, supervisor, VNC, & X11 packages
RUN set -ex; \
    apt-get update; \
    apt-get install -y \
      xterm \
      fluxbox \
      git \
      net-tools \
      novnc \
      supervisor \
      x11vnc \
      xvfb \
   && apt clean all \
   && rm -rf /var/lib/apt/lists/*

# Setup demo environment variables
ENV HOME=/root \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=C.UTF-8 \
    DISPLAY=:0.0 \
    DISPLAY_WIDTH=1024 \
    DISPLAY_HEIGHT=768 \
	RUN_TERMINAl=no \
    RUN_FLUXBOX=yes

### Non-root user

RUN \
    chmod 664 /etc/passwd /etc/group \
    && echo "user:x:1001:0:Default:/:/bin/bash" >> /etc/passwd \
    && adduser user sudo \
    && echo "user:owl" | chpasswd


#<---------------------- CONFIGURAZIONE DI ANDROID ------------------------->

#======================
# Install SDK packages || MODIFICA QUI LE IMPOSTAZIONI DEL DEVICE
#======================
ARG ANDROID_VERSION=11
ARG API_LEVEL=30
ARG PROCESSOR=x86
ARG SYS_IMG=x86
ARG IMG_TYPE=google_apis
ARG BROWSER=chrome
ARG CHROME_DRIVER=93.0.4577.63
ARG GOOGLE_PLAY_SERVICE=21.0.0
ARG GOOGLE_PLAY_STORE=26.9.22
ARG APP_RELEASE_VERSION=1.5-p0
ENV ANDROID_VERSION=$ANDROID_VERSION \
    API_LEVEL=$API_LEVEL \
    PROCESSOR=$PROCESSOR \
    SYS_IMG=$SYS_IMG \
    IMG_TYPE=$IMG_TYPE \
    BROWSER=$BROWSER \
    CHROME_DRIVER=$CHROME_DRIVER \
    GOOGLE_PLAY_SERVICE=$GOOGLE_PLAY_SERVICE \
    GOOGLE_PLAY_STORE=$GOOGLE_PLAY_STORE \
    GA=true \
    GA_ENDPOINT=https://www.google-analytics.com/collect \
    GA_TRACKING_ID=UA-133466903-1 \
    GA_API_VERSION="1" \
    APP_RELEASE_VERSION=$APP_RELEASE_VERSION \
    APP_TYPE=Emulator
ENV PATH ${PATH}:${ANDROID_HOME}/build-tools

RUN yes | sdkmanager --licenses && \
    sdkmanager "platforms;android-${API_LEVEL}" "system-images;android-${API_LEVEL};${IMG_TYPE};${SYS_IMG}" "emulator"

#==============================================
# Download proper version of chromedriver
# to be able to use Chrome browser in emulator
#==============================================
RUN wget -nv -O chrome.zip "https://chromedriver.storage.googleapis.com/${CHROME_DRIVER}/chromedriver_linux64.zip" \
 && unzip -x chrome.zip \
 && rm chrome.zip
 
#==============================================
# Librerie aggiuntive per android
#==============================================

RUN set -ex; \
    apt-get update; \
    apt-get install -y \
      socat \
   && apt clean all \
   && rm -rf /var/lib/apt/lists/*
   
#======================
# Add Emulator Devices
#======================
COPY devices ${ANDROID_HOME}/devices
 
#<-------------------- CONFIGURAZIONE DI AVVIO ---------------------->

#===================
#Supervisord e file di configurazione
#===================

COPY ./app /app
ENTRYPOINT [ "/app/entrypoint.sh" ]
	
EXPOSE 4723 6080 5554 5555

#===================
# Run docker-appium
#===================

COPY ./src /root/src

HEALTHCHECK --interval=2s --timeout=40s --retries=1 \
    CMD timeout 40 adb wait-for-device shell 'while [[ -z $(getprop sys.boot_completed) ]]; do sleep 1; done'

RUN ln -s ${ANDROID_HOME}/emulator/emulator /usr/bin/

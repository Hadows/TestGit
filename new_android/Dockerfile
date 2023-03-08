FROM custom/appium:latest

#<-------------- CONFIGURAZIONE INIZIALE DEL CONTAINER CON NOVNC ------------------------------->

USER root
ENV DEBIAN_FRONTEND noninteractive

#=============
# Set WORKDIR
#=============
WORKDIR /root

#==============================================
# Librerie aggiuntive per android
#==============================================

RUN apt-get -qqy update && apt-get -qqy install --no-install-recommends \
    xterm \
    feh \
    fluxbox \
    net-tools \
    novnc \
    supervisor \
    x11vnc \
    xvfb \
	socat \
    python-numpy \
    net-tools \
    ffmpeg \
    jq \
    qemu-kvm \
    libvirt-bin \
    ubuntu-vm-builder \
    bridge-utils \
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
	RUN_TERMINAl=no \
    RUN_FLUXBOX=yes

### Non-root user

RUN \
    chmod 664 /etc/passwd /etc/group \
    && echo "user:x:1001:0:Default:/:/bin/bash" >> /etc/passwd \
    && adduser user sudo \
    && echo "user:owl" | chpasswd


#<---------------------- CONFIGURAZIONE DI ANDROID ------------------------->

#110.0.5481.77
#======================
# Install SDK packages || MODIFICA QUI LE IMPOSTAZIONI DEL DEVICE
#======================
ARG ANDROID_VERSION=13.0
ARG API_LEVEL=33
ARG PROCESSOR=x86_64
ARG SYS_IMG=x86_64
ARG IMG_TYPE=google_apis_playstore
ARG BROWSER=chrome
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

#==============================================
# Emulatore Android
#==============================================

RUN yes | sdkmanager --licenses && \
    sdkmanager "platforms;android-${API_LEVEL}" "system-images;android-${API_LEVEL};${IMG_TYPE};${SYS_IMG}" "emulator"


ARG CHROME_DRIVER=110.0.5481.77
#ARG CHROME_VERSION=91.0.4472.114

#==============================================
# Download proper version of chromedriver
# to be able to use Chrome browser in emulator
#==============================================
RUN wget -nv -O chrome.zip "https://chromedriver.storage.googleapis.com/110.0.5481.77/chromedriver_linux64.zip" \
 && unzip -x chrome.zip \
 && rm chrome.zip

#================================================================
# Download Google Play Services APK and Play Store from apklinker
#================================================================
Run wget -nv -O google_play_services.apk "https://www.apklinker.com/wp-content/uploads/uploaded_apk/5b5155e5ef4f8/com.google.android.gms_${GOOGLE_PLAY_SERVICE}-020700-204998136_12874013_MinAPI21_(x86)(nodpi)_apklinker.com.apk"
Run wget -nv -O google_play_store.apk "https://www.apklinker.com/wp-content/uploads/uploaded_apk/5b632b1164e31/com.android.vending_${GOOGLE_PLAY_STORE}-all-0-PR-206665793_81105000_MinAPI16_(armeabi,armeabi-v7a,mips,mips64,x86,x86_64)(240,320,480dpi)_apklinker.com.apk"
#Run wget -nv -O google_chrome.apk "https://www.apklinker.com/wp-content/uploads/uploaded_apk/63ec79cc742b3/com.android.chrome_${CHROME_VERSION}_548106523_MinAPI24_(arm64-v8a,armeabi-v7a)(nodpi)_apklinker.com.apk"

#======================
# Add Emulator Devices
#======================
COPY devices ${ANDROID_HOME}/devices
 
#<-------------------- CONFIGURAZIONE DI AVVIO ---------------------->

#===================
#Supervisord e file di configurazione
#===================

COPY ./app /app
RUN chmod -R +x /app
ENTRYPOINT [ "/app/entrypoint.sh" ]

COPY fluxbox_conf /root/.fluxbox
RUN chmod -R +x /root/.fluxbox

COPY ./app/index.html /usr/share/novnc/index.html
RUN chmod -R +x /usr/share/novnc/index.html

#COPY ./google_chrome.apk /root/google_chrome.apk
#RUN chmod -R +x /root/google_chrome.apk

EXPOSE 4723 6080 5554 5555

#===================
# Run docker-appium
#===================

COPY ./src /root/src
RUN chmod -R +x /root/src

#HEALTHCHECK --interval=2s --timeout=40s --retries=1 \
#CMD timeout 40 adb wait-for-device shell 'while [[ -z $(getprop sys.boot_completed) ]]; do sleep 1; done'

RUN ln -s ${ANDROID_HOME}/emulator/emulator /usr/bin/

#======================
# Workarounds
#======================
ENV QTWEBENGINE_DISABLE_SANDBOX=1 \
    VIDEO_PATH=/video

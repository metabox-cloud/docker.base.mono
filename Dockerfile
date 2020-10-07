#metaBox Mono Base Install
# Lightweight Linux Node base
FROM alpine:latest
LABEL maintainer="metaBox <contact@metabox.cloud>"
LABEL build_version=="metaBox - Mono Base - v: 1.0"

#ENV Variables
ENV MEDIAINFO_VERSION='0.7.94'
ENV LANG=C.UTF-8

# InstalL s6 overlay
RUN wget https://github.com/just-containers/s6-overlay/releases/download/v1.21.4.0/s6-overlay-amd64.tar.gz -O s6-overlay.tar.gz && \
    tar xfv s6-overlay.tar.gz -C / && \
    rm -r s6-overlay.tar.gz

#Add Dependancies.
RUN \
    apk add --no-cache \
        sqlite-libs \
        libstdc++ &&\
    apk add --no-cache \
        --virtual=build-dependencies \
        ca-certificates \
        curl \
        g++ \
        gcc \
        git \
        make \
        tar \
        xz \
		htop \
		iftop \
		p7zip \
		unrar \
        zlib-dev
	
##Install Mono
RUN apk add --no-cache mono --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing
	
##Install Mediainfo
RUN \	
    curl -o \
        /tmp/mediainfo.src.tar.xz -L \
        https://mediaarea.net/download/binary/libmediainfo0/${MEDIAINFO_VERSION}/MediaInfo_DLL_${MEDIAINFO_VERSION}_GNU_FromSource.tar.xz &&\
    tar -xJf /tmp/mediainfo.src.tar.xz \
        -C /tmp &&\
    cd /tmp/MediaInfo_DLL_GNU_FromSource &&\
    ./SO_Compile.sh &&\
    cd /tmp/MediaInfo_DLL_GNU_FromSource/MediaInfoLib/Project/GNU/Library &&\
    make install &&\
    cd /tmp/MediaInfo_DLL_GNU_FromSource/ZenLib/Project/GNU/Library &&\
    make install

#Do Cleanup
RUN \
 apk del --purge \
    make \
    g++ \
    gcc \
    git \
    sqlite \
	build-dependencies
RUN \
  rm -rf \
    /root/.cache \
    /tmp/* 


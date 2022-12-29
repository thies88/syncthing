#Build stage
FROM 1-base-alpine:3.17 as buildstage

# build variables
ARG SYNCTHING_RELEASE

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache \
	--repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
	--repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
	curl \
	g++ \
	gcc \
	git \
	go \
	tar

RUN \
echo "**** fetch source code ****" && \
 if [ -z ${SYNCTHING_RELEASE+x} ]; then \
	SYNCTHING_RELEASE=$(curl -sX GET "https://api.github.com/repos/syncthing/syncthing/releases/latest" \
	| awk '/tag_name/{print $4;exit}' FS='[""]'); \
 fi && \
 mkdir -p \
	/tmp/sync && \
 curl -o \
 /tmp/syncthing-src.tar.gz -L \
	"https://github.com/syncthing/syncthing/archive/${SYNCTHING_RELEASE}.tar.gz" && \
 tar xf \
 /tmp/syncthing-src.tar.gz -C \
	/tmp/sync --strip-components=1 && \
 echo "**** compile syncthing  ****" && \
 cd /tmp/sync && \
 go clean -modcache && \
 CGO_ENABLED=0 go run build.go \
	-no-upgrade \
	-version=${SYNCTHING_RELEASE} \
	build syncthing

# Runtime stage
FROM 1-base-alpine:3.17

ARG BUILD_DATE
ARG VERSION
LABEL build_version="version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="Thies88"

#Define Application variables
ENV APP=""
ENV APP_DEPS=""
ENV APP_DEBUGMODE=0
#App path close with an / example: /usr/bin/
ENV APP_PATH=""
ENV APP_LOG=""
# environment settings
ENV HOME="/config"

#Start app with parameters
ENV APP1="syncthing -home=/config -no-browser -no-restart --gui-address=0.0.0.0:8384"

RUN \
 echo "**** create var lib folder ****" && \
 install -d -o abc -g abc \
	/var/lib/syncthing
 	
# copy files from build stage and local files
COPY --from=buildstage /tmp/sync/syncthing /usr/bin/
COPY root/ /

# ports and volumes
EXPOSE 8384 22000 21027/UDP
VOLUME /config

# Syncthing

Image based on Alpine Linux and monitored by s6-overlay.

#### weekly builds ####
* Rebuilds new base image from scratch:
Ubuntu: @https://partner-images.canonical.com/core/${REL}/current/ubuntu-${REL}-core-cloudimg-${ARCH}-root.tar.gz
Alpine: @http://nl.alpinelinux.org/alpine
  * Base OS is updated
  * Packages are updated
  * Application within image(container) gets updated if new release is available. 
  * Don't manual update Application within container unless you know what you're 		doing.
  * Application settings are restored if mapped correctly to a host folder, your /config folder and settings will be preserved

### docker setup

```
docker create \
  --name=syncthing \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/Amsterdam \
  -p 8384:8384 \
  -p 21027:21027 `#optional` \
  -p 22000:22000 `#optional` \
  -v /path/to/config:/config \
  -v /path/to/syncfolder:/syncfolder `#optional` \
  --restart unless-stopped \
  thies88/syncthing
```
Go to https://ipdockerhost:8384

### update your container:

Via Docker Run/Create

    -Update the image: docker pull thies88/containername
    -Stop the running container: docker stop containername
    -Delete the container: docker rm containername
    -Recreate a new container with the same docker create parameters used at the setup of the container (if mapped correctly to a host folder, your /config folder and settings will be preserved)
    -Start the new container: docker start containername
    -You can also remove the old dangling images: docker image prune

Unraid users can use "Check for updates" within Unraid WebGui
# test1
# test1

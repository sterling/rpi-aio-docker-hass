# rpi-aio-docker-hass
All-in-one docker image for Home Assistant on a Raspberry Pi

Supports:
- v0.48.1+
  - zwave
  - hdmi cec
  - nmap scanner
  - ssh device tracker
  - wake on lan
  - curl
  - mysql recorder (requires separate mysql server)

### Usage

```bash
# home assistant
docker run -d --name=home-assistant --net=host --rm \
  --device=/dev/vchiq:/dev/vchiq --device=/dev/zwave:/dev/zwave \
  -v ~/hass-config:/config -v /etc/localtime:/etc/localtime:ro -v ~/.ssh:/ssh \
  sterlingw/pi3-home-assistant:v0.48.1
```

```bash
# mysql
docker run -d --name=mysql -p 3306:3306 --rm \
  -e MYSQL_ALLOW_EMPTY_PASSWORD=yes -e MYSQL_DATABASE=homeassistant -e MYSQL_USER=hass -e MYSQL_PASSWORD=hass \
  -v ~/hass-config/db:/var/lib/mysql \
  hypriot/rpi-mysql
```
